'run-tests-livraison.R' (ce fichier);
test_file("tests-livraison.R", reporter = "summary")
library(testthat)
source("source.R")
data <- data.frame(start_date = as.Date("2018-05-09"),
                   start_station_code = as.factor(c("Adam", "Math", "Oli", "Serge", "Pierre",
                                                    "Claude", "Roger", "Lee", "Steve", "Dwayne")),
                   end_date = as.Date("2018-05-09"),
                   end_station_code = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                  6009, 6009, 6070, 6343, 6903)),
                   duration_sec = c(904, 404, 616, 921, 875, 850, 852, 672, 253, 337),
                   is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))


subfun <- function(x) (x + 2)/2


revenues(data, fun)

read.csv(Users/olivierbourret/Desktop/Université/Automne 2019/IFT-1902/Travail longitudinal/BixiMontrealRentals2019/OD_2019-04.cvs)


file.path(Users/olivierbourret/Desktop/Université/Automne 2019/IFT-1902/Travail longitudinal/BixiMontrealRentals2019/OD_2019-04.cvs)





typeof(486)
typeof(0.3324)



X[1] <- 1



x <- c(65, Inf, NaN, 88)
is.finite(x)


data(cars)
attributes(cars)
attr(cars, "class")


data.frame("Nom" = c("Olivier", "Rosie", "Sex anal"),
           "Âge" =c(28,24, 12),
           "Occupation" = c("a", "b", "c"),
           stringsAsFactors = FALSE)

data()
row.names(USArrests)



d <- "2004-02-29"
d+1
d <- as.Date(d)
d+1
d-1
as.numeric(d)
d - as.Date("1970-01-01")


(auj <- Sys.Date())
auj>=d

(dixsem <- seq(Sys.Date(), length.out = 10, by = "1 week"))
?seq.Date
weekdays(dixsem)
months(dixsem)
quarters(dixsem)




(auj <- Sys.time())
class(auj)
auj <- as.POSIXlt(auj)
unclass(auj)
auj$hour
(y <- auj$year)
y - (2000 - 1900)
d <- as.POSIXct("2000-02-29 10:51:27")
as.Date(d)
as.PO


read.csv("/Users/olivierbourret/Desktop/Université/Automne 2019/IFT-1902
/Travail longitudinal/BixiMontrealRentals2019/OD_2019-04.csv")
getwd()
setwd("Users/olivierbourret/Desktop/Université/Automne 2019/IFT-1902/Travail longitudinal/BixiMontrealRentals2019")
getwd()
stewd()
setwd()
file.path("Users", "olivierbourret", "Desktop", "Université", "Automne 2019", "IFT-1902", "Travail longitudinal", "BixiMontrealRentals2019", "OD_2019-04.cvs")





subset(airquality, Temp > 80, select = c(Ozone, Temp))
subset(airquality, Day == 1, select = -Temp)
subset(airquality, select = Ozone:Wind)
with(airquality, subset(Ozone, Temp > 80))
nm <- rownames(state.x77)
subset(state.x77, grepl("",nm))

getwd()


( x1 <- seq(-2, 4, by = .5) )
round(x1) #-- IEEE / IEC rounding !
x1[trunc(x1) != floor(x1)]
x1[round(x1) != floor(x1 + .5)]
(non.int <- ceiling(x1) != floor(x1))
