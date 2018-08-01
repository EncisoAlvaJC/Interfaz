require(fractal)

data_d   = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS'
#center_d = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'

nombre      = 'CLMN10SUE'
etiqueta    = 'CLMN'

dir_datos   = paste0(data_d,'/CLMN10SUE')
dir_res     = 'C:/Users/EQUIPO 1/Desktop/julio/escalamiento'

extension   = '.txt'
reemplazar  = F
fr_muestreo = 512
#dur_epoca   = 10
#canales     = 'PSG'
canales     = 'T6' 

ver_avance  = F
no_repetir  = F
haz_carpeta = T
usar_loess  = F
filtrar     = F

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
if(missing(etiqueta)){
  etiqueta = nombre
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
  
  # contenedores de los resltados
  pv.t   = rep(0,max_epoca)
  pv.ir  = rep(0,max_epoca)
  pv.tir = rep(0,max_epoca)
  
  #informacion sobre el progreso, si fue requerida
  if(ver_avance){
    print( paste0('  Sujeto : ',etiqueta) )
    print( paste0('   Canal : ',ch_actual,
                  ' (',toString(ch),'/',toString(n_canales),')') )
  }
  
  #################################################
  # inicio del ciclo que recorre las epocas
  for ( i in 0:(max_epoca-1) ){
    
    # filtro STL, robusto y forzado a periodico estandar
    tmp   = DATOS[ (i*ventana+1) : ((i+1)*ventana) ]
    tmp.t = ts(tmp,frequency=fr_muestreo,start=c(0,0))
    if(filtrar){
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
    
    # test de PSR, los archivos se recolectan
    z         = stationarity(tmp)
    pv.t[i]   = as.numeric( attr(z,'pvals')[1])
    pv.ir[i]  = as.numeric( attr(z,'pvals')[2])
    pv.tir[i] = as.numeric( attr(z,'pvals')[3])
  }
  # fin del ciclo que recorre las epocas
  #################################################
  
  # los resultados se guardan en un archivo .csv
  setwd(dir_res)
  write.table(pv.t  , paste0('EST_',nombre,'_',ch_actual,'_T',
                             toString(dur_epoca),'s.txt'  ),
              row.names=FALSE,col.names=FALSE)
  #write.table(pv.ir , paste0('EST_',nombre,'_',ch_actual,'_IR.txt' ),
  #            row.names=FALSE,col.names=FALSE)
  #write.table(pv.tir, paste0('EST_',nombre,'_',ch_actual,'_TIR.txt'),
  #            row.names=FALSE,col.names=FALSE)
}
# fin del ciclo que recorre canales
#################################################

# fin del script
###############################################################################