# Manual completo do pacote myfuns 0.5.0

## Referência integrada em português

Este manual reúne as vinhetas temáticas do pacote em um único documento.
Cada uma das vinte funções incorporadas na versão 0.5.0 possui pelo
menos três exemplos de uso nas seções correspondentes. Os exemplos
distinguem rotinas diretamente executáveis daqueles que dependem de
pacotes opcionais.

A finalidade do pacote é apoiar fluxos estatísticos repetitivos sem
substituir a definição do delineamento, a escolha do modelo, a avaliação
dos pressupostos ou a interpretação científica.

------------------------------------------------------------------------

# Finalidade

`myfuns` é uma camada de apoio para análise estatística aplicada à
experimentação agrícola. A versão 0.5.0 preserva as funções históricas e
acrescenta vinte funções para auditoria de delineamentos, descrição,
ANOVA, `emmeans`, regressão quantitativa, diagnóstico, modelos mistos,
contagens, PCA, Bayes e exportação de figuras.

A filosofia do pacote é auxiliar o fluxo de trabalho sem substituir
decisões científicas. Nenhuma função seleciona tratamento, modelo,
distribuição ou grau polinomial apenas com base em um valor de p.

# Organização funcional

| Etapa | Funções principais |
|----|----|
| Verificação do banco | [`auditar_delineamento()`](https://wep69.github.io/myfuns/reference/auditar_delineamento.md), [`resumo_agri()`](https://wep69.github.io/myfuns/reference/resumo_agri.md) |
| ANOVA | [`anovaCV()`](https://wep69.github.io/myfuns/reference/anovaCV.md), [`anova_agri()`](https://wep69.github.io/myfuns/reference/anova_agri.md) |
| Médias e contrastes | [`emmeans_lista()`](https://wep69.github.io/myfuns/reference/emmeans_lista.md), [`comparar_emmeans()`](https://wep69.github.io/myfuns/reference/comparar_emmeans.md), [`contrast_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md), [`cld_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md), [`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md) |
| Fatores quantitativos | [`reg_poly()`](https://wep69.github.io/myfuns/reference/reg_poly.md), [`ponto_critico()`](https://wep69.github.io/myfuns/reference/ponto_critico.md), [`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md), [`plot_reg()`](https://wep69.github.io/myfuns/reference/plot_reg.md) |
| Diagnóstico | [`diagnostico_modelo()`](https://wep69.github.io/myfuns/reference/diagnostico_modelo.md), [`diagnostico_contagem()`](https://wep69.github.io/myfuns/reference/diagnostico_contagem.md) |
| Modelos mistos | [`resumo_misto()`](https://wep69.github.io/myfuns/reference/resumo_misto.md) |
| Comparação de modelos | [`comparar_modelos()`](https://wep69.github.io/myfuns/reference/comparar_modelos.md) |
| PCA | [`pca_agri()`](https://wep69.github.io/myfuns/reference/pca_agri.md), [`plot_pca_agri()`](https://wep69.github.io/myfuns/reference/plot_pca_agri.md) |
| Bayes | [`resumo_bayes()`](https://wep69.github.io/myfuns/reference/resumo_bayes.md) |
| Gráficos | [`plot_emmeans()`](https://wep69.github.io/myfuns/reference/plot_emmeans.md), [`theme_nogrid()`](https://wep69.github.io/myfuns/reference/themes.md), [`theme_nogridacp()`](https://wep69.github.io/myfuns/reference/themes.md), [`theme_transparent()`](https://wep69.github.io/myfuns/reference/themes.md), `trans` |
| Exportação | [`ExportTimes()`](https://wep69.github.io/myfuns/reference/ExportTimes.md), [`export_figuras()`](https://wep69.github.io/myfuns/reference/export_figuras.md) |
| Área de transferência | [`read_clipboard_table()`](https://wep69.github.io/myfuns/reference/read_clipboard_table.md), [`write_clipboard_table()`](https://wep69.github.io/myfuns/reference/write_clipboard_table.md) e aliases históricos |

# Exemplo integrado: delineamento em blocos com doses

``` r

set.seed(2026)
dados <- expand.grid(
  bloco = factor(1:5),
  dose = c(0, 50, 100, 150, 200)
)
dados$produtividade <- with(
  dados,
  40 + 0.20 * dose - 0.00065 * dose^2 +
    rep(c(-2, 1, 0, 2, -1), each = 5) +
    rnorm(nrow(dados), 0, 2)
)
```

## 1. Auditar antes de modelar

``` r

auditar_delineamento(
  dados,
  tratamento = dose,
  bloco = bloco,
  resposta = produtividade
)
```

## 2. Resumir os dados observados

``` r

resumo_agri(dados, produtividade, dose)
```

## 3. Ajustar o fator quantitativo

``` r

rp <- reg_poly(dados, produtividade, dose, degree = 1:2)
rp
```

A tabela comparativa não representa seleção automática. O pesquisador
deve avaliar forma da resposta, falta de ajuste, incerteza, domínio
experimental, diagnóstico dos resíduos e coerência agronômica.

## 4. Obter o ponto crítico

``` r

ponto_critico(rp)
```

## 5. Produzir a figura

``` r

plot_reg(rp)
```

# Delineamento qualitativo e médias ajustadas

``` r

dq <- transform(dados, dose_f = factor(dose))
m <- lm(produtividade ~ bloco + dose_f, data = dq)

anova_agri(m)
cmp <- comparar_emmeans(m, ~ dose_f, method = "pairwise", adjust = "tukey")
plot_emmeans(cmp, data = dq, x = dose_f, y = produtividade)
```

# Contrastes polinomiais com doses reais

``` r

emm <- emmeans::emmeans(m, ~ dose_f)
cp <- contraste_poly(emm, scores = c(0, 50, 100, 150, 200), degree = 2)
cp
```

Para doses desigualmente espaçadas,
[`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md)
usa `opoly` quando `normalized = TRUE`, preservando os valores
quantitativos informados em `scores`.

# Próximas vinhetas

Consulte as vinhetas temáticas para exemplos mais extensos:

1.  delineamento, descrição e ANOVA;
2.  médias marginais e contrastes;
3.  regressão quantitativa;
4.  diagnóstico, modelos mistos e contagens;
5.  PCA;
6.  Bayes e produtividade;
7.  gráficos e exportação.

------------------------------------------------------------------------

``` r

knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
set.seed(2026)
```

# Dados didáticos

``` r

dados_dbc <- expand.grid(
  bloco = factor(1:5),
  tratamento = factor(c("Controle", "A", "B", "C"))
)
dados_dbc$produtividade <- 42 +
  c(0, 5, 9, 7)[dados_dbc$tratamento] +
  rep(c(-2, 1, 0, 2, -1), each = 4) +
  rnorm(nrow(dados_dbc), 0, 2)
```

# `auditar_delineamento()`

A auditoria é realizada antes do ajuste. Ela descreve níveis,
combinações previstas, células ausentes, respostas ausentes,
balanceamento e, quando `unidade` é informada, duplicação do
identificador da unidade experimental.

## Exemplo 1: DBC completo

``` r

aud1 <- auditar_delineamento(
  dados_dbc,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud1
```

## Exemplo 2: tratamento ausente em um bloco

``` r

dados_incompletos <- dados_dbc[-7, ]
aud2 <- auditar_delineamento(
  dados_incompletos,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud2$celulas_ausentes
```

## Exemplo 3: fatorial com fatores adicionais

``` r

fat <- expand.grid(
  bloco = factor(1:4),
  salinidade = factor(c("0.5", "3.0")),
  plantas = factor(c("1", "2")),
  porta_enxerto = factor(c("A", "B", "C"))
)
fat$y <- rnorm(nrow(fat), 20, 3)

auditar_delineamento(
  fat,
  tratamento = salinidade,
  bloco = bloco,
  fatores = c(plantas, porta_enxerto),
  resposta = y
)
```

# `resumo_agri()`

A função retorna `n`, total de linhas, ausências, média, desvio-padrão,
erro-padrão, intervalo de confiança, mediana, quartis, extremos e CV
descritivo.

## Exemplo 1: por tratamento

``` r

resumo_agri(dados_dbc, produtividade, tratamento)
```

## Exemplo 2: por tratamento e bloco

``` r

resumo_agri(dados_dbc, produtividade, tratamento, bloco)
```

## Exemplo 3: intervalo de 90%

``` r

resumo_agri(dados_dbc, produtividade, tratamento, conf.level = 0.90)
```

O CV é apresentado como descrição e não como critério universal de
qualidade. Respostas de contagem, proporções ou médias próximas de zero
requerem interpretação específica.

# `anova_agri()`

``` r

mod_dbc <- lm(produtividade ~ tratamento + bloco, data = dados_dbc)
```

## Exemplo 1: DBC

``` r

anova_agri(mod_dbc)
```

## Exemplo 2: interação fatorial

``` r

m2 <- lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
anova_agri(m2, effect_size = "eta2")
```

## Exemplo 3: sem CV

``` r

anova_agri(
  lm(weight ~ group, data = PlantGrowth),
  cv = FALSE,
  effect_size = "eta2_partial"
)
```

Quando `effectsize` está instalado, os tamanhos de efeito são obtidos
diretamente por esse pacote. Na ausência dele, `myfuns` consegue
calcular eta² parcial básico para modelos `lm`, mas sem intervalo de
confiança.

# Fluxo recomendado

``` r

auditar_delineamento(dados_dbc, tratamento, bloco, resposta = produtividade)
resumo_agri(dados_dbc, produtividade, tratamento)
anova_agri(mod_dbc)
```

A sequência reduz o risco de interpretar uma ANOVA sem ter verificado
previamente a estrutura do banco.

------------------------------------------------------------------------

# Preparação

``` r

dados <- data.frame(
  trat = factor(rep(c("A", "B", "C", "D"), each = 5)),
  bloco = factor(rep(1:5, times = 4)),
  altura = c(30,31,29,32,30, 35,34,36,35,34, 40,39,41,42,40, 38,37,39,38,40),
  massa = c(10,11,10,9,10, 12,13,12,12,11, 16,15,17,16,16, 14,15,14,13,14)
)
m_altura <- lm(altura ~ bloco + trat, data = dados)
m_massa <- lm(massa ~ bloco + trat, data = dados)
mods <- list(altura = m_altura, massa = m_massa)
```

# `emmeans_lista()`

## Exemplo 1: duas respostas

``` r

lista_emm <- emmeans_lista(mods, ~ trat)
lista_emm
```

## Exemplo 2: selecionar um modelo

``` r

emmeans_lista(mods, ~ trat, which = 2)
```

## Exemplo 3: GLM na escala de resposta

``` r

mp <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
emmeans_lista(list(quebras = mp), ~ tension | wool, type = "response")
```

# `contrast_lista()`

## Exemplo 1: Tukey

``` r

contrast_lista(lista_emm, method = "pairwise", adjust = "tukey")
```

## Exemplo 2: tratamento versus controle

``` r

contrast_lista(lista_emm, method = "trt.vs.ctrl", ref = 1, adjust = "dunnettx")
```

## Exemplo 3: contraste planejado

``` r

coef <- list("A vs demais" = c(-3, 1, 1, 1))
contrast_lista(lista_emm, method = coef, adjust = "none")
```

# `cld_lista()`

As letras são uma forma compacta de apresentar comparações, mas não
devem ser interpretadas como prova de igualdade.

## Exemplo 1

``` r

cld_lista(lista_emm, adjust = "tukey")
```

## Exemplo 2

``` r

cld_lista(lista_emm, which = 1, adjust = "tukey")
```

## Exemplo 3: margem de equivalência definida pelo pesquisador

``` r

cld_lista(lista_emm, adjust = "tukey", delta = 1.0)
```

# `comparar_emmeans()`

A função conserva o `emmGrid` e reúne tabela de médias, intervalos e
contrastes.

## Exemplo 1: Tukey

``` r

cmp1 <- comparar_emmeans(m_altura, ~ trat, method = "pairwise", adjust = "tukey")
cmp1
```

## Exemplo 2: Dunnett

``` r

cmp2 <- comparar_emmeans(
  m_altura,
  ~ trat,
  method = "trt.vs.ctrl",
  adjust = "dunnettx",
  ref = 1
)
cmp2$contrastes
```

## Exemplo 3: comparações simples em interação

``` r

m_int <- lm(breaks ~ wool * tension, data = warpbreaks)
cmp3 <- comparar_emmeans(m_int, ~ tension | wool, method = "pairwise", adjust = "tukey")
cmp3$estimativas
```

# `plot_emmeans()`

## Exemplo 1: EMMs e IC

``` r

plot_emmeans(cmp1)
```

## Exemplo 2: dados observados e EMMs

``` r

plot_emmeans(cmp1, data = dados, x = trat, y = altura)
```

## Exemplo 3: interação

``` r

plot_emmeans(cmp3, data = warpbreaks, x = tension, y = breaks)
```

# `contraste_poly()`

Esta função foi criada para reduzir um problema frequente em ensaios
quantitativos: contrastes polinomiais construídos apenas pela ordem dos
níveis podem não representar a escala real quando o espaçamento entre
doses é irregular.

## Exemplo 1: níveis igualmente espaçados

``` r

d1 <- data.frame(dose = factor(rep(c(0, 50, 100, 150), each = 4)), y = 1:16)
m1 <- lm(y ~ dose, data = d1)
em1 <- emmeans::emmeans(m1, ~ dose)
contraste_poly(em1, scores = c(0, 50, 100, 150))
```

## Exemplo 2: níveis desigualmente espaçados

``` r

d2 <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = 1:16)
m2 <- lm(y ~ dose, data = d2)
em2 <- emmeans::emmeans(m2, ~ dose)
cp2 <- contraste_poly(em2, scores = c(0, 25, 100, 200))
cp2$scores
cp2$igualmente_espacados
```

## Exemplo 3: limitar ao quadrático

``` r

contraste_poly(em1, scores = c(0, 50, 100, 150), degree = 2)
```

`normalized = TRUE` usa `opoly`. `normalized = FALSE` só é aceito quando
os escores são igualmente espaçados.

------------------------------------------------------------------------

``` r

knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
set.seed(2026)
```

# Dados

``` r

dados <- expand.grid(
  bloco = factor(1:5),
  dose = c(0, 50, 100, 150, 200)
)
dados$y <- with(
  dados,
  25 + 0.18 * dose - 0.00060 * dose^2 +
    rep(c(-1.5, 0, 1.2, -0.8, 0.5), each = 5) +
    rnorm(nrow(dados), 0, 1.8)
)
```

# `reg_poly()`

A função ajusta todos os graus solicitados e mantém todos os modelos.
Quando há vários graus, o modelo de maior grau é armazenado em `$model`
apenas para gerar predições e gráficos; isso não significa que ele tenha
sido selecionado como superior.

## Exemplo 1: linear e quadrático

``` r

rp1 <- reg_poly(dados, y, dose, degree = 1:2)
rp1
```

## Exemplo 2: quadrático previamente definido

``` r

rp2 <- reg_poly(dados, y, dose, degree = 2, compare = FALSE)
rp2$coeficientes$grau2
```

## Exemplo 3: explorar até cúbico

``` r

rp3 <- reg_poly(dados, y, dose, degree = 1:3)
rp3$comparacao
rp3$falta_ajuste
```

# Teste de falta de ajuste

Quando há replicação em níveis de `x`,
[`reg_poly()`](https://wep69.github.io/myfuns/reference/reg_poly.md)
compara cada polinômio com um modelo que trata `x` como fator. O
resultado ajuda a avaliar se a forma polinomial deixa estrutura
sistemática sem explicar.

# `ponto_critico()`

## Exemplo 1: máximo quadrático

``` r

mq <- lm(y ~ dose + I(dose^2), data = dados)
ponto_critico(mq, range = range(dados$dose))
```

## Exemplo 2: checar extrapolação

``` r

ponto_critico(mq, range = c(0, 100))
```

## Exemplo 3: diretamente do `reg_poly()`

``` r

ponto_critico(rp2)
```

O intervalo da posição do ponto quadrático é aproximado pelo método
delta. Pontos fora do intervalo experimental são explicitamente marcados
como extrapolação.

# `plot_reg()`

## Exemplo 1: curva, dados, médias e IC

``` r

plot_reg(rp2)
```

## Exemplo 2: controlar dados e variáveis

``` r

plot_reg(rp2, data = dados, x = dose, y = y, show_raw = TRUE, show_means = TRUE)
```

## Exemplo 3: sem equação

``` r

plot_reg(rp2, equation = FALSE)
```

# `equar2()` e contrastes polinomiais

[`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md)
continua disponível para o fluxo histórico que usa médias por dose e os
p-valores dos contrastes linear e quadrático.

``` r

dados$dose_f <- factor(dados$dose)
mod_f <- lm(y ~ bloco + dose_f, data = dados)
emm <- emmeans::emmeans(mod_f, ~ dose_f)
cp <- contraste_poly(emm, scores = c(0, 50, 100, 150, 200), degree = 2)
medias <- aggregate(y ~ dose, data = dados, FUN = mean)
```

## Exemplo 1

``` r

equar2(medias, cp)
```

## Exemplo 2: retorno detalhado

``` r

eq2 <- equar2(medias, cp, details = TRUE)
eq2$equation
eq2$p_values
```

## Exemplo 3: R² na escala 0 a 1

``` r

equar2(medias, cp, r2_percent = FALSE, digits = c(2, 4, 5, 3))
```

A equação de
[`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md) é
ajustada às médias fornecidas. Portanto, o R² mostrado descreve a
regressão dessas médias, não o ajuste às unidades experimentais
individuais.

------------------------------------------------------------------------

# Princípio geral

Diagnóstico não deve ser reduzido a um teste de normalidade ou a um
único valor de p. As funções desta vinheta organizam evidências e
preservam os objetos originais para inspeção detalhada.

# `diagnostico_modelo()`

## Exemplo 1: modelo linear

``` r

m1 <- lm(weight ~ group, data = PlantGrowth)
d1 <- diagnostico_modelo(m1, plot = FALSE)
d1$informacoes
```

## Exemplo 2: Poisson

``` r

mp <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
d2 <- diagnostico_modelo(mp, simulations = 300, plot = FALSE)
d2$verificacoes
```

## Exemplo 3: `glmmTMB`

``` r

mnb <- glmmTMB::glmmTMB(
  breaks ~ wool * tension,
  family = glmmTMB::nbinom2,
  data = warpbreaks
)
diagnostico_modelo(mnb, simulations = 1000, plot = TRUE)
```

Quando `performance` está instalado, a função agrega verificações de
heterocedasticidade, colinearidade, observações influentes, dispersão,
zeros, convergência e singularidade conforme a classe do modelo. Para
`glm`, `glmerMod` e `glmmTMB`, se `DHARMa` estiver disponível,
`simulations` controla o número de simulações usadas para produzir
resíduos escalonados e verificações complementares de uniformidade,
dispersão e observações discrepantes.

# `resumo_misto()`

## Exemplo 1: intercepto aleatório

``` r

mri <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
resumo_misto(mri)
```

## Exemplo 2: intercepto e inclinação aleatórios

``` r

mrs <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
resumo_misto(mrs)
```

## Exemplo 3: GLMM binomial e exponenciação

``` r

mg <- lme4::glmer(
  cbind(incidence, size - incidence) ~ period + (1 | herd),
  family = binomial,
  data = lme4::cbpp
)
resumo_misto(mg, exponentiate = TRUE)
```

A saída reúne efeitos fixos, ICs de Wald, componentes aleatórios e, com
`performance`, medidas como ICC e R² marginal/condicional, além das
verificações de convergência e singularidade.

# `diagnostico_contagem()`

## Exemplo 1: Poisson

``` r

dc1 <- diagnostico_contagem(mp, simulations = 300)
dc1$descritivo
dc1$dispersao_pearson
```

## Exemplo 2: binomial negativa

``` r

mnb2 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
diagnostico_contagem(mnb2, simulations = 500)
```

## Exemplo 3: modelo com componente de zeros

``` r

mzi <- glmmTMB::glmmTMB(
  breaks ~ tension,
  ziformula = ~ 1,
  family = glmmTMB::nbinom2,
  data = warpbreaks
)
diagnostico_contagem(mzi, simulations = 1000)
```

Se `DHARMa` estiver instalado, são armazenados resíduos simulados e
testes de dispersão, zeros e observações discrepantes. A função nunca
muda a família do modelo automaticamente.

# `comparar_modelos()`

``` r

set.seed(10)
d <- data.frame(x = rep(0:4, each = 5))
d$y <- 4 + 1.2 * d$x - 0.15 * d$x^2 + rnorm(nrow(d))
ml <- lm(y ~ x, data = d)
mq <- lm(y ~ x + I(x^2), data = d)
```

## Exemplo 1: linear versus quadrático

``` r

comparar_modelos(linear = ml, quadratico = mq)
```

## Exemplo 2: Poisson versus binomial negativa

``` r

mp2 <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
mnb3 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
comparar_modelos(poisson = mp2, negbin = mnb3)
```

## Exemplo 3: métricas específicas

``` r

comparar_modelos(
  linear = ml,
  quadratico = mq,
  metrics = c("AICc", "BIC", "RMSE"),
  rank_by = "AICc"
)
```

A ordenação por uma métrica é somente uma forma de organizar a tabela. A
escolha final deve considerar comparabilidade, delineamento,
diagnóstico, interpretação e finalidade do modelo.

------------------------------------------------------------------------

# `pca_agri()`

A função utiliza
[`stats::prcomp()`](https://rdrr.io/r/stats/prcomp.html) e mantém o
objeto original. Ela não remove linhas com dados ausentes e interrompe o
ajuste quando encontra variáveis sem variabilidade.

## Exemplo 1: PCA padronizada com grupo

``` r

pca1 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  group = Species
)
pca1
```

## Exemplo 2: sem padronização

``` r

pca2 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  scale = FALSE
)
pca2$variancia
```

## Exemplo 3: limitar componentes reportados

``` r

pca3 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  ncomp = 3
)
pca3$contribuicao
```

# Componentes da saída

``` r

head(pca1$escores)
pca1$cargas
pca1$variancia
pca1$contribuicao
```

# `plot_pca_agri()`

## Exemplo 1: biplot

``` r

plot_pca_agri(pca1, type = "biplot")
```

## Exemplo 2: escores com elipses

``` r

plot_pca_agri(pca1, type = "scores", ellipse = TRUE)
```

## Exemplo 3: cargas PC1 × PC3

``` r

plot_pca_agri(pca3, axes = c(1, 3), type = "loadings", labels = TRUE)
```

# Interpretação

A variância explicada informa quanto da variabilidade total é
representado por cada componente. As cargas indicam associação entre
variáveis originais e componentes. A interpretação deve levar em conta a
escala das variáveis e a decisão de padronizar ou não o conjunto.

------------------------------------------------------------------------

# `resumo_bayes()`

A função é uma camada sobre
[`bayestestR::describe_posterior()`](https://easystats.github.io/bayestestR/reference/describe_posterior.html).
Ela mantém o foco em estimativa posterior, intervalo de credibilidade e
diagnósticos. ROPE só é calculada quando seus limites são explicitamente
informados.

## Exemplo 1: amostras posteriores simples

``` r

if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(1)
  resumo_bayes(rnorm(3000, 0.4, 0.2), diagnostics = FALSE)
}
```

## Exemplo 2: ROPE definida pelo pesquisador

``` r

if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(2)
  resumo_bayes(
    rnorm(3000, 0.05, 0.15),
    diagnostics = FALSE,
    rope = c(-0.10, 0.10)
  )
}
```

## Exemplo 3: modelo `brms`

``` r

fit <- brms::brm(
  mpg ~ wt,
  data = mtcars,
  family = gaussian(),
  chains = 4,
  iter = 2000,
  seed = 123
)
resumo_bayes(fit, ci = 0.95, ci_method = "hdi")
```

# `export_figuras()`

``` r

p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_nogrid()
p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() + theme_nogrid()
```

## Exemplo 1: PNG

``` r

export_figuras(
  list(fig_mtcars = p1, fig_iris = p2),
  dir = "figuras",
  formats = "png"
)
```

## Exemplo 2: TIFF de alta resolução

``` r

export_figuras(
  list(fig_mtcars = p1, fig_iris = p2),
  dir = "figuras_tiff",
  formats = "tiff",
  dpi = 600
)
```

## Exemplo 3: transparência e SVG

``` r

export_figuras(
  list(fig_mtcars = p1 + trans, fig_iris = p2 + trans),
  dir = "figuras_transparentes",
  formats = c("png", "svg"),
  bg = "transparent"
)
```

# `read_clipboard_table()`

A função usa a área de transferência nativa do Windows.

## Exemplo 1

``` r

dados <- read_clipboard_table()
```

## Exemplo 2

``` r

dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA"))
```

## Exemplo 3

``` r

dados <- read_clipboard_table(header = FALSE)
```

[`read_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
permanece como alias histórico para não quebrar scripts antigos.

# `write_clipboard_table()`

## Exemplo 1

``` r

write_clipboard_table(head(iris))
```

## Exemplo 2

``` r

write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean))
```

## Exemplo 3

``` r

write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE)
```

[`write_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
também permanece como alias histórico.

------------------------------------------------------------------------

# Temas

``` r

p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point(size = 2.5) +
  ggplot2::labs(x = "Peso", y = "Consumo")
```

## `theme_nogrid()`

``` r

p + theme_nogrid()
```

## `theme_nogridacp()`

``` r

p + theme_nogridacp()
```

## `theme_transparent()` e `trans`

``` r

p + trans
```

``` r

theme_transparent()
```

# `ExportTimes()`

A função exporta uma figura individual. Os padrões históricos são 20 ×
15 cm e 600 dpi para os formatos raster, mas todos esses valores podem
ser alterados.

## Exemplo 1: PNG e SVG

``` r

ExportTimes(
  p + theme_nogrid(),
  "figuras/Figura_1",
  formats = c("png", "svg")
)
```

## Exemplo 2: TIFF

``` r

ExportTimes(
  p + theme_nogrid(),
  "figuras/Figura_1",
  formats = "tiff",
  compression = "lzw"
)
```

## Exemplo 3: fundo transparente

``` r

ExportTimes(
  p + trans,
  "figuras/Figura_transparente",
  formats = c("png", "svg"),
  bg = "transparent"
)
```

# `export_figuras()`

A função aplica
[`ExportTimes()`](https://wep69.github.io/myfuns/reference/ExportTimes.md)
a uma lista nomeada.

``` r

p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() + theme_nogrid()
```

## Exemplo 1

``` r

export_figuras(list(fig1 = p, fig2 = p2), "figuras", formats = "png")
```

## Exemplo 2

``` r

export_figuras(list(fig1 = p, fig2 = p2), "figuras", formats = c("png", "tiff", "svg"))
```

## Exemplo 3

``` r

export_figuras(
  list(fig1 = p + trans, fig2 = p2 + trans),
  "figuras_transparentes",
  formats = c("png", "svg"),
  bg = "transparent"
)
```

# Recomendações de uso

Para variáveis contínuas, prefira mostrar observações ou distribuição
juntamente com estimativas e incerteza.
[`plot_emmeans()`](https://wep69.github.io/myfuns/reference/plot_emmeans.md)
e [`plot_reg()`](https://wep69.github.io/myfuns/reference/plot_reg.md)
foram adicionadas justamente para facilitar esse padrão de apresentação.
