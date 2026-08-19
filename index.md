# myfuns 0.5.0

`myfuns` reúne funções auxiliares para análise estatística aplicada à
experimentação agrícola e preparação de resultados científicos em R.

## O que há na versão 0.5.0

A versão 0.5.0 preserva as funções históricas e implementa vinte funções
novas:

- **delineamento e descrição:**
  [`auditar_delineamento()`](https://wep69.github.io/myfuns/reference/auditar_delineamento.md),
  [`resumo_agri()`](https://wep69.github.io/myfuns/reference/resumo_agri.md),
  [`anova_agri()`](https://wep69.github.io/myfuns/reference/anova_agri.md);
- **médias e contrastes:**
  [`emmeans_lista()`](https://wep69.github.io/myfuns/reference/emmeans_lista.md),
  [`comparar_emmeans()`](https://wep69.github.io/myfuns/reference/comparar_emmeans.md),
  [`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md);
- **regressão quantitativa:**
  [`reg_poly()`](https://wep69.github.io/myfuns/reference/reg_poly.md),
  [`ponto_critico()`](https://wep69.github.io/myfuns/reference/ponto_critico.md),
  [`plot_reg()`](https://wep69.github.io/myfuns/reference/plot_reg.md);
- **estimativas ajustadas:**
  [`plot_emmeans()`](https://wep69.github.io/myfuns/reference/plot_emmeans.md);
- **diagnóstico e modelos:**
  [`diagnostico_modelo()`](https://wep69.github.io/myfuns/reference/diagnostico_modelo.md),
  [`resumo_misto()`](https://wep69.github.io/myfuns/reference/resumo_misto.md),
  [`diagnostico_contagem()`](https://wep69.github.io/myfuns/reference/diagnostico_contagem.md),
  [`comparar_modelos()`](https://wep69.github.io/myfuns/reference/comparar_modelos.md);
- **multivariada:**
  [`pca_agri()`](https://wep69.github.io/myfuns/reference/pca_agri.md),
  [`plot_pca_agri()`](https://wep69.github.io/myfuns/reference/plot_pca_agri.md);
- **Bayes:**
  [`resumo_bayes()`](https://wep69.github.io/myfuns/reference/resumo_bayes.md);
- **produtividade:**
  [`export_figuras()`](https://wep69.github.io/myfuns/reference/export_figuras.md),
  [`read_clipboard_table()`](https://wep69.github.io/myfuns/reference/read_clipboard_table.md),
  [`write_clipboard_table()`](https://wep69.github.io/myfuns/reference/write_clipboard_table.md).

As funções históricas
[`anovaCV()`](https://wep69.github.io/myfuns/reference/anovaCV.md),
[`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md),
[`contrast_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md),
[`cld_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md),
[`theme_nogrid()`](https://wep69.github.io/myfuns/reference/themes.md),
[`theme_nogridacp()`](https://wep69.github.io/myfuns/reference/themes.md),
[`theme_transparent()`](https://wep69.github.io/myfuns/reference/themes.md),
`trans`,
[`ExportTimes()`](https://wep69.github.io/myfuns/reference/ExportTimes.md),
[`read_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
e
[`write_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
continuam disponíveis.

## Filosofia

O pacote organiza tarefas repetitivas, mas não automatiza decisões
científicas críticas. Comparações de modelos são apresentadas como
evidência, não como seleção automática. Ausências não são removidas
silenciosamente em regressão e PCA. ROPE bayesiana só é calculada quando
o pesquisador define seus limites.

## Exemplo rápido

``` r

set.seed(2026)
dados <- expand.grid(
  bloco = factor(1:4),
  dose = c(0, 50, 100, 150, 200)
)
dados$y <- 20 + 0.18 * dados$dose - 0.0006 * dados$dose^2 +
  rnorm(nrow(dados), 0, 1.5)

auditar_delineamento(dados, tratamento = dose, bloco = bloco, resposta = y)
resumo_agri(dados, y, dose)

rp <- reg_poly(dados, y, dose, degree = 1:2)
ponto_critico(rp)
plot_reg(rp)
```

## Dependências

O núcleo usa dependências pequenas. Recursos avançados são opcionais e
ativados quando os pacotes correspondentes estão instalados:
`effectsize`, `performance`, `DHARMa`, `lme4`, `glmmTMB`, `MASS`,
`bayestestR` e `brms`.

## Documentação

- `MANUAL.md`: manual completo em português;
- `vignettes/`: vinhetas temáticas com fluxos completos;
- `man/`: ajuda individual das funções;
- `NEWS.md`: histórico das versões.

## Instalação a partir do código-fonte

``` r

install.packages("myfuns_0.5.0.tar.gz", repos = NULL, type = "source")
library(myfuns)
```
