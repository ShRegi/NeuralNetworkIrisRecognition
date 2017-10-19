%returns spectral density for a vector produced by sequence of rings
function [rez2, rows]=fft4rings(img2proc, delphi, delro, maxro, addX, addY)
count=1; ang = 1; ro =1; %rez1=zeros();

% for r=3:delro:maxro   %for r=3:5:149
%     kol=count;
%     for phi=0:delphi:2*pi    %for phi=0:pi/144:2*pi
%       count=count+1;
%      rez1(count,1)=img2proc(addY+round(r*sin(phi)),addX+round(r*cos(phi)));
%   
%     end
% 
%     %rez2(kol+1:count,1)=fft(double(rez2(kol+1:count,1)));
% end
for r=20:delro:maxro,    %for r=3:5:149
    kol=count;   
    for phi=0:delphi:2*pi,      %for phi=0:pi/144:2*pi      
%     Xs(ro,ang) = addX+round(r*cos(phi));
%     Ys(ro,ang) = addY+round(r*sin(phi)); 
    Xs(count) = addX+round(r*cos(phi));
    Ys(count) = addY+round(r*sin(phi));
        if (count==1) 
            prXs=Xs(count);   prYs=Ys(count); count=count+1;
        elseif ((Xs(count)~=prXs) | (Ys(count)~=prYs))
        
        prXs = Xs(count); prYs = Ys(count); count=count+1;
        end;
    ang = ang+1;
    end
    ro = ro+1;
    %rez2(kol+1:count,1)=fft(double(rez2(kol+1:count,1)));
end
clear newImg; 
 for ii=1:1:(count-1) rez1(ii,1) = img2proc(Ys(ii),Xs(ii)); end

  FourTrn=fft(double(rez1)); Harms=size(FourTrn);    rows=Harms(1);
  rez2=FourTrn.*conj(FourTrn)/Harms(1);
%rez2=abs(rez2); %rez2=sqrt(rez2); % 
%plot(rez2(50:250,1)); figure(gcf) ,hold on



