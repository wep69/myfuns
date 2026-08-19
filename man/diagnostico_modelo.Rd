\name{diagnostico_modelo}
\alias{diagnostico_modelo}
\title{Diagnóstico orientado pela classe do modelo}
\usage{
diagnostico_modelo(model,
                                 simulations = 1000,
                                 seed = 123,
                                 plot = TRUE,
                                 verbose = TRUE)
}
\arguments{
  \item{model}{Modelo ajustado.}
  \item{simulations}{Número de simulações para diagnósticos que as utilizem.}
  \item{seed}{Semente de reprodutibilidade.}
  \item{plot}{Produzir objeto de diagnóstico visual com `performance::check_model()`?}
  \item{verbose}{Imprimir síntese em português? }
}
\value{
Lista da classe `myfuns_diagnostico`.
}
\description{
Reúne verificações coerentes com modelos lineares, GLM, modelos mistos de `lme4` e modelos `glmmTMB`. Quando o pacote `performance` está disponível, utiliza suas verificações especializadas. Nenhum teste isolado é usado para aceitar, rejeitar ou substituir automaticamente o modelo.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
m1 <- stats::lm(weight ~ group, data = PlantGrowth)
diagnostico_modelo(m1, plot = FALSE)

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
diagnostico_modelo(mp, simulations = 200, plot = FALSE)

if (requireNamespace("glmmTMB", quietly = TRUE)) {
mnb <- glmmTMB::glmmTMB(breaks ~ wool * tension, family = glmmTMB::nbinom2, data = warpbreaks)
diagnostico_modelo(mnb, simulations = 200, plot = FALSE)
}
}
