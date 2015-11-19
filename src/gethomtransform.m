function T = gethomtransform(Txyz,Rxyz)
    theta = norm(Rxyz);
    R = R3d(rad2deg(theta),Rxyz);
    T = [[R,Txyz'];[0 0 0 1]];
end
