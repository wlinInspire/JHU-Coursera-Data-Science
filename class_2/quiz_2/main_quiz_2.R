pollutantmean <- function(directory,
                          pollutant,
                          id = 1:332) {
        setwd(paste0("~/Library/Mobile Documents/com~apple~CloudDocs/",
                     "DataScience/JHUDataScience/Class_2_R_programming/quiz_2"))
        allfiles <- sapply(list.files(directory),function(x){
                strsplit(x,'[.]')[[1]][1]})
        fileIndex <- as.numeric(allfiles) %in% id
        monitorfiles <- list.files(directory,full.names = T)[fileIndex]
        pollutionData <- data.frame()
        for (i in monitorfiles) {
                temp <- read.csv(i)
                pollutionData <- rbind(pollutionData,temp)
        }
        pollutantmean <- mean(pollutionData[,pollutant], na.rm = T)
        return(pollutantmean)
}

