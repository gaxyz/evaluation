process SIMULATE{                                                               
                                       

    publishDir "${params.outdir}/${params.scenario}-s${s}-m${m}-cond${params.conditioned_frequency}-${params.sampling_scheme}-${params.ne_variation}"   , pattern:"frequencies_*.mut" , mode: "move"                                         
                                                                                
    cpus 1          

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
    
    aggregate-frequencies.py . frequencies_${rep_id}.mut         
    """                                                                         
                                                                                
}                                                                               
                                                                                
                     
