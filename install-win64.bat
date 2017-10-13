ECHO https://ss64.com/nt/start.html - learn to use START / CALL to run sequentially without human interaction
conda create -n tensorflow python=3.5 
ECHO theano 0.9 does not work well under windows, but 0.8* does not support python 3.6
ECHO 'conda-env remove -n tensorflow' to remove an environment
conda install conda-build
activate tensorflow

conda install -y numpy matplotlib scipy scikit-learn pillow pandas jupyter
pip install --ignore-installed --upgrade tensorflow
conda install -y mingw libpython
conda install theano=0.8
REM theano 0.9 does not work in Windows Python 3.5 or 3.6, whether installed by pip or conda
REM theano 0.8 works, but require Windows Python 3.5, not compatible with Python 3.6
conda install -y pyyaml HDF5 h5py
pip install keras
REM pip error reference: http://jakzaprogramowac.pl/pytanie/92058,pip-throws-typeerror-parse-got-an-unexpected-keyword-argument-39-transport-encoding-39-when-trying-to-install-new-packages
REM Download https://github.com/html5lib/html5lib-python/tree/master/html5lib and overwrite all the files within html5lib folder 
REM in your tensorflow environment "envs\tensorflow\Lib\site-packages\html5lib" Then you should be able to run any "pip install" commands after that
