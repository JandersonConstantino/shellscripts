# /bin/bash

echo "removing dotnet files of user..."
rm -rf $HOME/.dotnet
rm -rf $HOME/dotnet
rm -rf $HOME/Downloads/dotnet
mkdir $HOME/Downloads/.dotnet

download_file=$1

while read url;
do
  rm -rf $HOME/Downloads/dotnet.tar.gz

  filename=$(echo $url | cut -d'/' -f 8)
  echo "Downloading version $filename..."
  cd $HOME/Downloads
  curl -Lo dotnet.tar.gz $url

  echo "Extracting dotnet files of $filename ..."
  tar -C .dotnet --skip-old-files -xf dotnet.tar.gz
done < $download_file

rm -rf $HOME/Downloads/dotnet.tar.gz
mv $HOME/Downloads/.dotnet $HOME/.dotnet

$HOME/.dotnet/dotnet --list-sdks

echo "\n\nTrying recognize your default shell..."

case $SHELL in
*/zsh) 
   echo "Zsh recognized! Configuring paths..."
   config_file=".zshrc"
   ;;
*/bash)
   echo "Bash recognized! Configuring paths..."
   config_file=".bashrc"
   ;;
*)
  echo "shell not recognized! Config DOTNET_ROOT and PATH manually!"
  exit
esac

cd $HOME
config_file=$HOME/$config_file

if [ -e $config_file ]
then
  echo "$config_file founded. Verifing file"

  HAS_DOTNET_ROOT=$(cat $config_file | grep -c "DOTNET_ROOT=\"\$HOME/.dotnet\"")
  HAS_DOTNET_ROOT_IN_PATH=$(cat $config_file | grep -c "PATH=\$DOTNET_ROOT:\$PATH")

  if [ $HAS_DOTNET_ROOT -eq 0 ]; then
    echo "\nexport DOTNET_ROOT=\"\$HOME/.dotnet\"\n" >> $config_file
  else
    echo "DOTNET_ROOT exists on $config_file."
  fi

  if [ $HAS_DOTNET_ROOT_IN_PATH -eq 0 ]; then
    echo "export PATH=\$DOTNET_ROOT:\$PATH\n" >> $config_file
  else
    echo "DOTNET_ROOT exists in PATH"
  fi

  echo "Reopen the terminal and try: \n\n dotnet --info"
else
  echo "$config_file NOT founded. Creating file..."
  echo "export DOTNET_ROOT=\"\$HOME/.dotnet\"\nexport PATH=\$DOTNET_ROOT:\$PATH\n" >> $config_file
fi
