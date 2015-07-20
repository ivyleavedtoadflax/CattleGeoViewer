
# Function adapted from 
# http://www.r-bloggers.com/approximate-sunrise-and-sunset-times/

ncalc <- function(
  date, 
  lon = -0.629225,
  lat = 52.07439,
  output = "sunset"
  ) {
  
  if (length(output) > 1) {
   
    warning("output must be of length 1.")
     
  }
  
  if (!output %in% c("sunrise","sunset","noon","all")) {
   
    warning("output must be one of: 'sunrise', 'sunset', 'noon'.") 
    
  }
  
  date <- as.POSIXct(date)
  d <- yday(date)
  
  
  ## d is the day of year
  ## lat is latitude in decimal degrees
  ## Long is longitude in decimal degrees (negative == West)
  
  ##This method is copied from:
  ##Teets, D.A. 2003. Predicting sunrise and sunset times.
  ##  The College Mathematics Journal 34(4):317-321.
  
  ## At the default location the estimates of sunrise and sunset are within 
  ## seven minutes of the correct times
  ## (http://aa.usno.navy.mil/data/docs/RS_OneYear.php) with a mean of 2.4
  ## minutes error.
  
  ## Function to convert degrees to radians
  rad <- function(x) pi*x/180
  
  ##Radius of the earth (km)
  R = 6378
  
  ##Radians between the xy-plane and the ecliptic plane
  epsilon = rad(23.45)
  
  ##Convert observer's latitude to radians
  L = rad(lat)
  
  ## Calculate offset of sunrise based on longitude (min) If Long is negative,
  ## then the mod represents degrees West of a standard time meridian, so timing
  ## of sunrise and sunset should be made later.
  
  timezone = -4 * (abs(lon)%%15) * sign(lon)
  
  ## The earth's mean distance from the sun (km)
  r = 149598000
  
  theta = 2 * pi / 365.25 * (d - 80)
  
  z.s = r * sin(theta) * sin(epsilon)
  r.p = sqrt(r^2 - z.s^2)
  
  t0 = 1440 / (2 * pi) * acos((R - z.s * sin(L)) / (r.p * cos(L)))
  
  ## a fudge adjustment for the radius of the sun
  that = t0 + 5 
  
  ## Adjust "noon" for the fact that the earth's orbit is not circular:
  n = 720 - 10 * sin(4 * pi * (d - 80) / 365.25) + 8 * sin(2 * pi * d / 365.25)
  
  ## now sunrise and sunset are:
  sunrise = date + ((n - that + timezone) * 60)
  noon = date + ((n + timezone) * 60)
  sunset = date + ((n + that + timezone) * 60)
  
  out_format <- function(x) {
    format(x, "%H:%M:%S")
  }
  
  sunrise <- out_format(sunrise)
  noon <- out_format(noon)
  sunset <- out_format(sunset)
  
  if (output == "sunrise") {
   
    return(sunrise)
    
  } else if (output == "noon") {
   
    return(noon)
     
  } else if (output == "sunset") {
   
    return(sunset)
     
  } else if (output == "all") {
   
    return(
      list(
        "sunrise" = sunrise,
        "noon" = noon,
        "sunset" = sunset
        )
      )
     
  }
  
}