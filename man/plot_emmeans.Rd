\name{plot_emmeans}
\alias{plot_emmeans}
\title{Gráfico de médias marginais estimadas com dados observados}
\usage{
plot_emmeans(object,
                           data = NULL,
                           x = NULL,
                           y = NULL,
                           show_data = TRUE,
                           interval = "confidence",
                           letters = FALSE,
                           theme = theme_nogrid())
}
\arguments{
  \item{object}{Resultado de [comparar_emmeans()] ou objeto `emmGrid`.}
  \item{data}{Banco original opcional.}
  \item{x}{Variável do eixo x no banco original. Se `NULL`, é inferida das EMMs.}
  \item{y}{Variável resposta no banco original.}
  \item{show_data}{Mostrar observações individuais quando `data` é fornecido?}
  \item{interval}{Tipo de intervalo. Atualmente `"confidence"` utiliza os limites fornecidos por `emmeans`.}
  \item{letters}{Mostrar letras se `object` contiver CLD?}
  \item{theme}{Tema `ggplot2` aplicado ao final. }
}
\value{
Objeto `ggplot`.
}
\description{
Combina estimativas ajustadas, intervalos de confiança e, opcionalmente, observações individuais. O objetivo é evitar figuras que mostrem apenas uma barra de média sem informação de distribuição ou incerteza.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
m <- stats::lm(weight ~ group, data = PlantGrowth)
cmp <- comparar_emmeans(m, ~ group)
plot_emmeans(cmp)

plot_emmeans(cmp, data = PlantGrowth, x = group, y = weight, show_data = TRUE)

m2 <- stats::lm(breaks ~ wool * tension, data = warpbreaks)
cmp2 <- comparar_emmeans(m2, ~ tension | wool)
plot_emmeans(cmp2, data = warpbreaks, x = tension, y = breaks)
}
