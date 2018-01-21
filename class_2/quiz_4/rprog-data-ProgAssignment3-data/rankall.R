rankall <- function(outcome, num = "best") {
        ## Read outcome data
        setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/')
        setwd('./JHUDataScience/Class_2_R_programming/quiz_4/')
        setwd('./rprog-data-ProgAssignment3-data/')
        outcomeMeasure <- read.csv("outcome-of-care-measures.csv", 
                                   colClasses = "character")
        names(outcomeMeasure) <- toupper(names(outcomeMeasure))
        ## Check that state and outcome are valid
        if(sum(outcome %in% c('heart attack', 'heart failure', 'pneumonia')) == 
           0) { 
                stop("invalid outcome", call. = F)}
        ## For each state, find the hospital of the given rank
        outcomeFormal <- paste0('HOSPITAL.30.DAY.DEATH..MORTALITY..RATES.FROM.',
                                sub(' ', '.', toupper(outcome)))
        outcomeMeasure[,outcomeFormal][
                outcomeMeasure[,outcomeFormal] == 'Not Available'] <- NA
        outcomeMeasure[,outcomeFormal] <- 
                as.numeric(outcomeMeasure[,outcomeFormal])
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
        rankAll <- data.frame(hospital = 0,
                              state = unique(outcomeMeasure$STATE))
        for (i in 1:nrow(rankAll)) {
                stateHospital <- 
                        outcomeMeasure[which(outcomeMeasure$STATE == 
                                                     rankAll$state[i]),]
                if (num == 'best') {
                        hospitalName <- 
                                stateHospital$HOSPITAL.NAME[
                                        order(stateHospital[,outcomeFormal], 
                                              stateHospital$HOSPITAL.NAME,
                                              decreasing = F)[1]]
                } else if (num == 'worst') {
                        # browser()
                        hospitalName <- 
                                stateHospital$HOSPITAL.NAME[
                                        order(stateHospital[,outcomeFormal], 
                                              stateHospital$HOSPITAL.NAME,
                                              decreasing = T)[1]]
                } else if (is.numeric(num)) {
                        # browser()
                        hospitalName <- 
                                stateHospital$HOSPITAL.NAME[
                                        order(stateHospital[,outcomeFormal],
                                              stateHospital$HOSPITAL.NAME)[num]]
                } else {
                        stop("invalid rank input", call. = F)
                }
                rankAll$hospital[i] <- hospitalName
        }
        return(rankAll[order(rankAll$state),])
}
