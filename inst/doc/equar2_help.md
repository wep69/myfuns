# `equar2()`: equacoes de regressao para anotacao de graficos

## Descricao

`equar2()` recebe uma tabela de medias por nivel quantitativo e o resultado de contrastes polinomiais, seleciona uma representacao constante, linear ou quadratica e devolve uma string em sintaxe `plotmath`.

A funcao foi incorporada ao `myfuns` a partir do script `equar2.R` fornecido para a modernizacao. A nova implementacao elimina as duas definicoes duplicadas do script original, valida a entrada e preserva a logica de decisao baseada nos contrastes `linear` e `quadratic`.

## Uso

```r
equar2(
  media,
  contrast_result,
  alpha = 0.05,
  strong_alpha = 0.01,
  digits = c(2, 3, 4, 1),
  r2_percent = TRUE,
  details = FALSE
)
```

## Argumentos

- `media`: `data.frame` com pelo menos duas colunas. A primeira deve representar `x`; a segunda, as medias de `y`.
- `contrast_result`: resultado com colunas `contrast` e `p.value`, normalmente obtido com `emmeans::contrast(..., "poly")` e convertido com `as.data.frame()`.
- `alpha`: limiar para significancia, por padrao 0,05.
- `strong_alpha`: limiar para `**`, por padrao 0,01.
- `digits`: casas decimais para intercepto/media, coeficiente linear, coeficiente quadratico e R2.
- `r2_percent`: mostra o R2 em porcentagem quando `TRUE`.
- `details`: retorna detalhes do modelo quando `TRUE`.

## Regra de selecao

1. Se o contraste quadratico tem `p <= alpha`, ajusta-se modelo quadratico.
2. Caso contrario, se o contraste linear tem `p <= alpha`, ajusta-se modelo linear.
3. Caso contrario, apresenta-se apenas a media geral das medias.

Quando o quadratico e selecionado, o modelo inclui os termos linear e quadratico, respeitando a hierarquia polinomial.

## Exemplo completo

```r
dados <- data.frame(
  TRAT = c(0, 50, 100, 150, 200, 250, 300, 0, 50, 100, 150, 200, 250,
           300, 0, 50, 100, 150, 200, 250, 300, 0, 50, 100, 150,
           200, 250, 300),
  REP = rep(1:4, each = 7),
  PESO = c(134.8, 161.7, 160.7, 169.8, 165.7, 171.8, 154.5, 139.7,
           157.7, 172.7, 168.2, 160, 157.3, 160.4, 147.6, 150.3,
           163.4, 160.7, 158.2, 150.4, 148.8, 132.3, 144.7, 161.3,
           161, 151, 160.4, 154)
)

dados$TRATq <- dados$TRAT
dados$TRAT <- factor(dados$TRAT)

modelo <- lm(PESO ~ TRAT, data = dados)

test2 <- emmeans::emmeans(modelo, ~ TRAT) |>
  emmeans::contrast("poly") |>
  as.data.frame()

media <- aggregate(PESO ~ TRATq, data = dados, FUN = mean)

eq <- equar2(media, test2)
eq
```

## Uso no `ggplot2`

```r
p <- ggplot2::ggplot(media, ggplot2::aes(TRATq, PESO)) +
  ggplot2::geom_point(size = 3) +
  ggplot2::annotate(
    "text",
    x = Inf,
    y = Inf,
    label = eq,
    parse = TRUE,
    hjust = 1.05,
    vjust = 1.5
  ) +
  theme_nogrid()
```

## Saida detalhada

```r
res <- equar2(media, test2, details = TRUE)
res$equation
res$degree
res$r_squared
res$p_values
summary(res$model)
```

## Interpretacao estatistica

O R2 exibido e calculado sobre as medias fornecidas. Ele nao deve ser interpretado como o R2 do modelo ajustado a todas as unidades experimentais. A significancia dos termos apresentada por asteriscos deriva dos contrastes polinomiais fornecidos.

Para tratamentos quantitativos desigualmente espaçados, prefira `contraste_poly()`, informando os valores reais das doses. O objeto retornado pode ser fornecido diretamente a `equar2()`, que reconhece os escores usados na construção dos contrastes.
