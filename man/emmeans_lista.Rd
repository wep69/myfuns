\name{emmeans_lista}
\alias{emmeans_lista}
\title{Calcular médias marginais estimadas para uma lista de modelos}
\usage{
emmeans_lista(object, specs, ..., which = seq_along(object))
}
\arguments{
  \item{object}{Lista de modelos.}
  \item{specs}{Especificação repassada a [emmeans::emmeans()].}
  \item{...}{Argumentos adicionais para [emmeans::emmeans()].}
  \item{which}{Índices dos elementos que serão processados. }
}
\value{
Lista de objetos `emmGrid`.
}
\description{
Aplica [emmeans::emmeans()] aos elementos selecionados de uma lista de modelos. É útil quando várias variáveis resposta compartilham a mesma estrutura experimental.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
m1 <- stats::lm(Sepal.Length ~ Species, data = iris)
m2 <- stats::lm(Petal.Length ~ Species, data = iris)
emmeans_lista(list(sepala = m1, petala = m2), ~ Species)

mods <- list(sepala = m1, petala = m2)
emmeans_lista(mods, ~ Species, which = 2)

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
emmeans_lista(list(quebras = mp), ~ tension | wool, type = "response")
}
