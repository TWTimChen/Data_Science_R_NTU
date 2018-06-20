library(reticulate)
path_to_python <- "/anaconda3/bin/python"
use_python(path_to_python)
res <- source_python("python/predict.py")

