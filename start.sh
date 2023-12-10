#!/bin/bash
eval "$(conda shell.bash hook)"
# Create the Conda environment
if [ ! -d ~/.conda/envs/facefusion ]
then
  conda create -y -n facefusion python=3.10
  conda activate facefusion
  pip install pyngrok
fi

conda activate facefusion

# Install facefusion if it's not already installed
if [ ! -d "facefusion" ]
then
  git clone https://github.com/facefusion/facefusion --branch 2.0.0 --single-branch
  cd facefusion
  python install.py --torch cuda --onnxruntime cuda
  cd ..
fi

# Update the installation if the parameter "update" was passed by running
# start.sh update
if [ $# -eq 1 ] && [ $1 = "update" ]
then
  cd facefusion
  git pull
  python install.py --torch cuda --onnxruntime cuda
  pip install pyngrok
  cd ..
fi

conda install opencv -y

# Start facefusion with ngrok
if [ $# -eq 0 ]
then
  python start-ngrok.py 
elif [ $1 = "reset" ]
then
  python start-ngrok.py --reset 
fi
