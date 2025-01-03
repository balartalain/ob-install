#!/bin/bash

SETUP_DIR="$(dirname "$(realpath "$0")")"

install_package() {
  PACKAGE=$1
  if dpkg -l | grep -qw "$PACKAGE"; then
    echo "--$PACKAGE is already installed."
  else
    echo ""
    echo "################ Installing $PACKAGE...##################"
    sudo apt-get install -y "$PACKAGE" || { echo "Error installing $PACKAGE."; exit 1; }
  fi
}

PACKAGES=("zsh" "curl" "nodejs" "openjdk-11-jdk" "ant" "google-chrome-stable" "python3-tqdm" "postgresql-12")


# Add Google Chrome repo
if ! grep -q "^deb .*dl.google.com/linux/chrome/deb/" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
   wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg 
   sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' 
#  echo "Añadiendo repositorio de Google Chrome..."
#  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /usr/share/keyrings/google-chrome-archive-keyring.gpg > /dev/null
#  echo "deb [signed-by=/usr/share/keyrings/google-chrome-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
#  sudo apt-get update
fi

# Postgres

#Para Ubuntu 24.04
#sudo apt install -y postgresql-common
#sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
#sudo apt update
#sudo apt install -y postgresql-12

PACKAGE="postgresql"
if ! dpkg -l | grep -qw "$PACKAGE"; then
 echo "Adding postgresql repository." 
 #curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
 sudo sh -c 'curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null'
 #echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
 sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
fi

PACKAGE="curl"
if ! dpkg -l | grep -qw "$PACKAGE"; then
  sudo apt update
  sudo apt install curl
# curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
fi

if ! dpkg -l | grep -qw "nodejs"; then
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
fi
sudo apt update

# Install packages
sudo apt-get install -y git
for PACKAGE in "${PACKAGES[@]}"; do
  install_package "$PACKAGE"
done

# Add oh-my-zsh
OHMYZSH_DIR="$HOME/.oh-my-zsh"
if [ -d "$OHMYZSH_DIR" ]; then
  echo "oh-my-zsh is already installed"
else
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
  if [ $? -eq 0 ]; then 
    echo "Repositorio clonado correctamente en $CLONE_DIR." 
  else 
    echo "Error al clonar el repositorio. Intenta nuevamente." 
    exit 1
  fi
fi

TOMCAT_TAR="apache-tomcat-9.0.*.tar.gz"
ECLIPSE_TAR="eclipse-jee-*.tar.gz"
SMARTGIT_TAR="smartgit-linux-19_1_8.tar.gz"
TOMCAT_DROPBOX="https://www.dropbox.com/scl/fi/ptske6cmcoonvpkasmvie/apache-tomcat-9.0.97.tar.gz?rlkey=imic9ki8u30f86x2xbfh4bo6i&st=bh8e391q&dl=1 -O apache-tomcat-9.0.97.tar.gz"
ECLIPSE_DROPBOX="https://www.dropbox.com/scl/fi/s3w2yifmtpuqny3vjmev9/eclipse-jee-2024-12-R-linux-gtk-x86_64.tar.gz?rlkey=71updtr1qrpshfoqliv8nm3o5&st=574pcj1s&dl=1 -O eclipse-jee.tar.gz"
SMARTGIT_DROPBOX="https://www.dropbox.com/scl/fi/2uzlw5trq81g2dzeki4cr/smartgit-linux-19_1_8.tar.gz?rlkey=xthpju501ta2oy6ow1o644fo4&st=uku7pm4h&dl=1 -O smartgit-linux-19_1_8.tar.gz"

# Apache
EXISTE=$(ls /opt | grep -i apache)
if ! [ -z "$EXISTE" ]; then
 echo "apache is already installed"
else
  EXIST_TAR=$(ls $SETUPDIR | grep -i $TOMCAT_TAR)
  if ! [ -z "$EXIST_TAR" ]; then
    sudo tar -xzf $SETUP_DIR/$TOMCAT_TAR -C /opt
  else
    cd /tmp
    wget $TOMCAT_DROPBOX
    sudo tar -xzf $TOMCAT_TAR -C /opt
    rm -f /tmp/$TOMCAT_TAR
  fi
 sudo ln -s /opt/apache-tomcat-9.0.* /opt/apache-tomcat-9.0
 sudo sh -c 'echo "export CATALINA_OPTS=\"-server -Djava.awt.headless=true -Xms512M -Xmx1024M\"" >> /etc/environment'
 sudo sh -c 'echo "export CATALINA_HOME=/opt/apache-tomcat-9.0" >> /etc/environment'
 sudo sh -c 'echo "export CATALINA_BASE=/opt/apache-tomcat-9.0" >> /etc/environment'
fi

# Eclipse
EXISTE=$(ls /opt | grep -i eclipse)
if ! [ -z "$EXISTE" ]; then
 echo "eclipse is already installed"
else
   EXIST_TAR=$(ls $SETUPDIR | grep -i $ECLIPSE_TAR)
  if ! [ -z "$EXIST_TAR" ]; then
    sudo tar -xzf $SETUP_DIR/$ECLIPSE_TAR -C /opt
  else
    cd /tmp
    wget $ECLIPSE_DROPBOX
    sudo tar -xzf $ECLIPSE_TAR -C /opt
    rm -f /tmp/$ECLIPSE_TAR
  fi

  sudo ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse
  sudo sh -c 'echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment'
  sudo sh -c 'echo "export ANT_OPTS=\"-Xmx1024M\"" >> /etc/environment'
fi

# Smartgit
EXISTE=$(ls /opt | grep -i smartgit)
if ! [ -z "$EXISTE" ]; then
  echo "smartgit is already installed"
else
   EXIST_TAR=$(ls $SETUPDIR | grep -i $SMARGIT_TAR)
  if ! [ -z "$EXIST_TAR" ]; then
    sudo tar -xzf $SETUP_DIR/$SMARTGIT_TAR -C /opt
  else
    cd /tmp
    wget $SMARTGIT_DROPBOX
    sudo tar -xzf $SMARTGIT_TAR -C /opt
    rm -f /tmp/$SMARTGIT_TAR 
  fi

  sudo ln -s /opt/smartgit/bin/smartgit.sh /usr/local/bin/smartgit 
fi
sudo chown -R $USER:$USER /opt/apache-tomcat-9.0.*
sudo chown -R $USER:$USER /opt/eclipse
sudo chown -R $USER:$USER /opt/smartgit

# Postgres config
sudo -u postgres psql -c "alter user postgres with password 'postgres';"

# CONFIGURATION FILES
CONFIG_FILES=(
  "$SETUP_DIR/eclipse.desktop:$HOME/.local/share/applications/"
  "$SETUP_DIR/smartgit.desktop:$HOME/.local/share/applications/"
  "$SETUP_DIR/.zshrc:$HOME"
  "$SETUP_DIR/.zsh_history:$HOME"
)

# Copy configuration files
for FILE_PAIR in "${CONFIG_FILES[@]}"; do
  IFS=':' read -r SRC DEST <<< "$FILE_PAIR"
  if [ -f "$SRC" ]; then
    echo "Copying $SRC a $DEST..."
    cp "$SRC" "$DEST" || { echo "Error copying  $SRC a $DEST."; }
  else
    echo "The configuration file does not exist: $SRC"
    #exit 1
  fi
done
echo "DONE."
