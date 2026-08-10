\name{comparar_modelos}
\alias{comparar_modelos}
\title{Comparar modelos candidatos por múltiplos critérios}
\usage{
comparar_modelos(...,
                               metrics = c("AIC", "AICc", "BIC", "logLik", "R2", "RMSE"),
                               rank_by = NULL,
                               check_comparability = TRUE)
}
\arguments{
  \item{...}{Modelos nomeados ou uma única lista de modelos.}
  \item{metrics}{Métricas desejadas dentre `AIC`, `AICc`, `BIC`, `logLik`, `R2` e `RMSE`.}
  \item{rank_by}{Métrica opcional usada apenas para ordenar a tabela.}
  \item{check_comparability}{Realizar verificações de comparabilidade? }
}
\value{
Lista da classe `myfuns_comparacao_modelos`.
}
\description{
Calcula AIC, AICc, BIC, log-verossimilhança, R² quando definido e RMSE. Antes da comparação, registra alertas sobre resposta, conjunto de observações e, para modelos lineares mistos, uso de REML com efeitos fixos diferentes.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
d <- data.frame(x = rep(0:4, each = 4))
d$y <- 2 + 1.5 * d$x - 0.2 * d$x^2 + stats::rnorm(nrow(d))
ml <- stats::lm(y ~ x, d)
mq <- stats::lm(y ~ x + I(x^2), d)
comparar_modelos(linear = ml, quadratico = mq)

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
if (requireNamespace("MASS", quietly = TRUE)) {
mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
comparar_modelos(poisson = mp, negbin = mnb)
}

comparar_modelos(linear = ml, quadratico = mq, metrics = c("AICc", "BIC", "RMSE"), rank_by = "AICc")
}
