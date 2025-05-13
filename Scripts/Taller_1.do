*******************************************************
*     Curso: Introducción a la Bioestadística          *
*     Magíster en Salud Pública - Año 2025             *
*******************************************************
*    Informe 1: Análisis exploratorio y descriptivo    *
*               de datos en Stata                      *
*******************************************************

clear all
* Definir directorio de trabajo donde guardaremos archivos .do, .log, base y gráficos.
cd "C:/Users/Usuario/Documents/Frantopia/Trabajo_grupal" // Aquí tienen que ubicarse en el repositorio local
capture mkdir "Directorio" // De aquí en adelante van a generarse carpetas de orden del directorio si es que no existen.
cd "Directorio"
capture mkdir "Data"
capture mkdir "Scripts"
capture mkdir "Figures"
capture mkdir "Trash"

* Con esto cierro el log anterior:
capture log close 
* Con es to abro un nuevo log:
log using "Informe_taller1.log", replace text

* Importar base formato .csv (delimited es para valores separados por comas)
import delimited "Data/Serie_Nacimientos_2020_2022.csv", clear 

* Guardar base en formato .dta
save "Data/Base_original.dta", replace


*******************************************************
* Análisis exploratorio
*******************************************************
* Visualizar la base
br
* Descripción general
describe
* Quiero que muestre sólo la región que nos toca
br if region_residencia == 15

* Nos quedamos sólo con los datos de la región que nos tocó
//keep if region_residencia == 
* Vemos de nuevo nuestra base pa cachar si salió todo bien
br
describe
// usaremos todas las variables? Elegir las variables a utilizar
// Existen varias variables categóricas que hay que traspasar a numérica si las necesitamos: 
* Rango_peso
* grupo_etario_padre
* ocupacion_padre
* grupo_etario_madre
* ocupacion_madre
* nacionalidad_madre
* glosa region_residencia (Esta debería quedar solo la que elegimos)


* Crear variable identificadora
gen id = _n


* Examinar estructura de variables
* ordenar la base de datos
* Revisar valores perdidos
* Limpiar valores extremos
* Recodificar
* Guardar base de datos modificada en formato .dta
save "Data/Data_taller1.dta", replace

*******************************************************
* Análisis descriptivo
*******************************************************

*******************************************************
* Exportar tabla de frecuencias a Word 
*******************************************************

*******************************************************
* Cierre del log
*******************************************************
log close