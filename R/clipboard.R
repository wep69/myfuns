#' Ler tabela copiada do Excel pela área de transferência
#'
#' Alias histórico de [read_clipboard_table()]. Apesar do nome, a função não
#' abre arquivos `.xlsx`; ela lê texto tabulado copiado para a área de
#' transferência nativa do Windows.
#'
#' @param header A primeira linha contém nomes de colunas?
#' @param ... Argumentos adicionais repassados a [utils::read.table()].
#' @return `data.frame` com os dados lidos.
#' @rdname clipboard
#' @export
#'
#' @examples
#' \dontrun{dados <- read_excel(header = TRUE, dec = ",")}
read_excel <- function(header = TRUE, ...) {
  read_clipboard_table(header = header, ...)
}

#' Copiar tabela para colagem no Excel
#'
#' Alias histórico de [write_clipboard_table()]. Escreve uma tabela tabulada
#' na área de transferência nativa do Windows.
#'
#' @param x Objeto tabular.
#' @param row.names Exportar nomes das linhas?
#' @param col.names Exportar nomes das colunas?
#' @param ... Argumentos adicionais repassados a [utils::write.table()].
#' @return Invisivelmente, `NULL`.
#' @rdname clipboard
#' @export
#'
#' @examples
#' \dontrun{write_excel(head(iris))}
write_excel <- function(x, row.names = FALSE, col.names = TRUE, ...) {
  write_clipboard_table(x, row.names = row.names, col.names = col.names, ...)
}

.require_windows_clipboard <- function() {
  if (.Platform$OS.type != "windows") {
    stop(
      "As fun\u00E7\u00F5es de \u00E1rea de transfer\u00EAncia do `myfuns` utilizam a \u00E1rea de transfer\u00EAncia nativa do Windows.",
      call. = FALSE
    )
  }
}