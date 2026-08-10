\name{contrast_lista}
\alias{contrast_lista}
\alias{cld_lista}
\title{Aplicar contrastes ou compact letter displays a elementos de uma lista}
\usage{
contrast_lista(object, ..., which = seq_along(object))

cld_lista(object, ..., which = seq_along(object))
}
\arguments{
\item{object}{Lista de objetos compativeis com a operacao solicitada.}
\item{...}{Argumentos adicionais para \code{emmeans::contrast()} ou \code{multcomp::cld()}.}
\item{which}{Indices dos elementos a processar.}
}
\description{
\code{contrast_lista()} aplica \code{emmeans::contrast()} e \code{cld_lista()}
aplica \code{multcomp::cld()} aos elementos selecionados de uma lista.
}
\details{
Em um CLD tradicional, letras compartilhadas indicam apenas que a diferenca
nao foi demonstrada sob o procedimento usado; nao demonstram igualdade.
}
\value{Lista com um resultado por elemento processado.}
\examples{
dados <- data.frame(
  trat = factor(rep(c("A", "B", "C"), each = 4)),
  bloco = factor(rep(1:4, times = 3)),
  y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
)
mod <- lm(y ~ trat + bloco, data = dados)
em <- emmeans::emmeans(mod, ~ trat)
contrast_lista(list(resposta = em), method = "pairwise")
}
