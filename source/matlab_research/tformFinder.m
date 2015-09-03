[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;
for i=1:23
    tform(i) = findTform(D(:,:,i), imresize(Fseg(:,:,i),[224 224],'nearest'), 'affine', optimizer, metric);
end
