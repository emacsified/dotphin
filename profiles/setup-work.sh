#!/usr/bin/env zsh

step "Setup SSH Keys"
SSH_DIR="$HOME/.ssh"
cp "$DOTFILES_REPO/ssh/publicKeys/id_rsa.pub" "$SSH_DIR/id_rsa.pub"

step "Setup GPG Key"
if [[ $(gpg --list-secret-keys 2>/dev/null | grep -w 5C3E5C7460B27C4E4871BDAD2CB691A35DD056B7) ]] ; then
    info "GPG key already installed"
else
    opsignin
    temp_file=$(mktemp)
    trap "rm -f $temp_file" 0 2 3 15
    op document get "private.key" --output $temp_file
    gpg --import --batch $temp_file &> /dev/null
    expect -c 'spawn gpg --edit-key 5C3E5C7460B27C4E4871BDAD2CB691A35DD056B7 trust quit; send "5\ry\r"; expect eof' &> /dev/null
    success "Installed GPG Key"
    rm -f $temp_file
fi

step "Setup SSH Keys"
if [ -f "$HOME/.ssh/id_rsa" ]; then
	info "SSH key already exists"
else
	opsignin
	temp_file=$(mktemp)
	trap "rm -f $temp_file" 0 2 3 15
	op document get "ssh.key" --output $temp_file
	mkdir -p $HOME/.ssh
	cp $temp_file $HOME/.ssh/id_rsa
	chmod 600 $HOME/.ssh/id_rsa
	success "Installed SSH Key"
	rm -f $temp_file
fi


#step "Setup Project folder"
PROJECTS_DIR="$HOME/Code"
if [[ -d "${PROJECTS_DIR}" ]]; then
    #info "Project folder already exists"
else
    mkdir "${PROJECTS_DIR}"
    success "Project folder created"
    step "Initializing repo"
    (cd "${PROJECTS_DIR}"; repo init -u git@github.com:Nef10/repo-manifest.git | cat)
    success "Initialized repo"
    step "Downloading repositories"
    (cd "${PROJECTS_DIR}"; repo --no-pager sync | cat)
    success "Downloaded repositories"
    step "Checking out branches and downloading git lfs files"
    (cd "${PROJECTS_DIR}"; repo --no-pager forall -p -c 'git checkout $REPO_RREV && git lfs pull' | cat)
    success "Checked out branches and downloaded git lfs files"
#fi

step "AWS"
if [[ ! -d $HOME/.aws ]]; then
    mkdir $HOME/.aws
fi
copy_file "AWS Config" $DOTFILES_REPO/aws/config $HOME/.aws/config
backup_file_if_exists $HOME/.aws/config
touch $HOME/.aws/credentials
