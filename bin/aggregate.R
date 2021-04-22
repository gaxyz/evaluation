#!/usr/bin/env Rscript
library(tidyverse)

# Match files in dir------
# hapflk
hapflk_files <- Sys.glob("*.hapflk")
# flk
flk_files <- Sys.glob("*.flk")


# Set up command line arguments------
args = commandArgs(trailingOnly=TRUE)
scenario = args[1]


# Process hapflk files ------

for (i in 1:length(hapflk_files )){ 
  filename = hapflk_files[i]
  basename = strsplit(filename , "\\.")[[1]][1]
  covariance = strsplit(basename, "_")[[1]][1]
  replicate = strsplit(basename, "_")[[1]][2]
  
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
  replicate = strsplit(basename, "_")[[1]][2]
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
statistics_file = paste0(scenario,"_statistics.tab.gz")
write_delim(final_tbl,
            path = statistics_file,
            delim = " ",
            col_names = TRUE)


