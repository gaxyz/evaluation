process KINSHIP_HAPFLK{                                                       
                                                                                
    scratch true                                                                
                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(rep_id) , file(bed), file(fam), file(bim)                     
    output:                                                                     
        tuple val(rep_id) , file("*.flk"), file("*.hapflk"), file("*_fij.txt")  
                                                                                
    """                                                                         
    hapflk --ncpu ${task.cpus} \
            --reynolds-snps ${params.reynold_snps} \
            --bfile genotypes_${rep_id} \
            --prefix kinship_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --reynolds \
            --nfit ${params.nfit}                                               
    """                                                                         
}                 


process EMPIRICAL_HAPFLK {                                                     
                                                                                
    scratch true                                                                
                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(rep_id) , file(bed), file(fam), file(bim)                     
    output:                                                                     
        tuple val(rep_id) , file("*.flk"), file("*.hapflk"), file("*_fij.txt")  
                                                                                
    """                                                                         
    hapflk --ncpu ${task.cpus} \
            --reynolds-snps ${params.reynold_snps} \
            --bfile genotypes_${rep_id} \
            --prefix empirical_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --covkin \
            --reynolds \
            --nfit ${params.nfit}                                               
    """                                                                         
                                                                                
                                                                                
}       




process THEORETICAL_HAPFLK{                                                     
                                                                                
    scratch true                                                                
                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(rep_id), file(bed), file(fam), file(bim)                      
        file(covariance)                                                        
    output:                                                                     
        tuple val(rep_id) , file("*.flk"), file("*.hapflk")                     
                                                                                
    """                                                                         
    hapflk --ncpu ${task.cpus} \
            --reynolds-snps ${params.reynold_snps} \
            --bfile genotypes_${rep_id} \
            --prefix theoretical_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --nfit ${params.nfit} \
            --kinship ${covariance}                                             
    """                                                                         
                                                                                
}                



process TREEMIX_HAPFLK {                                                        
                                                                                
    scratch true                                                                
                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(rep_id), file(bed), file(fam), file(bim), file(covariance)    
                                                                                
    output:                                                                     
        tuple val(rep_id) , file("*.flk"), file("*.hapflk")                     
                                                                                
    """                                                                         
    hapflk --ncpu ${task.cpus} \
            --reynolds-snps ${params.reynold_snps} \
            --bfile genotypes_${rep_id} \
            --prefix treemix_calibration_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --nfit ${params.nfit} \
            --kinship ${covariance}                                             
    """                                                                         
}                                                                               
              


process TREEMIX {                                                               
                                                                                
    cpus 1                                                                      
                                                                                
    input:                                                                      
        tuple val(rep_id), file(countfile)                                      
                                                                                
    output:                                                                     
        tuple val(rep_id), file("*_covariance.tab")                             
                                                                                
                                                                                
                                                                                
    """                                                                         
    treemix -i ${countfile} \
            -m ${params.edges} \
            -o ${rep_id}_${params.edges}  \
            -root p1 \
            -bootstrap -k ${params.bootstrap}                                   
                                                                                
                                                                                
    prepare-modelcov.py ${rep_id}_${params.edges}.modelcov.gz ${rep_id}_${params.edges}_covariance.tab --outgroup p1
    """                                                                         
                                                                                
}                                                                               
        
