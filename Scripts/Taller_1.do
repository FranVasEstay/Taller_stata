*******************************************************
*     Curso: Introducción a la Bioestadística          *
*     Magíster en Salud Pública - Año 2025             *
*******************************************************
*    Informe 1: Análisis exploratorio y descriptivo    *
*               de datos en Stata                      *
*******************************************************

clear all
set more off
* Definir directorio de trabajo donde guardaremos archivos .do, .log, base y gráficos.
cd "C:\Users\Kibif\Desktop\Master en Salud Pública\1°Semestre\Bioestadística\Talleres\Taller grupal\Taller_stata"
// Aquí tienen que ubicarse en el repositorio local
capture mkdir "Data"
capture mkdir "Scripts"
capture mkdir "Figures"
capture mkdir "Trash"

* Con esto cierro el log anterior:
capture log close 
* Con esto abro un nuevo log:
log using "Informe_taller1.log", replace text

* Importar base formato .csv (delimited es para valores separados por comas)
import delimited "Data/Serie_Nacimientos_2020_2022.csv", clear 

* Guardar base en formato .dta
save "Data/Base_original.dta", replace

*******************************************************
* Análisis exploratorio
*******************************************************
* Descripción general de la base de datos
describe
* Nos quedamos sólo con los datos de la región que nos tocó
keep if region_residencia == 6

* Filtrar por madres extranjeras
tab nacionalidad_madre // Para revisar cómo está codificada
keep if nacionalidad_madre == "E" // Nos quedamos sólo con las extranjeras

* Verificación de variables relevantes
describe
tab nacionalidad_madre
tab grupo_etario_madre
tab nivel_madre
tab est_civ_madre
tab activ_madre

* Recodificación de variables y añadir etiquetas
* Edad de la madre (convertir grupo_etario_madre a numérico)
encode grupo_etario_madre, gen(grupo_etario_madre_num)
label define grupo_etario_lbl 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49" 8 "50+" 9 "<15" 10 "NE"
label values grupo_etario_madre_num grupo_etario_lbl
* Edad de la padre (convertir grupo_etario_padre a numérico)
encode grupo_etario_padre, gen(grupo_etario_padre_num)
label values grupo_etario_padre_num grupo_etario_lbl
* Actividad madre
label define activ_lbl 0 "Inactiva/o" 1 "Ocupada/o" 2 "Cesante o desocupada/o" 9 "Ignorado"
label values activ_madre activ_lbl
* Actividad padre
label values activ_padre activ_lbl
* Nivel educacional madre
label define nivel_lbl 1 "Superior" 2 "Medio" 3 "Secundaria" 4 "Básico o Primario" 5 "Ninguno" 9 "Ignorado"
label values nivel_madre nivel_lbl
* Nivel educacional padre
label values nivel_padre nivel_lbl
* Estado civil madre
label define civil_lbl 1 "Soltera" 2 "Casada" 3 "Viuda" 4 "Divorciada" 5 "Separada Judicial" 6 "Conviviente Civil" 9 "Ignorado"
label values est_civ_madre civil_lbl

* Usar sólo las siguiente variables
keep grupo_etario_madre_num grupo_etario_padre_num activ_madre activ_padre nivel_madre nivel_padre est_civ_madre nacionalidad_madre

* ordenar la base de datos por el grupo_etario_madre_num
sort grupo_etario_madre_num
* Crear variable identificadora
gen id = _n

* Guardar base de datos modificada en formato .dta
save "Data/Data_taller1.dta", replace

*******************************************************
* ANÁLISIS DESCRIPTIVO
*******************************************************
**********************************************************
* Exportar tabla de frecuencias para variables categóricas
**********************************************************
// Las líneas con // No se usaron en el informe final
*Grupo etario madre
table grupo_etario_madre_num, statistic(frequency) statistic(percent)
collect export "tabla_grupo_edad.docx", replace

* Actividad madre
table activ_madre
collect export "Figures/Tabla_ActividadMadre.docx", replace

* Nivel educacional madre
table nivel_madre, collect
collect export "Figures/Tabla_NivelMadre.docx", replace

* Estado civil madre
table est_civ_madre
collect export "Figures/Tabla_CivilMadre.docx", replace

* Actividad padre
table activ_padre, collect
collect export "Figures/Tabla_ActividadPadre.docx", replace

* Nivel educacional padre
table nivel_padre, collect
collect export "Figures/Tabla_NivelPadre.docx", replace
	
* Tabla de resumen general
//collect clear
* Tabla sociodemográfica
//table grupo_etario_madre_num nivel_madre activ_madre est_civ_madre, ///
//    statistic(frequency) ///
//    nformat(%9.0fc) ///
//    nototal 

//collect export "Figures/Tabla_Perfil_Madres.docx", replace // Exporta en word
// Esta tabla es gigante y poco informativa
*******************************************************
* Gráficos descriptivos
*******************************************************
* Gráficos de barras para variables categóricas
//graph bar (count), over(grupo_etario_madre_num) ///
//    title("Frecuencia por grupo etario madre") ///
//    ytitle("Frecuencia") ///
//    blabel(bar, size(medium))
//graph export "Figures/Barra_GrupoEtarioMadre.png", replace

//graph bar (count), over(nivel_madre) ///
//    title("Frecuencia por nivel educacional madre") ///
//    ytitle("Frecuencia") ///
//    blabel(bar, size(medium))
//graph export "Figures/Barra_NivelEduMadre.png", replace

//graph bar (count), over(activ_madre) ///
//    title("Frecuencia por actividad madre") ///
//    ytitle("Frecuencia") ///
//    blabel(bar, size(medium))
//graph export "Figures/Barra_ActividadMadre.png", replace

graph bar (count), over(est_civ_madre) ///
    title("Frecuencia por estado civil madre") ///
    ytitle("Frecuencia") ///
    blabel(bar, size(medium))
graph export "Figures/Barra_EstadoCivilMadre.png", replace

* Gráficos de torta para nivel educacional madre
//graph pie, over(nivel_madre) plabel(_all percent) ///
//    title("Distribución nivel educacional madre")
//graph export "Figures/Pie_NivelEduMadre.png", replace

* Gráficos de torta para estado civil madre
//graph pie, over(est_civ_madre) plabel(_all percent) ///
//    title("Distribución estado civil madre")
//graph export "Figures/Pie_EstadoCivilMadre.png", replace

* Gráfico agrupado para nivel educativo/distribución de edad

label define nivel_simple_lbl_2 1 "S." 2 "M." 3 "Sec." 4 "B." 5 "N." 9 "I." // Redefinir etiquetas para que no se colapsen en el gráfico
label values nivel_madre nivel_simple_lbl_2

graph bar (count), ///
    over(nivel_madre, gap(5)) over(grupo_etario_madre_num, gap(0)) ///
    ascategory ///
    bar(1, color(blue)) /// intenté poner colores pero no funcionó :c 
    bar(2, color(orange)) ///
    bar(3, color(green)) ///
    bar(4, color(red)) ///
    bar(5, color(gs10)) ///
    bar(6, color(gs12)) ///
    legend(order(1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40+")) ///
    title("Nivel educativo por grupo etario de madres extranjeras") ///
    ytitle("Frecuencia") ///
    graphregion(color(white)) ///
    name(graf2, replace)

graph export "Figures/Grafico_NivelEducativo_EdadMadre.png", width(3000) height(1800) replace

label define act_simple_lbl_1 0 "I." 1 "A." 2 "C." 9 "NE" // Redefinir etiquetas para que no se colapsen en el gráfico
label values activ_madre act_simple_lbl_1
* Gráfico apilado: Ocupación según grupo etario
graph bar (count), ///
    over(activ_madre, gap(5)) over(grupo_etario_madre_num, gap(0)) ///
    stack ///
    title("Condición de ocupación por grupo etario") ///
    ytitle("Frecuencia") ///
    legend(label(1 "Ocupada") label(2 "Desocupada") label(3 "Inactiva") ///
           label(4 "Ignorado") size(small) pos(6) ring(0)) ///
    graphregion(color(white)) ///
    name(graf3, replace)
graph export "Figures/Grafico_Ocupacion_EdadMadre.png", width(3000) height(1800) replace
*******************************************************
* Cierre del log
*******************************************************
save "Data/Data_taller1.dta", replace

log close