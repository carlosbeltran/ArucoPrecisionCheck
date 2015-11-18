
%%img = imread('../images/test_img.png');
img = imread('../images/ArucoPrecisionSnapShots/1.tiff');
tmph = load('../images/ArucoPrecisionSnapShots/boundaryimg1.mat');
pos = tmph.surface{1};
imshow(img);
hold on;

%%result = '10=(1852.86,1291.25) (2034.85,1277.98) (2064.17,1425.92) (1872.77,1441.03) Txyz= 0.0109797 -0.014364 0.324452 Rxyz=1.95024 1.75563 -0.52896';
result1 = '10=(1802.21,1134.79) (2009.6,1124.56) (2022.07,1292.79) (1803.91,1303.69) Txyz=0.00353763 -0.0318755 0.28685 Rxyz=1.96302 1.8863 -0.579586';

[id,p1,p2,p3,p4,Txyz,Rxyz] = parseArucoRT(result1);

x  = [p1(1);
      p2(1);
      p3(1);
      p4(1);]
y  = [p1(2);
      p2(2);
      p3(2);
      p4(2);]

[markercx,markercy,a] = centroid(x,y);

%%%plane = createPlane(p1,p2,p3); %% Dependency on geom3D

scatter(pos(:,1),pos(:,2),'+');
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
pt_o = cam.project(Txyz');
scatter(pt_o(1),pt_o(2));

Ty =  [ 0 0.015 0]';
Tyo = h2e(T*e2h(Ty));
pt_y = cam.project(Tyo);
scatter(pt_y(1),pt_y(2));

Tx =  [ 0.015 0 0]';
Txo = h2e(T*e2h(Tx));
pt_x = cam.project(Txo);
scatter(pt_x(1),pt_x(2));

figure;
cam.plot_camera('scale',0.02);
hold;
trplot(T,'length',0.015);

% Create Plane
 plane = createPlane(Txyz,Tyo',Txo');

 %
 %ray = cam.ray(p1');
 ray = cam.ray(pt_o);
 rp1 = ray.P0;
 rp2 = ray.d;
 line = [rp1(1) rp1(2) rp1(3) rp2(1)-rp1(1) rp2(2)-rp1(2) rp2(3)-rp1(3)]
 drawLine3d(line);

 ray = cam.ray(pt_y);
 rp1 = ray.P0;
 rp2 = ray.d;
 line = [rp1(1) rp1(2) rp1(3) rp2(1)-rp1(1) rp2(2)-rp1(2) rp2(3)-rp1(3)]
 drawLine3d(line,'r');

 ray = cam.ray(pt_x);
 rp1 = ray.P0;
 rp2 = ray.d;
 line = [rp1(1) rp1(2) rp1(3) rp2(1)-rp1(1) rp2(2)-rp1(2) rp2(3)-rp1(3)]
 drawLine3d(line,'g');

 % Get 3D points of the anotated boundary
 %
 rays = cam.ray(pos');
 pts3D = [];

 for iray = 1:size(rays,2)
    rp1 = rays(iray).P0;
    rp2 = rays(iray).d;
    line = [rp1(1) rp1(2) rp1(3) rp2(1)-rp1(1) rp2(2)-rp1(2) rp2(3)-rp1(3)]
    drawLine3d(line,'g');
    point = intersectLinePlane(line,plane);
    pts3D =[pts3D point']; 
    drawPoint3d(point(1),point(2),point(3));
 end

% Move to the reference frame of the first marker
pts3D = h2e(inv(T)*e2h(pts3D));
 
img2 = imread('../images/ArucoPrecisionSnapShots/2.tiff');
figure;
imshow(img2);
hold on;
result2 = '10=(1809.38,1041.76) (2045.52,1031.96) (2057.29,1261.25) (1817.12,1271.93) Txyz=0.00585792 -0.0356664 0.256087 Rxyz=2.19864 2.11374 -0.178318';

[id,p1,p2,p3,p4,Txyz,Rxyz] = parseArucoRT(result2);
theta = norm(Rxyz);
R2 = R3d(rad2deg(theta),Rxyz);
T2 = [[R2,Txyz'];[0 0 0 1]];

%% Move points to the new camera position reference frame
pts3D = h2e((T2)*e2h(pts3D));
% Project points
newpts = cam.project(pts3D);
newpts = newpts';
scatter(newpts(:,1),newpts(:,2),'+','r');
