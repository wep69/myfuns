\name{export_figuras}
\alias{export_figuras}
\title{Exportar várias figuras em lote}
\usage{
export_figuras(plots,
                             dir,
                             formats = c("png", "tiff", "svg"),
                             width = 20,
                             height = 15,
                             units = "cm",
                             dpi = 600,
                             bg = "white",
                             family = "Times New Roman")
}
\arguments{
  \item{plots}{Lista nomeada de objetos gráficos imprimíveis.}
  \item{dir}{Pasta de destino.}
  \item{formats}{Formatos dentre `png`, `tiff`, `svg` e `emf`.}
  \item{width}{Largura.}
  \item{height}{Altura.}
  \item{units}{Unidade de largura e altura.}
  \item{dpi}{Resolução dos formatos raster.}
  \item{bg}{Fundo do dispositivo.}
  \item{family}{Família tipográfica repassada a [ExportTimes()]. }
}
\value{
Lista nomeada com os caminhos produzidos para cada figura.
}
\description{
Aplica [ExportTimes()] a uma lista de gráficos, padronizando nomes, pasta, formatos, dimensões, resolução e fundo.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
\donttest{
p1 <- ggplot2::ggplot(mtcars,
    ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() +
  theme_nogrid()
p2 <- ggplot2::ggplot(iris,
    ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() +
  theme_nogrid()
export_figuras(list(mtcars = p1, iris = p2),
               tempdir(), formats = "png")
export_figuras(list(fig1 = p1, fig2 = p2),
               tempdir(), formats = "tiff",
               dpi = 600)
}
}
