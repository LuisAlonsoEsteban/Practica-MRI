%% Autores: Mikel Catalina Olazaguirre, Susana del Riego Gómez y Luis Alonso Esteban
% Asignatura: Grandes Equipamientos Médicos
% Máster en Ingeniería Biomédica
% Tecnun - Universidad de Navarra
% Enero de 2023

%% Instructions to read files:
clear all;
close all;

%1. Choose Gd or Fruit
Phantom_or_Fruit= input('Choose image folder. Input for (1) Phantom or(2) Fruit ');
if (Phantom_or_Fruit == 1)
    phantomPath = 'Phantom';
elseif (Phantom_or_Fruit == 2)
    phantomPath = 'Fruit';
end

%2. Choose sequence
dicompath_GRE_T2star =['1_ImgSymphony',filesep,phantomPath,filesep,'1_GRE_T2star',filesep];
dicompath_SE_T2=['1_ImgSymphony',filesep,phantomPath,filesep,'2_SE_T2',filesep];
dicompath_SE_T1=['1_ImgSymphony',filesep,phantomPath,filesep,'3_SE_T1',filesep];
fileExt='*.IMA';
minimum=0;
nc=4;
dicompathC = input('Choose path. Input for (1) GRE T2star, (2) SE T2,(3) SE T1 ');
if (Phantom_or_Fruit ==1 && dicompathC ==1)
    dicompath = dicompath_GRE_T2star;
    nameSeq='GRE'; %Gradient Echo
    maximum=150;
    nf=3;
    eq = 'a*exp(-b*x)'; % M = M_0*e^(-t/T2*)
    constant = 'T2*';
    te_r = 4:5:59;
elseif (Phantom_or_Fruit ==1 && dicompathC ==2)
    dicompath = dicompath_SE_T2;
    nameSeq='SE'; %Spin Echo
    fileExt='*.dcm';
    maximum=600;
    nf=8;
    eq = 'a*exp(-b*x)'; % M = M_0*e^(-t/T2)
    constant = 'T2';
    te_r = 10:10:320;
elseif (Phantom_or_Fruit ==1 && dicompathC ==3)
    dicompath = dicompath_SE_T1;
    nameSeq='SE'; %Spin Echo
    maximum=1300;
    nc=3;
    nf=3;
    eq = 'a*(1-exp(-b*x))'; % M = M_0*(1-e^(-t/T1))
    constant = 'T1';
    te_r = 20:20:100;
    te_r = [te_r 500 1000 5000 7000];
elseif (Phantom_or_Fruit ==2 && dicompathC ==1)
    dicompath = dicompath_GRE_T2star;
    nameSeq='GRE'; %Gradient Echo
    maximum=200;
    nf=1;
    eq = 'a*exp(-b*x)'; % M = M_0*e^(-t/T2*)
    constant = 'T2*';
    te_r = [5 10 30 60];
elseif (Phantom_or_Fruit ==2 && dicompathC ==2)
    dicompath = dicompath_SE_T2;
    nameSeq='SE'; %Spin Echo
    maximum=800;
    nf=1;
    eq = 'a*exp(-b*x)'; % M = M_0*e^(-t/T2)
    constant = 'T2';
    te_r = [10 30 60 100];
elseif (Phantom_or_Fruit ==2 && dicompathC ==3)
    dicompath = dicompath_SE_T1;
    nameSeq='SE'; %Spin Echo
    maximum=1500;
    nf=1;
    eq = 'a*(1-exp(-b*x))'; % M = M_0*(1-e^(-t/T1))
    constant = 'T1';
    te_r = [500 1000 2000 5000];
end

%3. Read images:
folderfiles = dir([dicompath '*']); folderfiles(1:2)=[];
nimages = length(folderfiles); % Number of files found
z=1;
for ii=1:nimages
    SequenceDirectory = strcat(dicompath,folderfiles(ii).name);
    imagefile = dir([SequenceDirectory filesep fileExt]);
    ImageDirectory = strcat(dicompath,folderfiles(ii).name,filesep,imagefile.name);
    currentimage = dicomread(ImageDirectory);
    currentimage = double(currentimage);
    images{z} = currentimage;
    sequence_name{z,1} = folderfiles(ii).name;
    images_names{z,1} = imagefile.name;
    z=z+1;
end

%4. Plot files
figure,
for ii=1:nimages
    subplot(nf,nc,ii), imshow(images{ii},[minimum maximum]);
    colormap('gray')
    currentfilename = strcat(dicompath,sequence_name(ii),filesep,images_names(ii));
    title(sequence_name(ii), 'Interpreter', 'none');
    [m(ii),n(ii)] = size(images{ii});
    colorbar
end

set(gcf, 'Position', get(0, 'Screensize'))
disp (['Resolution cols: ', num2str(m)])
disp (['Resolution rows: ', num2str(n)])

%% Create variable with ROIs
if (Phantom_or_Fruit == 1)

    create_ROI = true;
    sz = size(images{1});
    
    if ((strcmp(constant,'T2*') && isfile("roisT2star.mat")) || ...
            (strcmp(constant,'T2') && isfile("roisT2.mat")) || ...
            (strcmp(constant,'T1') && isfile("roisT1.mat")))
        correct_answer = false;
        while (~correct_answer)
            prompt = "¿Quieres crear unas nuevas ROIs de " + sz(1) + "x" + sz(2) + "? [Y/N] ";
            answer_create_ROI = input(prompt,"s");
            correct_answer = true;
            if (answer_create_ROI == 'N' || answer_create_ROI == 'n')
               create_ROI = false;
            elseif (answer_create_ROI ~= 'Y' && answer_create_ROI ~= 'y')
                disp("Respuesta incorrecta. ")
                correct_answer = false;
            end
        end
    end
    

    % If ROIs have not been created yet or the user wants to create new
    % ROIs, the first image is opened and roipoly function is called, in 
    % order to define the ROI. Once all 14 ROIs have been defined, their 
    % masks are stored in a 3-dimensional matrix and saved into a variable 
    % called 'roisT1.mat', 'roisT2.mat' or 'roisT2star.mat'

    if (create_ROI)
        BW = zeros(sz(1),sz(2),14);
        for i = 1:14
            imshow(images{1},[])
            BW(:,:,i) = roipoly;
            close
        end
        
        if (strcmp(constant,'T2*'))
            save('roisT2star','BW')
        elseif (strcmp(constant,'T2'))
            save('roisT2','BW')
        elseif (strcmp(constant,'T1'))
            save('roisT1','BW')
        end
    end

end

%% Phantom: ROIs

if (Phantom_or_Fruit == 2)
    disp("ERROR: Esta funcionalidad solo está disponible para imágenes del fantoma.")
    return
end

% Load ROI masks. If these have not been defined, the code raises an error.
try
    if (strcmp(constant,'T2*'))
        load('roisT2star.mat')
    elseif (strcmp(constant,'T2'))
        load('roisT2.mat')
    elseif (strcmp(constant,'T1'))
        load('roisT1.mat')
    end
catch exception
    disp("ERROR: Primero debes crear las ROIs")
    return
end


% Procedure:
% 1. Calculate ROI intensities (14 ROIs x n images)
% 2. Fit them to the magnetization function
% 3. Obtain the time constant
% 4. Plot them

figure('Units','normalized','Position',[0 0 1 1])
te_r_amp = [0 te_r];
for i = 1:14 % Number of ROIs
    intensities = zeros(nimages + 1,1);
    for j = 1:nimages
        im = BW(:,:,i) .* images{j};
        intensities(j+1) = mean(nonzeros(im));
    end

    mgn_trans = fittype(eq); % b=1/T2*, b=1/T2, b=1/T1

    max_int = max(intensities);
    min_int = min(intensities);
    range_int = max_int - min_int;
    [cfit,gor,output] = fit(te_r',intensities(2:end),mgn_trans,...
        'Lower',[max_int - 0.2*range_int,0.0001],'Upper',[max_int + 0.7*range_int,1],'StartPoint',[max_int + 0.1*range_int,0.001]);
    
    % In order to represent magnetization from t=0, the M_0
    % ('a' in our equations) is set as the first element in the intensities 
    % vector. If T1 is being calculated, the longitudinal magnetization at 
    % t=0 will always be 0. If T2 or T2* are being calculated, the 
    % transverse magnetization at t=0 is not trivial, but the fitting 
    % object returns this value.
    if (constant == "T1")
        intensities(1) = 0; 
    else
        intensities(1) = cfit.a; 
    end

    t = 1/cfit.b;

    subplot(4,4,i)
    plot(cfit,te_r_amp,intensities)
    title(constant + ": " + t)
    if (strcmp(constant,'T1'))
        xlabel('TR')
    else
        xlabel('TE')
    end
    ylabel("Signal")
    % Delete the legend
    lgd = findobj('type','legend');
    delete(lgd)

end

% Set unique legend
legend({'Valores de intensidad','Curva de ajuste'},...
    'NumColumns',2,'Position',[0.65 0.1 0.15 0.15],...
    'FontSize',10,'FontWeight','bold',...
    'Color',[.9882 .8941 .7686],'EdgeColor',[.9725 .6471 .2157],'LineWidth',1.5);

%% Phantom and Fruit: Pixel by pixel

nrows = max(n);
ncols = max(m);
map = zeros(nrows,ncols);
intensities = zeros(nimages,1);


% Procedure:
% 1. Calculate every pixel intensities through all images
% 2. Fit them to the magnetization function
% 3. Obtain the time constant
% 4. Plot the color map with time constant values for each pixel

tic
last_progress_int = 0;
for x = 1:nrows
    % Print execution progress in command window
    progress_int = floor(100*x/nrows);
    if (progress_int ~= last_progress_int)
        disp(progress_int + " %")
        last_progress_int = progress_int;
    end

    for y = 1:ncols
        for z = 1:nimages
            intensities(z) = images{z}(x,y);
        end

        mgn_trans = fittype(eq); % b=1/T2*, b=1/T2, b=1/T1
        
        max_int = max(intensities);
        min_int = min(intensities);
        range_int = max_int - min_int;
        [cfit,gor,output] = fit(te_r',intensities,mgn_trans,...
            'Lower',[max_int,0.0001],'Upper',[max_int + 0.5*range_int,1],'StartPoint',[max_int + 0.1*range_int,0.001]);
        
        t = 1/cfit.b;
        map(x,y) = t;
    end
end

time_elapsed = toc;
disp("Tiempo de ejecución: " + time_elapsed + " segundos")

if (Phantom_or_Fruit == 1)
    uint8_map = uint8(map);
    imshow(uint8_map,[],Colormap=copper)
    title("Mapa de valores del fantoma " + constant)
    colorbar
else 
    uint8_map = uint8(map);
    imshow(uint8_map,[],Colormap=copper)
    title("Mapa de valores de la fruta " + constant)
    colorbar
end

