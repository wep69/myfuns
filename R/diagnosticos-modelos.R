#' Diagnóstico orientado pela classe do modelo
#'
#' Reúne verificações coerentes com modelos lineares, GLM, modelos mistos de
#' `lme4` e modelos `glmmTMB`. Quando o pacote `performance` está disponível,
#' utiliza suas verificações especializadas. Nenhum teste isolado é usado para
#' aceitar, rejeitar ou substituir automaticamente o modelo.
#'
#' @param model Modelo ajustado.
#' @param simulations Número de simulações para diagnósticos que as utilizem.
#' @param seed Semente de reprodutibilidade.
#' @param plot Produzir objeto de diagnóstico visual com `performance::check_model()`?
#' @param verbose Imprimir síntese em português?
#'
#' @return Lista da classe `myfuns_diagnostico`.
#' @export
#'
#' @examples
#' m1 <- stats::lm(weight ~ group, data = PlantGrowth)
#' diagnostico_modelo(m1, plot = FALSE)
#'
#' mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
#' diagnostico_modelo(mp, simulations = 200, plot = FALSE)
#'
#' if (requireNamespace("glmmTMB", quietly = TRUE)) {
#'   mnb <- glmmTMB::glmmTMB(breaks ~ wool * tension, family = glmmTMB::nbinom2, data = warpbreaks)
#'   diagnostico_modelo(mnb, simulations = 200, plot = FALSE)
#' }
diagnostico_modelo <- function(model,
                               simulations = 1000,
                               seed = 123,
                               plot = TRUE,
                               verbose = TRUE) {
  if (!is.numeric(simulations) || length(simulations) != 1L || simulations < 1) stop("`simulations` deve ser positivo.", call. = FALSE)
  classe <- class(model)
  info <- list(
    classe = classe,
    formula = .model_formula_text(model),
    resposta = .model_response_name(model),
    n = tryCatch(stats::nobs(model), error = function(e) NA_integer_)
  )
  checks <- list()

  if (inherits(model, "lm") && !inherits(model, "glm")) {
    r <- stats::residuals(model)
    checks$residuos <- data.frame(
      n = length(r), media = mean(r), dp = stats::sd(r),
      minimo = min(r), maximo = max(r)
    )
    if (length(r) >= 3L && length(r) <= 5000L) checks$shapiro <- stats::shapiro.test(r)
  }

  if (inherits(model, "glm")) {
    fam <- stats::family(model)
    info$familia <- fam$family
    info$link <- fam$link
  } else {
    fam <- tryCatch(stats::family(model), error = function(e) NULL)
    if (!is.null(fam)) {
      info$familia <- fam$family
      info$link <- fam$link
    }
  }

  if (requireNamespace("performance", quietly = TRUE)) {
    if (inherits(model, "lm") && !inherits(model, "glm")) {
      checks$heterocedasticidade <- .safe_call(performance::check_heteroscedasticity(model))
      checks$colinearidade <- .safe_call(performance::check_collinearity(model))
      checks$influencia <- .safe_call(performance::check_outliers(model))
    }
    if (inherits(model, "glm") || inherits(model, "glmmTMB") || inherits(model, "glmerMod")) {
      checks$dispersao <- .safe_call(performance::check_overdispersion(model))
      checks$zeros <- .safe_call(performance::check_zeroinflation(model))
    }
    if (inherits(model, "merMod") || inherits(model, "glmmTMB")) {
      checks$convergencia <- .safe_call(performance::check_convergence(model))
      checks$singularidade <- .safe_call(performance::check_singularity(model))
    }
    checks$desempenho <- .safe_call(performance::model_performance(model))
    grafico <- if (isTRUE(plot)) .safe_call(performance::check_model(model)) else NULL
  } else {
    grafico <- NULL
    checks$nota_performance <- "Instale `performance` para verifica\u00e7\u00f5es adicionais de heterocedasticidade, colinearidade, dispers\u00e3o, zeros, converg\u00eancia e singularidade."
  }

  # Resíduos simulados são especialmente úteis para modelos generalizados e mistos.
  residuos_simulados <- NULL
  usar_dharma <- inherits(model, c("glm", "glmerMod", "glmmTMB"))
  if (usar_dharma && requireNamespace("DHARMa", quietly = TRUE)) {
    residuos_simulados <- .safe_call(
      DHARMa::simulateResiduals(
        fittedModel = model, n = as.integer(simulations), plot = FALSE, seed = seed
      )
    )
    if (!.is_error_result(residuos_simulados)) {
      checks$uniformidade_DHARMa <- .safe_call(DHARMa::testUniformity(residuos_simulados, plot = FALSE))
      checks$dispersao_DHARMa <- .safe_call(DHARMa::testDispersion(residuos_simulados, plot = FALSE))
      checks$outliers_DHARMa <- .safe_call(DHARMa::testOutliers(residuos_simulados, plot = FALSE))
    }
  } else if (usar_dharma) {
    checks$nota_DHARMa <- "Instale `DHARMa` para acrescentar diagn\u00f3stico por res\u00edduos simulados."
  }

  out <- list(
    informacoes = info,
    verificacoes = checks,
    residuos_simulados = residuos_simulados,
    grafico = grafico,
    simulations = simulations,
    seed = seed
  )
  class(out) <- c("myfuns_diagnostico", "list")

  if (isTRUE(verbose)) {
    cat("Diagn\u00f3stico do modelo\n")
    cat("---------------------\n")
    cat("Classe: ", paste(classe, collapse = "/"), "\n", sep = "")
    cat("Resposta: ", info$resposta, "\n", sep = "")
    cat("n: ", info$n, "\n", sep = "")
    if (!requireNamespace("performance", quietly = TRUE)) cat("Observa\u00e7\u00e3o: instale `performance` para ampliar as verifica\u00e7\u00f5es.\n")
    cat("Interprete as verifica\u00e7\u00f5es em conjunto com o delineamento, os res\u00edduos e a finalidade cient\u00edfica.\n")
  }
  out
}

#' Resumir modelos mistos
#'
#' Organiza efeitos fixos, intervalos de confiança de Wald, componentes de
#' variância, ICC, R² marginal e condicional, singularidade e convergência para
#' modelos `merMod` e `glmmTMB` quando as informações estão disponíveis.
#'
#' @param model Modelo misto.
#' @param conf.level Nível de confiança dos efeitos fixos.
#' @param exponentiate Exponenciar estimativas e intervalos dos efeitos fixos?
#'
#' @return Lista da classe `myfuns_resumo_misto`.
#' @export
#'
#' @examples
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   m1 <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
#'   resumo_misto(m1)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   m2 <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
#'   resumo_misto(m2)
#' }
#'
#' if (requireNamespace("lme4", quietly = TRUE)) {
#'   m3 <- lme4::glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
#'     family = binomial, data = lme4::cbpp)
#'   resumo_misto(m3, exponentiate = TRUE)
#' }
resumo_misto <- function(model, conf.level = 0.95, exponentiate = FALSE) {
  if (!inherits(model, "merMod") && !inherits(model, "glmmTMB")) {
    stop("`resumo_misto()` atualmente suporta modelos `merMod` e `glmmTMB`.", call. = FALSE)
  }
  z <- stats::qnorm(1 - (1 - conf.level) / 2)

  if (inherits(model, "merMod")) {
    cf <- stats::coef(summary(model))
    fix <- data.frame(
      termo = row.names(cf), estimativa = cf[, 1L], erro_padrao = cf[, 2L],
      estatistica = cf[, 3L], row.names = NULL, stringsAsFactors = FALSE
    )
    if (ncol(cf) >= 4L) fix$p_valor <- cf[, 4L]
    random <- tryCatch(as.data.frame(lme4::VarCorr(model)), error = function(e) NULL)
    niveis <- tryCatch(data.frame(grupo = names(lme4::ngrps(model)), n_niveis = as.integer(lme4::ngrps(model))), error = function(e) NULL)
  } else {
    sm <- summary(model)
    cf <- sm$coefficients$cond
    fix <- data.frame(
      termo = row.names(cf), estimativa = cf[, 1L], erro_padrao = cf[, 2L],
      estatistica = cf[, 3L], p_valor = cf[, 4L], row.names = NULL, stringsAsFactors = FALSE
    )
    random <- tryCatch(as.data.frame(glmmTMB::VarCorr(model)), error = function(e) NULL)
    niveis <- NULL
  }

  fix$ic_inferior <- fix$estimativa - z * fix$erro_padrao
  fix$ic_superior <- fix$estimativa + z * fix$erro_padrao
  if (isTRUE(exponentiate)) {
    fix$estimativa <- exp(fix$estimativa)
    fix$ic_inferior <- exp(fix$ic_inferior)
    fix$ic_superior <- exp(fix$ic_superior)
  }

  desempenho <- singularidade <- convergencia <- icc <- r2 <- NULL
  if (requireNamespace("performance", quietly = TRUE)) {
    desempenho <- .safe_call(performance::model_performance(model))
    icc <- .safe_call(performance::icc(model))
    r2 <- .safe_call(performance::r2(model))
    singularidade <- .safe_call(performance::check_singularity(model))
    convergencia <- .safe_call(performance::check_convergence(model))
  }

  out <- list(
    efeitos_fixos = fix,
    efeitos_aleatorios = random,
    icc = icc,
    r2 = r2,
    desempenho = desempenho,
    singularidade = singularidade,
    convergencia = convergencia,
    niveis_aleatorios = niveis,
    modelo = model,
    exponentiado = exponentiate,
    conf.level = conf.level
  )
  class(out) <- c("myfuns_resumo_misto", "list")
  out
}

#' @export
print.myfuns_resumo_misto <- function(x, ...) {
  cat("Resumo do modelo misto\n")
  cat("----------------------\n")
  print(x$efeitos_fixos, row.names = FALSE)
  if (!is.null(x$efeitos_aleatorios)) {
    cat("\nComponentes de vari\u00e2ncia:\n")
    print(x$efeitos_aleatorios, row.names = FALSE)
  }
  if (!is.null(x$desempenho)) {
    cat("\nDesempenho do modelo:\n")
    print(x$desempenho)
  }
  invisible(x)
}

#' Diagnóstico de modelos de contagem
#'
#' Centraliza verificações de dispersão, frequência de zeros, resíduos simulados
#' e observações discrepantes para modelos de contagem. A função não troca a
#' família do modelo automaticamente.
#'
#' @param model Modelo de contagem ajustado.
#' @param simulations Número de simulações para `DHARMa`.
#' @param test_dispersion Executar teste de dispersão?
#' @param test_zeros Executar teste de excesso ou deficiência de zeros?
#' @param test_outliers Executar teste de observações discrepantes?
#' @param seed Semente para as simulações.
#'
#' @return Lista da classe `myfuns_diagnostico_contagem`.
#' @export
#'
#' @examples
#' mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
#' diagnostico_contagem(mp, simulations = 200)
#'
#' if (requireNamespace("MASS", quietly = TRUE)) {
#'   mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
#'   diagnostico_contagem(mnb, simulations = 200)
#' }
#'
#' if (requireNamespace("glmmTMB", quietly = TRUE)) {
#'   mzi <- glmmTMB::glmmTMB(breaks ~ tension, ziformula = ~1,
#'     family = glmmTMB::nbinom2, data = warpbreaks)
#'   diagnostico_contagem(mzi, simulations = 200)
#' }
diagnostico_contagem <- function(model,
                                 simulations = 1000,
                                 test_dispersion = TRUE,
                                 test_zeros = TRUE,
                                 test_outliers = TRUE,
                                 seed = 123) {
  y <- .model_response(model)
  if (is.null(y) || is.matrix(y) || !is.numeric(y)) {
    stop("N\u00e3o foi poss\u00edvel obter uma resposta num\u00e9rica univariada do modelo.", call. = FALSE)
  }
  if (any(y < 0, na.rm = TRUE)) warning("A resposta cont\u00e9m valores negativos; verifique se este \u00e9 realmente um modelo de contagem.", call. = FALSE)

  desc <- data.frame(
    n = length(y),
    media = mean(y, na.rm = TRUE),
    variancia = stats::var(y, na.rm = TRUE),
    zeros = sum(y == 0, na.rm = TRUE),
    proporcao_zeros = mean(y == 0, na.rm = TRUE)
  )

  pearson <- tryCatch(stats::residuals(model, type = "pearson"), error = function(e) NULL)
  dfres <- tryCatch(stats::df.residual(model), error = function(e) NA_real_)
  disp_base <- NULL
  if (!is.null(pearson) && is.finite(dfres) && dfres > 0) {
    ratio <- sum(pearson^2, na.rm = TRUE) / dfres
    p <- stats::pchisq(sum(pearson^2, na.rm = TRUE), df = dfres, lower.tail = FALSE)
    disp_base <- data.frame(razao_pearson = ratio, gl = dfres, p_valor = p)
  }

  checks <- list()
  if (requireNamespace("performance", quietly = TRUE)) {
    if (isTRUE(test_dispersion)) checks$dispersao_performance <- .safe_call(performance::check_overdispersion(model))
    if (isTRUE(test_zeros)) checks$zeros_performance <- .safe_call(performance::check_zeroinflation(model))
  }

  simulados <- NULL
  if (requireNamespace("DHARMa", quietly = TRUE)) {
    set.seed(seed)
    simulados <- .safe_call(DHARMa::simulateResiduals(fittedModel = model, n = simulations, plot = FALSE, seed = seed))
    if (!.is_error_result(simulados)) {
      if (isTRUE(test_dispersion)) checks$dispersao_DHARMa <- .safe_call(DHARMa::testDispersion(simulados, plot = FALSE))
      if (isTRUE(test_zeros)) checks$zeros_DHARMa <- .safe_call(DHARMa::testZeroInflation(simulados, plot = FALSE))
      if (isTRUE(test_outliers)) checks$outliers_DHARMa <- .safe_call(DHARMa::testOutliers(simulados, plot = FALSE))
    }
  } else {
    checks$nota_DHARMa <- "Instale `DHARMa` para res\u00edduos simulados e testes correspondentes."
  }

  fam <- tryCatch(stats::family(model), error = function(e) NULL)
  out <- list(
    descritivo = desc,
    familia = if (is.null(fam)) NULL else list(family = fam$family, link = fam$link),
    dispersao_pearson = disp_base,
    verificacoes = checks,
    residuos_simulados = simulados,
    modelo = model,
    simulations = simulations,
    seed = seed
  )
  class(out) <- c("myfuns_diagnostico_contagem", "list")
  out
}

#' Comparar modelos candidatos por múltiplos critérios
#'
#' Calcula AIC, AICc, BIC, log-verossimilhança, R² quando definido e RMSE. Antes
#' da comparação, registra alertas sobre resposta, conjunto de observações e,
#' para modelos lineares mistos, uso de REML com efeitos fixos diferentes.
#'
#' @param ... Modelos nomeados ou uma única lista de modelos.
#' @param metrics Métricas desejadas dentre `AIC`, `AICc`, `BIC`, `logLik`, `R2`
#'   e `RMSE`.
#' @param rank_by Métrica opcional usada apenas para ordenar a tabela.
#' @param check_comparability Realizar verificações de comparabilidade?
#'
#' @return Lista da classe `myfuns_comparacao_modelos`.
#' @export
#'
#' @examples
#' d <- data.frame(x = rep(0:4, each = 4))
#' d$y <- 2 + 1.5 * d$x - 0.2 * d$x^2 + stats::rnorm(nrow(d))
#' ml <- stats::lm(y ~ x, d)
#' mq <- stats::lm(y ~ x + I(x^2), d)
#' comparar_modelos(linear = ml, quadratico = mq)
#'
#' mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
#' if (requireNamespace("MASS", quietly = TRUE)) {
#'   mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
#'   comparar_modelos(poisson = mp, negbin = mnb)
#' }
#'
#' comparar_modelos(linear = ml, quadratico = mq, metrics = c("AICc", "BIC", "RMSE"), rank_by = "AICc")
comparar_modelos <- function(...,
                             metrics = c("AIC", "AICc", "BIC", "logLik", "R2", "RMSE"),
                             rank_by = NULL,
                             check_comparability = TRUE) {
  mods <- list(...)
  if (length(mods) == 1L && is.list(mods[[1L]]) && !inherits(mods[[1L]], c("lm", "glm", "merMod", "glmmTMB"))) mods <- mods[[1L]]
  if (length(mods) < 2L) stop("Informe pelo menos dois modelos para compara\u00e7\u00e3o.", call. = FALSE)
  if (is.null(names(mods))) names(mods) <- paste0("modelo", seq_along(mods))
  empty <- !nzchar(names(mods))
  names(mods)[empty] <- paste0("modelo", which(empty))

  allowed <- c("AIC", "AICc", "BIC", "logLik", "R2", "RMSE")
  metrics <- unique(metrics)
  if (any(!metrics %in% allowed)) stop("`metrics` cont\u00e9m m\u00e9trica n\u00e3o reconhecida.", call. = FALSE)

  tabela <- do.call(rbind, lapply(seq_along(mods), function(i) {
    m <- mods[[i]]
    vals <- list(
      modelo = names(mods)[i],
      classe = class(m)[1L],
      n = tryCatch(stats::nobs(m), error = function(e) NA_integer_),
      AIC = tryCatch(stats::AIC(m), error = function(e) NA_real_),
      AICc = .aicc(m),
      BIC = tryCatch(stats::BIC(m), error = function(e) NA_real_),
      logLik = tryCatch(as.numeric(stats::logLik(m)), error = function(e) NA_real_),
      R2 = .model_r2(m),
      RMSE = .rmse_model(m)
    )
    as.data.frame(vals[c("modelo", "classe", "n", metrics)], stringsAsFactors = FALSE)
  }))
  row.names(tabela) <- NULL

  alertas <- character()
  if (isTRUE(check_comparability)) {
    resp <- vapply(mods, .model_response_name, character(1))
    if (length(unique(resp)) > 1L) alertas <- c(alertas, "Os modelos n\u00e3o apresentam a mesma vari\u00e1vel resposta identificada.")
    nobs_vec <- vapply(mods, function(m) tryCatch(stats::nobs(m), error = function(e) NA_integer_), integer(1))
    if (length(unique(nobs_vec[!is.na(nobs_vec)])) > 1L) alertas <- c(alertas, "Os modelos foram ajustados com n\u00fameros de observa\u00e7\u00f5es diferentes.")
    rows <- lapply(mods, .model_rows)
    if (all(vapply(rows, Negate(is.null), logical(1)))) {
      ref <- rows[[1L]]
      if (any(!vapply(rows[-1L], identical, logical(1), y = ref))) alertas <- c(alertas, "Os modelos n\u00e3o usam exatamente as mesmas linhas do banco.")
    }

    if (requireNamespace("lme4", quietly = TRUE)) {
      mixed <- vapply(mods, inherits, logical(1), what = "lmerMod")
      if (sum(mixed) >= 2L) {
        reml <- vapply(mods[mixed], lme4::isREML, logical(1))
        formulas <- vapply(mods[mixed], .model_formula_text, character(1))
        if (any(reml) && length(unique(formulas)) > 1L) {
          alertas <- c(alertas, "H\u00e1 modelos `lmer` ajustados por REML com f\u00f3rmulas diferentes. Para comparar efeitos fixos por crit\u00e9rios de verossimilhan\u00e7a, prefira ajustes por ML.")
        }
      }
    }
  }
  if (!length(alertas)) alertas <- "Nenhum problema b\u00e1sico de comparabilidade foi identificado; ainda assim, a legitimidade cient\u00edfica da compara\u00e7\u00e3o deve ser verificada."

  if (!is.null(rank_by)) {
    if (!rank_by %in% names(tabela)) stop("`rank_by` deve ser uma das m\u00e9tricas presentes na tabela.", call. = FALSE)
    dec <- rank_by %in% c("logLik", "R2")
    tabela <- tabela[order(tabela[[rank_by]], decreasing = dec, na.last = TRUE), , drop = FALSE]
    row.names(tabela) <- NULL
  }

  out <- list(tabela = tabela, alertas = unique(alertas), modelos = mods, rank_by = rank_by)
  class(out) <- c("myfuns_comparacao_modelos", "list")
  out
}

#' @export
print.myfuns_comparacao_modelos <- function(x, ...) {
  cat("Compara\u00e7\u00e3o de modelos\n")
  cat("--------------------\n")
  print(x$tabela, row.names = FALSE)
  cat("\nAlertas de comparabilidade:\n")
  for (a in x$alertas) cat("* ", a, "\n", sep = "")
  invisible(x)
}
