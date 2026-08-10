\name{anovaCV}
\alias{anovaCV}
\title{Tabela de ANOVA e coeficiente de variação}
\usage{
anovaCV(x, digits = 1)
}
\arguments{
\item{x}{Modelo ajustado aceito por \code{anova()}, tipicamente \code{lm}, \code{aov} ou modelo misto para o qual \code{sigma()} esteja definido.}
\item{digits}{Número de casas decimais usadas no CV.}
}
\description{
Retorna a tabela de análise de variância e o coeficiente de variação experimental em porcentagem.
}
\details{
O CV é calculado como 100 vezes o desvio-padrão residual, obtido por \code{sigma(modelo)}, dividido pelo valor absoluto da média da resposta. O valor deve ser interpretado no contexto da variável, da escala e do delineamento experimental.
}
\value{
Lista com os componentes \code{Anova} e \code{CV}.
}
\examples{
dados <- data.frame(
  tratamento = factor(rep(c("A", "B", "C"), each = 4)),
  y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
)
mod <- lm(y ~ tratamento, data = dados)
anovaCV(mod)
}
