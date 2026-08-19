# Validação estrutural do myfuns 0.5.0

Data da reconstrução: 10 de agosto de 2026.

## Verificações realizadas

- [x] Delimitadores de código R e testes
- [x] Todos os exports possuem objeto definido
- [x] Todos os métodos S3 estão definidos
- [x] Todos os exports possuem alias em man
- [x] Chaves balanceadas nos arquivos Rd
- [x] Namespaces externos declarados em DESCRIPTION
- [x] 20 novas funções possuem arquivo Rd
- [x] 20 novas funções possuem pelo menos três exemplos no Rd
- [x] 20 novas funções aparecem pelo menos três vezes nas vinhetas
- [x] Todas as vinhetas estão listadas no pkgdown
- [x] Versão declarada como 0.5.0
- [x] Dependência emmeans exige versão com opoly
- [x] Sem marcadores TODO/FIXME ou nome provisório
- [x] Sem travessão tipográfico em documentação principal

## Limitação do ambiente

O ambiente de reconstrução não possui executável R. Portanto, não foi possível executar `R CMD check`, `R CMD build`, os testes `testthat` nem renderizar as vinhetas. Os arquivos de teste foram incluídos e validados estaticamente, mas precisam ser executados em uma instalação de R antes de distribuição pública.

## Comandos recomendados para validação final em R

```r
roxygen2::roxygenise()
testthat::test_local()
rmarkdown::render_site() # ou renderização individual das vinhetas
```

No terminal:

```text
R CMD build myfuns
R CMD check --as-cran myfuns_0.5.0.tar.gz
```
