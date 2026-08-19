\name{reg_poly}
\alias{reg_poly}
\title{Ajustar regressões polinomiais para fatores quantitativos}
\usage{
reg_poly(data,
                       y,
                       x,
                       degree = 1:3,
                       weights = NULL,
                       compare = TRUE,
                       lack_of_fit = TRUE,
                       conf.level = 0.95)
}
\arguments{
  \item{data}{`data.frame`.}
  \item{y}{Variável resposta numérica.}
  \item{x}{Variável quantitativa numérica.}
  \item{degree}{Grau ou vetor de graus, por exemplo `1:3`.}
  \item{weights}{Pesos opcionais. Pode ser uma variável do banco ou vetor numérico com comprimento igual ao número de linhas.}
  \item{compare}{Produzir tabela comparativa dos modelos? Padrão `TRUE`.}
  \item{lack_of_fit}{Calcular teste de falta de ajuste quando possível?}
  \item{conf.level}{Nível de confiança para coeficientes e predições. }
}
\value{
Objeto da classe `myfuns_reg_poly`.
}
\description{
Ajusta modelos polinomiais brutos de graus especificados, preserva todos os modelos candidatos e produz medidas comparativas, intervalos dos coeficientes, teste de falta de ajuste quando há repetição de níveis e predições para o modelo de maior grau solicitado. A função não seleciona automaticamente o "melhor" modelo.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
set.seed(1)
d <- expand.grid(rep = factor(1:4), dose = c(0, 50, 100, 150, 200))
d$y <- 20 + 0.2 * d$dose - 0.0007 * d$dose^2 + stats::rnorm(nrow(d), 0, 2)
reg_poly(d, y, dose, degree = 1:2)

reg_poly(d, y, dose, degree = 2, compare = FALSE)

rp <- reg_poly(d, y, dose, degree = 1:3, compare = TRUE)
rp$comparacao
}
