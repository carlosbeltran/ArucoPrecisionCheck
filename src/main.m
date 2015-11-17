
img = imread('../images/test_img.png');
imshow(img);
hold on;

result = '10=(1852.86,1291.25) (2034.85,1277.98) (2064.17,1425.92) (1872.77,1441.03) Txyz= 0.0109797 -0.014364 0.324452 Rxyz=1.95024 1.75563 -0.52896';

[id,p1,p2,p3,p4,Txyz,Rxyz] = parseArucoRT(result);

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
pt_y = cam.project(h2e(T*e2h(Ty)));
scatter(pt_y(1),pt_y(2));

Tx =  [ 0.015 0 0]';
pt_x = cam.project(h2e(T*e2h(Tx)));
scatter(pt_x(1),pt_x(2));

figure;
cam.plot_camera('scale',0.02);
hold;
trplot(T,'length',0.015);

% Create Plane
 Tyo = h2e(T*e2h(Ty));
 Txo = h2e(T*e2h(Tx));

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
