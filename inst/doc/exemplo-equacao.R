# Exemplo: equação renderizada em gráfico de regressão
library(myfuns)

# Dados simulados
set.seed(42)
dados <- expand.grid(
  bloco = factor(1:4),
  dose = c(0, 50, 100, 150)
)
dados$y <- with(dados, 20 + 0.25 * dose - 0.0008 * dose^2 + 
  as.numeric(bloco) * 0.3 + rnorm(nrow(dados), 0, 1))

# Criar fator para emmeans
dados$dose_f <- factor(dados$dose)

# Ajustar regressão polinomial
rp <- reg_poly(dados, y, dose, degree = 1:2)

# Modelo fatorial para contrastes polinomiais
mod_f <- lm(y ~ bloco + dose_f, data = dados)
emm <- emmeans::emmeans(mod_f, ~ dose_f)
cp <- contraste_poly(emm, scores = c(0, 50, 100, 150), degree = 2)

# Médias por dose
medias <- aggregate(y ~ dose, data = dados, FUN = mean)

# Equação via equar2
eq_text <- equar2(medias, cp)

# Gerar gráfico com equação renderizada
p <- plot_reg_equation(rp, equation_text = eq_text)

# Salvar figura
if (!dir.exists("man/figures")) dir.create("man/figures", recursive = TRUE)
ggplot2::ggsave("man/figures/plot_reg_equation_example.png", plot = p, 
  width = 7, height = 5, dpi = 300)

cat("Figura salva em man/figures/plot_reg_equation_example.png\n")
