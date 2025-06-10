#!/usr/bin/env Rscript

# first install packages affy, matrixStats and vsn
#install.packages("../ProtStatsWF", repos = NULL, type="source")
library(CalibraCurve)
library(optparse)

option_list <- list( 
  make_option(opt_str = c("--data_path"), 
              type = "character",
              help = "A string of the input path for the data."),
  make_option(opt_str = c("--output_path"), 
              type = "character",
              help = "A string of the input path for the data."),
  make_option(opt_str = c("--conc_col"), 
              type = "integer",
              #default = 1,
              help = "Column number of the concentration column in the data."),
  make_option(opt_str = c("--meas_col"), 
              type = "integer",
              #default = 2,
              help = "Column number of the measurement column in the data.")
)

#print(option_list)

opt <- parse_args(OptionParser(option_list=option_list))

if(is.null(opt$data_path)){
  message("The data path is missing. Add: --data_path <your/data/path/file.xlsx>")
}
if(is.null(opt$output_path)){
  message("The output path is missing. Add: --output_path <your/output/path/folder>")
}
if(is.null(opt$conc_col)){
  message("Column number of concentration column is missing. Add: --conc_col <number>")
}
if(is.null(opt$mea_col)){
  message("Column number of measurement column is missing. Add: --meas_col <number>")
}

print(opt)

CalibraCurve(data_path = opt$data_path,
                    output_path = opt$output_path,
                    conc_col = opt$conc_col,
                    meas_col = opt$meas_col)
