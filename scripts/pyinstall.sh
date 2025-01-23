
echo "all tools for start "
sudo pacman -S python 
sudo pacman -S python-numpy
sudo pacman -S python-pandas 
sudo pacman -S python-networkx
sudo pacman -S python-graphviz
sudo pacman -S python-pywebview
sudo pacman -S python-pipenv
sudo pacman -S python-flask
sudo pacman -S python-django 
sudo panman -S python-pypdf

echo "ui tools desktop and pyqt"
sudo pacman -S tk
sudo pacman -S qt5 

echo " pyenv "
sudo pacman -S pyenv 

echo "pyviz"
yay -S python-pyviz

echo "ai tools"
yay -S anaconda 
sudo pacman -S python-pluggy python-pycosat python-ruamel-yaml python-glob2

sudo pacman -S python-scikit-learn
sudo pacman -S python-keras
sudo pacman -S python-pytorch 
