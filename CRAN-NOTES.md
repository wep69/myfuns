# Notas para validação e eventual submissão ao CRAN

A versão 0.5.0 está organizada como pacote-fonte e documentada
integralmente em português. Antes de eventual distribuição pública ou
submissão ao CRAN:

1.  escolher e declarar uma licença de distribuição;
2.  executar `roxygen2::roxygenise()` para regenerar `NAMESPACE` e
    `man/` a partir dos comentários `roxygen2`;
3.  executar
    [`testthat::test_local()`](https://testthat.r-lib.org/reference/test_package.html);
4.  executar `R CMD build` e `R CMD check --as-cran`, ou
    `rcmdcheck::rcmdcheck(args = "--as-cran")`;
5.  renderizar todas as vinhetas e confirmar que os exemplos
    condicionais se comportam corretamente com as dependências opcionais
    instaladas;
6.  revisar no Windows as funções de área de transferência e, quando
    necessário, a exportação EMF;
7.  confirmar a disponibilidade da família tipográfica escolhida nas
    máquinas usadas para exportação gráfica.

## Validação realizada nesta reconstrução

O ambiente utilizado para reconstruir o pacote não contém executável R.
Por isso, foram realizadas verificações estruturais e estáticas de
código, documentação, exportações, exemplos e arquivos do pacote, mas
não foi possível executar `R CMD check`, os testes `testthat` ou as
vinhetas em R. Essa limitação deve ser resolvida antes de uma
distribuição pública.
