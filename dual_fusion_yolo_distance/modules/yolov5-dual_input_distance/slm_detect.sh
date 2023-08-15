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

python detect_input_3D.py --weights /home/zhoulingwei/pycharm_project_258/dual_conv_fusion_yolov5-20.04_2_changemodel/modules/yolov5-dual_copy/runs/train/delect_spff_Cbam_reflex/weights/best.pt --source /home/zhoulingwei/pycharm_project_258/new_dataset_kitti/detect/images --source2 /home/zhoulingwei/pycharm_project_258/new_dataset_kitti/detect/images2
