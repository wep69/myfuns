#' Resumo posterior para modelos bayesianos
#'
#' Organiza estimativas posteriores, intervalos de credibilidade e diagnósticos
#' de MCMC por meio de `bayestestR::describe_posterior()`. ROPE só é incluída
#' quando o pesquisador informa explicitamente seus limites.
#'
#' @param model Modelo bayesiano ou objeto de amostras posteriores aceito por
#'   `bayestestR::describe_posterior()`.
#' @param ci Probabilidade do intervalo de credibilidade.
#' @param ci_method Método do intervalo, como `"hdi"` ou `"eti"`.
#' @param centrality Medida de tendência central, como `"median"` ou `"mean"`.
#' @param diagnostics Incluir ESS, Rhat e MCSE quando disponíveis?
#' @param rope Limites `c(inferior, superior)` da região de equivalência prática.
#'   Se `NULL`, nenhuma ROPE é calculada.
#' @param exponentiate Exponenciar estimativas e limites compatíveis, útil para
#'   modelos com link log ou logit quando essa transformação possui sentido.
#'
#' @return `data.frame` com o resumo posterior.
#' @export
#'
#' @examples
#' if (requireNamespace("bayestestR", quietly = TRUE)) {
#'   set.seed(1)
#'   resumo_bayes(stats::rnorm(2000, 0.4, 0.2), diagnostics = FALSE)
#' }
#'
#' if (requireNamespace("bayestestR", quietly = TRUE)) {
#'   set.seed(2)
#'   resumo_bayes(stats::rnorm(2000, 0.05, 0.15), diagnostics = FALSE, rope = c(-0.1, 0.1))
#' }
#'
#' \dontrun{
#' fit <- brms::brm(mpg ~ wt, data = mtcars, family = gaussian(), seed = 123)
#' resumo_bayes(fit, ci = 0.95, ci_method = "hdi")
#' }
resumo_bayes <- function(model,
                         ci = 0.95,
                         ci_method = "hdi",
                         centrality = "median",
                         diagnostics = TRUE,
                         rope = NULL,
                         exponentiate = FALSE) {
  .require_namespace("bayestestR", "resumo_bayes")
  if (!is.numeric(ci) || length(ci) != 1L || ci <= 0 || ci >= 1) stop("`ci` deve estar entre 0 e 1.", call. = FALSE)
  if (!is.null(rope) && (!is.numeric(rope) || length(rope) != 2L || anyNA(rope) || rope[1L] >= rope[2L])) {
    stop("`rope` deve ser `NULL` ou um vetor num\u00E9rico crescente com dois limites.", call. = FALSE)
  }

  tests <- if (is.null(rope)) "p_direction" else c("p_direction", "rope")
  diag <- if (isTRUE(diagnostics)) "all" else NULL
  args <- list(
    posterior = model,
    centrality = centrality,
    ci = ci,
    ci_method = ci_method,
    test = tests,
    diagnostic = diag,
    verbose = FALSE
  )
  if (!is.null(rope)) args$rope_range <- rope
  out <- as.data.frame(do.call(bayestestR::describe_posterior, args))

  if (isTRUE(exponentiate)) {
    transform_cols <- grep(
      "^(Median|Mean|MAP|CI_low|CI_high|CI_low_[0-9]+|CI_high_[0-9]+)$",
      names(out), value = TRUE
    )
    if (length(transform_cols)) {
      out[transform_cols] <- lapply(out[transform_cols], exp)
      attr(out, "escala") <- "exponenciada"
    } else {
      warning("N\u00E3o foram identificadas colunas de estimativa compat\u00EDveis para exponencia\u00E7\u00E3o autom\u00E1tica.", call. = FALSE)
    }
  } else {
    attr(out, "escala") <- "linear_do_modelo"
  }
  attr(out, "rope") <- rope
  attr(out, "ci") <- ci
  out
}

#' Exportar várias figuras em lote
#'
#' Aplica [ExportTimes()] a uma lista de gráficos, padronizando nomes, pasta,
#' formatos, dimensões, resolução e fundo.
#'
#' @param plots Lista nomeada de objetos gráficos imprimíveis.
#' @param dir Pasta de destino.
#' @param formats Formatos dentre `png`, `tiff`, `svg` e `emf`.
#' @param width Largura.
#' @param height Altura.
#' @param units Unidade de largura e altura.
#' @param dpi Resolução dos formatos raster.
#' @param bg Fundo do dispositivo.
#' @param family Família tipográfica repassada a [ExportTimes()].
#'
#' @return Lista nomeada com os caminhos produzidos para cada figura.
#' @export
#'
#' @examples
#' p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point() + theme_nogrid()
#' p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) + ggplot2::geom_boxplot() + theme_nogrid()
#' \dontrun{export_figuras(list(mtcars = p1, iris = p2), tempdir(), formats = "png")}
#'
#' \dontrun{export_figuras(list(fig1 = p1, fig2 = p2), tempdir(), formats = "tiff", dpi = 600)}
#'
#' \dontrun{export_figuras(list(fig1 = p1 + trans, fig2 = p2 + trans), tempdir(),
#'   formats = c("png", "svg"), bg = "transparent")}
export_figuras <- function(plots,
                           dir,
                           formats = c("png", "tiff", "svg"),
                           width = 20,
                           height = 15,
                           units = "cm",
                           dpi = 600,
                           bg = "white",
                           family = "Times New Roman") {
  if (!is.list(plots) || !length(plots)) stop("`plots` deve ser uma lista n\u00E3o vazia.", call. = FALSE)
  if (!is.character(dir) || length(dir) != 1L || !nzchar(dir)) stop("`dir` deve ser um caminho v\u00E1lido.", call. = FALSE)
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  nms <- names(plots)
  if (is.null(nms)) nms <- paste0("figura_", seq_along(plots))
  bad <- !nzchar(nms)
  nms[bad] <- paste0("figura_", which(bad))
  nms <- make.unique(vapply(nms, .clean_filename, character(1)))

  out <- lapply(seq_along(plots), function(i) {
    ExportTimes(
      gplot = plots[[i]],
      filename = file.path(dir, nms[i]),
      width = width,
      height = height,
      units = units,
      dpi = dpi,
      family = family,
      formats = formats,
      bg = bg
    )
  })
  names(out) <- nms
  out
}

#' Ler tabela da área de transferência
#'
#' Nome moderno para o fluxo histórico de [read_excel()]. A função lê texto
#' tabulado da área de transferência nativa do Windows; não abre arquivos XLSX.
#'
#' @param header A primeira linha contém nomes de colunas?
#' @param ... Argumentos adicionais para [utils::read.table()].
#'
#' @return `data.frame`.
#' @export
#'
#' @examples
#' \dontrun{dados <- read_clipboard_table()}
#'
#' \dontrun{dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA"))}
#'
#' \dontrun{dados <- read_clipboard_table(header = FALSE)}
read_clipboard_table <- function(header = TRUE, ...) {
  .require_windows_clipboard()
  utils::read.table("clipboard", header = header, sep = "\t", ...)
}

#' Escrever tabela na área de transferência
#'
#' Nome moderno para o fluxo histórico de [write_excel()]. Escreve uma tabela
#' separada por tabulações para colagem em Excel ou software equivalente no
#' Windows.
#'
#' @param x Objeto tabular.
#' @param row.names Exportar nomes das linhas?
#' @param col.names Exportar nomes das colunas?
#' @param ... Argumentos adicionais para [utils::write.table()].
#'
#' @return Invisivelmente, `NULL`.
#' @export
#'
#' @examples
#' \dontrun{write_clipboard_table(head(iris))}
#'
#' \dontrun{write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean))}
#'
#' \dontrun{write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE)}
write_clipboard_table <- function(x, row.names = FALSE, col.names = TRUE, ...) {
  .require_windows_clipboard()
  utils::write.table(
    x, file = "clipboard", sep = "\t", row.names = row.names,
    col.names = col.names, ...
  )
  invisible(NULL)
}