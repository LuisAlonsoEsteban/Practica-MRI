### Grandes Equipamientos Médicos
### Máster en Ingeniería Biomédica
### Tecnun - Universidad de Navarra
# Practica MRI
### Autores: Mikel Catalina Olazaguirre, Susana del Riego Gómez y Luis Alonso Esteban.
### Fecha: enero de 2023.


## Introducción
El objetivo de esta práctica es obtener los valores de T1, T2 y T2* a partir de distintas imágenes obtenidas utilizando una serie de gradientes y diferentes tiempos de eco y repetición. Las imágenes proporcionadas han sido adquiridas por el equipo de resonancia magnética de 1.5T Symphony de la CUN. Las imágenes son de un corte de un fantoma (_Essential System Phantom, CaliberMRI_) y de una fruta.

Este repositorio cuenta con los siguiente ficheros y directorios:
1. _1_ImgSymphony_ (dir): directorio con imágenes (en formato _.dicom_) obtenidas por Resonancia Magnética de un fantoma y de una fruta, potenciadas en T1, T2 y T2*.
2. _practicaMRI__MCO_SDG_LAE.mat_: fichero de Matlab con el código de la práctica. El código ha sido desarrollado para ser **ejecutado por secciones (Ctrl + Enter)**. Si se ejecuta el código entero y se han seleccionado las ímagenes de la fruta, devuelve un error; en cambio, si se ejecutan las imágenes del fantoma, se puede ejecutar todo el código sin que salte ningún error.
3. _roisT1.mat_: variable de Matlab que contiene la matriz con las máscaras de las 14 regiones de interés (a partir de ahora ROIs), de las imágenes potenciadas en T1.
4. _roisT2.mat_: variable de Matlab que contiene la matriz con las máscaras de las 14 ROIs, de las imágenes potenciadas en T2.
5. _roisT2star.mat_: variable de Matlab que contiene la matriz con las máscaras de las 14 ROIs, de las imágenes potenciadas en T2*.

## Secciones
El código de la práctica (_practicaMRI__MCO_SDG_LAE.mat_) se divide en 4 secciones:
1. **"Instruction to read files".** Esta sección lee las imágenes (del fantoma o de la fruta, potenciadas en T1, T2 o T2*), las almacena en un _struct_ y prepara el "Workspace" para el procesamiento posterior de las imágenes.
2. **"Create variables with ROIs".** En el caso de que las ROIs no estén guardadas en las variables _roisT1.mat_, _roisT2.mat_ o _roisT2star.mat_, o que el usuario prefiera volver a definirlas, se pueden definir manualmente estas ROIs.
3. **"Phantom: ROIs".** Esta sección calcula la constante de tiempo (T1, T2 o T2*) de la magnetización longitudinal o transversal en las 14 ROIs, representando la exponencial. Esta sección solo está disponible para el caso de haber seleccionado las imágenes del fantoma. En el caso contrario y de no haber ejecutado el código por secciones, se detiene la ejecución avisando de que esta sección no está disponible para las imágenes de la fruta.
5. **"Phantom and Fruit: pixel by pixel".** Esta sección genera un mapa de valores de la misma constante de tiempo (T1, T2 o T2*), representándola para el material de cada uno de los píxeles.

El procedimiento más detallado de las últimas dos secciones ha sido documentado en el propio fichero.

## GitHub
Si desea clonar el repositorio directamente, utilizar el comando:
```
git clone https://github.com/LuisAlonsoEsteban/Practica-MRI.git
```
