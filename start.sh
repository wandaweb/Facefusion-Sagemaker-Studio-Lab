#!/bin/bash
eval "$(conda shell.bash hook)"

# Create the Conda environment
env_exists=1
if [ ! -d ~/.conda/envs/facefusion ]
then
  env_exists=0
  conda create -y -n facefusion python=3.10
fi 

conda activate facefusion

# Get Facefusion from GitHub
if [ ! -d "facefusion" ]
then
  git clone https://github.com/facefusion/facefusion --branch 2.0.0 --single-branch
fi

# Update the installation if the parameter "update" was passed by running
# start.sh update
if [ $# -eq 1 ] && [ $1 = "update" ]
then
  cd facefusion
  git pull
  cd ..
fi

# Install the required packages if the environment needs to be freshly installed or updated 
if [ $# -eq 1 ] && [ $1 = "update" ] || [ $env_exists = 0 ]
then
  cd facefusion
  python install.py --torch cuda --onnxruntime cuda
  cd ..
  pip install pyngrok
  conda install opencv -y
  conda install ffmpeg
fi

# Start facefusion with ngrok
if [ $# -eq 0 ]
then
  python start-ngrok.py 
elif [ $1 = "reset" ]
then
  python start-ngrok.py --reset 
fi
