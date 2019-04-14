library(ggplot2)
library(plyr)


te = read.delim("file location")
head(te)
#1-RS2009 2-CL2016
rs = te[which(te$Set == 1),]
cl = te[which(te$Set == 2),]


te.table = as.data.frame(sort(table(te$Name), decreasing = T))
te.names = c(te.table[1])

rs.table = as.data.frame(table(rs$Name))
rs.table$Freq = rs.table$Freq/sum(rs.table$Freq)

cl.table = as.data.frame(table(cl$Name))
cl.table$Freq = cl.table$Freq/sum(cl.table$Freq)

cl.table[order(cl.table$Freq),]

rs_cl.table = merge(rs.table, cl.table, by = "Var1")
rs_cl.matrix = as.matrix(rs_cl.table)

#order based on Frequency of RS
rs_cl.table = rs_cl.table[order(rs_cl.table$Freq.x, decreasing = T), ]

#rm(t)
barplot(t(as.matrix(rs_cl.table[,2:3])), 
        beside = T,
        names.arg = rs_cl.table$Var1,
        las = 2,
        col = c('red','blue'),
        main = "TEs Between Cheney Lake and Rabbit Slough",
        legend.text = c('RS',"CL"),
        ylab = 'Frequency',
        ylim = c(0, .3))

