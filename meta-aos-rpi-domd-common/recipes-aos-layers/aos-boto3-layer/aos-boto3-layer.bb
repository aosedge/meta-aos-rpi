SUMMARY = "boto3 python layer"

require recipes-aos-layers/aos-base-layer/aos-base-layer.inc

AOS_LAYER_FEATURES += " \
    python3-boto3 \
    python3-botocore \
"
