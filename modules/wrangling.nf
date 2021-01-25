process PREPROCESS {

    publishDir "${params.outdir}/${params.scenario}-s${s}-m${m}-cond${params.conditioned_frequency}-${params.sampling_scheme}-${params.ne_variation}"   , pattern:"genotypes_*" , mode: "copy"
    cpus 1
    scratch true
                                                                               
    input:                                                                      
        tuple val(rep_id), val(s), val(m), file(vcfs)
    output:                                                                     
        tuple val(rep_id), file("genotypes_${rep_id}.bed"), file("genotypes_${rep_id}.fam"),file("genotypes_${rep_id}.bim")
        tuple val(rep_id), file("parameters_${rep_id}.csv")                      
                                                                                
   
    
    """                                                                         
    merge-vcf --outfile genotypes_${rep_id}.vcf
    plink --vcf genotypes_${rep_id}.vcf --id-delim : --make-bed --out genotypes_${rep_id} 
    mv genotypes_${rep_id}.bed geno.bed                                         
    mv genotypes_${rep_id}.fam geno.fam                                         
    mv genotypes_${rep_id}.bim geno.bim                                         
                                                                                
    plink --bfile geno --maf 0.1 --nonfounders --make-bed --out genotypes_${rep_id}    

    generate_parameter_file.py \
                    --replicate ${rep_id} \
                    --s ${s} \
                    --m ${m} \
                    --cond_freq ${params.conditioned_frequency} \
                    --N ${params.N} \
                    --sample_size ${params.sample_size} \
                    --sampling ${params.sampling_scheme} \
                    --ne_variation ${params.ne_variation} \
                    --out parameters_${rep_id}.csv
                                            
    """    

}
