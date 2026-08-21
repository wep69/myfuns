# Utilitarios internos ------------------------------------------------------

.require_namespace <- function(pkg, funcao = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    sufixo <- if (is.null(funcao)) "" else paste0(" para usar `", funcao, "()`")
    stop(
      paste0("O pacote `", pkg, "` e necessario", sufixo, ". Instale-o com install.packages(\"", pkg, "\")."),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

.arg_name <- function(expr, data = NULL, allow_null = TRUE) {
  if (is.null(expr)) {
    if (allow_null) return(NULL)
    stop("Um nome de variavel deve ser informado.", call. = FALSE)
  }
  if (is.character(expr)) {
    if (length(expr) != 1L) stop("Informe apenas uma variavel.", call. = FALSE)
    return(expr)
  }
  if (is.symbol(expr)) return(as.character(expr))
  txt <- deparse(expr, width.cutoff = 500L)
  if (length(txt) != 1L) stop("Nao foi possivel identificar a variavel.", call. = FALSE)
  txt
}

.vars_from_expr <- function(expr, data = NULL, allow_null = TRUE) {
  if (is.null(expr)) {
    if (allow_null) return(character())
    stop("Informe pelo menos uma variavel.", call. = FALSE)
  }
  if (is.character(expr)) return(unique(expr))
  if (is.symbol(expr)) return(as.character(expr))
  if (is.call(expr) && identical(expr[[1L]], as.name("c"))) {
    out <- vapply(as.list(expr)[-1L], function(z) {
      if (is.symbol(z)) as.character(z)
      else if (is.character(z) && length(z) == 1L) z
      else stop("Em `c(...)`, use somente nomes de variaveis ou strings.", call. = FALSE)
    }, character(1))
    return(unique(out))
  }
  stop("Use nomes de variaveis, um vetor de nomes ou `c(var1, var2, ...)`.", call. = FALSE)
}

.check_columns <- function(data, vars) {
  vars <- unique(vars[nzchar(vars)])
  ausentes <- setdiff(vars, names(data))
  if (length(ausentes)) {
    stop(
      paste0("Variavel(is) nao encontrada(s) em `data`: ", paste(ausentes, collapse = ", "), "."),
      call. = FALSE
    )
  }
  invisible(vars)
}

.safe_call <- function(expr) {
  tryCatch(expr, error = function(e) structure(list(erro = conditionMessage(e)), class = "myfuns_erro"))
}

.is_error_result <- function(x) inherits(x, "myfuns_erro")

.aicc <- function(model) {
  aic <- tryCatch(stats::AIC(model), error = function(e) NA_real_)
  ll <- tryCatch(stats::logLik(model), error = function(e) NULL)
  n <- tryCatch(stats::nobs(model), error = function(e) NA_integer_)
  k <- if (is.null(ll)) NA_real_ else attr(ll, "df")
  if (is.na(aic) || is.na(n) || is.na(k) || n <= k + 1) return(NA_real_)
  aic + (2 * k * (k + 1)) / (n - k - 1)
}

.model_response <- function(model) {
  mf <- tryCatch(stats::model.frame(model), error = function(e) NULL)
  if (is.null(mf) || ncol(mf) < 1L) return(NULL)
  y <- stats::model.response(mf)
  y
}

.model_response_name <- function(model) {
  f <- tryCatch(stats::formula(model), error = function(e) NULL)
  if (is.null(f)) return(NA_character_)
  all.vars(f[[2L]])[1L]
}

.rmse_model <- function(model) {
  y <- .model_response(model)
  pred <- tryCatch(stats::predict(model, type = "response"), error = function(e) {
    tryCatch(stats::fitted(model), error = function(e2) NULL)
  })
  if (is.null(y) || is.null(pred) || is.matrix(y) || length(y) != length(pred)) return(NA_real_)
  sqrt(mean((as.numeric(y) - as.numeric(pred))^2, na.rm = TRUE))
}

.model_r2 <- function(model) {
  if (inherits(model, "lm") && !inherits(model, "glm")) {
    return(unname(summary(model)$r.squared))
  }
  if (requireNamespace("performance", quietly = TRUE)) {
    p <- tryCatch(performance::r2(model), error = function(e) NULL)
    if (!is.null(p)) {
      nums <- unlist(as.data.frame(p), use.names = TRUE)
      if (length(nums)) return(as.numeric(nums[1L]))
    }
  }
  NA_real_
}

.model_rows <- function(model) {
  mf <- tryCatch(stats::model.frame(model), error = function(e) NULL)
  if (is.null(mf)) return(NULL)
  rn <- row.names(mf)
  if (is.null(rn)) seq_len(nrow(mf)) else rn
}

.model_formula_text <- function(model) {
  f <- tryCatch(stats::formula(model), error = function(e) NULL)
  if (is.null(f)) return(NA_character_)
  paste(deparse(f, width.cutoff = 500L), collapse = "")
}

.as_numeric_safe <- function(x, nome = "variavel") {
  if (is.numeric(x)) return(as.numeric(x))
  out <- suppressWarnings(as.numeric(as.character(x)))
  if (any(is.na(out) & !is.na(x))) {
    stop(paste0("`", nome, "` deve ser numerica ou coercivel para numerico sem perdas."), call. = FALSE)
  }
  out
}

.is_equally_spaced <- function(x, tolerance = sqrt(.Machine$double.eps)) {
  x <- sort(unique(as.numeric(x)))
  if (length(x) <= 2L) return(TRUE)
  d <- diff(x)
  max(abs(d - d[1L])) <= tolerance * max(1, abs(d[1L]))
}

.primary_emm_var <- function(df) {
  stat_names <- c(
    "emmean", "SE", "df", "lower.CL", "upper.CL", "asymp.LCL", "asymp.UCL",
    "response", "prob", "rate", "odds.ratio", "null", "t.ratio", "z.ratio",
    "p.value", "estimate", "ratio"
  )
  candidates <- setdiff(names(df), stat_names)
  candidates <- candidates[vapply(df[candidates], function(z) {
    is.factor(z) || is.character(z) || (is.numeric(z) && length(unique(z)) <= max(20L, nrow(df) / 2L))
  }, logical(1))]
  if (!length(candidates)) return(NULL)
  candidates[1L]
}

.emm_estimate_col <- function(df) {
  preferred <- c("emmean", "response", "prob", "rate")
  hit <- preferred[preferred %in% names(df)]
  if (length(hit)) return(hit[1L])
  numeric_cols <- names(df)[vapply(df, is.numeric, logical(1))]
  numeric_cols <- setdiff(numeric_cols, c("SE", "df", "lower.CL", "upper.CL", "asymp.LCL", "asymp.UCL", "p.value"))
  if (!length(numeric_cols)) stop("Nao foi possivel identificar a coluna de estimativa do objeto `emmeans`.", call. = FALSE)
  numeric_cols[1L]
}

.emm_ci_cols <- function(df) {
  if (all(c("lower.CL", "upper.CL") %in% names(df))) return(c("lower.CL", "upper.CL"))
  if (all(c("asymp.LCL", "asymp.UCL") %in% names(df))) return(c("asymp.LCL", "asymp.UCL"))
  c(NA_character_, NA_character_)
}

.clean_filename <- function(x) {
  x <- gsub("[^[:alnum:]_-]+", "_", x)
  x <- gsub("_+", "_", x)
  x <- gsub("^_|_$", "", x)
  ifelse(nzchar(x), x, "figura")
}

.cv_model <- function(model) {
  y <- .model_response(model)
  if (is.null(y) || is.matrix(y) || !is.numeric(y)) return(NA_real_)
  media <- mean(y, na.rm = TRUE)
  sigma <- tryCatch(stats::sigma(model), error = function(e) NA_real_)
  if (!is.finite(media) || abs(media) <= sqrt(.Machine$double.eps) || !is.finite(sigma)) return(NA_real_)
  100 * sigma / abs(media)
}

# Conversao plotmath -> texto simples (interno) --------------------------------
.plotmath_to_plain <- function(x) {
  out <- x

  # Processar por blocos para suportar aninhamento simples
  # 1. hat(y) -> y
  out <- gsub("hat\\s*\\(([^)]+)\\)", "\\1", out)
  # 2. bar(y) -> ȳ
  out <- gsub("bar\\s*\\(([^)]+)\\)", "\\1\u0305", out)
  # 3. bold(x) / italic(x) / bolditalic(x) -> x
  out <- gsub("(?:bold|italic|bolditalic)\\s*\\(([^)]+)\\)", "\\1", out)
  # 4. frac(a, b) -> a/b
  out <- gsub("frac\\s*\\(([^,]+),\\s*([^)]+)\\)", "\\1/\\2", out)
  # 5. sqrt(x) -> √(x)
  out <- gsub("sqrt\\s*\\(([^)]+)\\)", "\u221A(\\1)", out)
  # 6. Spacing: ~ e whitespace do plotmath
  out <- gsub("~", " ", out)
  out <- gsub("\\s+", " ", out)
  out <- trimws(out)

  out
}
