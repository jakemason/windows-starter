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
    install_with: str = "choco install"
    upgrade_with: str = "choco upgrade"
    message: str = ""
    priority: int = 1 # Lower gets installed first

# Create the desired directory for our tools
Path(TOOLS_DIRECTORY).mkdir(parents=True, exist_ok=True);

# List of tools to install
tools_to_install = [
  ToolToInstall(name="composer"),
  ToolToInstall(name="ctags"),
  ToolToInstall(name="fd"),
  ToolToInstall(name="ffmpeg"),
  ToolToInstall(name="fzf"),
  ToolToInstall(name="lazygit"),
  ToolToInstall(name="lua"),
  ToolToInstall(name="luarocks", priority=5),
  ToolToInstall(name="ninja"),
  ToolToInstall(name="nodejs.install"),
  ToolToInstall(name="php"),
  ToolToInstall(name="ripgrep"),
  ToolToInstall(name="sqlite"),
  ToolToInstall(name="vlc"),
  ToolToInstall(name="zig"),
  ToolToInstall(name="neovim"),
  ToolToInstall(name="neovide"),
  ToolToInstall(name="visualstudio2019community"),
  ToolToInstall(name="ruby"),
  ToolToInstall(name="windirstat"),
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
        print(f"{tool.message}")
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
