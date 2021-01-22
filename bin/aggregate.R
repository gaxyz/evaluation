#!/usr/bin/env Rscript
library(tidyverse)

# Match files in dir------
# hapflk
hapflk_files <- Sys.glob("*_calibration_*.hapflk")
# flk
flk_files <- Sys.glob("*_calibration_*.flk")
# fij
fij_files <- Sys.glob("*_fij.txt")
# simulation data
#
freq_files <- Sys.glob("m2_frequencies_*.tab")

# Set up command line arguments------
args = commandArgs(trailingOnly=TRUE)
scenario = args[1]


# Process hapflk files ------

for (i in 1:length(hapflk_files )){ 
  filename = hapflk_files[i]
  basename = strsplit(filename , "\\.")[[1]][1]
  covariance = strsplit(basename, "_")[[1]][1]
  replicate = strsplit(basename, "_")[[1]][3]
  
  # initialize tibble
  if  ( i == 1 ){  
    hapflk <- read_delim(filename, delim = " ", col_names = TRUE  ) %>%
      mutate(replicate = replicate ) %>%
      mutate(covariance = covariance )
    
  } else {
    h <- read_delim(filename, delim = " ", col_names = TRUE  ) %>%
      mutate(replicate = replicate ) %>%
      mutate(covariance = covariance )
      
    hapflk <- full_join( h, hapflk )
    
  }
}



# Process flk files------
for (i in 1:length(flk_files )){
  filename = flk_files[i]
  basename = strsplit(filename , "\\.")[[1]][1]
  
  covariance = strsplit(basename, "_")[[1]][1]
  replicate = strsplit(basename, "_")[[1]][3]
  # initialize tibble
  if  ( i == 1 ){
    
    flk <- read_delim(filename, delim = " ", col_names = TRUE  ) %>%
      select(-pzero, -pvalue) %>%
      mutate(replicate = replicate ) %>%
      mutate(covariance = covariance )
  } else {
    h <- read_delim(filename, delim = " ", col_names = TRUE  ) %>%
      select(-pzero,-pvalue) %>%
      mutate(replicate = replicate ) %>%
      mutate(covariance = covariance )
    
    flk <- full_join( h, flk )
    
  }
}

# Merge tibbles and write------
final_tbl <- full_join(flk, 
                       hapflk, 
                       by = c("rs", "replicate", "covariance","chr","pos") )

# Write statistics file
statistics_file = paste0(scenario,"_hapflk.tab")
write_delim(final_tbl,
            path = statistics_file,
            delim = " ",
            col_names = TRUE)


# Process fij files------


# Merge into dataframe --------- 
for (i in 1:length(fij_files) ){
  
  filename <- fij_files[i]
  basename <- strsplit(filename, "_fij.txt")[[1]]
  replicate <- tail( strsplit(basename, "_")[[1]], n =  1 )
  m <- read.delim(fij_files[i],header = FALSE, sep = " ")
  colnames(m) <- c("pop", as.character(m$V1))
  
  if ( i ==  1 ){
    final <- as_tibble(m) %>%
      rename( pop_i = pop ) %>%
      pivot_longer(cols = matches("p[0-9]+"),names_to = "pop_j") %>%
      mutate(replicate = replicate )
    
  }else{
    tbl <- as_tibble(m) %>% 
      rename( pop_i = pop ) %>% 
      pivot_longer(cols = matches("p[0-9]+"),names_to = "pop_j") %>% 
      mutate(replicate = replicate )
    
    final <- full_join(final,tbl)
    
  }
  
}
## Factorize
final$pop_j <- factor(final$pop_j)
final$replicate <- factor(final$replicate)


# Write aggregated fij file
F_file = paste0(scenario,"_fij.tab")
write_delim(final,
            path = F_file,
            delim = " ",
            col_names = TRUE)




# Process simulation data------
for (i in 1:length(freq_files)) {
  filename <- freq_files[i]
  basename <- strsplit(filename,"\\.")[[1]][1]
  replicate <- tail(strsplit(basename, "_")[[1]], n =1 )
  
  if (i==1){
    final <- read_delim(filename,delim = " ", col_names = TRUE, col_types=cols(generation=col_integer(),frequency=col_double()) ) %>%
      mutate(replicate = replicate)
  }else{
    tmp <- read_delim(filename,
                      delim = " ", 
                      col_names = TRUE, 
                      col_types=cols(generation=col_integer(),
                                     frequency=col_double() ) ) %>%
                      mutate(replicate = replicate)
    final <- full_join(final, tmp)
  }

}

final$replicate <- factor(final$replicate)



# Write aggregated simulation data
#
#

fq_file = paste0(scenario,"_m2_frequencies.tab")
write_delim(final,
            path = fq_file,
            delim = " ",
            col_names = TRUE)




