function fun_3DComp(hA, BW, param3D)

xg = param3D.xg;
yg = param3D.yg;
zg = param3D.zg;

CLR = 'bgr';
for n = 1:length(BW)
    [f, v] = isosurface(xg, yg, zg, BW{n}, 0.99);
    patch(hA, 'Faces', f, 'Vertices', v, 'Facecolor', CLR(n), 'Edgecolor', 'none', 'FaceAlpha', 0.2);
end