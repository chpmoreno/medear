
#' @title Limpieza de las cadenas con las direcciones a geocodificar
#'
#' @description Esta funci�n ejecuta una limpieza gen�rica de las direcciones,
#'   eliminando datos perdidos, sustituyendo portales igual a cero o ceros a la
#'   izquierda, normaliza los pincipales tipos de v�a (calle, avenida, plaza,
#'   partida, camino, carretera, pasaje, paseo y traves�a) y elimina
#'   duplicidades en el nombre de municipios y provincias (consecuencia del uso
#'   conjunto de varias lenguas).
#'
#'   La funci�n espera como entrada los campos habituales del bolet�n de
#'   defunciones, y ella se ocupa de trabajarlos por separado.
#'
#' @param tvia Caracter: tipos de v�as.
#' @param nvia Caracter: nombres de la v�as.
#' @param npoli Caracter: n�meros de polic�a.
#' @param muni Caracter: nombres de los municipios.
#' @param prov Caracter: nombres de las provincias.
#' @param codpost Caracter: c�digos postales.
#'
#' @usage limpia_dir(tvia, nvia, npoli, muni, prov, codpost)
#'
#' @return Se devuelve una lista de 6 elementos, uno para cada campo de entrada.
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{geocodificar_cartociudad}} y
#'   \code{\link{geocodificar_google}}.
#'
limpia_dir <- function(tvia, nvia, npoli, muni, prov, codpost) {

  vias <- list(tvia = tvia, nvia = nvia, npoli = npoli,
               muni = muni, prov = prov, codpost = codpost)
  stopifnot(all(sapply(vias, is.character)))

  vias <- lapply(vias, tolower)

  # Convertir NA's en 0 car�cteres.
  vias <- lapply(vias, function(x) ifelse(is.na(x), "", x))
  # Repaso de la conversion previa (no es realmente necesario...).
  vias <- lapply(vias, gsub, pattern = "^na$", replacement = "")

  # Eliminar ceros a la izquierda en npoli.
  vias$npoli <- gsub("^0*(?=\\d+)", "", vias$npoli, perl = TRUE)

  # Convertir numeros compuestos por un cero en 0 car�cteres.
  vias$npoli <- gsub("^0$", "", vias$npoli)

  # Convertir numeros 999 o 9999 en cero car�cteres
  vias$npoli <- gsub("9999?", "", vias$npoli)

  # Convertir nombres de via con 3a en tercera.
  vias$nvia <- gsub("\\s3a\\s", "tercera", vias$nvia)

  # Convertir nombres de via no consta en 0 car�cteres.
  vias$nvia <- gsub("no consta", "", vias$nvia)

  # Eliminar comas del nombre de la v�a.
  vias$nvia <- gsub(",", "", vias$nvia)

  # Normalizaci�n de los tipos de via mas frecuentes por variantes habituales.
  calle     <- "^(ca[^monstbp])\\w+\\b|^(c)\\b|^(cl[^rnia][^b])|^([^bv]lle*)\\w"
  avenida   <- "^(a.v)[^t]\\w+\\b|^(av)\\w+\\b|^(abg)\\w+\\b|^(vda)\\w+\\b|^a\\b|^av\\b"
  plaza     <- "^(pz?l?z?[^tsrqopjigedau])\\w+"
  partida   <- "^(par?t)\\w+|^(pda)\\w+|^(pr?t)\\w+|^pa.*da\\w+|^p.tda\\b"
  camino    <- "^(cam)[^p]\\w+|^(cm[^p])\\w+"
  carretera <- "^(ctr)\\w+|^(crt)\\w+"
  pasaje    <- "^(pa?s[^e]j?)\\w+|^(pas[^e](.*))\\w+|^pje\\b|^psj\\b"
  paseo     <- "^(pa?s[^a]e?)\\w+"
  travesia  <- "^(trav)(.*)\\b|^tr?v\\w+"
  vias$tvia <- gsub(calle, "calle", vias$tvia)
  vias$tvia <- gsub(avenida, "avenida", vias$tvia)
  vias$tvia <- gsub(plaza, "plaza", vias$tvia)
  vias$tvia <- gsub(partida, "partida", vias$tvia)
  vias$tvia <- gsub(camino, "camino", vias$tvia)
  vias$tvia <- gsub(carretera, "carretera", vias$tvia)
  vias$tvia <- gsub(pasaje, "pasaje", vias$tvia)
  vias$tvia <- gsub(paseo, "paseo", vias$tvia)
  vias$tvia <- gsub(travesia, "travesia", vias$tvia)

  # Eliminar duplicidades (por lengua) en municipios y provincias (divisiones por barra /).
  vias[c("muni", "prov")] <- lapply(
    X           = vias[c("muni", "prov")],
    FUN         = gsub,
    pattern     = "\\/(?<=\\/)(.*)",
    replacement = "",
    perl        = TRUE
  )

  # Eliminar espacios en ambos extremos de todos los elementos.
  vias <- lapply(vias, trimws)
  vias <- lapply(vias, gsub, pattern = "\\s{2,}", replacement = " ")

  return(vias)
}


#' @title Deteccion y prueba de variantes de direcciones mal escritas
#'
#' @description Se considera una serie de variantes de las cadenas de car�cteres
#'   de las direcciones no geocodificadas. La intenci�n es valorar si esas
#'   variaciones podr�an producir en alguna ocasi�n una geocodificaci�n exitosa.
#'   En concreto, \code{\link{filtra_dir}} contempla 5 posibles variantes para
#'   las direcciones que no han podido ser geocodificadas:
#'   \enumerate{\item{eliminar duplicidad de tipos de v�a (ejemplo: calle camino
#'   ...-> camino ...);} \item{eliminar descripciones de v�a (ejemplo: Avenida
#'   rosa (Edificio azul)->Avenida rosa);} \item{eliminar palabras de 3 o menos
#'   car�cteres (ejemplo: calle la marina alta-> calle marina alta);}
#'   \item{eliminar signos de puntuaci�n (ejemplo: calle gral. pedro.->calle
#'   gral pedro);} \item{implementaci�n de todas las variantes anteriores de
#'   forma secuencial.}} \code{\link{filtra_dir}} contempla todas estas
#'   variantes para cualquier direcci�n que no haya podido ser geocodificada a
#'   partir de su direcci�n original.
#'
#' @param vias Lista de seis elementos devuelta por \code{\link{limpia_dir}}.
#' @param nivel Num�rico: filtro a a aplicar.
#'
#' @usage filtra_dir(vias, nivel)
#'
#' @return Se devuelve un vector de car�cteres de igual longitud a la lista de
#'   entrada, con las direcciones listas para geocodificar (las direcciones en
#'   las que no se reconozca ning�n patr�n son sustituidas por un elemento
#'   vac�o).
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{limpia_dir}}, \code{\link{geocodificar_cartociudad}} y
#'   \code{\link{geocodificar_google}}.
#'
filtra_dir <- function(vias, nivel) {

  stopifnot(is.list(vias))
  stopifnot(c("tvia", "nvia", "npoli", "muni", "prov", "codpost") %in% names(vias))
  stopifnot(is.numeric(nivel))

  tvias     <- paste(vias$tvia, vias$nvia)
  indice    <- integer()
  tvia_norm <- c("calle", "avenida", "plaza", "partida", "camino", "carretera",
                 "pasaje", "paseo", "vereda", "paraje", "ronda", "travesia",
                 "parque", "grupo")

  # Patron para detectar direcciones absurdas tras el filtrado (p.ej.,
  # "calle 1,", "calle ,", ...). Estas se dan por perdidas.
  inutiles  <- paste0("^(", paste0(tvia_norm, collapse = "|"),
                      ")\\s{1,10}\\d+,|^\\s?([a-z]+|\\d+)\\s{0,10},|^,|^\\s,")
  patron_ini  <- c("\\s", "\\(", "-")
  patron_fin  <- c("\\s", "\\.")
  descripcion <- c("urb", "urbanizacion", "ed", "edf", "edif", "edificio", "res",
                   "rsd", "rsden", "resid", "residencia", "geriatric.", "centro",
                   "grupo", "grup", "polig", "poligono", "finca", "aptos",
                   "complejo", "cooperativa", "coop")

  if (nivel == 1) {
    for (i in seq_along(tvia_norm)) {
      for (j in seq_along(tvia_norm)) {
        eliminar <- grep(paste0(tvia_norm[i], "\\s{1,10}", tvia_norm[j]), tvias)
        indice   <- sort(unique(c(indice, eliminar)))
        tvias[eliminar] <- gsub("^[a-z]+\\s{1,10}", "", tvias[eliminar])
      }
    }
  } else if (nivel == 2) {
    for (k in seq_along(descripcion)) {
      for (i in seq_along(patron_ini)) {
        for (j in seq_along(patron_fin)) {
          patron <- paste0("(?<=", patron_ini[i], descripcion[k], patron_fin[j], ")(.*)")
          if (i == 2) {
            patron <- paste0(patron, "\\)|", patron)
          } else if (i == 3) {
            patron <- paste0(patron, "-|", patron)
          }
          indice <- sort(unique(c(indice, grep(patron, tvias, perl = TRUE))))
          tvias  <- gsub(patron, "", tvias, perl = TRUE)
          tvias  <- gsub(
            pattern     = paste0(patron_ini[i], descripcion[k], patron_fin[j]),
            replacement = "",
            x           = tvias
          )
        }
      }
    }
  } else if (nivel == 3) {
    indice <- grep("\\b[[:alpha:]]{1,3}\\b\\.?", tvias)
    tvias  <- gsub("\\b[[:alpha:]]{1,3}\\b\\.?", "", tvias)
  } else if (nivel == 4) {
    tvias <- gsub("[[:punct:]]", "", tvias)
    for (i in seq_along(tvia_norm)) {
      eliminar <- grep(paste0("^", tvia_norm[i], "\\s{1,10}"), tvias)
      indice   <- sort(unique(c(indice, eliminar)))
      tvias[eliminar] <- gsub(paste0("^", tvia_norm[i], "\\s{1,10}"), "", tvias[eliminar])
    }
  } else {
    for (i in seq_along(tvia_norm)) {
      for (j in seq_along(tvia_norm)) {
        eliminar <- grep(paste0(tvia_norm[i], "\\s{1,10}", tvia_norm[j]), tvias)
        indice   <- sort(unique(c(indice, eliminar)))
        tvias[eliminar] <- gsub("^[a-z]+\\s{1,10}", "", tvias[eliminar])
      }
    }
    for (k in seq_along(descripcion)) {
      for (i in seq_along(patron_ini)) {
        for (j in seq_along(patron_fin)) {
          patron <- paste0("(?<=", patron_ini[i], descripcion[k], patron_fin[j], ")(.*)")
          if (i == 2) {
            patron <- paste0(patron, "\\)|", patron)
          } else if (i == 3) {
            patron <- paste0(patron, "-|", patron)
          }
          indice <- sort(unique(c(indice, grep(patron, tvias, perl = TRUE))))
          tvias  <- gsub(patron, "", tvias, perl = TRUE)
          tvias  <- gsub(
            pattern     = paste0(patron_ini[i], descripcion[k], patron_fin[j]),
            replacement = "",
            x           = tvias
          )
        }
      }
    }
    indice <- sort(unique(c(grep("\\b[[:alpha:]]{1,3}\\b\\.?", tvias), indice)))
    tvias  <- gsub("\\b[[:alpha:]]{1,3}\\b\\.?", "", tvias)
    tvias  <- gsub("[[:punct:]]", "", tvias)
    for (i in seq_along(tvia_norm)) {
      eliminar <- grep(paste0("^", tvia_norm[i], "\\s{1,10}"), tvias)
      indice   <- sort(unique(c(indice, eliminar)))
      tvias[eliminar] <- gsub(paste0("^", tvia_norm[i], "\\s{1,10}"), "", tvias[eliminar])
    }
  }
  if (length(indice) > 0) {
    indice <- indice[nchar(tvias[indice]) >= 4]
  }
  res <- character(length(vias[[1]]))
  if (length(indice) > 0) {
    pegote <- paste0(tvias[indice], " ", vias$npoli[indice], ", ", vias$muni[indice],
                     ", ", vias$prov[indice], ", ", vias$codpost[indice])
    pegote <- gsub("\\s{2,}", " ", pegote)
    res[indice] <- pegote
  }

  return(res)
}


#' @title Comprobacion de inclusion de una coordenada dentro de un poligono
#'
#' @description Con el fin de asegurar que el resultado de la geocodificaci�n
#'   sea coherente, esta funci�n permite identificar parejas de coordenadas que
#'   no est�n incluidas en un pol�gono concreto (una secci�n, un distrito, un
#'   municipio o una provincia). Para ello es necesario proporcionar un pol�gono
#'   de referencia para cada par de coordenadas, en las cuales se utiliza el CRS
#'   WGS84 (c�digo EPSG 4326), que es el sistema de referencia de coordenadas
#'   empleado en MEDEA. Si se desea utilizar esta funci�n para coordenadas no
#'   recuperadas con las funciones de este paquete
#'   (\code{\link{geocodificar_cartociudad}}, \code{\link{geocodificar_google}})
#'   o tras llamar directamente a
#'   \code{\link[caRtociudad]{cartociudad_geocode}}, habr� que transformar la
#'   proyecci�n.
#'
#' @param punto Un data.frame con dos columnas: lng y lat.
#' @param poligono Un objeto de clase \code{\link[sp]{SpatialPolygons}}
#'   con el pol�gono de referencia sobre el que se desee contrastar la
#'   pertenecia de las coordenadas.
#'
#' @return Valor l�gico.
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{geocodificar_cartociudad}} y
#'   \code{\link{geocodificar_google}}.
#'
comprueba_punto_poligono <- function(punto, poligono) {

  stopifnot(is.data.frame(punto))
  stopifnot(is.numeric(unlist(punto)))
  if ("SpatialPolygonsDataFrame" != class(poligono))
    stop("El objeto 'poligono' debe ser de clase 'SpatialPolygonsDataFrame'.")
  if (is.na(sp::proj4string(poligono)))
    stop("El objeto 'poligono' no tiene asignado un CRS.")

  poligono     <- sp::spTransform(poligono, sp::CRS("+init=epsg:4326"))
  CRScarto     <- sp::CRS(sp::proj4string(poligono))
  poligono     <- sp::spTransform(poligono, CRScarto)
  punto.lonlat <- data.frame(
    longitude = as.numeric(as.character(punto$lng)),
    latitude  = as.numeric(as.character(punto$lat))
  )

  sp::coordinates(punto.lonlat) <- ~ longitude + latitude
  sp::proj4string(punto.lonlat) <- sp::CRS("+init=epsg:4326")

  # Transformamos los puntos a la misma proyeccion que la cartografia
  puntos.fin <- try(sp::spTransform(punto.lonlat, CRScarto), silent = TRUE)
  if (class(puntos.fin) != "try-error") {
    auxiliar <- sp::over(puntos.fin, poligono)$CUMUN
  } else {
    auxiliar <- NA
  }
  devuelve <- !is.na(auxiliar)

  return(devuelve)
}


#' @title Limpieza de caracteres para Google
#'
#' @description Eliminaci�n de car�cteres no ASCII para la geocodificaci�n con
#'   Google.
#'
#' @param cadena Cadena de car�cteres con las direcciones a pasar a Google.
#'
#' @return Cadena de car�cteres de la misma longitud que la proporcionada.
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{geocodificar_google}}.
#'
limpiadirecGoogle <- function(cadena){
  stopifnot(is.character(cadena))

  cadena <- gsub(cadena, pattern = "\U00F1|\U00F0|\U00A5",        replacement = "n")
  cadena <- gsub(cadena, pattern = "\U00E1|\U00E0|\U00AA|\U00E4", replacement = "a")
  cadena <- gsub(cadena, pattern = "\U00E9|\U00E8|\U00EB",        replacement = "e")
  cadena <- gsub(cadena, pattern = "\U00ED|\U00EC|\U00EF",        replacement = "i")
  cadena <- gsub(cadena, pattern = "\U00F3|\U00F2|\U00BA|\U00F6", replacement = "o")
  cadena <- gsub(cadena, pattern = "\U00FA|\U00F9|\U00FC|\U00FD", replacement = "u")
  cadena <- gsub(cadena, pattern = "\U00E7",                      replacement = "c")
  cadena <- gsub(cadena, pattern = "\U0027|\U0060|\U00B4",        replacement = " ")

  #Por si queda algun caracter raro
  cad_aux <- strsplit(cadena, "")[[1]]
  elim    <- which(!cad_aux %in% c(letters, " ", 0:1000 , ",", "'"))
  if (length(elim) > 0) {
    cad_aux <- cad_aux[-elim]
    cadena <- paste(cad_aux, collapse = "")
  }

  return(cadena)
}


#' @title Implementar la tercera fase del algoritmo de geocodificacion de
#'   direcciones de MEDEA3 (geocodificado con CartoCiudad)
#'
#' @description Esta funci�n implementa la tercera parte del algoritmo de
#'   geocodificaci�n de MEDEA3. En primer lugar se intenta geocodificar las
#'   direcciones haciendo uso del servicio CartoCiudad en su
#'   \href{http://www.cartociudad.es/CartoGeocoder/Geocode}{versi�n antigua}. En
#'   esta primera parte daremos por v�lidos todas aquellos direcciones que hayan
#'   obtenido estado == 1 (se ha encontrado la direcci�n correspondiente de
#'   forma exacta) o estado == 2 (direcci�n asignada al portal m�s pr�ximo).
#'   Tras esto se intentar� geocodificar con
#'   \href{http://www.cartociudad.es/geocoder/api/geocoder/findJsonp}{la nueva
#'   versi�n de CartoCiudad} al resto de direcciones no geocodifadas por la
#'   versi�n anterior, junto con las direcciones geocodificadas que no tuvieran
#'   portal y las que hayan obtenido status == 2. La geocodificaci�n de las
#'   direcciones que no tienen portal resulta menos fiable en la versi�n antigua
#'   de CartoCiudad ya que son situadas en el inicio de su v�a, mientras que en
#'   la nueva versi�n se sit�an en el centro, siendo este abordaje m�s acertado.
#'   Por otro lado, la versi�n antigua de CartoCiudad en ocasiones cambia de
#'   acera (numeros pares a impares y viceversa) algunas direcciones mientras
#'   que en la versi�n nueva esto no ocurre. Por ello, intentaremos solucionar
#'   estas dos situaciones con la nueva versi�n de CartoCiudad, y en caso de que
#'   esta no logre obtener una ubicaci�n satisfactoria mantendr�amos la
#'   geocodificaci�n original conseguida por la versi�n previa.
#'
#'   Tras el proceso descrito, pueden considerarse una serie de variantes de las
#'   cadenas de car�cteres de las direcciones no geocodificadas, empleando la
#'   funci�n \code{\link{filtra_dir}}.
#'
#'   La funci�n incorpora un filtro cartogr�fico que deseche aquellas
#'   localizaciones que caigan fuera de un pol�gono concreto, para lo cual es
#'   necesario incluirlo como argumento de la funci�n.
#'
#'   Tras la geocodificaci�n usando CartoCiudad, es el momento de probar el
#'   motor de Google con las direcciones que no hayan sido geocodificadas
#'   correctamente.
#'
#' @param direc Cadena de car�cteres con laa direcciones a georreferenciar.
#' @param poligono Opcional: objeto de clase
#'   \code{\link[sp]{SpatialPolygons}}.
#'
#' @usage geocodificar_cartociudad(direc, poligono = NULL)
#'
#' @return Un data.frame con tantas filas como direcciones se haya proporcionado
#'   y 14 columnas: id, province, muni, tip_via, address, portalNumber,
#'   refCatastral, postalCode, lat, lng, stateMsg, state, type y georef.
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{geocodificar_google}} para georreferenciar los registros
#'   pendientes (cuarta fase del protocolo) y
#'   \code{vignette("medear-georreferenciacion")} para visualizar el protocolo
#'   de georreferenciaci�n.
#'
geocodificar_cartociudad <- function(direc, poligono = NULL) {

  stopifnot(is.character(direc))
  if (!is.null(poligono))
    stopifnot(class(poligono) == "SpatialPolygonsDataFrame")

  columnas_elegidas <- c("id", "province", "muni", "tip_via", "address",
                         "portalNumber", "refCatastral", "postalCode",
                         "lat", "lng", "stateMsg", "state", "type")
  devuelve <- data.frame(georef = "NO", stringsAsFactors = FALSE)

  # Llamamos a caRtociudad version previa (OLD)
  fcarto.old <- suppressWarnings(caRtociudad::cartociudad_geocode(direc, version = "prev"))
  if (fcarto.old$state %in% 1:2) {
    devuelve <- fcarto.old[, columnas_elegidas]
    devuelve$georef <- "caRto.OLD"

    # Comprobacion de si el punto devuelto esta en el poligono (municipio)
    # que corresponde
    if (!is.null(poligono)) {
      pto.in.poli <- comprueba_punto_poligono(
        punto = devuelve[, c("lat", "lng")], poligono = poligono
      )
      if (!pto.in.poli) {
        # si hemos obtenido georeferenciacion pero el punto no esta en
        # el poligono lo indicamos
        devuelve <- data.frame(georef = "NO punto caRto.OLD", stringsAsFactors = FALSE)
      }
    }
  }

  # Llamamos a caRtociudad version nueva (NEW)
  if (substr(devuelve$georef, 1, 2) == "NO" | (devuelve$georef == "caRto.OLD" & fcarto.old$state == "2")) {
    fcarto.new <- suppressWarnings(caRtociudad::cartociudad_geocode(direc,version = "current"))
    if (fcarto.new$state %in% 1:4) {
      devuelve <- fcarto.new[, columnas_elegidas]
      devuelve$georef <- "caRto.NEW"

      # Compruebo si el punto devuelto esta en el poligono que corresponde
      if (!is.null(poligono)) {
        pto.in.poli <- comprueba_punto_poligono(punto = devuelve[, c("lat", "lng")], poligono)
        if (pto.in.poli == FALSE) {
          devuelve <- data.frame(georef = "NO punto caRto.NEW", stringsAsFactors = FALSE)
        }
      }
    }
  }

  return(devuelve)
}


#' @title Implementar la cuarta fase del algoritmo de geocodificacion de
#'   direcciones de MEDEA3 (geocodificado con Google)
#'
#' @description Esta funci�n implementa la cuarta fase del algoritmo de
#'   geocodificaci�n de MEDEA3. En la fase previa se intent� geocodificar las
#'   direcciones haciendo uso del servicio CartoCiudad
#'   \code{\link{geocodificar_cartociudad}}. Tras la geocodificaci�n usando
#'   CartoCiudad, es el momento de probar el motor de Google con las direcciones
#'   que no hayan sido geocodificadas correctamente.
#'
#' @param direc Cadena de car�cteres con laa direcciones a georreferenciar.
#' @param poligono Opcional: objeto de clase
#'   \code{\link[sp]{SpatialPolygons}}.
#'
#' @usage geocodificar_google(direc, poligono = NULL)
#'
#' @return Un data.frame con tantas filas como direcciones se haya proporcionado
#'   y 14 columnas: id, province, muni, tip_via, address, portalNumber,
#'   refCatastral, postalCode, lat, lng, stateMsg, state, type y georef.
#'
#' @encoding UTF-8
#'
#' @export
#'
#' @seealso \code{\link{geocodificar_cartociudad}} como paso previo (tercera
#'   fase del protocolo) y \code{vignette("medear-georreferenciacion")} para
#'   visualizar el protocolo de georreferenciaci�n.
#'
geocodificar_google <- function(direc, poligono = NULL) {

  stopifnot(is.character(direc))
  if (!is.null(poligono))
    stopifnot(class(poligono) == "SpatialPolygonsDataFrame")

  direc   <- limpiadirecGoogle(cadena = direc)
  fgoogle <- llama_google(direc = direc, tries = 10)

  if (fgoogle$status == "OK") {
    devuelve <- data.frame(
      id               = "",
      province         = "",
      muni             = "",
      tip_via          = "",
      address          = "",
      portalNumber     = "",
      refCatastral     = "",
      postalCode       = "",
      lat              = NA_real_,
      lng              = NA_real_,
      stateMsg         = "",
      state            = "OK",
      type             = "",
      georef           = "google",
      stringsAsFactors = FALSE
    )

    resultados <- fgoogle$results[[1]]

    # lat y lng
    devuelve$lat <- resultados$geometry$location$lat
    devuelve$lng <- resultados$geometry$location$lng

    # stateMsg
    devuelve$stateMsg <- resultados$geometry$location_type

    # type
    devuelve$type <- paste(resultados$types, collapse = " ")

    if (length(resultados$address_components) > 0) {
      # province
      ident <- grep("administrative_area_level_2",resultados$address_components)
      if (length(ident) != 0) {
        devuelve$province <- resultados$address_components[[ident[1]]]$long_name
      }

      # muni
      ident <- grep("locality", resultados$address_components)
      if (length(ident) != 0) {
        devuelve$muni <- resultados$address_components[[ident[1]]]$long_name
      }

      # tip_via y address
      ident <- grep("route", resultados$address_components)
      if (length(ident) != 0) {
        devuelve$tip_via <- resultados$address_components[[ident[1]]]$types
        devuelve$address <- resultados$address_components[[ident[1]]]$long_name
      }

      # portalNumber
      ident <- grep("street_number", resultados$address_components)
      if (length(ident) != 0) {
        devuelve$portalNumber <- resultados$address_components[[ident[1]]]$long_name
      }

      # postalCode
      ident <- grep("postal_code", resultados$address_components)
      if (length(ident) != 0) {
        devuelve$postalCode <- resultados$address_components[[ident[1]]]$long_name
      }
    }

    # Compruebo si el punto devuelto esta en el poligono que corresponde
    if (!is.null(poligono)) {
      pto.in.poli <- comprueba_punto_poligono(punto = devuelve[, c("lat", "lng")], poligono)
      if (!pto.in.poli) {
        devuelve <- data.frame(georef = "NO punto", stringsAsFactors = FALSE)
      }
    }
  } else {
    devuelve <- data.frame(georef = "NO", state = fgoogle$status, stringsAsFactors = FALSE)
  }

  return(devuelve)
}
