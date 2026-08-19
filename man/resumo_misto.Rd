\name{resumo_misto}
\alias{resumo_misto}
\title{Resumir modelos mistos}
\usage{
resumo_misto(model, conf.level = 0.95, exponentiate = FALSE)
}
\arguments{
  \item{model}{Modelo misto.}
  \item{conf.level}{Nível de confiança dos efeitos fixos.}
  \item{exponentiate}{Exponenciar estimativas e intervalos dos efeitos fixos? }
}
\value{
Lista da classe `myfuns_resumo_misto`.
}
\description{
Organiza efeitos fixos, intervalos de confiança de Wald, componentes de variância, ICC, R² marginal e condicional, singularidade e convergência para modelos `merMod` e `glmmTMB` quando as informações estão disponíveis.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
if (requireNamespace("lme4", quietly = TRUE)) {
m1 <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
resumo_misto(m1)
}

if (requireNamespace("lme4", quietly = TRUE)) {
m2 <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
resumo_misto(m2)
}

if (requireNamespace("lme4", quietly = TRUE)) {
m3 <- lme4::glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
family = binomial, data = lme4::cbpp)
resumo_misto(m3, exponentiate = TRUE)
}
}
