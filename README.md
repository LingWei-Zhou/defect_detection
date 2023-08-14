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

