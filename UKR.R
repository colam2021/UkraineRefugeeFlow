lib = c("tidyverse","networkD3", "shiny")
lapply(lib, require, character.only = TRUE) 

links = read.csv("df.csv", header = T)

nodes = data.frame(name = c(as.character(links$source),
                            as.character(links$target))
                   %>% unique(),
                   stringsAsFactors = FALSE)


links$IDsource <- match(links$source, nodes$name)-1

links$IDtarget <- match(links$target, nodes$name)-1


p <- sankeyNetwork(Links = as.data.frame(links), Nodes = as.data.frame(nodes),
                   
                   Source = "IDsource", Target = "IDtarget",
                   
                   Value = "value", NodeID = "name", height=800, width=1000,
                   
                   sinksRight=FALSE, fontSize=14, fontFamily="Arial", nodeWidth = 20, iterations = 0)

p

ui = shinyUI(fluidPage(
  
  h3("Latest Ukraine Refugee Situation", style="text-align:left"),
  h4("Over 1.5 million people have fled the war in Ukraine since Feb 24"),
  
  h5("Source: UNHCR Operational Portal March 5th, 2022", style="text-align:left"),
  
  sankeyNetworkOutput('sankey')
  
))


server = function(input, output) {
  
  output$sankey <- renderSankeyNetwork(p)
  
}

shinyApp(ui = ui, server = server)
