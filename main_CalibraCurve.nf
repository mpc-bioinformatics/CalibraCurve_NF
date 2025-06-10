#!usr/bin/env nextflow
nextflow.enable.dsl=2

params.data_path = "//mnt/data/Documents/CalibraCurve_NF/testdata/ALB_LVNEVTEFAK_y8.xlsx"
params.output_path = "."
params.conc_col = 6
params.meas_col = 7

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

  output:
    path("*.png")
    path("*.rds")
    path("*.xlsx")

  """
  Run_CalibraCurve.R --data_path ${data_path} --output_path "." --conc_col ${conc_col} --meas_col ${meas_col}
  """
}

workflow {
  Rscript(params.data_path, params.output_path, params.conc_col, params.meas_col) 
}

