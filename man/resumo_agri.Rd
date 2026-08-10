\name{resumo_agri}
\alias{resumo_agri}
\title{Resumo descritivo para experimentação agrícola}
\usage{
resumo_agri(data, resposta, ..., conf.level = 0.95, na.rm = TRUE)
}
\arguments{
  \item{data}{`data.frame`.}
  \item{resposta}{Variável numérica resposta.}
  \item{...}{Variáveis de agrupamento, informadas sem aspas.}
  \item{conf.level}{Nível do intervalo de confiança da média.}
  \item{na.rm}{Remover valores ausentes da resposta? Quando `FALSE`, grupos com ausências retornam estatísticas `NA` para medidas dependentes da resposta. }
}
\value{
`data.frame` com as estatísticas descritivas por grupo.
}
\description{
Calcula, por um ou mais grupos, tamanho amostral, média, desvio-padrão, erro-padrão, intervalo de confiança da média, mediana, quartis, mínimo, máximo e coeficiente de variação descritivo.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
resumo_agri(iris, Sepal.Length, Species)

iris$grupo_largura <- cut(iris$Sepal.Width, breaks = 2)
resumo_agri(iris, Petal.Length, Species, grupo_largura)

resumo_agri(iris, Sepal.Length, Species, conf.level = 0.90)
}
