# esta funcion abre todos los archivos y realiza el test PSR
#
# funcion que abre todos los archivos que contienen los registros,
# y realiza el test PSR sobre cada epoca; esto suponiendo que
# previamente ha utilizado el script 'segmentarX.R'
#
# Variables
#   nombre  -> nombre comun de los archivos, segun paciente;
#              se escribe entre comillas
#       ch  -> numero del canal, del 1 al 22 en orden alfabetico
#
# Orden alfabetico de los canales
#       1 : C3
#       2 : C4
#       3 : CZ
#       4 : EMG
#       5 : F3
#       6 : F4
#       7 : F7
#       8 : F8
#       9 : FP1
#      10 : FP2
#      11 : FZ
#      12 : LOG
#      13 : O1
#      14 : O2
#      15 : P3
#      16 : P4
#      17 : PZ
#      18 : ROG
#      19 : T3
#      20 : T4
#      21 : T5
#      22 : T6
#
multipsr <- function(ch,nombre,w_dir,c_dir,r_dir,
                     frec,dur_epo){
  
  # el paquete 'fractal' tiene implementado el test psr
  library(fractal)

  # constantes genericas
  #nombre = 'VCNNS1'
  channel = c('C3','C4','CZ','EMG',
              'F3','F4','F7','F8',
              'FP1','FP2','FZ','LOG',
              'O1','O2','P3','P4','PZ',
              'ROG','T3','T4','T5','T6'
              )
  dur_epoca = frec*dur_epo
  
  # componentes de los nombres de archivo
  canal  = channel[ch]
  nom_ar = paste0(nombre,'_',canal,'.txt')
  
  # cargar datos
  setwd(w_dir)
  DATA = read.csv(nom_ar)
  DATA = as.numeric(unlist(DATA))
    
  # cuantas epocas contiene el archivo/segmento en cuestion
  max_epoca = floor(length(DATA)/dur_epoca)
  
  # contenedores de los resltados del test
  pv.t   = rep(0,max_epoca)
  pv.ir  = rep(0,max_epoca)
  pv.tir = rep(0,max_epoca)

    #print( paste0('  SUJETO : ',nombre) )
    #print( paste0('   Canal : ',
    #              canal,' (',toString(ch),'/22)') )
  
  # ciclo que recorre las epocas en el archivo/segmento actual
  for ( i in 0:(max_epoca-1) ){
    #print(max_epoca)
    # filtro STL, robusto y forzado a periodico estandar
    temp   = DATA[ (i*dur_epoca) : ((i+1)*dur_epoca) ]
    temp.t = ts(temp,frequency=frec,start=c(0,0))
    s      = stl(temp.t,robust=T,s.window='periodic')
    te     = s$time.series[,'remainder']
    te1    = as.numeric(unclass(te))
      
    # test de PSR, los archivos se recolectan
    z      = stationarity(te1)
    pv.t[i+1]   = as.numeric( attr(z,'pvals')[1])
    pv.ir[i+1]  = as.numeric( attr(z,'pvals')[2])
    pv.tir[i+1] = as.numeric( attr(z,'pvals')[3])
      
    # se imprime en pantalla el porcentaje del proceso
    #print( paste0('  SUJETO : ',nombre) )
    #print( paste0('   Canal : ',
    #              canal,' (',toString(ch),'/22)') )
    #print( paste0('Progreso : ',
    #              toString(floor(i/(max_epoca-1)*10000)/100),
    #              ' %' ))
  }

  # los resultados se guardan en un archivo .csv
  setwd(r_dir)
  write.csv(pv.t  , paste0('EST_',nombre,'_',canal,'_T_',dur_epo,'.csv'  ))
  write.csv(pv.ir , paste0('EST_',nombre,'_',canal,'_IR_',dur_epo,'.csv' ))
  write.csv(pv.tir, paste0('EST_',nombre,'_',canal,'_TIR_',dur_epo,'.csv'))
  
  ## necesita regresar algo
  return(ch)
}
