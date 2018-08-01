# -*- coding: utf-8 -*-
"""
Created on Wed Feb 28 05:20:33 2018

@author: Clandestina
"""

from PyQt5.QtWidgets import QWidget, QTabWidget, QVBoxLayout
# Custom Dependencies
from modules.Visualizacion import Visualizacion
from modules.Estacionariedad import Estacionariedad
from modules.Espectro import Espectro
import rpy2.robjects.packages as rpackages
from rpy2.robjects.packages import STAP
import rpy2.robjects as robjects
from rpy2.robjects.vectors import StrVector

class vistaPrincipal(QWidget):
 
    def __init__(self, parent):   
        super(QWidget, self).__init__(parent)
        utils = rpackages.importr('utils')
        utils.chooseCRANmirror(ind=1)
        packnames=('plotrix', 'psd', 'fractal', 'squash', 'doParallel')
        for x in packnames:
            if (not rpackages.isinstalled(x)):
                utils.install_packages(x)
            
        #self.layout es una ventana contenedora
        self.layout = QVBoxLayout(self)
 
        # Initialize tab screen
        #self.tabs es un elemento que soporta la contención de pestañas
        self.tabs = QTabWidget()
        
        #Pestañas
        self.tabVis = QWidget()
        self.tabEst = QWidget()
        self.tabEsp = QWidget()


        # Content Tabs 
        self.tabVisLayout = Visualizacion()
        self.tabEstLayout = Estacionariedad()
        self.tabEspLayout = Espectro()


        # Add tabs
        self.tabs.addTab(self.tabVis,"Visualization")
        self.tabs.addTab(self.tabEst,"Estacionariedad")
        self.tabs.addTab(self.tabEsp,"Espectro")
 
        # Set asing layout
        self.tabVis.layout = self.tabVisLayout
        self.tabEst.layout = self.tabEstLayout
        self.tabEsp.layout = self.tabEspLayout
        
        # SetLayout Tabs 
        self.tabVis.setLayout(self.tabVis.layout)
        self.tabEst.setLayout(self.tabEst.layout)
        self.tabEsp.setLayout(self.tabEsp.layout)
 
        # Add tabs to Main
        self.layout.addWidget(self.tabs)
        self.setLayout(self.layout)