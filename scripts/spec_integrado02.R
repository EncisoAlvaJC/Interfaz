require('beepr')

data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
#result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/espectro_integrado_171018/'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/espectro_integrado_171104/'

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

h_ini = c( 1, 1, 0, 3, 2, 1, 1, 1, 2, 2, 1, 1)
m_ini = c(50,23,46, 9, 8,14,52,48,55, 9,50,32)
s_ini = c( 0, 0, 0, 0,30,30,30, 0,30,30,30,30)

h_fin = c( 2, 1, 1, 3, 2, 1, 2, 2, 3, 2, 2, 1)
m_fin = c(15,48,11,34,33,39,17,13,20,34,15,57)
s_fin = c( 0, 0, 0, 0,30,30,30, 0,30,30,30,30)

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
  #for(sujeto in c(6,1,8,2,9,3,10,4,11,5,12,7)){
  for(sujeto in c(7)){
    
    #dur_epoca = 1
    
    setwd(central_dir)
    
    nombre   = nom_arch[sujeto]
    etiqueta = nom_facil[sujeto]
    
    dir_datos   = paste0(data_dir,nom_dir[sujeto])
    #dir_res     = paste0(result_dir,nom_dir[sujeto])
    dir_res     = result_dir
    
    fr_muestreo = frecuenciasss[sujeto]
    
    #min_epo = epoca_ini[sujeto]
    #max_epo = epoca_fin[sujeto]
    
    min_hms = c(h_ini[sujeto],m_ini[sujeto],s_ini[sujeto])
    max_hms = c(h_fin[sujeto],m_fin[sujeto],s_fin[sujeto])
    
    #min_epo = 0
    #if(fr_muestreo==512){
    #  max_epo = 20
    #}
    #if(fr_muestreo==200){
    #  max_epo = 60
    #}
    
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