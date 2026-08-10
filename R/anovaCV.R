#' Tabela de ANOVA e coeficiente de variacao
#'
#' Retorna, em uma lista nomeada, a tabela de análise de variância e o
#' coeficiente de variação (CV) em porcentagem. O CV é calculado como
#' `100 * sigma(modelo) / abs(media_resposta)`, preservando a interpretação
#' histórica sem depender de pacote externo para esse cálculo.
#'
#' @param x Modelo ajustado aceito por [stats::anova()], tipicamente um objeto
#'   `lm`, `aov` ou modelo misto para o qual [stats::sigma()] esteja definido.
#' @param digits Numero de casas decimais usadas no CV. O valor padrao `1`
#'   reproduz a versao original.
#'
#' @return Lista com os componentes `Anova` e `CV`.
#' @export
#'
#' @examples
#' dados <- data.frame(
#'   tratamento = factor(rep(c("A", "B", "C"), each = 4)),
#'   y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
#' )
#' mod <- stats::lm(y ~ tratamento, data = dados)
#' anovaCV(mod)
anovaCV <- function(x, digits = 1) {
  if (!is.numeric(digits) || length(digits) != 1L || is.na(digits) || digits < 0) {
    stop("`digits` deve ser um numero nao negativo de comprimento 1.", call. = FALSE)
  }

  tab_anova <- stats::anova(x)
  cv <- .cv_model(x)
  if (!is.finite(cv)) warning("N\u00e3o foi poss\u00edvel calcular o CV a partir da resposta e de `sigma(modelo)`.", call. = FALSE)

  list(
    Anova = tab_anova,
    CV = round(as.numeric(cv), digits = digits)
  )
}
