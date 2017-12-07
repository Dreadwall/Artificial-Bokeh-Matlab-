function [defocused_image] = defocus(Image_Path, alpha)

sigma_s = 2;
sigma_r = 50;
max_window = 25;

%cmu_alpha = 2;
%2_trees_alpha = 3;
%park_alpha = 4;
%forest_painting_lifelike_alpha = 3;
%forest_painting_alpha = 1;
%forest_alpha = 2;








input_image = imread(Image_Path);


%https://users.cs.duke.edu/~tomasi/papers/tomasi/tomasiIccv98.pdf
%Specifies using the CIE LAB color space to help with minimizing error

lab_image = rgb2lab(input_image);

dims = size(lab_image);
defocused_image = lab_image;
depth_map = imresize(mydepthMap(Image_Path), [dims(1) dims(2)]);



%Defocus Based on Window Size
%Pre-compute wide range of Gaussian Distributions based on window_size
for window_size = 0:max_window
    [X,Y] = meshgrid(-window_size:window_size,-window_size:window_size);
    G = exp(-(X.^2+Y.^2)/(2*sigma_s^2));
    windows{window_size+1} = G;
end

        
    
   V = depth_map(:);
   min_depth = min(V);
   median_depth = median(V);
   max_depth = max(V);
   
    

%Using Equations from https://www.csie.ntu.edu.tw/~cyy/courses/vfx/10spring/lectures/handouts/lec14_bilateral_4up.pdf
for i = 1:dims(1)
    for j = 1:dims(2)

        
        depth_at_pixel = depth_map(i,j);
        
        %window_size = round(min(max_window, max(0, 1/alpha * (depth_at_pixel - min_depth)^3 - depth_at_pixel)));
        %window_size = round(min(max_window, max(0, depth_at_pixel - min_depth + alpha)));
        window_size =  round(min(max_window, max(0, depth_at_pixel - median_depth + alpha)));
        
        
        % neighborhood
         iMin = max(i-window_size,1);
         iMax = min(i+window_size,dims(1));
         jMin = max(j-window_size,1);
         jMax = min(j+window_size,dims(2));
         Neighborhood = lab_image(iMin:iMax,jMin:jMax,:);
      
         % get differences
         diff_along_L = Neighborhood(:,:,1)-lab_image(i,j,1);
         diff_along_A = Neighborhood(:,:,2)-lab_image(i,j,2);
         diff_along_B = Neighborhood(:,:,3)-lab_image(i,j,3);
         %https://users.cs.duke.edu/~tomasi/papers/tomasi/tomasiIccv98.pdf
         %specifies euclidian distance
         
         euclid = sqrt(diff_along_L.^2 + diff_along_A.^2 + diff_along_B.^2);
        
         %Gauss Equation (Range Factor)
         Part1 = exp(-euclid/(2*sigma_r^2));
         
         %Gauss Equation (Space Factor)
         G = cell2mat(windows(window_size+1));
         Part2 = G((iMin:iMax)-i+window_size+1,(jMin:jMax)-j+window_size+1);
         
         
         
         bilateral_filter = (Part1.*Part2);
         norm_F = sum(bilateral_filter(:));
         defocused_image(i,j,1) = sum(sum(bilateral_filter.*Neighborhood(:,:,1)))/norm_F;
         defocused_image(i,j,2) = sum(sum(bilateral_filter.*Neighborhood(:,:,2)))/norm_F;
         defocused_image(i,j,3) = sum(sum(bilateral_filter.*Neighborhood(:,:,3)))/norm_F;
      
        
     
    end
end

defocused_image = lab2rgb(defocused_image);
end




