## Define colours
## To be used in echo -e

ECHO_RED="\033[0;31m"
ECHO_YELLOW="\033[0;33m"
ECHO_BLUE="\033[0;34m"
ECHO_COLOR_NONE="\e[0m"

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

## Function to parse the git branch

function parse_git_branch_mine {
    git_branch="$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')"
    prompt=''
#    git_status="$(git status 2> /dev/null)"
    state=''

#    if [[ ! $git_status =~ "working directory clean" ]]; then
#        state="${RED}⚡"
#    else
#        state=''
#    fi
    if [ $git_branch ] ; then
        prompt=${RED}"($git_branch$state"${RED}")"${COLOR_NONE}
        git_branch=""
    fi

    echo $prompt
}

function is_under_git_control {
    git rev-parse --is-inside-work-tree 2> /dev/null
}

function get_current_folder_name {
    $(basename "$PWD")
}

function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "⚡"
}

function parse_git_behind {
    [[ $(git status -uno 2> /dev/null | grep "Your branch is behind") != "" ]] && echo "↓↓"
#   attempt ag givin red, but got the overwriting issue while tying long strings.. reverting
#   echo -e "${ECHO_RED}↓${ECHO_YELLOW}"
}

function parse_git_branch {
    if [[ $(is_under_git_control) ]]; then
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)$(parse_git_behind)]/"
       # $(parse_git_behind)
       # git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]/"
    fi
}

function add_new_symbol {
    echo -e "\u15DA"
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
#### Old one DO NOT REMOVE ####
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#    PS1="\\w$(parse_git_branch) ➔ "
   PS1='\w\[\033[1;33m\]$(parse_git_branch)\[\033[0m\] $(add_new_symbol) '
    # PS1='\w$(parse_git_branch_mine) $(add_new_symbol) '
fi
unset color_prompt force_color_prompt