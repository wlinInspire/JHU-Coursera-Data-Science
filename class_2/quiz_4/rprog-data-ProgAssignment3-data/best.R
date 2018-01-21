best <- function(state, outcome) {
        ## Read outcome data
        setwd('~/Library/Mobile Documents/com~apple~CloudDocs/DataScience/')
        setwd('./JHUDataScience/Class_2_R_programming/quiz_4/')
        setwd('./rprog-data-ProgAssignment3-data/')
        outcomeMeasure <- read.csv("outcome-of-care-measures.csv", 
                            colClasses = "character")
        names(outcomeMeasure) <- toupper(names(outcomeMeasure))
        ## Check that state and outcome are valid
        if(sum(state %in% outcomeMeasure$STATE) == 0) {
                stop("invalid state", call. = F)}
        if(sum(outcome %in% c('heart attack', 'heart failure', 'pneumonia')) == 
           0) { 
                stop("invalid outcome", call. = F)}
        ## Return hospital name in that state with lowest 30-day death rate
        outcomeFormal <- paste0('HOSPITAL.30.DAY.DEATH..MORTALITY..RATES.FROM.',
                                sub(' ', '.', toupper(outcome)))
        outcomeMeasure[,outcomeFormal][
                outcomeMeasure[,outcomeFormal] == 'Not Available'] <- NA
        outcomeMeasure[,outcomeFormal] <- 
                as.numeric(outcomeMeasure[,outcomeFormal])
        stateHospital <- outcomeMeasure[which(outcomeMeasure$STATE == state),]
        # browser()
        bestStateHospital <- 
                stateHospital$HOSPITAL.NAME[
                        order(stateHospital[,outcomeFormal], 
                              stateHospital$HOSPITAL.NAME,
                              decreasing = F)[1]]
        return(bestStateHospital)
}
