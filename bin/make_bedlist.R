
f <- read_delim("frequencies.tsv",
	       	delim = " ",
		col_types = cols(
				  generation = col_double(),
  				  pop = col_character(),
				  freq = col_double(),
				  s = col_char(),
				  m = col_char(),
				  rep = col_double()
				)
		)


# view frequencies

f %>%
            filter(generation==7600) %>%
            filter(s!="0.0") %>%
            filter(pop=="p5") %>%
            ggplot(aes(x=freq)) +
            geom_histogram(binwidth = 0.01) +
            facet_wrap(~m+s)



# replicates per regime

f %>%  
	filter(generation==7600) %>% 
        filter(s!="0.0") %>%
        filter(pop=="p5"&freq>=0.4) %>% 
        select(s,m,rep) %>% 
	group_by(s,m) %>%
	summarise(n())


f %>% 
	filter(generation==7600) %>% 
	filter(s!="0.0") %>%
	filter(pop=="p5"&freq>=0.4) %>% 
	select(s,m,rep, freq) %>%
	distinct() %>%
	mutate(bed=paste0("paper-s",s,"-m",m,"-cond0.1-b-b/genotypes_",rep,".bed")) %>%
	mutate(bim=paste0("paper-s",s,"-m",m,"-cond0.1-b-b/genotypes_",rep,".bim")) %>%
	mutate(fam=paste0("paper-s",s,"-m",m,"-cond0.1-b-b/genotypes_",rep,".fam")) %>%
	pivot_longer(cols=c(bim,bed,fam), names_to="filetype", values_to="path")    %>%
	select(path) %>%
	write_delim(., "reps_to_delete.tab", delim=" ")



