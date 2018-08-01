###############################################################################
# directorios de trabajo
data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/estacionariedad_sf/'

###############################################################################
# parametros
duraciones = 30*(2**rev(-5:2))

###############################################################################
# datos generales
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
             'EMNN')
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
# librerias: sonidito y test PSR
require(beepr)
require(fractal)
# librerias: paralelizar
require(foreach)
require(doParallel)
require(parallel)

beep()

###############################################################################
# inicio ciclo doble
for(dur_epoca in duraciones){
  for(sujeto in 1:12){
    setwd(central_dir)
    
    nombre   = nom_arch[sujeto]
    etiqueta = nom_facil[sujeto]
    
    dir_datos   = paste0(data_dir,nom_dir[sujeto])
    dir_res     = paste0(result_dir,nom_dir[sujeto])
    
    fr_muestreo = frecuenciasss[sujeto]
    #dur_epoca   = 30
    
    source('multipsr03_paralelizado.R' ) 
    
    beep()
  }
  beep()
  beep()
}
# fin ciclo doble
###############################################################################

beep()
beep()