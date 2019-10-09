clc; clear all;
img=imread('Mz.png');

imshow(img);
rec1=imrect;
M=getPosition(rec1);
M=round(M);
patch= imread('patch.jpg');
% patch= imread('p1.jpg');

imshow(patch);
rec2=imrect;
K=getPosition(rec2);
K=round(K);
intValeMatrix=[M(1),M(2);(M(1)+M(3)),M(2);M(1),(M(2)+M(4));(M(1)+M(3)),(M(2)+M(4))]
finalValueMatrix=[K(1),K(2);(K(1)+K(3)),K(2);K(1),(K(2)+K(4));(K(1)+K(3)),(K(2)+K(4))]

h1=0; h2=0; h3=0; h4=0; h5=0; h6=0; h7=0; h8=0; 

H= [1+h1, h2, h3; h4, 1+h5, h6; h7, h8, 1];

for i=1:4
x_dash(i)= (((1+h1)*intValeMatrix(i,1))+(h2*intValeMatrix(i,2))+h3)/(h7*intValeMatrix(i,1)+h8*intValeMatrix(i,2)+1);
y_dash(i)= ((h4*intValeMatrix(i,1))+((1+h5)*intValeMatrix(i,2))+h6)/(h7*intValeMatrix(i,1)+h8*intValeMatrix(i,2)+1);

end

updatedPoints=[x_dash',y_dash'];

D=(h7*intValeMatrix(i,1)+h8*intValeMatrix(i,2)+1);
r=updatedPoints-finalValueMatrix;

for ii=1:2
sum=0;
sum1=0;
for i=1:4
    J=[intValeMatrix(i,1),intValeMatrix(i,2),1,0,0,0,(-(x_dash(i)*intValeMatrix(i,1))),(-(x_dash(i)*intValeMatrix(i,2))); 0,0,0,intValeMatrix(i,1),intValeMatrix(i,2),1,(-(y_dash(i)*intValeMatrix(i,1))),(-(y_dash(i)*intValeMatrix(i,2))) ]/D;
   sum=sum+(J'*J) ;
   A=sum;
   del_x=r(i,:);
    sum1=sum1+(J'*del_x');
    b=sum1;
    
end

    [Q,R]= qr(A);
    p=inv(R)*Q'*b;
H=[p(1),p(2),p(3);p(4),p(5),p(6);p(7),p(8),1];

for i=1:4
    x_dash(i)= (((p(1))*intValeMatrix(i,1))+(p(2)*intValeMatrix(i,2))+p(3))/(p(7)*intValeMatrix(i,1)+p(8)*intValeMatrix(i,2)+1);
    y_dash(i)= ((p(4)*intValeMatrix(i,1))+((p(5))*intValeMatrix(i,2))+p(6))/(p(7)*intValeMatrix(i,1)+p(8)*intValeMatrix(i,2)+1);
end
updatedPoints=[x_dash',y_dash'];
r=updatedPoints-finalValueMatrix;

D=(p(7)*intValeMatrix(i,1)+p(8)*intValeMatrix(i,2)+1);
end
% H=H-eye(3);
output=img;
patch1=patch(K(1):(K(1)+K(3)),K(2):(K(2)+K(4)),:);
for j=M(1):(M(1)+M(3))
    for i=M(2):(M(2)+M(4))
        projection= H*[i;j;1];
        
        projectedLocation= round([projection(1)/projection(3),projection(2)/projection(3)]);
        img(i,j,1)=patch(projectedLocation(1),projectedLocation(2),1);
        img(i,j,2)=patch(projectedLocation(1),projectedLocation(2),2);
        img(i,j,3)=patch(projectedLocation(1),projectedLocation(2),3);

        
    end
end
  
imshow(img)