\name{comparar_emmeans}
\alias{comparar_emmeans}
\title{Organizar médias marginais estimadas e contrastes}
\usage{
comparar_emmeans(model,
                               specs,
                               method = "pairwise",
                               adjust = "tukey",
                               type = "response",
                               cld = FALSE,
                               delta = 0,
                               ...)
}
\arguments{
  \item{model}{Modelo aceito por [emmeans::emmeans()].}
  \item{specs}{Especificação das médias marginais.}
  \item{method}{Família de contrastes repassada a [emmeans::contrast()].}
  \item{adjust}{Método de ajuste de multiplicidade.}
  \item{type}{Escala das estimativas, como `"response"` ou `"link"`.}
  \item{cld}{Calcular letras de comparação? Padrão `FALSE`.}
  \item{delta}{Margem de equivalência usada apenas quando `cld = TRUE` e suportada pelo método de `emmeans`.}
  \item{...}{Argumentos adicionais. Argumentos como `ref` são repassados aos contrastes; argumentos próprios de `emmeans()` devem ser informados antes da criação do objeto quando necessário. }
}
\value{
Lista da classe `myfuns_emmeans`.
}
\description{
Gera EMMs, intervalos de confiança e contrastes em um objeto único, mantendo o `emmGrid` original disponível para inferências posteriores. Opcionalmente, pode calcular compact letter display.
}
\details{
Consulte as vinhetas do pacote para interpretação, limitações e fluxos integrados. A função não deve substituir a avaliação do delineamento e da pergunta científica.
}
\examples{
m <- stats::lm(weight ~ group, data = PlantGrowth)
comparar_emmeans(m, ~ group, method = "pairwise", adjust = "tukey")

comparar_emmeans(m, ~ group, method = "trt.vs.ctrl", adjust = "dunnettx", ref = 1)

m2 <- stats::lm(breaks ~ wool * tension, data = warpbreaks)
comparar_emmeans(m2, ~ tension | wool, method = "pairwise", adjust = "tukey")
}
