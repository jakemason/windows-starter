from pathlib import Path
from dataclasses import dataclass

# Tools I want to install
# Lua
# MSVC
# lazygit
# nodejs
# npm
# riggrep
# ffmpeg
# fd
# fzf
# luarocks
# php
# pip
# sqlite
# rbenv
# zig
# zstd
# ctags
# composer
# vlc
# remedybg
# ninja
# neovim
# neovide

# Defining various things we may want to override via ENV
DRIVE = "C:";
PATH_SEPERATOR = "/";
TOOLS_DIRECTORY = DRIVE + PATH_SEPERATOR + "tools";

@dataclass
class ToolToInstall:
    name: str
    install_args: str
    install_with: str = "choco install"
    priority: int = 1 # Lower gets installed first

# Create the desired directory for our tools
Path(TOOLS_DIRECTORY).mkdir(parents=True, exist_ok=True);
