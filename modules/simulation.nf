process SIMULATE{                                                               
                                                                                
                                                                                
    cpus 1          
    scratch true                                                            
    input:                                                                      
        file(slim_script)                                                       
        val(rep_id)                                                             
    output:                                                                     
        tuple val(rep_id) , file("*.vcf")                         
        
                                                                                
    """                                                                         
    slim -d s=$params.scoef \
        -d m=${params.mprop} \
        -d condfreq=${params.conditioned_frequency} \
        -d rep_id=${rep_id} \
        ${slim_script}          
    """                                                                         
                                                                                
}                                                                               
                                                                                
                     
