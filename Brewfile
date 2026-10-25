# Brewfile — このマシンに入っている Homebrew パッケージのスナップショット。
#
# 手書きしない。tap / brew / cask / vscode の各行は `brew bundle dump` の生成物。
# 何が入っているかの記録であり、install.sh（シンボリックリンク）とは無関係。
#
# node のグローバルパッケージはここに入らない（volta 管理で npm ls -g に出ないため）。
# そちらは volta.txt が持つ。
#
# 復元:   brew bundle install --file=~/dotfiles/Brewfile
# 差分:   brew bundle check --file=~/dotfiles/Brewfile --verbose
# 再生成: 下の1行（先頭のこのコメント群を残したまま中身だけ入れ替える）
#   { awk '/^#|^$/{print;next}{exit}' ~/dotfiles/Brewfile; brew bundle dump --file=- --no-npm; } > ~/dotfiles/Brewfile.new && mv ~/dotfiles/Brewfile.new ~/dotfiles/Brewfile
#
# 詳細は docs/brew/brewfile.md。

tap "adoptopenjdk/openjdk"
tap "anthropics/tap"
tap "carlocab/personal"
tap "homebrew/services"
tap "ngrok/ngrok"
tap "oven-sh/bun"
# C parser in Python
brew "pycparser"
# C Foreign Function Interface for Python
brew "cffi"
# General-purpose scripting language
brew "php"
# Dependency Manager for PHP
brew "composer"
# Secure runtime for JavaScript and TypeScript
brew "deno"
# Embeddable SQL OLAP Database Management System
brew "duckdb"
# Lean Theorem Prover installer and version manager
brew "elan-init"
# Simple, fast and user-friendly alternative to find
brew "fd"
# Play, record, convert, and stream select audio and video codecs
brew "ffmpeg"
# GitHub command-line tool
brew "gh"
# Installer for the general purpose language Haskell
brew "ghcup"
# Distributed revision control system
brew "git"
# Render markdown on the CLI
brew "glow"
# Agent multiplexer that lives in your terminal
brew "herdr"
# Command-line note taker
brew "jrnl"
# MIT/GNU Scheme development tools and runtime library
brew "mit-scheme"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Create, run, and share large language models (LLMs)
brew "ollama"
# PDF rendering library (based on the xpdf-3.0 code base)
brew "poppler"
# Object-relational database system
brew "postgresql@14"
# Python version management
brew "pyenv"
# Pyenv plugin to manage virtualenv
brew "pyenv-virtualenv"
# Interpreted, interactive, object-oriented programming language
brew "python@3.11"
# Perl-powered file rename script with many helpful built-ins
brew "rename"
# Rust toolchain installer
brew "rustup"
# Steel Bank Common Lisp system
brew "sbcl"
# Tools for market analysis
brew "ta-lib"
# Tool to build, change, and version infrastructure
brew "terraform"
# Terminal multiplexer
brew "tmux"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Pretty print math in monospace fonts, using a TeX-like syntax
brew "utftex"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"
# Vi 'workalike' with many additional features
brew "vim"
# Tool for creating isolated virtual python environments
brew "virtualenv"
# JavaScript toolchain manager for reproducible environments
brew "volta"
# Internet file retriever
brew "wget"
# CLI for the Claude Platform
cask "anthropics/tap/ant", trusted: true
# Terminal-based AI coding assistant
cask "claude-code"
# OpenAI's coding agent that runs in your terminal
cask "codex"
# Plain-text editor for web pages, program source codes and more
cask "coteditor"
# GNU Emacs text editor
cask "emacs-app"
cask "font-hackgen"
cask "font-hackgen-nerd"
# Terminal emulator that uses platform-native UI and GPU acceleration
cask "ghostty"
# Client for the Google Drive storage service
cask "google-drive"
# Terminal built on web technologies
cask "hyper"
# Full TeX Live distribution with GUI applications
cask "mactex"
# Open-source software for live streaming and screen recording
cask "obs"
# Knowledge base that works on top of a local folder of plain text Markdown files
cask "obsidian"
# Kubernetes and container management on the desktop
cask "rancher"
# Control your tools with a few keystrokes
cask "raycast"
# Customizable email client
cask "thunderbird"
# Open-source code editor
cask "visual-studio-code"
# Multimedia player
cask "vlc"
# GPU-accelerated cross-platform terminal emulator and multiplexer
cask "wezterm"
# Video communication and virtual meeting platform
cask "zoom"
vscode "anthropic.claude-code"
vscode "hashicorp.terraform"
vscode "liviuschera.noctis"
vscode "marp-team.marp-vscode"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ritwickdey.liveserver"
vscode "svelte.svelte-vscode"
vscode "yzane.markdown-pdf"
uv "harlequin"
