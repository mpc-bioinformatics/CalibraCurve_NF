#!usr/bin/env nextflow
nextflow.enable.dsl=2

params.output_path = "."
params.intensity_col = 1


process CalibraCurve_prediction {
  container 'mpc/calibracurve-r:1.0.0'

  publishDir(
    path:"${params.output_path}/results",
    mode:'copy'
  )

  input:
    val CC_RES
    val output_path
    val newdata
    val intensity_col

  output:
    path("predicted_concentrations.xlsx")

  """
  Run_prediction.R --CC_RES ${CC_RES} --output_path "." --newdata ${newdata} --intensity_col ${intensity_col}
  """
}

workflow {
  CalibraCurve_prediction(params.CC_RES, params.output_path, params.newdata, params.intensity_col)
}

