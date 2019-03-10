#! /bin/bash

source ${HOME}/scripts/dmenu/bash_utils/tmux_bgterm.sh

# ---------- Step 0 ----------
#
# Check whether jupyter notebook is already running
pids=$(ps a | grep [j]upyter-notebook | awk '{ print $1 }')
if [ ! -z ${pids} ]; then
    to_keep=$(echo -e "Yes\nNo" | dmenu -i -p "Jupyter Notebook exists, keep it?")
    if [ ${to_keep} = "Yes" ]; then
        # Keep the current jupyter by existing this script.
        exit
    else
        # Otherwise, kill each of the jupyter notebooks
        for pid in $(echo "${pids}"); do
            kill -9 ${pid}
        done
    fi
fi

# ---------- Step 1 ----------
#
# Pick an env for conda, and switch to it.
conda_envs=$(ls ~/anaconda3/envs)
picked=$(echo -e "${conda_envs}\nbase" | dmenu -i -p "Jupyter Kernel")
bgterm_ensure_window jupyter_notebook
tmux send -t bgterm conda SPACE activate SPACE ${picked} ENTER

# ---------- Step 2 ----------
#
# Set working directory and start notebook
#
# TODO(breakds): Auto completion of file path
working_dir=$(echo -e "$HOME/projects\n$HOME" | dmenu -i -p "Working Dir")
bgterm_ensure_window jupyter_notebook
tmux send -t bgterm cd SPACE ${working_dir} ENTER
tmux send -t bgterm jupyter SPACE notebook ENTER
