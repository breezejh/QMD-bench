#!/bin/bash

# 根据operator替换文件
if [ $# -lt 1 ]; then
    echo "缺少operator参数！"
    exit 1
fi

OPERATOR=$1

cp -r ./Opencv opencv

case $OPERATOR in
    "blur")
        if [ -f "./blur/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="blur/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/box_filter.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "cmp")
        if [ -f "./cmp/core.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="cmp/core.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/core.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/core/compare.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "color")
        if [ -f "./color/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="color/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/color.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "convolution")
        if [ -f "./conv/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="conv/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/filter.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "div")
        if [ -f "./div/core.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="div/core.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/core.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/core/div.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "dot_product")
        if [ -f "./dot/core.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="dot/core.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/core.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/core/dot.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "gaussian_blur")
        if [ -f "./gaussian_blur/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="gaussian_blur/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/gaussian_blur.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "median_filter")
        if [ -f "./median_filter/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="median_filter/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/median_blur.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "morph")
        if [ -f "./morph/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="morph/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/morph.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "pyramid")
        if [ -f "./pyramid/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="pyramid/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/pyramids.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "resize")
        if [ -f "./resize/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="resize/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/resize.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "sep_filter")
        if [ -f "./sep_filter/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="sep_filter/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/sep_filter.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;
    "sobel")
        if [ -f "./sobel/imgproc.hpp" ]; then
            # 这里执行替换操作，您需要指定替换源
            SOURCE_FILE="sobel/imgproc.hpp"
            FILE_PATH="opencv/hal/riscv-rvv/include/imgproc.hpp"

            cp "$SOURCE_FILE" "$FILE_PATH"

            rm opencv/hal/riscv-rvv/src/imgproc/sobel.cpp

            echo "文件已替换和删除: $SOURCE_FILE"
        else
            echo "错误: 文件不存在: $SOURCE_FILE"
        fi
        ;;

esac