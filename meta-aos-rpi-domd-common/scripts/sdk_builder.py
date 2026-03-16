#!/usr/bin/env python3
"""Script for building Aos layers"""
import argparse
import os
import shutil
import sys

import yaml
from bitbake import call_bitbake


def main():
    """Main function"""
    parser = argparse.ArgumentParser(description="SDK builder")

    parser.add_argument(
        "conf", metavar="conf.yaml", type=str, help="YAML file with configuration"
    )

    args = parser.parse_args()

    with open(args.conf, "r", encoding="utf-8") as conf_file:
        conf = yaml.load(conf_file, Loader=yaml.CLoader)

    sdk_conf = conf["sdk"]

    yocto_dir = sdk_conf.get("yocto_dir", "yocto")
    build_dir = sdk_conf.get("build_dir", "build")

    ret = call_bitbake(
        conf.get("work_dir", "workdir"),
        yocto_dir,
        build_dir,
        sdk_conf["base_image"],
        task="populate_sdk",
        do_clean=True,
    )

    if ret != 0:
        return ret

    try:
        # Yocto doesn't allow to override SDK_DEPLOY variable, regardless of documentation.
        # It is strictly set to ${TOPDIR}/tmp/deploy/sdk in populate_sdk_base.bbclass.
        # As WA copy SDK to the output directory manually.

        sdk_dir = os.path.join(yocto_dir, build_dir, "tmp", "deploy", "sdk")

        shutil.copytree(
            sdk_dir,
            sdk_conf.get("output_dir", "../output/sdk"),
            dirs_exist_ok=True,
        )

        shutil.rmtree(sdk_dir, ignore_errors=True)
    except OSError as e:
        print(f"Failed to copy sdk: {e}")

        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
