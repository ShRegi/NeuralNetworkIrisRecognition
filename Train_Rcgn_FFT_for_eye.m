%Reads initial images and train NN to be used further by recog_FFT

clear
indirname=input('Input dirname(Iris0): ','s');
%samples=input('Number of images: ');
samples=10;
wcd=cd;  Inwcd=[wcd, '\',indirname,'\'];
filenmb=0;  clf, hold off 
SpHarms=200; %240; 
SpHarms2=10; %Number of space frequencies for training
HarmIndices=(-SpHarms/2:SpHarms/2-1);
%HarmIndices2=(-SpHarms2/2:SpHarms2/2-1);
MinIn=-1; MaxIn=1044;
%maxro=input('Size of image: ');
 delro=1; maxro=200;
 maxro=(maxro/2)-1;
 if rem(maxro, 2)==1
     maxro=maxro-1;
 end
 delphi=2*pi/((maxro-20)/delro); 
 Img_FFT2 = [];
for ii=1:samples
   Imag=imread([Inwcd,num2str(filenmb)],'bmp'); %imshow(I),figure(gcf)
  
%    Gray(:,:) = round((Imag(:,:,1) +Imag(:,:,2)/5+Imag(:,:,3)/5)/1.4);
   Rgb_to_Gray
imshow(Gray), pause;
   img_inf=imfinfo([Inwcd,num2str(filenmb)],'bmp'); 
   %img_inf.Height   img_inf.Width
   addX=round(img_inf.Width/2);  addY=round(img_inf.Height/2);
   %[PwFourTrn(:,ii), rows]=fft4ringse2(Imag, delphi, delro, maxro, addX, addY);
    [PwFourTrn(:,ii), rows]=fft4rings(Gray, delphi, delro, maxro, addX, addY);
%  Img_FFT2(1:2*((SpHarms/2)-SpHarms2), ii) = PwFourTrn(SpHarms2:2*SpHarms2, ii);
   Img_FFT(1:SpHarms/2,ii) = PwFourTrn((rows-SpHarms/2):(rows-1),ii);
   Img_FFT((SpHarms/2+1):SpHarms,ii) = PwFourTrn(2:(SpHarms/2+1),ii);
   
   IMG_FFT_Temp = [PwFourTrn(2:(SpHarms/2+1),ii); PwFourTrn((rows-SpHarms/2):(rows-1),ii)];
   Img_FFT2 = [Img_FFT2 IMG_FFT_Temp(SpHarms2:(SpHarms - SpHarms2))];
   %plot(Img_FFT(:,ii)); grid on; figure(gcf); 
   %title(num2str(filenmb)), pause
   filenmb=filenmb+1;  
end
close
Img_FFT=round(Img_FFT/max(max(Img_FFT)).*1020); 
Img_FFT2=round(Img_FFT2/max(max(Img_FFT2)).*1020);
figure(gcf);
Fsize=16; %Future FontSize
hold off
for ii=1:samples, 
plot(HarmIndices, Img_FFT,'-black'); grid on; hold on; % pause
end
x1=xlabel('     Spatial Frequency'); y1=ylabel('FFT for Arrays of Rings');
set(x1,'FontAngle','italic','FontSize',Fsize);
set(y1,'FontAngle','italic','FontSize',Fsize);
set(gca,'Fontsize',Fsize); pause; close

% Building up NN
Img_Indx = [0 1 2 3 4 5 6 7 8 9 10]; 
InNrns=11;  %Number of neurons in 1st layer
Input_Lims=zeros(SpHarms, 2);

szInp = size(Img_FFT2, 1);
Input_Lims_2=zeros(szInp, 2);
for ii=1:SpHarms,  Input_Lims(ii, 1)=MinIn; Input_Lims(ii, 2)=MaxIn; end
for ii=1:szInp,  Input_Lims_2(ii, 1)=MinIn; Input_Lims_2(ii, 2)=MaxIn; end
%for ii=SpHarms2:(SpHarms/2)+SpHarms2,  Input_Lims(ii, 1)=MinIn; Input_Lims(ii, 2)=MaxIn; end
% Rx2 matrix of min and max values for R input elements.
Layers=[InNrns 1]; % Size of ith layer, for Nl layers.
% net = newff(Input_Lims,[S1 S2...SNl],{TF1 TF2...TFNl},BTF,BLF,PF)
%{'tansig', 'purelin'};%Transfer function of ith layer, default = 'tansig'.
% BTF='traingdm';% - Backprop network training function, default = 'trainlm'.
% BTF='traingda'; BTF='trainrp';  BTF='traincgf'; BTF='traincgb'; BTF='trainscg';
%   BLF - Backprop weight/bias learning function, default = 'learngdm'.
%   PF  - Performance function, default = 'mse'.
%BTF='trainlm';
BTF='trainscg';%'trainrp';%'traingdm';%'traingda';% %'traincgb''traincgf'
%  net1=newff(Input_Lims, Layers,{'tansig', 'purelin'}, BTF);
% net1.trainParam.show=5;
% net1.trainParam.lr=.05; net1.trainParam.epochs=800;
% net1.trainParam.goal=1.7e-5; %0.7e-5;
% net1.trainParam.mu=0.001; net1.trainParam.mu_max=1e+10;
% net1=train(net1,  Img_FFT(:,1:samples),Img_Indx(1,1:samples)); 	grid on;
% Y =  sim(net1, Img_FFT)
% Y=round(Y)

net2=newff(Input_Lims_2, Layers,{'tansig', 'purelin'}, BTF);
net2.trainParam.show=5;
net2.trainParam.lr=.05; net2.trainParam.epochs=2000;
net2.trainParam.goal=1.7e-5; %0.7e-5;
net2.trainParam.mu=0.001; net2.trainParam.mu_max=1e+10;
net2=train(net2,  Img_FFT2(:,1:samples),Img_Indx(1,2:samples + 1)); 	grid on;
Y =  sim(net2, Img_FFT2) 
Y=round(Y)

