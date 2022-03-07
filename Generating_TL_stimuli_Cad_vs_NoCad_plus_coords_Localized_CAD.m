clc;
clear all;
close all;
Char_scale=10;
Char_spann=5;
radius_around_fixation=200;
radius_threshold=0;
image_size=500;
image_center_x=image_size./2;
image_center_y=image_size./2;
noise_intensity=128;
rotation_angles=[1 359];
noise_frequency=-3; % -1, -2, -3
No_overlap=1;
Targ_prevalence=0.5;
Add_noise_to_stimuli=1; % 1=add noise (set letters_intensity=30); 0= no noise added (set letters_intensity = 100),
letters_intensity=30;
Cad_size=80;
Cad_thick=1.5;

Sensitivity=0.75; % TP/T
Specificity=0.9;  % TN/N
False_alams=1-Specificity;  % FP

%% number of charecters stats setting and calculation of proportions
folder=1; %1 or 2: Training set or the test set
folder_to_use={'TrnLocCad', 'LocCad'};
folder_to_use_NoCad={'TrnNoCad', 'NoCad'};
Num_images=20; %20, 240, 20, 240 ; sum of target and non-target stimuli 
num_Chars_mean=5;
num_Chars_max=6;
num_Chars_min=4;
prop_Chars_max=0.2;
prop_Chars_min=0.2;

Targ_inds=1:Num_images./2;
Dist_inds=1:Num_images./2;

Targ_Targ_cued=false(1,length(Targ_inds));
Targ_Targ_cued(randsample(Targ_inds,round(Sensitivity.*length(Targ_inds))))=1;
Targ_Dist_cued=false(1,length(Targ_inds));
Targ_Dist_cued(randsample(Targ_inds(Targ_inds(Targ_Targ_cued==0)),round(False_alams.*length(Targ_inds))))=1;
Dist_Dist_cued=false(1,length(Dist_inds));
Dist_Dist_cued(randsample(Dist_inds,round(False_alams.*length(Dist_inds))))=1;


Targ_Targ_cued_inds=Targ_inds(Targ_Targ_cued);
Num_chars_vector=num_Chars_mean.*ones(1,Num_images);
Num_chars_vector(randsample(Targ_Targ_cued_inds,round(prop_Chars_max*sum(Targ_Targ_cued))))=num_Chars_max;
Num_chars_vector(randsample(Targ_Targ_cued_inds(find(Num_chars_vector(Targ_Targ_cued_inds)~=num_Chars_max)),round(prop_Chars_min*sum(Targ_Targ_cued))))=num_Chars_min;

Targ_Dist_cued_inds=Targ_inds(Targ_Dist_cued);
Num_chars_vector(randsample(Targ_Dist_cued_inds,round(prop_Chars_max*sum(Targ_Dist_cued))))=num_Chars_max;
Num_chars_vector(randsample(Targ_Dist_cued_inds(find(Num_chars_vector(Targ_Dist_cued_inds)~=num_Chars_max)),round(prop_Chars_min*sum(Targ_Dist_cued))))=num_Chars_min;

Targ_uncued=~(Targ_Targ_cued + Targ_Dist_cued);
Targ_uncued_inds=Targ_inds(Targ_uncued); 
Num_chars_vector(randsample(Targ_uncued_inds,round(prop_Chars_max*sum(Targ_uncued))))=num_Chars_max;
Num_chars_vector(randsample(Targ_uncued_inds(find(Num_chars_vector(Targ_uncued_inds)~=num_Chars_max)),round(prop_Chars_min*sum(Targ_uncued))))=num_Chars_min;


Dist_Dist_cued_inds=Dist_inds(Dist_Dist_cued)+Num_images./2;
Num_chars_vector(randsample(Dist_Dist_cued_inds,round(prop_Chars_max*sum(Dist_Dist_cued))))=num_Chars_max;
Num_chars_vector(randsample(Dist_Dist_cued_inds(find(Num_chars_vector(Dist_Dist_cued_inds)~=num_Chars_max)),round(prop_Chars_min*sum(Dist_Dist_cued))))=num_Chars_min;

Dist_uncued=~Dist_Dist_cued;
Dist_uncued_inds=Dist_inds(Dist_uncued)+Num_images./2;
Num_chars_vector(randsample(Dist_uncued_inds,round(prop_Chars_max*sum(Dist_uncued))))=num_Chars_max;
Num_chars_vector(randsample(Dist_uncued_inds(find(Num_chars_vector(Dist_uncued_inds)~=num_Chars_max)),round(prop_Chars_min*sum(Dist_uncued))))=num_Chars_min;

% sum(Num_chars_vector==6)
% sum(Num_chars_vector==4)
% sum(Num_chars_vector==5)
% [sum(Targ_Targ_cued) sum(Targ_Dist_cued) sum(Dist_Dist_cued)]

%% Characters definition
L_x_elements=Char_scale.*[-2 -1 0 1 2 -1 -1 -1 -1 -1];
L_y_elements=Char_scale.*[-1 -1 -1 -1 -1 -2 -1 0 1 2];

% L_x_elements=Char_scale.*[linspace(-2,2,sampling_step) linspace(-1,-1,sampling_step)];
% L_y_elements=Char_scale.*[linspace(-1,-1,sampling_step) linspace(-2,2,sampling_step)];

T_x_elements=Char_scale.*[0 0 0 0 0 -2 -1 0 1 2];
T_y_elements=Char_scale.*[-2 -1 0 1 2 1 1 1 1 1];

images_generated=0;
images_tried_to_generate=0;
Coordinates_chars_xy=nan(Num_images,num_Chars_max*2);
while images_generated < Num_images
    images_tried_to_generate=images_tried_to_generate+1;
    sample_images=uint8(zeros(image_size,image_size,Num_chars_vector(images_generated+1)));
    image_to_find_char_position=uint8(zeros(image_size,image_size,Num_chars_vector(images_generated+1)));
    
    possible_xy_coordinates=randi([1 image_size-10],[Num_chars_vector(images_generated+1) 2]);
    
    c=0;
    for x=1:size(sample_images,1)
        for y=1:size(sample_images,2)
            if abs(pdist([x y;image_center_x image_center_y],'euclidean')-radius_around_fixation)<=radius_threshold
                c=c+1;
                possible_xy_coordinates(c,:)=[x y];
            end
        end
    end
    
    %% subsampling possible locations
    samples_indices=randsample([1:size(possible_xy_coordinates,1)],Num_chars_vector(images_generated+1));
    possible_xy_coordinates=possible_xy_coordinates(samples_indices,:);
    
    if (Targ_prevalence*Num_images)>images_generated
        num_Ls=Num_chars_vector(images_generated+1)-1;
        num_Ts=1;
        Targ_NonTarg='Target';
    else
        num_Ls=Num_chars_vector(images_generated+1);
        num_Ts=0;
        Targ_NonTarg='NoTarg';
    end
    %% Adding Ls
    IN=0;
    gg=0;
    for L_number=1:num_Ls
        IN=IN+1;
        for L_element=1:length(L_x_elements)
            x_pos_elmnt=possible_xy_coordinates(L_number,1)+L_x_elements(L_element);
            y_pos_elmnt=size(sample_images,1)-[possible_xy_coordinates(L_number,2)+L_y_elements(L_element)];
            sample_images(y_pos_elmnt-Char_spann:y_pos_elmnt+Char_spann,x_pos_elmnt-Char_spann:x_pos_elmnt+Char_spann,IN)=letters_intensity;
            if L_element==2 % center of mass of char
                gg=gg+1;
                image_to_find_char_position(y_pos_elmnt-Char_spann:y_pos_elmnt+Char_spann,x_pos_elmnt-Char_spann:x_pos_elmnt+Char_spann,IN)=1;
            end
        end
    end
    
    %% Adding Ts
    for T_number=num_Ls+1:num_Ls+num_Ts
        IN=IN+1;
        for T_element=1:length(T_x_elements)
            x_pos_elmnt=possible_xy_coordinates(T_number,1)+T_x_elements(T_element);
            y_pos_elmnt=size(sample_images,1)-[possible_xy_coordinates(T_number,2)+T_y_elements(T_element)];
            sample_images(y_pos_elmnt-Char_spann:y_pos_elmnt+Char_spann,x_pos_elmnt-Char_spann:x_pos_elmnt+Char_spann,IN)=letters_intensity;
            if T_element==3 % center of mass of char
                gg=gg+1;
                image_to_find_char_position(y_pos_elmnt-Char_spann:y_pos_elmnt+Char_spann,x_pos_elmnt-Char_spann:x_pos_elmnt+Char_spann,IN)=1;
            end
        end
    end
    
    %% Rotating and combining images (individual charecters)
    combined_images=uint8(zeros(image_size));
    tmp_image_char_centres=uint8(zeros(image_size));
    for im=1:IN
        rotation_angles_char(im)=randi([rotation_angles(1) rotation_angles(2)],1);
        combined_images=combined_images+imrotate(sample_images(:,:,im),rotation_angles_char(im),'crop');
        
        s = regionprops(im2bw(imrotate(image_to_find_char_position(:,:,im),rotation_angles_char(im),'crop')*255), 'centroid');
        
        if im<=num_Ls
            L_chars_centroids{im}= round(cat(1, s.Centroid));
            L_chars_centroids_for_exl(1,im*2-1:im*2)= round(cat(1, s.Centroid));
        elseif im>num_Ls
            T_chars_centroids{im-num_Ls}= round(cat(1, s.Centroid));
            T_chars_centroids_for_exl(1,:)= round(cat(1, s.Centroid));
        end
    end
    if Add_noise_to_stimuli==1 && (No_overlap~=1 || sum(sum(combined_images>letters_intensity))==0)
        %% Adding spatial 1/f3 noise
        Noise_mask=spatialPattern([image_size image_size],noise_frequency);
        Noise_mask=((Noise_mask-(min(min(Noise_mask))))./max(max(Noise_mask))).*noise_intensity;
        Fused_image=imfuse(combined_images,uint8(Noise_mask),'blend','Scaling','joint');
        images_generated=images_generated+1;
        
        Coordinates_chars_1st_Column_Ls_2nd_Ts_Rows_Imgs{images_generated,1}=L_chars_centroids;
        Coordinates_chars_exl_tmp(1,:)=L_chars_centroids_for_exl;
        try
            Coordinates_chars_1st_Column_Ls_2nd_Ts_Rows_Imgs{images_generated,2}=T_chars_centroids;
            Coordinates_chars_exl_tmp(1,end+1:end+2)=T_chars_centroids_for_exl;
        end
        Coordinates_chars_xy(images_generated,1:IN*2)=Coordinates_chars_exl_tmp;
        Has_Target_or_Not{images_generated,1}=Targ_NonTarg;
        Number_of_Chars{images_generated,1}=IN;
        Image_names{images_generated,1}=['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use{folder},'_',Targ_NonTarg,'.png'];
        imwrite(Fused_image,['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use_NoCad{folder},'_',Targ_NonTarg,'.png']);
        
        %% adding the red indicator frame
        imshow(Fused_image)
        hold on;
        ggg=0;
        fff=0;
        kkk=0;
        if (Targ_prevalence*Num_images)>=images_generated && sum(Targ_Targ_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-1:end);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
            ggg=ggg+1;
        elseif (Targ_prevalence*Num_images)>=images_generated && sum(Targ_Dist_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-3:end-2);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
            fff=fff+1;
        elseif (Targ_prevalence*Num_images)<images_generated && sum(Dist_Dist_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-1:end);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
            kkk=kkk+1;
        end
        
        imwrite(Fused_image,['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use{folder},'_',Targ_NonTarg,'.png']);
        close all;        
        clearvars L_chars_centroids T_chars_centroids Coordinates_chars_exl_tmp L_chars_centroids_for_exl T_chars_centroids_for_exl

    
    elseif Add_noise_to_stimuli==0 && (No_overlap~=1 || sum(sum(combined_images>letters_intensity))==0)
        Fused_image=combined_images;
        images_generated=images_generated+1;
%         imwrite(Fused_image,['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',Targ_NonTarg,'_no_noise.png']);
        Coordinates_chars_1st_Column_Ls_2nd_Ts_Rows_Imgs{images_generated,1}=L_chars_centroids;
        Coordinates_chars_exl_tmp(1,:)=L_chars_centroids_for_exl;
        try
            Coordinates_chars_1st_Column_Ls_2nd_Ts_Rows_Imgs{images_generated,2}=T_chars_centroids;
            Coordinates_chars_exl_tmp(1,end+1:end+2)=T_chars_centroids_for_exl;
        end
        Coordinates_chars_xy(images_generated,1:IN*2)=Coordinates_chars_exl_tmp;
        Image_names{images_generated,1}=['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use{folder},'_',Targ_NonTarg,'_no_noise.png'];
        Has_Target_or_Not{images_generated,1}=Targ_NonTarg;
        Number_of_Chars{images_generated,1}=IN;
        imwrite(Fused_image,['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use_NoCad{folder},'_',Targ_NonTarg,'_no_noise.png']);
        
        %% adding the red indicator frame
        imshow(Fused_image)
        hold on;
        if (Targ_prevalence*Num_images)>=images_generated && sum(Targ_Targ_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-1:end);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
        elseif (Targ_prevalence*Num_images)>=images_generated && sum(Targ_Dist_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-3:end-2);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
        elseif (Targ_prevalence*Num_images)<images_generated && sum(Dist_Dist_cued_inds==images_generated)>0
            coords_frame=Coordinates_chars_exl_tmp(end-1:end);
            rectangle('Position',[coords_frame-Cad_size./2 Cad_size Cad_size],'EdgeColor','r','LineWidth',Cad_thick)
            S = getframe(gca);
            Fused_image = S.cdata;
        end
        
        imwrite(Fused_image,['Img_',sprintf('%0.3d',images_generated),'_Chars_',num2str(num_Ls+num_Ts),'_',folder_to_use{folder},'_',Targ_NonTarg,'_no_noise.png']);
        close all;
        
        clearvars L_chars_centroids T_chars_centroids Coordinates_chars_exl_tmp L_chars_centroids_for_exl T_chars_centroids_for_exl
    end
    [images_tried_to_generate images_generated]
end
T = table(Image_names,Coordinates_chars_xy,Number_of_Chars,Has_Target_or_Not);
filename = ['Coordinates_charecters_',folder_to_use{folder},'.xlsx'];
writetable(T,filename,'Sheet',1,'Range','A1')
save(['Coordinates_characters_',folder_to_use{folder},'.mat'],'Coordinates_chars_1st_Column_Ls_2nd_Ts_Rows_Imgs','Image_names')
