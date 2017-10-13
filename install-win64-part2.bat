conda install -y numpy matplotlib scipy scikit-learn pillow pandas jupyter
pip install --ignore-installed --upgrade tensorflow
conda install -y mingw libpython
conda install theano=0.8
REM theano 0.9 does not work in Windows Python 3.5 or 3.6, whether installed by pip or conda
REM theano 0.8 works, but require Windows Python 3.5, not compatible with Python 3.6
conda install -y pyyaml HDF5 h5py
pip install keras
