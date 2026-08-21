\name{read_excel}
\alias{read_excel}
\alias{write_excel}
\title{Transferir tabelas entre R e Excel pela area de transferencia}
\usage{
read_excel(header = TRUE, ...)

write_excel(x, row.names = FALSE, col.names = TRUE, ...)
}
\arguments{
\item{header}{A primeira linha contem nomes de colunas?}
\item{x}{Objeto tabular a copiar.}
\item{row.names}{Copiar nomes das linhas?}
\item{col.names}{Copiar nomes das colunas?}
\item{...}{Argumentos adicionais para \code{read.table()} ou \code{write.table()}.}
}
\description{
Funcoes historicas para fluxo copiar/colar com Excel no Windows. Nao leem nem
escrevem arquivos .xlsx diretamente.
}
\value{
\code{read_excel()} retorna um \code{data.frame}; \code{write_excel()} retorna
\code{NULL} invisivelmente.
}
\examples{
# Requer interação manual com a área de transferência do Windows.
\dontrun{
dados <- read_excel(header = TRUE, dec = ",")
write_excel(dados)
}
}
