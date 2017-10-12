conda create -n tensorflow python=3.5 
ECHO theano 0.9 does not work well under windows, but 0.8* does not support python 3.6
ECHO 'conda-env remove -n tensorflow' to remove an environment
conda install conda-build
activate tensorflow
