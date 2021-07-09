

library(plyr)
library(ggplot2)
setwd('C:\\Users\\Vaibhav\\OneDrive\\Documents\\NEU-CPS\\2nd Sem\\ALY 6070')
df <- read.csv("clean_data.csv")

head(df)

#lapply(df,function(x){})

# length(unique(df$status))

#if(df$borough == 'Manhattan' && df$health == 'Fair'){
#sum(df[,'status'] == 'Dead') %>% filter(df$borough == 'Manhattan' && df$health == 'Fair')

z <-data.frame(table(df$status))
z
ggplot(z, aes(x = reorder(z$Var1,z$Freq), y = z$Freq)) + 
  geom_bar(stat="identity", fill="gold1", colour="black") +
  theme_bw(base_size = 10)+
  labs(title="z", x ="Birth Country", y = "Frequency") 
 
table(df$status)
