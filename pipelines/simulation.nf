#!/usr/bin/env nextflow                                                         
nextflow.preview.dsl=2                                                          
workflow {                                                                      
                   
include {SIMULATE} from "../modules/simulation"
include {PREPROCESS} from "../modules/wrangling"



/// Read config file parameters                                                 
replicates = params.replicates              /// how many simulation replicates  
scenario = params.scenario                  /// String for scenario name for data processing purposes
scoef=params.scoef                          /// Selection coefficient
mprop=params.mprop                          /// Admixture proportion
conditioned_frequency=params.conditioned_frequency                       /// Conditioned m2 frquency
sampling_scheme=params.sampling_scheme      /// Sampling scheme
ne_variation=params.ne_variation            /// Ne variation (possible bottlenecks)



outdir = params.outdir                      /// Output directory name           
slim_script = file(params.slim_script)      /// Slim script for simulation 

//////////////////////////////////                                              
//////// Begin pipeline //////////                                              
//////////////////////////////////                                              
                                                                                
                                                                                
// Generate replicate channels                                                  
                                                                                
rep_id = Channel.from(1..replicates)

// SIMULATION-------------------                                                
                                                                                
SIMULATE( slim_script, rep_id  )                                                
vcf = SIMULATE.out                                                           


// PREPROCESS

PREPROCESS( vcf ) 
























}
