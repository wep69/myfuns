# Changelog

## myfuns 0.5.0

### Novas funções

Foram implementadas vinte funções planejadas para ampliar o pacote:

- [`auditar_delineamento()`](https://wep69.github.io/myfuns/reference/auditar_delineamento.md);
- [`resumo_agri()`](https://wep69.github.io/myfuns/reference/resumo_agri.md);
- [`anova_agri()`](https://wep69.github.io/myfuns/reference/anova_agri.md);
- [`emmeans_lista()`](https://wep69.github.io/myfuns/reference/emmeans_lista.md);
- [`comparar_emmeans()`](https://wep69.github.io/myfuns/reference/comparar_emmeans.md);
- [`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md);
- [`reg_poly()`](https://wep69.github.io/myfuns/reference/reg_poly.md);
- [`ponto_critico()`](https://wep69.github.io/myfuns/reference/ponto_critico.md);
- [`plot_emmeans()`](https://wep69.github.io/myfuns/reference/plot_emmeans.md);
- [`plot_reg()`](https://wep69.github.io/myfuns/reference/plot_reg.md);
- [`diagnostico_modelo()`](https://wep69.github.io/myfuns/reference/diagnostico_modelo.md);
- [`resumo_misto()`](https://wep69.github.io/myfuns/reference/resumo_misto.md);
- [`diagnostico_contagem()`](https://wep69.github.io/myfuns/reference/diagnostico_contagem.md);
- [`comparar_modelos()`](https://wep69.github.io/myfuns/reference/comparar_modelos.md);
- [`pca_agri()`](https://wep69.github.io/myfuns/reference/pca_agri.md);
- [`plot_pca_agri()`](https://wep69.github.io/myfuns/reference/plot_pca_agri.md);
- [`resumo_bayes()`](https://wep69.github.io/myfuns/reference/resumo_bayes.md);
- [`export_figuras()`](https://wep69.github.io/myfuns/reference/export_figuras.md);
- [`read_clipboard_table()`](https://wep69.github.io/myfuns/reference/read_clipboard_table.md);
- [`write_clipboard_table()`](https://wep69.github.io/myfuns/reference/write_clipboard_table.md).

### Melhorias metodológicas

- [`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md)
  usa os valores reais dos níveis quantitativos com `opoly` quando
  apropriado.
- [`reg_poly()`](https://wep69.github.io/myfuns/reference/reg_poly.md)
  preserva todos os graus solicitados e não seleciona automaticamente um
  modelo.
- [`pca_agri()`](https://wep69.github.io/myfuns/reference/pca_agri.md)
  não remove valores ausentes silenciosamente.
- [`comparar_modelos()`](https://wep69.github.io/myfuns/reference/comparar_modelos.md)
  verifica resposta, observações utilizadas e situações de REML
  potencialmente não comparáveis.
- [`resumo_bayes()`](https://wep69.github.io/myfuns/reference/resumo_bayes.md)
  só calcula ROPE quando a margem é definida pelo pesquisador.
- diagnósticos avançados são integrados a `performance` e `DHARMa`
  quando disponíveis.

### Documentação

- todas as novas funções possuem documentação em português;
- todas possuem pelo menos três exemplos de uso;
- foram criadas vinhetas temáticas para delineamento, `emmeans`,
  regressão, diagnóstico, PCA, Bayes e figuras;
- `MANUAL.md` foi ampliado como referência integrada.

## myfuns 0.2.0

- Reconstrução do pacote histórico de 2020 como pacote-fonte.
- Inclusão de
  [`equar2()`](https://wep69.github.io/myfuns/reference/equar2.md),
  [`contrast_lista()`](https://wep69.github.io/myfuns/reference/list_helpers.md)
  e tema transparente `trans`.
- Modernização de temas e exportação de figuras.
