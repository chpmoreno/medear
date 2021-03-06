
#' @title Poblaciones y cartografia por seccion censal del INE (proyecto MEDEA3)
#'
#' @description Paquete que contiene las funciones y los datos utilizados para
#'   llevar a cabo el proyecto MEDEA3, incluyendo los datos de poblaci�n por
#'   sexo y grupos de edad para las ciudades implicadas en el proyecto a nivel
#'   de secci�n censal. Aunque algunos datos de poblaci�n est�n encriptados por
#'   tratarse de consultas espec�ficas realizadas al Instituto Nacional de
#'   Estad�stica -INE- (se puede acceder a ellos mediante contrase�a), los datos
#'   desde 2006 son de libre acceso siguiendo la licencia del INE.
#'
#' @details El uso habitual del paquete ser� la carga de datos o de la
#'   cartografia (\code{\link[utils]{data}}) y su preparaci�n para unir las
#'   secciones seg�n el rango de a�os que se desee (funci�n
#'   \code{\link{une_secciones}}), o la georreferenciaci�n de la mortalidad
#'   (\code{\link{geocodificar_cartociudad}} y
#'   \code{\link{geocodificar_google}}). En todo caso, se ofrece la fecha de la
#'   �ltima actualizaci�n de los datos (siempre que est� disponible) como un
#'   atributo de los objetos.
#'
#'   Un uso potencial puede ser la preparaci�n de consultas personalizadas para
#'   ciudades o provincias completas, por lo que el paquete ofrece todas las
#'   funciones necesarias para descargar los datos y la cartograf�a directamente
#'   desde el INE y trabajarlos para obtener el producto final. En este sentido,
#'   las funciones deber�an ejecutarse en el siguiente orden:
#'
#'   \describe{\item{\code{\link{descarga_cartografia}}}{Descarga de la
#'   cartograf�a nacional por secci�n censal para el a�o 2011 en formato SHP.}
#'   \item{\code{\link{descarga_poblaciones}}}{Descarga de la poblaciones por
#'   secci�n censal, sexo y grupos de edad (disponibilidad desde 2006 en
#'   adelante).} \item{\code{\link{descarga_trameros}}}{Descarga de los trameros
#'   para las provincias indicadas en los a�os marcados (disponible desde 2004
#'   en adelante).} \item{\code{\link{detecta_cambios}}}{Identifica los cambios
#'   de secci�n censal comparando el tramero de 2011 con el de otros a�os.}
#'   \item{\code{\link{une_secciones}}}{Habiendo obtenido los cambios en el
#'   seccionado, se realiza la uni�n de las secciones en la cartograf�a y en las
#'   cifras de poblaci�n.} }
#'
#'   Por otra parte, el paquete incorpora una serie de funciones para efectuar
#'   la georreferenciaci�n de la mortalidad, siguiendo el protocolo disponible
#'   como vi�eta dentro del paquete (accesible mediante
#'   \code{vignette("medear-georreferenciacion")}):
#'
#'   \describe{\item{\code{\link{geocodificar_cartociudad}}}{Implementaci�n del
#'   algoritmo de geocodificaci�n de direcciones de MEDEA3 (geocodificado con
#'   CartoCiudad).} \item{\code{\link{geocodificar_google}}}{Implementaci�n del
#'   algoritmo de geocodificaci�n de direcciones de MEDEA3 (geocodificado con
#'   Google).} }
#'
#'   En �ltimo lugar, el paquete dispone de varios bancos de datos de uso
#'   frecuente en el proyecto:
#'
#'   \describe{\item{\code{\link{cartografia}}}{Cartografia por seccion censal
#'   para las ciudades MEDEA3.} \item{\code{\link{poblacion}}}{Datos de
#'   poblacion por seccion censal para las ciudades MEDEA3 (periodo 2004-2015:
#'   si desea cargarse el per�odo 1996-2015, usar la funci�n
#'   \code{\link{carga_datos}}).} \item{\code{\link{secciones}}}{Secciones
#'   censales �nicas por per�odo (1996-2015).}
#'   \item{\code{\link{cambios_seccion}}}{Cambios de seccionado para las
#'   ciudades MEDEA3 (per�odo 1996-2015).}
#'   \item{\code{\link{codigos_ine}}}{C�digos y nombres de municipios y
#'   provincias seg�n terminolog�a oficial del INE.} }
#'
#'   Fuente: Elaboraci�n propia con datos extra�dos del \href{www.ine.es}{sitio
#'   web del INE}.
#'
#'   Licencia: Los datos contenidos en este paquete han sido extra�dos desde el
#'   \href{www.ine.es}{sitio web del INE} y modificados de acuerdo a las
#'   necesidades del proyecto, quedando sujeto su uso a la
#'   \href{www.ine.es/ss/Satellite?L=0&c=Page&cid=1254735849170&p=1254735849170&pagename=Ayuda\%2FINELayout#}{licencia
#'    INE}.
#'
#'   Exenci�n de responsabilidad: El INE no ha participado en la elaboraci�n de
#'   este paquete.
#'
#' @seealso \code{\link{descarga_cartografia}},
#'   \code{\link{descarga_poblaciones}}, \code{\link{descarga_trameros}},
#'   \code{\link{detecta_cambios}}, \code{\link{une_secciones}},
#'   \code{\link{geocodificar_cartociudad}}, \code{\link{geocodificar_google}},
#'   \code{\link{cartografia}}, \code{\link{poblacion}},
#'   \code{\link{secciones}}, \code{\link{cambios_seccion}},
#'   \code{\link{codigos_ine}}
#'
#' @references \describe{\item{\href{www.ine.es/}{Sitio web del INE.}}{}
#'   \item{\href{www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177012&menu=resultados&secc=1254736195461&idp=1254734710990}{Poblaci�n
#'    por secciones censales.}}{}
#'   \item{\href{http://www.ine.es/censos2011_datos/cartografia_censo2011_nacional.zip}{Cartograf�a
#'    de secciones censales a 1 de noviembre de 2011 en formato SHP.}}{}}
#'
#' @name medear-package
#'
#' @docType package
#'
#' @keywords package
#'
#' @encoding UTF-8
#'
#' @import data.table sp
#'
"_PACKAGE"
