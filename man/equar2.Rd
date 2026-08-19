\name{equar2}
\alias{equar2}
\title{Gerar equacao de regressao a partir de medias e contrastes polinomiais}
\usage{
equar2(
  media,
  contrast_result,
  alpha = 0.05,
  strong_alpha = 0.01,
  digits = c(2, 3, 4, 1),
  r2_percent = TRUE,
  details = FALSE
)
}
\arguments{
\item{media}{Objeto coercivel a \code{data.frame} com x na primeira coluna e medias de y na segunda.}
\item{contrast_result}{Objeto com colunas \code{contrast} e \code{p.value}, tipicamente obtido com \code{emmeans::contrast(..., "poly")} ou por \code{contraste_poly()}.}
\item{alpha}{Nivel de significancia usado para selecionar o grau do modelo.}
\item{strong_alpha}{Nivel de significancia usado para marcar \code{**}.}
\item{digits}{Quatro valores para casas decimais do intercepto/media, termo linear, termo quadratico e R2.}
\item{r2_percent}{Mostrar R2 em porcentagem?}
\item{details}{Retornar lista detalhada em vez de somente a equacao?}
}
\description{
Seleciona uma representacao constante, linear ou quadratica a partir dos
p-valores dos contrastes polinomiais e retorna texto compativel com plotmath.
}
\details{
O R2 corresponde a regressao ajustada sobre as medias fornecidas, e nao sobre
as observacoes individuais. Os asteriscos sao definidos pelos p-valores em
\code{contrast_result}.

Para níveis quantitativos desigualmente espaçados, recomenda-se \code{contraste_poly()}, que usa os escores numéricos reais. Quando o objeto retornado por essa função é fornecido diretamente, \code{equar2()} reconhece os escores utilizados e evita avisos indevidos.
}
\value{
Por padrao, string plotmath. Com \code{details = TRUE}, lista contendo
\code{equation}, \code{degree}, \code{model}, \code{r_squared},
\code{p_values} e \code{data}.
}
\examples{
dados <- data.frame(
  TRAT = rep(c(0, 50, 100, 150, 200), 4),
  REP = rep(1:4, each = 5),
  PESO = c(20, 25, 30, 29, 24,
           21, 26, 31, 30, 25,
           19, 24, 29, 28, 23,
           20, 25, 32, 29, 24)
)
dados$TRATq <- dados$TRAT
dados$TRAT <- factor(dados$TRAT)
modelo <- lm(PESO ~ TRAT, data = dados)
teste <- as.data.frame(
  emmeans::contrast(emmeans::emmeans(modelo, ~ TRAT), "poly")
)
medias <- aggregate(PESO ~ TRATq, data = dados, FUN = mean)
equar2(medias, teste)
}
