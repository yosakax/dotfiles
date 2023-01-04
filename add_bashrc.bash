# pyenv の設定
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## コピペ用の関数
# you need to install xsel like this: sudo apt install xsel
clip() { # ファイルの中身をコピー
    cat $1 | xsel --clipboard --input
}

## c++コンパイル
cppcompile() { g++ -O2 --std=c++14 $@ ; }
cppr() {
    exename="$(echo $1 | sed 's/\.[^\.]*$//')"
    cppcompile $@
    ./a.out && rm a.out
}

nimcompile() { nim c $@ ;}
nimr() {
    exename="$(echo $1 | sed 's/\.[^\.]*$//')"
    nimcompile $@
    ./$exename && rm $exename
}

## Rustコンパイル
rustcompile(){ rustc $@ ;}
rrust() {
    exename="$(echo $1 | sed 's/\.[^\.]*$//')"
    rustcompile $@
    ./$exename && rm $exename
}

## nvimの設定
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
nvim --version > /dev/null || {
  sudo add-apt-repository ppa:neovim-ppa/stable -y
  sudo apt-get update
  sudo apt-get install neovim -y
  mkdir -p ${XDG_CONFIG_HOME}/nvim
  touch ${XDG_CONFIG_HOME}/nvim/init.vim
}

## PS1の設定
# source ~/.bash/completion/_git
# source ~/.bash/completion/git-prompt.sh

# プロンプトに各種情報を表示
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=1

############### ターミナルのコマンド受付状態の表示変更
# \u ユーザ名
# \h ホスト名
# \W カレントディレクトリ
# \w カレントディレクトリのパス
# \n 改行
# \d 日付
# \[ 表示させない文字列の開始
# \] 表示させない文字列の終了
# \$ $
# export PS1='\[\033[1;32m\]\u\[\033[00m\]:\[\033[1;34m\]\w\[\033[1;31m\]$(__git_ps1)\n\[\033[00m\] \$ '
# export PS1='\[\e[37;45m\] \u \[\e[35;47m\]\[\e[30;47m\] \W \[\e[37;46m\]\[\e[30m\] $(__git_ps1 "(%s)") \[\e[36;49m\]\[\e[0m\]\n $'
##############
# Function part
## 16bitカラーの定義がわかりにくいので再定義(なくてもいいです)
c_red="\e[31m"
c_gre="\e[32m"
c_yel="\e[33m"
c_blu="\e[34m"
c_mag="\e[35m"
c_cya="\e[36m"
c_off="\e[m"
export PS1='\[\033[1;31m\]\u\[\033[00m\]:\[\033[1;34m\]\w\[\033[1;31m\]$(__git_ps1)\n\[\033[00m\] \$ '

# Source global definitions
## おまじない
# if [ -f /etc/bashrc ]; then
    # . /etc/bashrc
# fi

# Aliases
## この他にもよく使うコマンドのエイリアスを追加してもいいです。
alias grep='grep --color'
# alias ssh='sshrc'

alias ls='ls -F --color=auto'
alias ll='ls -Fal --color=auto'
alias cl="clip"

## 環境別設定
### 色の設定などは完全に好みです
### ログインした時点で、そのサーバーのhostnameを元に環境を判断し、shellの表示する文字を変更します
### if文の中の-eごとに部分一致の条件を付け加えられます

## 次の行でコンソールでカレントディレクトリの表示、コマンドごとに改行、色の定義を行う。
# PS1="\[\n${c_red}\]\u@ ~> \[${c_yel}\] $(__git_ps1 " (%s)") \n\w ~> \n$ \[\e[0m\]"
# PS1="\[\n${c_gre}\]\D{%Y/%m/%d} \t \u@\h -> \[${c_yel}\]\n\w -> \n$ \[\e[0m\]"
# PS1="\[\n${c_cya}\]\D{%Y/%m/%d} \t \u@\h -> \[${c_yel}\]\n\w -> \n$ \[\e[0m\]"
# PS1="\[\n${c_mag}\]\D{%Y/%m/%d} \t \u@\h -> \[${c_yel}\]\n\w -> \n$ \[\e[0m\]"


export GIT_EDITOR=nvim
