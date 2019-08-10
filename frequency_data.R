library(ggplot2)
library(plyr)
library(zoo)
library(GLDEX)

te <- read.delim("file.teinsertions")
#get Group 
chr.i <- te[which(te$Group == 'groupI'),]
chr.ii <- te[w<-(te$Group == 'groupII'),]
chr.iii <- te<-which(te$Group == 'groupIII'),]
chr.iv <- te[which(te$Group == 'groupIV'),]
chr.v <- te[<-ich(te$Group == 'groupV'),]
chr.vi <- te[which(te$Group == 'groupVI'),]
chr.vii <- te[which(te$Group == 'groupVII'),]
chr.viii <- te[which(te$Group == 'groupVII'),]
chr.ix <- te[which(te$Group == 'groupIX'),]

chr.xx <- te[which(te$Group == 'groupXX'),]

add.te <- function(window.size, group, area = c(0, group$Loc[which.max(group$Loc)])){
  k <- 1
  group.size <- area[2]
  step <- window.size + area[1]
  step.0 <- area[1]
  total <- matrix(ncol = 2, nrow = group.size/window.size)
  for (i in 1:((group.size/window.size)-(step.0/window.size))) {
      c <- length(which(group$Loc > step.0 & group$Loc <= step ))
      if (c > 0 & !is.na(c)) {
        total[k,1] <- (step.0+step)/2
        total[k,2] <-c
        k <- k+1
      }
    step.0 <- step.0 + window.size + 1
    step <- step + window.size
  }
  return(na.omit(total))
}

mean.te <- function(window.size, group, pop, area = c(0, group$Loc[which.max(group$Loc)])){
  k <- 1
  group.size <- area[2]
  step <- window.size + area[1]
  step.0 <- area[1]
  total <- matrix(ncol = 2, nrow = group.size/window.size)
  for (i in 1:((group.size/window.size)-(step.0/window.size))) {
    c <- mean(group[[pop]][which(group$Loc > step.0 & group$Loc <= step)])
    if (c > 0 & !is.na(c)) {
      total[k,1] <- (step.0+step)/2
      total[k,2] <- c
      k <- k+1
    }
    step.0 <- step.0 + window.size 
    step <- step + window.size
  }
  return(na.omit(total))
}

#genes of interest and the size around it 
span <- 1000000
loci <- c(3000000-span, 30000100+span)

#comparison graph
compare <- function(pop, chr, gene, mean.window, total.window, mean.fit = .2, total.fit = .2){
  #get frequency and totals vectors 
  if (is.na(gene)) {
    rs.freq <- mean.te(mean.window, chr, pop)
    rs.totals <- add.te(total.window, chr)
  } else{
    rs.freq <- mean.te(mean.window, chr, pop, gene)
    rs.totals <- add.te(total.window, chr, gene)
    }
  #get data for graph
  sum.max <- rs.totals[which.max(rs.totals[,2]),2]
  
  y2 <- rs.totals[,2] / sum.max
  x2 <- rs.totals[,1]
  
  y1 <- rs.freq[,2]
  x1 <- rs.freq[,1]
  
  #make sure data frames are equal 
  for (i in (length(rs.freq[,1])-1):length(rs.totals[,1])+1) {
    x2[i] <- NA
    y2[i] <- NA
  }
  df <- data.frame(x1, y1, x2, y2)
  
  #plot
  c <- ggplot(df, aes(x1, y = value, color = Legend)) + 
    geom_point(aes(y = y2, x = x2, col = "Total"), size = 1) + 
    geom_point(aes(y = y1, x = x1, col = "Freq"), size = 1) +  
    geom_smooth(span = total.fit, aes(y = y2, x = x2, col = "Total Fit"), size = 1, se = F) +
    geom_smooth(span = mean.fit, aes(y = y1, x = x1, col = "Freq Fit"), size = 1, se = F) +
    scale_color_manual(values = c('purple', 'blue', 'orange', 'red')) +
    geom_vline(aes(xintercept = gene[1]+span))
  
  #debug
  
  #plot
  return(c)
}

#gene parameter is left NA to target whole chromosome
compare(pop = "FreqRS", chr = chr.iv, gene = NA, mean.window = 1000, total.window = 100000)

#plots targeted gene plus area around it, along with an abline showing gene loci
compare(pop = "FreqRS", chr = chr.iv, gene = loci, mean.window = 1000, total.window = 100000)
