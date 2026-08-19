# Gráficos de PCA em padrão de publicação

Produz biplot, gráfico de escores ou gráfico de cargas a partir de
\[pca_agri()\]. Os eixos são rotulados com a porcentagem de variância
explicada.

## Usage

``` r
plot_pca_agri(object,
                            axes = c(1, 2),
                            type = c("biplot", "scores", "loadings"),
                            group = NULL,
                            ellipse = FALSE,
                            labels = FALSE,
                            theme = theme_nogridacp())
```

## Arguments

- object:

  Resultado de \[pca_agri()\].

- axes:

  Dois componentes, por exemplo \`c(1, 2)\`.

- type:

  \`"biplot"\`, \`"scores"\` ou \`"loadings"\`.

- group:

  Variável de grupo. Se omitida, usa a registrada em \`pca_agri()\`.

- ellipse:

  Adicionar elipse por grupo aos escores?

- labels:

  Adicionar rótulos das observações nos escores e das variáveis nas
  cargas?

- theme:

  Tema \`ggplot2\`.

## Value

Objeto \`ggplot\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
pca <- pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
plot_pca_agri(pca, type = "biplot")


plot_pca_agri(pca, type = "scores", ellipse = TRUE)


plot_pca_agri(pca, axes = c(1, 3), type = "loadings", labels = TRUE)
```
