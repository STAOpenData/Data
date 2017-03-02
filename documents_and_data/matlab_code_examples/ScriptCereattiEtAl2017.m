% -------------------------------------------------------------------------
%%
% Reference:
% Cereatti et al. (2017). Standardization proposal of soft tissue artefact 
%                         description and data exchange for data sharing in
%                         human motion measurements. To be published
%
% Grimpampi et al. (2014). Metrics for describing soft-tissue artefact and 
%                          its effect on pose, size, and shape of marker
%                          clusters. IEEE Trans. Biomed. Eng. 61, 362–367.
%
%%

% Version: 1.1
% Tecla Bonci
% Life and Health Sciences, Aston University, Birmingham, UK
%
% Interuniversity Centre of Bioengineering of the Human Neuromusculoskeletal
%    system, University of Rome “Foro Italico”, Rome, Italy
%
% 2016 Dec 29
% -------------------------------------------------------------------------

clear all
close all
clc

% select the dataSample_*.mat of interest
[a,b] = uigetfile ('*.mat');
data = load([b,a]);
dataSample = fieldnames(data);
disp(strcat('Load data:  ',dataSample))
Seg = fieldnames(data.(dataSample{1}).subj01.trial01);

%% 3D Skin marker trajectories - ACS and ALs - PLOTS
t = [0 0 0]';
R = eye(3);
scale = 100; % scale factor for the axes dimension
linewidth = 2;

% A graph is created for each segment in the structure
for seg = 1:size(Seg,1)
    
    % Skin-marker trajectories in the ACS
    % Check that mrk coordinates are available
    check = strcmp(fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg})), 'mrk');
    if find(check)
        figure('Name',strcat((Seg{seg}),' mkr + ALs - ARF'),'NumberTitle','off')
        set3Dview
        hold on      
        mrk = fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg}).mrk);
        
        for i =1:size(mrk,1)
            hold on          
            mrkNow = data.(dataSample{1}).subj01.trial01.(Seg{seg}).mrk.(mrk{i});
            plot3d_tb(mrkNow,'b',5)
        end
    end    
    
    % ACS
    my3Dplot(t,R,scale,linewidth)
    
    % Check that AL coordinates are available
    check = strcmp(fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg})), 'ALs');
    if find(check)
        mrk = fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg}).ALs);
        for i =1:size(mrk,1)
            mrkNow = data.(dataSample{1}).subj01.trial01.(Seg{seg}).ALs.(mrk{i});
            plot3d_tb(mrkNow','.k',30)
            text(mrkNow(1,1),mrkNow(2,1),mrkNow(3,1),...
                strcat('\leftarrow -',(mrk{i})),'FontSize',10)
        end
    end  
    axis equal
end

%% STA Parameters for each segment calculated as detailed in the manuscript
for seg = 1:size(Seg,1)
    check = strcmp(fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg})), 'mrk');
    if find(check)
        mrk = fieldnames(data.(dataSample{1}).subj01.trial01.(Seg{seg}).mrk);
        [rmsd, deltap, d] = STA_Parameters(data.(dataSample{1}).subj01.trial01.(Seg{seg}).mrk,mrk');      

        figure('Name',strcat('rms(d) and delta p -',(Seg{seg})),'NumberTitle','off')
        subplot(121)
        boxplot([rmsd.mod,rmsd.x, rmsd.y, rmsd.z], 'Labels',{'rms(d)','rms(d_x)','rms(d_y)','rms(d_z)'})
        title('rms(d)', 'fontweight','bold','FontSize', 14);
        ylabel('[mm]', 'FontSize', 12);

        subplot(122)
        boxplot([deltap.max, deltap.x, deltap.y, deltap.z],'Labels',{'deltap_max','deltap_x','deltap_y','deltap_z'})
        title('delta p','fontweight','bold', 'FontSize', 14);
        ylabel('[mm]', 'FontSize', 12);
        
        figure('Name','Instantaneous displacement vector','NumberTitle','off')
        title(strcat('Instantaneous displacement vector -',(Seg{seg})),'fontweight','bold', 'FontSize', 14);
        set3Dview
        hold on
        mrk = fieldnames(d);
        cc = hsv(size(mrk,1));
        for i =1:size(mrk,1)
            hold on
            plot3(d.(mrk{i})(:,1),d.(mrk{i})(:,2),d.(mrk{i})(:,3),'-', 'MarkerSize',2,'color',cc(i,:))

        end
        xlabel('x  [mm]')
        ylabel('y  [mm]')
        zlabel('z  [mm]')
    end
end