\name{contraste_poly}
\alias{contraste_poly}
\title{Contrastes polinomiais com os valores reais do fator quantitativo}
\usage{
contraste_poly(emm,
                             scores = NULL,
                             degree = NULL,
                             normalized = TRUE,
                             adjust = "none")
}
\arguments{
  \item{emm}{Objeto `emmGrid` com médias estimadas de um fator quantitativo.}
  \item{scores}{Valores numéricos correspondentes aos níveis. Se `NULL`, a função tenta converter os níveis do primeiro fator do `emmGrid` para número.}
  \item{degree}{Maior grau a ser retornado. `NULL` usa o máximo permitido.}
  \item{normalized}{Se `TRUE`, usa `opoly`, cujos coeficientes são normalizados. Se `FALSE`, `poly` só é usado quando os escores são igualmente espaçados.}
  \item{adjust}{Ajuste de multiplicidade. O padrão é `"none"`. }
}
\value{
Lista da classe `myfuns_contraste_poly` com objeto de contraste, tabela, escores, grau e informação sobre espaçamento.
}
\description{
Calcula contrastes polinomiais ortogonais com `emmeans`. Quando os níveis quantitativos são desigualmente espaçados, utiliza `opoly`, que admite `scores` reais. A função informa explicitamente os escores usados e não escolhe automaticamente o grau da regressão.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
dados <- data.frame(dose = factor(rep(c(0, 50, 100, 150), each = 4)), y = 1:16)
m <- stats::lm(y ~ dose, data = dados)
em <- emmeans::emmeans(m, ~ dose)
contraste_poly(em, scores = c(0, 50, 100, 150))

dados2 <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = 1:16)
m2 <- stats::lm(y ~ dose, data = dados2)
em2 <- emmeans::emmeans(m2, ~ dose)
contraste_poly(em2, scores = c(0, 25, 100, 200))

contraste_poly(em, scores = c(0, 50, 100, 150), degree = 2)
}
