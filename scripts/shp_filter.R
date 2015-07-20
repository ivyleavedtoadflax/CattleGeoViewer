


epping_data %>% 
  filter(!is.na(fairmead_filter)) %>% 
  group_by(year, device) 


fairmead_EK3_filter
fairmead_HC_13_filter
  

epping_data %>% 
  filter(
    !is.na(fairmead_filter),
    year == 2013
    ) %>% 
  group_by(
    year, device
    ) %>%
  summarise(
    n = n()
  ) %>%
  filter(
    n > 0
    ) %$%
  device
