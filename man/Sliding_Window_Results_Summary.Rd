% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sliding_Window_Results_Summary.R
\name{Sliding_Window_Results_Summary}
\alias{Sliding_Window_Results_Summary}
\title{Summarize the sliding window analysis results generated by \code{STAARpipeline} package}
\usage{
Sliding_Window_Results_Summary(
  agds_dir,
  jobs_num,
  input_path,
  output_path,
  sliding_window_results_name,
  obj_nullmodel,
  known_loci = NULL,
  method_cond = c("optimal", "naive"),
  QC_label = "annotation/filter",
  geno_missing_imputation = c("mean", "minor"),
  variant_type = c("SNV", "Indel", "variant"),
  Annotation_dir = "annotation/info/FunctionalAnnotation",
  Annotation_name_catalog,
  Use_annotation_weights = FALSE,
  Annotation_name = NULL,
  alpha = 0.05,
  manhattan_plot = FALSE,
  QQ_plot = FALSE
)
}
\arguments{
\item{agds_dir}{file directory of annotated GDS (aGDS) files for all chromosomes (1-22).}

\item{jobs_num}{a data frame containing the number of jobs for association analysis.
The data frame must include a column with the name "sliding_window_num"}

\item{input_path}{file directory of the sliding window analysis results.}

\item{output_path}{file output directory of the summary results.}

\item{sliding_window_results_name}{the file name of the input sliding window analysis results.}

\item{obj_nullmodel}{an object from fitting the null model, which is either the output from \code{fit_nullmodel} function in the \code{STAARpipeline} package,
or the output from \code{fitNullModel} function in the \code{GENESIS} package and transformed using the \code{genesis2staar_nullmodel} function in the \code{STAARpipeline} package.}

\item{known_loci}{the data frame of variants to be adjusted for in conditional analysis and should
contain 4 columns in the following order: chromosome (CHR), position (POS), reference allele (REF),
and alternative allele (ALT).}

\item{method_cond}{a character value indicating the method for conditional analysis.
\code{optimal} refers to regressing residuals from the null model on \code{known_loci}
as well as all covariates used in fitting the null model (fully adjusted) and taking the residuals;
\code{naive} refers to regressing residuals from the null model on \code{known_loci}
and taking the residuals (default = \code{optimal}).}

\item{QC_label}{channel name of the QC label in the GDS/aGDS file (default = "annotation/filter").}

\item{geno_missing_imputation}{method of handling missing genotypes. Either "mean" or "minor" (default = "mean").}

\item{variant_type}{variants include in the conditional analysis. Choices include "variant", "SNV", or "Indel" (default = "SNV").}

\item{Annotation_dir}{channel name of the annotations in the aGDS file (default = "annotation/info/FunctionalAnnotation").}

\item{Annotation_name_catalog}{a data frame containing the name and the corresponding channel name in the aGDS file.}

\item{Use_annotation_weights}{use annotations as weights or not (default = FALSE).}

\item{Annotation_name}{a vector of names of annotation scores used in variant-set test (default = NULL).}

\item{alpha}{threshod to control the genome-wise (family-wise) error rate (default = 0.05), the p-value threshold is alpha/total number of sliding windows}

\item{manhattan_plot}{output manhattan plot or not (default = FALSE).}

\item{QQ_plot}{output Q-Q plot or not (default = FALSE).}
}
\value{
The function returns the following analysis results:

\code{results_sliding_window_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the sliding windows across the genome.

\code{sliding_window_sig.Rdata} and \code{sliding_window_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the significant sliding windows (unconditional p-value<alpha/total number of sliding windows).

\code{sliding_window_sig_cond.Rdata} and \code{sliding_window_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the significant sliding windows (available if known_loci is not a NULL).
}
\description{
The \code{Sliding_Window_Results_Summary} function takes in the results of sliding window analysis,
the object from fitting the null model, and the set of known variants to be adjusted for in conditional analysis
to summarize the sliding window analysis results and analyze the conditional association between a quantitative/dichotomous phenotype and
the rare variants in the unconditional significant genetic region.
}
