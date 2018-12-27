clear all
im = imread('frame11.png');

im1=imresize(im,[100 100]);
[r, c]=size(im1);  
w_idx=1:r*c;
len_w=length(w_idx);

[I,J]=ind2sub([r,c],w_idx);
%storing intensity values in an array
for i=1:len_w
       V(i)=double(im1(w_idx(i)))/255;
end

% w is the weight matrix (similarity matrix or adjacency matrix)
w=zeros(len_w);

% r, sigma_I, sigma_x values and distance threshold
r=5;
sigma_i=.1;
sigma_x=15;

% computing the weight matrix
for i=1:len_w
    x1=I(1,i);
    y1=J(1,i);
    
    for j=1:len_w
         if (i==j)
                 w(i,j)=1;
         else
          
                 x2=I(1,j);
                 y2=J(1,j);
            %euclidean distance
            dist=((x1-x2)^2 + (y1-y2)^2);  
            if sqrt(dist)>=r
                dx=0;            
            else
                dx=exp(-((dist)/(sigma_x^2)));
            end
  
            pdiff=(V(i)-V(j))^2;
            di=exp(-((pdiff)/(sigma_i)^2));  
            w(i,j)=di*dx;
        end
    
    end
end

d=zeros(len_w);
s=sum(w,2);

% the diagonal matrix for computing the laplacian matrix
for i=1:len_w
     d(i,i)=s(i);
end
 % L is the laplacian matrix
L=zeros(len_w);
L=(d-w);
k=5;
[vect,vl]=eigs(L,d,5,'sm');

ve=vect(:,2:4);
id=kmeans(ve,k);
parts=cell(1,k);

%plotting different clusters
for i=1:k
    parts{1,i}= find(id(:,1)==i);
    pad=zeros(100,100);
    num=parts{1,i};
    pad(num)=im1(num);
    figure,imshow(uint8(pad));
end


