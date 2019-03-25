# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/home/hidde/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="terminalparty"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias vim='nvim'
alias mutt='tmux rename-window mutt; neomutt'
alias notes='tmux rename-window notes; cd ~/Personal/Notes; vim inbox.txt todo.txt waiting\ for.txt Serverius/projects.txt'

zstyle ":completion:*:*:ssh:*" use-cache 1
zstyle -s ":completion:*:*:ssh:*" cache-policy update_policy
if [[ -z "$update_policy" ]]; then
  zstyle ":completion:*:*:ssh:*" cache-policy _ssh_caching_policy
fi

_ssh 2>/dev/null
functions[_ssh_orig]=$functions[_ssh]
_ssh () {
  if ( [[ ${+_maas_hosts} -eq 0 ]] ||
      _cache_invalid MAAS_hosts ) && ! _retrieve_cache MAAS_hosts;
  then
    if [[ $PREFIX = cc-* ]]; then
      _maas_hosts=($(maas machines --format plain | sed -ne 's/.*\(CC[^ \t]*\).*/\1/p' | tr '[:upper:]' '[:lower:]'))
      if (( ${#_maas_hosts} )); then
        _store_cache MAAS_hosts _maas_hosts
      fi
    fi
  fi
  _wanted hosts expl 'remote host name' \
    compadd -M 'm:{a-zA-Z}={A-Za-z} r:|.=* r:|=*' "$@" $_maas_hosts
  _ssh_orig "$@"
}

_ssh_caching_policy () {
    # rebuild if cache is more than one hour
    local -a oldp
    oldp=( "$1"(Nmh+1) )
    (( $#oldp ))
}
