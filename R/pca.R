#' Análise de componentes principais para dados agronômicos
#'
#' Padroniza um fluxo de PCA baseado em [stats::prcomp()], preservando o objeto
#' original e organizando escores, cargas, autovalores, variância explicada,
#' variância acumulada e contribuição das variáveis. Valores ausentes não são
#' removidos silenciosamente.
#'
#' @param data `data.frame`.
#' @param vars Variáveis numéricas, como `c(var1, var2, var3)` ou vetor de nomes.
#' @param scale Padronizar pelas unidades de desvio-padrão?
#' @param center Centralizar as variáveis?
#' @param group Variável opcional de agrupamento para gráficos.
#' @param ncomp Número de componentes a reportar. `NULL` usa todos os disponíveis.
#'
#' @return Objeto da classe `myfuns_pca`.
#' @export
#'
#' @examples
#' pca1 <- pca_agri(iris,
#'   vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
#' pca1
#'
#' pca_agri(iris,
#'   vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), scale = FALSE)
#'
#' pca_agri(iris,
#'   vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), ncomp = 3)
pca_agri <- function(data,
                     vars,
                     scale = TRUE,
                     center = TRUE,
                     group = NULL,
                     ncomp = NULL) {
  if (!is.data.frame(data)) stop("`data` deve ser um data.frame.", call. = FALSE)
  vars_name <- .vars_from_expr(substitute(vars), data, allow_null = FALSE)
  group_name <- if (missing(group) || is.null(substitute(group))) NULL else .arg_name(substitute(group), data)
  .check_columns(data, c(vars_name, group_name))
  if (length(vars_name) < 2L) stop("A PCA requer pelo menos duas vari\u00E1veis.", call. = FALSE)
  if (any(!vapply(data[vars_name], is.numeric, logical(1)))) stop("Todas as vari\u00E1veis da PCA devem ser num\u00E9ricas.", call. = FALSE)
  if (anyNA(data[vars_name])) {
    stop("H\u00E1 valores ausentes nas vari\u00E1veis da PCA. `pca_agri()` n\u00E3o exclui linhas automaticamente; trate e documente as aus\u00EAncias antes da an\u00E1lise.", call. = FALSE)
  }
  variancias <- vapply(data[vars_name], stats::var, numeric(1))
  if (any(!is.finite(variancias) | variancias <= sqrt(.Machine$double.eps))) {
    bad <- names(variancias)[!is.finite(variancias) | variancias <= sqrt(.Machine$double.eps)]
    stop(paste0("Vari\u00E1vel(is) sem variabilidade adequada para PCA: ", paste(bad, collapse = ", "), "."), call. = FALSE)
  }

  fit <- stats::prcomp(data[vars_name], center = center, scale. = scale)
  maxcomp <- ncol(fit$x)
  if (is.null(ncomp)) ncomp <- maxcomp
  if (!is.numeric(ncomp) || length(ncomp) != 1L || ncomp < 1 || ncomp %% 1 != 0) stop("`ncomp` deve ser um inteiro positivo.", call. = FALSE)
  ncomp <- min(as.integer(ncomp), maxcomp)
  pcs <- paste0("PC", seq_len(ncomp))

  scores <- as.data.frame(fit$x[, seq_len(ncomp), drop = FALSE])
  scores$.linha <- row.names(data)
  if (!is.null(group_name)) scores[[group_name]] <- data[[group_name]]

  loadings <- as.data.frame(fit$rotation[, seq_len(ncomp), drop = FALSE])
  loadings$variavel <- row.names(loadings)
  row.names(loadings) <- NULL

  eigen <- fit$sdev^2
  explained <- eigen / sum(eigen)
  variance <- data.frame(
    componente = paste0("PC", seq_along(eigen)),
    autovalor = eigen,
    variancia = explained,
    variancia_percentual = 100 * explained,
    variancia_acumulada = cumsum(explained),
    acumulada_percentual = 100 * cumsum(explained),
    stringsAsFactors = FALSE
  )
  variance <- variance[seq_len(ncomp), , drop = FALSE]

  rot <- fit$rotation[, seq_len(ncomp), drop = FALSE]^2
  contrib <- sweep(rot, 2L, colSums(rot), "/") * 100
  contribution <- as.data.frame(contrib)
  contribution$variavel <- row.names(contribution)
  row.names(contribution) <- NULL

  out <- list(
    pca = fit,
    escores = scores,
    cargas = loadings,
    variancia = variance,
    contribuicao = contribution,
    variaveis = vars_name,
    grupo = group_name,
    center = center,
    scale = scale,
    ncomp = ncomp,
    dados = data
  )
  class(out) <- c("myfuns_pca", "list")
  out
}

#' @export
print.myfuns_pca <- function(x, ...) {
  cat("An\u00E1lise de componentes principais\n")
  cat("---------------------------------\n")
  cat("Vari\u00E1veis: ", paste(x$variaveis, collapse = ", "), "\n", sep = "")
  cat("Centraliza\u00E7\u00E3o: ", if (x$center) "sim" else "n\u00E3o", "; padroniza\u00E7\u00E3o: ", if (x$scale) "sim" else "n\u00E3o", "\n\n", sep = "")
  print(x$variancia, row.names = FALSE)
  invisible(x)
}

#' Gráficos de PCA em padrão de publicação
#'
#' Produz biplot, gráfico de escores ou gráfico de cargas a partir de
#' [pca_agri()]. Os eixos são rotulados com a porcentagem de variância explicada.
#'
#' @param object Resultado de [pca_agri()].
#' @param axes Dois componentes, por exemplo `c(1, 2)`.
#' @param type `"biplot"`, `"scores"` ou `"loadings"`.
#' @param group Variável de grupo. Se omitida, usa a registrada em `pca_agri()`.
#' @param ellipse Adicionar elipse por grupo aos escores?
#' @param labels Adicionar rótulos das observações nos escores e das variáveis nas cargas?
#' @param theme Tema `ggplot2`.
#'
#' @return Objeto `ggplot`.
#' @export
#'
#' @examples
#' pca <- pca_agri(iris,
#'   vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
#' plot_pca_agri(pca, type = "biplot")
#'
#' plot_pca_agri(pca, type = "scores", ellipse = TRUE)
#'
#' plot_pca_agri(pca, axes = c(1, 3), type = "loadings", labels = TRUE)
plot_pca_agri <- function(object,
                          axes = c(1, 2),
                          type = c("biplot", "scores", "loadings"),
                          group = NULL,
                          ellipse = FALSE,
                          labels = FALSE,
                          theme = theme_nogridacp()) {
  if (!inherits(object, "myfuns_pca")) stop("`object` deve ser resultado de `pca_agri()`.", call. = FALSE)
  type <- match.arg(type)
  if (!is.numeric(axes) || length(axes) != 2L || anyNA(axes) || any(axes < 1) || any(axes %% 1 != 0)) stop("`axes` deve conter dois \u00EDndices inteiros positivos.", call. = FALSE)
  axes <- as.integer(axes)
  if (max(axes) > object$ncomp) stop("O componente solicitado n\u00E3o foi armazenado em `object`. Aumente `ncomp` em `pca_agri()`.", call. = FALSE)
  pcx <- paste0("PC", axes[1L]); pcy <- paste0("PC", axes[2L])

  group_name <- if (missing(group) || is.null(substitute(group))) object$grupo else .arg_name(substitute(group), object$dados)
  if (!is.null(group_name) && !group_name %in% names(object$escores)) {
    if (group_name %in% names(object$dados)) object$escores[[group_name]] <- object$dados[[group_name]]
    else stop("A vari\u00E1vel de grupo n\u00E3o est\u00E1 dispon\u00EDvel no objeto.", call. = FALSE)
  }

  varx <- object$variancia$variancia_percentual[axes[1L]]
  vary <- object$variancia$variancia_percentual[axes[2L]]
  labs <- ggplot2::labs(
    x = paste0(pcx, " (", formatC(varx, digits = 2, format = "f"), "%)"),
    y = paste0(pcy, " (", formatC(vary, digits = 2, format = "f"), "%)")
  )

  scores <- object$escores
  loads <- object$cargas

  if (type == "scores") {
    map <- if (is.null(group_name)) {
      ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy))
    } else {
      ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy), shape = !!rlang::sym(group_name), group = !!rlang::sym(group_name))
    }
    p <- ggplot2::ggplot(scores, map) + ggplot2::geom_point(size = 2.4)
    if (isTRUE(ellipse) && !is.null(group_name)) p <- p + ggplot2::stat_ellipse()
    if (isTRUE(labels)) p <- p + ggplot2::geom_text(ggplot2::aes(label = !!rlang::sym(".linha")), vjust = -0.7, show.legend = FALSE)
    return(p + labs + theme)
  }

  if (type == "loadings") {
    p <- ggplot2::ggplot(loads, ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy))) +
      ggplot2::geom_segment(
        ggplot2::aes(x = 0, y = 0, xend = !!rlang::sym(pcx), yend = !!rlang::sym(pcy)),
        arrow = grid::arrow(length = grid::unit(0.16, "cm"))
      ) +
      ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
      ggplot2::geom_vline(xintercept = 0, linewidth = 0.3)
    if (isTRUE(labels)) p <- p + ggplot2::geom_text(ggplot2::aes(label = !!rlang::sym("variavel")), vjust = -0.6)
    return(p + labs + theme)
  }

  # Biplot com escalonamento das cargas para a região dos escores.
  map <- if (is.null(group_name)) {
    ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy))
  } else {
    ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy), shape = !!rlang::sym(group_name), group = !!rlang::sym(group_name))
  }
  p <- ggplot2::ggplot(scores, map) + ggplot2::geom_point(size = 2.3)
  if (isTRUE(ellipse) && !is.null(group_name)) p <- p + ggplot2::stat_ellipse()
  if (isTRUE(labels)) p <- p + ggplot2::geom_text(ggplot2::aes(label = !!rlang::sym(".linha")), vjust = -0.6, show.legend = FALSE)

  sx <- max(abs(scores[[pcx]]), na.rm = TRUE) / max(abs(loads[[pcx]]), na.rm = TRUE)
  sy <- max(abs(scores[[pcy]]), na.rm = TRUE) / max(abs(loads[[pcy]]), na.rm = TRUE)
  mult <- 0.75 * min(sx, sy)
  l2 <- loads
  l2[[pcx]] <- l2[[pcx]] * mult
  l2[[pcy]] <- l2[[pcy]] * mult

  p +
    ggplot2::geom_segment(
      data = l2,
      mapping = ggplot2::aes(x = 0, y = 0, xend = !!rlang::sym(pcx), yend = !!rlang::sym(pcy)),
      inherit.aes = FALSE,
      arrow = grid::arrow(length = grid::unit(0.16, "cm"))
    ) +
    ggplot2::geom_text(
      data = l2,
      mapping = ggplot2::aes(x = !!rlang::sym(pcx), y = !!rlang::sym(pcy), label = !!rlang::sym("variavel")),
      inherit.aes = FALSE, vjust = -0.5
    ) + labs + theme
}