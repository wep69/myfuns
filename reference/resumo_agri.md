# Resumo descritivo para experimentação agrícola

Calcula, por um ou mais grupos, tamanho amostral, média, desvio-padrão,
erro-padrão, intervalo de confiança da média, mediana, quartis, mínimo,
máximo e coeficiente de variação descritivo.

## Usage

``` r
resumo_agri(data, resposta, ..., conf.level = 0.95, na.rm = TRUE)
```

## Arguments

- data:

  \`data.frame\`.

- resposta:

  Variável numérica resposta.

- ...:

  Variáveis de agrupamento, informadas sem aspas.

- conf.level:

  Nível do intervalo de confiança da média.

- na.rm:

  Remover valores ausentes da resposta? Quando \`FALSE\`, grupos com
  ausências retornam estatísticas \`NA\` para medidas dependentes da
  resposta.

## Value

\`data.frame\` com as estatísticas descritivas por grupo.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
resumo_agri(iris, Sepal.Length, Species)
#>      Species  n n_total n_ausentes media        dp erro_padrao ic_inferior
#> 1     setosa 50      50          0 5.006 0.3524897  0.04984957    4.905824
#> 2 versicolor 50      50          0 5.936 0.5161711  0.07299762    5.789306
#> 3  virginica 50      50          0 6.588 0.6358796  0.08992695    6.407285
#>   ic_superior mediana    q1  q3 minimo maximo       cv
#> 1    5.106176     5.0 4.800 5.2    4.3    5.8 7.041344
#> 2    6.082694     5.9 5.600 6.3    4.9    7.0 8.695606
#> 3    6.768715     6.5 6.225 6.9    4.9    7.9 9.652089

iris$grupo_largura <- cut(iris$Sepal.Width, breaks = 2)
resumo_agri(iris, Petal.Length, Species, grupo_largura)
#>      Species grupo_largura  n n_total n_ausentes    media        dp erro_padrao
#> 1     setosa       (2,3.2] 17      17          0 1.400000 0.1414214  0.03429972
#> 2     setosa     (3.2,4.4] 33      33          0 1.493939 0.1818987  0.03166449
#> 3 versicolor       (2,3.2] 48      48          0 4.245833 0.4739864  0.06841405
#> 4 versicolor     (3.2,4.4]  2       2          0 4.600000 0.1414214  0.10000000
#> 5  virginica       (2,3.2] 42      42          0 5.476190 0.5427165  0.08374298
#> 6  virginica     (3.2,4.4]  8       8          0 5.950000 0.4375255  0.15468863
#>   ic_inferior ic_superior mediana    q1    q3 minimo maximo        cv
#> 1    1.327288    1.472712    1.40 1.300 1.500    1.1    1.6 10.101525
#> 2    1.429441    1.558438    1.50 1.400 1.600    1.0    1.9 12.175772
#> 3    4.108202    4.383465    4.30 4.000 4.600    3.0    5.1 11.163566
#> 4    3.329380    5.870620    4.60 4.550 4.650    4.5    4.7  3.074377
#> 5    5.307068    5.645313    5.45 5.100 5.800    4.5    6.9  9.910476
#> 6    5.584220    6.315780    5.85 5.675 6.175    5.4    6.7  7.353370

resumo_agri(iris, Sepal.Length, Species, conf.level = 0.90)
#>      Species  n n_total n_ausentes media        dp erro_padrao ic_inferior
#> 1     setosa 50      50          0 5.006 0.3524897  0.04984957    4.922425
#> 2 versicolor 50      50          0 5.936 0.5161711  0.07299762    5.813616
#> 3  virginica 50      50          0 6.588 0.6358796  0.08992695    6.437233
#>   ic_superior mediana    q1  q3 minimo maximo       cv
#> 1    5.089575     5.0 4.800 5.2    4.3    5.8 7.041344
#> 2    6.058384     5.9 5.600 6.3    4.9    7.0 8.695606
#> 3    6.738767     6.5 6.225 6.9    4.9    7.9 9.652089
```
