process SIMULATE{                                                               
                                                                                
                                                                                
    cpus 1          
    scratch true                                                            
    input:                                                                      
        file(slim_script)                                                       
        tuple val(rep_id), val(s), val(m)                                                             
    output:                                                                     
        tuple val(rep_id), val(s), val(m) , file("*.vcf")                         
        
                                                                                
    """                                                                         
    slim -d s=${s} \
        -d m=${m} \
        -d condfreq=${params.conditioned_frequency} \
        -d rep_id=${rep_id} \
        -d N=${params.N} \
        -d sample_size=${params.sample_size} \
        ${slim_script}          
    """                                                                         
                                                                                
}                                                                               
                                                                                
                     
