# Cooperative-Learning_Deblur_SR

## 1.Abstract
<br>Recently, with great success in high-level vision tasks, the deep convolutional neural networks (CNNs) have also been applied to deal with low-level vision problems. However, the existing CNN-based approaches can only handle the single factor degeneration problem: resolution descend or relative motion during imaging. When the actual degradation is inconsistent with hypothetical degradation condition or contains multiple kinds of degradation, they will inevitability get undesirable performance. In order to solve these problems, we propose a deep cooperative learning network model, which can deal with multiple kinds of degradation factors as well as their simultaneous effects, such as concurrent resolution reduction and motion blur. Our approach can actualize single image super-resolution (SISR) and motion deblurring simultaneously and will bring high practicability. We evaluate the proposed approach on diverse benchmark data sets including natural images and man-made images. Both the evaluation and the comparisons demonstrate that our approach is superior to the state-of-the-art methods, where image SR and motion deblurring can be accomplished effectively at the same time.</br>

## 2. The proposed Cooperative Learning Deep Network
<br>The detailed architecture of the MSDEPC network is shown in the below.</br>
![image](https://github.com/hengliusky/Cooperative-Learning_Deblur_SR/blob/master/imgs/model.png)
<br>Our proposed deep network contains two sub-CNNs, where one is for HR details recovery and the other is deployed for motion details acquisition. At the same time, the two sub-CNNs are grouped cooperatively to reconstruct the final sharp and HR image.we use different color boxes to indicate diverse operations: Orange red box indicates convolution layers, grass green box corresponds to deconvolution
layers, bright yellow box represents PRelu activation operation, sky blur box refers to sum operation, and brow box
marks batch normalization (BN) layers.</br>

<br>An example of recursive residual structure</br>
![image](https://github.com/hengliusky/Cooperative-Learning_Deblur_SR/blob/master/imgs/recursive%20residual%20struct.png)
<br>the input signal will pass through two ‘Conv-BN-PRelu-Conv-BN-PRelu’ blocks with recursively residual connections.</br>

## 3.Usage

### 1)Requirements
<br>Ubuntu 14.04 LTS</br>
<br>MATLAB R2014a</br>
<br>CUDA 8.0 and Cudnn 5.1</br>
<br>Caffe</br>
<br>Nvidia GTX 1080ti</br>

### 2)Dataset
* **Dataset**
Our network utilzes GOPRO train dataset to train the network and two different test dataset to test the network:
<br>***Train Dateset*** </br>
<br>***GOPRO Dateset(Train)*** </br>
<br>Utilze train dataset from GOPRO to train cooperative learning deep network(Refer to:Nah, S.; Kim, T. H.; and Lee, K. M. 2017. Deep multi-scale convolutional neural network for dynamic scene deblurring. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition, 3883–3891.)</br>
<br>***Test Dateset*** </br>
<br>***GOPRO Dateset(Test)*** </br>
<br>Utilze test dataset from GOPRO to test cooperative learning deep network</br>
<br>***Lai et al. Dateset*** </br>
<br>Utilze Lai et al. dataset to test cooperative learning deep network(Refer to:Lai, W.-S.; Huang, J.-B.; Hu, Z.; Ahuja, N.; and Yang, M.- H. 2016. A comparative study for single image blind deblurring. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition, 1701–1709.)</br>
* **Data generation**
 <br>./matlab/generate_mod.m Convert training images to HDF5 files</br>
 
 ### 3）Training
* **Training networks through old degradation order images(first downsampling then upsampling images and finally blurring)**
  <br> /path_to_caffe/build/tools/caffe train -solver ./caffe_file/old_model/deblur_sr_solver_flow.prototxt -gpu [gpu id]</br>
* **Training networks through new degradation order images(first downsampling then blurring images and finally upsampling)**
  <br> /path_to_caffe/build/tools/caffe train -solver ./caffe_file/new_model/deblur_sr_solver_flow.prototxt -gpu [gpu id]</br>
  
### 4) Model
* **Model obtained through old degradation order images training**
  <br>deblur_sr_flow_iter_137500.caffemodel</br>
* **Model obtained through new degradation order images training**
  <br>deblur_sr_flow2_iter_202500.caffemodel</br>
  
### 5) Test
 <br> You can download the corresponding model from https://drive.google.com/drive/folders/1NyUnDoX1UvuxlZKFuh_pkk3tq-wuTbl0?usp=sharing to ./model folder and use the script in ./test for your images test.</br>
  <br>We convert RGB images to YCbCr and only use the Y channel for performance comparisions. PSNR and SSIM are objective evaluation indicators. </br>
  ![image](https://github.com/hengliusky/Cooperative-Learning_Deblur_SR/blob/master/imgs/compare.png)
  <br>Visual comparisons of different methods: the first row images come from GOPRO datset; the second row images comes from the dataset of Lai et al.</br>
<br>For more details, please refer to the paper.</br>
