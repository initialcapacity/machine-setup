source ~/.aliases

autoload -Uz compinit && compinit -i

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%F{magenta}[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{magenta}[%b]%f %F{red}(%a)%f' 

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

NEWLINE=$'\n'
USERNAME="%F{green}%n%f"
HOSTNAME="%F{red}%m%f"
DATETIME="%F{blue}20%D %*%f"
LOCATION=%~

PROMPT='${USERNAME}@${HOSTNAME} ${DATETIME} $vcs_info_msg_0_${NEWLINE} ${LOCATION} $: '

jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

jdk 1.8 > /dev/null 2>&1
