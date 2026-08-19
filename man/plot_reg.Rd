\name{plot_reg}
\alias{plot_reg}
\title{Gráfico para regressão de fator quantitativo}
\usage{
plot_reg(object,
                       data = NULL,
                       x = NULL,
                       y = NULL,
                       show_raw = TRUE,
                       show_means = TRUE,
                       interval = "confidence",
                       equation = TRUE,
                       theme = theme_nogrid())
}
\arguments{
  \item{object}{Resultado de [reg_poly()].}
  \item{data}{Banco opcional. Por padrão, usa o banco armazenado em `object`.}
  \item{x}{Variável quantitativa. Por padrão, usa a registrada em `object`.}
  \item{y}{Variável resposta. Por padrão, usa a registrada em `object`.}
  \item{show_raw}{Mostrar observações individuais?}
  \item{show_means}{Mostrar médias observadas por nível?}
  \item{interval}{Mostrar intervalo de confiança?}
  \item{equation}{Adicionar equação e R² ao gráfico?}
  \item{theme}{Tema `ggplot2`. }
}
\value{
Objeto `ggplot`.
}
\description{
Mostra observações, médias por nível, curva ajustada, intervalo de confiança e equação do modelo principal de um objeto produzido por [reg_poly()].
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
d <- data.frame(dose = rep(c(0, 50, 100, 150), each = 4))
d$y <- 12 + 0.2 * d$dose - 0.0008 * d$dose^2 + stats::rnorm(nrow(d))
rp <- reg_poly(d, y, dose, degree = 2)
plot_reg(rp)

plot_reg(rp, data = d, x = dose, y = y, show_raw = TRUE, show_means = TRUE)

plot_reg(rp, equation = FALSE)
}
