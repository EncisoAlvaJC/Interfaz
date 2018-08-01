require('ggplot2')
require('ggpubr')

f = function(x){
  numTerms = 50
  xx = rep(0,length(x))
  for(i in 1:length(x)){
    for(k in 0:numTerms){
      xx[i] = xx[i] + (cos((2**k) * x[i])/(1.5**k))
    }
  }
  return(xx)
}

x1  = seq(-2*pi,2*pi,length.out = 1001)
xx1 = f(x1)

x2  = seq(-0.1*pi,0.1*pi,length.out = 1001)
xx2 = f(x2)

xy1 = cbind(x1,xx1)
xy1 = as.data.frame(xy1)

xy2 = cbind(x2,xx2)
xy2 = as.data.frame(xy2)

A = ggplot(xy1,aes(x=x1,y=xx1)) +
  theme_bw() +
  xlab('t') + ylab('y') +
  scale_x_continuous(expand=c(0,0)) +
  geom_line() +
  annotate(geom='rect',xmin=min(x2),xmax=max(x2),
           ymin=min(xx2),ymax=max(xx2),
           fill=NA,color='red',size=.8)

B = ggplot(xy2,aes(x=x2,y=xx2)) +
  theme_bw() +
  xlab(expression(paste(M[x],t))) +
  ylab(expression(paste(M[y],y))) +
  scale_x_continuous(expand=c(0,0)) +
  geom_line()

err1 = function(x){
  return( exp(-(x**2/(2/3)))/sqrt(2*pi/3) )
}
err2 = function(x){
  return( exp(-(x**2/(2*3)))/sqrt(2*pi*3) )
}

X1 = seq(-3,3,by=1/100)
P1 = err1(X1)
P2 = err2(X1)

curvas = cbind(rbind(X1,P1,rep(1,length(P1))),
               rbind(X1,P2,rep(0,length(P2))))
curvas = as.data.frame(t(curvas))
colnames(curvas) = c('xx','pp','indice')
curvas$indice = factor(curvas$indice,
                       labels=c('Ventana n_1','Ventana n_2'))

C = ggplot(curvas,aes(x=xx,y=pp,linetype=indice)) +
  theme_classic() +
  xlab('y') +
  ylab('P(y)') +
  labs(linetype=NULL) +
  theme(legend.position = c(.2,.8)) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) +
  geom_vline(xintercept = 0,color='gray') +
  theme(axis.text.y = element_blank()) +
  theme(axis.text.x = element_blank()) +
  geom_line()

px = c(1,2)
py = c(1,2)

punts = cbind(px,py)
punts = as.data.frame(punts)

D = ggplot(punts,aes(x=px,y=py)) +
  theme_classic() +
  xlab(NULL) +
  ylab(NULL) +
  expand_limits(x=c(.5,2.5),y=c(.5,2.5)) +
  scale_x_continuous(breaks=c(1,2),labels=c('log n_1','log n_2')) +
  scale_y_continuous(breaks=c(1,2),labels=c('log s_1','log s_2')) +
  geom_abline(intercept = 0,slope=1,color='gray') +
  geom_point()

AB = ggarrange(A,B,ncol=1,nrow=2,align = 'v',labels = c('(a)','(b)'))

CD = ggarrange(C,D,ncol=2,nrow=1,align = 'h',labels = c('(c)','(d)'))

ggarrange(AB,CD,ncol=1,nrow=2,align = 'v',heights=c(2/3,1/3))
