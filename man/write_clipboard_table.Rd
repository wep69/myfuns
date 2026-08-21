\name{write_clipboard_table}
\alias{write_clipboard_table}
\title{Escrever tabela na área de transferência}
\usage{
write_clipboard_table(x, row.names = FALSE, col.names = TRUE, ...)
}
\arguments{
  \item{x}{Objeto tabular.}
  \item{row.names}{Exportar nomes das linhas?}
  \item{col.names}{Exportar nomes das colunas?}
  \item{...}{Argumentos adicionais para [utils::write.table()]. }
}
\value{
Invisivelmente, `NULL`.
}
\description{
Nome moderno para o fluxo histórico de [write_excel()]. Escreve uma tabela separada por tabulações para colagem em Excel ou software equivalente no Windows.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
# Requer interação manual com a área de transferência do Windows.
\dontrun{write_clipboard_table(head(iris))}

# Requer interação manual com a área de transferência do Windows.
\dontrun{write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean))}

# Requer interação manual com a área de transferência do Windows.
\dontrun{write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE)}
}
