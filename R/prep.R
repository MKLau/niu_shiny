## Data Prep

pkgs <- c("readxl")
sapply(pkgs, library, character.only = TRUE)
source("R/lib.R")
x <- readxl::read_xlsx("data/UHWO Niu Nursery Narration of 24 niu varities 7.29.2023.xlsx", sheet = 1)
x2 <- readxl::read_xlsx("data/Niu Nursery Round 2 at UHWO Data.xlsx", sheet = 1)

x <- data.frame(x)
colnames(x) <- x[1, ]
x <- x[-1:-2, ]
x <- x[-nrow(x), ]
latlon <- convert_latlon(x[, 2])
colnames(latlon) <- c("lat", "lon")
latlon[, "lon"] <- latlon[, "lon"] * -1
x <- cbind(number = x[, 1], latlon, x[, -1:-2])
loc.name <- sapply(x[, 4], function(x) strsplit(x, ":",)[[1]][1])
names(loc.name) <- seq(1, length(loc.name))
tab.niu <- cbind("Location Name" = loc.name, x)

x2 <- data.frame(x2)
colnames(x2) <- x2[1, ]
x2 <- x2[-1:-2, ]
x2 <- x2[-nrow(x2), ]
latlon2 <- convert_latlon(x2[, 2])
colnames(latlon2) <- c("lat", "lon")
latlon2[, "lon"] <- latlon2[, "lon"] * -1
x2 <- cbind(number = x2[, 1], latlon2, x2[, -1:-2])
loc.name2 <- sapply(x2[, 4], function(x) strsplit(x, ":",)[[1]][1])
names(loc.name2) <- seq(1, length(loc.name2))
tab.niu2 <- cbind("Location Name" = loc.name2, x2)

tab.niu <- tab.niu[, na.omit(match(colnames(tab.niu2), colnames(tab.niu)))]
tab.niu2 <- tab.niu2[, na.omit(match(colnames(tab.niu), colnames(tab.niu2)))]
tab.niu <- rbind(tab.niu, tab.niu2)
tab.niu <- tab.niu[!(apply(tab.niu, 1, function(x) all(is.na(x)))), ]

save(tab.niu, file = "data/niu_map_data.save")
