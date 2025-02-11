#' Summarize gene-centric coding analysis results generated by \code{STAARpipeline} package and
#' perform conditional analysis for (unconditionally) significant coding masks by adjusting for a given list of known variants.
#'
#' The \code{Gene_Centric_Coding_Results_Summary} function takes in the objects of gene-centric coding analysis results
#' generated by \code{STAARpipeline} package,
#' the object from fitting the null model, and the set of known variants to be adjusted for in conditional analysis
#' to summarize the gene-centric coding analysis results and analyze the conditional association between a quantitative/dichotomous phenotype and
#' the rare variants in the unconditional significant coding masks.
#' @param agds_dir file directory of annotated GDS (aGDS) files for all chromosomes (1-22)
#' @param gene_centric_coding_jobs_num the number of gene-centric coding analysis results generated by \code{STAARpipeline} package.
#' @param input_path the directory of gene-centric coding analysis results that generated by \code{STAARpipeline} package.
#' @param output_path the directory for the output files.
#' @param gene_centric_results_name file name of gene-centric coding analysis results generated by \code{STAARpipeline} package.
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
#' @param variant_type variants include in the analysis. Choices include "variant", "SNV", or "Indel" (default = "SNV").
#' @param method_cond a character value indicating the method for conditional analysis.
#' \code{optimal} refers to regressing residuals from the null model on \code{known_loci}
#' as well as all covariates used in fitting the null model (fully adjusted) and taking the residuals;
#' \code{naive} refers to regressing residuals from the null model on \code{known_loci}
#' and taking the residuals (default = \code{optimal}).
#' @param QC_label channel name of the QC label in the GDS/aGDS file  (default = "annotation/filter").
#' @param Annotation_dir channel name of the annotations in the aGDS file (default = "annotation/info/FunctionalAnnotation").
#' @param Annotation_name_catalog a data frame containing the name and the corresponding channel name in the aGDS file.
#' @param Use_annotation_weights use annotations as weights or not (default = FALSE).
#' @param Annotation_name annotations used in STAAR.
#' @param alpha p-value threshold of significant results (default=2.5E-06).
#' @param manhattan_plot output manhattan plot or not (default = FALSE).
#' @param QQ_plot output Q-Q plot or not (default = FALSE).
#' @return The function returns the following analysis results:
#' @return \code{coding_sig.csv}: a matrix that summarizes the unconditional significant coding masks detected by STAAR-O (STAAR-O pvalue smaller than the threshold alpha),
#' including gene name ("Gene name"), chromosome ("chr"), coding functional category ("Category"), number of variants  ("#SNV"),
#' and unconditional p-values of set-based tests SKAT ("SKAT(1,25)"), Burden ("Burden(1,1)"), ACAT-V ("ACAT-V(1,25)") and STAAR-O ("STAAR-O").
#' @return \code{coding_sig_cond.csv}: a matrix that summarized the conditional analysis results of unconditional significant coding masks detected by STAAR-O (available if known_loci is not a NULL),
#' including gene name ("Gene name"), chromosome ("chr"), coding functional category ("Category"), number of variants  ("#SNV"),
#' and conditional p-values of set-based tests SKAT ("SKAT(1,25)"), Burden ("Burden(1,1)"), ACAT-V ("ACAT-V(1,25)") and STAAR-O ("STAAR-O").
#' @return \code{results_plof_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the coding mask defined by the putative loss of function variants (plof) for all protein-coding genes across the genome.
#' @return \code{plof_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant plof masks.
#' @return \code{plof_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant plof masks (available if known_loci is not a NULL).
#' @return \code{results_plof_ds_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the coding mask defined by the putative loss of function variants and disruptive missense variants (plof_ds) for all protein-coding genes across the genome.
#' @return \code{plof_ds_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant plof_ds masks.
#' @return \code{plof_ds_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant plof_ds masks (available if known_loci is not a NULL).
#' @return \code{results_disruptive_missense_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the coding mask defined by the disruptive missense variants (disruptive_missense) for all protein-coding genes across the genome.
#' @return \code{disruptive_missense_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant disruptive_missense masks.
#' @return \code{disruptive_missense_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant disruptive_missense masks (available if known_loci is not a NULL).
#' @return \code{results_missense_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the coding mask defined by the missense variants (missense) for all protein-coding genes across the genome.
#' @return \code{missense_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant missense masks.
#' @return \code{missense_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant missense masks (available if known_loci is not a NULL).
#' @return \code{results_synonymous_genome.Rdata}: a matrix contains the STAAR p-values (including STAAR-O) of the coding mask defined by the synonymous variants (synonymous) for all protein-coding genes across the genome.
#' @return \code{synonymous_sig.csv}: a matrix contains the unconditional STAAR p-values (including STAAR-O) of the unconditional significant synonymous masks.
#' @return \code{synonymous_sig_cond.csv}: a matrix contains the conditional STAAR p-values (including STAAR-O) of the unconditional significant synonymous masks (available if known_loci is not a NULL).
#  manhattan plot (option) and Q-Q plot (option) of the individual analysis results.
#' @export

Gene_Centric_Coding_Results_Summary <- function(agds_dir,gene_centric_coding_jobs_num,input_path,output_path,gene_centric_results_name,
                                                obj_nullmodel,known_loci=NULL,
                                                method_cond=c("optimal","naive"),
                                                QC_label="annotation/filter",geno_missing_imputation=c("mean","minor"),variant_type=c("SNV","Indel","variant"),
                                                Annotation_dir="annotation/info/FunctionalAnnotation",Annotation_name_catalog,
                                                Use_annotation_weights=FALSE,Annotation_name=NULL,
                                                alpha=2.5E-06,manhattan_plot=FALSE,QQ_plot=FALSE){

  ## evaluate choices
  method_cond <- match.arg(method_cond)
  variant_type <- match.arg(variant_type)
  geno_missing_imputation <- match.arg(geno_missing_imputation)

	#######################################################
	#     summarize unconditional analysis results
	#######################################################

	results_coding_genome <- c()

	for(kk in 1:gene_centric_coding_jobs_num)
	{
		print(kk)
	  results_coding <- get(load(paste0(input_path,gene_centric_results_name,"_",kk,".Rdata")))

		results_coding_genome <- c(results_coding_genome,results_coding)
	}

	results_plof_genome <- c()
	results_plof_ds_genome <- c()
	results_missense_genome <- c()
	results_disruptive_missense_genome <- c()
	results_synonymous_genome <- c()

	for(kk in 1:length(results_coding_genome))
	{
		results <- results_coding_genome[[kk]]

		if(is.null(results)==FALSE)
		{
			### plof
			if(results[3]=="plof")
			{
				results_plof_genome <- rbind(results_plof_genome,results)
			}
			### plof_ds
			if(results[3]=="plof_ds")
			{
				results_plof_ds_genome <- rbind(results_plof_ds_genome,results)
			}
			### missense
			if(results[3]=="missense")
			{
				results_missense_genome <- rbind(results_missense_genome,results)
			}
			### disruptive_missense
			if(results[3]=="disruptive_missense")
			{
				results_disruptive_missense_genome <- rbind(results_disruptive_missense_genome,results)
			}
			### synonymous
			if(results[3]=="synonymous")
			{
				results_synonymous_genome <- rbind(results_synonymous_genome,results)
			}
		}

		if(kk%%1000==0)
		{
			print(kk)
		}
	}

	###### whole-genome results
	# plof
	save(results_plof_genome,file=paste0(output_path,"plof.Rdata"))
	# plof + disruptive missense
	save(results_plof_ds_genome,file=paste0(output_path,"plof_ds.Rdata"))
	# missense
	save(results_missense_genome,file=paste0(output_path,"missense.Rdata"))
	# disruptive missense
	save(results_disruptive_missense_genome,file=paste0(output_path,"disruptive_missense.Rdata"))
	# synonymous
	save(results_synonymous_genome,file=paste0(output_path,"synonymous.Rdata"))

	###### significant results
	# plof
	plof_sig <- results_plof_genome[results_plof_genome[,"STAAR-O"]<alpha,,drop=FALSE]
	write.csv(plof_sig,file=paste0(output_path,"plof_sig.csv"))
	# missense
	missense_sig <- results_missense_genome[results_missense_genome[,"STAAR-O"]<alpha,,drop=FALSE]
	write.csv(missense_sig,file=paste0(output_path,"missense_sig.csv"))
	# synonymous
	synonymous_sig <- results_synonymous_genome[results_synonymous_genome[,"STAAR-O"]<alpha,,drop=FALSE]
	write.csv(synonymous_sig,file=paste0(output_path,"synonymous_sig.csv"))
	# plof_ds
	plof_ds_sig <- results_plof_ds_genome[results_plof_ds_genome[,"STAAR-O"]<alpha,,drop=FALSE]
	write.csv(plof_ds_sig,file=paste0(output_path,"plof_ds_sig.csv"))
	# disruptive_missense
	disruptive_missense_sig <- results_disruptive_missense_genome[results_disruptive_missense_genome[,"STAAR-O"]<alpha,,drop=FALSE]
	write.csv(disruptive_missense_sig,file=paste0(output_path,"disruptive_missense_sig.csv"))
	# coding results
	coding_sig <- rbind(plof_sig[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")],
					missense_sig[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
	coding_sig <- rbind(coding_sig,synonymous_sig[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
	coding_sig <- rbind(coding_sig,plof_ds_sig[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
	coding_sig <- rbind(coding_sig,disruptive_missense_sig[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
	write.csv(coding_sig,file=paste0(output_path,"coding_sig.csv"))


	#######################################################
	#     conditional analysis
	#######################################################

	if(length(known_loci)!=0)
	{
		# plof
		plof_sig_cond <- c()
		if(length(plof_sig)!=0)
		{
			if((class(plof_sig)!="matrix")&(class(plof_sig)!="data.frame"))
			{
				plof_sig <- matrix(plof_sig,nrow=1)
			}

			for(k in 1:dim(plof_sig)[1])
			{
				chr <- as.numeric(plof_sig[k,2])
				gene_name <- as.character(plof_sig[k,1])
				category <- as.character(plof_sig[k,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Gene_Centric_Coding_cond(chr=chr,gene_name=gene_name,category=category,genofile=genofile,
												obj_nullmodel=obj_nullmodel,known_loci=known_loci,
												variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,QC_label=QC_label,
											    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
												Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

				plof_sig_cond <- rbind(plof_sig_cond,res_cond)

				seqClose(genofile)
			}
		}

		write.csv(plof_sig_cond,file=paste0(output_path,"plof_sig_cond.csv"))

		### missense
		missense_sig_cond <- c()
		if(length(missense_sig)!=0)
		{
			if((class(missense_sig)!="matrix")&(class(missense_sig)!="data.frame"))
			{
				missense_sig <- matrix(missense_sig,nrow=1)
			}

			for(k in 1:dim(missense_sig)[1])
			{
				chr <- as.numeric(missense_sig[k,2])
				gene_name <- as.character(missense_sig[k,1])
				category <- as.character(missense_sig[k,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Gene_Centric_Coding_cond(chr=chr,gene_name=gene_name,category=category,genofile=genofile,
												obj_nullmodel=obj_nullmodel,known_loci=known_loci,
												variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,QC_label=QC_label,
											    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
												Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

				missense_sig_cond <- rbind(missense_sig_cond,res_cond)

				seqClose(genofile)
			}
		}
		write.csv(missense_sig_cond,file=paste0(output_path,"missense_sig_cond.csv"))

		## synonymous
		synonymous_sig_cond <- c()
		if(length(synonymous_sig)!=0)
		{
			if((class(synonymous_sig)!="matrix")&(class(synonymous_sig)!="data.frame"))
			{
				synonymous_sig <- matrix(synonymous_sig,nrow=1)
			}

			for(k in 1:dim(synonymous_sig)[1])
			{
				chr <- as.numeric(synonymous_sig[k,2])
				gene_name <- as.character(synonymous_sig[k,1])
				category <- as.character(synonymous_sig[k,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Gene_Centric_Coding_cond(chr=chr,gene_name=gene_name,category=category,genofile=genofile,
												obj_nullmodel=obj_nullmodel,known_loci=known_loci,
												variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,QC_label=QC_label,
											    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
												Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

				synonymous_sig_cond <- rbind(synonymous_sig_cond,res_cond)

				seqClose(genofile)
			}
		}
		write.csv(synonymous_sig_cond,file=paste0(output_path,"synonymous_sig_cond.csv"))

		## plof_ds
		plof_ds_sig_cond <- c()
		if(length(plof_ds_sig)!=0)
		{
			if((class(plof_ds_sig)!="matrix")&(class(plof_ds_sig)!="data.frame"))
			{
				plof_ds_sig <- matrix(plof_ds_sig,nrow=1)
			}

			for(k in 1:dim(plof_ds_sig)[1])
			{
				chr <- as.numeric(plof_ds_sig[k,2])
				gene_name <- as.character(plof_ds_sig[k,1])
				category <- as.character(plof_ds_sig[k,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Gene_Centric_Coding_cond(chr=chr,gene_name=gene_name,category=category,genofile=genofile,
												obj_nullmodel=obj_nullmodel,known_loci=known_loci,
												variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,QC_label=QC_label,
											    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
												Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

				plof_ds_sig_cond <- rbind(plof_ds_sig_cond,res_cond)

				seqClose(genofile)
			}
		}
		write.csv(plof_ds_sig_cond,file=paste0(output_path,"plof_ds_sig_cond.csv"))


		## disruptive_missense
		disruptive_missense_sig_cond <- c()
		if(length(disruptive_missense_sig)!=0)
		{
			if((class(disruptive_missense_sig)!="matrix")&(class(disruptive_missense_sig)!="data.frame"))
			{
				disruptive_missense_sig <- matrix(disruptive_missense_sig,nrow=1)
			}

			for(k in 1:dim(disruptive_missense_sig)[1])
			{
				chr <- as.numeric(disruptive_missense_sig[k,2])
				gene_name <- as.character(disruptive_missense_sig[k,1])
				category <- as.character(disruptive_missense_sig[k,3])

				gds.path <- agds_dir[chr]
				genofile <- seqOpen(gds.path)

				res_cond <- Gene_Centric_Coding_cond(chr=chr,gene_name=gene_name,category=category,genofile=genofile,
												obj_nullmodel=obj_nullmodel,known_loci=known_loci,
												variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,QC_label=QC_label,
											    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
												Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

				disruptive_missense_sig_cond <- rbind(disruptive_missense_sig_cond,res_cond)

				seqClose(genofile)
			}
		}
		write.csv(disruptive_missense_sig_cond,file=paste0(output_path,"disruptive_missense_sig_cond.csv"))

		## coding cond
		coding_sig_cond <- rbind(plof_sig_cond[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")],
		missense_sig_cond[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
		coding_sig_cond <- rbind(coding_sig_cond,synonymous_sig_cond[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
		coding_sig_cond <- rbind(coding_sig_cond,plof_ds_sig_cond[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])
		coding_sig_cond <- rbind(coding_sig_cond,disruptive_missense_sig_cond[,c("Gene name","Chr","Category","#SNV","SKAT(1,25)","Burden(1,1)","ACAT-V(1,25)","STAAR-O")])

		write.csv(coding_sig_cond,file=paste0(output_path,"coding_sig_cond.csv"))
	}


	if(manhattan_plot)
	{
		### pLoF
		results_STAAR <- results_plof_genome[,c(1,2,dim(results_plof_genome)[2])]

		results_m <- c()
		for(i in 1:dim(results_STAAR)[2])
		{
			results_m <- cbind(results_m,unlist(results_STAAR[,i]))
		}

		colnames(results_m) <- colnames(results_STAAR)
		results_m <- data.frame(results_m,stringsAsFactors = FALSE)
		results_m[,2] <- as.numeric(results_m[,2])
		results_m[,3] <- as.numeric(results_m[,3])

		genes_info_manhattan <- dplyr::left_join(genes_info,results_m,by=c("chromosome_name"="Chr","hgnc_symbol"="Gene.name"))

		genes_info_manhattan[is.na(genes_info_manhattan)] <- 1
		colnames(genes_info_manhattan)[dim(genes_info_manhattan)[2]] <- "plof"

		### pLoF_DS
		results_STAAR <- results_plof_ds_genome[,c(1,2,dim(results_plof_ds_genome)[2])]

		results_m <- c()
		for(i in 1:dim(results_STAAR)[2])
		{
			results_m <- cbind(results_m,unlist(results_STAAR[,i]))
		}

		colnames(results_m) <- colnames(results_STAAR)
		results_m <- data.frame(results_m,stringsAsFactors = FALSE)
		results_m[,2] <- as.numeric(results_m[,2])
		results_m[,3] <- as.numeric(results_m[,3])

		genes_info_manhattan <- dplyr::left_join(genes_info_manhattan,results_m,by=c("chromosome_name"="Chr","hgnc_symbol"="Gene.name"))
		genes_info_manhattan[is.na(genes_info_manhattan)] <- 1
		colnames(genes_info_manhattan)[dim(genes_info_manhattan)[2]] <- "plof_ds"

		### missense
		results_STAAR <- results_missense_genome[,c(1,2,dim(results_missense_genome)[2]-6)]

		results_m <- c()
		for(i in 1:dim(results_STAAR)[2])
		{
			results_m <- cbind(results_m,unlist(results_STAAR[,i]))
		}

		colnames(results_m) <- colnames(results_STAAR)
		results_m <- data.frame(results_m,stringsAsFactors = FALSE)
		results_m[,2] <- as.numeric(results_m[,2])
		results_m[,3] <- as.numeric(results_m[,3])

		genes_info_manhattan <- dplyr::left_join(genes_info_manhattan,results_m,by=c("chromosome_name"="Chr","hgnc_symbol"="Gene.name"))
		genes_info_manhattan[is.na(genes_info_manhattan)] <- 1
		colnames(genes_info_manhattan)[dim(genes_info_manhattan)[2]] <- "missense"

		### disruptive_missense
		results_STAAR <- results_disruptive_missense_genome[,c(1,2,dim(results_disruptive_missense_genome)[2])]

		results_m <- c()
		for(i in 1:dim(results_STAAR)[2])
		{
			results_m <- cbind(results_m,unlist(results_STAAR[,i]))
		}

		colnames(results_m) <- colnames(results_STAAR)
		results_m <- data.frame(results_m,stringsAsFactors = FALSE)
		results_m[,2] <- as.numeric(results_m[,2])
		results_m[,3] <- as.numeric(results_m[,3])

		genes_info_manhattan <- dplyr::left_join(genes_info_manhattan,results_m,by=c("chromosome_name"="Chr","hgnc_symbol"="Gene.name"))
		genes_info_manhattan[is.na(genes_info_manhattan)] <- 1
		colnames(genes_info_manhattan)[dim(genes_info_manhattan)[2]] <- "disruptive_missense"

		### synonymous
		results_STAAR <- results_synonymous_genome[,c(1,2,dim(results_synonymous_genome)[2])]

		results_m <- c()
		for(i in 1:dim(results_STAAR)[2])
		{
			results_m <- cbind(results_m,unlist(results_STAAR[,i]))
		}

		colnames(results_m) <- colnames(results_STAAR)
		results_m <- data.frame(results_m,stringsAsFactors = FALSE)
		results_m[,2] <- as.numeric(results_m[,2])
		results_m[,3] <- as.numeric(results_m[,3])

		genes_info_manhattan <- dplyr::left_join(genes_info_manhattan,results_m,by=c("chromosome_name"="Chr","hgnc_symbol"="Gene.name"))
		genes_info_manhattan[is.na(genes_info_manhattan)] <- 1
		colnames(genes_info_manhattan)[dim(genes_info_manhattan)[2]] <- "synonymous"

		## ylim
		coding_minp <- min(genes_info_manhattan[,(dim(genes_info_manhattan)[2]-4):dim(genes_info_manhattan)[2]])
		min_y <- ceiling(-log10(coding_minp)) + 1

		pch <- c(0,1,2,3,4)
		figure1 <- manhattan_plot(genes_info_manhattan[,2], (genes_info_manhattan[,3]+genes_info_manhattan[,4])/2, genes_info_manhattan$plof,sig.level=alpha,pch=pch[1],col = c("blue4", "orange3"),ylim=c(0,min_y),
                          auto.key=T,key=list(space="top", columns=5, title="Functional Category", cex.title=1, points=TRUE,pch=pch,text=list(c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"))))

		figure2 <- manhattan_plot(genes_info_manhattan[,2], (genes_info_manhattan[,3]+genes_info_manhattan[,4])/2, genes_info_manhattan$plof_ds,sig.level=alpha,pch=pch[2],col = c("blue4", "orange3"),ylim=c(0,min_y),
                          auto.key=T,key=list(space="top", columns=5, title="Functional Category", cex.title=1, points=TRUE,pch=pch,text=list(c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"))))

		figure3 <- manhattan_plot(genes_info_manhattan[,2], (genes_info_manhattan[,3]+genes_info_manhattan[,4])/2, genes_info_manhattan$missense,sig.level=alpha,pch=pch[3],col = c("blue4", "orange3"),ylim=c(0,min_y),
                          auto.key=T,key=list(space="top", columns=5, title="Functional Category", cex.title=1, points=TRUE,pch=pch,text=list(c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"))))

		figure4 <- manhattan_plot(genes_info_manhattan[,2], (genes_info_manhattan[,3]+genes_info_manhattan[,4])/2, genes_info_manhattan$disruptive_missense,sig.level=alpha,pch=pch[4],col = c("blue4", "orange3"),ylim=c(0,min_y),
                          auto.key=T,key=list(space="top", columns=5, title="Functional Category", cex.title=1, points=TRUE,pch=pch,text=list(c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"))))

		figure5 <- manhattan_plot(genes_info_manhattan[,2], (genes_info_manhattan[,3]+genes_info_manhattan[,4])/2, genes_info_manhattan$synonymous,sig.level=alpha,pch=pch[5],col = c("blue4", "orange3"),ylim=c(0,min_y),
                          auto.key=T,key=list(space="top", columns=5, title="Functional Category", cex.title=1, points=TRUE,pch=pch,text=list(c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"))))

		print("Manhattan plot")

		png(paste0(output_path,"gene_centric_coding_manhattan.png"), width = 9, height = 6, units = 'in', res = 600)

		print(figure1)
		print(figure2,newpage = FALSE)
		print(figure3,newpage = FALSE)
		print(figure4,newpage = FALSE)
		print(figure5,newpage = FALSE)

		dev.off()
	}


	## Q-Q plot
	if(QQ_plot)
	{
		print("Q-Q plot")
		cex_point <- 1

		png(paste0(output_path,"gene_centric_coding_qqplot.png"), width = 9, height = 9, units = 'in', res = 600)

		## pLoF
		observed <- sort(genes_info_manhattan$plof)
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		# par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=0, cex=cex_point, xlim = c(0, 5), ylim = c(0, min_y),
				xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
				font.lab=2,cex.lab=1,cex.axis=1,font.axis=2)

		abline(0, 1, col="red",lwd=1)

		## pLoF_DS
		observed <- sort(genes_info_manhattan$plof_ds)
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		par(new=T)
		# par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=1, cex=cex_point, xlim = c(0, 5), ylim = c(0, min_y),
				xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
				font.lab=2,cex.lab=1,cex.axis=1,font.axis=2)

		abline(0, 1, col="red",lwd=1)

        ## missense
		observed <- sort(genes_info_manhattan$missense)
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		par(new=T)
		# par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=2, cex=cex_point, xlim = c(0, 5), ylim = c(0, min_y),
				xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
				font.lab=2,cex.lab=1,cex.axis=1,font.axis=2)

		abline(0, 1, col="red",lwd=1)

		## disruptive_missense
		observed <- sort(genes_info_manhattan$disruptive_missense)
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))

		par(new=T)
		# par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=3, cex=cex_point, xlim = c(0, 5), ylim = c(0, min_y),
				xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
				font.lab=2,cex.lab=1,cex.axis=1,font.axis=2)

		abline(0, 1, col="red",lwd=1)

		## synonymous
		observed <- sort(genes_info_manhattan$synonymous)
		lobs <- -(log10(observed))

		expected <- c(1:length(observed))
		lexp <- -(log10(expected / (length(expected)+1)))


		par(new=T)
		# par(mar=c(5,6,4,4))
		plot(lexp,lobs,pch=4, cex=cex_point, xlim = c(0, 5), ylim = c(0, min_y),
				xlab = expression(Expected ~ ~-log[10](italic(p))), ylab = expression(Observed ~ ~-log[10](italic(p))),
				font.lab=2,cex.lab=1,cex.axis=1,font.axis=2)

		abline(0, 1, col="red",lwd=1)

		legend("topleft",legend=c("pLoF","pLoF+D","Missense","Disruptive Missense","Synonymous"),ncol=1,bty="o",box.lwd=1,pch=0:4,cex=1,text.font=2)

		dev.off()
	}

}


