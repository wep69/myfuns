\name{pca_agri}
\alias{pca_agri}
\title{Análise de componentes principais para dados agronômicos}
\usage{
pca_agri(data,
                       vars,
                       scale = TRUE,
                       center = TRUE,
                       group = NULL,
                       ncomp = NULL)
}
\arguments{
  \item{data}{`data.frame`.}
  \item{vars}{Variáveis numéricas, como `c(var1, var2, var3)` ou vetor de nomes.}
  \item{scale}{Padronizar pelas unidades de desvio-padrão?}
  \item{center}{Centralizar as variáveis?}
  \item{group}{Variável opcional de agrupamento para gráficos.}
  \item{ncomp}{Número de componentes a reportar. `NULL` usa todos os disponíveis. }
}
\value{
Objeto da classe `myfuns_pca`.
}
\description{
Padroniza um fluxo de PCA baseado em [stats::prcomp()], preservando o objeto original e organizando escores, cargas, autovalores, variância explicada, variância acumulada e contribuição das variáveis. Valores ausentes não são removidos silenciosamente.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
pca1 <- pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
pca1

pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), scale = FALSE)

pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), ncomp = 3)
}
