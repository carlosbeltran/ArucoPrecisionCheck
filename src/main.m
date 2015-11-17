
img = imread('../images/test_img.png');
imshow(img);
hold on;

result = '10=(1852.86,1291.25) (2034.85,1277.98) (2064.17,1425.92) (1872.77,1441.03) Txyz= 0.0109797 -0.014364 0.324452 Rxyz=1.95024 1.75563 -0.52896';

[id,p1,p2,p3,p4,Txyz,Rxyz] = parseArucoRT(result);
%% 
%%p1 = [1852.86,1291.25];
%%p2 = [2034.85,1277.98]; 
%%p3 = [2064.17,1425.92]; 
%%p4 = [1872.77,1441.03];

x  = [p1(1);
      p2(1);
      p3(1);
      p4(1);]
y  = [p1(2);
      p2(2);
      p3(2);
      p4(2);]

[markercx,markercy,a] = centroid(x,y);

%Txyz = [0.0109797 -0.014364 0.324452];
%Rxyz = [1.95024 1.75563 -0.52896];

scatter(p1(1),p1(2));
scatter(p2(1),p2(2));
scatter(p3(1),p3(2));
scatter(p4(1),p4(2));
scatter(markercx,markercy);

x  = [p1(1);
      p2(1);
      p3(1);
      p4(1);]
plot(x,y);


theta = norm(Rxyz);
R = R3d(rad2deg(theta),Rxyz);
T = [[R,Txyz'];[0 0 0 1]];

%% This should be the result of R
%
%    0.1114    0.9936    0.0213
%    0.8164   -0.0793   -0.5720
%   -0.5666    0.0811   -0.8200
%
disto = [ -6.1688379586668375e-002, 1.6082224431333297e-001,...
       2.5879292291040206e-003, -1.1214913617323160e-004,...
       -1.2474406177802803e-001 ];
cam = CentralCamera('focal',3.55,'pixel',1.63e-3, 'distorsion', disto,...
'resolution', [3840 2748], 'centre',[1882 1453],'name','cam');
pt = cam.project(Txyz');
scatter(pt(1),pt(2));

Ty =  [ 0 0.015 0]';
pt = cam.project(h2e(T*e2h(Ty)));
scatter(pt(1),pt(2));

Tx =  [ 0.015 0 0]';
pt = cam.project(h2e(T*e2h(Tx)));
scatter(pt(1),pt(2));

figure;
cam.plot_camera('scale',0.02);
hold;
trplot(T,'length',0.01);


