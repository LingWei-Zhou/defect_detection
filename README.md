# defect_detection
双通道缺陷检测一共分为四步：数据标注，点云处理，模型融合，检测优化。
## 1.数据标注
使用 https://github.com/HumanSignal/labelImg 进行对缺失的缺陷数据集进行标注。LabelImg更加适合做分类，不适合做实例分割的数据集标注。LabelImg 可以保存三种数据格式：PASCAL VOC: voc 的xml 格式，yolo 格式和ML格式。具体安装程序为：
```
pip install labelme
```
![](https://github.com/LingWei-Zhou/defect_detection/assets/108880900/0d58401a-7c94-4c5e-be9c-6397495b8e35)

## 2.点云处理
在[KITTI数据集官网](https://www.cvlibs.net/datasets/kitti/raw_data.php)可以得到数据集相关的相机参数，以及对点云数据进行视觉匹配的代码。

![](https://github.com/LingWei-Zhou/defect_detection/assets/108880900/fba9b7f4-1403-4c67-8c91-c7223a511604)

## 3.模型融合
- 保存初始模型 <br>

  下载合适的初始模型至 \dual_backbone_fusion_yolo\modules\yolov5-dual_copy\weights 

- 安装环境 <br>

  ```
  conda create -n yolov5_d python=3.8
  conda activate yolov5_d
  cd dual_backbone_fusion_yolo
  pip install -r requirements.txt
  ```
- 保存点云的视角转换数据以及视觉图像
  
- 修改图像的参数路径

  生成数据的.yaml文件，用于保存训练集和数据集的路径文本文件，在train.py文件中修改文件路径。

- 训练及测试

  运行指令
  ```
  python train.py
  python detect.py
  ```
## 4.检测优化
运行 matlab/fangcha_tiqu.m 使用RANSAC算法剔除地面，地面提取效果如下：
![](https://github.com/LingWei-Zhou/defect_detection/assets/108880900/62d82b0c-61f0-4249-8751-46144fab4e83)

- 点云数据投影添加空间信息
  ```
  cd \dual_backbone_fusion_yolo_indistance\modules\yolov5-dual_input_distance
  python detect.py
  ```
  ![Q](https://github.com/LingWei-Zhou/defect_detection/assets/108880900/c5275a13-d68a-4b0d-b830-cdf3d13169b1)
- 双目测距添加空间信息
  同时得到双目视图，运行
  ```
  python detect copy2.py
  ```
  生成带有空间信息的检测框。

  ![](https://github.com/LingWei-Zhou/defect_detection/assets/108880900/06168092-1a71-44d0-808b-919736b0325d)
