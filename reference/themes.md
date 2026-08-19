# Temas ggplot2 do pacote myfuns

Temas para remover grades, destacar eixos ou molduras e produzir figuras
com fundo transparente.

## Usage

``` r
theme_nogrid(base_size = 12, base_family = "")

theme_nogridacp(base_size = 12, base_family = "")

theme_transparent()

trans
```

## Arguments

- base_size:

  Tamanho base da fonte.

- base_family:

  Familia tipografica base.

## Details

`trans` e um objeto pronto equivalente a `theme_transparent()`.

## Value

Objeto `theme` do ggplot2.

## Examples

``` r
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
p + theme_nogrid()

p + theme_nogridacp()

p + trans
```
