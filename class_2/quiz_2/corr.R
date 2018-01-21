corr <- function(directory, threshold = 0){
        setwd(paste0("~/Library/Mobile Documents/com~apple~CloudDocs/",
                     "DataScience/JHUDataScience/Class_2_R_programming/quiz_2"))
        allfiles <- sapply(list.files(directory),function(x){
                strsplit(x,'[.]')[[1]][1]})
        compCases <- complete(directory)
        compCases <- compCases[compCases$nobs > threshold,]
        fileIndex <- match(as.numeric(allfiles), compCases$id)
        monitorfiles <- list.files(directory,full.names = T)[fileIndex]
        corr <- NULL
        for (i in monitorfiles) {
                temp <- read.csv(i)
                corr <- c(corr,cor(temp$sulfate,
                                   temp$nitrate,
                                   use = "pairwise.complete.obs"))
        }
        return(corr)
}