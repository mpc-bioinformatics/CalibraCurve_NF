#!usr/bin/env nextflow
nextflow.enable.dsl=2

params.output_path = "."
params.conc_col = 1
params.meas_col = 2
params.substance = "_"
params.suffix = "_"
params.minReplicates = 3
params.cvThres = 20
params.calcContinuousPrelimRanges = true
params.weightingMethod = "1/x^2"
params.centralTendencyMeasure = "mean"
params.perBiasThres = 20
params.considerPerBiasCV = true
params.perBiasDistThres = 10
params.RfThresL = 80
params.RfThresU = 120
params.xlab = "Concentration"
params.ylab = "Intensity"
params.plot_type = "single_plots"
params.show_regression_info = false
params.show_linear_range = true
params.show_data_points = true
params.point_colour = "black"
params.curve_colour = "red"
params.linear_range_colour = "black"
params.multiplot_nrow = 0
params.multiplot_ncol = 0
params.multiplot_scales = "fixed"
params.RF_colour_threshold = "orange"
params.RF_colour_within = "#00BFC4"
params.RF_colour_outside = "#F8766D"
params.CC_plot_width = 10
params.CC_plot_height = 10
params.RF_plot_width = 10
params.RF_plot_height = 10


process Rscript {
  container 'mpc/calibracurve-r:1.0.0'

  publishDir(
    path:"${params.output_path}/results",
    mode:'copy'
  )

  input:
    val data_folder
    val output_path
    val conc_col
    val meas_col
    val substance
    val suffix
    val minReplicates
    val cvThres
    val calcContinuousPrelimRanges
    val weightingMethod
    val centralTendencyMeasure
    val perBiasThres
    val considerPerBiasCV
    val perBiasDistThres
    val RfThresL
    val RfThresU
    val xlab
    val ylab
    val plot_type
    val show_regression_info
    val show_linear_range
    val show_data_points
    val point_colour
    val curve_colour
    val linear_range_colour
    val multiplot_nrow
    val multiplot_ncol
    val multiplot_scales
    val RF_colour_threshold
    val RF_colour_within
    val RF_colour_outside
    val CC_plot_width
    val CC_plot_height
    val RF_plot_width
    val RF_plot_height

  output:
    path("*.png")
    path("*.rds")
    path("*.xlsx")

  script:
  """
  Run_CalibraCurve.R --data_folder ${data_folder} --output_path "." --conc_col ${conc_col} --meas_col ${meas_col} --substance ${substance} --suffix ${suffix} --minReplicates ${minReplicates} --cvThres ${cvThres} --calcContinuousPrelimRanges ${calcContinuousPrelimRanges} --weightingMethod ${weightingMethod} --centralTendencyMeasure ${centralTendencyMeasure} --perBiasThres ${perBiasThres} --considerPerBiasCV ${considerPerBiasCV} --perBiasDistThres ${perBiasDistThres} --RfThresL ${RfThresL} --RfThresU ${RfThresU} --xlab "${xlab}" --ylab "${ylab}" --plot_type "${plot_type}" --show_regression_info ${show_regression_info} --show_linear_range ${show_linear_range} --show_data_points ${show_data_points} --point_colour "${point_colour}" --curve_colour "${curve_colour}" --linear_range_colour "${linear_range_colour}" --multiplot_nrow ${multiplot_nrow} --multiplot_ncol ${multiplot_ncol} --multiplot_scales "${multiplot_scales}" --RF_colour_threshold "${RF_colour_threshold}" --RF_colour_within "${RF_colour_within}" --RF_colour_outside "${RF_colour_outside}" --CC_plot_width ${CC_plot_width} --CC_plot_height ${CC_plot_height} --RF_plot_width ${RF_plot_width} --RF_plot_height ${RF_plot_height} 
  """
}

workflow {
  Rscript(params.data_folder, params.output_path, params.conc_col, params.meas_col, 
          params.substance, params.suffix,
          params.minReplicates, params.cvThres, params.calcContinuousPrelimRanges, 
          params.weightingMethod, params.centralTendencyMeasure, params.perBiasThres, 
          params.considerPerBiasCV, params.perBiasDistThres, params.RfThresL, 
          params.RfThresU,  params.xlab, params.ylab, params.plot_type,
          params.show_regression_info, params.show_linear_range,
          params.show_data_points, params.point_colour,
          params.curve_colour, params.linear_range_colour,
          params.multiplot_nrow, params.multiplot_ncol, params.multiplot_scales,
          params.RF_colour_threshold, params.RF_colour_within,
          params.RF_colour_outside, 
          params.CC_plot_width, params.CC_plot_height,
          params.RF_plot_width, params.RF_plot_height)
}

