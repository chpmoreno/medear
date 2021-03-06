
#' @title Datos de poblacion por seccion censal para las ciudades MEDEA3
#'   (periodo 2004-2015)
#'
#' @description Datos de poblaci�n por sexo (0=Hombres, 1=Mujeres), edad (grupos
#'   quinquenales) y a�o (periodo 2004-2015) a nivel de secci�n censal para las
#'   ciudades de MEDEA3. Estos datos han sido descargados de la web del INE, que
#'   los publica de forma libre, y se pueden obtener usando la funci�n
#'   \code{\link{descarga_poblaciones}} de este paquete.
#'
#' @details Los c�digos de secci�n censal (columna \code{seccion} del
#'   \code{data.frame} \code{poblacion}) se corresponden con el identificador
#'   habitual de secciones censales seg�n el INE, es decir: los primeros dos
#'   d�gitos identifican la provincia, los siguientes tres d�gitos el municipio,
#'   los pr�ximos dos d�gitos el distrito y los �ltimos tres la secci�n censal.
#'   Los 5 primeros d�gitos de este identificador se corresponden con el c�digo
#'   INE del respectivo municipio.
#'
#'   Hasta el a�o 2010 (inclusive) el INE agrupa la �ltima categor�a de edad
#'   como 85 y m�s, mientras que desde el a�o 2011 llega hasta 100 y m�s. Los
#'   �ltimas columnas de \code{poblacion} tienen informaci�n detallada de los
#'   grupos de edad mayores para los a�os posteriores a 2010, por si esta
#'   pudiera ser de utilidad en alg�n momento. En cualquier caso, la casilla
#'   correspondiente al grupo de edad 85 y m�s para dichos a�os tambi�n tiene la
#'   informaci�n agregada para los grupos de edad mayores de 85, de la misma
#'   forma que los a�os anteriores.
#'
#'   El paquete \code{medear} dispone tambi�n de los datos para todo el periodo
#'   1996-2015 pero estos est�n encriptados ya que los datos para el periodo
#'   1996-2003 son propiedad del INE, que han sido adquiridos para uso exclusivo
#'   del proyecto MEDEA3. Estos datos son accesibles mediante la funci�n
#'   \code{\link{carga_datos}} que necesita una contrase�a de desencriptaci�n,
#'   que se har� disponible a todos los grupos del proyecto MEDEA. La llamada a
#'   \code{\link{carga_datos}} produce un data.frame con exactamente el mismo
#'   formato que \code{poblacion}, de hecho machaca dicho objeto, pero con la
#'   informaci�n adicional del periodo 1996-2005.
#'
#'   Notar que las poblaciones corresponden al seccionado censal de cada a�o por
#'   lo que algunas de las secciones censales consideradas pueden no tener
#'   informaci�n para todo el periodo 2004-2015 si es que dicha secci�n no ha
#'   existido durante todo este periodo. Este comentario tambi�n aplica a la
#'   funci�n \code{\link{carga_datos}}.
#'
#' @name poblacion
#'
#' @docType data
#'
#' @format Un objeto de clase \code{poblaciones_ine} donde las filas representan
#'   la combinaci�n de las distintas secciones censales de MEDEA3, sexos y a�os
#'   del periodo de estudio. Las cuatro primeras columnas son: \describe{
#'   \item{seccion}{C�digo de la secci�n censal.} \item{sexo}{0 hombres; 1
#'   mujeres.} \item{year}{A�o.} \item{medea3}{Pertenencia de la secci�n al
#'   proyecto MEDEA3.} } El resto de columnas representan los distintos grupos
#'   de edad. Todo objeto de la clase \code{poblaciones_ine} deber� tener este
#'   formato.
#'
#' @references \href{http://www.ine.es/}{ Sitio web del INE}.
#'
#'   \href{http://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177012&menu=resultados&secc=1254736195461&idp=1254734710990}{
#'    Poblaciones}.
#'
#' @encoding UTF-8
#'
#' @keywords datasets
#'
#' @seealso \code{\link{descarga_poblaciones}}, \code{\link{carga_datos}}
#'
#' @examples
#'
#' \dontrun{
#'   library(medear)
#'   data("poblacion")
#'
#'   # Informaci�n de poblaciones de la secci�n censal 01001 de Valencia (c�digo INE 46250)
#'   poblacion[poblacion$seccion == "4625001001", ]
#'
#'   # Informaci�n de poblaciones de toda la ciudad de Valencia
#'   poblacion[substring(poblacion$seccion, 1, 5) == "46250", ]
#' }
"poblacion"


#' @title Cartografia por seccion censal para las ciudades MEDEA3
#'
#' @description Contiene la cartograf�a por secci�n censal tal cual puede ser
#'   utilizada por el paquete \code{sp}.
#'
#' @name cartografia
#'
#' @docType data
#'
#' @format Un objeto de clase \code{SpatialPoligonsDataFrame}, donde los datos
#'   (\code{cartografia@data}) tienen clase \code{data.frame} y
#'   \code{cartografia_ine}, donde cada fila es una secci�n censal y que cuenta
#'   con 7 columnas: \describe{ \item{seccion}{C�dena de 10 caracteres con el
#'   c�digo de secci�n censal (incluye provincia, municipio, distrito y
#'   secci�n).} \item{CUMUN}{C�dena de 5 caracteres con el c�digo INE del
#'   municipio.} \item{CCA}{C�dena de 2 caracteres con el c�digo INE de la
#'   comunidad aut�noma} \item{NPRO}{Nombre de la provincia.} \item{NCA}{Nombre
#'   de la comunidad aut�noma.} \item{NMUN}{Nombre del municipio.}
#'   \item{n_viv}{N�mero de viviendas por secci�n censal (datos cruzados con
#'   Direcci�n General de Catastro).}}
#'
#' @references \href{http://www.ine.es/}{ Sitio web del INE}.
#'
#'   \href{http://www.ine.es/censos2011_datos/cen11_datos_resultados_seccen.htm}{Cartograf�a}.
#'
#'
#' @encoding UTF-8
#'
#' @keywords datasets
#'
#' @examples
#'
#' \dontrun{
#'   library(medear)
#'   library(sp)
#'   data("cartografia")
#'
#'   # Representaci�n de los secciones censales de �lava
#'   plot(cartografia[substr(cartografia$seccion, 1, 5) == "01059", ])
#'
#'   # Representaci�n de los secciones censales de �lava, seg�n distritos.
#'   distritos <- substr(cartografia[substr(cartografia$CUSEC, 1, 5) == "01059", "CUSEC"], 6, 7)
#'   plot(cartografia[substr(cartografia$CUSEC, 1, 5) == "01059", ], col = as.numeric(distritos))
#' }
"cartografia"


#' @title Nombres de municipios y provincias segun terminologia oficial del INE
#'
#' @description Codificaci�n/nombres usados por el INE para las provincias y los
#'   municipios. Tambi�n indica si se trata de un municipio participante en
#'   MEDEA3 o no.
#'
#' @name codigos_ine
#'
#' @docType data
#'
#' @format Un objeto de clase \code{data.frame}, donde cada
#'   fila es un municipio y que cuenta con 7 columnas:
#'   \describe{
#'     \item{cod_provincia}{C�dena de 2 caracteres con el c�digo de la provincia.}
#'     \item{CUMUN}{C�dena de 3 caracteres con el c�digo del municipio.}
#'     \item{nombre_municipio}{Nombre del municipio.}
#'     \item{medea3}{Valor l�gico: �participa en MEDEA3?}
#'   }
#'
#' @references
#'   \href{http://www.ine.es/}{ Sitio web del INE}.
#'
#'   \href{http://www.ine.es/daco/daco42/codmun/codmunmapa.htm}{ Codificaci�n INE}.
#'
#' @keywords datasets
#'
#' @encoding UTF-8
#'
#' @examples
#'
#' \dontrun{
#'   library(medear)
#'   data("codigos_ine")
#' }
"codigos_ine"

#' @title Cambios temporales de seccionado para todas las ciudades MEDEA3
#'   (periodo 1996-2015)
#'
#' @description Relaci�n de secciones censales que interseccionan
#'   geogr�ficamente con el seccionado de 2011, seg�n la definici�n de dicha
#'   secci�n secci�n censal en ambos a�os siguiendo el tramero del INE. Este
#'   objeto contiene todas las intersecciones entre secciones censales distintas
#'   para el per�odo 1996-2015 (tanto haciendo uso del c�digo postal como sin
#'   el: campo \code{codigo_postal}). Esta informaci�n es costosa de calcular y
#'   se necesita para la funci�n \code{\link{une_secciones}} por ello se ha
#'   considerado conveniente almacenar sus resultados dentro del paquete.
#'
#'   Salvo Vitoria-Gasteiz, Barcelona, Donostia, Madrid, Pamplona y Bilbao, el
#'   resto de ciudades incorporan informaci�n sobre el n�mero de viviendas
#'   afectadas por el cambio de secci�n as� como el porcentaje de tramos, no
#'   detectados en catastro, de ese cambio con respecto al total de tramos que
#'   contiene la secci�n de 2011 (informaci�n �til a la hora de unir las
#'   secciones).
#'
#' @name cambios_seccion
#'
#' @docType data
#'
#' @format Un objeto de clase \code{cambios_ine}, donde cada fila es un un
#'   cambio de secci�n y que cuenta con 7 columnas: \describe{
#'   \item{sc_ref}{C�dena de 10 caracteres con el c�digo de la secci�n 2011.}
#'   \item{sc_new}{C�dena de 10 caracteres con el c�digo de la secci�n en a�o ==
#'   year2.} \item{year}{A�o de referencia: 2011.} \item{year2}{A�o de
#'   comparacion.} \item{viviendas}{N�mero de viviendas afectadas por el cambio
#'   de secci�n.} \item{tramo_por}{Porcentaje de tramos, no detectados en
#'   catastro, afectados por el cambio de secci�n, respecto al total de tramos
#'   que incluye la secci�n de 2011.} \item{codigo_postal}{�La detecci�n de los
#'   cambios se hizo usando el c�digo postal?.}  \item{vias}{Lista con las v�as
#'   afectadas por el cambio de secci�n.} }
#'
#' @keywords datasets
#'
#' @encoding UTF-8
#'
#' @examples
#'
#' \dontrun{
#' library(medear)
#' data(cambios_seccion)
#' cambios_sin_cp <- cambios_seccion[cambios_seccion$cp == FALSE, ]
#' cambios_con_cp <- cambios_seccion[cambios_seccion$cp == TRUE, ]
#' }
"cambios_seccion"


#' @title Secciones censales unicas por periodo (1996-2015)
#'
#' @description Listado con las secciones censales �nicas por a�o (1996-2015) de
#'   ciudades MEDEA3.
#'
#' @name secciones
#'
#' @docType data
#'
#' @format Un objeto de clase \code{data.frame} y \code{data.table}, donde cada
#'   fila es una secci�n para un a�o determinado.
#'
#' @keywords datasets
#'
#' @encoding UTF-8
#'
#' @examples
#'
#' \dontrun{
#'   library(medear)
#'   data("secciones")
#' }
"secciones"
