#!/bin/bash

# Forticlient
FORTICLIENT_TAR="forticlient.tar.gz"
FORTICLIENT_DROPBOX="https://www.dropbox.com/scl/fi/qt4r3p12f2xdh07v47n6w/forticlient.tar.gz?rlkey=l5qgoux43jphag1dun9nw44ji&st=bhok86xu&dl=0"
EXISTE=$(ls /opt | grep -i forticlient)
if ! [ -z "$EXISTE" ]; then
  echo "Forticlient is already installed"
else
   EXIST_TAR=$(ls $SETUPDIR | grep -i $FORTICLIENT_TAR)
  if ! [ -z "$EXIST_TAR" ]; then
    sudo tar -xzf $SETUP_DIR/$FORTICLIENT_TAR -C /opt
  else
    wget -P /tmp $FORTICLIENT_DROPBOX
    sudo tar -xzf /tmp/$FORTICLIENT_TAR -C /opt
    rm -f /tmp/$FORTICLIENT_TAR 
  fi

  sudo ln -s /opt/forticlient/forticlient-cli /usr/local/bin/forticlient 
fi"

