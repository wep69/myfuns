# Relatório de modernização do myfuns 0.5.0

## Origem

O arquivo inicial correspondia a uma instalação binária antiga do
`myfuns` 0.1.0 para Windows, construída com R 4.0.0 em 2020. O
código-fonte original não estava organizado em `R/*.R`; as funções
históricas foram recuperadas e reconstruídas como pacote-fonte
documentado.

## Compatibilidade histórica preservada

Permanecem disponíveis
[`ExportTimes()`](https://wep69.github.io/myfuns/reference/ExportTimes.md),
[`anovaCV()`](https://wep69.github.io/myfuns/reference/anovaCV.md),
[`cld_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md),
[`read_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md),
[`theme_nogrid()`](https://wep69.github.io/myfuns/reference/themes.md),
[`theme_nogridacp()`](https://wep69.github.io/myfuns/reference/themes.md),
[`write_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md),
além das funções incorporadas na primeira modernização:
[`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md),
[`contrast_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md),
[`theme_transparent()`](https://wep69.github.io/myfuns/reference/themes.md)
e `trans`.

## Ampliação da versão 0.5.0

Foram implementadas vinte funções adicionais para delineamento
experimental, descrição, ANOVA, `emmeans`, contrastes quantitativos,
regressão polinomial, diagnóstico, modelos mistos, modelos de contagem,
comparação de modelos, PCA, Bayes, exportação em lote e área de
transferência. Todas possuem documentação em português e pelo menos três
exemplos de uso nas páginas de ajuda e nas vinhetas.

## Princípios adotados

- preservar os objetos estatísticos originais para inspeção posterior;
- não excluir observações ou transformar respostas silenciosamente;
- não escolher modelos apenas pelo valor de p ou por um único critério
  de informação;
- explicitar incerteza, domínio experimental e riscos de extrapolação;
- utilizar dependências avançadas apenas quando instaladas;
- separar diagnóstico, estimação, comparação e apresentação gráfica;
- manter compatibilidade com scripts históricos sempre que isso não
  comprometer a clareza metodológica.

## Integrações principais

[`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md)
utiliza os valores reais do fator quantitativo e pode empregar `opoly`
para níveis desigualmente espaçados.
[`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md)
reconhece diretamente esse objeto.
[`diagnostico_modelo()`](https://wep69.github.io/myfuns/reference/diagnostico_modelo.md)
integra verificações do `performance` e resíduos simulados do `DHARMa`
quando disponíveis.
[`resumo_misto()`](https://wep69.github.io/myfuns/reference/resumo_misto.md)
organiza efeitos fixos, componentes aleatórios, ICC e R² quando
suportados.
[`resumo_bayes()`](https://wep69.github.io/myfuns/reference/resumo_bayes.md)
utiliza `bayestestR` e somente calcula ROPE quando os limites são
informados pelo pesquisador.

## Documentação e testes

O pacote contém oito vinhetas temáticas, manual integrado em Markdown,
27 páginas `.Rd`, configuração `pkgdown`, 11 arquivos de testes
`testthat`, `NEWS.md`, `README.md`, notas para validação CRAN e
relatório de validação estrutural.

## Limitação da validação

O ambiente de reconstrução não possui executável R. Por isso,
`R CMD check`, `R CMD build`, a execução dos testes e a renderização
real das vinhetas precisam ser realizadas posteriormente em uma
instalação de R. As verificações estruturais executadas estão
documentadas em `VALIDACAO_ESTRUTURAL.md`.
