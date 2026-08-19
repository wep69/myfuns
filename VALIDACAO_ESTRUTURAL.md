# Validação estrutural do myfuns 0.5.0

Data da reconstrução: 10 de agosto de 2026.

## Verificações realizadas

Delimitadores de código R e testes

Todos os exports possuem objeto definido

Todos os métodos S3 estão definidos

Todos os exports possuem alias em man

Chaves balanceadas nos arquivos Rd

Namespaces externos declarados em DESCRIPTION

20 novas funções possuem arquivo Rd

20 novas funções possuem pelo menos três exemplos no Rd

20 novas funções aparecem pelo menos três vezes nas vinhetas

Todas as vinhetas estão listadas no pkgdown

Versão declarada como 0.5.0

Dependência emmeans exige versão com opoly

Sem marcadores TODO/FIXME ou nome provisório

Sem travessão tipográfico em documentação principal

## Limitação do ambiente

O ambiente de reconstrução não possui executável R. Portanto, não foi
possível executar `R CMD check`, `R CMD build`, os testes `testthat` nem
renderizar as vinhetas. Os arquivos de teste foram incluídos e validados
estaticamente, mas precisam ser executados em uma instalação de R antes
de distribuição pública.

## Comandos recomendados para validação final em R

``` r

roxygen2::roxygenise()
testthat::test_local()
rmarkdown::render_site() # ou renderização individual das vinhetas
```

No terminal:

``` text
R CMD build myfuns
R CMD check --as-cran myfuns_0.5.0.tar.gz
```
