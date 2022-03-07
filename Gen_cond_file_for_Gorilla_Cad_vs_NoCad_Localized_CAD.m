clc;
clear all;
close all;
subject_group=1; %group 1=blocks 1 and 2 and then 3 and 4, 3and4 and then 1and2

for folder=1:4 % When changing it pay attention to all places where the variable "folder" is used
    folder_to_use={'TrnLocCad', 'LocCad', 'TrnNoCad', 'NoCad'};
    
    Specificity=0.9;
    Sensitivity=0.75;
    
    dirs=dir(['C:\Users\hk01\Documents\Hamid\Postdocs\Cambridge\Scientific\Projects\Blake\',folder_to_use{folder}]);
    
    c=0;
    d=0;
    for i=3:length(dirs)
        if strncmp(dirs(i).name,'Img',3)
            if strcmp(dirs(i).name(end-9:end-4),'Target')
                c=c+1;
                Target_indices(c)=i-2;
            else
                d=d+1;
                NoTarg_indices(d)=i-2;
            end
        end
    end
    inds_sensit_correct_Target=randsample(Target_indices,Sensitivity*length(Target_indices));
    inds_specif_correct_NoTarg=randsample(NoTarg_indices,Specificity*length(NoTarg_indices));
    
    if folder==1 || folder==3
        c=2;
        d=1;
    else
        c=1;
        d=0;
    end
    for i=3:length(dirs)-1
        c=c+1;
        if strncmp(dirs(i).name,'Img',3)
            images{c,1}=dirs(i).name;
            if sum((c-1)==Target_indices)
                Target{c,1}='Yes';
                ANSWER{c,1}='k';
                if folder==1 || folder==2
                    if sum(inds_sensit_correct_Target==(c-1))>0
                        mask{c,1}='Gray.png';
                    else
                        mask{c,1}='Gray.png';
                    end
                else
                    mask{c,1}='Gray.png';
                end
            else
                Target{c,1}='No';
                ANSWER{c,1}='s';
                if folder==1 || folder==2
                    if sum(inds_specif_correct_NoTarg==(c-1))>0
                        mask{c,1}='Gray.png';
                    else
                        mask{c,1}='Gray.png';
                    end
                else
                    mask{c,1}='Gray.png';
                end
            end
        end
        randomise_trials{c,1}=1;
        randomise_blocks{c,1}=1;
        Subject_groups{c,1}=subject_group;
        
        display{1,1}='Sample_stimuli';
        display{1+d,1}='Instruction_initial';
        
        if folder==1
            initial_stimulus_presentation{1,1}=['<p style="text-align: center;"> <br/><br/><strong>Sample stimuli:<br/><br/><br/></strong> You can see a sample screen with a <strong>''T''</strong> on the right (as indicated by the red circle) and a sample screen with no <strong>''T''</strong>s on the left. <br/><br/><br/> Your task is to detect screens with a <strong>''T''</strong> among <strong>''L''</strong>s.  <br/><br/><br/>There will be no red circle to indicate the <strong>''T''</strong> in the experiment. <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> if you can see the difference between the <strong>''T''</strong> and <strong>''L''</strong>s to see more details.</p>'];
            display_text{2,1}=['<p style="text-align: center;"> <br/><br/><strong>Training Block:<br/><br/><br/></strong> <br/><br/><br/>Press <strong>''K''</strong> if you see a <strong>''T''</strong> (as in the right example), and <strong>''S''</strong> if you do not (as in the left example).     <br/><br/><br/>Please respond as <strong>''rapidly''</strong> and <strong>''accurately''</strong> as possible. <br/><br/><br/>Computer will try to help by putting a <strong>''RED''</strong> frame around screens with a <strong>''T''</strong> and a <strong>''GRAY''</strong> frame otherwise.     <br/><br/><br/>The computer is <strong>''NOT''</strong> always right!!! <br/><br/><br/>Get ready!  <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> to start. </p>'];
        elseif folder==2
            display_text{1,1}=['<p style="text-align: center;"> <br/><br/><strong>Testing Block:<br/><br/><br/></strong> <br/><br/><br/>Press <strong>''K''</strong> if you see a <strong>''T''</strong> (as in the right example), and <strong>''S''</strong> if you do not (as in the left example).     <br/><br/><br/>Please respond as <strong>''rapidly''</strong> and <strong>''accurately''</strong> as possible. <br/><br/><br/>Computer will try to help by putting a <strong>''RED''</strong> frame around screens with a <strong>''T''</strong> and a <strong>''GRAY''</strong> frame otherwise.     <br/><br/><br/>The computer is <strong>''NOT''</strong> always right!!! <br/><br/><br/>Get ready!  <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> to start. </p>'];
        elseif folder==3
            initial_stimulus_presentation{1,1}=['<p style="text-align: center;"> <br/><br/><strong>Sample stimuli:<br/><br/><br/></strong> You can see a sample screen with a <strong>''T''</strong> on the right (as indicated by the red circle) and a sample screen with no <strong>''T''</strong>s on the left. <br/><br/><br/> Your task is to detect screens with a <strong>''T''</strong> among <strong>''L''</strong>s.  <br/><br/><br/>There will be no red circle to indicate the <strong>''T''</strong> in the experiment. <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> if you can see the difference between the <strong>''T''</strong> and <strong>''L''</strong>s to see more details.</p>'];
            display_text{2,1}=['<p style="text-align: center;"> <br/><br/><strong>Training Block:<br/><br/><br/></strong> <br/><br/><br/>Press <strong>''K''</strong> if you see a <strong>''T''</strong> (as in the right example), and <strong>''S''</strong> if you do not (as in the left example).     <br/><br/><br/>Please respond as <strong>''rapidly''</strong> and <strong>''accurately''</strong> as possible. <br/><br/><br/><br/><br/>Get ready!                     <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> to start. </p>'];
        elseif folder==4
            display_text{1,1}=['<p style="text-align: center;"> <br/><br/><strong>Testing Block:<br/><br/><br/></strong> <br/><br/><br/>Press <strong>''K''</strong> if you see a <strong>''T''</strong> (as in the right example), and <strong>''S''</strong> if you do not (as in the left example).     <br/><br/><br/>Please respond as <strong>''rapidly''</strong> and <strong>''accurately''</strong> as possible. <br/><br/><br/><br/><br/>Get ready!                     <br/><br/><br/>Press the <strong>''SPACEBAR''</strong> to start. </p>'];
        end
        display{c,1}='Trial_images';
        display_text{c,1}=[];
        initial_stimulus_presentation{c,1}=[];
        
        % instruction images and masks
        if sum((c-1)==Target_indices)
            image_instrct_Target{1+d,1}=images{c,1};
        else
            image_instrct_NoTarg{1+d,1}=images{c,1};
        end
        image_instrct_Target{c,1}=[];
        image_instrct_NoTarg{c,1}=[];
        
        if sum((c-1)==Target_indices)
            unmasked_Target{1,1}='Img_001_NoChars_5_Target_no_noise.png';
        else
            unmasked_NoTarg{1,1}='Img_001_NoChars_5_NoTarg_no_noise.png';
        end
        unmasked_Target{c,1}=[];
        unmasked_NoTarg{c,1}=[];
        
        
        
        if folder==1 || folder==2
            mask_instrct_Target{1+d,1}='Gray.png';
            mask_instrct_NoTarg{1+d,1}='Gray.png';
        elseif folder==3 || folder==4
            mask_instrct_Target{1+d,1}='Gray.png';
            mask_instrct_NoTarg{1+d,1}='Gray.png';
        end
        mask_instrct_Target{c,1}=[];
        mask_instrct_NoTarg{c,1}=[];
        
    end
    display{c+1,1}='Instruction_final';
    display_text{c+1,1}=['<p style="text-align: center;">   <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>Block finished.   <br/><br/><br/>Good job!</p>'];
    initial_stimulus_presentation{c+1,1}=[];
    
    randomise_blocks{c+1,1}=[];
    randomise_trials{c+1,1}=[];
    ANSWER{c+1,1}=[];
    images{c+1,1}=[];
    mask{c+1,1}=[];
    Target{c+1,1}=[];
    ANSWER{c+1,1}=[];
    Subject_groups{c+1,1}=[];
    image_instrct_Target{c+1,1}=[];
    image_instrct_NoTarg{c+1,1}=[];
    unmasked_Target{c+1,1}=[];
    unmasked_NoTarg{c+1,1}=[];
    mask_instrct_Target{c+1,1}=[];
    mask_instrct_NoTarg{c+1,1}=[];
    
    T = table(randomise_blocks,randomise_trials,display,ANSWER,images,mask,Target,Subject_groups,display_text,initial_stimulus_presentation,image_instrct_Target,image_instrct_NoTarg,unmasked_Target,unmasked_NoTarg,mask_instrct_Target,mask_instrct_NoTarg);
    filename = [folder_to_use{folder},'_Group_',num2str(subject_group),'_Gray_borders.xlsx'];
    writetable(T,filename,'Sheet',1,'Range','A1')
    clearvars -except subject_group
end