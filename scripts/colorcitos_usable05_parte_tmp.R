#################################################
# parametros dependientes de los datos
n_canales = length(kanales$Etiqueta)
ventana   = dur_epoca*fr_muestreo

#################################################
# procesamiento parametros opcionales (ajuste)
if(unidad_par_t =='tiempo'){
  ini_t   = ajuste_ini_hms[1]*60*60+
    ajuste_ini_hms[2]*60+
    ajuste_ini_hms[3]
  ini_epo = ini_t/dur_epoca
  ini_pt  = floor(ini_t*fr_muestreo)
}
if(unidad_par_t =='puntos'){
  ini_epo = ajuste_ini_epo
  ini_t   = ini_epo*dur_epoca
  ini_pt  = ini_epo*ventana
}
str_t   = 0
str_epo = 1
str_pt  = 1

min_e = 1

#################################################
# optimizacion: lee el tamano de los datos el contenedor
setwd(dir_res_mid)
ch            = 1
ch_actual     = kanales$Nombre_archivo[ch]
nom_arch      = paste0('EST_',nombre,'_',ch_actual,
                       '_T_',toString(dur_epoca),'.txt')
pv_t          = scan(nom_arch)
pv_t          = as.numeric(t(pv_t))

factor_escala = dur_epoca/30
n_epocas      = length(pv_t)
max_e         = n_epocas

#################################################
# minimo
#if(zoom){
#  mini = hms2t(min_hms)/dur_epoca + 1
#  maxi = hms2t(max_hms)/dur_epoca
#}else{
#  mini = 1
#  maxi = max_e
#}
#zum  = mini:maxi
#l_z  = length(zum)

#################################################
# contenedores de los datos
RES_T   = matrix(0,nrow=n_canales,ncol=n_epocas)
RES_TIR = matrix(0,nrow=n_canales,ncol=n_epocas)

#################################################
# inicio ciclo que recorre todos los canales
for(ch in 1:n_canales){
  # cargar los datos
  ch_actual = kanales$Nombre_archivo[ch]
  nom_arch  = paste0('EST_',nombre,'_',ch_actual,
                     '_T_'  ,toString(dur_epoca),'.txt')
  pv_t      = scan(nom_arch)
  pv_t      = as.numeric(t(pv_t))
  
  nom_arch  = paste0('EST_',nombre,'_',ch_actual,
                     '_TIR_',toString(dur_epoca),'.txt')
  pv_tir    = scan(nom_arch)
  pv_tir    = as.numeric(t(pv_tir))
  
  mmm1 = min(n_epocas,length(pv_t))
  mmm2 = min(n_epocas,length(pv_tir))
  
  # organizacion de los datos en una matriz
  RES_T[ch,1:mmm1]   = pv_t[1:mmm1]
  RES_TIR[ch,1:mmm2] = pv_tir[1:mmm2]
}
# fin ciclo que recorre canales
#################################################

# pedazo final de la prueba de PSR
if(binario){
  if(FALSE){
    n_pvals = length(p.vales)
    M_RES   = matrix(0,nrow=n_canales,ncol=n_epocas)
    for(i in 1:n_pvals){
      M_RES = M_RES + 1*( RES_T>p.vales[i])
    }
    RES_T   = (M_RES/length(p.vales))**3
  }else{
    M_RES1 = 1*( RES_TIR<.05 )
    M_RES2 = 1*( RES_T  <.05 )
    M_RES = pmin(M_RES1,M_RES2)
    RES_T = (-M_RES+1)*1
    #RES_T = (-M_RES+1)*.95 + .025
  }
  
}

RES_T     = rbind(RES_T,1:n_epocas)
zum_l     = is.element(RES_T[n.canales+1,],zum)
RES.chico = t(RES_T[,zum_l])

RES.chico = as.data.frame(RES.chico)
colnames(RES.chico) = c(kanales$Etiqueta,'Indice')

#################################################
# preparacion de los datos
otro_factor = dur_epoca/(30*(2**-5))
indize     = ((1:n_epocas)-1)*otro_factor

RES.grande = c()
for(i in (1:otro_factor)){
  RES.grande = cbind(RES.grande,rbind(RES_T,indize+i))
}
RES.grande = t(RES.grande)
#RES.grande = RES.grande[,sort(RES.grande[n.canales+1,])]

#################################################
# epocas de suenno MOR
ar_indice = read_excel(paste0(info_dir,'/info_tecnico.xlsx'),
                       sheet='EpocasTesis')
indice    = ar_indice[,etiqueta]
indice    = as.numeric(unlist(indice))
indice    = indice[!is.na(indice)]

if(fr_muestreo==200){
  indixe = ceiling(indice/3)
  indixe = unique(indixe)
  indixe = sort(indixe)
  indice = indixe
}

indixe = c()
for(k in 1:32){
  indixe = c(indixe,indice*32-k+1)
}
indixe = unique(indixe)
indixe = sort(indixe)
indice = indixe

RES.grande = as.data.frame(RES.grande)
colnames(RES.grande) = c(kanales$Etiqueta,'Indice')

RES.grande = RES.grande[,1:23]

mores = is.element(as.numeric(RES.grande$Indice),indice)
RES.grande[mores,1:n.canales] = RES.grande[mores,1:n.canales]+2

#RES.extenso = melt(RES.chico,id.vars=c('Indice'))
RES.extenso = melt(RES.grande,id.vars=c('Indice'))

colnames(RES.extenso) = c('Indice','Canal_var','Estacionario')

#################################################
# inicia grafico
RES.extenso$Estacionario[is.na(RES.extenso$Estacionario)] = 0
RES.extenso$Estacionario = factor(RES.extenso$Estacionario,
                                  labels=c('Non-stationary',
                                           'Stationary',
                                           'REM',
                                           'REM2'))
#RES.extenso$Estacionario = factor(RES.extenso$Estacionario,
#                                  labels=c('Non-stationary',
#                                           'Stationary'))
RES.extenso$Indice = (RES.extenso$Indice-1)*(30/(2**5))
RES.extenso$Indice = as.POSIXct(as.hms(RES.extenso$Indice))

RES.extenso$D_chunk = rep(dur_epoca,length(RES.extenso$Indice))
RES.collect         = rbind(RES.collect,RES.extenso)

if(FALSE){
  #res.respaldo = RES.extenso
  RES.extenso = res.respaldo
}

print(
  ggplot(RES.extenso,aes(x=Indice,y=Canal_var,fill=Estacionario)) +
    geom_raster() +
    xlab('Time [hh:mm]') + ylab(NULL) +
    theme_bw() +
    #scale_x_discrete(expand=c(0,0)) +
    #scale_x_datetime(expand=c(0,0),labels=date_format("%H:%M:%S"),
    #                 breaks = date_breaks("20 min"))+
    scale_x_datetime(expand=c(0,0),labels=date_format("%H:%M"),
                     breaks = date_breaks("3 min"))+
    scale_y_discrete(expand=c(0,0),
                     limits=rev(levels(RES.extenso$Canal_var))) +
    scale_fill_manual(values=c('white','black','#acff81','#077813'))+
    #labs(title=paste('Época =',toString(dur_epoca),'s'),
    #     subtitle=paste('Participante:',etiqueta,'| Grupo:',grupo)) +
    labs(title=paste('Subject:',etiqueta)) +
    #theme(legend.position=c(1,1),legend.direction = 'horizontal',
    #      legend.justification=c(1,0))+
    
    theme(legend.position='top') +
    
    theme(legend.title=element_blank()) +
    theme(legend.key = element_rect(color='black',size=1))+
    #theme(axis.text.y = element_text(colour="grey20",size=10))+
    theme(legend.text=element_text(size=13)) +
    rotate_x_text(angle = 45)
)

if(FALSE){
  ggsave(filename=paste0('parte2.png'),
         device='png',dpi=400,width=15,height=7,unit='cm',
         scale=1.5)
}

#ggsave(filename=paste0('zoom_no',etiqueta,'.png'),
#       device='png',dpi=600,width=6,height=4,unit='in',
#       path=dir_graf)

# fin grafico
#################################################