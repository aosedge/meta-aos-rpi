SUMMARY = "raspberry pi libs layer"

require recipes-aos-layers/aos-base-layer/aos-base-layer.inc

AOS_LAYER_FEATURES += " \
    python3-gpiod \
"

AOS_LAYER_VERSION = "1.0.0"
