\name{ExportTimes}
\alias{ExportTimes}
\title{Exportar um grafico em formatos de publicacao}
\usage{
ExportTimes(
  gplot,
  filename,
  width = 20,
  height = 15,
  units = "cm",
  dpi = 600,
  family = "Times New Roman",
  formats = c("png", "tiff", "svg", "emf"),
  bg = "white",
  compression = "lzw",
  create_dir = TRUE
)
}
\arguments{
\item{gplot}{Grafico imprimivel, tipicamente um objeto ggplot.}
\item{filename}{Caminho-base sem extensao.}
\item{width, height}{Dimensoes do grafico.}
\item{units}{Unidade: \code{"in"}, \code{"cm"}, \code{"mm"} ou \code{"px"}.}
\item{dpi}{Resolucao dos formatos raster.}
\item{family}{Familia tipografica solicitada ao dispositivo.}
\item{formats}{Formatos dentre png, tiff, svg e emf.}
\item{bg}{Cor de fundo do dispositivo.}
\item{compression}{Compressao TIFF.}
\item{create_dir}{Criar a pasta de destino automaticamente?}
}
\description{
Salva o mesmo grafico em formatos raster e vetoriais. Os padroes preservam a
funcao historica: 20 x 15 cm, 600 dpi e Times New Roman.
}
\details{
EMF usa \code{devEMF::emf()} quando disponivel e, no Windows, pode usar o
dispositivo \code{win.metafile()}.
}
\value{Vetor nomeado com os arquivos produzidos.}
\examples{
\dontrun{
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_nogrid()
ExportTimes(p, file.path(tempdir(), "figura_1"), formats = c("png", "svg"))
}
}
