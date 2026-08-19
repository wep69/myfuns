# Exportar várias figuras em lote

Aplica \[ExportTimes()\] a uma lista de gráficos, padronizando nomes,
pasta, formatos, dimensões, resolução e fundo.

## Usage

``` r
export_figuras(plots,
                             dir,
                             formats = c("png", "tiff", "svg"),
                             width = 20,
                             height = 15,
                             units = "cm",
                             dpi = 600,
                             bg = "white",
                             family = "Times New Roman")
```

## Arguments

- plots:

  Lista nomeada de objetos gráficos imprimíveis.

- dir:

  Pasta de destino.

- formats:

  Formatos dentre \`png\`, \`tiff\`, \`svg\` e \`emf\`.

- width:

  Largura.

- height:

  Altura.

- units:

  Unidade de largura e altura.

- dpi:

  Resolução dos formatos raster.

- bg:

  Fundo do dispositivo.

- family:

  Família tipográfica repassada a \[ExportTimes()\].

## Value

Lista nomeada com os caminhos produzidos para cada figura.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
p1 <- ggplot2::ggplot(mtcars,
    ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() +
  theme_nogrid()
p2 <- ggplot2::ggplot(iris,
    ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() +
  theme_nogrid()
if (FALSE) { # \dontrun{
export_figuras(list(mtcars = p1, iris = p2),
               tempdir(), formats = "png")
} # }

if (FALSE) { # \dontrun{
export_figuras(list(fig1 = p1, fig2 = p2),
               tempdir(), formats = "tiff",
               dpi = 600)
} # }

if (FALSE) { # \dontrun{
export_figuras(
  list(fig1 = p1 + trans,
       fig2 = p2 + trans),
  tempdir(),
  formats = c("png", "svg"),
  bg = "transparent")
} # }
```
