
library(shiny)
library(dplyr)
library(plyr)
library(ggplot2)
options(shiny.maxRequestSize=250*1024^2)



function(input,output,session){

df <- reactive({
  
  req(input$upload_data)
  
  tryCatch({
    read.csv(input$upload_data$datapath, input$header, sep = ",")
  },
  error = function(e){
    stop(safeError(e))
  })
  
})


# clean_data <- reactive({
#   
#   req(input$upload_data)
#   
#   tryCatch({
#     na.omit(input$upload_data$datapath)
#     read.csv(input$upload_data$datapath, input$header, sep = ",")
#     
#   },
#   error = function(e){
#     stop(safeError(e))
#   })
#   
# })
z <- reactive({
  
  as.data.frame(table(df()[,'status']))
 
  
})

y <- reactive({
  
  as.data.frame(table(df()[,'spc_common']))
  
  
})

desc_ordered_y <- reactive({
  
    as.data.frame(tail(y()[order(y()[,'Freq']),],20))
  
})

ordered_y <- reactive({
  
  as.data.frame(head(y()[order(y()[,'Freq']),],20))
  
})


x <- reactive({
  
  as.data.frame(table(df()[,'health']))
  
  
})


output$hist_plot <- renderPlot({
  switch(input$hist_species,
         "all_species" = all_species(),
         "top_20" =top_20(),
         "low_20" =low_20()
  )
})
  


output$hist_plot1 <- renderPlot({

  if(input$hist_status == TRUE){
  ggplot(z(), aes(x = reorder(z()[,'Var1'],z()[,'Freq']), y = z()[,'Freq'])) +
    geom_bar(stat="identity", fill="gold1", colour="black") +
    theme_bw(base_size = 10)+
    labs(title="Status Analysis of Trees", x ="Tree Status", y = "Frequency")
}
})

all_species <-  reactive({
  
  ggplot(y(), aes(x = reorder(y()[,'Var1'],y()[,'Freq']), y = y()[,'Freq'])) +
    geom_bar(stat="identity", fill="gold1",width = 0.4, alpha=0.6) + coord_flip() +
    theme_bw(base_size = 10)+
    labs(title="ALl Species", x ="Species", y = "Frequency")
  
})

top_20 <- reactive({
           ggplot(desc_ordered_y(), aes(x = reorder(desc_ordered_y()[,'Var1'],desc_ordered_y()[,'Freq']), y = desc_ordered_y()[,'Freq'])) +
           geom_bar(stat="identity", fill="lightgreen",width = 0.4, alpha=0.6) + coord_flip() +
           theme_bw(base_size = 10)+ theme(text = element_text(size=15),
                                           axis.text.y = element_text(angle=360, hjust=1))+
           labs(title="Highest Number of Species", x ="Species", y = "Frequency")
})

low_20 <- reactive({
  ggplot(ordered_y(), aes(x = reorder(ordered_y()[,'Var1'],ordered_y()[,'Freq']), y = ordered_y()[,'Freq'])) +
           geom_bar(stat="identity", fill="tomato",width = 0.4, alpha=0.6) + coord_flip() +
           theme_bw(base_size = 10)+ theme(text = element_text(size=15),
                                           axis.text.y = element_text(angle=360, hjust=1))+
          labs(title="Lowest Number of Species", x ="Species", y = "Frequency")
})
  
  # output$hist_plot <- renderPlot({
  #   
  #   #desc_ordered_y()
  #   if(input$hist_species == "all_species"){
  #     ggplot(y(), aes(x = reorder(y()[,'Var1'],y()[,'Freq']), y = y()[,'Freq'])) +
  #     geom_bar(stat="identity", fill="gold1", colour="black") + coord_flip() +
  #     theme_bw(base_size = 10)+
  #     labs(title="z", x ="Species", y = "Frequency")
  #   }
  #   
  #   if(input$hist_species == "top_20"){
  #     ggplot(desc_ordered_y(), aes(x = reorder(desc_ordered_y()[,'Var1'],desc_ordered_y()[,'Freq']), y = desc_ordered_y()[,'Freq'])) +
  #       geom_bar(stat="identity", fill="gold1", colour="black") + coord_flip() +
  #       theme_bw(base_size = 10)+
  #       labs(title="z", x ="Species", y = "Frequency")
  #   }
  #   
  #   if(input$hist_species == "low_20"){
  #     ggplot(ordered_y(), aes(x = reorder(ordered_y()[,'Var1'],ordered_y()[,'Freq']), y = ordered_y()[,'Freq'])) +
  #       geom_bar(stat="identity", fill="gold1", colour="black") + coord_flip() +
  #       theme_bw(base_size = 10)+
  #       labs(title="z", x ="Species", y = "Frequency")
  #   }
  #   
  # })

  
  output$hist_plot2 <- renderPlot({
    if(input$hist_health == TRUE){
      ggplot(x(), aes(x = reorder(x()[,'Var1'],x()[,'Freq']), y = x()[,'Freq'])) +
        geom_bar(stat="identity", fill="tomato", colour="black") +
        theme_bw(base_size = 10)+
        labs(title="Health Analysis of Tree", x ="Health Status", y = "Frequency")
    }
  })



 

observeEvent(input$submit,{
  updateTabsetPanel(session,inputId = "inTabset",selected =  "panel3")
    output$contents <-renderTable({
    isolate(head(df(),input$display_rows))
  })
  
})

observeEvent(input$null_value,{
  output$disp_value <- renderText({
   return(isolate(sum(is.na(df()))))
  })
})
  
observeEvent(input$total_rows,{
  output$disp_value <- renderText({
    return(isolate(nrow(df())))
  })
})

observeEvent(input$stats,{
  updateTabsetPanel(session,inputId = "inTabset",selected =  "panel2")
  output$summary <- renderText({
        return(isolate(summary(df())))
  })
})

#-------------------------------------------------------------------------------
#radio button logic

# d <- reactive({
#   distx <- switch(input$distx,
#                  norm = rnorm,
#                  unif = runif,
#                  lnorm = rlnorm,
#                  exp = rexp,
#                  rnorm)
#   
#   distx(input$n)
# })



# output$plot <- renderPlot({
#   dist <- input$dist
#   n <- input$n
# 
#   hist(d(),
#        main = paste("r", dist, "(", n, ")", sep = ""),
#        col = "#75AADB", border = "white")
# })


#histograms---------------------------------------------------------------------
data1 <- reactive({
     input$attri
  })

output$plot <- renderPlot({
  req(data1())
  n <- input$n
  #hist(df()[,data1()], main = input$attri)
 hist(df()[,data1()], xlab = input$attri,
      breaks = n, col = "#75AADB", border = "white", main = paste(data1(),"Histogram"))
 # if(input$distx=="norm"){
 #   rnorm(hist(df()[,data1()],breaks = n, col = "#75AADB", border = "white", main = data1()))
 # }
 #  
 #  if(input$distx=="unif"){
 #    runif(hist(df()[,data1()],breaks = n, col = "#75BBDB", border = "white", main = data1()),min = 0, max = 1)
 #  }
 #  
 #  if(input$distx=="lnorm"){
 #    rlnorm(hist(df()[,data1()],breaks = n, col = "#75CCDB", border = "white", main = data1()),meanlog = 0,sdlog = 10)
 #  }
 #  
 #  if(input$distx=="exp"){
 #    rexp(hist(df()[,data1()],breaks = n, col = "#75DDDB", border = "white", main = data1()),rate = 5)
 #  }

  
}) 

#scatterplots-------------------------------------------------------------------

data2 <- reactive({
  input$xcol
})

data3 <- reactive({
  input$ycol
})

output$main <- renderPlot({
  req(data2())
  req(data3())
  a <- input$xcol
  b <- input$ycol
  #barplot(input$xcol,input$ycol)
  #ggplot(df(), aes(x = input$xcol, y = input$ycol)) + geom_point()
   #plot(df()[,a],df()[,b])
  
  if(input$smooth == TRUE){
    ggplot(df(),aes(df()[,a], df()[,b], color=df()[,a])) +
      geom_point() + geom_smooth(method = lm) +xlab(a) + ylab(b)+ ggtitle(paste(a,"Vs",b))
  
  }else{
    ggplot(df(),aes(df()[,a], df()[,b], color=df()[,a])) +
      geom_point() +  theme_bw() +xlab(a) + ylab(b) + ggtitle(paste(a,"Vs",b))
  }
})  

# output$borough_name <- renderPrint({
#   
#   return(input$borough)
#   
# })

output$total_species <- renderPrint({
  
  return(sum(df()[,'spc_common']== input$species))
  
  
})

output$total_status <- renderPrint({

    return(sum(df()[,'status']== input$status))
  

  })
output$health_status <- renderPrint({
  #if(df()[,'status']==input$status && df()[,'borough']==input$borough){
    return(sum(df()[,'health']==input$health))
  
})
 
# z <- reactive({
#   table(df()[,'status'])
# }) 


  
  # output$hist_species <- renderPlot({
  #   if(input$hist_species_check == TRUE){  
  #   
  #     # ggplot(z(),aes(z()[,'Var1'], z()[,'Freq'], color=z()[,1])) +
  #     #   geom_point() + geom_smooth(method = lm)
  #     
  #     
  #   ggplot(z(), aes(x = reorder(z()[,1],z()[,'Freq']), y = z()[,'Freq'])) +
  #     geom_bar(stat="identity", fill="gold1", colour="black") +
  #     theme_bw(base_size = 10)+
  #     labs(title="z", x ="Birth Country", y = "Frequency")
  #   
  # }
  # })
  
  
#} 

 


#------------------------------------------------------------------------------- 
}
  
  


# output$table <- renderTable({
#   df()
# })

# output$downloadData <- downloadHandler(
#     filename = function() {
#       paste(na.omit(input$upload_data), Sys.Date(), '.csv', sep="")
#     },
#     content = function(file) {
#      
#       write.csv(df(), file,row.names = FALSE)
#     }
#   )


# observeEvent(input$total_rows,{
#   output$disp_value <- renderText({
#     return(isolate(nrow(df())))
#   })
# })

# observeEvent(input$remove_na,{
#   output$disp_value <- renderText({
#     input$display_rows
#     na.omit(df)
#     write.csv("cleandata.csv")
#   })
# })
  

 




