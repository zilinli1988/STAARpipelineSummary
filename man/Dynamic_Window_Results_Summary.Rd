% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Dynamic_Window_Results_Summary.R
\name{Dynamic_Window_Results_Summary}
\alias{Dynamic_Window_Results_Summary}
\title{Summarize the results of dynamic window analysis generated by \code{STAARpipeline} package and
perform conditional analysis for (unconditionally) significant genetic regions by adjusting for a given list of known variants.}
\usage{
Dynamic_Window_Results_Summary(
  agds_dir,
  jobs_num,
  input_path,
  output_path,
  dynamic_window_results_name,
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
  alpha = 0.05
)
}
\arguments{
\item{agds_dir}{a vector containing file directory of annotated GDS (aGDS) files for all chromosomes (1-22).}

\item{jobs_num}{a data frame containing the number of jobs for association analysis.
The data frame must include a column with the name "scang_num"}

\item{input_path}{file directory of the input dynamic window analysis results.}

\item{output_path}{file directory of the output summary results.}

\item{dynamic_window_results_name}{file names of the input dynamic window analysis results.}

\item{obj_nullmodel}{an object from fitting the null model, which is either the output from \code{fit_nullmodel} function in the \code{STAARpipeline} package,
or the output from \code{fitNullModel} function in the \code{GENESIS} package and transformed using the \code{genesis2staar_nullmodel} function in the \code{STAARpipeline} package.}

\item{known_loci}{a data frame of variants to be adjusted for in conditional analysis and should
contain 4 columns in the following order: chromosome (CHR), position (POS), reference allele (REF),
and alternative allele (ALT).}

\item{method_cond}{a character value indicating the method for conditional analysis.
\code{optimal} refers to regressing residuals from the null model on \code{known_loci}
as well as all covariates used in fitting the null model (fully adjusted) and taking the residuals;
\code{naive} refers to regressing residuals from the null model on \code{known_loci}
and taking the residuals (default = \code{optimal}).}

\item{QC_label}{channel name of the QC label in the GDS/aGDS file (default = "annotation/filter").}

\item{geno_missing_imputation}{method of handling missing genotypes. Either "mean" or "minor" (default = "mean").}

\item{variant_type}{variants include in the conditional analysis. Choice includes "variant", "SNV", or "Indel"  (default = "SNV").}

\item{Annotation_dir}{channel name of the annotations in the aGDS file (default = "annotation/info/FunctionalAnnotation").}

\item{Annotation_name_catalog}{a data frame containing the name and the corresponding channel name in the aGDS file.}

\item{Use_annotation_weights}{use annotations as weights or not (default = FALSE).}

\item{Annotation_name}{a vector of names of annotation scores used in variant-set test (default = NULL).}

\item{alpha}{threshod to control the genome-wise (family-wise) error rate (default = 0.05).}
}
\value{
The function returns the following analysis results:

\code{SCANG_S_res_uncond_cond.Rdata} and \code{SCANG_S_res_uncond_cond.csv}: A matrix that summarized the unconditional and
conditional results of the significant regions (GWER<alpha) detected by the SCANG-STAAR-S procedure (conditional results available if known_loci is not a NULL),
including chromosome ("chr"), start position ("start_pos"), end position ("end_pos"), number of variants ("SNV_nos"),
family-wise/genome-wide error rate (GWER), unconditional STAAR-S p-value ("STAAR_S"), conditional STAAR-S p-value ("STAAR_S_cond"),
conditional ACAT-V p-value ("ACAT_V_cond"), conditional Burden p-value ("Burden_cond"), conditional SKAT p-value ("SKAT_cond"),
and conditional STAAR-O p-value ("STAAR_O_cond").

\code{SCANG_B_res_uncond_cond.Rdata} and \code{SCANG_B_res_uncond_cond.csv}: A matrix that summarized the unconditional and
conditional results of the significant regions detected by the SCANG-STAAR-B procedure  (conditional results available if known_loci is not a NULL).
Details see SCANG-STAAR-S.

\code{SCANG_O_res_uncond_cond.Rdata} and \code{SCANG_O_res_uncond_cond.csv}: A matrix that summarized the unconditional and
conditional results of the significant regions detected by the SCANG-STAAR-O procedure  (conditional results available if known_loci is not a NULL).
Details see SCANG-STAAR-S.

\code{results_dynamic_window.Rdata}: A Rdata file that summarized the significant regions detected by SCANG-STAAR procedure.

\code{SCANG_S_top1.Rdata} and \code{SCANG_S_top1.csv}: A matrix that summarized the top 1 unconditional region detected by SCANG-STAAR-S,
including the STAAR-S p-value ("STAAR_S"), chromosome ("chr"), start position ("start_pos"), end position ("end_pos"),
family-wise/genome-wide error rate (GWER) and the number of variants  ("SNV_nos").

\code{SCANG_B_top1.Rdata} and \code{SCANG_B_top1.csv}: A matrix that summarized the top 1 unconditional region detected by SCANG-STAAR-B.
Details see SCANG-STAAR-B.

\code{SCANG_O_top1.Rdata} and \code{SCANG_O_top1.csv}: A matrix that summarized the top 1 unconditional region detected by SCANG-STAAR-O.
Details see SCANG-STAAR-O.

\code{SCANG_S_res.Rdata} and \code{SCANG_S_res.csv}: A matrix that summarized the significant regions (GWER<alpha) detected by SCANG-STAAR-S,
including the negative log transformation of STAAR-S p-value ("-logp"), chromosome ("chr"), start position ("start_pos"), end position ("end_pos"),
family-wise/genome-wide error rate (GWER) and the number of variants  ("SNV_num").

\code{SCANG_B_res.Rdata} and \code{SCANG_B_res.csv}: A matrix that summarized the significant regions detected by SCANG-STAAR-B.
Details see SCANG-STAAR-S.

\code{SCANG_O_res.Rdata} and \code{SCANG_O_res.csv}: A matrix that summarized the significant regions detected by SCANG-STAAR-O.
Details see SCANG-STAAR-S.

\code{SCANG_S_res_cond.Rdata} and \code{SCANG_S_res_cond.csv}: A matrix that summarized the conditional p-values of the significant regions (GWER<alpha) detected by SCANG-STAAR-S,
including chromosome ("chr"), start position ("Start Loc"), end position ("End Loc"),
the number of variants ("#SNV"), annotation-weighted ACAT-V, Burden and SKAT conditional p-values,
and STAAR conditional p-values of the regions with GWER smaller than the threshold alpha (available if known_loci is not a NULL).

\code{SCANG_B_res_cond.Rdata} and \code{SCANG_B_res_cond.csv}: A matrix that summarized the conditional p-values of the significant regions (GWER<alpha) detected by SCANG-STAAR-B (available if known_loci is not a NULL),
Details see SCANG-STAAR-S.

\code{SCANG_O_res_cond.Rdata} and \code{SCANG_O_res_cond.csv}: A matrix that summarized the conditional p-values of the significant regions (GWER<alpha) detected by SCANG-STAAR-O (available if known_loci is not a NULL),
Details see SCANG-STAAR-S.
}
\description{
The \code{Dynamic_Window_Results_Summary} function takes in the results of dynamic window analysis generated by \code{STAARpipeline} package,
the object from fitting the null model, and the set of known variants to be adjusted for in conditional analysis
to summarize the dynamic window analysis results and analyze the conditional association between a quantitative/dichotomous phenotype and
the rare variants in the unconditional significant genetic regions.
}
