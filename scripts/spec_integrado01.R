require('beepr')

data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/spec_int_art/'

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

epoca_ini = c(712 -10,
              183 -10)
epoca_fin = c(721 +1,
              192 +1)

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
  
  for(sujeto in c(9,7)){
    
    #dur_epoca = 1
    
    setwd(central_dir)
    
    nombre   = nom_arch[sujeto]
    etiqueta = nom_facil[sujeto]
    
    dir_datos   = paste0(data_dir,nom_dir[sujeto])
    #dir_res     = paste0(result_dir,nom_dir[sujeto])
    dir_res     = result_dir
    
    fr_muestreo = frecuenciasss[sujeto]
    
    min_epo = epoca_ini[sujeto]
    max_epo = epoca_fin[sujeto]
    
    #source('multi_espectro_integrado01.R' )
    source('multi_espectro_integrado02_paralelizado.R' )
    
    beep()
  }
  beep()
  beep()
  beep()
}

beep()
beep()