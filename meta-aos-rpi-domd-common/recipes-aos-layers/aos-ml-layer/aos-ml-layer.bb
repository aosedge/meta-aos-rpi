SUMMARY = "python machine learning layer"

require recipes-aos-layers/aos-base-layer/aos-base-layer.inc

AOS_LAYER_FEATURES += " \
    python3-ultralytics \
    python3-plotly \
    python3-dash \
    python3-scikit-learn \
    python3-addict \
    python3-yolov5 \
"
