#!/bin/bash
#SBATCH -J test
#SBATCH -p gpu
#SBATCH -N 1
#SBATCH --ntasks=4
#SBATCH --gres=gpu:1

module load shared
module add anaconda3
module add cudnn8.1-cuda11.2/8.1.1.33


# 重新进入conda环境
source activate

# conda激活自定义环境
conda activate zlw2

python train.py --data data/demage_rgb_liard_reflex.yaml --cfg models/road_demage_delect_spff_Cbam.yaml --weights weights/yolov5s.pt --batch-size 16 --epochs 100
# python train.py --data data/demage_rgb_liard_reflex.yaml --cfg models/road_demage_delect_spff_Cbam_compress.yaml --weights weights/yolov5s.pt --batch-size 8 --epochs 100