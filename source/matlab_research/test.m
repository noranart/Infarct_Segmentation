i=8;

[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

ff=imresize(F(:,:,i),[224 224],'nearest');
register = imregister(D(:,:,i), ff, 'affine', optimizer, metric);
imshowpair(register,ff);