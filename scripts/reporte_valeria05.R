###############################################################################
# PARCHE : volver a la carpeta central
dir_actual  = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'

require(fractal)

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

analizar     = matrix(nrow=length(v.nombres),ncol=2)
analizar[ 1,] = c(712,721)
analizar[ 2,] = c(183,192)
analizar[ 3,] = c(108,140)
analizar[ 4,] = c(1184,1195)
analizar[ 5,] = c(824,833)
analizar[ 6,] = c(166,176)
analizar[ 7,] = c(242,251)
analizar[ 8,] = c(697,706)
analizar[ 9,] = c(368,378)
analizar[10,] = c(276,289)
analizar[11,] = c(  0,  0)
analizar[12,] = c(202,220)


###############################################################################
# parametros del script, ver documantacion para mas informacion
#sujeto = 2
nombre       = v.nombres[sujeto]
etiqueta     = v.etiqueta[sujeto]
dir_datos    = paste0('C:/Users/EQUIPO 1/Desktop/julio/DATOS/',v.directorio[sujeto])
dir_graf     = 'C:/Users/EQUIPO 1/Desktop/julio/reporte_valeria_2'
fr_muestreo  = frecuenciasss[sujeto]
#dur_epoca    = 10
if(fr_muestreo==512){
  dur_epoca = 30
}else{
  dur_epoca = 10
}

grabar      = FALSE
anotaciones = ''

reemplazar  = TRUE
canales      = 'PSG'

binario = T
p.vales = c(.05,.01,.005)
escala  = F

zoom           = TRUE
#unidad_par_t   = 'tiempo'
#ajuste_ini_hms = c(0,0,0)
#min_hms        = c(3,17,20)
#max_hms        = c(3,19,10)
unidad_par_t   = 'puntos'
ajuste_ini_epo = 0
min_epo        = analizar[sujeto,1]
max_epo        = analizar[sujeto,2]

# parametros de dibujo
paso    = 1*2

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
# datos que seran analizados
epocas.analizar = seq(min_epo-10,max_epo)

#################################################

# contenedores de los datos
RES_T = matrix(nrow=n_canales,ncol=length(epocas.analizar))
colnames(RES_T)  = epocas.analizar
row.names(RES_T) = canales

#################################################
# inicio ciclo que recorre todos los canales
for(ch in 1:n_canales){
  # cargar los datos
  setwd(dir_datos)
  
  ch_actual = canales[ch]
  nom_arch  = paste0(nombre,'_',ch_actual,'.txt')
  DATOS     = scan(nom_arch)
  
  for(i in 1:length(epocas.analizar)){
    ii  = epocas.analizar[i]-1
    tmp = DATOS[(ii*ventana+1):((ii+1)*ventana)]
    
    tmp.t = ts(tmp,frequency=fr_muestreo)
    tmp.s = stl(tmp.t,s.window='periodic',robust = T)
    tmp.r = tmp.s$time.series[,'remainder']
    
    tmp   = as.numeric(tmp.r) 
    
    z   = stationarity(tmp)
    
    RES_T[ch,i] = as.numeric(attr(z,'pvals')[1])
  }

}
# fin ciclo que recorre canales
#################################################

setwd(dir_graf)
#require(xlsx)

write.csv(RES_T,file=paste0('pvals_epocas_',etiqueta,'.csv'))

setwd(dir_actual)

Q = 1*(RES_T>0.01) + 1*(RES_T>0.05) + 1*(RES_T>0.1)
color2D.matplot(-Q,border=NA,yrev=T)
