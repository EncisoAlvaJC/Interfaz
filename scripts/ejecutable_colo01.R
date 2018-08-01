#
# para vc, EMG es una copia de LOG
#

require(beepr)
require(signal)

data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/kolor/'

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

#for(sujeto in c(1,2,6,10)){
for(sujeto in 1:12){
  
  setwd(central_dir)
  
  nombre   = nom_arch[sujeto]
  nombre   = nom_arch[sujeto]
  
  dir_datos   = paste0(data_dir,nom_dir[sujeto])
  dir_res     = paste0(result_dir,nom_dir[sujeto])
  
  fr_muestreo = frecuenciasss[sujeto]
  dur_epoca   = 30
  
  source('colores02.R' ) 
  
  beep()
}

beep()

beep()

beep()

beep()

beep()
