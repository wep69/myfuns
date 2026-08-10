\name{read_clipboard_table}
\alias{read_clipboard_table}
\title{Ler tabela da área de transferência}
\usage{
read_clipboard_table(header = TRUE, ...)
}
\arguments{
  \item{header}{A primeira linha contém nomes de colunas?}
  \item{...}{Argumentos adicionais para [utils::read.table()]. }
}
\value{
`data.frame`.
}
\description{
Nome moderno para o fluxo histórico de [read_excel()]. A função lê texto tabulado da área de transferência nativa do Windows; não abre arquivos XLSX.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
\dontrun{dados <- read_clipboard_table()}

\dontrun{dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA"))}

\dontrun{dados <- read_clipboard_table(header = FALSE)}
}
