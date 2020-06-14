library(tidyverse)
library(jsonlite)
library(rvest)
library(httr)
library(shiny)
library(shinydashboard)
library(tidyquant)
library(formattable)
library(ggplot2)
library(dplyr)
library(leaflet)
library(webshot)

#usethis::edit_r_environ("project")

readRenviron(".Renviron")








ui <- dashboardPage(
    # the app is called Honeymoon in Turkey
    dashboardHeader(title = "Honeymoon in Turkey"),
    dashboardSidebar(),
    dashboardBody(
        sidebarPanel(
            
            # input : the user choose the city that he is intersted to visit
            # output : prints out the city name and the current Temperture of the city.
            selectInput("city", 
                        "Select a Interest City",
                        choices = c("Istanbul", "Ephesusl", "Trabzon", "Alanya", "Fethiye", "Edirne", "İzmit","Amasya", "Kuşadası", "Van", "Tekirdağ", "Çeşme", "Çanakkale", "Giresun", "Zonguldak", "pamukkale"),
                        selected = "Istanbul"),
            
            # input : Choose what type of place the user want to 
            # output : prints all the observation list that have the same type in the city.
            selectInput("type", 
                        label = "Place to go:",
                        choices = c("Hotels", "Beach", "Museums", "Restaurants", "Hospitals", "Mall", "National Park", "skiing", "zoo", "Lakes"),
                        selected = "Hotels"),
            
            # Select the number of observation list
            numericInput("obs", "Number of observations to view:", 20)
        ),
        
        tabBox(id = "tabset1",
            side = "right", height = "150px",
            selected = "Tab3",
            tabPanel("Temperture", "Temperture Information: ", verbatimTextOutput("tabset1Selected"))
        )
        ,
        mainPanel(
            textOutput("selected_var"), #display the city inputname
            textOutput("temp"),         #display the temperture of the input name of the city
            textOutput("places"),       #display the type of place the user is searching.
            tableOutput("results"),     #display the table that prints name, rating for eaching location 
            leafletOutput("leaflet")    #display the map function to navigate for all the list of location.
            
            )
        
        )
    
    
)
        




# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # The input is to choose which city your searching for
    # The output is the name of the city "input$city"
    output$selected_var <- renderText({ 
        paste("You have selected The City", input$city)
    })
    
    # For this part we run the API link to defind the current temperture
    # The input is the name of the city "input$city"
    # The output is the temperture in Fernhite of the city
    output$temp <- eventReactive(input$city, {
        r <- GET("http://api.weatherstack.com/current?", query = list(access_key = Sys.getenv("key"), query = input$city, units = "f"))
        
        json <- content(r, as = "text",encoding = "UTF-8")
        data <- fromJSON(json)
        #data$data$max_temp
        paste("The Temperature is :", data$current$temperature)
    })
    
    # This function called businesses and is used to run the API link in yelp to we get our data
    # We use this function as the main data in other funtion and we only run it in the server. 
    businesses <- reactive({
        r1 <- GET("https://api.yelp.com/v3/businesses/search",
                  add_headers(Authorization = paste("Bearer",Sys.getenv("DATABASEPW"))),
                  query = list(
                      location = str_c(input$city, ", Turkey"),
                      term = input$type,
                      rating = 4.5,
                      limit = input$obs
                  ))
        
        stop_for_status(r1)
        json <- content(r1, as = "text", encoding = "UTF-8")
        my_data <- fromJSON(json, flatten = TRUE)
        
        my_data$businesses  
    })
    
    # This function called temper and is used to run the API link for the Temperture
    # We use this function as the main data in other funtion to defind the Temperture 
    # and we only run it in the server. 
    temper <- reactive({
        r <- GET("http://api.weatherstack.com/current?", query = list(access_key = Sys.getenv("key"), query = input$city, units = "f"))
        
        json <- content(r, as = "text",encoding = "UTF-8")
        data <- fromJSON(json)
        
        data
     })
    
    # This function called results and is used to print out a list of names with thier ranking, and it 
    # runs the API link in yelp by using bussinesses function 
    # The input is what type of term your looking for in the city such as (Hotels, resturants ....etc)
    # The output list of (limited) catagories in city that the user can look through, and decide to go.
    # for the limited output, the user can decide how many locations he wants to see.
    output$results <- renderTable({
        businesses() %>% select(name, rating) 
        #%>% mutate(price = map_chr(price, ~ strrep("$", str_length(.))))
    })
    
    output$tabset1Selected <- renderPrint({
        
        data <- temper() 
        
        paste("The Temperature is :", data$current$temperature, ".F ", data$current$weather_descriptions)
       
    })
    
    # Map function : here we navigate the place of the location, and provide 
    # the main information for each location such as phone number, location address, rating......etc
    output$leaflet <- renderLeaflet({
        my_data <- businesses()  # we apply the businesses() function and call it my_data to run the map
        
        leaflet(my_data) %>%
            addProviderTiles(providers$Esri.WorldImagery) %>%
            setView( lng = 28.88306, 
                     lat = 41.05571,
                    zoom = 4) %>%
            setMaxBounds(lng1 = -140, lat1 = -70, lng2 = 155, lat2 = 70) %>%
            addMarkers(data = my_data,
                       lng = ~(my_data$coordinates.longitude), 
                       lat = ~(my_data$coordinates.latitude), 
                       popup = paste(
                           "<b>Location Name: </b>",my_data$name,"<br>","<br>",
                           "<b> Rating: </b>",my_data$rating,"<br>",
                           "<b> Number of Reviews : </b>",my_data$businesses$review_count,"<br>",
                           "</b>",my_data$name,"<br>","<b>Phone number : </b>",my_data$phone, "<br>",
                           "<b> Location Address: <b>", my_data$location.display_address,"</b>","<br>",
                           sep=""))
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)


# This is the link to run the app
#https://abdallah-anees.shinyapps.io/Final_Project_141B/
