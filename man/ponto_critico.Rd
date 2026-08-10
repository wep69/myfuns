\name{ponto_critico}
\alias{ponto_critico}
\title{Calcular pontos críticos de uma regressão polinomial}
\usage{
ponto_critico(model, range = NULL, conf.level = 0.95, classify = TRUE)
}
\arguments{
  \item{model}{Objeto `lm` ou `myfuns_reg_poly`.}
  \item{range}{Intervalo experimental `c(min, max)`. Se `NULL`, é inferido do banco usado no ajuste.}
  \item{conf.level}{Nível de confiança do intervalo aproximado para o ponto quadrático.}
  \item{classify}{Classificar o ponto como máximo, mínimo ou indeterminado? }
}
\value{
`data.frame` com posição, resposta prevista, classificação, posição relativa ao domínio e, quando disponível, intervalo de confiança.
}
\description{
Obtém raízes da primeira derivada de modelos polinomiais brutos produzidos por `lm()` ou [reg_poly()]. Para regressões quadráticas, também calcula um intervalo aproximado para a posição do ponto pelo método delta.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
d <- data.frame(dose = rep(c(0, 50, 100, 150, 200), each = 3))
d$y <- 20 + 0.25 * d$dose - 0.0008 * d$dose^2 + rep(c(-1, 0, 1), 5)
mq <- stats::lm(y ~ dose + I(dose^2), data = d)
ponto_critico(mq, range = range(d$dose))

ponto_critico(mq, range = c(0, 100))

rp <- reg_poly(d, y, dose, degree = 2)
ponto_critico(rp)
}
