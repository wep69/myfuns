\name{resumo_bayes}
\alias{resumo_bayes}
\title{Resumo posterior para modelos bayesianos}
\usage{
resumo_bayes(model,
                           ci = 0.95,
                           ci_method = "hdi",
                           centrality = "median",
                           diagnostics = TRUE,
                           rope = NULL,
                           exponentiate = FALSE)
}
\arguments{
  \item{model}{Modelo bayesiano ou objeto de amostras posteriores aceito por `bayestestR::describe_posterior()`.}
  \item{ci}{Probabilidade do intervalo de credibilidade.}
  \item{ci_method}{Método do intervalo, como `"hdi"` ou `"eti"`.}
  \item{centrality}{Medida de tendência central, como `"median"` ou `"mean"`.}
  \item{diagnostics}{Incluir ESS, Rhat e MCSE quando disponíveis?}
  \item{rope}{Limites `c(inferior, superior)` da região de equivalência prática. Se `NULL`, nenhuma ROPE é calculada.}
  \item{exponentiate}{Exponenciar estimativas e limites compatíveis, útil para modelos com link log ou logit quando essa transformação possui sentido. }
}
\value{
`data.frame` com o resumo posterior.
}
\description{
Organiza estimativas posteriores, intervalos de credibilidade e diagnósticos de MCMC por meio de `bayestestR::describe_posterior()`. ROPE só é incluída quando o pesquisador informa explicitamente seus limites.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
if (requireNamespace("bayestestR", quietly = TRUE)) {
set.seed(1)
resumo_bayes(stats::rnorm(2000, 0.4, 0.2), diagnostics = FALSE)
}

if (requireNamespace("bayestestR", quietly = TRUE)) {
set.seed(2)
resumo_bayes(stats::rnorm(2000, 0.05, 0.15), diagnostics = FALSE, rope = c(-0.1, 0.1))
}

\dontrun{
fit <- brms::brm(mpg ~ wt, data = mtcars, family = gaussian(), seed = 123)
resumo_bayes(fit, ci = 0.95, ci_method = "hdi")
}
}
