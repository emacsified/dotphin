#!/usr/bin/env zsh

main() {
    ask_for_profile
    ask_for_sudo
    install_homebrew
    if [[ "$1" != "--update" ]]; then
        clone_dotfiles_repo
    fi
    install_packages_with_brewfile
    link_brew_completions
    configure_zsh
    configure_git
    configure_ssh
    configure_rust
	configure_dotfiles
    install_quartz_filter
    hide_home_applications
    setup_repos
    profile_specifics
    if [[ "$1" != "--update" ]]; then
        finish
    fi
}

DOTFILES_REPO=$HOME/.dotfiles

# Steps

function ask_for_profile() {
    step "Asking for profile"
    if [[ -f $DOTFILES_REPO/profile ]]; then
        PROFILE=$(cat $DOTFILES_REPO/profile)
        success "Found saved profile: $PROFILE"
    else
        info "Please enter the profile to be used (private|work):"
        read PROFILE
        success "Using profile: $PROFILE"
    fi
}

function ask_for_sudo() {
    step "Prompting for sudo password"
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
        success "Temporary sudo mode activated"
    else
        error "sudo failed"
    fi
}

function clone_dotfiles_repo() {
    clone_or_update "Dotfiles" ${DOTFILES_REPO} "https://github.com/emacsified/dotfiles.git"
    echo $PROFILE > $DOTFILES_REPO/profile
}

function install_homebrew() {
    step "Installing Homebrew"
    if hash brew 2>/dev/null; then
        info "Homebrew already exists"
    else
        if true | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
            if [ "$(uname -p)" = "i386" ]; then
                eval "$(/usr/local/bin/brew shellenv)"
            else
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            success "Homebrew installation succeeded"
        else
            error "Homebrew installation failed"
        fi
    fi
}

function install_packages_with_brewfile() {
    DEFAULT_BREW_FILE_PATH="${DOTFILES_REPO}/brew/macOS.Brewfile"
    PROFILE_BREW_FILE_PATH="${DOTFILES_REPO}/brew/${PROFILE}.Brewfile"
    step "Installing software with brew"
    if cat $DEFAULT_BREW_FILE_PATH $PROFILE_BREW_FILE_PATH | brew bundle check --no-upgrade --file=- &> /dev/null; then
        info "Brewfile's dependencies are already satisfied"
    else
        if cat $DEFAULT_BREW_FILE_PATH $PROFILE_BREW_FILE_PATH | brew bundle --no-upgrade --file=-; then
            success "Brewfile installation succeeded"
        else
            warning "Brewfile installation failed"
        fi
    fi
}

function link_brew_completions() {
    step "Linking brew completions"
    if brew completions state | grep -q "are linked"; then
        info "Brew completions are already linked"
    else
        brew completions link &> /dev/null
        success "Brew completions linked successfully"
    fi
}

function configure_zsh() {
    copy_file "zshrc" $DOTFILES_REPO/zsh/.zshrc $HOME/.zshrc
}

function configure_git() {
    GIT_CONFIG_TEMPLATE="$DOTFILES_REPO/git/.gitconfig_template_$PROFILE"
    addTemplateToFileIfNeeded $GIT_CONFIG_TEMPLATE ".gitconfig include" $HOME/.gitconfig
}

function configure_dotfiles() {
	configure_kitty
	configure_aerospace
	configure_tmux
	configure_mise
	configure_nvim
    configure_tmux_sessionizer
    configure_gh
}

configure_tmux_sessionizer() {
    copy_file "tmux-sessionizer" $DOTFILES_REPO/tmux/tmux-sessionizer.sh $HOME/.local/bin/tmux-sessionizer.sh
    chmod +x $HOME/.local/bin/tmux-sessionizer.sh
}

configure_kitty() {
	copy_file "kitty.conf" $DOTFILES_REPO/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
}

configure_aerospace() {
	copy_file "aerospace" $DOTFILES_REPO/aerospace/aerospace.toml $HOME/.config/aerospace/aerospace.toml
}

configure_gh() {
    ln -s $DOTFILES_REPO/gh/ $HOME/.config/gh/
}

configure_tmux() {
	copy_file "tmux.conf" $DOTFILES_REPO/tmux/tmux.conf $HOME/.tmux.conf
	mkdir -p ~/.config/tmux/plugins/catppuccin
	git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin
}

configure_nvim() {
	ln -s $DOTFILES_REPO/nvim $HOME/.config/nvim
}
configure_mise() {
	copy_file "mise" $DOTFILES_REPO/mise/mise.toml $HOME/.config/mise/mise.toml
}

function configure_ssh() {
    if [[ ! -d $HOME/.ssh ]]; then
        mkdir $HOME/.ssh
    fi
    SSH_CONFIG_TEMPLATE="$DOTFILES_REPO/ssh/config_template_$PROFILE"
    addTemplateToFileIfNeeded $SSH_CONFIG_TEMPLATE "ssh config include" $HOME/.ssh/config
}

configure_rust() {
    curl https://sh.rustup.rs -sSf | sh
    rustup install nightly
    rustup component add rustfmt --toolchain nightly
    rustup component add clippy --toolchain nightly
}

function install_quartz_filter() {
    if [[ ! -d $HOME/Library/Filters ]]; then
        mkdir -p $HOME/Library/Filters
    fi
    copy_file "Quartz Filter Minimal" $DOTFILES_REPO/quartz/Reduce\ File\ Size\ Minimal.qfilter $HOME/Library/Filters/Reduce\ File\ Size\ Minimal.qfilter
    copy_file "Quartz Filter Medium" $DOTFILES_REPO/quartz/Reduce\ File\ Size\ Medium.qfilter $HOME/Library/Filters/Reduce\ File\ Size\ Medium.qfilter
    copy_file "Quartz Filter Extreme" $DOTFILES_REPO/quartz/Reduce\ File\ Size\ Extreme.qfilter $HOME/Library/Filters/Reduce\ File\ Size\ Extreme.qfilter
}

function hide_home_applications() {
    step "Hiding Application folder in home directory"
    if [[ -d $HOME/Applications ]]; then
        if [[ $(stat -f "%Xf" $HOME/Applications) -eq 8000 ]]; then
            info "folder already hidden"
        else
            chflags hidden $HOME/Applications
            success "successfully hidden"
        fi
    else
        warning "Application folder in home directory does not exist"
    fi
}

function profile_specifics() {
    . ${DOTFILES_REPO}/profiles/setup-${PROFILE}.sh
}

function finish() {
    echo ""
    success "Finished successfully!"
    info "Please restart your Terminal for the applied changes to take effect."
}

# Git helper

function clone_or_update() {
    step "Cloning ${1} repository into ${2}"
    if test -e $2; then
        info "${2} already exists"
        pull_latest $1 $2
    else
        if git clone "$3" $2; then
            success "${1} repository cloned into ${2}"
        else
            error "${1} repository cloning failed"
        fi
    fi
}

function pull_latest() {
    step "Pulling latest changes in ${1} repository"
    git -C $1 fetch &> /dev/null
    if [ $(git -C $2 rev-parse HEAD) '==' $(git -C $2 rev-parse @{u}) ]; then
        info "${1} already up to date"
    else
        if git -C $2 pull origin main &> /dev/null; then
            success "Pull in ${1} successful"
        else
            error "Failed, please pull latest changes in ${1} repository manually"
        fi
    fi
}

# File helper

function createFileIfNeeded() {
    step "creating ${1} if needed"
    if test -e $1; then
        info "${1} already exists"
    else
        if touch $1; then
            success "${1} created successfully"
        else
            error "${1} could not be created"
        fi
    fi
}

function copy_file() {
    step "Copying ${1}"
    if diff -q $2 $3 &> /dev/null; then
        info "${1} already the same"
    else
        if ln -s $2 $3; then
            success "${1} copied"
        else
            error "Failed to copy ${1}"
        fi
    fi
}

function addTemplateToFileIfNeeded() {
    createFileIfNeeded $3
    step "Setting up ${2} in ${3}"
    if [[ -z $(comm -13 $3 $1) ]]; then
        info "${2} already set up in ${3}"
    else
        if ln -s $1  $3; then
            success "${2} successfully set up in ${3}"
        else
            error "Failed to set up ${2} in ${3}"
        fi
    fi
}

function setup_repos() {
    step "Creating repo directories"
    if [[ -d $HOME/Code ]]; then
        info "Projects directory already exists"
    else
        mkdir $HOME/Code
        success "Projects directory created"
    fi
    if [[ -d $HOME/Code/personal ]]; then
        info "Personal directory already exists"
    else
        mkdir $HOME/Code/personal
        success "Personal directory created"
    fi
    if [[ -d $HOME/Code/work]]; then
        info "Work directory already exists"
    else
        mkdir $HOME/Code/work
        success "Work directory created"
    fi
    step "Cloning repos"
    if [[ -d $HOME/Code/personal/ashmcbri.de]]; then
        info "ashmcbri.de directory already exists"
    else
        git clone git@gitlab.com:emaxxx/ashmcbri.de.git $HOME/Code/personal/ashmcbri.de
        success "ashmcbri.de directory created"
    fi
    if [[ -d $HOME/Code/personal/artemis]]; then
        info "artemis directory already exists"
    else
        git clone git@github.com:artemis-torr/tracker.git $HOME/Code/personal/artemis
        success "artemis directory created"
    fi
    if [[ -d $HOME/Code/work/nandos-platform ]]; then
        info "nandos-platform directory already exists"
    else
        git clone git@github.com:NandosUK/nandos-platform.git $HOME/Code/work/nandos-platform
        success "nandos-platform directory created"
    fi
    if [[ -d $HOME/Code/work/nossa-casa-next ]]; then
        info "nossa-casa-next directory already exists"
    else
        git clone git@github.com:NandosUK/nossa-casa-next.git $HOME/Code/work/nossa-casa-next
        info "nossa-casa-next directory created"
    fi
    if [[ -d $HOME/Code/work/platform-config ]]; then
        info "platform-config directory already exists"
    else
        git clone git@github.com:NandosUK/platform-config.git $HOME/Code/work/platform-config
        success "platform-config directory created"
    fi

}

## helper

function opsignin() {
    if op whoami 2>&1 | grep -c 'ERROR' &> /dev/null; then
        warning "Logging into 1Password, your credentials are required:"
        if op account list 2>&1 | grep -c 'ash@ashmcbri.de' &> /dev/null; then
            eval "$(op signin)"
        else
            eval "$(op account add --address my.1password.co.uk --email ash@ashmcbri.de --signin)"
        fi
    fi
}

# Print helper

function step() {
    print -P "%F{blue}=> $1%f"
}

function info() {
    print -P "%F{white}===> $1%f"
}

function warning() {
    print -P "%F{yellow}===> $1%f"
}

function success() {
    print -P "%F{green}===> $1%f"
}

function error() {
    print -P "%F{red}===> $1%f"
    print -P "%F{red}Aborting%f"
    exit 1
}

main "$@";

