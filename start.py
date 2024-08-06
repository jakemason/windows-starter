from pathlib import Path
from dataclasses import dataclass
import os
import subprocess

# remedybg

# Defining various things we may want to override via ENV
DRIVE = "C:";
PATH_SEPERATOR = "/";
TOOLS_DIRECTORY = DRIVE + PATH_SEPERATOR + "tools";

@dataclass
class ToolToInstall:
    name: str
    install_args: str = ""
    # scoop is the default install tool because it allows us to actually
    # pick where we want our tools to be installed
    install_with: str = "scoop install -g"
    upgrade_with: str = "scoop update -g"
    priority: int = 1 # Lower gets installed first

# Create the desired directory for our tools
Path(TOOLS_DIRECTORY).mkdir(parents=True, exist_ok=True);

# git has to be installed first in order to use "scoop bucket"
ToolToInstall(name="git")

command = f"scoop bucket add extras"
subprocess.run(command, shell=True, check=True)

command = f"scoop bucket add nonportable"
subprocess.run(command, shell=True, check=True)

command = f"scoop bucket add games"
subprocess.run(command, shell=True, check=True)

# List of tools to install
tools_to_install = [
  # Development / Tools
  ToolToInstall(name="7zip"),
  ToolToInstall(name="cmake"),
  ToolToInstall(name="composer"),
  ToolToInstall(name="ctags"),
  ToolToInstall(name="cyberduck"),
  ToolToInstall(name="everything"),
  ToolToInstall(name="fd"),
  ToolToInstall(name="ffmpeg"),
  ToolToInstall(name="fzf"),
  ToolToInstall(name="googlechrome"),
  ToolToInstall(name="lazygit", priority=5),
  ToolToInstall(name="lua"),
  ToolToInstall(name="luarocks", priority=5),
  ToolToInstall(name="neovide-nightly"),
  ToolToInstall(name="neovim"),
  ToolToInstall(name="ninja", priority=5),
  ToolToInstall(name="nodejs"),
  ToolToInstall(name="php"),
  ToolToInstall(name="postman"),
  ToolToInstall(name="ripgrep"),
  ToolToInstall(name="ruby"),
  ToolToInstall(name="sqlite"),
  ToolToInstall(name="streamdeck"),
  ToolToInstall(name="tableplus"),
  ToolToInstall(name="teracopy-np"),
  ToolToInstall(name="visualstudio2019community", install_with="choco install -y", upgrade_with="choco upgrade -y"),
  ToolToInstall(name="visualstudio2019buildtools", install_with="choco install -y", 
                        upgrade_with="choco upgrade -y",
                        install_args="--params \"--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.18362 --add Maicrosoft.VisualStudio.Component.Windows10SDK.19041 --includeRecommended --includeOptional\""),
  ToolToInstall(name="vlc"),
  ToolToInstall(name="windirstat"),
  ToolToInstall(name="windows-terminal"),
  ToolToInstall(name="wp-cli"),
  ToolToInstall(name="zig"),

  # Chat 
  ToolToInstall(name="discord"),
  ToolToInstall(name="signal"),
  ToolToInstall(name="slack"),
  ToolToInstall(name="zoom"),

  # Entertainment
  ToolToInstall(name="goggalaxy"),
  ToolToInstall(name="spotify"),
  ToolToInstall(name="steam"),
]

def is_tool_installed(tool_name):
    """Check if a tool is already installed."""
    try:
        result = subprocess.run(["where", tool_name], capture_output=True, text=True, check=True)
        return result.returncode == 0
    except subprocess.CalledProcessError:
        return False

def install_tool(tool):
    """Install a tool using the specified method."""
    if not is_tool_installed(tool.name):
        command = f"{tool.install_with} {tool.name} {tool.install_args}"
        subprocess.run(command, shell=True, check=True)
        print(f"{tool.name} has been installed.")
    else:
        print(f"Updating {tool.name}.")
        command = f"{tool.upgrade_with} {tool.name} {tool.install_args}"
        subprocess.run(command, shell=True, check=True)

# Sort tools by priority
tools_to_install.sort(key=lambda x: x.priority)

# Install each tool
for tool in tools_to_install:
    install_tool(tool)
