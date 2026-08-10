\name{anova_agri}
\alias{anova_agri}
\title{ANOVA organizada para experimentação agrícola}
\usage{
anova_agri(model,
                         effect_size = c("eta2_partial", "eta2",
                                         "omega2_partial", "omega2", "none"),
                         cv = TRUE,
                         conf.level = 0.95)
}
\arguments{
  \item{model}{Modelo ajustado, tipicamente `lm` ou `aov`.}
  \item{effect_size}{Tamanho de efeito. Opções: `"eta2_partial"`, `"eta2"`, `"omega2_partial"`, `"omega2"` ou `"none"`.}
  \item{cv}{Calcular coeficiente de variação experimental? Padrão `TRUE`.}
  \item{conf.level}{Nível de confiança usado por `effectsize`, quando disponível. }
}
\value{
Lista da classe `myfuns_anova`.
}
\description{
Reúne tabela de análise de variância, coeficiente de variação, tamanho de efeito e informações básicas do modelo em um único objeto. A função não usa significância estatística para tomar decisões automáticas sobre tratamentos.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
m1 <- stats::lm(weight ~ group, data = PlantGrowth)
anova_agri(m1)

m2 <- stats::lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
anova_agri(m2, effect_size = "eta2")

anova_agri(m1, cv = FALSE, effect_size = "eta2_partial")
}
