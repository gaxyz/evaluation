#!/usr/bin/env nextflow                                                         
nextflow.preview.dsl=2                                                          
workflow {                                                                      
                    

////////////////////////////////////                                            
////////// Define parameters ///////                                            
////////////////////////////////////                                            
// Include modules       
include {EMPIRICAL_HAPFLK; THEORETICAL_HAPFLK; COVARIANCE_HAPFLK; TREEMIX_HAPFLK; TREEMIX} from "../modules/analysis"


/// Read config file parameters                                                 
covariance_matrix = file(params.covariance) /// Covariance matrix for the given demographic scenario
K=params.K                                  /// K for fasPHASE                  
reynold_snps=params.reynold_snps            /// Snps for tree estimation        
nfit=params.nfit                            /// Number of fits to average from (hapFLK)
edges=params.edges                           /// Number of migration edges for computing with treemix
bootstrap=params.bootstrap     

//////////////////////////////////                                              
//////// Begin pipeline //////////                                              
////////////////////////////////// 

// TREEMIX---------------------------------                                     
/// Prepare treemix input (LD filtering and wrangling)                          
TREEMIX_INPUT( MERGE_VCFS.out )                                                 
TREEMIX( TREEMIX_INPUT.out )                                                    
                                                                                
                                                                                
// HAPFLK COMPUTATION--------------------------------------------               
// Empirical hapFLK                                                             
/// Compute hapFLK using empricial estimation of covariance matrix              
EMPIRICAL_HAPFLK(MAF_FILTER.out)                                                
// Theoretical hapFLK                                                           
/// Compute hapFLK using theoretical covariance matrix                          
THEORETICAL_HAPFLK(MAF_FILTER.out, covariance_matrix )                          
// Covariance hapFLK                                                            
/// Compute hapFLK using estimated covariance matrix as kinship                 
COVARIANCE_HAPFLK( MAF_FILTER.out )                                             
// Treemix covariance                                                           
/// Compute hapFLK using treemix estimated covariance matrix                    
treemix_in = MAF_FILTER.out.join(TREEMIX.out, remainder:true)                   
                                                                                
TREEMIX_HAPFLK( treemix_in )                                                    
                                                                                
                                                                                
// AGGREGATE--------------------------------------------                        
// Aggregate results                                                            
/// Aggregate simulation and hapflk results into dataframes for data analysis   
                                                                                
AGGREGATE(  EMPIRICAL_HAPFLK.out.collect(),                                     
            THEORETICAL_HAPFLK.out.collect(),                                   
            COVARIANCE_HAPFLK.out.collect(),                                    
            TREEMIX_HAPFLK.out.collect(),   
            freq_file.collect() )                                               
                                                                                
                                                                                
                                                                                
}                                                                               


   
