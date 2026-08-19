#' ANOVA organizada para experimentação agrícola
#'
#' Reúne tabela de análise de variância, coeficiente de variação, tamanho de
#' efeito e informações básicas do modelo em um único objeto. A função não usa
#' significância estatística para tomar decisões automáticas sobre tratamentos.
#'
#' @param model Modelo ajustado, tipicamente `lm` ou `aov`.
#' @param effect_size Tamanho de efeito. Opções: `"eta2_partial"`, `"eta2"`,
#'   `"omega2_partial"`, `"omega2"` ou `"none"`.
#' @param cv Calcular coeficiente de variação experimental? Padrão `TRUE`.
#' @param conf.level Nível de confiança usado por `effectsize`, quando disponível.
#'
#' @return Lista da classe `myfuns_anova`.
#' @export
#'
#' @examples
#' m1 <- stats::lm(weight ~ group, data = PlantGrowth)
#' anova_agri(m1)
#'
#' m2 <- stats::lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
#' anova_agri(m2, effect_size = "eta2")
#'
#' anova_agri(m1, cv = FALSE, effect_size = "eta2_partial")
anova_agri <- function(model,
                       effect_size = c("eta2_partial", "eta2", "omega2_partial", "omega2", "none"),
                       cv = TRUE,
                       conf.level = 0.95) {
  effect_size <- match.arg(effect_size)
  if (!is.numeric(conf.level) || length(conf.level) != 1L || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` deve estar entre 0 e 1.", call. = FALSE)
  }

  tab <- stats::anova(model)
  y <- .model_response(model)
  cv_value <- NA_real_
  if (isTRUE(cv)) {
    cv_value <- .cv_model(model)
    if (!is.finite(cv_value)) {
      warning("N\u00E3o foi poss\u00EDvel calcular o CV a partir da resposta e de `sigma(modelo)`.", call. = FALSE)
    }
  }

  efeito <- NULL
  if (effect_size != "none") {
    if (requireNamespace("effectsize", quietly = TRUE)) {
      efeito <- switch(
        effect_size,
        eta2_partial = effectsize::eta_squared(model, partial = TRUE, ci = conf.level),
        eta2 = effectsize::eta_squared(model, partial = FALSE, ci = conf.level),
        omega2_partial = effectsize::omega_squared(model, partial = TRUE, ci = conf.level),
        omega2 = effectsize::omega_squared(model, partial = FALSE, ci = conf.level)
      )
    } else if (effect_size == "eta2_partial" && inherits(model, "lm")) {
      ss_col <- grep("Sum Sq", names(tab), value = TRUE)[1L]
      if (!is.na(ss_col)) {
        ss <- tab[[ss_col]]
        termo <- row.names(tab)
        erro_idx <- which(tolower(termo) %in% c("residuals", "res\u00EDduo", "residuos", "res\u00EDduos"))
        if (length(erro_idx) == 1L) {
          ss_error <- ss[erro_idx]
          keep <- setdiff(seq_along(ss), erro_idx)
          efeito <- data.frame(
            Parameter = termo[keep],
            Eta2_partial = ss[keep] / (ss[keep] + ss_error),
            CI = NA_real_,
            CI_low = NA_real_,
            CI_high = NA_real_,
            stringsAsFactors = FALSE
          )
          warning("`effectsize` n\u00E3o est\u00E1 instalado; eta\u00B2 parcial foi calculado diretamente, sem intervalo de confian\u00E7a.", call. = FALSE)
        }
      }
    } else {
      warning("Instale `effectsize` para obter o tamanho de efeito solicitado.", call. = FALSE)
    }
  }

  info <- data.frame(
    classe = paste(class(model), collapse = "/"),
    n = tryCatch(stats::nobs(model), error = function(e) NA_integer_),
    resposta = .model_response_name(model),
    formula = .model_formula_text(model),
    stringsAsFactors = FALSE
  )

  out <- list(anova = tab, cv = cv_value, efeito = efeito, modelo = info, objeto = model)
  class(out) <- c("myfuns_anova", "list")
  out
}

#' @export
print.myfuns_anova <- function(x, ...) {
  cat("ANOVA agr\u00EDcola\n")
  cat("--------------\n")
  print(x$anova)
  if (is.finite(x$cv)) cat("\nCV experimental: ", format(round(x$cv, 2), nsmall = 2), "%\n", sep = "")
  if (!is.null(x$efeito)) {
    cat("\nTamanho de efeito:\n")
    print(x$efeito)
  }
  invisible(x)
}

#' Calcular médias marginais estimadas para uma lista de modelos
#'
#' Aplica [emmeans::emmeans()] aos elementos selecionados de uma lista de
#' modelos. É útil quando várias variáveis resposta compartilham a mesma
#' estrutura experimental.
#'
#' @param object Lista de modelos.
#' @param specs Especificação repassada a [emmeans::emmeans()].
#' @param ... Argumentos adicionais para [emmeans::emmeans()].
#' @param which Índices dos elementos que serão processados.
#'
#' @return Lista de objetos `emmGrid`.
#' @export
#'
#' @examples
#' m1 <- stats::lm(Sepal.Length ~ Species, data = iris)
#' m2 <- stats::lm(Petal.Length ~ Species, data = iris)
#' emmeans_lista(list(sepala = m1, petala = m2), ~ Species)
#'
#' mods <- list(sepala = m1, petala = m2)
#' emmeans_lista(mods, ~ Species, which = 2)
#'
#' mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
#' emmeans_lista(list(quebras = mp), ~ tension | wool, type = "response")
emmeans_lista <- function(object, specs, ..., which = seq_along(object)) {
  if (!is.list(object)) stop("`object` deve ser uma lista de modelos.", call. = FALSE)
  which <- .validate_which(which, length(object))
  lapply(object[which], emmeans::emmeans, specs = specs, ...)
}

#' Organizar médias marginais estimadas e contrastes
#'
#' Gera EMMs, intervalos de confiança e contrastes em um objeto único, mantendo
#' o `emmGrid` original disponível para inferências posteriores. Opcionalmente,
#' pode calcular compact letter display.
#'
#' @param model Modelo aceito por [emmeans::emmeans()].
#' @param specs Especificação das médias marginais.
#' @param method Família de contrastes repassada a [emmeans::contrast()].
#' @param adjust Método de ajuste de multiplicidade.
#' @param type Escala das estimativas, como `"response"` ou `"link"`.
#' @param cld Calcular letras de comparação? Padrão `FALSE`.
#' @param delta Margem de equivalência usada apenas quando `cld = TRUE` e
#'   suportada pelo método de `emmeans`.
#' @param ... Argumentos adicionais. Argumentos como `ref` são repassados aos
#'   contrastes; argumentos próprios de `emmeans()` devem ser informados antes
#'   da criação do objeto quando necessário.
#'
#' @return Lista da classe `myfuns_emmeans`.
#' @export
#'
#' @examples
#' m <- stats::lm(weight ~ group, data = PlantGrowth)
#' comparar_emmeans(m, ~ group, method = "pairwise", adjust = "tukey")
#'
#' comparar_emmeans(m, ~ group, method = "trt.vs.ctrl", adjust = "dunnettx", ref = 1)
#'
#' m2 <- stats::lm(breaks ~ wool * tension, data = warpbreaks)
#' comparar_emmeans(m2, ~ tension | wool, method = "pairwise", adjust = "tukey")
comparar_emmeans <- function(model,
                             specs,
                             method = "pairwise",
                             adjust = "tukey",
                             type = "response",
                             cld = FALSE,
                             delta = 0,
                             ...) {
  dots <- list(...)
  emm <- emmeans::emmeans(model, specs = specs, type = type)
  contrast_args <- c(list(object = emm, method = method, adjust = adjust), dots)
  contr <- do.call(emmeans::contrast, contrast_args)

  estimativas <- as.data.frame(summary(emm, infer = c(TRUE, FALSE), type = type))
  contrastes <- as.data.frame(summary(contr, infer = c(TRUE, TRUE), type = type))
  intervalos <- as.data.frame(stats::confint(emm, type = type))

  letras <- NULL
  if (isTRUE(cld)) {
    .require_namespace("multcompView", "comparar_emmeans")
    cld_args <- c(list(object = emm, adjust = adjust, delta = delta, type = type), dots)
    letras <- tryCatch(
      as.data.frame(do.call(multcomp::cld, cld_args)),
      error = function(e) {
        warning(paste0("N\u00E3o foi poss\u00EDvel calcular CLD: ", conditionMessage(e)), call. = FALSE)
        NULL
      }
    )
  }

  out <- list(
    emm = emm,
    estimativas = estimativas,
    intervalos = intervalos,
    contraste = contr,
    contrastes = contrastes,
    cld = letras,
    modelo = model,
    specs = specs,
    method = method,
    adjust = adjust,
    type = type
  )
  class(out) <- c("myfuns_emmeans", "list")
  out
}

#' @export
print.myfuns_emmeans <- function(x, ...) {
  cat("M\u00E9dias marginais estimadas\n")
  cat("--------------------------\n")
  print(x$estimativas, row.names = FALSE)
  cat("\nContrastes:\n")
  print(x$contrastes, row.names = FALSE)
  if (!is.null(x$cld)) {
    cat("\nGrupos por letras (CLD):\n")
    print(x$cld, row.names = FALSE)
  }
  invisible(x)
}

#' Contrastes polinomiais com os valores reais do fator quantitativo
#'
#' Calcula contrastes polinomiais ortogonais com `emmeans`. Quando os níveis
#' quantitativos são desigualmente espaçados, utiliza `opoly`, que admite
#' `scores` reais. A função informa explicitamente os escores usados e não
#' escolhe automaticamente o grau da regressão.
#'
#' @param emm Objeto `emmGrid` com médias estimadas de um fator quantitativo.
#' @param scores Valores numéricos correspondentes aos níveis. Se `NULL`, a
#'   função tenta converter os níveis do primeiro fator do `emmGrid` para número.
#' @param degree Maior grau a ser retornado. `NULL` usa o máximo permitido.
#' @param normalized Se `TRUE`, usa `opoly`, cujos coeficientes são normalizados.
#'   Se `FALSE`, `poly` só é usado quando os escores são igualmente espaçados.
#' @param adjust Ajuste de multiplicidade. O padrão é `"none"`.
#'
#' @return Lista da classe `myfuns_contraste_poly` com objeto de contraste,
#'   tabela, escores, grau e informação sobre espaçamento.
#' @export
#'
#' @examples
#' dados <- data.frame(dose = factor(rep(c(0, 50, 100, 150), each = 4)), y = 1:16)
#' m <- stats::lm(y ~ dose, data = dados)
#' em <- emmeans::emmeans(m, ~ dose)
#' contraste_poly(em, scores = c(0, 50, 100, 150))
#'
#' dados2 <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = 1:16)
#' m2 <- stats::lm(y ~ dose, data = dados2)
#' em2 <- emmeans::emmeans(m2, ~ dose)
#' contraste_poly(em2, scores = c(0, 25, 100, 200))
#'
#' contraste_poly(em, scores = c(0, 50, 100, 150), degree = 2)
contraste_poly <- function(emm,
                           scores = NULL,
                           degree = NULL,
                           normalized = TRUE,
                           adjust = "none") {
  df <- as.data.frame(emm)
  var <- .primary_emm_var(df)
  if (is.null(var)) stop("N\u00E3o foi poss\u00EDvel identificar o fator quantitativo no objeto `emm`.", call. = FALSE)
  levs <- unique(as.character(df[[var]]))

  if (is.null(scores)) {
    scores <- suppressWarnings(as.numeric(levs))
    if (anyNA(scores)) {
      stop("N\u00E3o foi poss\u00EDvel converter os n\u00EDveis para n\u00FAmeros. Informe `scores` explicitamente.", call. = FALSE)
    }
  }
  if (!is.numeric(scores) || anyNA(scores) || length(scores) != length(levs)) {
    stop("`scores` deve ser num\u00E9rico, sem aus\u00EAncias e ter o mesmo n\u00FAmero de valores que os n\u00EDveis do fator.", call. = FALSE)
  }
  if (anyDuplicated(scores)) stop("`scores` deve conter valores distintos.", call. = FALSE)

  max_degree <- length(scores) - 1L
  if (is.null(degree)) degree <- max_degree
  if (!is.numeric(degree) || length(degree) != 1L || is.na(degree) || degree < 1 || degree %% 1 != 0) {
    stop("`degree` deve ser um inteiro positivo.", call. = FALSE)
  }
  degree <- min(as.integer(degree), max_degree)
  equal <- .is_equally_spaced(scores)

  if (!isTRUE(normalized) && !equal) {
    stop("`normalized = FALSE` n\u00E3o \u00E9 adequado a escores desigualmente espa\u00E7ados. Use `normalized = TRUE` para empregar `opoly` com os valores reais.", call. = FALSE)
  }

  method <- if (isTRUE(normalized)) "opoly" else "poly"
  args <- list(object = emm, method = method, max.degree = degree, adjust = adjust)
  if (method == "opoly") args$scores <- scores
  obj <- do.call(emmeans::contrast, args)
  tab <- as.data.frame(summary(obj, infer = c(TRUE, TRUE)))

  out <- list(
    contraste = obj,
    tabela = tab,
    scores = stats::setNames(as.numeric(scores), levs),
    variavel = var,
    igualmente_espacados = equal,
    grau = degree,
    metodo = method,
    adjust = adjust
  )
  class(out) <- c("myfuns_contraste_poly", "list")
  out
}

#' @export
print.myfuns_contraste_poly <- function(x, ...) {
  cat("Contrastes polinomiais\n")
  cat("-----------------------\n")
  cat("M\u00E9todo: ", x$metodo, "\n", sep = "")
  cat("Escores: ", paste(names(x$scores), x$scores, sep = "=", collapse = ", "), "\n", sep = "")
  cat("Espa\u00E7amento regular: ", if (x$igualmente_espacados) "sim" else "n\u00E3o", "\n\n", sep = "")
  print(x$tabela, row.names = FALSE)
  invisible(x)
}

#' @export
as.data.frame.myfuns_contraste_poly <- function(x, ...) x$tabela