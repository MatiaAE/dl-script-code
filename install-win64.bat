conda create -n tensorflow
conda install conda-build
activate tensorflow
conda install -y numpy matplotlib scipy scikit-learn pillow pandas jupyter
pip install --ignore-installed --upgrade tensorflow
conda install -y mingw libpython
conda install -y theano
conda install -y pyyaml HDF5 h5py 
pip install keras
