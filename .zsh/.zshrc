TRUE=1
FALSE=0
CHPWD=$TRUE

# 設定ファイルロード用
zshload(){
    ZSHRC_FILE=$ZDOTDIR/$1
    if [ -f $ZSHRC_FILE ] 
        then source $ZSHRC_FILE
        else echo "${ZSHRC_FILE}が読み込めませんでした"
    fi
}

# 個別設定読み込み
zshload .zshrc.local
# 関数定義読み込み
zshload .zshrc.function
# git系読み込み
zshload .zshrc.git

precmd(){
    psvar=()

    git_check
    GIT_CHECK_RESULT=$?
    if [ $GIT_CHECK_RESULT -ne 9 ]
        then
            GIT_STATUS_COLOR_RED="009"
            GIT_STATUS_COLOR_YELLOW="226"
            GIT_STATUS_COLOR_GREEN="118"
            GIT_STATUS_COLOR_BLUE="039"
            # ファイルの更新状況によって色を変える
            case $GIT_CHECK_RESULT in
                $GIT_TRACKSTATUS_ALL_COMMITED          ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_BLUE;;
                $GIT_TRACKSTATUS_ALL_STAGING_NOCHANGE  ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_GREEN;;
                $GIT_TRACKSTATUS_ALL_STAGING_CHANGED   ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_YELLOW;;
                $GIT_TRACKSTATUS_EXISTS_UNTRACKED_FILE ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_RED;;
            esac
            GIT_CURRENT_BRANCH=`git_current_branch`
            RPROMPT="[`clecho_prompt $GIT_CURRENT_BRANCH $GIT_BRANCH_COLOR`]"
        else
            RPROMPT=""
    fi

    # 毎回実行するコマンド
    ############################################################

    # 区切り線
    SEPARATOR=""
    TERMINAL_WIDTH=`tput cols`
    SEPARATOR_WIDTH=`expr $TERMINAL_WIDTH - 4`
    for TEMP in {1..$SEPARATOR_WIDTH};
        do SEPARATOR="${SEPARATOR}."
    done;
    echo # 改行
    clecho "  $SEPARATOR  \n" 141

    # ls
    if [ $CHPWD -eq $TRUE ]
        then
            CHPWD=$FALSE
            autoDispTitle "files"
            ls
            echo # 最後に改行する
    fi

    # git status
    if [ $GIT_CHECK_RESULT -ne $GIT_TRACKSTATUS_NOT_IN_GIT_REPOSITORY ]
        then
            autoDispTitle "git status"
            if [ $GIT_CHECK_RESULT -eq $GIT_TRACKSTATUS_ALL_COMMITED ]
                then
                    clecho "全てコミット済みです" 144
                else
                    git status -s
            fi
            echo # 最後に改行する
    fi

    # tips
    ARG=$RANDOM
    TIPS=`tips $ARG`
    if [ $TIPS ]
        then
            autoDispTitle "tips"
            print -nP "$TIPS\n"
    fi

}

export LANG=ja_JP.UTF-8

setopt print_eight_bit

# 補間
autoload -U compinit
compinit

# プロンプトの設定
autoload colors
colors

PROMPT="
`clecho_prompt %~ 111`
`clecho_prompt %n 240`@`clecho_prompt %M 228`$ "

# 256色を有効に
TERM=xterm-256color

# ディレクトリ名だけでディレクトリ移動
setopt auto_cd

# cdする旅にlsするように設定
chpwd(){
    CHPWD=$TRUE
}

autoDispTitle(){
    if [ $# -gt 0 ]
        then STR=$1
        else return 1
    fi
    if [ $# -gt 1 ]
        then COLOR=$2
        else COLOR="179" # デフォルトカラー
    fi
    UNDERLINED_STR="`ulecho \"/ $STR\"`"
    clecho $UNDERLINED_STR $COLOR
}

tips(){
    if [ $# -gt 0 ]
        then NUM=$1
        else NUM=$RANDOM
    fi

    ALL_LINES=()
    COUNT=0;

    find $ZDOTDIR/tips -type f -name "*.txt" | while read FILE
    do
        while read LINE;
        do
            ALL_LINES+=($LINE)
            COUNT=`expr $COUNT + 1`
        done < $FILE
    done

    if [ $COUNT -gt 0 ];
    then
        ID=`expr $NUM % $COUNT`
        ID=`expr $ID + 1`
        echo $ALL_LINES[$ID]
    else
        echo ""
    fi
}

