close all;
clear all;

tic

up_scale=4;
blur_folder='./test/GOPR0385_11_01/blur/003060.png';
shape_folder='./test/GOPR0385_11_01/sharp/003060.png';

% model_dir = './';
% net_model = [model_dir 'Deblur_SR_deploy_flow.prototxt'];
% net_weights = [model_dir 'fnew_model/deblur_sr_flow_iter_137500.caffemodel'];
% phase = 'test';

model_dir = './';
net_model = [model_dir 'Deblur_SR_deploy_flow.prototxt'];
net_weights = [model_dir 'fnew_model/deblur_sr_flow2_iter_202500.caffemodel'];
phase = 'test';

% caffe.set_mode_gpu();
% caffe.set_device(1);
caffe.set_mode_cpu();


net = caffe.Net(net_model, net_weights, phase);

image_blur = imread(blur_folder);
image_shape = imread(shape_folder);

if size(image_blur, 3) > 1
im_shape = rgb2ycbcr(image_shape);  

im_shape_y = im_shape(:,:,1);

[hei, wid] = size(im_shape_y);

im_blur_ycbcr=rgb2ycbcr(image_blur);
im_blur_y=im_blur_ycbcr(:,:,1);

blur_input=im2double(image_blur);
input_data={blur_input};

output=net.forward(input_data);

%% computer PSNR
img_output=uint8(output{1} * 255);
elt_ycbcr=rgb2ycbcr(img_output);
elt_y=elt_ycbcr(:,:,1);

drrn(1) = compute_psnr(im_shape_y,elt_y);
drrn(2) = compute_psnr(im_shape_y,im_blur_y);
drrn(3) = ssim_index(im_shape_y,elt_y);
drrn(4) = ssim_index(im_shape_y,im_blur_y);

fprintf('---------------------------------------\n');
fprintf('---------------------------------------\n');
fprintf('PSNR for ours %f dB\n', drrn(1));
fprintf('PSNR for input %f dB\n', drrn(2));
fprintf('---------------------------------------\n');
fprintf('---------------------------------------\n');
fprintf('SSIM for ours %f dB\n', drrn(3));
fprintf('SSIM for inputs %f dB\n', drrn(4));
fprintf('---------------------------------------\n');
fprintf('---------------------------------------\n');
caffe.reset_all();
figure, imshow(img_output); title('muti-task Reconstruction');
figure, imshow(image_shape); title('sharp Ground Truth');
figure, imshow(image_blur); title('blur and low');

end
toc