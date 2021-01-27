#!/usr/bin/env nextflow                                                         
nextflow.preview.dsl=2                                                          
workflow {                                                                      
                   
include {SIMULATE} from "../modules/simulation"
include {PREPROCESS; COLLECT_PARAMETERS} from "../modules/wrangling"



/// Read config file parameters                                                 
replicates = params.replicates              /// how many simulation replicates  
scenario = params.scenario                  /// String for scenario name for data processing purposes
scoef=params.scoef                          /// Selection coefficient
mprop=params.mprop                          /// Admixture proportion
conditioned_frequency=params.conditioned_frequency                       /// Conditioned m2 frquency
sampling_scheme=params.sampling_scheme      /// Sampling scheme
ne_variation=params.ne_variation            /// Ne variation (possible bottlenecks)
N=params.N                                  /// Individual population size Ne=2*N
sample_size=params.sample_size              /// Final sampling size (per population)


outdir = params.outdir                      /// Output directory name           
slim_script = file(params.slim_script)      /// Slim script for simulation 

//////////////////////////////////                                              
//////// Begin pipeline //////////                                              
//////////////////////////////////                                              
                                                                                
                                                                                
// Generate replicate channels                                                        
rep_id = Channel.from(1..replicates)
// Merge with other parameters
s = Channel.fromList( params.scoef )
m = Channel.fromList( params.mprop )

pars = rep_id.combine(s).combine(m)


// SIMULATION-------------------                                                                               
SIMULATE( slim_script, pars  )                                                
vcf = SIMULATE.out                                                         

// PREPROCESS

PREPROCESS( vcf ) 
parameter_data = PREPROCESS.out[1]

// COLLECT PARAMETER DATA

COLLECT_PARAMETERS( parameter_data.collect() )
























}
