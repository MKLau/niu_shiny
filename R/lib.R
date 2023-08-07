convert_degminsec <- function(x){
    lat <- x[1] + (x[2] + x[3]/60)/60
    lon <- x[4] + (x[5] + x[6]/60)/60
    out <- c(lat, lon)
    return(out)
}

convert_latlon <- function(x){
    out <- gsub("\"", "", x)
    out <- gsub("\'", "", out)
    out <- gsub("°", "", out)
    out <- gsub(" W", "", out)
    out <- strsplit(out, " N ")
    out <- do.call(rbind, out)
    out <- apply(out, 1, strsplit, split = " ")
    out <- lapply(out, unlist)
    out <- lapply(out, as.numeric)
    out <- lapply(out, convert_degminsec)
    out <- do.call(rbind, out)
    return(out)
}
