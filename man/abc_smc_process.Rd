% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slurm.R
\name{abc_smc_process}
\alias{abc_smc_process}
\title{Processes ABC-SMC Slurm Simulation Output and Selects Next Wave Particles}
\usage{
abc_smc_process(input = "data/", wave, save = TRUE, outdir = "data/")
}
\arguments{
\item{input}{A character string containing the directory of the output file
from \code{\link{abc_smc_prep}} which should be saved as an RDS file
with the name \code{abc.wave0.rda} (the default), or the object itself.}

\item{wave}{SMC wave number, where the initial wave = 0. In the standard Slurm
workflow, this would get passed in as an environmental variable
\code{wave} from the master bash script.}

\item{save}{If \code{TRUE}, writes output to an RDS file with the name
\code{abc.waveX.batchY.rda} in the directory specified by \code{outdir},
where \code{X} is the value of \code{wave} and \code{Y} is the value
of \code{batch}.}

\item{outdir}{Path to save the output RDS file if \code{save=TRUE}.}
}
\description{
This is the fourth step in the ABC-SMC Slurm workflow.
}
