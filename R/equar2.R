#' Gerar equacao de regressao a partir de medias e contrastes polinomiais
#'
#' Seleciona entre media constante, regressao linear e regressao quadratica com
#' base nos valores de p dos contrastes `linear` e `quadratic`. A equacao e
#' devolvida como texto compativel com `plotmath`, adequado para anotacoes com
#' `ggplot2::geom_text(parse = TRUE)` ou `ggplot2::annotate(parse = TRUE)`.
#'
#' @param media Objeto coercivel a `data.frame` com duas colunas. A primeira
#'   contem os niveis quantitativos de `x`; a segunda, as medias de `y`.
#' @param contrast_result Objeto coercivel a `data.frame` contendo as colunas
#'   `contrast` e `p.value`, tipicamente produzido por
#'   `emmeans::contrast(..., "poly")` ou por [contraste_poly()].
#' @param alpha Nivel de significancia usado para selecionar o grau do modelo.
#' @param strong_alpha Nivel usado para marcar `**`; valores de p entre
#'   `strong_alpha` e `alpha` recebem `*`.
#' @param digits Vetor nomeado ou nao com quatro valores: casas decimais para
#'   intercepto/media, termo linear, termo quadratico e R2, respectivamente.
#' @param r2_percent Se `TRUE`, mostra R2 em porcentagem, como na funcao
#'   historica; se `FALSE`, mostra R2 entre 0 e 1.
#' @param details Se `FALSE`, retorna apenas a equacao. Se `TRUE`, retorna uma
#'   lista com equacao, grau selecionado, modelo ajustado, R2 e p-valores.
#'
#' @return Por padrao, string `plotmath`. Com `details = TRUE`, lista detalhada.
#' @export
#'
#' @details
#' O ajuste linear ou quadratico e feito sobre as **medias** fornecidas em
#' `media`; portanto, o R2 descreve o ajuste das medias e nao o ajuste aos dados
#' individuais. Os p-valores usados para escolher o grau e marcar os termos vem
#' de `contrast_result`, e nao de `summary(lm(...))`.
#'
#' `emmeans::contrast(method = "poly")` trabalha com níveis igualmente
#' espaçados. Para doses quantitativas com espaçamentos desiguais, prefira
#' [contraste_poly()], que usa `opoly` e os valores numéricos reais. Quando um
#' objeto retornado por [contraste_poly()] é fornecido diretamente, `equar2()`
#' reconhece essa informação e verifica a correspondência dos escores.
#'
#' @examples
#' dados <- data.frame(
#'   TRAT = c(0, 50, 100, 150, 200, 250, 300, 0, 50, 100, 150, 200, 250,
#'            300, 0, 50, 100, 150, 200, 250, 300, 0, 50, 100, 150,
#'            200, 250, 300),
#'   REP = rep(1:4, each = 7),
#'   PESO = c(134.8, 161.7, 160.7, 169.8, 165.7, 171.8, 154.5, 139.7,
#'            157.7, 172.7, 168.2, 160, 157.3, 160.4, 147.6, 150.3,
#'            163.4, 160.7, 158.2, 150.4, 148.8, 132.3, 144.7, 161.3,
#'            161, 151, 160.4, 154)
#' )
#'
#' dados$TRATq <- dados$TRAT
#' dados$TRAT <- factor(dados$TRAT)
#' modelo <- stats::lm(PESO ~ TRAT, data = dados)
#' teste <- as.data.frame(
#'   emmeans::contrast(emmeans::emmeans(modelo, ~ TRAT), "poly")
#' )
#' medias <- stats::aggregate(PESO ~ TRATq, data = dados, FUN = mean)
#' equar2(medias, teste)
equar2 <- function(media,
                   contrast_result,
                   alpha = 0.05,
                   strong_alpha = 0.01,
                   digits = c(2, 3, 4, 1),
                   r2_percent = TRUE,
                   details = FALSE) {
  media <- as.data.frame(media)
  meta_poly <- if (inherits(contrast_result, "myfuns_contraste_poly")) {
    list(scores = unname(contrast_result$scores), metodo = contrast_result$metodo)
  } else {
    NULL
  }
  contrast_result <- as.data.frame(contrast_result)

  if (ncol(media) < 2L) {
    stop("`media` deve conter pelo menos duas colunas.", call. = FALSE)
  }
  if (!all(c("contrast", "p.value") %in% names(contrast_result))) {
    stop("`contrast_result` deve conter as colunas `contrast` e `p.value`.", call. = FALSE)
  }
  if (!is.numeric(alpha) || length(alpha) != 1L || is.na(alpha) || alpha <= 0 || alpha >= 1) {
    stop("`alpha` deve estar entre 0 e 1.", call. = FALSE)
  }
  if (!is.numeric(strong_alpha) || length(strong_alpha) != 1L || is.na(strong_alpha) ||
      strong_alpha <= 0 || strong_alpha > alpha) {
    stop("`strong_alpha` deve ser positivo e menor ou igual a `alpha`.", call. = FALSE)
  }
  if (!is.numeric(digits) || length(digits) != 4L || anyNA(digits) || any(digits < 0)) {
    stop("`digits` deve ser um vetor numerico de quatro valores nao negativos.", call. = FALSE)
  }

  x <- .as_numeric_levels(media[[1L]], "primeira coluna de `media`")
  y <- .as_numeric_levels(media[[2L]], "segunda coluna de `media`")
  keep <- stats::complete.cases(x, y)
  x <- x[keep]
  y <- y[keep]

  if (length(x) < 2L) {
    stop("Sao necessarios pelo menos dois pares completos em `media`.", call. = FALSE)
  }

  ord <- order(x)
  x <- x[ord]
  y <- y[ord]

  p_linear <- .extract_poly_p(contrast_result, "linear")
  p_quadratic <- .extract_poly_p(contrast_result, "quadratic", required = FALSE)

  if (length(unique(x)) >= 3L) {
    xu <- sort(unique(x))
    dx <- diff(xu)
    desigual <- length(dx) > 1L && max(dx) - min(dx) > sqrt(.Machine$double.eps) * max(1, max(abs(x)))
    opoly_valido <- !is.null(meta_poly) && identical(meta_poly$metodo, "opoly") &&
      length(meta_poly$scores) == length(xu) &&
      isTRUE(all.equal(sort(as.numeric(meta_poly$scores)), xu, tolerance = sqrt(.Machine$double.eps)))
    if (desigual && !opoly_valido) {
      warning(
        "Os n\u00EDveis num\u00E9ricos de `media` n\u00E3o s\u00E3o igualmente espa\u00E7ados. Use `contraste_poly()` com os valores reais das doses ou verifique a especifica\u00E7\u00E3o dos contrastes.",
        call. = FALSE
      )
    }
  }

  df <- data.frame(x = x, y = y)
  degree <- if (!is.na(p_quadratic) && p_quadratic <= alpha) {
    "quadratic"
  } else if (!is.na(p_linear) && p_linear <= alpha) {
    "linear"
  } else {
    "mean"
  }

  star <- function(p) {
    if (is.na(p) || p > alpha) return("")
    if (p <= strong_alpha) "**" else "*"
  }

  model <- NULL
  r2 <- NA_real_

  if (degree == "mean") {
    estimate <- mean(df$y)
    equation <- paste0(
      "hat(y) == bar(y) == ",
      .fmt_number(estimate, digits[1L])
    )
  } else if (degree == "linear") {
    model <- stats::lm(y ~ x, data = df)
    cf <- stats::coef(model)
    r2 <- summary(model)$r.squared
    equation <- paste0(
      "hat(y) == ", .fmt_number(cf[[1L]], digits[1L]),
      .fmt_term(cf[[2L]], digits[2L], "x", star(p_linear)),
      " ~ \";\" ~ R^2 == \"", .fmt_r2(r2, digits[4L], r2_percent), "\""
    )
  } else {
    model <- stats::lm(y ~ x + I(x^2), data = df)
    cf <- stats::coef(model)
    r2 <- summary(model)$r.squared
    equation <- paste0(
      "hat(y) == ", .fmt_number(cf[[1L]], digits[1L]),
      .fmt_term(cf[[2L]], digits[2L], "x", star(p_linear)),
      .fmt_term(cf[[3L]], digits[3L], "x^2", star(p_quadratic)),
      " ~ \";\" ~ R^2 == \"", .fmt_r2(r2, digits[4L], r2_percent), "\""
    )
  }

  if (!isTRUE(details)) {
    return(equation)
  }

  list(
    equation = equation,
    degree = degree,
    model = model,
    r_squared = r2,
    p_values = c(linear = p_linear, quadratic = p_quadratic),
    data = df
  )
}

.extract_poly_p <- function(x, label, required = TRUE) {
  labels <- tolower(trimws(as.character(x$contrast)))
  idx <- which(labels == tolower(label))

  if (length(idx) == 0L) {
    if (required) {
      stop(sprintf("Contraste `%s` nao encontrado em `contrast_result`.", label), call. = FALSE)
    }
    return(NA_real_)
  }
  if (length(idx) > 1L) {
    stop(
      sprintf("Ha mais de um contraste `%s`. Subdivida `contrast_result` por grupo antes de usar `equar2()`.", label),
      call. = FALSE
    )
  }

  p <- x$p.value[idx]
  if (!is.numeric(p) || length(p) != 1L || is.na(p)) {
    stop(sprintf("O p-valor do contraste `%s` deve ser numerico e nao ausente.", label), call. = FALSE)
  }
  p
}

.as_numeric_levels <- function(x, label) {
  if (is.numeric(x)) return(as.numeric(x))
  out <- suppressWarnings(as.numeric(as.character(x)))
  bad <- is.na(out) & !is.na(x)
  if (any(bad)) {
    stop(sprintf("A %s deve ser numerica ou coercivel sem perda para numerico.", label), call. = FALSE)
  }
  out
}

.fmt_number <- function(x, digits) {
  formatC(x, format = "f", digits = as.integer(digits))
}

.fmt_term <- function(coef, digits, variable, stars = "") {
  sign <- if (coef < 0) " - " else " + "
  value <- formatC(abs(coef), format = "f", digits = as.integer(digits))
  if (nzchar(stars)) value <- paste0(value, "^\"", stars, "\"")
  paste0(sign, value, " * ", variable)
}

.fmt_r2 <- function(r2, digits, percent) {
  if (isTRUE(percent)) {
    paste0(formatC(100 * r2, format = "f", digits = as.integer(digits)), "%")
  } else {
    formatC(r2, format = "f", digits = as.integer(digits))
  }
}