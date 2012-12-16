# 
precmd(){
    psvar=()

    # gitのブランチを取得
    `git branch > /dev/null 2>&1`
    if [ $? -eq 0 ]
        then psvar[1]=`git branch | grep '*'| cut -c 3-`
        else psvar[1]='[not repo]'
    fi
}

PATH="$PATH":/Users/darima/bin:/usr/bin/symfony:/usr/local/mysql/bin:/usr/bin/scala/bin:
export LANG=ja_JP.UTF-8

setopt print_eight_bit

# 補間
autoload -U compinit
compinit

# プロンプトの設定
autoload colors
colors
# gitのブランチを表示する文字列を生成
PROMPT="
%F{blue}%~%f
%F{red}%n%f@%F{yellow}%M%f#%F{green}%1v%f $ "

# ディレクトリ名だけでディレクトリ移動
setopt auto_cd

alias ls='ls -G'
