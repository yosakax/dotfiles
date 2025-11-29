#!/bin/bash
# --------------------------------------------------
# Ubuntu 開発環境 初期設定スクリプト (bashrc設定追加)
# --------------------------------------------------

# エラーがあれば即座に終了し、未定義変数の使用を禁止する
set -eu

# $HOME/.local/bin が存在しない場合は作成し、PATHに追加するための準備
mkdir -p "$HOME/.local/bin"

echo "✅ Ubuntu 初期設定スクリプトを開始します..."
echo "-----------------------------------------"

# --- 1. システムの更新と必須パッケージのインストール ---
echo "▶️ システムの更新と基本パッケージのインストールを開始します..."

PACKAGES=("python3-venv" "git" "curl" "build-essential" "tmux" "bat" "ripgrep" "fd-find" "luarocks" "unzip")

if ! command -v apt &>/dev/null; then
	echo "❌ aptコマンドが見つかりません。Ubuntu以外のOSかもしれません。スクリプトを終了します。"
	exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt install -y "${PACKAGES[@]}"

# $HOME/.local/binにパスを通す
export PATH="$HOME/.local/bin:$PATH"

# fd-findを'fd'として使えるようにシンボリックリンクを作成
# if ! command -v fd &>/dev/null; then
# 	echo "  - fd-findをfdとして $HOME/.local/bin/ にリンクします。"
# 	ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
# fi

echo "✅ システムの更新と基本パッケージのインストールが完了しました。"

# --- 2. 開発ツールのインストール (Rust, Deno, Mise) ---
echo "▶️ 開発ツールのインストールを開始します..."

# Rustのインストール
if ! command -v rustc &>/dev/null; then
	echo "  - Rustをインストールします..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	# スクリプト内で即時利用できるように環境変数を設定
	# shellcheck source=/dev/null
	source "$HOME/.cargo/env"
	echo "  - Rust (rustup) のインストールが完了しました。"
fi

# Denoのインストール (curl経由)
if ! command -v deno &>/dev/null; then
	echo "  - Denoをインストールします..."
	curl -fsSL https://deno.land/install.sh | sh -s -- -y
	echo "" >>$HOME/.bashrc
	# スクリプト内で即時利用できるように環境変数を設定
	export PATH="$HOME/.deno/bin:$PATH"
	echo "  - Deno のインストールが完了しました。"
fi

# Mise (rtx) のインストール (curl経由)
if ! command -v mise &>/dev/null; then
	echo "  - Mise (rtx) をインストールします..."
	curl https://mise.run | sh
	# スクリプト内で即時利用できるように環境変数を設定
	# shellcheck source=/dev/null
	# source "$HOME/.local/share/mise/env"
	echo "  - Mise のインストールが完了しました。"
fi

echo "✅ 開発ツールのインストールが完了しました。"

# --- 3. Miseを使用したグローバルツールのインストール ---
echo "▶️ Miseを使用したNeovimとNode.jsのインストールを開始します..."
mise use -g neovim@latest
mise use -g node@24
mise use -g lazygit@latest
mise reshim # PATHを更新するために実行
echo "  - Mise環境を現在のシェルに即時反映します..."
eval "$(mise env -s bash)"
echo "  - 環境反映が完了しました。"
source ~/.bashrc
echo "✅ NeovimとNode.jsのインストールが完了しました。"

# --- 4. Neovimの追加設定 ---
echo "▶️ Neovimの追加設定を開始します..."

npm install -g neovim
npm install -g prettier

NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"
echo "  - $NVIM_CONFIG_DIR ディレクトリを作成しました。"

VENV_DIR="$NVIM_CONFIG_DIR/python-nvim"
python3 -m venv "$VENV_DIR"
echo "  - Python仮想環境を $VENV_DIR に作成しました。"

# pynvimを仮想環境にインストール
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"
pip install pynvim
deactivate
echo "  - pynvimを仮想環境にインストールしました。"

# --- 5. dotfilesのクローンとシンボリックリンクの作成 ---
echo "▶️ dotfilesのクローンと設定ファイルのリンクを開始します..."
DOTFILES_REPO="https://github.com/yosakax/dotfiles.git"
DOTFILES_PATH="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_PATH" ]; then
	git clone "$DOTFILES_REPO" "$DOTFILES_PATH"
	echo "  - dotfilesを $DOTFILES_PATH にクローンしました。"
else
	echo "  - $DOTFILES_PATH が既に存在するため、クローンをスキップします。"
fi

LN_TARGET="$NVIM_CONFIG_DIR/init.lua"
if [ -L "$LN_TARGET" ]; then
	echo "  - $LN_TARGET は既にリンクされているため、スキップします。"
elif [ -f "$LN_TARGET" ]; then
	echo "  - $LN_TARGET が既にファイルとして存在します。手動で確認してください。"
else
	# リンク元のパスを相対パスではなく、常にフルパスで指定
	ln -s "$DOTFILES_PATH/init.lua" "$LN_TARGET"
	ln -s "$DOTFILES_PATH/tmux.conf" "$HOME/.tmux.conf"
	echo "  - init.luaのシンボリックリンクを作成しました。"
fi

echo "✅ Neovimの追加設定とdotfilesの配置が完了しました。"

# --- 6. ~/.bashrc への環境パスの追加 (NEW) ---
echo "▶️ ~/.bashrc に環境設定を追加します..."

source $HOME/.bashrc
cargo install eza
cargo install erdtree

# 追記する設定ブロック
BASHRC_CONFIG=$(
	cat <<'EOF'
export PATH=$HOME/.local/bin:$PATH
alias tree="erd"
alias ls="eza --icons"
alias ll="eza --icons -alF" 
alias la="eza --icons -aF"
alias l="eza --icons -F"

# --- ツールインストールスクリプトによる追加設定 ---

# Rust (rustup) PATH の設定
# rustupがインストール時に生成する環境設定ファイルを読み込む
if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.cargo/env"
fi

# Deno PATH の設定
# Denoのバイナリパスを追加
export PATH="$HOME/.deno/bin:$PATH"

# Mise (rtx) 環境の設定
# Miseによって管理されるツールのPATHを適切に設定する (推奨される方法)
if command -v mise &> /dev/null; then
    eval "$(mise env -s bash)"
fi

# --- 追加設定 終了 ---
EOF
)

# 既に設定が追加されていないか確認 (Rustの設定ファイルをチェック)
if grep -q "# Rust (rustup) PATH の設定" "$HOME/.bashrc"; then
	echo "  - ~/.bashrc に環境設定は既に存在するため、追記をスキップします。"
else
	# ~/.bashrcの末尾に設定ブロックを追記
	echo "$BASHRC_CONFIG" >>"$HOME/.bashrc"
	echo "  - ~/.bashrc に新しい設定ブロックを追記しました。"
fi

echo "✅ ~/.bashrc への環境設定の追加が完了しました。"
echo "-----------------------------------------"
echo "🎉 すべての初期設定が完了しました！"
echo ""
echo "💡 設定を完全に反映させるため、新しいターミナルセッションを開始するか、以下のコマンドを実行してください。"
echo "   source ~/.bashrc"

