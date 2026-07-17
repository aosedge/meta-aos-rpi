SUMMARY = "valkey layer"

require recipes-aos-layers/aos-base-layer/aos-base-layer.inc

AOS_LAYER_FEATURES += " \
    python3-valkey \
"
