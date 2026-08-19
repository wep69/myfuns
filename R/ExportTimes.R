#' Exportar um grafico em formatos de publicacao
#'
#' Salva o mesmo grafico em PNG, TIFF, SVG e, quando disponivel, EMF. A funcao
#' moderniza `ExportTimes()` da versao 0.1.0, preservando os padroes historicos
#' de 20 x 15 cm, 600 dpi e Times New Roman para os formatos raster.
#'
#' @param gplot Grafico imprimivel, tipicamente um objeto `ggplot`.
#' @param filename Caminho-base sem extensao.
#' @param width Largura dos arquivos raster.
#' @param height Altura dos arquivos raster.
#' @param units Unidade de `width` e `height`: `"in"`, `"cm"`, `"mm"` ou `"px"`.
#' @param dpi Resolucao de PNG e TIFF em dpi.
#' @param family Familia tipografica solicitada ao dispositivo grafico.
#' @param formats Vetor com formatos dentre `png`, `tiff`, `svg` e `emf`.
#' @param bg Fundo do dispositivo. Use `"transparent"` quando apropriado.
#' @param compression Compressao do TIFF.
#' @param create_dir Criar automaticamente a pasta de destino, se necessario.
#'
#' @return Vetor nomeado com os caminhos dos arquivos efetivamente produzidos.
#' @export
#'
#' @details
#' SVG e EMF sao vetoriais. Para SVG, as dimensoes sao convertidas para
#' polegadas porque [grDevices::svg()] usa polegadas. EMF e produzido com
#' `devEMF::emf()` quando o pacote `devEMF` esta instalado; caso contrario, no
#' Windows, tenta-se `grDevices::win.metafile()`. Se nenhum dispositivo EMF
#' estiver disponivel, o formato e ignorado com aviso.
#'
#' @examples
#' \dontrun{
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'   ggplot2::geom_point() +
#'   theme_nogrid()
#' ExportTimes(p, file.path(tempdir(), "figura_1"), formats = c("png", "svg"))
#' }
ExportTimes <- function(gplot,
                        filename,
                        width = 20,
                        height = 15,
                        units = "cm",
                        dpi = 600,
                        family = "Times New Roman",
                        formats = c("png", "tiff", "svg", "emf"),
                        bg = "white",
                        compression = "lzw",
                        create_dir = TRUE) {
  if (!is.character(filename) || length(filename) != 1L || is.na(filename) || !nzchar(filename)) {
    stop("`filename` deve ser uma string nao vazia.", call. = FALSE)
  }
  if (!is.numeric(width) || length(width) != 1L || width <= 0 ||
      !is.numeric(height) || length(height) != 1L || height <= 0) {
    stop("`width` e `height` devem ser numeros positivos.", call. = FALSE)
  }
  units <- match.arg(units, c("in", "cm", "mm", "px"))
  formats <- unique(tolower(formats))
  allowed <- c("png", "tiff", "svg", "emf")
  if (length(formats) == 0L || any(!formats %in% allowed)) {
    stop("`formats` deve conter apenas: png, tiff, svg e/ou emf.", call. = FALSE)
  }

  out_dir <- dirname(filename)
  if (!dir.exists(out_dir)) {
    if (!isTRUE(create_dir)) {
      stop("A pasta de destino nao existe.", call. = FALSE)
    }
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  }

  produced <- character()
  draw <- function() print(gplot)

  if ("png" %in% formats) {
    path <- paste0(filename, ".png")
    grDevices::png(path, width = width, height = height, units = units,
                   res = dpi, family = family, bg = bg)
    on.exit(grDevices::dev.off(), add = TRUE)
    draw()
    grDevices::dev.off()
    on.exit(NULL, add = FALSE)
    produced["png"] <- path
  }

  if ("tiff" %in% formats) {
    path <- paste0(filename, ".tiff")
    grDevices::tiff(path, width = width, height = height, units = units,
                    res = dpi, family = family, bg = bg, compression = compression)
    on.exit(grDevices::dev.off(), add = TRUE)
    draw()
    grDevices::dev.off()
    on.exit(NULL, add = FALSE)
    produced["tiff"] <- path
  }

  if ("svg" %in% formats) {
    inches <- .to_inches(width, height, units, dpi)
    path <- paste0(filename, ".svg")
    grDevices::svg(path, width = inches[[1L]], height = inches[[2L]],
                   family = family, bg = bg)
    on.exit(grDevices::dev.off(), add = TRUE)
    draw()
    grDevices::dev.off()
    on.exit(NULL, add = FALSE)
    produced["svg"] <- path
  }

  if ("emf" %in% formats) {
    inches <- .to_inches(width, height, units, dpi)
    path <- paste0(filename, ".emf")
    opened <- FALSE

    if (requireNamespace("devEMF", quietly = TRUE)) {
      devEMF::emf(path, width = inches[[1L]], height = inches[[2L]],
                  units = "in", family = family, bg = bg)
      opened <- TRUE
    } else if (.Platform$OS.type == "windows" &&
               exists("win.metafile", envir = asNamespace("grDevices"), inherits = FALSE)) {
      grDevices::win.metafile(path, width = inches[[1L]], height = inches[[2L]],
                             pointsize = 12, family = family)
      opened <- TRUE
    }

    if (opened) {
      on.exit(grDevices::dev.off(), add = TRUE)
      draw()
      grDevices::dev.off()
      on.exit(NULL, add = FALSE)
      produced["emf"] <- path
    } else {
      warning("Formato EMF ignorado: instale `devEMF` ou execute no Windows.", call. = FALSE)
    }
  }

  produced
}

.to_inches <- function(width, height, units, dpi) {
  mult <- switch(
    units,
    "in" = 1,
    cm = 1 / 2.54,
    mm = 1 / 25.4,
    px = 1 / dpi
  )
  c(width * mult, height * mult)
}
