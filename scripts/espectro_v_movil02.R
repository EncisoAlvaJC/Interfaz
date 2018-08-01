library(signal)

data_d   = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS'
#center_d = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'

nombre      = 'CLMN10SUE'
#nombre      = 'MJNNVIGILOS'
nom_dir     = '/CLMN10SUE'
#nom_dir     = '/MJNNVIGILOScCanal'

#etiqueta    = 'CLMN'

dir_datos   = paste0(data_d,nom_dir)
dir_res     = 'C:/Users/EQUIPO 1/Desktop/julio/espectro_cuadrado2'

extension   = '.txt'
reemplazar  = T
fr_muestreo = 512
#dur_epoca   = 30
canales     = 'PSG'
#canales = c('T4','T5','T6','LOG','ROG','EMG')

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
#if(missing(etiqueta)){
#  etiqueta = nombre
#}

#################################################
# parametros dependientes de los datos
#ventana   = fr_muestreo*dur_epoca
n_canales = length(canales)
#usar_stl  = T
#if(dur_epoca<=2){
#  usar_stl = F
#}
#if(usar_loess){
#  usar_stl = F
#}

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
  
  sp = specgram(DATOS,Fs=512)
  
  setwd(dir_res)
  
  write.table(Mod(sp$S),file=paste0('SPEC_',nombre,'_',ch_actual,'.txt'),
              col.names=F,row.names=F)
  write.table(sp$f,file=paste0('FREC_',nombre,'_',ch_actual,'.txt'),
              col.names=F,row.names=F)
  write.table(sp$t,file=paste0('TIME_',nombre,'_',ch_actual,'.txt'),
              col.names=F,row.names=F)
}
# fin del ciclo que recorre canales
#################################################

# fin del script
###############################################################################