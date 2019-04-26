# PPGpeakDetection1

#ORGANIZACION DE FOLDERS

#ARCHIVOS EXTRA: Contiene códigos de prueba del año 2018 -2019
#Noiseproofs: Contiene archivos para detectar picos manualmente, parametrizado, detrending y funciones de obtención de modelo savitzky, bpm
#GeneralNoise: El archivo Main_Total_Noise contiene 3 modelos de ruido artificial: LPC linear predictor, MA Mobile Average, Savitzky-Golay y Modelo GMA Gaussian based on Mobile Average 

#Se han borrado ciertas funciones de GeneralNoise que tambien se encuentran en NoiseProofs para no confundirse, simplemente se le ha cambiado el path.

#db: Contiene la base de datos IEEE Signal Processing Cup usada por Zhang en TROIKA y por nosotros en la obtencion del modelo de ruido

#db-2015Challenge: Contiene la base de datos de Taqui-Bradicardias las cuales eran 5 tipos pero se optan por 3 que son los más diferenciados de los 5: Bradicardia, Taquicardia y Taquicardia Ventricular (estos dos ultimos se considerarán iguales en el código)

#GaussianNoise: Este folder contiene los archivos necesarios para crear el modelo de ruido Gaussiano, algunos que no se usan, sin embargo no se borran, como por ejemplo el BestSensitivityFinder 
