function update_apt {
  # ---
  # Update APT
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  echo "Updating apt package lists";
  apt-get update -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to apt package lists";
    exit 1;
  fi
  apt-get upgrade -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to upgrade apt";
    exit 1;
  fi

  return 0;
}

function install_cli_tools {
  # ---
  # Install CLI Tools
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  echo "Installing CLI Tools";

  echo "Installing ack";
  apt-get install ack-grep -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install ack";
    exit 1;
  fi

  echo "Installing Silver Searcher";
  apt-get install silversearcher-ag -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install Silver Searcher";
    exit 1;
  fi

  echo "Installing zsh";
  sudo apt-get install zsh -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install zsh";
    exit 1;
  fi

  # echo "Installing zplug";
  # curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh;
  # if [ $? != 0 ]; then
  #   echo -e "Failed to install zplug";
  #   exit 1;
  # fi

  echo "Installing neovim";
  add-apt-repository ppa:neovim-ppa/unstable -y > /dev/null;
  apt-get update > /dev/null;
  apt-get install neovim -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install neovim";
    exit 1;
  fi


  echo "Installing tmux";
  apt-get install tmux -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install tmux";
    exit 1;
  fi

  return 0;
}

function install_java {
  # ---
  # Install Jenkins dependencies
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  echo "Adding Open JDK apt repository";
  add-apt-repository ppa:openjdk-r/ppa -y > /dev/null 2> /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to add Open JDK apt repository";
    exit 1;
  fi

  echo "Updating apt packages";
  apt-get update -y > /dev/null;
  if [ $? != 0 ]; then
      echo -e "Failed to update apt packages";
      exit 1;
  fi

  echo "Installing Open JDK";
  apt-get install -y openjdk-8-jdk openjdk-8-jre > /dev/null 2> /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install Open JDK";
    exit 1;
  fi

  return 0;
}

function install_mongo {
  echo "Installing MongoDB";
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
  if [ $? != 0 ]; then
    echo -e "Failed to install MongoDB";
    exit 1;
  fi

  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list;
  sudo apt-get update -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to update apt for MongoDB";
    exit 1;
  fi
  apt-get install mongodb-org -y > /dev/null
  if [ $? != 0 ]; then
    echo -e "Failed to install MongoDB";
    exit 1;
  fi

  return 0;
}

function install_elasticsearch {
  local _cwd=$(pwd);

  cd /tmp
  echo "Installing Elasticsearch";
  curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.10.deb
  if [ $? != 0 ]; then
    echo -e "Failed to download Elasticsearch";
    exit 1;
  fi

  dpkg -i elasticsearch-5.6.10.deb
  if [ $? != 0 ]; then
    echo -e "Failed to install Elasticsearch";
    exit 1;
  fi

  cd $_cwd;
  return 0;
}

function install_redis {
  apt-get install redis-server -y > /dev/null
  if [ $? != 0 ]; then
    echo -e "Failed to install Redis";
    exit 1;
  fi

  return 0;
}

function install_imagemagick {
  local _cwd=$(pwd);

  echo "Installing Imagemagick"
  apt-get install build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng12-dev libjpeg-dev libfreetype6-dev libxml2-dev -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install Imagemagick dependencies";
    exit 1;
  fi

  apt-get build-dep imagemagick -y > /dev/null

  cd /tmp;
  wget http://www.imagemagick.org/download/ImageMagick-6.9.10-8.tar.gz > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to download Imagemagick";
    exit 1;
  fi
  tar -xzvf ImageMagick-6.9.10-8.tar.gz > /dev/null;
  cd ImageMagick-6.9.10-8;
  ./configure > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to configure Imagemagick install";
    exit 1;
  fi
  checkinstall > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install Imagemagick";
    exit 1;
  fi
  cd $_cwd;

  return 0;
}

function install_graphicsmagick {
  local _cwd=$(pwd);

  echo "Installing GraphcisMagick";

  apt-get install graphicsmagick -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install GraphicsMagick";
    exit 1;
  fi
  cd $_cwd;

  return 0;
}

function install_opencv {
  local _cwd=$(pwd);

  echo "Installing opencv"
  apt-get install libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install opencv dependencies";
    exit 1;
  fi

  cd /tmp;
  wget https://github.com/opencv/opencv/archive/3.1.0.zip -O opencv-3.1.0.zip;
  unzip opencv-3.1.0.zip;
  cd opencv-3.1.0;
  mkdir build;
  cd build;
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to configure opencv install";
    exit 1;
  fi
  make -j $(nproc) > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install opencv";
    exit 1;
  fi
  make install > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install opencv";
    exit 1;
  fi
  /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
  ldconfig > /dev/null;
  cd $_cwd;

  return 0;
}

function install_cairo {
  echo "Installing cairo"
  apt-get install libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ -y > /dev/null; 
  if [ $? != 0 ]; then
    echo -e "Failed to install cairo";
    exit 1;
  fi

  return 0;
}

function install_nginx {
  echo "Installing nginx";
  apt-get install nginx -y > /dev/null
  if [ $? != 0 ]; then
    echo -e "Failed to install nginx";
    exit 1;
  fi
  return 0;
}

function install_boost {
  echo "Installing boost";
  apt-get install libboost-all-dev -y > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to install boost";
    exit 1;
  fi
}

function install_lang_runtime {
  local _USER=$1;
  # ---
  # Install Languages and runtimes
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  install_java;

  echo "Installing nvm";
  sudo su $_USER -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash";
  return 0;
}

function install_dev_tools {
  install_mongo;

  install_nginx;

  install_elasticsearch;

  install_imagemagick;

  install_graphicsmagick;

  install_boost;

  install_opencv;

  install_cairo;

  return 0;
}

function main {
  local _USER=$1;

  update_apt;
  install_lang_runtime $_USER;
  install_dev_tools;
  install_cli_tools;
}

main $1;

