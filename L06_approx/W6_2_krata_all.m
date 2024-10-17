close all
clear all

[i1, cmap] = imread('Krata1.jpg'); imshow(i1,  cmap); pause
i1g = double(rgb2gray(i1));        imshow(i1g, cmap); pause
[sx, sy]=size(i1g);
cx=sx/2;
cy=sy/2;

% wyszukanie przeciêæ lini
wzorzec=[
0 0 0 1 1 1 0 0 0
0 0 0 1 1 1 0 0 0
0 0 0 1 1 1 0 0 0
1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 1
0 0 0 1 1 1 0 0 0
0 0 0 1 1 1 0 0 0
0 0 0 1 1 1 0 0 0
];

ic = normxcorr2(wzorzec,i1g);   imshow(ic, cmap), pause  % korelacja z "krzy¿ykiem"
ig = ic<-0.7;                   imshow(ig, cmap), pause  % 
ig = bwmorph(ig,'shrink',Inf);  imshow(ig, cmap), pause  % shrink objects to points
[ix,iy] = find(ig>0);              % wspó³rzêdne przeciêæ linii
r = sqrt((ix-cx).^2+(iy-cy).^2);   % promieñ do œrodka obrazu
[rs,i] = sort(r);                  % posortowane promienie

% ustalenie punktów odniesienia (siatki regularnej)

x0=ix(i(1)); y0=iy(i(1)); 
dx=abs(ix(i(1))-ix(i(4)))-1;
dy=abs(iy(i(1))-iy(i(4)))-3;
jx=x0+dx*[-4:1:5];
jy=y0+dy*[-6:1:7];
[jX, jY]=meshgrid(jx,jy);
jx=jX'; jx=jx(:);               % wspó³rzêdne przeciêæ linii dla obrazu wzorcowego
jy=jY'; jy=jy(:);
rm=sqrt((jx-cx).^2+(jy-cy).^2); % promieñ do œrodka obrazu
[rms,j]=sort(rm);

imshow(ig, cmap), hold on
plot(cy,cx,'r+')                % punkt centralny
plot(jY,jX,'bo')                % punkty odniesienia
pause

% identyfikacja modelu algorytmem LS

U = [rms, rms.^2, rms.^3];
Y = [rs];
A = U \ Y;
R = U * A;
figure, plot(rms,rs,'b.', rms,R,'g-', [0 3e2],[0 3e2],'r-'); pause

% prostowanie obrazka

xx=1:sx;
yy=1:sy;
[XX,YY] = meshgrid( xx, yy );
RR = sqrt( (XX-cx).^2 + (YY-cy).^2 );
RRr = RR*A(1) + RR.^2*A(2) + RR.^3*A(3);
RRu = RRr ./ RR;
i1r=interp2( i1g, (YY-cy).*RRu+cy, (XX-cx).*RRu+cx );
figure,
    subplot(2,1,1),imagesc(i1g); title('We');
    subplot(2,1,2),imagesc(i1r); title('Wy');
    colormap gray
    pause