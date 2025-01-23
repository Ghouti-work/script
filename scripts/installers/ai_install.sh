mkdir ~/build && cd ~/build

git clone https://aur.archlinux.org/python-conda-package-handling.git && cd python-conda-package-handling
makepkg -is

sudo pacman -S python-pluggy python-pycosat python-ruamel-yaml python-glob2

git clone https://aur.archlinux.org/python-conda.git && cd python-conda

mkpkg -is

git clone https://github.com/oobabooga/text-generation-webui.git && cd text-generation-webui

conda create -n textgen python=3.11

conda activate textgen

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

pip install -r requirements_cpu_only.txt

python server.py


