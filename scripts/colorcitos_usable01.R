###############################################################################
# PARCHE : volver a la carpeta central
dir_actual  = getwd()

frecuenciasss = c(200,
                  512,512,
                  200,
                  200,#segun valeria GUR=200 Hz
                  #512, #segun la libreta GURM=512
                  512,512,
                  200,#solo tiene 3 horas
                  512,
                  512,512,
                  200)

###############################################################################
# FACILITADOR : nombres y directorios de los sujetos que analizo
v.nombres    = c('VCNNS1',
                 'MJNNVIGILOS',
                 'JANASUE',
                 'GH24031950SUEÑO',
                 'GURM251148SUE',
                 'CLMN10SUE',
                 'RLMN10SUE',
                 'RRMNS',
                 'JGMN6SUE',
                 'FGHSUE',
                 'MGNA5SUE',
                 'EMNNS')
v.etiqueta   = c('VCR',
                 'MJH',
                 'JAE',
                 'GHA',
                 'MFGR',
                 'CLO',
                 'RLO',
                 'RRU',
                 'JGZ',
                 'FGH',
                 'MGG',
                 'EMT')
v.directorio = c('VCNNS',
                 'MJNNVIGILOScCanal',
                 'JANASUE_revisado',
                 'GH',
                 'GURM_revisado',
                 'CLMN10SUE',
                 'RLMN',
                 'RRMNS_2',
                 'JGMN6SUE',
                 'FGH_EEGdescompuesto',
                 'MGNA',
                 'EMNN')

###############################################################################
# parametros del script, ver documantacion para mas informacion
#sujeto = 6
nombre      = v.nombres[sujeto]
etiqueta    = v.etiqueta[sujeto]
#dir_res_mid  = paste0(getwd(),'/estacionariedad_10s/',v.directorio[sujeto])
dir_res_mid  = paste0('C:/Users/EQUIPO 1/Desktop/julio/estacionariedad_promedio/',
                      v.directorio[sujeto])
dir_graf     = paste0(getwd(),'/graficos_sinfiltro')
#fr_muestreo  = 512
fr_muestreo  = frecuenciasss[sujeto]
dur_epoca    = 30

grabar      = T
anotaciones = ''

reemplazar  = TRUE
canales      = 'PSG'
#canales     = c('C3','C4','CZ','F3','F4','F7','F8','FP1','FP2','FZ','O1','O2',
#                'P3','P4','PZ','T3','T4','T5','T6')

binario = T
p.vales = c(.05,.01,.005)
escala  = F

zoom           = F
unidad_par_t   = 'tiempo'
ajuste_ini_hms = c(0,0,0)
min_hms        = c(3,17,20)
max_hms        = c(3,19,10)
#unidad_par_t   = 'puntos'
#ajuste_ini_epo = 0
#min_epo        = 0
#max_epo        = 0

# parametros de dibujo
paso    = 10*60*2

#################################################
# libreria especifica para el grafico tipo matriz
require('plotrix')

#################################################
# procesamiento parametros opcionales
if(reemplazar){
  if(canales=='10-20'){
    canales = c('C3','C4','CZ','F3','F4','F7','F8','FP1','FP2','FZ','O1','O2',
                'P3','P4','PZ','T3','T4','T5','T6')
  }
  if(canales=='PSG'){
    canales = c('C3','C4','CZ','F3','F4','F7','F8','FP1','FP2','FZ','O1','O2',
                'P3','P4','PZ','T3','T4','T5','T6','LOG','ROG','EMG')
  }
}
if(length(canales)<1){
  stop('ERROR: Lista de canales tiene longitud cero')
}

#################################################
# parametros dependientes de los datos
n_canales = length(canales)
ventana   = dur_epoca*fr_muestreo

#################################################
# procesamiento parametros opcionales (ajuste)
if(unidad_par_t =='tiempo'){
  ini_t   = ajuste_ini_hms[1]*60*60
  +ajuste_ini_hms[2]*60
  +ajuste_ini_hms[3]
  ini_epo = ini_t/dur_epoca
  ini_pt  = floor(ini_t*fr_muestreo)
}
if(unidad_par_t =='epoca'){
  ini_epo = ajuste_ini_epo
  ini_t   = ini_epo*dur_epoca
  ini_pt  = ini_epo*ventana
}
str_t   = 0
str_epo = 1
str_pt  = 1

# ini : cuando inicia el archivo, util si es un fragmento
# str : cuando inicia el zoom, evita la confusion provocada por ini

min_e = 1

# procesamiento parametros opcionales (zoom)
if(zoom){
  confirma_zoom = FALSE
  if(unidad_par_t == 'tiempo'){
    min_t  = min_hms[1]*60*60 + min_hms[2]*60 + min_hms[3] -ini_t
    max_t  = max_hms[1]*60*60 + max_hms[2]*60 + max_hms[3] -ini_t
    
    min_e  = floor((min_t+ini_t)/dur_epoca -ini_epo)
    max_e  = ceiling((max_t+ini_t)/dur_epoca -ini_epo)
    
    confirma_zoom = TRUE
  }
  if(unidad_par_t == 'puntos'){
    min_t = min_epo*dur_epoca -ini_t
    max_t = max_epo*dur_epoca -ini_t
    
    min_e = floor((min_epo+ini_t) -ini_epo)
    max_e = ceiling((max_epo+ini_t) -ini_epo)
    
    confirma_zoom = TRUE
  }
  if(!confirma_zoom){
    warning('WARNING: Indique unidad de tiempo para zoom (epocas o segundos)')
  }
  min_pt = floor(min_e*ventana)
  max_pt = ceiling(max_e*ventana)
  
  str_t   = max(min_t, 0)
  str_epo = max(min_e, 1)
  str_pt  = max(min_pt,1)
}

#################################################
# modo seguro: revisa si estan los archivos
correctos = rep(FALSE,n_canales)
n_datos   = Inf

setwd(dir_res_mid)
for(ch in 1:n_canales){
  ch_actual = canales[ch]
  if(file.exists(paste0('EST_',nombre,'_',ch_actual,'_T.txt'))){
    correctos[ch] =TRUE
  }else{
    warning('ERROR: En canal ',ch_actual,', no se encontro el archivo ',
            paste0(nombre,'_',ch_actual,'.txt'))
  }
}
canales   = canales[correctos]
n_canales = length(canales)

#################################################
# optimizacion: lee el tamano de los datos el contenedor
setwd(dir_res_mid)
ch        = 1
ch_actual = canales[ch]
nom_arch  = paste0('EST_',nombre,'_',ch_actual,'_T.txt')
#pv_t      = scan(nom_arch)
pv_t      = read.csv(nom_arch)
#pv_t      = as.numeric(t(pv_t[2]))
pv_t      = as.numeric(t(pv_t))
n_epocas  = length(pv_t)
max_e     = n_epocas

# ajustes en el tiempo

if(zoom){
  end_t    = min(max_t, n_epocas*dur_epoca)
  end_epo  = min(max_e, n_epocas)
  end_pt   = min(max_pt,n_epocas)
  
  ini_t    = ini_t   + str_t
  ini_epo  = ini_epo + str_epo
  ini_pt   = ini_pt  + str_pt
  n_epocas = length(str_epo:end_epo)
} 
# end : cuando termina el zoom, evita la confusion provocada por ini

#################################################

# contenedores de los datos
RES_T   = matrix(nrow=n_canales,ncol=n_epocas)

#################################################
# inicio ciclo que recorre todos los canales
for(ch in 1:n_canales){
  # cargar los datos
  ch_actual = canales[ch]
  nom_arch  = paste0('EST_',nombre,'_',ch_actual,'_T.txt')
  #pv_t      = scan(nom_arch)
  pv_t      = read.csv(nom_arch)
  #pv_t      = as.numeric(t(pv_t[2]))
  pv_t      = as.numeric(t(pv_t))
  if(zoom){
    pv_t    = pv_t[min_e:max_e]
  }
  
  # si en algun canal se analizaron mas o menos epocas
  if(length(pv_t)!=n_epocas){
    warning('ERROR: En canal ',ch_actual,', no coincide el numero de epocas')
    if(length(pv_t)>n_epocas){
      pv_t  = pv_t[1:n_epocas]
    }else{
      pv_t2 = pv_t
      pv_t  = rep(1,n_epocas)
      pv_t[1:length(pv_t2)] = pv_t2
    }
  }
  
  # organizacion de los datos en una matriz
  RES_T[ch,] = pv_t
}
# fin ciclo que recorre canales
#################################################

#################################################
# creacion etiquetas de tiempo
ind_t  = (0:n_epocas)*(dur_epoca) + ini_t
ind_hh = floor(ind_t/(60*60))
ind_mm = floor( (ind_t - ind_hh*60*60)/60 )
ind_ss = floor(  ind_t - ind_hh*60*60 - ind_mm*60 )
txt_t  = character(n_epocas+1)
for(i in 1:(n_epocas+1)){
  txt_mm = toString(ind_mm[i])
  if(ind_mm[i]<10){
    txt_mm = paste0('0',ind_mm[i])
  }
  txt_ss = toString(ind_ss[i])
  if(ind_ss[i]<10){
    txt_ss = paste0('0',ind_ss[i])
  }
  txt_t[i] = paste0(toString(ind_hh[i]),':',txt_mm,':',txt_ss)
  #txt_t[i] = paste0(toString(ind_hh[i]),':',txt_mm)
}

pass  = paso/dur_epoca
IND_T = ind_t-1

#################################################
# tratamiento para contraste de color
if(binario){
  n_pvals = length(p.vales)
  M_RES   = matrix(0,nrow=n_canales,ncol=n_epocas)
  for(i in 1:n_pvals){
    M_RES = M_RES + 1*( RES_T>p.vales[i])
  }
  RES_T   = M_RES**(3/2)
}

#################################################
# inicio guardado automatico del grafico
if(grabar){
  setwd(dir_graf)
  #pdf(paste0(nombre,
  png(paste0(nombre,
             '_est',
  #           '.pdf'),width=12,height=6)
             '.png'),units='in',res=300,width=12,height=6)
}

# grafico principal
par(mar=c(4,3,3.5,1))
color2D.matplot(RES_T,
                #colores claro->oscuro ~ menor->mayor
                cs1=c(1,0),cs2=c(1,0),cs3=c(1,0),
                border=NA,
                axes=F,na.color=NA,
                xlab='Num de epoca',ylab='',
                main=paste0('Sujeto : ',etiqueta
                            #'  (',toString(dur_epoca),' s)'
                            )
                )

# PARCHE
que.epocas = min_e:max_e
letras     = rep('',length(que.epocas))
for(i in 1:length(que.epocas)){
  letras[i] = toString(que.epocas[i]) 
}

# los ejes
axis(2,at=1:22-0.5,labels=rev(canales),las=2,tick=F)
axis(2,at=0:22,    labels=F,           las=2,tick=T)
axis(3,labels=F,tick=T,at=c(0,n_epocas))
skip = seq(1,n_epocas+1,by=paso)
#axis(1,at=skip-1,labels=txt_t[skip],las=2,tick=T)
axis(1,at=1:n_epocas-.5,labels=letras,las=2,tick=F)
axis(1,at=0:n_epocas,labels=F,las=2,tick=T)
axis(4,at=c(0,22),    labels=F,           las=2,tick=T)


if(grabar){
  setwd(dir_graf)
  dev.off()
}
# fin guardado automatico del grafico
#################################################

setwd(dir_actual)

#abline(v = 10,col='green',lwd=3)
# 650 x 400

