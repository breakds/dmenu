# Ensure that the bgterm session exists.
function bgterm_ensure_session() {
    tmux has-session -t bgterm || tmux new -s bgterm -d \; send -t bgterm source SPACE ~/.bashrc ENTER
}

bgterm_ensure_session

# Same as above, but create the window if it does not exist.
function bgterm_ensure_window() {
    tmux attach -t bgterm \; detach
    tmux select-window -t $1 || tmux new-window -n $1 \; send -t bgterm source SPACE ~/.bashrc ENTER
}
