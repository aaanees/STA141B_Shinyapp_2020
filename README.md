# STA141B_Shinyapp_2020
my shiny app 
This app called HoneyMoon in Turkey, where it pritns out a table of locations and thier rating for each city that is provided for the user.
for the "Data" we are using API link from yelp to get the location information and for the weather we used the API from (weatherstack.com) 

#  The way the app work
# 1 - input$city
The user Enters the input$city where the user choose the city to visit and there are mutiple cities as choises
# 2 - input$type
The user choose the place type such as resturants, zoo, hotels....etc
then the app prints out a table (limit) number of locations that is founded in the cossen city input$cit and here link to the API yelp to the data (https://abdallah-anees.shinyapps.io/STA141B_Shinyapp_2020/to/img.png)

# UI 
1 - Calls out for the city name 
2 - Calls out for the place type the the user is searching for.
3- Control the limit of output list by pressing the button whether increase the decrease the output.
4- Calls out to display the map to navigate the address for each location is listed from 'Step2'

# Server 
1 - Prints out the input$city name
2- prints out the temperature for input$city location, and we made a tagtap to output the temperature in Ferinhit uits
3- Prints out the table of location list that was found after choosing input$city, and it apply the input$obs to limit the output
4- it activate the map where it navigate the location address for each location and we use pupos to provide information about each location listed in the city. 
5- if there is no output form whether the input$city or input$type then it prints out error 

# Summary:
This app navigate the places that two couples wants to spend their time as having their honeymoon. We call out the best places 
such National Parks, Lakes, ... etc that couples wants to spend time. Also this app privde some basic information for each place list such as rating, number os reviews. for the pricses it was on the Turkish curency. After the user choose the city and place then the map will navigate for each address locations and it pup up on the map the basic information for each location such as phone number, address, rate. 
on the right top side of the page we print out the temperture with the description for every input$city name, and it change every time we reactivate or change the location address. 
this is the link for our app to run it https://abdallah-anees.shinyapps.io/STA141B_Shinyapp_2020/
