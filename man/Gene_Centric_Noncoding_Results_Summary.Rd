% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Gene_Centric_Noncoding_Results_Summary.R
\name{Gene_Centric_Noncoding_Results_Summary}
\alias{Gene_Centric_Noncoding_Results_Summary}
\title{Summarize gene-centric noncoding analysis results generated by \code{STAARpipeline} package.}
\usage{
Gene_Centric_Noncoding_Results_Summary(
  agds_dir,
  gene_centric_noncoding_jobs_num,
  input_path,
  output_path,
  gene_centric_results_name,
  ncRNA_jobs_num,
  ncRNA_input_path,
  ncRNA_output_path,
  ncRNA_results_name,
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
  alpha = 2.5e-06,
  manhattan_plot = FALSE,
  QQ_plot = FALSE
)
}
\arguments{
\item{agds_dir}{a data farme containing directory of GDS/aGDS files.}

\item{gene_centric_noncoding_jobs_num}{the number of results for gene-centric noncoding analysis of protein-coding genes generated by \code{STAARpipeline} package.}

\item{input_path}{the directory of gene-centric noncoding analysis results for protein-coding genes that generated by \code{STAARpipeline} package.}

\item{output_path}{the directory for the output files of the summary of gene-centric noncoding analysis results for protein-coding genes.}

\item{gene_centric_results_name}{the file name of gene-centric noncoding analysis results for protein-coding genes generated by \code{STAARpipeline} package.}

\item{ncRNA_jobs_num}{the number of results for gene-centric noncoding analysis of ncRNA genes generated by \code{STAARpipeline} package..}

\item{ncRNA_input_path}{the directory of gene-centric noncoding analysis results for ncRNA genes that generated by \code{STAARpipeline} package.}

\item{ncRNA_output_path}{the directory for the output files of the summary of gene-centric noncoding analysis results for ncRNA genes.}

\item{ncRNA_results_name}{file name of gene-centric noncoding analysis results for ncRNA genes that generated by \code{STAARpipeline} package.}

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

\item{variant_type}{variants include in the analysis. Choices include "variant", "SNV", or "Indel" (default = "SNV").}

\item{Annotation_dir}{channel name of the annotations in the aGDS file (default = "annotation/info/FunctionalAnnotation").}

\item{Annotation_name_catalog}{a data frame containing the name and the corresponding channel name in the aGDS file.}

\item{Use_annotation_weights}{use annotations as weights or not (default = FALSE).}

\item{Annotation_name}{annotations used in STAAR.}

\item{alpha}{p-value threshold of significant results (default=2.5E-06).}

\item{manhattan_plot}{output manhattan plot or not (default = FALSE).}

\item{QQ_plot}{output Q-Q plot or not (default = FALSE).}
}
\value{
The function returns the following analysis results:

\code{noncoding_sig.csv}: a matrix that summarized the unconditional significant region detected by STAAR-O (STAAR-O pvalue smaller than the threshold alpha),
including gene name ("Gene name"), chromosome ("chr"), coding functional category ("Category"), number of variants  ("#SNV"),
and the unconditional STAAR p-values (including STAAR-O).

\code{noncoding_sig_cond.csv}: a matrix that summarized the conditional analysis results of the unconditional significant region detected by STAAR-O (available if known_loci is not a NULL),
including gene name ("Gene name"), chromosome ("chr"), coding functional category ("Category"), number of variants  ("#SNV"),
and the conditional STAAR p-values (including STAAR-O).

\code{results_UTR_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by UTR variants (UTR) for all protein-coding genes across the genome.

\code{UTR_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant UTR masks.

\code{UTR_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant UTR masks (available if known_loci is not a NULL).

\code{results_upstream_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by upstream variants (upstream) for all protein-coding genes across the genome.

\code{upstream_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant upstream masks.

\code{upstream_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant upstream masks (available if known_loci is not a NULL).

\code{results_downstream_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by downstream variants (downstream) for all protein-coding genes across the genome.

\code{downstream_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant downstream masks.

\code{downstream_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant downstream masks (available if known_loci is not a NULL).

\code{results_promoter_CAGE_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by variants overlaid with CAGE sites in the promoter (promoter_CAGE) for all protein-coding genes across the genome.

\code{promoter_CAGE_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant promoter_CAGE masks.

\code{promoter_CAGE_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant promoter_CAGE masks (available if known_loci is not a NULL).

\code{results_promoter_DHS_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by variants overlaid with DHS sites in the promoter (promoter_DHS) for all protein-coding genes across the genome.

\code{promoter_DHS_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant promoter_DHS masks.

\code{promoter_DHS_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant promoter_DHS masks (available if known_loci is not a NULL).

\code{results_enhancer_CAGE_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by variants overlaid with CAGE sites in the enhancer (enhancer_CAGE) for all protein-coding genes across the genome.

\code{enhancer_CAGE_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant enhancer_CAGE masks.

\code{enhancer_CAGE_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant enhancer_CAGE masks (available if known_loci is not a NULL).

\code{results_enhancer_DHS_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by variants overlaid with DHS sites in the enhancer (enhancer_DHS) for all protein-coding genes across the genome.

\code{enhancer_DHS_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant enhancer_DHS masks.

\code{enhancer_DHS_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant enhancer_DHS masks (available if known_loci is not a NULL).

\code{results_ncRNA_genome}: a matrix contains the STAAR p-values (including STAAR-O) of the noncoding masks defined by exonic and splicing ncRNA variants (ncRNA) for all ncRNA genes across the genome.

\code{ncRNA_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant ncRNA masks.

\code{ncRNA_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant ncRNA masks (available if known_loci is not a NULL).
}
\description{
The \code{Gene_Centric_Noncoding_Results_Summary} function takes in the objects of gene-centric noncoding analysis results
generated by \code{STAARpipeline} package,
the object from fitting the null model, and the set of known variants to be adjusted for in conditional analysis
to summarize the gene-centric noncoding analysis results and analyze the conditional association between a quantitative/dichotomous phenotype and
the rare variants in the unconditional significant noncoding masks.
}
