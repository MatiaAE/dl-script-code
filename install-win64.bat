conda create -n tensorflow python=3.5 
ECHO theano 0.9 does not work well under windows, but 0.8* does not support python 3.6
ECHO 'conda-env remove -n tensorflow' to remove an environment
conda install conda-build
activate tensorflow
conda install -y numpy matplotlib scipy scikit-learn pillow pandas jupyter
pip install --ignore-installed --upgrade tensorflow
conda install -y mingw libpython
conda install -y theano
conda install -y pyyaml HDF5 h5py 
pip install keras
