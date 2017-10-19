%Uses prepared (trained) NN and demonstrates recognition ability 
%
%samples=input('Number of images: ');
samples=10;
indirname=input('Input dirname(Iris0, Iris30, Iris60...): ','s');
wcd=cd;  Inwcd=[wcd, '\',indirname,'\'];
filenmb=0;  clf, hold off
SpHarms2=10;
SpHarms=200;  %240; %Number of space frequencies for training
HarmIndices=(-SpHarms/2:SpHarms/2-1);
MinIn=-1; MaxIn=1044;
%maxro=input('Size of image: ');
 delro=1; maxro=200;
 maxro=maxro/2-1;
 if rem(maxro, 2)==1
     maxro=maxro-1;
 end
 delphi=2*pi/((maxro-20)/delro);
 Img_FFT2 = [];
 for ii=1:samples
   Imag=imread([Inwcd,num2str(filenmb)],'bmp'); %imshow(I),figure(gcf)
%    Imag=rgb2gray(Imag); imshow(Imag); pause;
%    clear Gray;
%     Gray(:,:) = round((Imag(:,:,1) +Imag(:,:,2)/5+Imag(:,:,3)/5)/1.4);
    Rgb_to_Gray
  % imshow(Gray), pause;
   img_inf=imfinfo([Inwcd,num2str(filenmb)],'bmp'); 
   addX=round(img_inf.Width/2);  addY=round(img_inf.Height/2);
%   [PwFourTrn(:,ii), rows]=fft4ringse2(Imag, delphi, delro, maxro, addX, addY);
   [PwFourTrn(:,ii), rows]=fft4rings(Gray, delphi, delro, maxro, addX, addY);

   Img_FFT(1:SpHarms/2,ii) = PwFourTrn((rows-SpHarms/2):(rows-1),ii);
   Img_FFT((SpHarms/2+1):SpHarms,ii) = PwFourTrn(2:(SpHarms/2+1),ii);
   IMG_FFT_Temp = [PwFourTrn(2:(SpHarms/2+1),ii); PwFourTrn((rows-SpHarms/2):(rows-1),ii)];
   Img_FFT2 = [Img_FFT2 IMG_FFT_Temp(SpHarms2:(SpHarms - SpHarms2))];
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

% Testing NN
tic;
Y =  sim(net2, Img_FFT2); strY=''; str_roundY=''; toc
for ii=1:samples,  
 strY=strcat(strY,sprintf('%6.3f', Y(ii)));
 str_roundY=strcat(str_roundY,sprintf('%6d', round(Y(ii))) );  
end
disp(strY);  disp(str_roundY);
