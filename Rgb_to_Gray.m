  clear Gray;
  r=0.985; g=0.376; b=0.276;
  Gray(:,:) = round((Imag(:,:,1)*r +Imag(:,:,2)*g+Imag(:,:,3)*b)/(r+g+b));