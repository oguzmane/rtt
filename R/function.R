
rtt_plotFUN <- function(metric,field) {
  
  read_rds("inst/rtt_admitted.rds") %>% 
    rename(Field=1,
           Metric=all_of(metric)) %>% 
    mutate(Field=gsub(" Service","",Field),
           Field=gsub(" Internal","",Field),
           Field=case_when(grepl("ENT|Ear",Field) ~ "ENT",
                           grepl("Elderly",Field) ~ "Geriatric Medicine",
                           grepl("Trauma",Field) ~ "Trauma & Orthopaedic",
                           grepl("Neurosurgical",Field) ~ "Neurosurgery",
                           grepl("Respiratory",Field) ~ "Thoracic Medicine",
                           grepl("Other",Field) ~ "Other",
                           T ~ Field)) %>% 
    filter(Field!="Other") %>% 
    filter(Field%in%field) %>%
    group_by(Field) %>% 
    e_charts(Date) %>% 
    e_line(Metric) %>% 
    e_tooltip(show=T)
  
}

