\name{diagnostico_contagem}
\alias{diagnostico_contagem}
\title{Diagnóstico de modelos de contagem}
\usage{
diagnostico_contagem(model,
                                   simulations = 1000,
                                   test_dispersion = TRUE,
                                   test_zeros = TRUE,
                                   test_outliers = TRUE,
                                   seed = 123)
}
\arguments{
  \item{model}{Modelo de contagem ajustado.}
  \item{simulations}{Número de simulações para `DHARMa`.}
  \item{test_dispersion}{Executar teste de dispersão?}
  \item{test_zeros}{Executar teste de excesso ou deficiência de zeros?}
  \item{test_outliers}{Executar teste de observações discrepantes?}
  \item{seed}{Semente para as simulações. }
}
\value{
Lista da classe `myfuns_diagnostico_contagem`.
}
\description{
Centraliza verificações de dispersão, frequência de zeros, resíduos simulados e observações discrepantes para modelos de contagem. A função não troca a família do modelo automaticamente.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
diagnostico_contagem(mp, simulations = 200)

if (requireNamespace("MASS", quietly = TRUE)) {
mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
diagnostico_contagem(mnb, simulations = 200)
}

if (requireNamespace("glmmTMB", quietly = TRUE)) {
mzi <- glmmTMB::glmmTMB(breaks ~ tension, ziformula = ~1,
family = glmmTMB::nbinom2, data = warpbreaks)
diagnostico_contagem(mzi, simulations = 200)
}
}
