complete <- function(directory, id = 1:332){
        setwd(paste0("~/Library/Mobile Documents/com~apple~CloudDocs/",
                     "DataScience/JHUDataScience/Class_2_R_programming/quiz_2"))
        allfiles <- sapply(list.files(directory),function(x){
                strsplit(x,'[.]')[[1]][1]})
        fileIndex <- match(as.numeric(allfiles), id)
        monitorfiles <- list.files(directory,full.names = T)[fileIndex]
        nobs <- data.frame()
        for (i in monitorfiles) {
                temp <- read.csv(i)
                temp <- data.frame(id = temp$ID[1],
                                   nobs = nrow(na.omit(temp)))
                nobs <- rbind(nobs,temp)
        }
        return(nobs)
}

