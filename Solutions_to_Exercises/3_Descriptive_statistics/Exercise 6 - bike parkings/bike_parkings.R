# https://opentransportdata.swiss/en/dataset/bike-parking

# Execute the following code to show the bike parking locations on a map.

library(pacman)
p_load(jsonlite, tidyverse, leaflet)

# Set working directory to source file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# /Users/juergen/Downloads/bike_parking.json
bike <- fromJSON("bike_parking.json")

# Extract the "features" data frame
features <- bike$features

# Extract and flatten geometry (coordinates)
coordinates <- do.call(rbind, lapply(features$geometry$coordinates, as.numeric))
colnames(coordinates) <- c("longitude", "latitude")

bike_data <- cbind(coordinates, features$properties)
head(bike_data)
bike_cleaned <- bike_data %>%
  dplyr::select(longitude, latitude, name, address_city, address_postalCode, capacity, properties_operator)
head(bike_cleaned)

# Create an interactive map
# Check the structure of capacity
str(bike_cleaned$capacity)

# Convert capacity to numeric
bike_cleaned$capacity <- as.numeric(bike_cleaned$capacity)

# Check for warnings
if (any(is.na(bike_cleaned$capacity))) {
  warning("Some capacities could not be converted to numeric. Non-numeric values have been set to NA.")
}

# Retry the map creation
leaflet(bike_cleaned) %>%
  addTiles() %>%  # Add OpenStreetMap tiles
  addCircleMarkers(
    ~longitude, ~latitude,
    popup = ~paste(
      "<strong>Name:</strong>", name,
      "<br><strong>City:</strong>", address_city,
      "<br><strong>Capacity:</strong>", capacity,
      "<br><strong>Operator:</strong>", properties_operator
    ),
    radius = ~log(capacity + 1) * 2,  # Radius scaled by capacity
    color = ~ifelse(properties_operator == "SBB", "blue", "red"),
    fillOpacity = 0.7
  ) %>%
  addLegend("bottomright", colors = c("blue", "red"),
            labels = c("SBB", "Other Operators"),
            title = "Operators")

# Questions------------

head(bike_cleaned)

# 1) In what city is the bike parking with the highest capacity located?
bike_cleaned$capacity <- as.numeric(bike_cleaned$capacity)  # Ensure capacity is numeric
bike_cleaned %>% filter(capacity == max(capacity, na.rm = TRUE)) # Basel SBB
# Winterthur
bike_cleaned %>% filter(address_city == "Winterthur")  # Winterthur


# 2) Which cities are represented in the dataset?
unique(bike_cleaned$address_city)

# 3) How many bike parkings are operated by the SBB (Swiss Federal Railways)?
bike_cleaned %>%
  filter(properties_operator == "SBB") %>%
  count(properties_operator)

# Summarize total capacity by city for SBB-operated bike parkings
sbb_capacity_city <- bike_cleaned %>%
  filter(properties_operator == "SBB") %>%
  group_by(address_city) %>%
  summarise(total_capacity = sum(capacity, na.rm = TRUE)) %>%
  arrange(desc(total_capacity))  # Order by total capacity

# Create an ordered bar plot
ggplot(sbb_capacity_city, aes(x = reorder(address_city, -total_capacity), y = total_capacity)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Total Bike Parking Capacity by City (SBB)",
       x = "City",
       y = "Total Capacity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4) What is the average capacity of bike parkings in the dataset?
average_capacity <- mean(bike_cleaned$capacity, na.rm = TRUE)
print(average_capacity)

# Draw a histogram
ggplot(bike_cleaned, aes(x = capacity)) +
  geom_histogram(binwidth = 10, fill = "lightblue", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Bike Parking Capacity",
       x = "Capacity",
       y = "Frequency")

# Draw a boxplot
ggplot(bike_cleaned, aes(y = capacity)) +
  geom_boxplot(fill = "orange", color = "black") +
  theme_minimal() +
  labs(title = "Boxplot of Bike Parking Capacity",
       y = "Capacity") + 
  coord_flip()

# 5) What are the dimensions of the dataset bike_cleaned?
dim(bike_cleaned)
