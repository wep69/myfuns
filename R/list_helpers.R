#' Aplicar compact letter display a elementos de uma lista
#'
#' Aplica [multcomp::cld()] aos elementos selecionados de uma lista. A funcao
#' preserva a API da versao original do pacote.
#'
#' @param object Lista contendo objetos para os quais exista metodo `cld`, como
#'   objetos `emmGrid` produzidos por `emmeans`.
#' @param ... Argumentos adicionais repassados a [multcomp::cld()].
#' @param which Indices dos elementos de `object` que devem ser processados.
#' @return Lista com os resultados de `cld`.
#' @rdname list_helpers
#' @export
#'
#' @details
#' Em objetos `emmGrid`, letras iguais indicam que uma diferenca nao foi
#' demonstrada no nivel de significancia adotado; elas nao demonstram igualdade
#' entre medias. Para inferencia de equivalencia, considere o argumento `delta`
#' do metodo `cld` do pacote `emmeans`.
cld_lista <- function(object, ..., which = seq_along(object)) {
  if (!is.list(object)) {
    stop("`object` deve ser uma lista.", call. = FALSE)
  }
  which <- .validate_which(which, length(object))
  lapply(object[which], multcomp::cld, ...)
}

#' Aplicar contrastes a elementos de uma lista
#'
#' Aplica [emmeans::contrast()] aos elementos selecionados de uma lista. E util
#' quando varias grades de medias marginais estimadas precisam receber a mesma
#' familia de contrastes.
#'
#' @param object Lista de objetos compativeis com [emmeans::contrast()].
#' @param ... Argumentos adicionais repassados a [emmeans::contrast()].
#' @param which Indices dos elementos de `object` que devem ser processados.
#' @return Lista com os contrastes calculados.
#' @rdname list_helpers
#' @export
#'
#' @examples
#' dados <- data.frame(
#'   trat = factor(rep(c("A", "B", "C"), each = 4)),
#'   bloco = factor(rep(1:4, times = 3)),
#'   y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
#' )
#' mod <- stats::lm(y ~ trat + bloco, data = dados)
#' em <- emmeans::emmeans(mod, ~ trat)
#' contrast_lista(list(resposta = em), method = "pairwise")
contrast_lista <- function(object, ..., which = seq_along(object)) {
  if (!is.list(object)) {
    stop("`object` deve ser uma lista.", call. = FALSE)
  }
  which <- .validate_which(which, length(object))
  lapply(object[which], emmeans::contrast, ...)
}

.validate_which <- function(which, n) {
  if (!is.numeric(which) || anyNA(which) || any(which %% 1 != 0)) {
    stop("`which` deve conter indices inteiros validos.", call. = FALSE)
  }
  which <- as.integer(which)
  if (any(which < 1L | which > n)) {
    stop("`which` contem indice fora dos limites de `object`.", call. = FALSE)
  }
  which
}
