PATH="$PATH":/Users/darima/bin:/usr/bin/symfony:/usr/local/mysql/bin:/usr/bin/scala/bin:
export LANG=ja_JP.UTF-8

setopt print_eight_bit

# 補間
autoload -U compinit
compinit

# プロンプトの設定
autoload colors
colors
PROMPT='current:%F{blue}%~%f
[%F{red}%n%f@%F{yellow}%M%f] '

# ディレクトリ名だけでディレクトリ移動
setopt auto_cd

alias ls='ls -G'
