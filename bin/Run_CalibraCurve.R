#!/usr/bin/env Rscript

### specify paths to package library, otherwise the package will not be found
.libPaths("/home/ubuntu/R/x86_64-pc-linux-gnu-library/4.5")

library(CalibraCurve)
library(optparse)

option_list <- list( 
  make_option(opt_str = c("--data_folder"), 
              type = "character",
              help = "Folder containing input data."),
  make_option(opt_str = c("--output_path"), 
              type = "character",
              help = "Folder for saving results (plots and tables)."),
  make_option(opt_str = c("--conc_col"), 
              type = "integer",
              #default = 1,
              help = "Column number of the concentration column in the data."),
  make_option(opt_str = c("--meas_col"), 
              type = "integer",
              #default = 2,
              help = "Column number of the measurement column in the data."),
  make_option(opt_str = c("--substance"), 
              type = "character",
              default = "",
              help = ""),
  make_option(opt_str = c("--suffix"), 
              type = "character",
              default = "",
              help = ""),
  make_option(opt_str = c("--minReplicates"),
              type = "integer",
              default = 3,
              help = "Minimum number of replicates for a concentration level to be included in the calibration curve. Default is 3."),
  make_option(opt_str = c("--cvThres"),
              type = "numeric",
              default = 20,
              help = "Threshold for CV per concentration level in percent (default is 20)."),
  make_option(opt_str = c("--calcContinuousPrelimRanges"),
              type = "logical",
              default = TRUE,
              help = "If TRUE, the longest continuous range is selected (default is TRUE). If FALSE, gaps with CVs larger than the threshold may be included."),
  make_option(opt_str = c("--weightingMethod"),
              type = "character",
              default = "1/x^2",
              help = "Method for weighting (currently 1/x, 1/x^2 and None are supported, default is 1/x^2)."),
  make_option(opt_str = c("--centralTendencyMeasure"),
              type = "character",
              default = "mean",
              help = "Method for calculating average percent bias, mean (default) or median."),
  make_option(opt_str = c("--perBiasThres"),
              type = "numeric",
              default = 20,
              help = "Threshold for average percent bias in percent, default is 20."),
  make_option(opt_str = c("--considerPerBiasCV"),
              type = "logical",
              default = TRUE,
              help = "If TRUE, CV is considered for the elimination of the concentration level (default). CV will only be considered if the difference in percent bias values is lower than perBiasDistThres."),
  make_option(opt_str = c("--perBiasDistThres"),
              type = "numeric",
              default = 10,
              help = "Threshold for the difference in average percent bias in percent (for lower differences, CV will be considered), default is 10."),
  make_option(opt_str = c("--RfThresL"),
              type = "numeric",
              default = 80,
              help = "Lower threshold for response factor in percent (default is 80)."),
  make_option(opt_str = c("--RfThresU"),
              type = "numeric",
              default = 120,
              help = "Upper threshold for response factor in percent (default is 120)."), 
  make_option(opt_str = c("--xlab"), 
              type = "character",
              default = "Concentration",
              help = "Label of the x-axis"),
  make_option(opt_str = c("--ylab"), 
              type = "character",
              default = "Intensity",
              help = "Label of the y-axis"),
  make_option(opt_str = c("--plot_type"),
              type = "character",
              default = "single_plots",
              help = "Type of plot for calibration curves: single_plots (default), multiplot, or all_in_one."),
  make_option(opt_str = c("--show_regression_info"),
              type = "logical",
              default = FALSE,
              help = "If TRUE, show regression information (R2, slope, intercept) on the plot."),
  make_option(opt_str = c("--show_linear_range"),
              type = "logical",
              default = TRUE,
              help = "If TRUE, show the linear range of the calibration curve as a rectangle in the plot."),
  make_option(opt_str = c("--show_data_points"),
              type = "logical",
              default = TRUE,
              help = "If TRUE, show the data points on the plot."),
  make_option(opt_str = c("--point_colour"), 
              type = "character",
              default = "black",
              help = "Colour for the data points in the plot."),
  make_option(opt_str = c("--curve_colour"), 
              type = "character",
              default = "red",
              help = "Colour for the calibration curve in the plot."),
  make_option(opt_str = c("--linear_range_colour"), 
              type = "character",
              default = "black",
              help = "Colour for the linear range rectangle in the plot."),
  make_option(opt_str = c("--multiplot_nrow"), 
              type = "integer",
              default = 0,
              help = "Number of rows for the multiplot layout."),
  make_option(opt_str = c("--multiplot_ncol"), 
              type = "integer",
              default = 0,
              help = "Number of columns for the multiplot layout."),
  make_option(opt_str = c("--multiplot_scales"), 
              type = "character",
              default = "fixed",
              help = "Scales for the multiplot layout: fixed (default), free, free_x or free_y."),
  make_option(opt_str = c("--RF_colour_threshold"), 
              type = "character",
              default = "orange",
              help = "Colour for the threshold lines in the response factor plot."),
  make_option(opt_str = c("--RF_colour_within"), 
              type = "character",
              default = "#00BFC4",
              help = "Colour for the data points within the threshold lines in the response factor plot."),
  make_option(opt_str = c("--RF_colour_outside"), 
              type = "character",
              default = "#F8766D",
              help = "Colour for the data points outside of the threshold lines in the response factor plot."),  
  make_option(opt_str = c("--CC_plot_width"), 
              type = "numeric",
              default = 10,
              help = "Width of the calibration curve plot in cm (default is 10)."),
  make_option(opt_str = c("--CC_plot_height"), 
              type = "numeric",
              default = 10,
              help = "Height of the calibration curve plot in cm (default is 10)."),
  make_option(opt_str = c("--RF_plot_width"), 
              type = "numeric",
              default = 10,
              help = "Width of the response factor plot in cm (default is 10)."),
  make_option(opt_str = c("--RF_plot_height"), 
              type = "numeric",
              default = 10,
              help = "Height of the response factor plot in cm (default is 10).")
)

#print(option_list)

opt <- parse_args(OptionParser(option_list=option_list))

if(is.null(opt$data_folder)){
  message("The data path is missing. Add: --data_folder <your/data/path>")
}
if(is.null(opt$output_path)){
  message("The output path is missing. Add: --output_path <your/output/folder>")
}
if(is.null(opt$conc_col)){
  message("Column number of concentration column is missing. Add: --conc_col <number>")
}
if(is.null(opt$meas_col)){
  message("Column number of measurement column is missing. Add: --meas_col <number>")
}

if(opt$substance == "_"){
  dir <- opt$data_folder
  #opt$substance <- strsplit(basename(dir), "\\.")[[1]][1]
  #message("Substance name is missing. Using the name of the data folder: ", opt$substance)
}
if(opt$suffix == "_"){
  opt$suffix <- paste0("_", opt$substance)
  message("Suffix is missing. Using substance name.")
}

# in MacWorp 0 is used as default for number of multiplot rows and columns
if(opt$multiplot_nrow == 0){
  opt$multiplot_nrow <- NULL
}
if(opt$multiplot_ncol == 0){
  opt$multiplot_ncol <- NULL
}


D_list <- CalibraCurve::readMultipleTables(dataFolder = opt$data_folder, 
              fileType = "xlsx", 
              concCol = opt$conc_col, 
              measCol = opt$meas_col, 
              naStrings = c("NA", "NaN", "Filtered", "#NV"), 
              sheet = 1)


RES <- CalibraCurve::CalibraCurve(D_list = D_list,
              output_path = opt$output_path,
              substance = opt$substance,
              minReplicates = opt$minReplicates,
              cvThres = opt$cvThres,
              calcContinuousPrelimRanges = opt$calcContinuousPrelimRanges,
              weightingMethod = opt$weightingMethod,
              centralTendencyMeasure = opt$centralTendencyMeasure,
              perBiasThres = opt$perBiasThres,
              considerPerBiasCV = opt$considerPerBiasCV,
              perBiasDistThres = opt$perBiasDistThres,
              RfThresL = opt$RfThresL,
              RfThresU = opt$RfThresU, 
              plot_type = opt$plot_type,
              RF_colour_threshold = opt$RF_colour_threshold,
              RF_colour_within = opt$RF_colour_within,
              RF_colour_outside = opt$RF_colour_outside, 
              device = "png",
              CC_plot_width = opt$CC_plot_width,
              CC_plot_height = opt$CC_plot_height,
              RF_plot_width = opt$RF_plot_width,
              RF_plot_height = opt$RF_plot_height, 
              plot_dpi = 300, 
              verbose = FALSE,
              xlab = opt$xlab,
              ylab = opt$ylab,
              show_regression_info = opt$show_regression_info,
              show_linear_range = opt$show_linear_range,
              show_data_points = opt$show_data_points,
              point_colour = opt$point_colour,
              curve_colour = opt$curve_colour,
              linear_range_colour = opt$linear_range_colour,
              multiplot_nrow = opt$multiplot_nrow,
              multiplot_ncol = opt$multiplot_ncol,
              multiplot_scales = opt$multiplot_scales)
              




             











