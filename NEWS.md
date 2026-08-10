# myfuns 0.5.0

## Novas funções

Foram implementadas vinte funções planejadas para ampliar o pacote:

- `auditar_delineamento()`;
- `resumo_agri()`;
- `anova_agri()`;
- `emmeans_lista()`;
- `comparar_emmeans()`;
- `contraste_poly()`;
- `reg_poly()`;
- `ponto_critico()`;
- `plot_emmeans()`;
- `plot_reg()`;
- `diagnostico_modelo()`;
- `resumo_misto()`;
- `diagnostico_contagem()`;
- `comparar_modelos()`;
- `pca_agri()`;
- `plot_pca_agri()`;
- `resumo_bayes()`;
- `export_figuras()`;
- `read_clipboard_table()`;
- `write_clipboard_table()`.

## Melhorias metodológicas

- `contraste_poly()` usa os valores reais dos níveis quantitativos com `opoly` quando apropriado.
- `reg_poly()` preserva todos os graus solicitados e não seleciona automaticamente um modelo.
- `pca_agri()` não remove valores ausentes silenciosamente.
- `comparar_modelos()` verifica resposta, observações utilizadas e situações de REML potencialmente não comparáveis.
- `resumo_bayes()` só calcula ROPE quando a margem é definida pelo pesquisador.
- diagnósticos avançados são integrados a `performance` e `DHARMa` quando disponíveis.

## Documentação

- todas as novas funções possuem documentação em português;
- todas possuem pelo menos três exemplos de uso;
- foram criadas vinhetas temáticas para delineamento, `emmeans`, regressão, diagnóstico, PCA, Bayes e figuras;
- `MANUAL.md` foi ampliado como referência integrada.

# myfuns 0.2.0

- Reconstrução do pacote histórico de 2020 como pacote-fonte.
- Inclusão de `equar2()`, `contrast_lista()` e tema transparente `trans`.
- Modernização de temas e exportação de figuras.

