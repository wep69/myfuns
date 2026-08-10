#' Tema sem grade e com eixos pretos
#'
#' Tema derivado de [ggplot2::theme_bw()] que remove grades e borda do painel e
#' desenha as linhas dos eixos em preto. Reimplementa o tema da versao 0.1.0
#' usando o argumento moderno `linewidth`.
#'
#' @param base_size Tamanho base da fonte.
#' @param base_family Familia tipografica base.
#' @return Objeto `theme` do ggplot2.
#' @rdname themes
#' @export
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     theme_nogrid()
#' }
theme_nogrid <- function(base_size = 12, base_family = "") {
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(color = "black", linewidth = 0.7)
    )
}

#' Tema sem grade com moldura para graficos multivariados
#'
#' Variante historicamente usada em graficos de ACP/PCA. Mantem uma moldura
#' preta de maior espessura ao redor do painel e remove as grades.
#'
#' @inheritParams theme_nogrid
#' @return Objeto `theme` do ggplot2.
#' @rdname themes
#' @export
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     theme_nogridacp()
#' }
theme_nogridacp <- function(base_size = 12, base_family = "") {
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_rect(
        color = "black",
        linewidth = 1.5,
        fill = NA
      )
    )
}

#' Tema transparente para figuras ggplot2
#'
#' Remove fundos e grades, preservando os demais elementos do tema. E a forma
#' funcional e reutilizavel do objeto historico `trans`.
#'
#' @return Objeto `theme` do ggplot2.
#' @rdname themes
#' @export
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     theme_transparent()
#' }
theme_transparent <- function() {
  ggplot2::theme(
    panel.background = ggplot2::element_rect(fill = "transparent"),
    plot.background = ggplot2::element_rect(fill = "transparent", color = NA),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    legend.background = ggplot2::element_rect(fill = "transparent"),
    legend.box.background = ggplot2::element_rect(fill = "transparent")
  )
}

#' Tema transparente preconstruido
#'
#' Objeto de tema equivalente a `theme_transparent()`. Mantem a sintaxe curta
#' `grafico + trans` solicitada para compatibilidade com scripts existentes.
#'
#' @format Objeto da classe `theme` do ggplot2.
#' @rdname themes
#' @export
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() + trans
#' }
trans <- theme_transparent()
