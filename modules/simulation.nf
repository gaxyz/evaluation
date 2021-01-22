process SIMULATE{                                                               
                                                                                
                                                                                
    cpus 1                                                                      
    input:                                                                      
        file(slim_script)                                                       
        val(rep_id)                                                             
    output:                                                                     
        tuple val(rep_id) , file("*.vcf"), file("M2_*")                         
        file("*.tab")                                                           
                                                                                
    """                                                                         
    slim -d neutral=$params.neutral -d rep_id=${rep_id} ${slim_script}          
    """                                                                         
                                                                                
}                                                                               
                                                                                
                     
