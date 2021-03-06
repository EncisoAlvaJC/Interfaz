#    INTERCANALES

###############################################################################
###############################################################################
kanales  = read_excel(paste0(dir_info,'/info_intercanales.xlsx'),
                      sheet='Alfabetico')
if(orden_stam){
  kanales  = read_excel(paste0(dir_info,'/info_intercanales.xlsx'),
                        sheet='Redes')
}
n.canales    = length(kanales$Etiqueta)
canales.arch = kanales$Nombre_archivo
###############################################################################
# cargar los datos
raw = read_excel(paste0(dir_res_pre,'/dfa_asdataframe.xlsx'),
                 sheet='redes')
raw = as.data.frame(raw)

Hurst.MOR           = melt(raw,id=c('Sujeto','Grupo','Edad',
                                    'MMSE','Neuropsi','Escol',
                                    'MORn','Epoca','Etapa'))
colnames(Hurst.MOR) = c('Sujeto','Grupo','Edad','MMSE','Neuropsi',
                        'Escol',
                        'MORn','Epoca','Etapa','Canal_var','Hurst')
Hurst.MOR$Canal_var = as.numeric(Hurst.MOR$Canal_var)
Hurst.MOR$Sujeto_n  = factor(Hurst.MOR$Sujeto,labels = info$Nombre)
Hurst.MOR$Etapa     = rep(1,length(Hurst.MOR$Sujeto))

Hurst.MOR = Hurst.MOR[!is.na(Hurst.MOR$Hurst),]
Hurst.MOR = Hurst.MOR[Hurst.MOR$Grupo>-1,]

sujetos = setdiff(unique(Hurst.MOR$Sujeto),11)

if(usar.log){
  Hurst.MOR$Hurst     = log(Hurst.MOR$Hurst)
  Hurst.promedio$Hurst = log(Hurst.promedio$Hurst)
}
Hurst.MOR.promedio = c()
for(suj in sujetos){
  tmp       = Hurst.MOR[grep(info$Nombre[suj],Hurst.MOR$Sujeto_n),]
  promedios = aggregate(tmp,by=list(tmp$Canal_var),mean)
  Hurst.MOR.promedio = rbind(Hurst.MOR.promedio,promedios)
}

# problemas con etiquetas
Hurst.MOR$Canal_var          = factor(Hurst.MOR$Canal_var,
                                      labels=kanales$Etiqueta)
Hurst.MOR$Grupo              = factor(Hurst.MOR$Grupo,
                                      labels=c('CTL','MCI'))

Hurst.MOR.promedio           = as.data.frame(Hurst.MOR.promedio)
Hurst.MOR.promedio$Canal_var = factor(Hurst.MOR.promedio$Canal_var,
                                      labels=kanales$Etiqueta)
Hurst.MOR.promedio$Grupo     = factor(Hurst.MOR.promedio$Grupo,
                                      labels=c('CTL','MCI'))
Hurst.MOR.promedio$Sujeto_n = info$Nombre[Hurst.MOR.promedio$Sujeto]
promedios.MOR               = summarySE(Hurst.MOR.promedio,na.rm=T,
                                        measurevar='Hurst',
                                        groupvars=c('Grupo','Canal_var'))

###############################################################################
# lo mismo para NMOR
raw = read_excel(paste0(dir_res_pre,'/dfa_asdataframe.xlsx'),
                 sheet='redes_pre')
raw = as.data.frame(raw)

Hurst.NMOR           = melt(raw,id=c('Sujeto','Grupo','Edad',
                                     'MMSE','Neuropsi','Escol',
                                     'MORn','Epoca','Etapa'))
colnames(Hurst.NMOR) = c('Sujeto','Grupo','Edad','MMSE','Neuropsi','Escol',
                         'MORn','Epoca','Etapa','Canal_var','Hurst')
Hurst.NMOR$Canal_var = as.numeric(Hurst.NMOR$Canal_var)
Hurst.NMOR$Sujeto_n  = factor(Hurst.NMOR$Sujeto,labels = info$Nombre)
Hurst.NMOR$Etapa     = rep(0,length(Hurst.NMOR$Sujeto))

Hurst.NMOR = Hurst.NMOR[!is.na(Hurst.NMOR$Hurst),]
Hurst.NMOR = Hurst.NMOR[Hurst.NMOR$Grupo>-1,]

sujetos = setdiff(unique(Hurst.MOR$Sujeto),11)

if(usar.log){
  Hurst.NMOR$Hurst     = log(Hurst.NMOR$Hurst)
  Hurst.promedio$Hurst = log(Hurst.promedio$Hurst)
}
Hurst.NMOR.promedio = c()
for(suj in sujetos){
  tmp       = Hurst.NMOR[grep(info$Nombre[suj],Hurst.NMOR$Sujeto_n),]
  promedios = aggregate(tmp,by=list(tmp$Canal_var),mean)
  Hurst.NMOR.promedio = rbind(Hurst.NMOR.promedio,promedios)
}

# problemas con etiquetas
Hurst.NMOR$Canal_var          = factor(Hurst.NMOR$Canal_var,
                                       labels=kanales$Etiqueta)
Hurst.NMOR$Grupo              = factor(Hurst.NMOR$Grupo,
                                       labels=c('CTL','MCI'))
Hurst.NMOR.promedio           = as.data.frame(Hurst.NMOR.promedio)
Hurst.NMOR.promedio$Canal_var = factor(Hurst.NMOR.promedio$Canal_var,
                                       labels=kanales$Etiqueta)
Hurst.NMOR.promedio$Grupo     = factor(Hurst.NMOR.promedio$Grupo,
                                       labels=c('CTL','MCI'))
Hurst.NMOR.promedio$Sujeto_n = info$Nombre[Hurst.NMOR.promedio$Sujeto]
promedios.NMOR               = summarySE(Hurst.NMOR.promedio,na.rm=T,
                                         measurevar='Hurst',
                                         groupvars=c('Grupo','Canal_var'))

# combinacion
Hurst.MOR$Etapa  = rep('REM',length(Hurst.MOR$Etapa))
Hurst.NMOR$Etapa = rep('NREM',length(Hurst.NMOR$Etapa))
Hurst.todo       = rbind(Hurst.MOR,Hurst.NMOR)

Hurst.MOR.promedio$Etapa  = rep('REM',length(Hurst.MOR.promedio$Etapa))
Hurst.NMOR.promedio$Etapa = rep('NREM',length(Hurst.NMOR.promedio$Etapa))
Hurst.todo.promedio       = rbind(Hurst.MOR.promedio,Hurst.NMOR.promedio)

promedios.MOR$Etapa  = rep('REM',length(promedios.MOR$Grupo))
promedios.NMOR$Etapa = rep('NREM',length(promedios.NMOR$Grupo))
promedios.todo       = rbind(promedios.MOR,promedios.NMOR)

#rm(Hurst.MOR,Hurst.NMOR,Hurst.todo,promedios,raw,tmp)

###############################################################################

big.summary = c()

require('lemon')

promedios.todo$xx = kanales$x[promedios.todo$Canal_var]
promedios.todo$yy = kanales$y[promedios.todo$Canal_var]

ggplot(promedios.todo,aes(x=Etapa,y=Hurst,color=Grupo))+
  theme_classic2() +
  theme(legend.position='top') +
  ylab('Hurst exponent')+ xlab('Sleep stage')+
  geom_line(aes(group=Grupo))+
  scale_color_manual(values=c('blue','red'))+
  geom_errorbar(aes(ymin=Hurst-se,ymax=Hurst+se),width=0.05) +
  scale_x_discrete(expand = c(.25,0)) +
  scale_y_continuous(#expand=c(0,0),
                     breaks = c(1.1,1.2,1.3,1.4,1.5)) +
  #theme(legend.position='left',legend.direction = 'horizontal')+
  labs(color='Group') +
  facet_rep_grid((-yy)~xx)+
  geom_text(data=promedios.todo,aes(x=-Inf,y=-Inf,label=Canal_var),
            hjust=-.1,vjust=-1,colour='gray20')+
  theme(strip.text.y = element_blank()) +
  theme(strip.text.x = element_blank()) +
  geom_point(size=.1)

ggsave(filename='/cabeza_ANOVA_Hurst_redes.png',path=dir_graf,
       device='png',units='cm',width=9,height=7,dpi=400,scale=1.2)
ggsave(filename='/cabeza_ANOVA_Hurst_redes.eps',path=dir_graf,
       device='eps',units='cm',width=9,height=7,dpi=400,scale=1.2)
