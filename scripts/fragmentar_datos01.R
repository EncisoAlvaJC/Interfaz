data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/datos_segmentados/'

nom_dir  = c('VCNNS',
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
             'EMNN'
)
nom_arch = c('VCNNS1',
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
nom_facil = c('VCR',
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

epoca_ini = c(712 -30,
              183 -10,
              108 -10,
              1184-30,
              824 -30,
              166 -10,
              242 -10,
              697 -30,
              368 -10,
              276 -10,
              0,
              202 -30)
epoca_fin = c(741 +1,
              192 +1,
              140 +1,
              1213+1,
              853 +1,
              176 +1,
              251 +1,
              726 +1,
              378 +1,
              289 +1,
              0,
              231 +1)

grupo_de = c(0,0,0,0,0,1,1,1,1,-1,-1,-1)

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
# parametros del script
#nombre      = 'CLMN10SUE'
#etiqueta    = 'CLMN'
#dir_datos   = paste0(getwd(),'/CLMN10SUE')
#dir_res     = paste0(getwd(),'/res_parciales')

setwd(central_dir)

nombre   = nom_arch[sujeto]
etiqueta = nom_facil[sujeto]

dir_datos   = paste0(data_dir,nom_dir[sujeto])
#dir_res     = paste0(result_dir,nom_dir[sujeto])
dir_res     = result_dir

fr_muestreo = frecuenciasss[sujeto]
dur_epoca   = 30

extension   = '.txt'
reemplazar  = TRUE   #  <-
canales     = 'PSG'

ver_avance  = T
no_repetir  = F
haz_carpeta = F
usar_loess  = F
filtrar     = F

#################################################
# parametros para el zoom
zoom           = F
unidad_par_t   = 'tiempo'
ajuste_ini_hms = c(0,0,0)
min_hms        = c(hora  ,0,0)
max_hms        = c(hora+1,0,0)
#unidad_par_t   = 'puntos'
#ajuste_ini_epo = 0
#min_epo        = 702
#max_epo        = 722

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
if(fr_muestreo==512){
  dur_epoca_reg = 30
}
if(fr_muestreo==200){
  dur_epoca_reg = 10
}
ventana_reg = fr_muestreo*dur_epoca_reg

# procesamiento parametros opcionales (ajuste)
if(unidad_par_t =='tiempo'){
  ini_t   = ajuste_ini_hms[1]*60*60
  +ajuste_ini_hms[2]*60
  +ajuste_ini_hms[3]
  ini_epo = ini_t/dur_epoca_reg
  ini_pt  = floor(ini_t*fr_muestreo)
}
if(unidad_par_t =='puntos'){
  ini_epo = ajuste_ini_epo
  ini_t   = ini_epo*dur_epoca_reg
  ini_pt  = ini_epo*ventana_reg
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
    min_t = min_epo*dur_epoca_reg -ini_t
    max_t = max_epo*dur_epoca_reg -ini_t
    
    min_e = floor((min_epo+ini_t) -ini_epo)
    max_e = ceiling((max_epo+ini_t) -ini_epo)
    
    confirma_zoom = TRUE
  }
  if(!confirma_zoom){
    warning('WARNING: Indique unidad de tiempo para zoom (epocas o segundos)')
  }
  min_pt = floor(min_e*ventana_reg)
  max_pt = ceiling(max_e*ventana_reg)
  
  str_t   = max(min_t, 0)
  str_epo = max(min_e, 1)
  str_pt  = max(min_pt,1)
}



#################################################
# optimizacion: lee un canal, obtiene los indices a analizar
setwd(dir_datos)
ch          = 1
ch_actual   = canales[ch]
nom_archivo = paste0(nombre,'_',ch_actual,extension)
DATOS       = read.csv(nom_archivo)
DATOS       = as.numeric(unlist(DATOS))
max_epoca   = floor(length(DATOS))
n_epocas    = max_epoca
#max_e       = n_epocas

if(zoom){
  end_t    = min(max_t, n_epocas*dur_epoca_reg)
  end_epo  = min(max_e, n_epocas)
  end_pt   = min(max_pt,n_epocas*ventana_reg)
  
  ini_t    = ini_t   + str_t
  ini_epo  = ini_epo + str_epo
  ini_pt   = ini_pt  + str_pt
  n_epocas = length(str_epo:end_epo)
} 

#################################################
# inicio del ciclo que recorre los canales
for(ch in rev(1:n_canales)){

  # construye el nombre del archivo
  ch_actual   = canales[ch]
  nom_archivo = paste0(nombre,'_',ch_actual,extension)
  
  # cargar los datos
  setwd(dir_datos)
  if(!file.exists(nom_archivo)){
    warning('ERROR: En canal ',ch_actual,
            ', no se encontro el archivo ',nom_archivo)
    next()
  }
  DATOS = read.csv(nom_archivo)
  DATOS = as.numeric(unlist(DATOS))
  
  if(zoom){
    DATOS = DATOS[ini_pt:end_pt]
  }
  
  

  # los resultados se guardan en un archivo .csv
  setwd(dir_res)
  write.table(DATOS,paste0(nombre,'_',ch_actual,'_',toString(hora),extension),
              row.names=FALSE,col.names=FALSE)
}
# fin del ciclo que recorre canales
#################################################

# fin del script
###############################################################################