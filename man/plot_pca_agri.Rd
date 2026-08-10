\name{plot_pca_agri}
\alias{plot_pca_agri}
\title{Gráficos de PCA em padrão de publicação}
\usage{
plot_pca_agri(object,
                            axes = c(1, 2),
                            type = c("biplot", "scores", "loadings"),
                            group = NULL,
                            ellipse = FALSE,
                            labels = FALSE,
                            theme = theme_nogridacp())
}
\arguments{
  \item{object}{Resultado de [pca_agri()].}
  \item{axes}{Dois componentes, por exemplo `c(1, 2)`.}
  \item{type}{`"biplot"`, `"scores"` ou `"loadings"`.}
  \item{group}{Variável de grupo. Se omitida, usa a registrada em `pca_agri()`.}
  \item{ellipse}{Adicionar elipse por grupo aos escores?}
  \item{labels}{Adicionar rótulos das observações nos escores e das variáveis nas cargas?}
  \item{theme}{Tema `ggplot2`. }
}
\value{
Objeto `ggplot`.
}
\description{
Produz biplot, gráfico de escores ou gráfico de cargas a partir de [pca_agri()]. Os eixos são rotulados com a porcentagem de variância explicada.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
pca <- pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
plot_pca_agri(pca, type = "biplot")

plot_pca_agri(pca, type = "scores", ellipse = TRUE)

plot_pca_agri(pca, axes = c(1, 3), type = "loadings", labels = TRUE)
}
