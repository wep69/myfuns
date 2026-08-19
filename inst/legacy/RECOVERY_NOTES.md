# Notas de recuperacao da versao 0.1.0

O arquivo original recebido continha uma instalacao Windows ja compilada, e nao o codigo-fonte do pacote. O `DESCRIPTION` registrava:

- pacote `myfuns`;
- versao `0.1.0`;
- construcao com R 4.0.0;
- data de construcao 2020-05-11;
- `NAMESPACE` com `exportPattern("^[[:alpha:]]+")`.

Os nomes exportados foram recuperados do indice `lazyLoad`:

- `ExportTimes`
- `anovaCV`
- `cld_lista`
- `read_excel`
- `theme_nogrid`
- `theme_nogridacp`
- `write_excel`

Detalhes recuperados do bytecode e preservados na reimplementacao:

- `cld_lista(object, ..., which = seq_along(object))` aplicava `lapply(..., multcomp::cld, ...)`.
- `read_excel(header = TRUE, ...)` usava `read.table("clipboard", sep = "\t", ...)`.
- `write_excel(x, row.names = FALSE, col.names = TRUE, ...)` usava `write.table("clipboard", sep = "\t", ...)`.
- `theme_nogrid(base_size = 12, base_family = "")` tinha eixos pretos com espessura 0.7.
- `theme_nogridacp(base_size = 12, base_family = "")` tinha borda preta com espessura 1.5 e `fill = NA`.
- `ExportTimes(gplot, filename)` gerava PNG e TIFF a 20 x 15 cm e 600 dpi, familia Times New Roman; SVG a 9 x 8 polegadas; e EMF via `R.devices::toEMF()` com `aspectRatio = 0.8` e `scale = 3`.
- `anovaCV(x)` usava `sjstats::cv(x) * 100` e arredondamento de uma casa decimal, retornando uma lista nomeada `Anova` e `CV`.

A versao 0.2.0 preserva a finalidade dessas rotinas, mas torna parametros importantes configuraveis e elimina chamadas `library()` dentro das funcoes.
