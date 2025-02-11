#' Summarize the sliding window analysis results generated by \code{STAARpipeline} package
#'
#' The \code{Sliding_Window_Results_Summary} function takes in the results of sliding window analysis,
#' the object from fitting the null model, and the set of known variants to be adjusted for in conditional analysis
#' to summarize the sliding window analysis results and analyze the conditional association between a quantitative/dichotomous phenotype and
#' the rare variants in the unconditional significant genetic region.
#' @param agds_dir file directory of annotated GDS (aGDS) files for all chromosomes (1-22).
#' @param jobs_num a data frame containing the number of jobs for association analysis.
#' The data frame must include a column with the name "sliding_window_num"
#' @param input_path file directory of the sliding window analysis results.
#' @param output_path file output directory of the summary results.
#' @param sliding_window_results_name the file name of the input sliding window analysis results.
#' @param obj_nullmodel an object from fitting the null model, which is either the output from \code{fit_nullmodel} function in the \code{STAARpipeline} package,
#' or the output from \code{fitNullModel} function in the \code{GENESIS} package and transformed using the \code{genesis2staar_nullmodel} function in the \code{STAARpipeline} package.
#' @param known_loci the data frame of variants to be adjusted for in conditional analysis and should
#' contain 4 columns in the following order: chromosome (CHR), position (POS), reference allele (REF),
#' and alternative allele (ALT).
#' @param method_cond a character value indicating the method for conditional analysis.
#' \code{optimal} refers to regressing residuals from the null model on \code{known_loci}
#' as well as all covariates used in fitting the null model (fully adjusted) and taking the residuals;
#' \code{naive} refers to regressing residuals from the null model on \code{known_loci}
#' and taking the residuals (default = \code{optimal}).
#' @param geno_missing_imputation method of handling missing genotypes. Either "mean" or "minor" (default = "mean").
#' @param variant_type variants include in the conditional analysis. Choices include "variant", "SNV", or "Indel" (default = "SNV").
#' @param method_cond a character value indicating the method for conditional analysis.
#' \code{optimal} refers to regressing residuals from the null model on \code{known_loci}
#' as well as all covariates used in fitting the null model (fully adjusted) and taking the residuals;
#' \code{naive} refers to regressing residuals from the null model on \code{known_loci}
#' and taking the residuals (default = \code{optimal}).
#' @param QC_label channel name of the QC label in the GDS/aGDS file (default = "annotation/filter").
#' @param Annotation_dir channel name of the annotations in the aGDS file (default = "annotation/info/FunctionalAnnotation").
#' @param Annotation_name_catalog a data frame containing the name and the corresponding channel name in the aGDS file.
#' @param Use_annotation_weights use annotations as weights or not (default = FALSE).
#' @param Annotation_name a vector of names of annotation scores used in variant-set test (default = NULL).
#' @param alpha threshod to control the genome-wise (family-wise) error rate (default = 0.05), the p-value threshold is alpha/total number of sliding windows
#' @param manhattan_plot output manhattan plot or not (default = FALSE).
#' @param QQ_plot output Q-Q plot or not (default = FALSE).
#' @return The function returns the following analysis results:
#' @return \code{results_sliding_window_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the sliding windows across the genome.
#' @return \code{sliding_window_sig.Rdata} and \code{sliding_window_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the significant sliding windows (unconditional p-value<alpha/total number of sliding windows).
#' @return \code{sliding_window_sig_cond.Rdata} and \code{sliding_window_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the significant sliding windows (available if known_loci is not a NULL).
#  manhattan plot (option) and Q-Q plot (option) of the individual analysis results.
#' @export

Sliding_Window_Results_Summary <- function(agds_dir,jobs_num,input_path,output_path,sliding_window_results_name,
                                           obj_nullmodel,known_loci=NULL,
                                           method_cond=c("optimal","naive"),
                                           QC_label="annotation/filter",geno_missing_imputation=c("mean","minor"),variant_type=c("SNV","Indel","variant"),
                                           Annotation_dir="annotation/info/FunctionalAnnotation",Annotation_name_catalog,
                                           Use_annotation_weights=FALSE,Annotation_name=NULL,
                                           alpha=0.05,manhattan_plot=FALSE,QQ_plot=FALSE){

  ## evaluate choices
  method_cond <- match.arg(method_cond)
  variant_type <- match.arg(variant_type)
  geno_missing_imputation <- match.arg(geno_missing_imputation)

	results_sliding_window_genome <- c()

	for(chr in 1:22)
	{
		results_sliding_window_genome_chr <- c()

		if(chr>1)
		{
			jobs_num_chr <- sum(jobs_num$sliding_window_num[1:(chr-1)])
		}else
		{
			jobs_num_chr <- 0
		}

		for(i in 1:jobs_num$sliding_window_num[chr])
		{
			print(i + jobs_num_chr)
		  results_sliding_window <- get(load(paste0(input_path,sliding_window_results_name,"_",i+jobs_num_chr,".Rdata")))

			results_sliding_window_genome_chr <- rbind(results_sliding_window_genome_chr,results_sliding_window)
		}

		results_sliding_window_genome <- rbind(results_sliding_window_genome,results_sliding_window_genome_chr)
	}

	rm(results_sliding_window_genome_chr)
	gc()

	save(results_sliding_window_genome,file=paste0(output_path,"results_sliding_window_genome.Rdata"))

	dim(results_sliding_window_genome)

	### Significant Results
	alpha <- 0.05
	results_sig <- results_sliding_window_genome[results_sliding_window_genome[,colnames(results_sliding_window_genome)=="STAAR-O"]<alpha/dim(results_sliding_window_genome)[1],,drop=FALSE]

	save(results_sig,file=paste0(output_path,"sliding_window_sig.Rdata"))
	write.csv(results_sig,paste0(output_path,"sliding_window_sig.csv"))

	dim(results_sig)[1]

	if(length(known_loci)!=0)
	{
		results_sig_cond <- c()
		if(length(results_sig)!=0)
		{
			for(kk in 1:dim(results_sig)[1])
			{
				chr <- as.numeric(results_sig[kk,1])
				start_loc <- as.numeric(results_sig[kk,2])
				end_loc <- as.numeric(results_sig[kk,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Sliding_Window_cond(chr=chr,genofile=genofile,obj_nullmodel=obj_nullmodel,
											start_loc=start_loc,end_loc=end_loc,known_loci=known_loci,method_cond=method_cond,
											QC_label=QC_label,variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,
											Annotation_name_catalog=Annotation_name_catalog,Annotation_dir=Annotation_dir,
											Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)
				results_sig_cond <- rbind(results_sig_cond,res_cond)

				seqClose(genofile)
			}
		}

		save(results_sig_cond,file=paste0(output_path,"sliding_window_sig_cond.Rdata"))
		write.csv(results_sig_cond,paste0(output_path,"sliding_window_sig_cond.csv"))
	}

	## manhattan plot
	if(manhattan_plot)
	{
		print("Manhattan plot")

		png(paste0(output_path,"sliding_window_manhattan.png"), width=12, height=8, units = 'in', res = 600)

		print(manhattan_plot(as.numeric(results_sliding_window_genome[,1]), (as.numeric(results_sliding_window_genome[,2])+as.numeric(results_sliding_window_genome[,3]))/2, as.numeric(results_sliding_window_genome[,colnames(results_sliding_window_genome)=="STAAR-O"]), col = c("blue4", "orange3"),sig.level=0.05/dim(results_sliding_window_genome)[1]))

		dev.off()
	}

	if(QQ_plot)
	{
		print("Q-Q plot")

		## STAAR-O
		observed <- sort(as.numeric(results_sliding_window_genome[,colnames(results_sliding_window_genome)=="STAAR-O"]))
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		png(paste0(output_path,"sliding_window_qq_staar_o.png"), width=8, height=8, units = 'in', res = 600)

		par(mar=c(5,6,4,4))

		plot(lexp,lobs,pch=20, cex=1, xlim = c(0, max(lexp)), ylim = c(0, max(lobs)),
		xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
		font.lab=2,cex.lab=2,cex.axis=2,font.axis=2)

		abline(0, 1, col="red",lwd=2)

		dev.off()

		## S(1,25)
		observed <- sort(as.numeric(results_sliding_window_genome[,colnames(results_sliding_window_genome)=="SKAT(1,25)"]))
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		png(paste0(output_path,"sliding_window_qq_skat_1_25.png"), width=8, height=8, units = 'in', res = 600)

		par(mar=c(5,6,4,4))

		plot(lexp,lobs,pch=20, cex=1, xlim = c(0, max(lexp)), ylim = c(0, max(lobs)),
		xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
		font.lab=2,cex.lab=2,cex.axis=2,font.axis=2)

		abline(0, 1, col="red",lwd=2)

		dev.off()


		## B(1,1)
		observed <- sort(as.numeric(results_sliding_window_genome[,colnames(results_sliding_window_genome)=="Burden(1,1)"]))
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		png(paste0(output_path,"sliding_window_qq_burden_1_1.png"), width=8, height=8, units = 'in', res = 600)

		par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=20, cex=1, xlim = c(0, max(lexp)), ylim = c(0, max(lobs)),
		xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
		font.lab=2,cex.lab=2,cex.axis=2,font.axis=2)
		abline(0, 1, col="red",lwd=2)

		dev.off()

	}
}
