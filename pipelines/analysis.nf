#!/usr/bin/env nextflow                                                         
nextflow.preview.dsl=2                                                          
workflow {                                                                      
////////////////////////////////////                                            
////////// Define parameters ///////                                            
////////////////////////////////////                                            
// Include modules       
include {KINSHIP_HAPFLK; EMPIRICAL_HAPFLK; TREEMIX_HAPFLK; TREEMIX} from "../modules/analysis"
include {TREEMIX_INPUT; MAF_FILTER } from "../modules/wrangling"

/// Read config file parameters    
data_dir=params.data_dir                            /// data folder                                             
K=params.K                                  /// K for fasPHASE                  
reynold_snps=params.reynold_snps            /// Snps for tree estimation        
nfit=params.nfit                            /// Number of fits to average from (hapFLK)
edges=params.edges                           /// Number of migration edges for computing with treemix
bootstrap=params.bootstrap                  /// bootstrap replicates for treemix


//////////////////////////////////                                              
//////// Begin pipeline //////////                                              
////////////////////////////////// 
/// Read input files and folders

data = Channel                                                                         
        .fromFilePairs("./${data_dir}/*/genotypes_*.{bed,bim,fam}", size: 3, flat: true )       
        .map { bfiles ->                                                            
            def scenario = bfiles.get(1).getParent().toString().tokenize('/').last()
            def rep_id = bfiles.get(0).tokenize("_").last()                         
            return   tuple( scenario, rep_id, bfiles ).flatten()                                           
        }                                                                          
     

/// MAF filter
MAF_FILTER( data )
// TREEMIX---------------------------------                                     
/// Prepare treemix input (LD filtering and wrangling)                          
TREEMIX_INPUT( data )                                                 
TREEMIX( TREEMIX_INPUT.out )                      
// HAPFLK COMPUTATION--------------------------------------------               
// Empirical hapFLK                                                             
/// Compute hapFLK using empricial estimation of kinship matrix              
KINSHIP_HAPFLK(MAF_FILTER.out)                                                
// Theoretical hapFLK                                                           
/// Compute hapFLK using theoretical covariance matrix                          
THEORETICAL_HAPFLK( MAF_FILTER.out ) 
// Covariance hapFLK                                                            
/// Compute hapFLK using estimated covariance matrix as kinship                 
EMPIRICAL_HAPFLK( MAF_FILTER.out )                                             
// Treemix covariance                                                           
/// Compute hapFLK using treemix estimated covariance matrix                    
treemix_in = MAF_FILTER.out.join(TREEMIX.out, remainder:true, by: [0,1] )                                                                       
TREEMIX_HAPFLK( treemix_in )                         
                                                                                
                                                                                
}                                                                       


