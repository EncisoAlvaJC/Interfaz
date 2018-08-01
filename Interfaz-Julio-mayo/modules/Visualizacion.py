# -*- coding: utf-8 -*-
"""
Created on Wed Feb 28 05:31:04 2018

@author: Clandestina
"""

import pyqtgraph as pg
from PyQt5.QtWidgets import (QVBoxLayout, QPushButton, QFileDialog, QMessageBox,QWidget, QSplitter, QFormLayout, QComboBox, QLineEdit, QLabel)
from PyQt5.QtCore import Qt
import os
import pandas as pd

import numpy as np


class Visualizacion(QVBoxLayout):
    
    def __init__(self):      
        super().__init__()
        self.initUI()
    
#%%
    def showDialog(self):
        if((self.data_dir!='')&(self.nom_dir!='')):
            s=pd.read_csv(self.data_dir+self.nom_dir[0])
            s=np.asarray(s)
            sizeEpo = self.sizes[self.cmbEpoch.currentIndex()]
            self.puntos = int(self.txtFrec.text())*sizeEpo
            self.tam = len(s)//self.puntos
            print("Tamanio: ", self.tam)
            self.Epos = np.arange(self.tam)+1
            
            for i in range(int(self.tam)):
                self.cmbEpo.addItem(str(i+1))
            
            self.grafi = np.zeros((22,self.puntos))
            self.graficaX()
        else:
            QMessageBox.critical(None, "Alerta","Debes seleccionar un directorio de datos y otro para salvar resultados ", QMessageBox.Ok)
            
#%%
    def openFile(self, bot):
            self.data_dir =  QFileDialog.getExistingDirectory(None, 'Open Directory', '/home') 
            self.data_dir = self.data_dir + '/'
            self.nom_dir = os.listdir(self.data_dir)
            self.lblDataDir.setText(self.data_dir)

#%%
    def graficaX(self):
        self.glw.clear()
        pos = int(self.Epos[self.cmbEpo.currentIndex()])
        print("Iniciando actualización")
        for i in range(22):
            s=pd.read_csv(self.data_dir+self.nom_dir[i])
            s=np.asarray(s)
            ini=(pos-1)*self.puntos
            fin=pos*self.puntos
            self.grafi[i,:] = s[ini:fin].reshape((self.puntos,))
        curves = []
        for i in range(22):
            c = pg.PlotCurveItem(pen=(i,22*1.3), width=2)
            self.glw.addItem(c)
            c.setPos(0,i*100)
            curves.append(c)
        lin=self.puntos/(15*int(self.txtFrec.text()))+1
        x=np.linspace(0,self.puntos,lin)
        if(self.sizes[self.cmbEpoch.currentIndex()] != 15):
            for i in x:
                self.glw.addLine(i, movable=False)
            print("Division", )
        
        ptr = 0
        for i in range(22):
            curves[i].setData(self.grafi[(ptr+i)%self.grafi.shape[0]])
            ptr += 22
        print("Finalizando actualizacion")


#%%           
    def initUI(self):
#        pg.setConfigOption('background', 'w')
        self.lblTit = pg.LabelItem(justify='right')
        #Variables
        self.data_dir=''
        self.nom_dir = []
        self.numEp=1
        self.grafi=[]
        self.tam=0
        self.puntos=0

        self.sizes = np.asarray([120, 60, 30, 15])

        datos = QVBoxLayout()
        contain=QSplitter(Qt.Horizontal)
        ima = QVBoxLayout()
        
        self.glw = pg.PlotWidget()

        btn_data_dir = QPushButton('Load Files')        
        btn_data_dir.clicked.connect(self.openFile)
        
        self.lblDataDir=QLabel('')
        
        self.lytEpoch = QFormLayout()
        self.cmbEpoch = QComboBox()
        self.cmbEpoch.addItem("120")
        self.cmbEpoch.addItem("60")
        self.cmbEpoch.addItem("30")
        self.cmbEpoch.addItem("15")
        self.lytEpoch.addRow("Epoch size: ", self.cmbEpoch)
        
        self.lytFrec = QFormLayout()
        self.txtFrec = QLineEdit('200')
        self.lytFrec.addRow("Frecuencia: ",self.txtFrec)
        
        btn_do = QPushButton('DO')        
        btn_do.clicked.connect(self.showDialog)
        
        self.lytEpo = QFormLayout()
        self.cmbEpo = QComboBox()
        self.cmbEpo.setCurrentIndex=1
        self.cmbEpo.activated[str].connect(self.graficaX)
        self.lytEpo.addRow("Número de época: ", self.cmbEpo)

        datos.addWidget(btn_data_dir)
        datos.addWidget(self.lblDataDir)
        datos.addLayout(self.lytEpoch)
        datos.addLayout(self.lytFrec)
        datos.addWidget(btn_do)
        
        ima.addWidget(self.glw)
        ima.addLayout(self.lytEpo)

        bot = QWidget()
        bot.setLayout(datos)
        gra = QWidget()
        gra.setLayout(ima)
        
        
        contain.addWidget(bot)
        contain.addWidget(gra)
        self.addWidget(contain)