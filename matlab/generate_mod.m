clear all;close all;

fsave='./train_h5_down/train';

blur_folder='./img_blur_train/';
sharp_folder='./img_label_train/';

h5_num=1;

size_input=96;
size_label=96;
size_low=96;
stride=27;
count=0;

scale = 4;
down_sample = 3;

data = zeros(size_input, size_input, 3, 1);
label = zeros(size_label, size_label, 3, 1); 
low = zeros(size_low, size_low, 3, 1); 
blur = zeros(size_low, size_low, 3, 1);  
blur_file=dir(fullfile(blur_folder,'*.png'));
sharp_file=dir(fullfile(sharp_folder,'*.png'));

for fnum = 1 : length(blur_file) 
    image_data = imread(fullfile(blur_folder,blur_file(fnum).name));
    image_label = imread(fullfile(sharp_folder,sharp_file(fnum).name));
    
    im_data_double=im2double(image_data);
    im_label_double=im2double(image_label);
    
    [hei,wid,channel]=size(im_data_double);

    im_data_low = imresize(imresize(im_data_double, 1/scale, 'bicubic'), [hei, wid], 'bicubic');%blur+lr
    im_label_low = imresize(imresize(im_label_double, 1/scale, 'bicubic'), [hei, wid], 'bicubic');%lr
    
    for x = 1 : stride : hei-size_input+1
        for y = 1 :stride : wid-size_input+1
            subim_input = im_data_low(x : x+size_input-1, y : y+size_input-1,:);
            subim_label = im_label_double(x : x+size_label-1, y : y+size_label-1,:);
            subim_low = im_label_low(x : x+size_label-1, y : y+size_label-1,:);
            subim_blur = im_data_double(x : x+size_label-1, y : y+size_label-1,:);

            count=count+1;
            
            data(:, :, :, count) = subim_input;
            label(:, :, :, count) = subim_label;
            low(:, :, :, count) = subim_low;
            blur(:, :, :, count) = subim_blur;
        end
    end
    if mod(fnum,100)==0
        order = randperm(count);
        data = data(:, :, :, order);
        label = label(:, :, :, order); 
        low = low(:, :, :, order);
        blur = blur(:, :, :, order);

        %% writing to HDF5
        chunksz = 64;
        created_flag = false;
        totalct = 0;
        %preno=-1;asno=-1;
        for batchno = 1:floor(count/chunksz)
            last_read=(batchno-1)*chunksz;
            batchdata = data(:,:,:,last_read+1:last_read+chunksz);
            batchlabs = label(:,:,:,last_read+1:last_read+chunksz);
            batchlow = low(:,:,:,last_read+1:last_read+chunksz);
            batchblur = blur(:,:,:,last_read+1:last_read+chunksz);
            
            str=num2str(h5_num);
            savepath=strcat(fsave,str);
            savepath=strcat(savepath,'.h5');

            startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,1,1,totalct+1], 'low', [1,1,1,totalct+1], 'blur', [1,1,1,totalct+1]);
            curr_dat_sz = store2hdf5_1(savepath, batchdata, batchlabs, batchlow, batchblur, ~created_flag, startloc, chunksz);
            created_flag = true;
            totalct = curr_dat_sz(end);
        end
        count=0;
        h5_num=h5_num+1;
        h5disp(savepath);
        %% write train.txt
        FILE = fopen('train_h5_down.txt', 'a');

        %% set the path and file name
        fprintf(FILE, '%s\r\n', savepath);
        fclose(FILE);
        fprintf('HDF5 savepath listed in %s \n', 'train_h5_down.txt');
        clear data,clear low,clear blur,clear label,clear batchdata,clear batchlow,clear batchblur,clear batchlabs;
    end
end


    
