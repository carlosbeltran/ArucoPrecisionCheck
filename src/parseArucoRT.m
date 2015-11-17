
function [id,p1,p2,p3,p4,Txyz,Rxyz] = parseArucoRT(arucostr)
% PARSEARUCORT parses the aruco string returned for a marker detection
% [id,p1,p2,p3,p4,Txyz,Rxyz] = PARSEARUCORT

    %%result = '10=(1852.86,1291.25) (2034.85,1277.98) (2064.17,1425.92) (1872.77,1441.03) Txyz= 0.0109797 -0.014364 0.324452 Rxyz=1.95024 1.75563 -0.52896';
    parts = textscan(arucostr,'%d=(%f,%f) (%f,%f) (%f,%f) (%f,%f) Txyz= %f %f %f Rxyz=%f %f %f');
    
    id = parts{1};
    p1 = [parts{2}, parts{3}];
    p2 = [parts{4}, parts{5}];
    p3 = [parts{6}, parts{7}];
    p4 = [parts{8}, parts{9}];
    
    %x  = [p1(1);
    %      p2(1);
    %      p3(1);
    %      p4(1)];
    %y  = [p1(2);
    %      p2(2);
    %      p3(2);
    %      p4(2)];
    
    Txyz = [parts{10} parts{11} parts{12}];
    Rxyz = [parts{13} parts{14} parts{15}];
