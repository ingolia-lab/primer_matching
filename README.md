primer_matching
===============

An R script to find sequencing primers useful to the plasmid at hand
Nicholas McGlincy, 27th July 2013, Baltimore MD, USA

Requires R, and a version advanced enough to run the Biostrings package. I 
used Biostrings because of the convenient functions and classes, but loading 
it slows the script down to ~5 seconds

Usage from the terminal window:

Rscript primerMatching.R [plasmid file] [primer file]

Plasmid file must be in fasta format. Primer file is a .csv download of the 
group sequencing primer gsheet.
