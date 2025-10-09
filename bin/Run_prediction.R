#!/usr/bin/env Rscript

### specify paths to package library, otherwise the package will not be found
.libPaths("/home/ubuntu/R/x86_64-pc-linux-gnu-library/4.5")

library(CalibraCurve)
library(optparse)
library(openxlsx)



option_list <- list( 
  make_option(opt_str = c("--CC_RES"), 
              type = "character",
              help = "File containing CalibraCurve results (.rds file)."),
  make_option(opt_str = c("--output_path"), 
              type = "character",
              help = "Folder for saving result table with predictions."),
  make_option(opt_str = c("--newdata"), 
              type = "character",
              help = "File containing new data for prediction."),
  make_option(opt_str = c("--intensity_col"), 
              type = "integer",
              default = 1,
              help = "Column number of newdata that contains the measured intensities.")
)


opt <- parse_args(OptionParser(option_list=option_list))

if(is.null(opt$CC_RES)){
  message("The data path is missing. Add: --CC_RES <your/data/path>")
}
if(is.null(opt$output_path)){
  message("The output path is missing. Add: --output_path <your/output/folder>")
}
if(is.null(opt$newdata)){
  message("The file containing new data is missing. Add: --newdata <your/newdata/file>")
}

CC_res <- readRDS(opt$CC_RES)

newdata <- openxlsx::read.xlsx(opt$newdata, sheet = 1)


prediction <- CalibraCurve::predictConcentration(CC_res = CC_res, 
                                  newdata = newdata[, opt$intensity_col])

openxlsx::write.xlsx(prediction, 
                 file = file.path(opt$output_path, "predicted_concentrations.xlsx"))
