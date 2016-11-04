function varargout = camera_pipeline(varargin)
% CAMERA_PIPELINE MATLAB code for camera_pipeline.fig
%      CAMERA_PIPELINE, by itself, creates a new CAMERA_PIPELINE or raises the existing
%      singleton*.
%
%      H = CAMERA_PIPELINE returns the handle to a new CAMERA_PIPELINE or the handle to
%      the existing singleton*.
%
%      CAMERA_PIPELINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERA_PIPELINE.M with the given input arguments.
%
%      CAMERA_PIPELINE('Property','Value',...) creates a new CAMERA_PIPELINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camera_pipeline_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camera_pipeline_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camera_pipeline

% Last Modified by GUIDE v2.5 03-Nov-2016 22:15:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camera_pipeline_OpeningFcn, ...
                   'gui_OutputFcn',  @camera_pipeline_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before camera_pipeline is made visible.
function camera_pipeline_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camera_pipeline (see VARARGIN)

% Choose default command line output for camera_pipeline
handles.output = hObject;
%TODO
% maximize the GUI 
set(0, 'Unit', 'pixel');
winsize = get(0, 'ScreenSize');

% Set the Gui position
winsize(1) = winsize(1) + 100;
winsize(2) = winsize(2) + 100;
winsize(3) = winsize(3) - 150;
winsize(4) = winsize(4) - 150;
set(gcf, 'Position', winsize);

step = winsize(4) / 16;
% Set the Panel position
set(handles.uipanel1, 'Position', [3/4* winsize(3) + 100, 10, 1/4*winsize(3) - 20, winsize(4) + 50]); 
% Set the Axes position disappear
set(handles.axes1, 'Position', [-10, -10, 5, 5]);
% Update handles structure
handles.myData.winsize = winsize;

%current stage in pipeline
handles.myData.current_stage = zeros(1,1);

pipeline_image = im2double(imread('.\Adobe_DNG_SDK_Pipeline_v4.bmp'));
% set the slider range and step size
numSteps = 11;
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', numSteps);
set(handles.slider1, 'Value', 1);
set(handles.slider1, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.slider1,'Value');
 
 % Update handles structure
handles.pushbutton1Pressed = 0;

guidata(hObject, handles);
% UIWAIT makes camera_pipeline wait for user response (see UIRESUME)
% uiwait(handles.figure1);
showImage(handles, pipeline_image);
% prompt = {'Enter matrix size:','Enter colormap name:'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {'20','hsv'};
% answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

% Get all the handles to everything we want to set in a single array.
handleArray = [handles.pushbutton1, handles.pushbutton12, handles.radiobutton3, handles.radiobutton8, handles.radiobutton15, handles.radiobutton16];
% Set them all disabled.
set(handleArray, 'Enable', 'off');
    
% --- Outputs from this function are returned to the command line.
function varargout = camera_pipeline_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
%%
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
{'*.*',  'All Files (*.*)';
'*.cr2;*.nef;*.pef;','RAW Image Files (*.cr2,*.nef, *.pef)';
'*.dat','Spectral data files (*.dat)'}, ...
   'Pick a file');
if isequal(filename,0) || isequal(pathname,0)
else
    handles.myData.fileName = [pathname filename];

    a = [get(handles.radiobutton15,'Value') get(handles.radiobutton16,'Value') get(handles.radiobutton3,'Value') get(handles.radiobutton8,'Value')];
    fileID = fopen('wbAndGainSettings.txt','w');
    fprintf(fileID,'%d\n',a);
    fclose(fileID);

    rwSettings = [0]; 
    if (get(handles.radiobutton17,'Value') == 1)
        rwSettings(1) = 1;
    end
    if ((get(handles.radiobutton17,'Value') == 0) && (get(handles.radiobutton18,'Value') == 0))
        rwSettings(1) = 2;
    end
    fileID = fopen('rwSettings.txt','w');
    fprintf(fileID,'%d\n',rwSettings);
    fclose(fileID);
    
    
    
    cam_settings = [0]; 
    if (get(handles.radiobutton20,'Value') == 1)
        cam_settings(1) = 1;
    end
    if ((get(handles.radiobutton20,'Value') == 0) && (get(handles.radiobutton19,'Value') == 0))
        cam_settings(1) = 2;
    end
    fileID = fopen('cam_settings.txt','w');
    fprintf(fileID,'%d\n',cam_settings);
    fclose(fileID);    

    my_waitbar = waitbar(0, 'Rendering Image...');
    
    inputFileName = [pathname filename];
    if (handles.lastSliderVal == 1) 
        stage1OutputFileName = [inputFileName(1:end-4) '_stage1.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -1 '  stage1OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage1OutputFileName);
        %imtool(uint8(handles.myData.image/256))
        delete(stage1OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 2) 
        
        a = [0 1 0 1]; % without gain [0 1 ...
        fileID = fopen('wbAndGainSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        stageSettings_indicator = [2];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',stageSettings_indicator);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',stageSettings_indicator);
            fclose(fileID);
        end 
        
        stage2OutputFileName = [inputFileName(1:end-4) '_stage2.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -2 '  stage2OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage2OutputFileName);
        delete(stage2OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end    
    
    if (handles.lastSliderVal == 3) 

        a = [1 0 0 1]; % with gain [1 0 ...
        fileID = fopen('wbAndGainSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);
        
        stageSettings_indicator = [3];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',stageSettings_indicator);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',stageSettings_indicator);
            fclose(fileID);
        end 
        
        stage3OutputFileName = [inputFileName(1:end-4) '_stage3.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -2 '  stage3OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage3OutputFileName);
        delete(stage3OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end        
    
    if (handles.lastSliderVal == 4) 
        a = [4];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        stage4OutputFileName = [inputFileName(1:end-4) '_stage4.tif'];

        if (get(handles.radiobutton17,'Value') == 0 && get(handles.radiobutton18,'Value') == 1 )
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
            system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage4OutputFileName ' ' inputFileName];
            system(system_command);   
            delete(stage4OutputFileName);
        end 
        
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -3 '  stage4OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage4OutputFileName);
        delete(stage4OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end          
    
    if (handles.lastSliderVal == 5) 
        
        a = [5];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 
        %     
        stage5OutputFileName = [inputFileName(1:end-4) '_stage5.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage5OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage5OutputFileName);
        delete(stage5OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 6) 
        
        a = [6];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);
        
        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 

        stage6OutputFileName = [inputFileName(1:end-4) '_stage6.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage6OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage6OutputFileName);
        delete(stage6OutputFileName);   
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 7) 
        
        a = [7];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);
        
        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 

        stage7OutputFileName = [inputFileName(1:end-4) '_stage7.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage7OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage7OutputFileName);
        delete(stage7OutputFileName);
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 8) 
        
        a = [8];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);
        
        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 

        stage8OutputFileName = [inputFileName(1:end-4) '_stage8.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage8OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage8OutputFileName);
        delete(stage8OutputFileName);    
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 9)
        
        a = [9];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 

        stage9OutputFileName = [inputFileName(1:end-4) '_stage9.tif'];
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage9OutputFileName ' ' inputFileName];
        system(system_command);   
        handles.myData.image = imread(stage9OutputFileName);
        delete(stage9OutputFileName);        
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
    if (handles.lastSliderVal == 10)
        
        a = [10];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 
        
        stage10OutputFileName = [inputFileName(1:end-4) '_stage10.tif'];%comment here when dng save tests. 
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage10OutputFileName ' ' inputFileName];%comment here when dng save tests. 
%         stage10OutputFileName = [inputFileName(1:end-4) '_stage10_V3.dng']; %comment out here when dng save tests. 
%         system_command = ['.\dngOneExeSDK\dng_validate.exe -dng '  stage10OutputFileName ' ' inputFileName]; %comment out here when dng save tests. 
        
        system(system_command);   
        handles.myData.image = imread(stage10OutputFileName);%comment here when dng save tests.
        delete(stage10OutputFileName);        %comment here when dng save tests. 
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end

    if (handles.lastSliderVal == 11) 
        
        a = [11];
        fileID = fopen('stageSettings.txt','w');
        fprintf(fileID,'%d\n',a);
        fclose(fileID);

        if (get(handles.radiobutton17,'Value') == 0)
            fileID = fopen('lastStage.txt','w');
            fprintf(fileID,'%d\n',a);
            fclose(fileID);
        end 

        stage11OutputFileName = [inputFileName(1:end-4) '_stage11.tif'];%comment here when dng save tests. 
        system_command = ['.\dngOneExeSDK\dng_validate.exe -16 -cs1 -tif '  stage11OutputFileName ' ' inputFileName];%comment here when dng save tests. 
%         stage11OutputFileName = [inputFileName(1:end-4) '_stage11_V3.dng']; %comment out here when dng save tests. 
%         system_command = ['.\dngOneExeSDK\dng_validate.exe -dng '  stage11OutputFileName ' ' inputFileName]; %comment out here when dng save tests. 
        system(system_command);   
        handles.myData.image = imread(stage11OutputFileName);
        delete(stage11OutputFileName);   %comment here when dng save tests. 
        delete(my_waitbar)       % DELETE the waitbar; don't try to CLOSE it.
    end
    
%     if (handles.lastSliderVal <= 9) 
%         set(handles.pushbutton3, 'Enable', 'on');        
%     end
    set(handles.pushbutton1, 'Enable', 'off');  
    set(handles.pushbutton12, 'Enable', 'on');  
    set(handles.slider1, 'Enable', 'off');  
    % Update handles structure 
    guidata(hObject, handles);
    if (handles.lastSliderVal >= 4) 
        showImage(handles, uint16(handles.myData.image));
    else 
        showImage(handles, handles.myData.image);        
    end
end

function showImage(handles, I)
% I = handles.myData.image;
winsize = handles.myData.winsize;
[wi, hi, ~] = size(I);
ws = winsize(4);
hs = 3/4*winsize(3);
if (ws/hs > wi/hi)
    ws = hs * (wi/hi);
else
    hs = ws * (hi/wi);
end

set(handles.axes1, 'Position', [10, 100, hs - 20, ws - 20]);
set(handles.pushbutton1, 'Parent', handles.uipanel1);
axes(handles.axes1);
% I(:,:,1) = I(:,:,1) ./ max(max(I(:,:,1)));
% I(:,:,2) = I(:,:,2) ./ max(max(I(:,:,2)));
% I(:,:,3) = I(:,:,3) ./ max(max(I(:,:,3)));
imshow(I);
% guidata(hObject, handles);

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
%%
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
%%
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saved_image =handles.myData.image;

% outputFileName = 'current_result.dng';
outputFileName = 'current_result.tif';
t = Tiff(outputFileName,'w');
% 8 bit save works well
output_unit16 = saved_image;

sliderValue =  handles.lastSliderVal;
 
tagstruct.ImageLength = size(output_unit16,1);
tagstruct.ImageWidth = size(output_unit16,2);
tagstruct.BitsPerSample = 16;
if sliderValue == 1 || sliderValue == 2 || sliderValue == 3 
    tagstruct.SamplesPerPixel = 1;
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
else 
    tagstruct.SamplesPerPixel = 3;
    tagstruct.Photometric = Tiff.Photometric.RGB;
end
% tagstruct.RowsPerStrip = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';
% tagstruct.DNGVersion = [1; 4; 0; 0];
t.setTag(tagstruct);

t.write(output_unit16);
t.close();

% 16 bit save does not work well
% output_unit16 = uint16(saved_image*255);
% 
% tagstruct.ImageLength = size(output_unit16,1);
% tagstruct.ImageWidth = size(output_unit16,2);
% tagstruct.Photometric = Tiff.Photometric.RGB;
% tagstruct.BitsPerSample = 16;
% tagstruct.SamplesPerPixel = 3;
% tagstruct.RowsPerStrip = 8; %16 and 32 are also tried. cannot save 16
% bit.
% tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% tagstruct.Software = 'MATLAB';
% t.setTag(tagstruct);
% 
% t.write(output_unit16);
% t.close();

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
%%
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% set(handles.edit32,'String',num2str( get( get(handles.slider1,'Value'))));
% 

  handles = guidata(hObject);
 % get the slider value and convert it to the nearest integer that is less
 % than this value
 newVal = floor(get(hObject,'Value'));
 % set the slider value to this integer which will be in the set {1,2,3,...,12,13}
 set(hObject,'Value',newVal);
 % now only do something in response to the slider movement if the 
 % new value is different from the last slider value
 if newVal ~= handles.lastSliderVal
     % it is different, so we have moved up or down from the previous integer
     % save the new value
     handles.lastSliderVal = newVal;
     guidata(hObject,handles);
    % display the current value of the slider
    disp(['at slider value ' num2str(get(hObject,'Value'))]);
 end
 
 sliderValue =  handles.lastSliderVal;
 set(handles.text3,'String',num2str(sliderValue));
 
if sliderValue >= 4
    % Get all the handles to everything we want to set in a single array.
    handleArray = [handles.radiobutton15, handles.radiobutton16];
    % Set them all disabled.
    set(handleArray, 'Enable', 'on');
    if sliderValue >= 5
        % Get all the handles to everything we want to set in a single array.
        handleArray = [handles.radiobutton3, handles.radiobutton8, handles.radiobutton15, handles.radiobutton16];
        % Set them all disabled.
        set(handleArray, 'Enable', 'on');        
    end
end
if sliderValue < 4
    % Get all the handles to everything we want to set in a single array.
    handleArray = [handles.radiobutton3, handles.radiobutton8, handles.radiobutton15, handles.radiobutton16];
    % Set them all disabled.
    set(handleArray, 'Enable', 'off');    
end
if sliderValue < 5
    % Get all the handles to everything we want to set in a single array.
    handleArray = [handles.radiobutton3, handles.radiobutton8];
    % Set them all disabled.
    set(handleArray, 'Enable', 'off');        
end

% if sliderValue >= 4
%     % Set them all disabled.
%     set(handles.pushbutton3, 'Enable', 'off');
% end
if sliderValue >= 1
    % Set them all disabled.
    set(handles.pushbutton1, 'Enable', 'on');  
end
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
