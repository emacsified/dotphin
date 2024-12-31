function update_dotfiles() {
    $HOME/.dotfiles/update-dotfiles.sh "$@"
}

function hide() {
    chflags hidden $1
}

function unhide() {
    chflags nohidden $1
}

function finder() {
    open .
}

function mute() {
    osascript -e 'set volume output muted true'
}

function unmute() {
    osascript -e 'set volume output muted false'
}

function volume() {
    if [[ -z $1 ]]; then
        osascript -e "output volume of (get volume settings)"
    else
        osascript -e "set volume output volume $1"
    fi
}

function port() {
    sudo lsof -i :$1
}

function battery() {
    pmset -g batt
}

function software() {
    system_profiler SPSoftwareDataType
}

function hardware() {
    system_profiler SPHardwareDataType SPDisplaysDataType
}
