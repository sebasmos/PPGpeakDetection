# PPGpeakDetection1
#ARTIFITIAL NOISE MODELING

#ORGANIZACION DE FOLDERS

#ARCHIVOS EXTRA: Contiene códigos de prueba del año 2018
#Noiseproofs: Contiene archivos para detectar picos manualmente, parametrizado, detrending y funciones de obtención de modelo savitzky, bpm
#GeneralNoise: El archivo Main_Total_Noise contiene 3 modelos de ruido artificial: LPC linea predictor, Average Mobile y savitzky.

#Se han borrado ciertas funciones de GeneralNoise que tambien se encuentran en NoiseProofs para no confundirse, simplemente se le ha cambiado el path.

#ArrhythmiaDetection: Contiene Arrhythmia_Main, se hacen pruebas en dataset a1065l con Bradicardias y Taquicardias, para determinar si el número de picos en señales originales son similares o parecidos al añadir ruido artificial Savitzky model 1. Se quita baseline para poder añadir correctamente ruido de bajas frecuencias del modelo 1.


#GaussianNoise: Este folder contiene todos los modelos generados por la distribución gaussiana al ser alimentada por diferentes tipos de señales. Hasta el momento tiene la mejor sensibilidad.
