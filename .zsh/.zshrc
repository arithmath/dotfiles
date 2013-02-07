TRUE=1
FALSE=0
CHPWD=$TRUE

precmd(){
    psvar=()
    # gitの管理下にあるかどうかを確認
    `git branch > /dev/null 2>&1`
    if [ $? -eq 0 ]
        then IN_GIT_REPOSITORY=$TRUE
        else IN_GIT_REPOSITORY=$FALSE
    fi

    # gitの管理下にある場合は、追加でいろいろな情報を取得する
    if [ $IN_GIT_REPOSITORY -eq $TRUE ]
        then
            # その1. git status -sで、ファイルの更新状態を取得する
            ############################################################
            GIT_STATUS=`git status`

            # その1-1. gitの管理下にないファイルがあるかどうかを確認
            echo $GIT_STATUS | grep '^# Untracked files:$' 1>/dev/null
            if [ $? -eq 0 ]
                then GIT_EXISTS_UNTRACKED_FILE=$TRUE
                else GIT_EXISTS_UNTRACKED_FILE=$FALSE
            fi

            # その1-2. gitの管理下にあって、修正されたファイルがあるかどうかを確認
            echo $GIT_STATUS | grep '^# Changes not staged for commit:$' 1>/dev/null
            if [ $? -eq 0 ]
                then GIT_EXISTS_MODIFIED_FILE=$TRUE
                else GIT_EXISTS_MODIFIED_FILE=$FALSE
            fi

            # その1-3. gitの管理下にあって、ステージングまでされたファイルがあるかどうかを確認
            echo $GIT_STATUS | grep '^# Changes to be committed:$' 1>/dev/null
            if [ $? -eq 0 ]
                then GIT_EXISTS_STAGING_FILE=$TRUE
                else GIT_EXISTS_STAGING_FILE=$FALSE
            fi

            # その2. git管理ファイルの追跡状況を調べる
            ############################################################

            # 追跡状況を示す定数を定義
            GIT_TRACKSTATUS_ALL_COMMITED=0          # すべてコミットされている
            GIT_TRACKSTATUS_ALL_STAGING_NOCHANGE=1  # すべてステージングされて、ステージング後変更がない
            GIT_TRACKSTATUS_ALL_STAGING_CHANGED=2   # すべてステージングされているが、ステージング後変更がある
            GIT_TRACKSTATUS_EXISTS_UNTRACKED_FILE=3 # 未追跡ファイルが存在する

            # GIT_TRACKSTATUSに追跡状況を代入
            GIT_TRACKSTATUS=$GIT_TRACKSTATUS_ALL_COMMITED
            if [ $GIT_EXISTS_STAGING_FILE -eq $TRUE ]
                then GIT_TRACKSTATUS=$GIT_TRACKSTATUS_ALL_STAGING_NOCHANGE
            fi
            if [ $GIT_EXISTS_MODIFIED_FILE -eq $TRUE ]
                then GIT_TRACKSTATUS=$GIT_TRACKSTATUS_ALL_STAGING_CHANGED
            fi
            if [ $GIT_EXISTS_UNTRACKED_FILE -eq $TRUE ]
                then GIT_TRACKSTATUS=$GIT_TRACKSTATUS_EXISTS_UNTRACKED_FILE
            fi

            # その3. 現在のブランチ名を取得
            ############################################################
            GIT_CURRENT_BRANCH=`git branch | grep '*' | cut -c 3-`
    fi

    if [ $IN_GIT_REPOSITORY -eq $TRUE ]
        then
            GIT_STATUS_COLOR_RED="009"
            GIT_STATUS_COLOR_YELLOW="226"
            GIT_STATUS_COLOR_GREEN="118"
            GIT_STATUS_COLOR_BLUE="039"
            # ファイルの更新状況によって色を変える
            case $GIT_TRACKSTATUS in
                $GIT_TRACKSTATUS_ALL_COMMITED          ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_BLUE;;
                $GIT_TRACKSTATUS_ALL_STAGING_NOCHANGE  ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_GREEN;;
                $GIT_TRACKSTATUS_ALL_STAGING_CHANGED   ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_YELLOW;;
                $GIT_TRACKSTATUS_EXISTS_UNTRACKED_FILE ) GIT_BRANCH_COLOR=$GIT_STATUS_COLOR_RED;;
            esac
            RPROMPT="[%F{$GIT_BRANCH_COLOR}$GIT_CURRENT_BRANCH%f]"
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
        do SEPARATOR="${SEPARATOR}-"
    done;
    clecho "  $SEPARATOR  " 141

    # ls
    if [ $CHPWD -eq $TRUE ]
        then
            CHPWD=$FALSE
            autoDispTitle "files"
            ls
            echo # 最後に改行する
    fi

    # git status
    if [ $IN_GIT_REPOSITORY -eq $TRUE ]
        then
            autoDispTitle "git status"
            if [ $GIT_TRACKSTATUS -eq $GIT_TRACKSTATUS_ALL_COMMITED ]
                then
                    print -nP "%F{144}  全てコミット済みです%f\n"
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

PATH=/usr/local/bin:"$PATH":/Users/darima/bin:/usr/bin/symfony:/usr/local/mysql/bin:/usr/bin/scala/bin:
export LANG=ja_JP.UTF-8

setopt print_eight_bit

# 補間
autoload -U compinit
compinit

# プロンプトの設定
autoload colors
colors
# gitのブランチを表示する文字列を生成
#PROMPT="
#%F{111}%~%f
#%F{240}%n%f@%F{228}%M%f$ "
#PROMPT=`echo "%{\e[38;05;111m%} {hogehoge} %{\e[m%}"`
#    echo "%{\e[38;05;${COLOR}m%}${STR}%{\e[m%}"
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

# 色をつけたりフォーマットを付与して出力します
# 第1引数に出力する文字を指定します
# 第2引数に色を指定します
#     30 : 文字色(黒)
#     31 : 文字色(赤)
#     32 : 文字色(緑)
#     33 : 文字色(黄色)
#     34 : 文字色(青)
#     35 : 文字色(マゼンタ)
#     36 : 文字色(シアン)
#     37 : 文字色(白)
#     40 : 背景色(黒)
#     41 : 背景色(赤)
#     42 : 背景色(緑)
#     43 : 背景色(黄色)
#     44 : 背景色(青)
#     45 : 背景色(マゼンタ)
#     46 : 背景色(シアン)
#     47 : 背景色(白)
# 第3匹数にフォーマットを指定します(省略可能)
#      0 : ノーマル
#      1 : 太字
#      4 : 下線
#      5 : 点滅
#      7 : 色反転
#      8 : Consealed
echoWithFormat(){
    if [ $# -gt 0 ]
        then STR=$1
        else return 1
    fi
    if [ $# -gt 1 ]
        then COLOR=$2
        else return 2
    fi
    if [ $# -gt 2 ]
        then STYLE=$3
        else STYLE="0"
    fi
    case $COLOR in
        "black"   ) COLOR="30";;
        "red"     ) COLOR="31";;
        "green"   ) COLOR="32";;
        "yellow"  ) COLOR="33";;
        "blue"    ) COLOR="34";;
        "magenta" ) COLOR="35";;
        "cyan"    ) COLOR="36";;
        "white"   ) COLOR="37";;
    esac

    echo "\033[${STYLE};${COLOR}m${STR}\033[0;39m"
}

clecho(){
    if [ $# -gt 0 ]
        then STR=$1
        else return 1
    fi
    if [ $# -gt 1 ]
        then COLOR=$2
        else return 2
    fi

    # カラー表示する場合は "\e[38;05;色番号m"と"\e[m"で囲めば良い。
    # また、上記のエスケープシーケンスを%{と%}で囲まないと、PROMPTで使用したときにRPROMPTがずれる。
    # そのため、実際には"%{\e[38;05;色番号m%}"と"%{\e[m%}"で囲む
    echo "\e[38;05;${COLOR}m${STR}\e[m"
}

clecho_prompt(){
    if [ $# -gt 0 ]
        then STR=$1
        else return 1
    fi
    if [ $# -gt 1 ]
        then COLOR=$2
        else return 2
    fi

    # カラー表示する場合は "\e[38;05;色番号m"と"\e[m"で囲めば良い。
    # また、上記のエスケープシーケンスを%{と%}で囲まないと、PROMPTで使用したときにRPROMPTがずれる。
    # そのため、実際には"%{\e[38;05;色番号m%}"と"%{\e[m%}"で囲む
    echo "%{\e[38;05;${COLOR}m%}${STR}%{\e[m%}"
}

clprint(){
    if [ $# -gt 0 ]
        then STR=$1
        else return 1
    fi
    if [ $# -gt 1 ]
        then COLOR=$2
        else return 2
    fi
    print -nP "%F{${COLOR}}${STR}%f"
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
    print -nP "%U%F{$COLOR}/ $STR %f%u\n"
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

# 環境固有の設定の読み込み
[ -f $ZDOTDIR/.zshrc.local ] && source $ZDOTDIR/.zshrc.local
