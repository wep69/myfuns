#' Auditar a estrutura de um delineamento experimental
#'
#' Examina o banco de dados antes do ajuste do modelo e identifica problemas
#' frequentes em experimentação: combinações ausentes, duplicações de unidades,
#' desbalanceamento e valores ausentes na variável resposta.
#'
#' @param data `data.frame` contendo o experimento.
#' @param tratamento Variável que identifica o tratamento principal. Aceita nome
#'   sem aspas ou string.
#' @param bloco Variável de bloco, quando houver. O padrão é `NULL`.
#' @param unidade Identificador da unidade experimental, quando disponível.
#' @param fatores Fatores adicionais do delineamento. Pode ser informado como
#'   `c(fator1, fator2)` ou vetor de nomes.
#' @param resposta Variável resposta a ser verificada quanto a valores ausentes.
#'
#' @return Lista da classe `myfuns_delineamento` com resumo, níveis, frequências,
#'   células ausentes, duplicações, valores ausentes, indicador de balanceamento
#'   e mensagens de atenção.
#' @export
#'
#' @examples
#' dados <- expand.grid(bloco = factor(1:4), tratamento = factor(c("A", "B", "C")))
#' dados$y <- c(10, 12, 14, 11, 13, 15, 9, 12, 16, 10, 14, 17)
#' auditar_delineamento(dados, tratamento, bloco, resposta = y)
#'
#' dados2 <- dados[-5, ]
#' auditar_delineamento(dados2, tratamento, bloco)
#'
#' fat <- expand.grid(
#'   bloco = factor(1:3), salinidade = factor(c("0.5", "3.0")),
#'   plantas = factor(c("1", "2")), porta_enxerto = factor(c("A", "B"))
#' )
#' fat$y <- seq_len(nrow(fat))
#' auditar_delineamento(
#'   fat, salinidade, bloco, fatores = c(plantas, porta_enxerto), resposta = y
#' )
auditar_delineamento <- function(data,
                                 tratamento,
                                 bloco = NULL,
                                 unidade = NULL,
                                 fatores = NULL,
                                 resposta = NULL) {
  if (!is.data.frame(data)) stop("`data` deve ser um data.frame.", call. = FALSE)

  trat <- .arg_name(substitute(tratamento), data, allow_null = FALSE)
  bl <- if (missing(bloco) || is.null(substitute(bloco))) NULL else .arg_name(substitute(bloco), data)
  un <- if (missing(unidade) || is.null(substitute(unidade))) NULL else .arg_name(substitute(unidade), data)
  fat <- if (missing(fatores) || is.null(substitute(fatores))) character() else .vars_from_expr(substitute(fatores), data)
  resp <- if (missing(resposta) || is.null(substitute(resposta))) NULL else .arg_name(substitute(resposta), data)

  design_vars <- unique(c(bl, trat, fat))
  check_vars <- unique(c(design_vars, un, resp))
  .check_columns(data, check_vars)

  niveis <- data.frame(
    variavel = design_vars,
    n_niveis = vapply(data[design_vars], function(z) length(unique(z[!is.na(z)])), integer(1)),
    n_ausentes = vapply(data[design_vars], function(z) sum(is.na(z)), integer(1)),
    stringsAsFactors = FALSE
  )

  if (!length(design_vars)) stop("Nenhuma vari\u00E1vel de delineamento foi identificada.", call. = FALSE)

  grupo <- interaction(data[design_vars], drop = TRUE, lex.order = TRUE, sep = " | ")
  freq <- as.data.frame(table(grupo), stringsAsFactors = FALSE)
  names(freq) <- c("combinacao", "n")
  freq <- freq[freq$n > 0L, , drop = FALSE]

  # Tabela completa das combinações possíveis observadas em cada fator.
  nivel_list <- lapply(data[design_vars], function(z) {
    if (is.factor(z)) levels(droplevels(z)) else sort(unique(z[!is.na(z)]))
  })
  grade <- do.call(expand.grid, c(nivel_list, stringsAsFactors = FALSE))
  names(grade) <- design_vars

  if (nrow(grade)) {
    obs <- aggregate(rep(1L, nrow(data)), by = data[design_vars], FUN = sum)
    names(obs)[ncol(obs)] <- "n"
    completa <- merge(grade, obs, by = design_vars, all.x = TRUE, sort = FALSE)
    completa$n[is.na(completa$n)] <- 0L
    celulas_ausentes <- completa[completa$n == 0L, , drop = FALSE]
  } else {
    completa <- data.frame()
    celulas_ausentes <- data.frame()
  }

  # Duplicação de unidade experimental só pode ser avaliada quando um
  # identificador de unidade é fornecido. Repetições dentro de combinações de
  # tratamentos são legítimas e não devem ser classificadas como duplicações.
  if (!is.null(un)) {
    duplicado <- duplicated(data[[un]]) | duplicated(data[[un]], fromLast = TRUE)
    duplicacoes <- data[duplicado, unique(c(un, design_vars)), drop = FALSE]
  } else {
    duplicacoes <- data[FALSE, design_vars, drop = FALSE]
  }

  ausentes_resposta <- if (is.null(resp)) {
    data.frame()
  } else {
    idx <- is.na(data[[resp]])
    out <- data[idx, unique(c(un, design_vars, resp)), drop = FALSE]
    row.names(out) <- NULL
    out
  }

  contagens_positivas <- completa$n[completa$n > 0L]
  ha_na_design <- any(vapply(data[design_vars], anyNA, logical(1)))
  balanceado <- nrow(celulas_ausentes) == 0L && !ha_na_design &&
    length(contagens_positivas) > 0L && length(unique(contagens_positivas)) == 1L

  mensagens <- character()
  if (ha_na_design) {
    mensagens <- c(mensagens, "H\u00E1 valores ausentes em uma ou mais vari\u00E1veis do delineamento; essas linhas precisam ser verificadas antes da an\u00E1lise.")
  }
  if (nrow(celulas_ausentes)) {
    mensagens <- c(mensagens, paste0(nrow(celulas_ausentes), " combina\u00E7\u00E3o(\u00F5es) do delineamento sem observa\u00E7\u00E3o."))
  }
  if (!is.null(un) && nrow(duplicacoes)) {
    mensagens <- c(mensagens, paste0(nrow(duplicacoes), " linha(s) apresentam identificadores de unidade experimental duplicados."))
  }
  if (is.null(un)) {
    mensagens <- c(mensagens, "Duplica\u00E7\u00E3o de unidade experimental n\u00E3o foi avaliada porque `unidade` n\u00E3o foi informada.")
  }
  if (!is.null(resp) && nrow(ausentes_resposta)) {
    mensagens <- c(mensagens, paste0(nrow(ausentes_resposta), " observa\u00E7\u00E3o(\u00F5es) com resposta ausente."))
  }
  if (!balanceado) {
    mensagens <- c(mensagens, "O conjunto n\u00E3o apresenta o mesmo n\u00FAmero de observa\u00E7\u00F5es em todas as combina\u00E7\u00F5es previstas.")
  }
  if (!length(mensagens)) mensagens <- "Nenhuma inconsist\u00EAncia estrutural foi detectada pelas verifica\u00E7\u00F5es realizadas."

  resumo <- data.frame(
    item = c("Observa\u00E7\u00F5es", "Vari\u00E1veis do delineamento", "C\u00E9lulas ausentes", "Linhas em chaves duplicadas", "Respostas ausentes", "Balanceado"),
    valor = c(
      nrow(data), length(design_vars), nrow(celulas_ausentes), nrow(duplicacoes),
      if (is.null(resp)) NA_integer_ else nrow(ausentes_resposta), balanceado
    ),
    stringsAsFactors = FALSE
  )

  out <- list(
    resumo = resumo,
    niveis = niveis,
    frequencias = completa,
    celulas_ausentes = celulas_ausentes,
    duplicacoes = duplicacoes,
    ausentes_resposta = ausentes_resposta,
    balanceado = balanceado,
    mensagens = unique(mensagens),
    variaveis = list(tratamento = trat, bloco = bl, unidade = un, fatores = fat, resposta = resp)
  )
  class(out) <- c("myfuns_delineamento", "list")
  out
}

#' @export
print.myfuns_delineamento <- function(x, ...) {
  cat("Auditoria do delineamento\n")
  cat("-------------------------\n")
  print(x$resumo, row.names = FALSE)
  cat("\nMensagens:\n")
  for (m in x$mensagens) cat("* ", m, "\n", sep = "")
  invisible(x)
}

#' Resumo descritivo para experimentação agrícola
#'
#' Calcula, por um ou mais grupos, tamanho amostral, média, desvio-padrão,
#' erro-padrão, intervalo de confiança da média, mediana, quartis, mínimo,
#' máximo e coeficiente de variação descritivo.
#'
#' @param data `data.frame`.
#' @param resposta Variável numérica resposta.
#' @param ... Variáveis de agrupamento, informadas sem aspas.
#' @param conf.level Nível do intervalo de confiança da média.
#' @param na.rm Remover valores ausentes da resposta? Quando `FALSE`, grupos com
#'   ausências retornam estatísticas `NA` para medidas dependentes da resposta.
#'
#' @return `data.frame` com as estatísticas descritivas por grupo.
#' @export
#'
#' @examples
#' resumo_agri(iris, Sepal.Length, Species)
#'
#' iris$grupo_largura <- cut(iris$Sepal.Width, breaks = 2)
#' resumo_agri(iris, Petal.Length, Species, grupo_largura)
#'
#' resumo_agri(iris, Sepal.Length, Species, conf.level = 0.90)
resumo_agri <- function(data, resposta, ..., conf.level = 0.95, na.rm = TRUE) {
  if (!is.data.frame(data)) stop("`data` deve ser um data.frame.", call. = FALSE)
  if (!is.numeric(conf.level) || length(conf.level) != 1L || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` deve estar entre 0 e 1.", call. = FALSE)
  }
  resp <- .arg_name(substitute(resposta), data, allow_null = FALSE)
  grupos_expr <- as.list(substitute(list(...)))[-1L]
  grupos <- if (!length(grupos_expr)) character() else vapply(grupos_expr, .arg_name, character(1), data = data, allow_null = FALSE)
  .check_columns(data, c(resp, grupos))
  if (!is.numeric(data[[resp]])) stop("A vari\u00E1vel resposta deve ser num\u00E9rica.", call. = FALSE)

  calc <- function(idx) {
    z0 <- data[[resp]][idx]
    n_total <- length(z0)
    n_aus <- sum(is.na(z0))
    z <- if (isTRUE(na.rm)) z0[!is.na(z0)] else z0
    n <- sum(!is.na(z))
    invalido <- !isTRUE(na.rm) && n_aus > 0L

    if (n == 0L || invalido) {
      return(data.frame(
        n = n, n_total = n_total, n_ausentes = n_aus, media = NA_real_, dp = NA_real_,
        erro_padrao = NA_real_, ic_inferior = NA_real_, ic_superior = NA_real_,
        mediana = NA_real_, q1 = NA_real_, q3 = NA_real_, minimo = NA_real_,
        maximo = NA_real_, cv = NA_real_
      ))
    }

    media <- mean(z)
    dp <- if (n > 1L) stats::sd(z) else NA_real_
    ep <- if (n > 1L) dp / sqrt(n) else NA_real_
    qt <- if (n > 1L) stats::qt(1 - (1 - conf.level) / 2, df = n - 1L) else NA_real_
    ic <- if (n > 1L) media + c(-1, 1) * qt * ep else c(NA_real_, NA_real_)
    qs <- stats::quantile(z, probs = c(0.25, 0.75), names = FALSE, na.rm = TRUE, type = 7)
    cv <- if (is.finite(media) && abs(media) > sqrt(.Machine$double.eps) && is.finite(dp)) 100 * dp / abs(media) else NA_real_

    data.frame(
      n = n, n_total = n_total, n_ausentes = n_aus, media = media, dp = dp,
      erro_padrao = ep, ic_inferior = ic[1L], ic_superior = ic[2L],
      mediana = stats::median(z), q1 = qs[1L], q3 = qs[2L], minimo = min(z),
      maximo = max(z), cv = cv
    )
  }

  if (!length(grupos)) return(calc(seq_len(nrow(data))))

  chave <- interaction(data[grupos], drop = TRUE, lex.order = TRUE, sep = "\r")
  indices <- split(seq_len(nrow(data)), chave, drop = TRUE)
  res <- lapply(indices, function(idx) {
    cab <- data[idx[1L], grupos, drop = FALSE]
    cbind(cab, calc(idx), row.names = NULL)
  })
  out <- do.call(rbind, res)
  row.names(out) <- NULL
  out
}