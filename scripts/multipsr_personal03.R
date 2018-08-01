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
usar_loess  = T
filtrar     = F

pvalores = c(.1,.05,.01,.005,.001,.005)

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
# conenedor de datos
porcentajes = matrix(nrow=length(canales),ncol=length(pvalores))

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
    
    # test de PSR, los archivos se recolectan
    z         = stationarity(tmp)
    pv.t[i]   = as.numeric( attr(z,'pvals')[1])
    pv.ir[i]  = as.numeric( attr(z,'pvals')[2])
    pv.tir[i] = as.numeric( attr(z,'pvals')[3])
  }
  # fin del ciclo que recorre las epocas
  #################################################
  
  # los resultados se guardan en un archivo .csv
  #setwd(dir_res)
  #write.table(pv.t  , paste0('EST_',nombre,'_',ch_actual,'_T.txt'  ),
  #            row.names=FALSE,col.names=FALSE)
  #write.table(pv.ir , paste0('EST_',nombre,'_',ch_actual,'_IR.txt' ),
  #            row.names=FALSE,col.names=FALSE)
  #write.table(pv.tir, paste0('EST_',nombre,'_',ch_actual,'_TIR.txt'),
  #            row.names=FALSE,col.names=FALSE)
  
  #################################################
  # los resultados se procesan para obtener un grafico
  for(i in 1:length(pvalores)){
    pp = pvalores[i]
    nd = length(pv.t)
    porcentajes[ch,i] = sum(pv.t>pp)/nd
  }
}
# fin del ciclo que recorre canales
#################################################

setwd('C:/Users/EQUIPO 1/Desktop/julio/escalamientop')
write.csv(porcentajes,paste0('PE_',nombre,'_',ch_actual,
                             '_',toString(dur_epoca),'.csv'))

# fin del script
###############################################################################