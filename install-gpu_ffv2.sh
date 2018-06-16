# This script is designed to work with ubuntu 16.04 LTS, with NVidia Tesla K80 system (e.g. Google Cloud Platform)
# It prepare a GPU-enabled conda environment ('deeplearning') with both Keras 1.2.2, Theano 0.9, Tensorflow (GPU) 1.2

# Forked from: https://github.com/fastai/courses/blob/master/setup/install-gpu.sh
# Download the RAW one here: "wget https://raw.githubusercontent.com/ChongFF/dl-script-code/master/install-gpu_ffv2.sh"
# Run the script by typing: "bash <script_name.sh>"

# Wish-list:
# 2) Run jupytr notebook in Tensorflow Docker Image
#    https://stackoverflow.com/questions/33636925/how-do-i-start-tensorflow-docker-jupyter-notebook
# 3) Or try deploying a tensorflow-gpu container (listed on Google Container Registry) to Compute instance
#    http://b.gcr.io/tensorflow/tensorflow

# *****************
# * Tech Details: *
# *****************
# - CUDA requires matching version of NVidia driver
# - cuCNN 5.1 only supports up to tensorflow-gpu 1.2
# - tensorflow-gpu requires libcupti-dev (NVIDIA CUDA Profiler Tools Interface development files) or it would fail

# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
# dtrx preferred over bzip2 because dtrx handles a wide range of archive format 7zip, zip, ...
sudo apt-get --assume-yes install dtrx tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common

# download and install GPU drivers
mkdir downloads
cd downloads

# Found it here: http://www.nvidia.com/Download/index.aspx?lang=en-us
wget "http://us.download.nvidia.com/tesla/384.66/nvidia-diag-driver-local-repo-ubuntu1604-384.66_1.0-1_amd64.deb"
sudo dpkg -i nvidia-diag-driver-local-repo-ubuntu1604-384.66_1.0-1_amd64.deb
sudo apt-get update
# Use 'apt-cache policy <package name>' to shows installed package version and also all the available versions in the repository
sudo apt-get --assume-yes --allow-unauthenticated install cuda-drivers=384.66-1

# Found it here: https://developer.nvidia.com/cuda-toolkit-archive
# CUDA 8.0 (not CUDA 9.0) is chosen becaues it is recommended for tensorflow-gpu
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb" -O "cuda-repo-ubuntu1604_8.0.44-1_amd64.deb"
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda=8.0.44-1
sudo modprobe nvidia
nvidia-smi

# install MiniConda and some common packages for current user
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b # DO NOT sudo bash this or could not update the packages

echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/miniconda3/bin:$PATH"
conda create -y -n deeplearning python=3.5
source activate deeplearning

conda install -y pandas numpy scikit-learn jupyter pillow
conda install -y bcolz
conda upgrade -y --all

# install and configure theano (pip install will install too new a version)
conda install -y theano
echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

# install and configure keras
pip install keras==1.2.2 # use a fixed version of Keras so that package update won't necessitate code change

mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# install cudnn 5.1 libraries
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/

# Advanced Profiling Tool Getting Ready for tensorflow-gpu (1.2) deployment
sudo apt-get --assume-yes install libcupti-dev

# Install Tensorflow GPU 1.2 (latest that would work with cuDNN 5.1)
pip install tensorflow-gpu==1.2

# create a SSL certificate for SSL connection
cd ~/
mkdir ssl
cd ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "cert.key" -out "cert.pem" -batch

# configure jupyter and prompt for password
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'$HOME/ssl/cert.pem' # path to the certificate we generated" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = u'$HOME/ssl/cert.key' # path to the certificate key we generated" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.IPKernelApp.pylab = 'inline'  # in-line figure when using Matplotlib" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*' # serve the notebooks locally
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

# clone the fast.ai course repo and prompt to start notebook
cd ~
git clone https://github.com/fastai/courses.git
echo "\"jupyter notebook\" will start Jupyter on port 8888"
echo "If you get an error instead, try restarting your session so your $PATH is updated"

# Installing commonly used packages
pip install imagehash hyperopt
conda install -y py-xgboost matplotlib seaborn

export PATH=~/miniconda3/bin:$PATH
pip install kaggle
mkdir kaggle_key
mkdir data
mkdir src
