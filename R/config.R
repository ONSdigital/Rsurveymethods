# Project directories
ARTIFACT_DIR <- getwd()
INPUT_DIR <- paste(ARTIFACT_DIR, "/tests/input", sep="")
OUTPUT_DIR <- paste(ARTIFACT_DIR, "/tests/output", sep="")

# Input files
DATA_FILENAME <- "snapshot-228-af4f3bd1-2aa5-4f3e-bb53-e22c1a0a4d3d_outlier_detection_imputation_outputs.csv"
POPULATION_COUNTS_FILENAME <- "population_counts.csv"
INPUT_DATA_FILE <- file.path(INPUT_DIR, DATA_FILENAME)
POPULATION_COUNTS_FILE <- file.path(INPUT_DIR, POPULATION_COUNTS_FILENAME)

# Output files
PROCESSED_DATA_FILE <- file.path(OUTPUT_DIR, "processed_data.csv")

# Constants
CONST_01 <- 0.05
CONST_02 <- 100

# Any other global variables
PROJECT_NAME <- "Rsurveymethods"
