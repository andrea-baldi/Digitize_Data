% Baldi Lab 16/04/2022
clear all;
close all;

% Select the figure you want to digitize
filename = uigetfile('*');

% Read image
image=imread(filename);

% Averages the RGB components of the image and plot
imageave=sum(image./size(image,3),3);
screen_size = get(0,'ScreenSize');
f1 = figure(1);
imshow(imageave,[]);
set(f1,'Position',[0 0 screen_size(3) screen_size(4)]);

% Define your axes limits
prompt = {'Enter xmin:','Enter xmax:','Enter ymin:','Enter ymax:'};
dlg_title = 'Input parameters';
num_lines = 1;
def = {'','','',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);
xmin=str2num(answer{1});
xmax=str2num(answer{2});
ymin=str2num(answer{3});
ymax=str2num(answer{4});

% Check if any axis is in log scale
buttonx = questdlg('Is the x-axis in log scale?');
buttony = questdlg('Is the y-axis in log scale?');

% Select xmin, xmax, ymin, ymax
title(['Select xmin = ',num2str(xmin)],'Fontsize',20);
[x0(1),y0(1)]=ginput(1);
title(['Select xmax = ',num2str(xmax)],'Fontsize',20);
[x0(2),y0(2)]=ginput(1);
title(['Select ymin = ',num2str(ymin)],'Fontsize',20);
[x0(3),y0(3)]=ginput(1);
title(['Select ymax = ',num2str(ymax)],'Fontsize',20);
[x0(4),y0(4)]=ginput(1);
title('Now click on the data points and press enter when done','Fontsize',20);

% Select npoints on the plot
[x,y]=ginput(10000);
close

% Coordinate transformations
if strcmp(buttonx,'No')==1;
    output(:,1)=[(x-x0(1))/(x0(2)-x0(1))].*(xmax-xmin)+xmin;
else if strcmp(buttonx,'No')==0;
        output(:,1)=exp([(x-x0(1))/(x0(2)-x0(1))].*log(xmax/xmin)+log(xmin));
    end
end
if strcmp(buttony,'No')==1;
    output(:,2)=[(y-y0(3))/(y0(4)-y0(3))].*(ymax-ymin)+ymin;
else if strcmp(buttony,'No')==0;
        output(:,2)=exp([(y-y0(3))/(y0(4)-y0(3))].*log(ymax/ymin)+log(ymin));
    end
end

% Plot result
figure
if strcmp(buttony,'No')==1;
    plot(output(:,1),output(:,2),'-o')
else if strcmp(buttony,'No')==0;
        semilogy(output(:,1),output(:,2),'-o')
    end
end

% Save results
button = questdlg('Do you want to save the digitized data as a txt file?')
if strcmp(button,'Yes')==1
    prompt = {'Write file name without extension:'};
    dlg_title = '';
    num_lines = 1;
    def = {''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    dlmwrite([answer{1},'.txt'],output,'\t');
end
