#! /bin/bash

tmux has-session -t bgterm || tmux new -s bgterm -d \; send -t bgterm source SPACE ~/.bashrc ENTER
tmux attach -t bgterm 


# ---------- Step 0 ----------
#
# Check whether jupyter notebook is already running
pids=$(ps a | grep [j]upyter-notebook | awk '{ print $1 }')
if [ ! -z ${pids} ]; then
    to_keep=$(echo -e "No\nYes" | dmenu -i -p "Jupyter Notebook exists, keep it?")
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

# Step 1
#
# List all conda environment and pick one
#
# Note: '^#\|^$' means line start with # or empty line.
conda_envs=$(conda env list | grep -v '^#\|^$' | cut -d' ' -f1)
if [ -z ${conda_envs} ]; then
    i3-nagbar -t warning -m "$PATH"
    exit
fi
picked=$(echo "$conda_envs" | dmenu -i -p "Jupyter Kernel")
conda activate ${picked}

# Step 2
#
# Input the starting path
#
# TODO(breakds): Auto completion of file path
working_dir=$(echo -e "$HOME/projects\n$HOME" | dmenu -i -p "Working Dir")
cd ${working_dir}
jupyter notebook
