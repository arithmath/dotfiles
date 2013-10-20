script_dir=$(cd $(dirname $0); pwd)

# 設置ファイルの定義
targets[0]=".vimrc"
targets[1]=".vim"
targets[2]=".zshenv"
targets[3]=".zsh"
targets[4]=".gitconfig"
targets[5]=".tmux.conf"
targets[6]=".misc"

for target in "${targets[@]}"
do
    source_path="$script_dir/$target"
    dist_path="$HOME/$target"
    rm $dist_path 2>/dev/null
    ln -s "$source_path" ~/
done
