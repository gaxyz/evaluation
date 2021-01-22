process PREPROCESS {

    publishDir "${params.outdir}/genotypes"   , pattern:"genotypes_*" , mode: "copy"

    scratch true
                                                                               
    input:                                                                      
        tuple val(rep_id), file(vcfs), file(m2_status)                          
    output:                                                                     
        tuple val(rep_id), file("genotypes_${rep_id}.bed"), file("genotypes_${rep_id}.fam"),file("genotypes_${rep_id}.bim")
        tuple val(rep_id), file("parameters_${rep_id}.csv")                      
                                                                                
    when:                                                                       
        m2_status.name == "M2_ESTABLISHED"                                      
    """                                                                         
    merge-vcf --outfile genotypes_${rep_id}.vcf
    plink --vcf genotypes_${rep_id}.vcf --id-delim : --make-bed --out genotypes_${rep_id} 
    mv genotypes_${rep_id}.bed geno.bed                                         
    mv genotypes_${rep_id}.fam geno.fam                                         
    mv genotypes_${rep_id}.bim geno.bim                                         
                                                                                
    plink --bfile geno --maf 0.1 --nonfounders --make-bed --out genotypes_${rep_id}    

    generate_parameter_file.py \
                    --replicate ${rep_id} \
                    --neutral ${params.neutral}       \
                    --s ${params.scoef} \
                    --m ${params.mprop} \
                    --cond_freq ${params.conditioned_frequency} \
                    --sampling ${params.sampling_scheme} \
                    --ne_variation ${params.ne_variation} \
                    --out parameters_${rep_id}.csv
                                            
    """    

}
