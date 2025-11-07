#!/bin/bash

set -euxo pipefail

# .local を含めてオーナー変更
sudo install -d -o vscode -g vscode ~/.claude

mise settings add idiomatic_version_file_enable_tools ruby
mise settings add idiomatic_version_file_enable_tools node
mise trust

#*** Claude Code auth persistence
# https://zenn.dev/nstock/articles/2c1ea72861f87c
mkdir -p ~/.claude
[ -f ~/.claude/.config.json ] || echo '{}' > ~/.claude/.config.json

#*** Install bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent

#*** Install latest ruby version
# # 1) Gemfile の ruby 制約から上限を取り出し、1 つ下の系列(= 3.3 など)を求める
# line=$(grep -E "^ruby " Gemfile)
# upper=$(echo "$line" | sed -n "s/.*'< *\([^']*\)'.*/\1/p")   # 例: 3.4.0
# maj=$(echo "$upper" | cut -d. -f1)                            # 3
# min=$(echo "$upper" | cut -d. -f2)                            # 4
# series="${maj}.$((min-1))"                                    # 3.3

# # 2) その系列で利用可能なバージョンを確認（任意・デバッグ用）
# mise ls-remote ruby@"$series" | tail -n +1

# # 3) インストール（3.3 系の最新パッチが入る）
# mise install "ruby@${series}"

# # 4) プロジェクトローカル設定に反映（.tool-versions / mise.toml に記録）
# mise use "ruby@${series}"

# #*** Install Node.js
# mise use node@latest

#*** Install codex
mise install npm:@openai/codex
mise use -g npm:@openai/codex

#*** Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash
