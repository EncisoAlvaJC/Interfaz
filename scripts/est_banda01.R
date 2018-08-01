#######################################
# ejemplo oficial
set.seed(2017)

X = rnorm(512*30)
for(i in 2:(512*15)){
  X[i] = (X[i] + X[i-1])/2
}

###############################################################################
# Implementacion de la prueba de Priestley-Subba Rao para estacionariedad
#
# Basado en 'Estimating the statistical bandwidth of a time series' por Walden
# y White ()
# Implementado por Enciso-Alva (2017)
#
###############################################################################
#
# PARAMETROS :
#
#        X  Serie de tiempo cuyo ancho de badan se va a estimar
#  ventana  Nombre de la ventana a usarse, por default usa la constante 1
#       th  Proporcion punto de truncamiento/longitud de la serie
#  truncar  En algunas ventanas (ej. Daniell, normal, Bohman) th no es para
#           truncar sino para reescalar, pero puede forzarse el primero
#
estacionariedad.banda = function(X,
                                 limites=c(0.5,3.5),nombre='Delta',
                                 ventana.g='Bartlett-Priestley',truncar.g=F,
                                 ventana.w='Bartlett-Priestley',truncar.w=F,
                                 th.g=0.5,th.w=0.25,
                                 d.om=1/100,
                                 f.muestreo=1,n.block=ceiling(log2(length(X)))){
  
  #######################################
  # parametros que dependen de los datos
  d.t = 1/f.muestreo
  TT  = length(X)
  
  # cargar g
  # cargar w
  # obtener min_dw
  
  J    = floor((limites[2]-limites[1])/d.om)
  d.om = (limites[2]-limites[1])/d.om
  I    = n.block
  T.m  = floor(TT/I)
  
  #######################################
  # contenedores de datos
  tiempos     = ((T.m-1)/2 + (0:(I-1))*T.m)*d.t
  frecuencias = limites[1] + ((1:J)-0.5)*d.om
  
  UU = matrix(nrow=T.m,ncol=J)
  FF = matrix(nrow=I  ,ncol=J)
  
  # preparacion de la ventana g
  u  = (1:T.m) - (T.m+1)/2
  g.vec = g((-T.m+1):(T.m-1))
  
  #######################################
  # inicio ciclo recorre n.block
  for(i in 1:I){
    X.m = X[(1:T.m)+(i-1)*T.m]
    ind = seq(T.m,2*T.m-2)
    
    # se calcula UU
    for(i in 1:T.m){
      for(j in 1:J){
        om  = frecuencias[j]
        ind = ind-1
        
        UU[i,j] = fft(X*g.vec[ind],om)
      }
    }

    # se calcula FF
    for(j in 1:J){
      F[,j] = U[,j]*W(u)
    }
  }
  # fin ciclo recorre n.block
  #######################################
  
  # se calculan los estadisticos que seran usados
  Y   = log(FF)
  Y.. = mean(Y)
  Y._ = rep(0,J)
  Y_. = rep(o,I)
  for(i in 1:I){
    Y_.[i] = mean(Y[i,])
  }
  for(j in 1:J){
    Y._[j] = mean(Y[,j])
  }
  sigma_2 = (C/T.m)*G4
  
  S.IR = 0
  for(j in 1:J){
    S.IR = S.IR + sum((Y[,j]-Y._[j])**2)
  }
  S.IR = S.IR/sigma_2
  # test(S.IR != 0)
  # S.IR ~ chi**2(J*(I-1))
  
  S.T = J*sum((Y_.-Y..)**2)/sigma_2
  # test(S.T != 0)
  # S.T ~ chi**2(I-1)
}
###############################################################################
##  BITACORA DE CAMBIOS  ######################################################
#
# 28/ago/2017
# Primera version, me he peleado por un largo rato por entender el papel de
# G4, C y min.d.om los cuales ahora estoy calculando numericamente; usare por
# ahora los de una ventana para ganar tiempo y tener expresiones exactas para
# todas las que pueda conseguir