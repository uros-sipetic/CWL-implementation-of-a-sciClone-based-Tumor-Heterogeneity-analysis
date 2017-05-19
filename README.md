# CWL-implementation-of-a-sciClone-based-Tumor-Heterogeneity-analysis

Tumor heterogeneity refers to the notion of tumors showing distinct cellular morphological and phenotypic properties which can affect disease progression and response. Next-gen sequencing results from bulk whole exome or whole genome samples can be expanded to infer tumor structure (heterogeneity) using a few different methods. One of these methods, sciClone (Cris Miller, https://github.com/genome/sciclone), was developed for detecting tumor subclones by clustering Variant Allele Frequencies (VAFs) of somatic mutations in copy number neutral regions. 
Presented here is a portable and reproducible Common Workflow Language (CWL) implementation of a sciClone based tumor heterogeneity workflow. The results of sciClone can be directly fed into additional software like ClonEvol and Fishplot, which produce additional visualizations, e.g. phylogenetic trees showing clonal evolution. 
The main idea of the workflow was to build a pipeline that can process standard bioinformatics file types (VCF, BAM) and produce a comprehensive set of outputs describing tumor heterogeneity. Additionally, the workflow is designed to be robust regardless of the number of samples provided.

The workflow consists of sciClone, ClonEvol (Ha Dang, https://github.com/hdng/clonevol), Fishplot (Chris Miller, https://github.com/chrisamiller/fishplot), VCFtools (https://github.com/vcftools/vcftools) for VCF processing and custom parsers that properly create files that sciClone can successfully process. 

The workflow is available as a json file desribing the CWL implementation, and can be imported to any of the engines that are able to run CWL code. 


This workflow has one required input:

    VCF file (ID: *input_files*) - VCF files with called variants

This workflow has four optional inputs:

    Tumor BAM files (ID: bams) - aligned BAM files from sequenced tumor samples

    Copy number calls (ID: copyNumberCalls) - file containing copy number variation data

    GTF file (ID: gtf) - gene annotation file

    Known cancer genes (ID: known_cancer_genes) - database with known cancer genes, like COSMIC

This workflow generates five outputs:

    SciClone plots (ID: *sciclone_plots*) - all plots generated by the SciClone tool.

    ClonEvol plots (ID: *clonevol_plots*) - all plots generated by the ClonEvol tool.

    Fishplot plots (ID: *fishplot_plots*) - all plots generated by the Fishplot tool.

    SciClone clusters summary (ID: clusterSummary) - information about SciClone clusters (namely centroid data).

    Estimated tumor purity (ID: purity) - Estimated sample tumor purity

Common issues

    If multiple samples are provided (in the form of multiple VCF files), accompanying BAM files for each sample should also be provided. In the case of only one sample, a BAM file is not required.
    Under the sciClone parameters, please specify the correct Copy-number caller used to infer the input copy number data (if provided).
    Fishplot currently might not output any plots, if certain requirements are not satisfied in the ClonEvol step.
    A GTF file and a known cancer database (like COSMIC) are optional inputs, as they are used for generating additional plots by the ClonEvol tool.
