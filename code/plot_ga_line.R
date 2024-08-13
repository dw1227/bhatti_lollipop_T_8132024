library(tidyverse)
library(readxl)
library(tidytext)
library(vioplot)

# Function to extract parts of a number
extract_weeks_days<- function(GA) {
  tibble(
    GAw= as.numeric(str_split_i(GA,"\\.",1)),
    GAd=as.numeric(str_split_i(GA,"\\.",2))) %>% 
    mutate(GAd= ifelse(is.na(GAd),0,GAd),
           GA=((GAw*7)+GAd)/7) %>% 
  pull(GA)
}




ano_wide<- read_xlsx("data/PTB_timepoints_KW.xlsx") %>% 
  mutate(Group_main=ifelse(`GA at Delivery`<37,"PTB","Control"))



ano<- ano_wide %>% 
  pivot_longer(cols=`GA1`:`GA5`,
               names_to="Time",
               values_to="GA") %>% 
  mutate(
    GA = case_when(
      GA < 0 ~ NA_real_,
      GA > 45 ~ NA_real_,
      TRUE ~ GA)) %>%   
  filter(!is.na(GA)) %>% 
  mutate(GA=map_dbl(GA,extract_weeks_days),
         `GA at Delivery`=map_dbl(`GA at Delivery`,extract_weeks_days)) %>% 

  filter(! `PTB Type` %in% "indicated") %>% 
  mutate(Group=if_else(PTB =="yes","sPTB","Control")) %>% 
  mutate(Group5= case_when(
    Group=="sPTB"&`GA at Delivery`<34~"sPTB_Early",
    Group=="sPTB"&`GA at Delivery`>=34~"sPTB_Late",
    TRUE ~ Group),
    ID=as.character(ID)
        )

  
 g_dot_chart<- ano %>%
    
    mutate(Group = Group5,
           ID= reorder_within(ID,GA, Group)) %>%
    ggplot() +
    geom_segment(aes(x=ID, xend=ID, y=GA, yend=`GA at Delivery`), color="gray")  +
    geom_point(aes(x=ID, y=GA,color="Amniocentesis",shape="Amniocentesis")) +
    geom_point(aes(x=ID, y=`GA at Delivery`,color="Delivery",shape="Delivery")) +
    geom_hline(yintercept=c(24, 28, 32,37), col="blue") +
    labs(x="Patients",y="Gestational age (weeks)")+
    coord_flip()+
    theme_bw() +
    scale_x_reordered()+
    scale_y_continuous(breaks = seq(8,42,2),limits = c(6, 43))+
    scale_colour_manual(name="",values = c("grey38","darkgreen"),
                        breaks = c("Amniocentesis","Delivery"),
                        labels=c("Gestational age at sample","Gestational age at delivery"))+
    scale_shape_manual(name="",values = c(16,6),breaks = c("Amniocentesis","Delivery"),
                       labels=c("Gestational age at sample","Gestational age at delivery"))+
    theme(legend.position="bottom",
          axis.text.y = element_blank(),
          axis.ticks.y =element_blank() )+
    facet_wrap(~Group, ncol=1, scale="free")+
   theme(strip.background.x = element_rect(fill = "white",colour = "black"))


 # Violen Plot using ggplot2
 # Calculate the number of unique patients (pts) and samples (smps) for each group
 summary_data <- ano %>%
   group_by(Group5) %>%
   summarise(
     pts = n_distinct(ID),
     smps = n()
   ) 
 
 # Create labels for the plot
 lbs <- summary_data %>%
   mutate(
     label = str_c(Group5, "\nN=", pts, "\nn=", smps)
   ) %>%
   pull(label)
 
 g_violen<- ggplot(ano, aes(x = Group5, y = GA)) +
   geom_violin(aes(fill = Group5), 
               color = "black", 
               trim = T) +
   geom_boxplot(width=0.1,fill="black",color="white")+
   scale_fill_manual(values = c("Control" = "blue", 
                                "sPTB_Early" = "grey", 
                                "sPTB_Late" = "red")) +
   scale_x_discrete(labels = lbs) +
   labs(
     x = NULL,
     y = "Gestational age at sample (weeks)",
     title = ""
   ) +
   theme_bw()+
   theme(legend.position = "none")
 
 pdf("results/Figure_GAsample_MOD.pdf")
 

 g_dot_chart
 
 # g_violen
 pts=c(length(unique(ano$ID[!duplicated(ano$ID)&ano$Group5=="Control"])),
       length(unique(ano$ID[!duplicated(ano$ID)&ano$Group5=="sPTB_Early"])),
       length(unique(ano$ID[!duplicated(ano$ID)&ano$Group5=="sPTB_Late"])))
 
 smps=c(length((ano$ID[ano$Group5=="Control"])),
        
        length((ano$ID[ano$Group5=="sPTB_Early"])),length((ano$ID[ano$Group5=="sPTB_Late"])))
 
 lbs=paste(c("Control","sPTB_Early","sPTB_Late"),paste(c("N=","N=","N="),pts),
           
           paste(c("n=","n=","n="),smps),sep="\n")
 
 vioplot(GA~Group5,ano,main="",names=lbs,xlab=NULL,ylab="Gestational age at sample (weeks)",
         
         col=c("blue","grey","red"))

dev.off()




