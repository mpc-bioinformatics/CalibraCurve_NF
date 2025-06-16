#!usr/bin/env nextflow
nextflow.enable.dsl=2

params.output_path = "."
params.conc_col = 1
params.meas_col = 2
params.substance = "_"
params.suffix = "_"
params.min_replicates = 3
params.cv_thres = 20
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
params.show_regression_info = false
params.show_linear_range = true
params.show_data_points = true
params.point_colour = "black"
params.curve_colour = "red"
params.linear_range_colour = "black"
params.RF_colour_threshold = "orange"
params.RF_colour_within = "#00BFC4"
params.RF_colour_outside = "#F8766D"


process Rscript {
  container 'mpc/calibracurve-r:1.0.0'

  publishDir(
    path:"${params.output_path}/results",
    mode:'copy'
  )

  input:
    val data_path
    val output_path
    val conc_col
    val meas_col
    val substance
    val suffix
    val min_replicates
    val cv_thres
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
    val show_regression_info
    val show_linear_range
    val show_data_points
    val point_colour
    val curve_colour
    val linear_range_colour
    val RF_colour_threshold
    val RF_colour_within
    val RF_colour_outside

  output:
    path("*.png")
    path("*.rds")
    path("*.xlsx")

  """
  Run_CalibraCurve.R --data_path ${data_path} --output_path "." --conc_col ${conc_col} --meas_col ${meas_col} --substance ${substance} --suffix ${suffix} --min_replicates ${min_replicates} --cv_thres ${cv_thres} --calcContinuousPrelimRanges ${calcContinuousPrelimRanges} --weightingMethod ${weightingMethod} --centralTendencyMeasure ${centralTendencyMeasure} --perBiasThres ${perBiasThres} --considerPerBiasCV ${considerPerBiasCV} --perBiasDistThres ${perBiasDistThres} --RfThresL ${RfThresL} --RfThresU ${RfThresU} --xlab "${xlab}" --ylab "${ylab}" --show_regression_info ${show_regression_info} --show_linear_range ${show_linear_range} --show_data_points ${show_data_points} --point_colour "${point_colour}" --curve_colour "${curve_colour}" --linear_range_colour "${linear_range_colour}" --RF_colour_threshold "${RF_colour_threshold}" --RF_colour_within "${RF_colour_within}" --RF_colour_outside "${RF_colour_outside}"
  """
}

workflow {
  Rscript(params.data_path, params.output_path, params.conc_col, params.meas_col, 
          params.substance, params.suffix,
          params.min_replicates, params.cv_thres, params.calcContinuousPrelimRanges, 
          params.weightingMethod, params.centralTendencyMeasure, params.perBiasThres, 
          params.considerPerBiasCV, params.perBiasDistThres, params.RfThresL, 
          params.RfThresU,  params.xlab, params.ylab,
          params.show_regression_info, params.show_linear_range,
          params.show_data_points, params.point_colour,
          params.curve_colour, params.linear_range_colour,
          params.RF_colour_threshold, params.RF_colour_within,
          params.RF_colour_outside)
}

