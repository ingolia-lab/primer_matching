# Hello world!
require("Biostrings")
# TODO detect if the package is installed, and run the installer script if it 
# isn't. Would require an internet connection.
args = commandArgs(T)
plasmid.file = args[1]
primer.file = args[2]
# Read in the plasmid sequence
#
# TODO, what if you have multiple plasmid files, how would you iterate through 
# them and name the output meaning fully. Could R do this itself, or would you 
# have to make it compatible with bash scripting.
plasmid = readDNAStringSet(plasmid.file,
                        	format = "fasta",
                        	use.names = T
                         	)
# Load primers file
#
primers = read.csv(primer.file,
					header = T,
					stringsAsFactors = F
					)
# Checking there are no NAs in the primers
#
if (sum(is.na(primers$Sequence)) > 0 ) {
	primerSet = primers$Sequence
	primerSet = primersSet[!is.na(primerSet)]
	primerSet = DNAStringSet(primerSet)
} else {
	primerSet = DNAStringSet(primers$Sequence) 
}
# Assigning names for later
#
names(primerSet) = primers$Primer
# Select individual sequence to convert from DNAstringSet to DNAstring
#
plasmid = plasmid[[1]]
# To avoid problems with circularity
#
plasmid = DNAString(paste(as.character(plasmid),
                        as.character(plasmid[1:max(width(primerSet))]),
                        sep = ""
                        )
                  )
# Make reverse complement
#
plasmidRC = reverseComplement(plasmid)
# Make it into a dictionary with the trusted band of the shortest primer
#
primersDict = PDict(primerSet, tb.end = min(width(primerSet)))
# The actual matching, returns index of matching primer in primersDict
# TODO would location of the match be interesting?
#
matchingPrimers = c(names(primerSet)[whichPDict(primersDict, plasmid)],
                    names(primerSet)[whichPDict(primersDict, plasmidRC)]
                    )
# The old line...
#writeLines(matchingPrimers, "goodOnes.txt")
#
fileConn = file(paste("matching_", plasmid.file, ".txt", sep = ""))
writeLines(matchingPrimers, fileConn)
close(fileConn)
# Getting more information on the matching primers
#
index = match(matchingPrimers, primers$Primer)
moreInfo = primers[index,]
write.csv(moreInfo, 
		  paste("moreInfo_", plasmid.file, ".csv", sep=""),
		  row.names = F
		  )
# clean up
rm(list = ls())
#sessionInfo()
