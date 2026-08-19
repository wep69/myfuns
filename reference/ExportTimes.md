# Exportar um grafico em formatos de publicacao

Salva o mesmo grafico em formatos raster e vetoriais. Os padroes
preservam a funcao historica: 20 x 15 cm, 600 dpi e Times New Roman.

## Usage

``` r
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
```

## Arguments

- gplot:

  Grafico imprimivel, tipicamente um objeto ggplot.

- filename:

  Caminho-base sem extensao.

- width, height:

  Dimensoes do grafico.

- units:

  Unidade: `"in"`, `"cm"`, `"mm"` ou `"px"`.

- dpi:

  Resolucao dos formatos raster.

- family:

  Familia tipografica solicitada ao dispositivo.

- formats:

  Formatos dentre png, tiff, svg e emf.

- bg:

  Cor de fundo do dispositivo.

- compression:

  Compressao TIFF.

- create_dir:

  Criar a pasta de destino automaticamente?

## Details

EMF usa [`devEMF::emf()`](https://rdrr.io/pkg/devEMF/man/emf.html)
quando disponivel e, no Windows, pode usar o dispositivo
`win.metafile()`.

## Value

Vetor nomeado com os arquivos produzidos.

## Examples

``` r
if (FALSE) { # \dontrun{
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_nogrid()
ExportTimes(p, file.path(tempdir(), "figura_1"), formats = c("png", "svg"))
} # }
```
