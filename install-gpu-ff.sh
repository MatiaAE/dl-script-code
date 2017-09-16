# This script is designed to work with ubuntu 16.04 LTS

# ensure system is updated and has basic build tools
sudo apt-get install bzip2
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common

# download and install GPU drivers
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb" -O "cuda-repo-ubuntu1604_8.0.44-1_amd64.deb"

sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo modprobe nvidia
nvidia-smi

# install Anaconda for current user
mkdir downloads
cd downloads
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/miniconda3/bin:$PATH"
conda install -y bcolz
conda install -y pandas numpy scikit-learn jupyter
conda upgrade -y --all

# install and configure theano
pip install theano
echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

# install and configure keras
# pip install keras==1.2.2
pip install keras
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# install cudnn libraries
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/

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
