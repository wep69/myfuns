\name{auditar_delineamento}
\alias{auditar_delineamento}
\title{Auditar a estrutura de um delineamento experimental}
\usage{
auditar_delineamento(data,
                                   tratamento,
                                   bloco = NULL,
                                   unidade = NULL,
                                   fatores = NULL,
                                   resposta = NULL)
}
\arguments{
  \item{data}{`data.frame` contendo o experimento.}
  \item{tratamento}{Variável que identifica o tratamento principal. Aceita nome sem aspas ou string.}
  \item{bloco}{Variável de bloco, quando houver. O padrão é `NULL`.}
  \item{unidade}{Identificador da unidade experimental, quando disponível.}
  \item{fatores}{Fatores adicionais do delineamento. Pode ser informado como `c(fator1, fator2)` ou vetor de nomes.}
  \item{resposta}{Variável resposta a ser verificada quanto a valores ausentes. }
}
\value{
Lista da classe `myfuns_delineamento` com resumo, níveis, frequências, células ausentes, duplicações, valores ausentes, indicador de balanceamento e mensagens de atenção.
}
\description{
Examina o banco de dados antes do ajuste do modelo e identifica problemas frequentes em experimentação: combinações ausentes, duplicações de unidades, desbalanceamento e valores ausentes na variável resposta.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
dados <- expand.grid(bloco = factor(1:4), tratamento = factor(c("A", "B", "C")))
dados$y <- c(10, 12, 14, 11, 13, 15, 9, 12, 16, 10, 14, 17)
auditar_delineamento(dados, tratamento, bloco, resposta = y)

dados2 <- dados[-5, ]
auditar_delineamento(dados2, tratamento, bloco)

fat <- expand.grid(
bloco = factor(1:3), salinidade = factor(c("0.5", "3.0")),
plantas = factor(c("1", "2")), porta_enxerto = factor(c("A", "B"))
)
fat$y <- seq_len(nrow(fat))
auditar_delineamento(
fat, salinidade, bloco, fatores = c(plantas, porta_enxerto), resposta = y
)
}
