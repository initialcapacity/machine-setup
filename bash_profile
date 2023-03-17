source ~/.aliases

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
 
RED="\[\033[0;31m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
 
PS1="$GREEN\u$NO_COLOR@$RED\\h $BLUE\D{%F %T}
in: $NO_COLOR\w $BLUE\$(parse_git_branch)$NO_COLOR\$: "

jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

jdk 1.8 > /dev/null 2>&1

export BASH_SILENCE_DEPRECATION_WARNING=1
