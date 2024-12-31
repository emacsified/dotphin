#!/bin/zsh
# uncomment this and the last line for zprof info
# zmodload zsh/zprof

# shortcut to this dotfiles path is $DOTFILES
export DOTFILES="$HOME/.dotfiles"

# your project folder that we can `c [tab]` to
export PROJECTS="$HOME/Code"

alias ls=colorls

# your default editor
alias vim=nvim
export EDITOR='nvim'
export VEDITOR='emacs'

# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/*/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

# load antibody plugins
source ~/.dotfiles/zsh_plugins.sh

source ~/.dotfiles/zsh/aliases.zsh
source ~/.dotfiles/zsh/functions.zsh

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C


# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files updated_at

# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
# shellcheck disable=SC1090
[ -f ~/.localrc ] && . ~/.localrc

# zprof

eval $(thefuck --alias)


export GOPATH="$(go env GOPATH)"
export PATH="${PATH}:${GOPATH}/bin"

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# pnpm
export PNPM_HOME="/Users/AMcbride/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

###### Nandos

export GOOGLE_CREDENTIALS=~/Documents/platform-provisioning.json

# 4 - gcloud nandos-api-platform
#SECRET_PROD="/Users/john.gillott/dev/.secrets/prod-platform-provisioning.json"
#SECRET_DEV="/Users/john.gillott/dev/.secrets/dev-platform-provisioning.json"
export SECRET_DEV=~/Documents/platform-provisioning.json

alias prod='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_PROD' \
 && gcloud config set account platform-provisioning-prod@nandos-api-platform-production.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform-production && gcloud auth activate-service-account --key-file '$SECRET_PROD' \
 && if [ $(dig +short A -4 dns-check.nandos.services) = "34.89.31.15" ]; then gcloud container clusters get-credentials prod-blue --region europe-west2; else gcloud container clusters get-credentials prod-green --region europe-west2; fi'

alias preprod='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && if [ $(dig +short A -4 dns-check.preprod.nandos.services) = "35.246.26.213" ]; then gcloud container clusters get-credentials dev-preprod-blue --region europe-west2; else gcloud container clusters get-credentials dev-preprod-green --region europe-west2; fi'

alias dev='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && if [ $(dig +short A -4 dns-check.dev.nandos.services) = "35.235.54.199" ]; then gcloud container clusters get-credentials dev-preview-blue --region europe-west2; else gcloud container clusters get-credentials dev-preview-green --region europe-west2; fi'

alias dev-tooling='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(dev-tooling, dev-tooling-blue, dev-tooling-green)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias prod-blue='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_PROD' \
 && gcloud config set account platform-provisioning-prod@nandos-api-platform-production.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform-production && gcloud auth activate-service-account --key-file '$SECRET_PROD' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(prod-blue)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias prod-green='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_PROD' \
 && gcloud config set account platform-provisioning-prod@nandos-api-platform-production.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform-production && gcloud auth activate-service-account --key-file '$SECRET_PROD' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(prod-green)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias preprod-blue='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(dev-preprod-blue)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias preprod-green='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(dev-preprod-green)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias dev-blue='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(dev-preview-blue)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias dev-green='export GOOGLE_APPLICATION_CREDENTIALS='$SECRET_DEV' \
 && gcloud config set account platform-provisioning@nandos-api-platform.iam.gserviceaccount.com \
 && gcloud config set project nandos-api-platform && gcloud auth activate-service-account --key-file '$SECRET_DEV' \
 && gcloud container clusters get-credentials $(gcloud container clusters list --filter="name:(dev-preview-green)" --limit=1 --format="value(selfLink.scope())") --region europe-west2'

alias heater='stress -c 6 -m 2 -t 300'

export GPG_TTY=$(tty)

export PATH="$HOME/.local/bin:$PATH"

alias ts="tmux-sessionizer"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--color=selected-bg:#bcc0cc \
--multi"

# init mise for version managing
eval"$(~/.local/bin/mise activate zsh)"

# init starship prompt
eval "$(starship init zsh)"
