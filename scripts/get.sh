echo "get is tools to shortcut"

case "$1" in
"python")
  ls ~/Notes/code/python/ || exit
  ;;
"c")
  cd ~/Notes/code/c_code/ || exit
  ;;
"an")
  cd ~/Notes/code/python/AN/ || exit
  ;;
"ai")
  cd ~/Notes/code/python/TP_IA/ || exit
  ;;
"i3")
  k3 || exit
  ;;
*)
  echo "the parametre are :"
  echo " python : content"
  echo " c : content"
  echo " analyse numirique : content"
  echo " ia : content"
  echo " i3 : keys binding"
  ;;
esac
