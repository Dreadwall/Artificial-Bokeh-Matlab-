function [depthMap] = mydepthMap(Image_Path)
addpath(genpath('toolbox'));
addpath(genpath('features'));
rootPath = '../Downloads';

opts=ssiDepthTrain();           
opts.modelFnm='modelMake3d';    
opts.dataSet='make3d';
opts.trainImDir=[rootPath '/Train400Im/'];
opts.gtMatDir=[rootPath '/Train400Depth/'];
opts.useParfor=0;                 

tic, model=ssiDepthTrain(opts); toc; 


model.opts.nTreesEval=4;         
model.opts.nThreads=4;            


if(0), 
if(strcmpi(model.opts.dataSet,'make3d')), ssiDepthTest([rootPath '/Test134Im/'], model); 
    [rel,lg10,rmse]=ssiDepthEval([rootPath '/Test134Im/'],[rootPath '/Test134Depth/'],model);
end
if(strcmpi(model.opts.dataSet,'nyu')), ssiDepthTest([rootPath '/NyuIm/'], model); 
    [rel,lg10,rmse]=ssiDepthEval([rootPath '/NyuIm/'],[rootPath '/NyuDepth/'],model);
end
save([opts.modelFnm '_eval.mat'],'rel','lg10','rmse');
end

if(1)
I=imread(Image_Path);
tic, depth=ssiDepthDetect(I, model); toc;
depthMap = depth;

end
end