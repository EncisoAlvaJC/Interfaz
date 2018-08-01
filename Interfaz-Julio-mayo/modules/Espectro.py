# -*- coding: utf-8 -*-
"""
Created on Wed Feb 28 05:31:04 2018

@author: Clandestina
"""

import pyqtgraph as pg
from PyQt5.QtWidgets import (QVBoxLayout, QHBoxLayout, QPushButton, QFileDialog, QMessageBox,QTableWidget,QTableWidgetItem, QWidget, QSplitter, QFormLayout, QComboBox)#, QTabWidget, QVBoxLayout, QWidget)
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPainterPath
import os
from rpy2.robjects.packages import STAP
import rpy2.robjects as robjects
import numpy as np


class Espectro(QVBoxLayout):
    
    def __init__(self):      
        super().__init__()
        self.initUI()
    
#%%
    def showDialog(self):
        print("En show dialog")
        if((self.data_dir!='')&(self.result_dir!='')):
            grupo_de=[]
            frecuenciasss=[]
            tam = self.table.rowCount()
            self.sizeEpo = self.sizes[self.cmbEpoch.currentIndex()]
            for i in range(tam):
                grupo_de.append(int(self.table.item(i,3).text()))
                frecuenciasss.append(int(self.table.item(i,4).text()))
            grupo_de = robjects.IntVector(grupo_de)
            frecuenciasss = robjects.IntVector(frecuenciasss)
            print(self.data_dir) # 'D:/DIART/Estancia/JULIO/datos/DATA/'
            print(os.getcwd() + '/')
            print(self.result_dir)# = 'D:/DIART/Estancia/JULIO/datos/RESULTADOS/'
            self.dir_res= self.result_dir
            print(self.dir_res)# = 'D:/DIART/Estancia/JULIO/datos/RESULTADOS/'
            print(self.nom_dir)# = (['GURM_revisado'])
            print(self.nom_arch) # = (['GURM251148SUE'])
            print(self.nom_facil) # = (['GUR'])
            print(grupo_de) # (0)
            print(frecuenciasss) #(200)
            print(self.sizeEpo) #(120)
            
            with open('ejecutable_espectro06_func.R', 'r') as f: string = f.read()
            espectro = STAP(string, "multiespectro")
            espectro.ejecutable_espectro(self.data_dir, os.getcwd() + '/', self.dir_res, self.result_dir, self.nom_dir, self.nom_arch, self.nom_facil, grupo_de, frecuenciasss, self.sizeEpo)
        else:
            QMessageBox.critical(None, "Alerta","Debes seleccionar un directorio de datos y otro para salvar resultados ", QMessageBox.Ok)
            
#%%
    def openFiles(self, bot):
        print("EN OPEN FILES")
        if (bot == 1):
            self.data_dir = QFileDialog.getExistingDirectory(None, 'Open Directory', '/home') 
            self.data_dir = self.data_dir + '/'
            print(self.data_dir)
            self.nom_dir = os.listdir(self.data_dir)
            print(self.nom_dir)
            for i in self.nom_dir:
                elemento = os.listdir(self.data_dir+"/"+i)[0]
                elemento = str.split(elemento,'_')[0]
                self.nom_arch.append(elemento)
                self.nom_facil.append(elemento[0:3])
            print(self.nom_arch)
            print(self.nom_facil)
        elif (bot == 2):
            self.result_dir = QFileDialog.getExistingDirectory(None, 'Open Directory', '/home') 
            self.result_dir = self.result_dir + '/'
            print(self.result_dir)

#%%
    def llenarTabla(self):
        filas=len(self.nom_facil)
        self.table.setRowCount(filas)
        self.table.setColumnCount(5)
        for i in range(filas):
            self.table.setItem(i,0,QTableWidgetItem(self.nom_dir[i]))
            self.table.setItem(i,1,QTableWidgetItem(self.nom_arch[i]))
            self.table.setItem(i,2,QTableWidgetItem(self.nom_facil[i]))
            self.table.setItem(i,3,QTableWidgetItem(""))
            self.table.setItem(i,4,QTableWidgetItem(""))
    
#%%
    def recuperaSujeto(self):
        self.sizeEpo = self.sizes[self.cmbEpoch.currentIndex()]
        print("En ress")
        rowTable = self.table.currentRow()
        print("1")
        sujeto=rowTable+1
        frecuenciasss=(512)#self.table.itemAt(rowTable,4).text()
        nombres = [self.table.item(rowTable,1).text()]#(['GURM251148SUE'])
        etiqueta = [self.table.item(rowTable,2).text()]# (['GUR'])
        directorio = self.nom_dir#self.data_dir+self.nom_dir
        res = self.result_dir
        with open(self.actual_dir+'\colorcitos_usable02.R', 'r') as f: string = f.read()
        colorcitos = STAP(string, "colorcitos")

        imagen = colorcitos.colorcitos(sujeto, frecuenciasss, nombres, etiqueta, directorio, res, self.sizeEpo)
        imagen = np.asmatrix(imagen)
        imagen=np.asarray(imagen)
        cont=0
        tamX = imagen.shape[1]
        self.p1.setXRange(-0.5, tamX+0.5)
        
        ejeX =[]
        for i in  range(int(self.sizeEpo)):
            ejeX.append(i*self.sizeEpo)
        
        for i in range(21,-1,-1):
            x=np.where(imagen[i,:]>0)
            ta=len(x[0])
            x=x[0]
            self.spis[cont].setData(x, cont + 0.5 + np.zeros((ta,)))
            cont=cont+1
        self.lblTit.setText("<span style='font-size: 12pt; color : black'> <b>Sujeto: %s</b></span>"%  self.table.item(rowTable,1).text())

        
        self.p1.plot()

#%%           
    def initUI(self):
        pg.setConfigOption('background', 'w')
        self.actual_dir=os.getcwd()
        self.lblTit = pg.LabelItem(justify='right')
        
#        self.lblTit.setText("Hola")
        #Variables
        self.data_dir=''
        self.result_dir=''
        self.nom_dir = []
        self.nom_arch=[]
        self.nom_facil = []
        self.sizes = np.asarray([120, 60, 30, 15, 7.5, 3.75, 1.875, 0.9375])

        buttons = QHBoxLayout()
        datos = QVBoxLayout()
        contain=QSplitter(Qt.Horizontal)
        ima = QVBoxLayout()
        
        self.glw = pg.GraphicsLayoutWidget(border=(100,100,100))
        self.glw.useOpenGL(True)
        self.glw.addItem(self.lblTit, col=1, colspan=4)
        self.glw.nextRow()
        self.glw.addLabel('Canales', angle=-90, rowspan=3)
        
        
        
        
        self.p1 = self.glw.addPlot(row=1, col=1)

        self.p1.setLimits(yMin=-0.5)
        self.p1.setLimits(yMax=26.5)
        


        self.lytEpoch = QFormLayout()
        self.cmbEpoch = QComboBox()
        self.cmbEpoch.addItem("120")
        self.cmbEpoch.addItem("60")
        self.cmbEpoch.addItem("30")
        self.cmbEpoch.addItem("15")
        self.cmbEpoch.addItem("7.5")
        self.cmbEpoch.addItem("3.75")
        self.cmbEpoch.addItem("1.875")
        self.cmbEpoch.addItem("0.9375")
        
        self.lytEpoch.addRow("Epoch size: ", self.cmbEpoch)

        btn_data_dir = QPushButton('Load Files')        
        btn_data_dir.clicked.connect(lambda: self.openFiles(1))
        
        btn_result_dir = QPushButton('Save Results')
        btn_result_dir.clicked.connect(lambda: self.openFiles(2))
        
        btn_do = QPushButton('Do')
        btn_do.clicked.connect(self.llenarTabla)
        
        self.table = QTableWidget()
        
        btn_make = QPushButton('Processing')
        btn_make.clicked.connect(self.showDialog)
        
        btn_showSujeto = QPushButton('Sujeto')
        btn_showSujeto.clicked.connect(self.recuperaSujeto)
        
        datos.addLayout(self.lytEpoch)
        buttons.addWidget(btn_data_dir)
        buttons.addWidget(btn_result_dir)
        buttons.addWidget(btn_do)
        datos.addLayout(buttons)
        datos.addWidget(self.table)
        datos.addWidget(btn_make)
        datos.addWidget(btn_showSujeto)
        ima.addWidget(self.glw)

        bot = QWidget()
        bot.setLayout(datos)
        gra = QWidget()
        gra.setLayout(ima)
        
        
        contain.addWidget(bot)
        contain.addWidget(gra)
        self.addWidget(contain)