if [ $USER != "root" ]; then
    echo "Please execute setup.sh with sudo permission"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Please enter [username] after setup.sh"
    exit 1
fi

# Check user is valid or not
USERNAME=$1
grep -Fq "/home/${USERNAME}:" /etc/passwd
if [ $? -eq 1 ]; then
    echo "${USERNAME} is not registered in the system"
    exit 1
fi
echo "Setup environment for user '${USERNAME}'"

# Update Packages
# =====================================================================
apt update && apt upgrade

# Install tmux
# =====================================================================
apt install tmux

git clone https://github.com/gpakosz/.tmux.git "/home/${USERNAME}"
# Setup configuration file
TMUX_CONF_FILE="/home/${USERNAME}/.tmux.conf"
TMUX_CONF_STYLE_FILE="/home/${USERNAME}/.tmux.conf.local"
cp "tmux/tmux.conf" ${TMUX_CONF_FILE}
cp "tmux/tmux.conf.local" ${TMUX_CONF_STYLE_FILE}

# Update file permission
chown ${USERNAME}:${USERNAME} ${TMUX_CONF_FILE}

# Install handy tools
# =====================================================================
apt install \
            vim \
            tmux \
            htop \
            tldr \
            net-tools \
            python3 python3-pip python3-dev \
            tig \
            zsh \
            curl \
            ripgrep

# Install zsh shell
# =====================================================================
apt install zsh

# Change user shell
command -v zsh | tee -a /etc/shells
chsh -s /usr/bin/zsh

# Setup configuration files
ZSHRC="/home/${USERNAME}/.zshrc"
cp zsh/zshrc ${ZSHRC}
chown ${USERNAME}:${USERNAME} ${ZSHRC}

# Install oh-my-zsh plugins
OH_MY_ZSH_DIR="/home/${USERNAME}/.oh-my-zsh"
OH_MY_ZSH_CUSTOM_DIR="${OH_MY_ZSH_DIR}/custom"
OH_MY_ZSH_PLUGIN_DIR="${OH_MY_ZSH_CUSTOM_DIR}/plugins"

OH_MY_ZSH_URL="https://github.com/robbyrussell/oh-my-zsh.git"

ZSH_AUTOSUGGESTION_DIR="${OH_MY_ZSH_PLUGIN_DIR}/zsh-autosuggestions"
ZSH_AUTOSUGGESTION_URL="https://github.com/zsh-users/zsh-autosuggestions.git"

ZSH_SYNTAX_HIGHLIGHT_DIR="${OH_MY_ZSH_PLUGIN_DIR}/zsh-syntax-highlighting"
ZSH_SYNTAX_HIGHLIGHT_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"

ZSH_PYENV_DIR="${OH_MY_ZSH_PLUGIN_DIR}/zsh-pyenv"
ZSH_PYENV_URL="https://github.com/mattberther/zsh-pyenv.git"

if [ ! -d ${OH_MY_ZSH_DIR} ]; then
    git clone ${OH_MY_ZSH_URL} ${OH_MY_ZSH_DIR}
fi

cp zsh/aliases.zsh ${OH_MY_ZSH_CUSTOM_DIR}
cp zsh/exports.zsh ${OH_MY_ZSH_CUSTOM_DIR}
cp zsh/robbyrussell.zsh-theme ${OH_MY_ZSH_CUSTOM_DIR}

if [ ! -d ${OH_MY_ZSH_PLUGIN_DIR} ]; then
    mkdir -p ${OH_MY_ZSH_PLUGIN_DIR}
fi

if [ ! -d ${ZSH_AUTOSUGGESTION_DIR} ]; then
    git clone ${ZSH_AUTOSUGGESTION_URL} ${ZSH_AUTOSUGGESTION_DIR}
fi

if [ ! -d ${ZSH_SYNTAX_HIGHLIGHT_DIR} ]; then
    git clone ${ZSH_SYNTAX_HIGHLIGHT_URL} ${ZSH_SYNTAX_HIGHLIGHT_DIR}
fi

if [ ! -d ${ZSH_PYENV_DIR} ]; then
    git clone ${ZSH_PYENV_URL} ${ZSH_PYENV_DIR}
fi

chown -R ${USERNAME}:${USERNAME} ${OH_MY_ZSH_DIR}
chsh -s /bin/zsh ${USERNAME}

# install fzf
# =====================================================================
FZF_URL="https://github.com/junegunn/fzf.git"
git clone --depth 1 ${FZF_URL} /home/${USERNAME}/.fzf
/home/${USERNAME}/.fzf/install

# install lts nodejs
# =====================================================================
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh


# install python virtual environment
# =====================================================================
PYENV_DIR="/home/${USERNAME}/.pyenv"
PYENV_URL="https://github.com/pyenv/pyenv.git"
PYENV_VIRT_URL="https://github.com/pyenv/pyenv-virtualenv.git"

if [ ! -d ${PYENV_DIR} ]; then
    git clone ${PYENV_URL} ${PYENV_DIR}
    mkdir -p "${PYENV_DIR}/plugins"
    git clone ${PYENV_VIRT_URL} "${PYENV_DIR}/plugins/pyenv-virtualenv"
    chown ${USERNAME}:${USERNAME} ${PYENV_DIR}
fi


# Update vimrc and gitconfig
# =====================================================================
cp .gitconfig /home/${USERNAME}
cp .vimrc /home/${USERNAME}
