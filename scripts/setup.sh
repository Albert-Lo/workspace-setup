
# ===
# Setup User
# ===
function setup_user {
  local _GROUP=$1
  local _USER=$2

  echo "Setting up user";
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  echo "Checking if group ${_GROUP} exists";
  cat /etc/group | grep "^${_GROUP}:" > /dev/null;
  if [ $? = 1 ]; then
    echo "Creating ${_GROUP} group";
    addgroup --gid 8888 $_GROUP > /dev/null;
    if [ $? != 0 ]; then
      echo -e "Failed to create group";
      exit 1;
    fi
  fi

  echo "Checking if user ${_USER} exists";
  id -u $_USER > /dev/null;
  if [ $? = 1 ]; then
    echo "Creating ${_USER} user";
    adduser --disabled-password --uid 8888 --gid 8888 \
        --home "/home/${_USER}" --gecos "" $_USER > /dev/null;
    if [ $? != 0 ]; then
      echo -e "Failed to create user";
      exit 1;
    fi

    echo "Adding ${_USER} user to sudo group";
    usermod -aG sudo $_USER > /dev/null;
    if [ $? != 0 ]; then
      echo -e "Failed to add ${_USER} user to sudo group";
      exit 1;
    fi
  fi

  return 0;
}

function set_sudo_nopasswd {
  # ---
  # Ensure sudo users can run commands without entering a password
  # ---
  # Return 0 on success
  # Fail on error
  # ---
  echo "Enabling sudo users to run commands without password entry";
  sed -r -i \
      "s/%sudo\s+ALL=\(ALL:ALL\)\s+ALL/%sudo\tALL=(ALL:ALL) NOPASSWD: ALL/g" \
      "/etc/sudoers" > /dev/null;
  if [ $? != 0 ]; then
    echo -e "Failed to update /etc/sudoers file";
    exit 1;
  fi

  return 0;
}

for i in "$@"
do
case $i in
    -u=*|--user=*)
    USER="${i#*=}"
    shift # past argument=value
    ;;
    -g=*|--group=*)
    GROUP="${i#*=}"
    shift # past argument=value
    ;;
    *)
esac
done

function main {
  local _GROUP=$1
  local _USER=$2
  # TODO: Error out on missing params

  echo "Setting environment...";
  set_sudo_nopasswd;
  setup_user $_GROUP $_USER;
  source ./install.sh $_USER;
}

main $GROUP $USER;

