# #duraciones = c(0.25,0.5,1:43)
# duraciones = 2**c(-3:6)
# N = length(duraciones)

require(beepr)
require(signal)

data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/espectro_integrado/'

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

beep()

#duraciones = 2**rev(-3:4)
duraciones = c(1)

for(dur_epoca in duraciones){
  
  for(sujeto in 1:12){
    
    setwd(central_dir)
    
    nombre   = nom_arch[sujeto]
    etiqueta = nom_facil[sujeto]
    
    dir_datos   = paste0(data_dir,nom_dir[sujeto])
    #dir_res     = paste0(result_dir,nom_dir[sujeto])
    dir_res     = result_dir
    
    fr_muestreo = frecuenciasss[sujeto]
    #dur_epoca   = 30
    
    source('multi_espectro_integrado01.R' ) 
    
    beep()
  }
  
  beep()
  
  beep()
  
  beep()
}

beep()

beep()

# plot(duraciones,
#      100*porcentajes[,1],type='o',ylim=c(0,100),
#      xlab='Duracion epoca (s)',
#      ylab='% epocas estacionarias',
#      main='Sujeto : CLO  |  Canal : T5')
# lines(duraciones,100*porcentajes[,2],type='o')
# lines(duraciones,100*porcentajes[,3],type='o')
# 
# plot(log2(duraciones),
#      100*porcentajes[,1],type='o',ylim=c(0,100),
#      xlab='log - Duracion epoca (s)',
#      ylab='% epocas estacionarias',
#      main='Sujeto : CLO  |  Canal : T5')
# lines(log2(duraciones),100*porcentajes[,2],type='o')
# lines(log2(duraciones),100*porcentajes[,3],type='o')