process KINSHIP_HAPFLK{                                                       
    publishDir "${params.outdir}/${scenario}/" , mode: "move"                                                                  

                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(scenario), val(rep_id) , file(bed), file(bim), file(fam)                     
    output:                                                                     
        tuple val(scenario) ,val(rep_id) , file("*.flk"), file("*.hapflk"), file("*_fij.txt")  
                                                                                
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
    publishDir "${params.outdir}/${scenario}/", mode: "move"                                           

                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(scenario), val(rep_id) , file(bed), file(bim), file(fam)                     
    output:                                                                     
        tuple val(scenario), val(rep_id) , file("*.flk"), file("*.hapflk"), file("*_fij.txt")  
                                                                                
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






process TREEMIX_HAPFLK {                                                        
    publishDir "${params.outdir}/${scenario}/"  , mode: "move"                                                                                               

                                                                                
    cpus 5                                                                      
                                                                                
    input:                                                                      
        tuple val(scenario), val(rep_id), file(bed), file(bim), file(fam), file(covariance)    
                                                                                
    output:                                                                     
        tuple val(scenario), val(rep_id) , file("*.flk"), file("*.hapflk")                     
                                                                                
    """                                                                         
    hapflk --ncpu ${task.cpus} \
            --reynolds-snps ${params.reynold_snps} \
            --bfile genotypes_${rep_id} \
            --prefix treemix_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --nfit ${params.nfit} \
            --kinship ${covariance}                                             
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
            --prefix theoretical_calibration_${rep_id} \
            --outgroup p1 \
            -K ${params.K} \
            --nfit ${params.nfit} \
            --kinship ${covariance}                                             
    """                                                                         
                                                                                
}       
              


process TREEMIX {                                                               
                                                                                
    cpus 1                                                                      
                                                                                
    input:                                                                      
        tuple val(scenario), val(rep_id), file(countfile)                                      
                                                                                
    output:                                                                     
        tuple val(scenario), val(rep_id), file("*_covariance.tab")                             
                                                                                
                                                                                
                                                                                
    """                                                                         
    treemix -i ${countfile} \
            -m ${params.edges} \
            -o ${rep_id}_${params.edges}  \
            -bootstrap -k ${params.bootstrap}                                   
                                                                                
    prepare-modelcov.py ${rep_id}_${params.edges}.modelcov.gz ${rep_id}_${params.edges}_covariance.tab 
    
   
    """                                                                         
                                                                                
}                                                                               
        
