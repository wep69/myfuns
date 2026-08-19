#' Gráfico de médias marginais estimadas com dados observados
#'
#' Combina estimativas ajustadas, intervalos de confiança e, opcionalmente,
#' observações individuais. O objetivo é evitar figuras que mostrem apenas uma
#' barra de média sem informação de distribuição ou incerteza.
#'
#' @param object Resultado de [comparar_emmeans()] ou objeto `emmGrid`.
#' @param data Banco original opcional.
#' @param x Variável do eixo x no banco original. Se `NULL`, é inferida das EMMs.
#' @param y Variável resposta no banco original.
#' @param show_data Mostrar observações individuais quando `data` é fornecido?
#' @param interval Tipo de intervalo. Atualmente `"confidence"` utiliza os
#'   limites fornecidos por `emmeans`.
#' @param letters Mostrar letras se `object` contiver CLD?
#' @param theme Tema `ggplot2` aplicado ao final.
#'
#' @return Objeto `ggplot`.
#' @export
#'
#' @examples
#' m <- stats::lm(weight ~ group, data = PlantGrowth)
#' cmp <- comparar_emmeans(m, ~ group)
#' plot_emmeans(cmp)
#'
#' plot_emmeans(cmp, data = PlantGrowth, x = group, y = weight, show_data = TRUE)
#'
#' m2 <- stats::lm(breaks ~ wool * tension, data = warpbreaks)
#' cmp2 <- comparar_emmeans(m2, ~ tension | wool)
#' plot_emmeans(cmp2, data = warpbreaks, x = tension, y = breaks)
plot_emmeans <- function(object,
                         data = NULL,
                         x = NULL,
                         y = NULL,
                         show_data = TRUE,
                         interval = "confidence",
                         letters = FALSE,
                         theme = theme_nogrid()) {
  if (inherits(object, "myfuns_emmeans")) {
    est <- object$estimativas
    cld <- object$cld
  } else {
    est <- as.data.frame(summary(object, infer = c(TRUE, FALSE)))
    cld <- NULL
  }
  if (!identical(interval, "confidence")) warning("No momento, `interval` usa os intervalos de confiança disponíveis em `emmeans`.", call. = FALSE)

  emm_x <- .primary_emm_var(est)
  if (is.null(emm_x)) stop("Não foi possível identificar a variável principal das EMMs.", call. = FALSE)
  estimate_col <- .emm_estimate_col(est)
  ci <- .emm_ci_cols(est)
  if (anyNA(ci)) stop("O objeto não contém limites de intervalo reconhecidos.", call. = FALSE)

  stat_names <- c(estimate_col, "SE", "df", ci, "p.value", "t.ratio", "z.ratio")
  by_vars <- setdiff(names(est)[vapply(est, function(z) is.factor(z) || is.character(z), logical(1))], c(emm_x, stat_names))
  group_var <- if (length(by_vars)) by_vars[1L] else NULL

  p <- ggplot2::ggplot(est, ggplot2::aes(x = !!rlang::sym(emm_x), y = !!rlang::sym(estimate_col)))
  dodge <- ggplot2::position_dodge(width = 0.35)
  if (!is.null(group_var)) {
    p <- p + ggplot2::aes(group = !!rlang::sym(group_var), shape = !!rlang::sym(group_var))
  }

  if (!is.null(data) && isTRUE(show_data)) {
    x_name <- if (missing(x) || is.null(substitute(x))) emm_x else .arg_name(substitute(x), data)
    if (missing(y) || is.null(substitute(y))) stop("Informe `y` quando `data` for usado.", call. = FALSE)
    y_name <- .arg_name(substitute(y), data, allow_null = FALSE)
    .check_columns(data, c(x_name, y_name, group_var))
    raw_map <- if (is.null(group_var) || !group_var %in% names(data)) {
      ggplot2::aes(x = !!rlang::sym(x_name), y = !!rlang::sym(y_name))
    } else {
      ggplot2::aes(x = !!rlang::sym(x_name), y = !!rlang::sym(y_name), shape = !!rlang::sym(group_var), group = !!rlang::sym(group_var))
    }
    p <- p + ggplot2::geom_jitter(
      data = data, mapping = raw_map, inherit.aes = FALSE,
      width = 0.08, height = 0, alpha = 0.45
    )
  }

  p <- p +
    ggplot2::geom_errorbar(
      ggplot2::aes(ymin = !!rlang::sym(ci[1L]), ymax = !!rlang::sym(ci[2L])),
      width = 0.12, position = dodge
    ) +
    ggplot2::geom_point(size = 2.6, position = dodge) +
    ggplot2::labs(x = emm_x, y = "Média marginal estimada") +
    theme

  if (isTRUE(letters) && !is.null(cld) && ".group" %in% names(cld)) {
    lx <- .primary_emm_var(cld)
    le <- .emm_estimate_col(cld)
    p <- p + ggplot2::geom_text(
      data = cld,
      mapping = ggplot2::aes(x = !!rlang::sym(lx), y = !!rlang::sym(le), label = trimws(!!rlang::sym(".group"))),
      inherit.aes = FALSE, vjust = -1.1
    )
  }
  p
}

#' Gráfico para regressão de fator quantitativo
#'
#' Mostra observações, médias por nível, curva ajustada, intervalo de confiança
#' e equação do modelo principal de um objeto produzido por [reg_poly()].
#'
#' @param object Resultado de [reg_poly()].
#' @param data Banco opcional. Por padrão, usa o banco armazenado em `object`.
#' @param x Variável quantitativa. Por padrão, usa a registrada em `object`.
#' @param y Variável resposta. Por padrão, usa a registrada em `object`.
#' @param show_raw Mostrar observações individuais?
#' @param show_means Mostrar médias observadas por nível?
#' @param interval Mostrar intervalo de confiança?
#' @param equation Adicionar equação e R² ao gráfico?
#' @param theme Tema `ggplot2`.
#'
#' @return Objeto `ggplot`.
#' @export
#'
#' @examples
#' d <- data.frame(dose = rep(c(0, 50, 100, 150), each = 4))
#' d$y <- 12 + 0.2 * d$dose - 0.0008 * d$dose^2 + stats::rnorm(nrow(d))
#' rp <- reg_poly(d, y, dose, degree = 2)
#' plot_reg(rp)
#'
#' plot_reg(rp, data = d, x = dose, y = y, show_raw = TRUE, show_means = TRUE)
#'
#' plot_reg(rp, equation = FALSE)
plot_reg <- function(object,
                     data = NULL,
                     x = NULL,
                     y = NULL,
                     show_raw = TRUE,
                     show_means = TRUE,
                     interval = "confidence",
                     equation = TRUE,
                     theme = theme_nogrid()) {
  if (!inherits(object, "myfuns_reg_poly")) stop("`object` deve ser resultado de `reg_poly()`.", call. = FALSE)
  if (is.null(data)) data <- object$data
  x_name <- if (missing(x) || is.null(substitute(x))) object$x else .arg_name(substitute(x), data)
  y_name <- if (missing(y) || is.null(substitute(y))) object$y else .arg_name(substitute(y), data)
  .check_columns(data, c(x_name, y_name))

  pred <- object$predicoes
  p <- ggplot2::ggplot()
  if (isTRUE(show_raw)) {
    p <- p + ggplot2::geom_point(
      data = data,
      mapping = ggplot2::aes(x = !!rlang::sym(x_name), y = !!rlang::sym(y_name)),
      alpha = 0.45
    )
  }
  if (isTRUE(show_means)) {
    means <- aggregate(data[[y_name]], by = list(x = data[[x_name]]), FUN = mean)
    names(means) <- c(x_name, "media")
    p <- p + ggplot2::geom_point(
      data = means,
      mapping = ggplot2::aes(x = !!rlang::sym(x_name), y = !!rlang::sym("media")),
      size = 3
    )
  }
  if (identical(interval, "confidence")) {
    p <- p + ggplot2::geom_ribbon(
      data = pred,
      mapping = ggplot2::aes(x = !!rlang::sym(object$x), ymin = !!rlang::sym("ic_inferior"), ymax = !!rlang::sym("ic_superior")),
      inherit.aes = FALSE, alpha = 0.18
    )
  }
  p <- p +
    ggplot2::geom_line(
      data = pred,
      mapping = ggplot2::aes(x = !!rlang::sym(object$x), y = !!rlang::sym("ajustado")),
      linewidth = 0.9
    ) +
    ggplot2::labs(x = x_name, y = y_name) +
    theme

  if (isTRUE(equation)) {
    cf <- stats::coef(object$model)
    terms <- names(cf)
    label <- paste0("ŷ = ", formatC(cf[1L], digits = 3, format = "fg"))
    if (length(cf) >= 2L) {
      for (i in 2:length(cf)) {
        val <- cf[i]
        term <- terms[i]
        term <- gsub("I\\(([^)]+)\\)", "\\1", term)
        label <- paste0(label, if (val >= 0) " + " else " - ", formatC(abs(val), digits = 3, format = "fg"), "·", term)
      }
    }
    r2 <- summary(object$model)$r.squared
    label <- paste0(label, "; R² = ", formatC(r2, digits = 3, format = "f"))
    p <- p + ggplot2::annotate("text", x = -Inf, y = Inf, label = label, hjust = -0.03, vjust = 1.15)
  }
  p
}
