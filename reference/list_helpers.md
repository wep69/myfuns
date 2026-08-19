# Aplicar contrastes ou compact letter displays a elementos de uma lista

`contrast_lista()` aplica
[`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
e `cld_lista()` aplica
[`multcomp::cld()`](https://rdrr.io/pkg/multcomp/man/cld.html) aos
elementos selecionados de uma lista.

## Usage

``` r
contrast_lista(object, ..., which = seq_along(object))

cld_lista(object, ..., which = seq_along(object))
```

## Arguments

- object:

  Lista de objetos compativeis com a operacao solicitada.

- ...:

  Argumentos adicionais para
  [`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
  ou [`multcomp::cld()`](https://rdrr.io/pkg/multcomp/man/cld.html).

- which:

  Indices dos elementos a processar.

## Details

Em um CLD tradicional, letras compartilhadas indicam apenas que a
diferenca nao foi demonstrada sob o procedimento usado; nao demonstram
igualdade.

## Value

Lista com um resultado por elemento processado.

## Examples

``` r
dados <- data.frame(
  trat = factor(rep(c("A", "B", "C"), each = 4)),
  bloco = factor(rep(1:4, times = 3)),
  y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
)
mod <- lm(y ~ trat + bloco, data = dados)
em <- emmeans::emmeans(mod, ~ trat)
contrast_lista(list(resposta = em), method = "pairwise")
#> $resposta
#>  contrast estimate    SE df t.ratio p.value
#>  A - B          -3 0.667  6  -4.500  0.0098
#>  A - C          -6 0.667  6  -9.000  0.0003
#>  B - C          -3 0.667  6  -4.500  0.0098
#> 
#> Results are averaged over the levels of: bloco 
#> P value adjustment: tukey method for comparing a family of 3 estimates 
#> 
```
