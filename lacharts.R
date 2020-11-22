library("tidyverse")
library("lubridate")
library("parallaxr")

download.file("https://www.opendata.nhs.scot/dataset/b318bddf-a4dc-4262-971f-0ba329e09b87/resource/427f9a25-db22-4014-a3bc-893b68243055/download/trend_ca_20201117.csv", "ladata.csv")

# read data

dflachart <- read_csv("ladata.csv") %>%
  mutate(date2=ymd(Date)) %>%
  filter(month(date2)>7 & year(date2) > 2019) 


plotglachart <- dflachart %>%
  filter(CA=="S12000049") %>%
  ggplot(aes(x=date2, y=DailyPositive)) +
           geom_col() +
           ylab("Daily Cases") +
           xlab("") +
           scale_x_date(date_labels = "%B") +
  theme(axis.text.x=element_text(size=5, angle = 45, hjust = 1),
        axis.text.y=element_text(size=5),
        axis.title.y=element_blank())
ggsave("gla.png",   
       width = 4,
       height = 4,
       units = c("cm"))


plotedchart <- dflachart %>%
  filter(CA=="S12000036") %>%
  ggplot(aes(x=date2, y=DailyPositive)) +
  geom_col() +
  ylab("Daily Cases") +
  xlab("") +
  scale_x_date(date_labels = "%B") +
  theme(axis.text.x=element_text(size=5, angle = 45, hjust = 1),
      axis.text.y=element_text(size=5),
      axis.title.y=element_blank())
ggsave("ed.png",   
       width = 4,
       height = 4,
       units = c("cm"))



##  MD files
all_md_str <- list.files(pattern=".md", full.names = FALSE)


## Loop through each MD file, parse, and return a single tibble
md_tibble <-
  all_md_str %>%
  purrr::map_dfr(parse_md) 

## Output HTML file

generate_scroll_doc(path = "test.html",
                    inputs = md_tibble)
  
