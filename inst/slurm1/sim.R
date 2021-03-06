
library("methods")
library("EpiABC")

setwd("inst/slurm")

rm(list = ls())
toy_model_parallel <- function(x){
  set.seed(x[1])
  # a <- rnorm(1e7)
  a <- 0
  2 * x[2] + 5 + rnorm(1,mean(a),0.1)
}
sum_stat_obs <- 6.5
toy_prior <- list(c("unif",0,1))

prep <- abc_smc_prep(model = toy_model_parallel,
                     prior = toy_prior,
                     nsims = 500,
                     summary_stat_target = sum_stat_obs,
                     ncores = 4,
                     alpha = 0.2,
                     p_acc_min = 0.1)
prep

wavedist <- prep
wave <- 0
for (i in 1:20) {
  wavedat <- abc_smc_wave(input = wavedist, wave = wave, batch = NULL, save = FALSE)
  wavedist <- abc_smc_process(input = wavedat, wave = wave, save = FALSE)
  cat("\n", wavedist$pwave$p_acc)
  wave <- wave + 1
}


# batch workflow ----------------------------------------------------------

# interactive
prep <- abc_smc_prep(model = toy_model_parallel,
                     prior = toy_prior,
                     nsims = 100,
                     summary_stat_target = sum_stat_obs,
                     ncores = 8,
                     alpha = 0.5,
                     p_acc_min = 0.1)
prep

# write bash script with this
nBatches <- ceiling(prep$nsims/prep$ncores)
nBatches

# Wave 0
for (batch in 1:nBatches) {
  abc_smc_wave(input = prep, wave = 0, batch = batch)
  cat("\n Batch:", batch)
}
merge_abc(wave = 0)
abc_smc_process(wave = 0)

# Wave 1
nBatches <- ceiling(prep$alpha*prep$nsims/prep$ncores)

for (batch in 1:nBatches) {
  abc_smc_wave(wave = 1, batch = batch)
  cat("\n Batch:", batch)
}
merge_abc(wave = 1)
abc_smc_process(wave = 1)

# Wave 2
for (batch in 1:nBatches) {
  abc_smc_wave(wave = 2, batch = batch)
  cat("\n Batch:", batch)
}
merge_abc(wave = 2)
abc_smc_process(wave = 2)

w2 <- out_abc(wave = 2)
summary_abc(w2)
