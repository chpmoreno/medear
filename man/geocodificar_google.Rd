% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geocodificar.R
\encoding{UTF-8}
\name{geocodificar_google}
\alias{geocodificar_google}
\title{Implementar la cuarta fase del algoritmo de geocodificacion de
  direcciones de MEDEA3 (geocodificado con Google)}
\usage{
geocodificar_google(direc, poligono = NULL)
}
\arguments{
\item{direc}{Cadena de carácteres con laa direcciones a georreferenciar.}

\item{poligono}{Opcional: objeto de clase
\code{\link[sp]{SpatialPolygons}}.}
}
\value{
Un data.frame con tantas filas como direcciones se haya proporcionado
  y 14 columnas: id, province, muni, tip_via, address, portalNumber,
  refCatastral, postalCode, lat, lng, stateMsg, state, type y georef.
}
\description{
Esta función implementa la cuarta fase del algoritmo de
  geocodificación de MEDEA3. En la fase previa se intentó geocodificar las
  direcciones haciendo uso del servicio CartoCiudad
  \code{\link{geocodificar_cartociudad}}. Tras la geocodificación usando
  CartoCiudad, es el momento de probar el motor de Google con las direcciones
  que no hayan sido geocodificadas correctamente.
}
\seealso{
\code{\link{geocodificar_cartociudad}} como paso previo (tercera
  fase del protocolo) y \code{vignette("medear-georreferenciacion")} para
  visualizar el protocolo de georreferenciación.
}
