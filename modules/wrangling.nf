process PREPROCESS {

    publishDir "${params.outdir}/${params.scenario}-s${s}-m${m}-cond${params.conditioned_frequency}-${params.sampling_scheme}-${params.ne_variation}"   , pattern:"genotypes_*" , mode: "move" 
    cpus 1
    scratch true
                                                                               
    input:                                                                      
        tuple val(rep_id), val(s), val(m), file(vcfs)
    output:                                                                     
        tuple val(rep_id), file("genotypes_${rep_id}.bed"), file("genotypes_${rep_id}.fam"),file("genotypes_${rep_id}.bim")
        
                                                                                
   
    
    """                                                                         
    merge-vcf --outfile genotypes_${rep_id}.vcf
    plink --vcf genotypes_${rep_id}.vcf --id-delim : --make-bed --out genotypes_${rep_id} 
    mv genotypes_${rep_id}.bed geno.bed                                         
    mv genotypes_${rep_id}.fam geno.fam                                         
    mv genotypes_${rep_id}.bim geno.bim                                         
                                                                                
    plink --bfile geno --maf 0.1 --nonfounders --make-bed --out genotypes_${rep_id}    
    """    

}


process COLLECT_PARAMETERS {

    publishDir "$params.outdir", mode: "move"

    input:
        file(table)

    output:
        file("parameters.csv")

    """
    collect-parameters.py --out parameters.csv --extension .csv
    """
        

}



process AGGREGATE{                                                              
                                                                                
    publishDir "$params.outdir", mode: "move"                                   
                                                                                
                                                                                
    input:                                                                      
        file(kinship)                                                          
        file(theoretical)                                                        
        file(empirical)
        file(treemix)                                                           

                                                                                
    output:                                                                     
        file("*.tab.gz")                                                           
                                                                                
                                                                                
    """                                                                         
    aggregate.R ${params.scenario}                                              
    """                                                                         
                                                                                
}                                                                               


process TREEMIX_INPUT {                                                         
                                                                                
    scratch true                                                                
                                                                                
    input:                                                                      
        tuple val(scenario), val(rep_id),val(basename), file(bed), file(bim), file(fam)                                            
    output:                                                                     
        tuple val(scenario), val(rep_id), file("*.counts.gz")                                  
                                                                                
                                                                                                                                                                
    """                                                                          
    plink --bfile genotypes_${rep_id} --indep-pairwise 100 50 0.1 -out ld       
    plink --bfile genotypes_${rep_id} --extract ld.prune.in --make-bed --out genotypes_${rep_id}_ldpruned
    plink --bfile genotypes_${rep_id}_ldpruned --freq --family --out genotypes_${rep_id}
    prepare-treemix.py genotypes_${rep_id}.frq.strat genotypes_${rep_id}.counts.gz 
    """                                                                                                                                                     
}      

process MAF_FILTER {                                                            
                                                                                
    cpus 1                                                
    scratch true                      
                                                                                
    input:                                                                      
        tuple val(scenario) , val(rep_id), val(basename), file(bed), file(bim), file(fam)                      
                                                                                
    output:                                                                     
        tuple val(scenario), val(rep_id), file("genotypes_${rep_id}.bed"), file("genotypes_${rep_id}.bim"),file("genotypes_${rep_id}.fam")
                                                                                
                                                                                
    """                                                                         
    mv genotypes_${rep_id}.bed geno.bed                                         
    mv genotypes_${rep_id}.fam geno.fam                                         
    mv genotypes_${rep_id}.bim geno.bim                                         
                                                                                
    plink --bfile geno --maf 0.1 --nonfounders --make-bed --out genotypes_${rep_id}
    """                                                                         
                                                                                
}                                                                               
    




process COLLECT_FREQUENCIES {

    publishDir "${params.outdir}"   , pattern:"frequencies_*.tsv" , mode: "move"
    
    cpus 1

    input:
        file(freqfile)
    output:
        file("frequencies_*.tsv")

    """
    collect-frequencies.py . --out frequencies_${params.scenario}.tsv
    """           
 



}



 
