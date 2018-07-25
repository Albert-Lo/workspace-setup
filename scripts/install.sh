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
  add-apt-repository ppa:neovim-ppa/unstable;
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
  sudo su $_USER;
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  if [ $? != 0 ]; then
    echo -e "Failed to install nvm";
    exit 1;
  fi
  sudo su root;

  return 0;
}

function install_dev_tool {

  echo "Installing MongoDB";
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
  if [ $? != 0 ]; then
    echo -e "Failed to install MongoDB";
    exit 1;
  fi
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
  sudo apt-get update
  if [ $? != 0 ]; then
    echo -e "Failed to install MongoDB";
    exit 1;
  fi
  apt-get install mongodb-org -y > /dev/null
  if [ $? != 0 ]; then
    echo -e "Failed to install MongoDB";
    exit 1;
  fi

  echo "Installing nginx";
  apt-get install nginx -y > /dev/null
  if [ $? != 0 ]; then
    echo -e "Failed to install nginx";
    exit 1;
  fi

  echo "Install Elasticsearch";
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? != 0 ]; then
    echo -e "Failed to add key for Elasticsearch";
    exit 1;
  fi

  apt-get install apt-transport-https;
  if [ $? != 0 ]; then
    echo -e "Failed to install apt-transport-https";
    exit 1;
  fi
  echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
  apt-get update;
  apt-get install elasticsearch -y;

  echo "Install Redis";
  apt-get install build-essential tcl;
  local _cwd=$(pwd);
  cd /tmp;
  curl -O http://download.redis.io/redis-stable.tar.gz;
  tar xzvf redis-stable.tar.gz;
  cd redis-stable;
  make > /dev/null;
  make install > /dev/null;
  cd $_cwd;
}

function main {
  local _USER=$1;

  update_apt;
  install_lang_runtime $_USER;
  install_dev_tools;
  install_cli_tools;
}

main $1;
