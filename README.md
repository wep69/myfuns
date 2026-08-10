# myfuns 0.5.0

`myfuns` reúne funções auxiliares para análise estatística aplicada à experimentação agrícola e preparação de resultados científicos em R.

## Estrutura do repositório

```
myfuns/
├── R/                  # Código-fonte das 15 funções do pacote
│   ├── anova-emmeans.R #   ANOVA organizada + médias marginais (anova_agri, emmeans_lista, comparar_emmeans, plot_emmeans)
│   ├── anovaCV.R       #   Coeficiente de variação (anovaCV)
│   ├── regressao.R     #   Regressão polinomial (reg_poly, ponto_critico, plot_reg, contraste_poly)
│   ├── equar2.R        #   Coeficiente de determinação para equações (equar2)
│   ├── pca.R           #   Análise de componentes principais (pca_agri, plot_pca_agri)
│   ├── diagnosticos-modelos.R # Diagnóstico orientado por classe (diagnostico_modelo, diagnostico_contagem, comparar_modelos)
│   ├── resumo_misto.R  #   (resumo_misto — merMod/glmmTMB)
│   ├── delineamento-resumo.R # Auditoria de delineamento + resumo agronômico
│   ├── plots-estatisticos.R  # Gráficos de médias marginais
│   ├── bayes-export-clipboard.R # Resumo bayesiano + exportação de figuras
│   ├── clipboard.R     #   Leitura/escrita de área de transferência
│   ├── themes.R        #   Temas ggplot2 (theme_nogrid, theme_transparent)
│   ├── ExportTimes.R   #   Exportação de figuras em múltiplos formatos
│   ├── list_helpers.R  #   Utilitários de listas
│   └── 00-utils.R      #   Funções auxiliares internas
├── man/                # Documentação Rd gerada por roxygen2 (27 páginas)
├── tests/              # Testes unitários com testthat (11 arquivos)
├── vignettes/          # 8 vinhetas temáticas com exemplos completos
│   ├── introducao-myfuns.Rmd        # Visão geral do pacote
│   ├── delineamento-anova.Rmd       # ANOVA e delineamento experimental
│   ├── emmeans-contrastes.Rmd       # Médias marginais e contrastes
│   ├── regressao-equar2.Rmd         # Regressão polinomial e R²
│   ├── diagnostico-modelos.Rmd      # Diagnóstico de modelos
│   ├── graficos-publicacao.Rmd      # Gráficos para publicação
│   ├── pca-agri.Rmd                 # Análise de componentes principais
│   └── bayes-produtividade.Rmd      # Análise bayesiana
├── inst/doc/           # Vinhetas pré-compiladas (HTML) + scripts R extraídos
├── DESCRIPTION         # Metadados do pacote (versão, dependências, licença)
├── NAMESPACE           # Exportações e importações
├── LICENSE             # Licença (sem escolha formal ainda)
└── NEWS.md             # Histórico de versões
```

## O que há na versão 0.5.0

A versão 0.5.0 preserva as funções históricas e implementa vinte funções novas:

- **delineamento e descrição:** `auditar_delineamento()`, `resumo_agri()`, `anova_agri()`;
- **médias e contrastes:** `emmeans_lista()`, `comparar_emmeans()`, `contraste_poly()`;
- **regressão quantitativa:** `reg_poly()`, `ponto_critico()`, `plot_reg()`;
- **estimativas ajustadas:** `plot_emmeans()`;
- **diagnóstico e modelos:** `diagnostico_modelo()`, `resumo_misto()`, `diagnostico_contagem()`, `comparar_modelos()`;
- **multivariada:** `pca_agri()`, `plot_pca_agri()`;
- **Bayes:** `resumo_bayes()`;
- **produtividade:** `export_figuras()`, `read_clipboard_table()`, `write_clipboard_table()`.

As funções históricas `anovaCV()`, `equar2()`, `contrast_lista()`, `cld_lista()`, `theme_nogrid()`, `theme_nogridacp()`, `theme_transparent()`, `trans`, `ExportTimes()`, `read_excel()` e `write_excel()` continuam disponíveis.

## Filosofia

O pacote organiza tarefas repetitivas, mas não automatiza decisões científicas críticas. Comparações de modelos são apresentadas como evidência, não como seleção automática. Ausências não são removidas silenciosamente em regressão e PCA. ROPE bayesiana só é calculada quando o pesquisador define seus limites.

## Exemplo rápido

```r
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

O núcleo usa dependências pequenas. Recursos avançados são opcionais e ativados quando os pacotes correspondentes estão instalados: `effectsize`, `performance`, `DHARMa`, `lme4`, `glmmTMB`, `MASS`, `bayestestR` e `brms`.

## Documentação

- `vignettes/`: 8 vinhetas temáticas com fluxos completos;
- `man/`: ajuda individual das 27 funções exportadas;
- `NEWS.md`: histórico das versões.

## Instalação a partir do código-fonte

```r
install.packages("myfuns_0.5.0.tar.gz", repos = NULL, type = "source")
library(myfuns)
```

## Instalação pelo GitHub

```r
# Com vignettes
devtools::install_github("wep69/myfuns")

# Sem vignettes
devtools::install_github("wep69/myfuns", build_vignettes = FALSE)
```
