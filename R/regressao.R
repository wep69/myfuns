#' Ajustar regressões polinomiais para fatores quantitativos
#'
#' Ajusta modelos polinomiais brutos de graus especificados, preserva todos os
#' modelos candidatos e produz medidas comparativas, intervalos dos coeficientes,
#' teste de falta de ajuste quando há repetição de níveis e predições para o
#' modelo de maior grau solicitado. A função não seleciona automaticamente o
#' "melhor" modelo.
#'
#' @param data `data.frame`.
#' @param y Variável resposta numérica.
#' @param x Variável quantitativa numérica.
#' @param degree Grau ou vetor de graus, por exemplo `1:3`.
#' @param weights Pesos opcionais. Pode ser uma variável do banco ou vetor
#'   numérico com comprimento igual ao número de linhas.
#' @param compare Produzir tabela comparativa dos modelos? Padrão `TRUE`.
#' @param lack_of_fit Calcular teste de falta de ajuste quando possível?
#' @param conf.level Nível de confiança para coeficientes e predições.
#'
#' @return Objeto da classe `myfuns_reg_poly`.
#' @export
#'
#' @examples
#' set.seed(1)
#' d <- expand.grid(rep = factor(1:4), dose = c(0, 50, 100, 150, 200))
#' d$y <- 20 + 0.2 * d$dose - 0.0007 * d$dose^2 + stats::rnorm(nrow(d), 0, 2)
#' reg_poly(d, y, dose, degree = 1:2)
#'
#' reg_poly(d, y, dose, degree = 2, compare = FALSE)
#'
#' rp <- reg_poly(d, y, dose, degree = 1:3, compare = TRUE)
#' rp$comparacao
reg_poly <- function(data,
                     y,
                     x,
                     degree = 1:3,
                     weights = NULL,
                     compare = TRUE,
                     lack_of_fit = TRUE,
                     conf.level = 0.95) {
  if (!is.data.frame(data)) stop("`data` deve ser um data.frame.", call. = FALSE)
  y_name <- .arg_name(substitute(y), data, allow_null = FALSE)
  x_name <- .arg_name(substitute(x), data, allow_null = FALSE)
  .check_columns(data, c(y_name, x_name))
  if (!is.numeric(data[[y_name]]) || !is.numeric(data[[x_name]])) {
    stop("`y` e `x` devem ser vari\u00E1veis num\u00E9ricas.", call. = FALSE)
  }
  if (anyNA(data[c(y_name, x_name)])) {
    stop("`reg_poly()` n\u00E3o remove observa\u00E7\u00F5es automaticamente. Trate ou justifique os valores ausentes antes do ajuste.", call. = FALSE)
  }
  if (!is.numeric(degree) || !length(degree) || anyNA(degree) || any(degree < 1) || any(degree %% 1 != 0)) {
    stop("`degree` deve conter inteiros positivos.", call. = FALSE)
  }
  degree <- sort(unique(as.integer(degree)))
  n_levels <- length(unique(data[[x_name]]))
  if (max(degree) >= n_levels) {
    stop("O grau m\u00E1ximo deve ser menor que o n\u00FAmero de n\u00EDveis distintos de `x`.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1L || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` deve estar entre 0 e 1.", call. = FALSE)
  }

  w_expr <- substitute(weights)
  w <- NULL
  if (!missing(weights) && !is.null(w_expr)) {
    if (is.symbol(w_expr) && as.character(w_expr) %in% names(data)) {
      w <- data[[as.character(w_expr)]]
    } else {
      w <- eval(w_expr, envir = data, enclos = parent.frame())
    }
    if (!is.numeric(w) || length(w) != nrow(data) || anyNA(w) || any(w < 0)) {
      stop("`weights` deve ser um vetor num\u00E9rico n\u00E3o negativo, sem aus\u00EAncias, com uma entrada por observa\u00E7\u00E3o.", call. = FALSE)
    }
  }

  make_formula <- function(g) {
    termos <- c(x_name, if (g >= 2L) paste0("I(", x_name, "^", 2:g, ")") else character())
    stats::reformulate(termos, response = y_name)
  }

  modelos <- lapply(degree, function(g) {
    f <- make_formula(g)
    if (is.null(w)) stats::lm(f, data = data) else stats::lm(f, data = data, weights = w)
  })
  names(modelos) <- paste0("grau", degree)

  comparacao <- do.call(rbind, lapply(seq_along(modelos), function(i) {
    m <- modelos[[i]]
    n <- stats::nobs(m)
    sm <- summary(m)
    data.frame(
      grau = degree[i],
      n = n,
      R2 = unname(sm$r.squared),
      R2_ajustado = unname(sm$adj.r.squared),
      RMSE = sqrt(mean(stats::residuals(m)^2)),
      AIC = stats::AIC(m),
      AICc = .aicc(m),
      BIC = stats::BIC(m),
      stringsAsFactors = FALSE
    )
  }))
  if (!isTRUE(compare)) comparacao <- NULL

  coeficientes <- lapply(modelos, function(m) {
    cf <- stats::coef(summary(m))
    ci <- stats::confint(m, level = conf.level)
    out <- data.frame(
      termo = row.names(cf),
      estimativa = cf[, 1L],
      erro_padrao = cf[, 2L],
      estatistica = cf[, 3L],
      p_valor = cf[, 4L],
      ic_inferior = ci[, 1L],
      ic_superior = ci[, 2L],
      row.names = NULL,
      stringsAsFactors = FALSE
    )
    out
  })

  falta_ajuste <- NULL
  if (isTRUE(lack_of_fit) && anyDuplicated(data[[x_name]])) {
    fat_formula <- stats::reformulate(paste0("factor(", x_name, ")"), response = y_name)
    mf <- if (is.null(w)) stats::lm(fat_formula, data = data) else stats::lm(fat_formula, data = data, weights = w)
    falta_ajuste <- do.call(rbind, lapply(seq_along(modelos), function(i) {
      m <- modelos[[i]]
      av <- tryCatch(stats::anova(m, mf), error = function(e) NULL)
      if (is.null(av) || nrow(av) < 2L) {
        return(data.frame(grau = degree[i], gl_falta_ajuste = NA_real_, SQ_falta_ajuste = NA_real_, F = NA_real_, p_valor = NA_real_))
      }
      data.frame(
        grau = degree[i],
        gl_falta_ajuste = av$Df[2L],
        SQ_falta_ajuste = av$`Sum of Sq`[2L],
        F = av$F[2L],
        p_valor = av$`Pr(>F)`[2L]
      )
    }))
    row.names(falta_ajuste) <- NULL
  }

  principal_idx <- which.max(degree)
  principal <- modelos[[principal_idx]]
  xrange <- range(data[[x_name]], na.rm = TRUE)
  grid <- data.frame(seq(xrange[1L], xrange[2L], length.out = 200L))
  names(grid) <- x_name
  pred <- stats::predict(principal, newdata = grid, interval = "confidence", level = conf.level)
  predicoes <- cbind(grid, as.data.frame(pred))
  names(predicoes)[(ncol(predicoes) - 2L):ncol(predicoes)] <- c("ajustado", "ic_inferior", "ic_superior")

  out <- list(
    modelos = modelos,
    model = principal,
    grau_principal = degree[principal_idx],
    comparacao = comparacao,
    coeficientes = coeficientes,
    falta_ajuste = falta_ajuste,
    predicoes = predicoes,
    data = data,
    x = x_name,
    y = y_name,
    dominio = xrange,
    conf.level = conf.level,
    weights = w
  )
  class(out) <- c("myfuns_reg_poly", "list")
  out
}

#' @export
print.myfuns_reg_poly <- function(x, ...) {
  cat("Regress\u00E3o polinomial\n")
  cat("--------------------\n")
  cat("Resposta: ", x$y, "\n", sep = "")
  cat("Preditor: ", x$x, "\n", sep = "")
  cat("Modelo principal para predi\u00E7\u00E3o: grau ", x$grau_principal, "\n", sep = "")
  if (!is.null(x$comparacao)) {
    cat("\nCompara\u00E7\u00E3o descritiva dos modelos:\n")
    print(x$comparacao, row.names = FALSE)
  }
  if (!is.null(x$falta_ajuste)) {
    cat("\nTeste de falta de ajuste:\n")
    print(x$falta_ajuste, row.names = FALSE)
  }
  invisible(x)
}

#' Calcular pontos críticos de uma regressão polinomial
#'
#' Obtém raízes da primeira derivada de modelos polinomiais brutos produzidos por
#' `lm()` ou [reg_poly()]. Para regressões quadráticas, também calcula um
#' intervalo aproximado para a posição do ponto pelo método delta.
#'
#' @param model Objeto `lm` ou `myfuns_reg_poly`.
#' @param range Intervalo experimental `c(min, max)`. Se `NULL`, é inferido do
#'   banco usado no ajuste.
#' @param conf.level Nível de confiança do intervalo aproximado para o ponto
#'   quadrático.
#' @param classify Classificar o ponto como máximo, mínimo ou indeterminado?
#'
#' @return `data.frame` com posição, resposta prevista, classificação, posição
#'   relativa ao domínio e, quando disponível, intervalo de confiança.
#' @export
#'
#' @examples
#' d <- data.frame(dose = rep(c(0, 50, 100, 150, 200), each = 3))
#' d$y <- 20 + 0.25 * d$dose - 0.0008 * d$dose^2 + rep(c(-1, 0, 1), 5)
#' mq <- stats::lm(y ~ dose + I(dose^2), data = d)
#' ponto_critico(mq, range = range(d$dose))
#'
#' ponto_critico(mq, range = c(0, 100))
#'
#' rp <- reg_poly(d, y, dose, degree = 2)
#' ponto_critico(rp)
ponto_critico <- function(model, range = NULL, conf.level = 0.95, classify = TRUE) {
  if (inherits(model, "myfuns_reg_poly")) {
    if (is.null(range)) range <- model$dominio
    model <- model$model
  }
  if (!inherits(model, "lm")) stop("`model` deve ser um objeto `lm` ou resultado de `reg_poly()`.", call. = FALSE)
  if (!is.numeric(conf.level) || conf.level <= 0 || conf.level >= 1) stop("`conf.level` deve estar entre 0 e 1.", call. = FALSE)

  mf <- stats::model.frame(model)
  yname <- names(mf)[1L]
  predictors <- names(mf)[-1L]
  base_candidates <- predictors[!grepl("^I\\(", predictors)]
  if (!length(base_candidates)) stop("N\u00E3o foi poss\u00EDvel identificar o preditor quantitativo do polin\u00F4mio.", call. = FALSE)
  xname <- base_candidates[1L]
  xobs <- mf[[xname]]
  if (!is.numeric(xobs)) stop("O preditor identificado deve ser num\u00E9rico.", call. = FALSE)
  if (is.null(range)) range <- range(xobs, na.rm = TRUE)
  if (!is.numeric(range) || length(range) != 2L || anyNA(range)) stop("`range` deve conter dois valores num\u00E9ricos.", call. = FALSE)
  range <- sort(range)

  cf <- stats::coef(model)
  # Coeficientes por potência: intercepto, x, I(x^2), ...
  degree <- 1L
  max_try <- 10L
  coefs <- numeric(max_try + 1L)
  coefs[1L] <- unname(cf["(Intercept)"])
  if (xname %in% names(cf)) coefs[2L] <- unname(cf[xname])
  for (p in 2:max_try) {
    nm1 <- paste0("I(", xname, "^", p, ")")
    nm2 <- paste0("I(", xname, "^", p, ")TRUE")
    hit <- c(nm1, nm2)[c(nm1, nm2) %in% names(cf)]
    if (length(hit)) {
      coefs[p + 1L] <- unname(cf[hit[1L]])
      degree <- max(degree, p)
    }
  }
  if (degree < 2L) stop("O modelo deve conter termo quadr\u00E1tico ou de ordem superior.", call. = FALSE)
  coefs <- coefs[seq_len(degree + 1L)]

  deriv_cf <- seq_len(degree) * coefs[2:(degree + 1L)]
  roots <- polyroot(deriv_cf)
  reais <- Re(roots[abs(Im(roots)) < 1e-8])
  if (!length(reais)) {
    return(data.frame(
      x_critico = numeric(), y_predito = numeric(), classificacao = character(),
      dentro_intervalo = logical(), ic_inferior = numeric(), ic_superior = numeric()
    ))
  }

  pred_data <- data.frame(reais)
  names(pred_data) <- xname
  ypred <- as.numeric(stats::predict(model, newdata = pred_data))

  second <- function(z) {
    if (degree < 2L) return(NA_real_)
    powers <- 2:degree
    sum(powers * (powers - 1) * coefs[powers + 1L] * z^(powers - 2L))
  }
  sec <- vapply(reais, second, numeric(1))
  classif <- if (!isTRUE(classify)) rep(NA_character_, length(reais)) else ifelse(
    sec < -sqrt(.Machine$double.eps), "m\u00E1ximo",
    ifelse(sec > sqrt(.Machine$double.eps), "m\u00EDnimo", "indeterminado")
  )

  ci_low <- ci_high <- rep(NA_real_, length(reais))
  if (degree == 2L && length(reais) == 1L) {
    bname <- xname
    cname <- paste0("I(", xname, "^2)")
    if (all(c(bname, cname) %in% names(cf))) {
      b <- unname(cf[bname]); c2 <- unname(cf[cname])
      V <- stats::vcov(model)[c(bname, cname), c(bname, cname), drop = FALSE]
      grad <- c(-1 / (2 * c2), b / (2 * c2^2))
      se <- sqrt(as.numeric(t(grad) %*% V %*% grad))
      z <- stats::qnorm(1 - (1 - conf.level) / 2)
      ci_low[1L] <- reais[1L] - z * se
      ci_high[1L] <- reais[1L] + z * se
    }
  }

  inside <- reais >= range[1L] & reais <= range[2L]
  if (any(!inside)) warning("H\u00E1 ponto cr\u00EDtico fora do dom\u00EDnio informado; sua interpreta\u00E7\u00E3o implica extrapola\u00E7\u00E3o.", call. = FALSE)

  data.frame(
    x_critico = reais,
    y_predito = ypred,
    classificacao = classif,
    dentro_intervalo = inside,
    ic_inferior = ci_low,
    ic_superior = ci_high,
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}