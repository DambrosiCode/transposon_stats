# transposon_stats
A few scripts I'm using for transposon analysis. 

All TE data was collected in a generic feature format (GFF) annotating location and frequency in a pooled population. This allows the software to plot the TE locations on a simple scatter plot. 

Because the real data is a bit unweildy (with several thousand data points) it helps to simplify information. For this, the data is calculated in a sliding window format, with the final data point plotted in the center of the window. The two functions add.te() and mean.te() average the population frequency, and number of points in the window, respectively. 

Finally, compare() takes both the averaged and totaled data and uses ggplot to output a comparitive graph showing the new data points and a best fit curve using geom_smooth() which uses lowess smoothing to show peaks and troughs of the data. 

Ultimately the goal of this program is to look at transposon frequencies in a given location for novel uses. Obviously a seperate program should be used to get transposon insertion frequencies(for example PopPoolationTE2), as those capabilities are far beyond this program, and it's more for the data-analysis part of a pipeline.  

## Loading and Comparing Data
AS stated file formats should follow GFF standards and have population frequency data, IE: a tab delimited text file with at least the following format:

chromosome  location  name  frequency

Different chromosomes can then be placed in vectors as such  
`te = read.delim('file_location')`  
`chr.i = te[which(te$Group == 'chrI'),]`

From this data you can then start comparisons.  
Ideally genes or loci of interest should be annotated in a vector with a span of the area around it you wish yo be graphed  
`span = 1000000`  
`loci = c(1000000-span, 1000000+span)`

Finally, your data can be put in the compare function to output the data specifide above.  
`compare(pop = "FreqRS", chr = chr.iv, gene = loci, total.window = 100000, mean.window = 110000, mean.fit = .3, total.fit = .3)`  
The parameters follow:
`pop`: Population you are looking at. It may not be aplicable to data that doesn't compare multiple populations or groups, and should then just be the name of your frequency column  
`chr`: chromosome  
`gene`: Gene or loci location. NA is used as a parameter, the whole chromosome will instead be plotted  
`total.window`: Window size for totalling data  
`mean.window`: Window size for averaging frequency data  
`mean.fit`: Smoothness of best fit line for average frequencies default is 0.3   
`total.fit`: Smoothness of best fit line for totals, default is 0.3   
