\name{theme_nogrid}
\alias{theme_nogrid}
\alias{theme_nogridacp}
\alias{theme_transparent}
\alias{trans}
\title{Temas ggplot2 do pacote myfuns}
\usage{
theme_nogrid(base_size = 12, base_family = "")

theme_nogridacp(base_size = 12, base_family = "")

theme_transparent()

trans
}
\arguments{
\item{base_size}{Tamanho base da fonte.}
\item{base_family}{Familia tipografica base.}
}
\description{
Temas para remover grades, destacar eixos ou molduras e produzir figuras com
fundo transparente.
}
\details{
\code{trans} e um objeto pronto equivalente a \code{theme_transparent()}.
}
\value{Objeto \code{theme} do ggplot2.}
\examples{
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
p + theme_nogrid()
p + theme_nogridacp()
p + trans
}
