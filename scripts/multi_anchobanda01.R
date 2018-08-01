###############################################################################
# parametros del script
#nombre      = 'CLMN10SUE'
#etiqueta    = 'CLMN'
#dir_datos   = paste0(getwd(),'/CLMN10SUE')
#dir_res     = paste0(getwd(),'/res_parciales')

extension   = '.txt'
#fr_muestreo = 512
#dur_epoca   = 30
reemplazar  = TRUE   #  <-
canales     = 'PSG'

ver_avance  = T
no_repetir  = F
haz_carpeta = F
usar_loess  = F
filtrar     = F

#################################################
# libreria que contiene la prueba de PSR
require('fractal')

#################################################
# revisar si faltan algunos parametros
if(missing(fr_muestreo)){
  warning('WARNING: No se ha indicado la frecuencia de muestreo')
}
if(missing(dur_epoca)){
  warning('WARNING: No se ha indicado el tamano de la epoca')
}

#################################################
# parametros opcionales
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
ventana   = fr_muestreo*dur_epoca
n_canales = length(canales)
usar_stl  = T
if(dur_epoca<=2){
  usar_stl = F
}
if(usar_loess){
  usar_stl = F
}

#################################################
# inicio del ciclo que recorre los canales
for(ch in 1:n_canales){
  
  # construye el nombre del archivo
  ch_actual   = canales[ch]
  nom_archivo = paste0(nombre,'_',ch_actual,extension)
  
  if(no_repetir){
    setwd(dir_res)
    if(file.exists(paste0('EST_',nombre,'_',ch_actual,'_T.csv'  ))){
      warning('El canal ',ch_actual,
              ' se ha omitido, pues se encontraron resultados previos')
      next()
    }
  }
  
  # cargar los datos
  setwd(dir_datos)
  if(!file.exists(nom_archivo)){
    warning('ERROR: En canal ',ch_actual,
            ', no se encontro el archivo ',nom_archivo)
    next()
  }
  DATOS = read.csv(nom_archivo)
  DATOS = as.numeric(unlist(DATOS))
  
  # cuantas epocas pueden formarse
  max_epoca = floor(length(DATOS)/ventana)
  if(max_epoca==0){
    warning(paste0('ERROR: En canal ',ch_actual,
                   ', no se pudieron leer datos'))
    next()
  }

  #################################################
  # conenedor de datos
  a_banda = rep(0,max_epoca)

  #informacion sobre el progreso, si fue requerida
  if(ver_avance){
    print( paste0('  Sujeto : ',etiqueta) )
    print( paste0('   Canal : ',ch_actual,
                  ' (',toString(ch),'/',toString(n_canales),')') )
  }
  
  #################################################
  # inicio del ciclo que recorre las epocas
  for ( i in 0:(max_epoca-1) ){
    tmp   = DATOS[ (i*ventana+1) : ((i+1)*ventana) ]
    
    if(filtrar){
      # filtro STL, robusto y forzado a periodico estandar
      tmp.t = ts(tmp,frequency=fr_muestreo,start=c(0,0))
      if(usar_stl){
        tmp.s = stl(tmp.t,robust=T,s.window='periodic')
        tmp.r = tmp.s$time.series[,'remainder']
        tmp   = as.numeric(unclass(tmp.r))
      }else{
        tmp.l = loess(tmp~time(tmp.t))
        tmp.s = predict(tmp.l,time(tmp.t))
        tmp   = tmp - tmp.s$fit
      }
    }
    
    # calculo ad hoc del ancho de banda
    a_banda[i] = ancho.banda(tmp,f.muestreo=fr_muestreo)
  }
  # fin del ciclo que recorre las epocas
  #################################################
  
  # los resultados se guardan en un archivo .csv
  setwd(dir_res)
  write.table(a_banda,paste0('AB_',nombre,'_',ch_actual,'.txt'  ),
              row.names=FALSE,col.names=FALSE)

}
# fin del ciclo que recorre canales
#################################################
# fin del script
###############################################################################