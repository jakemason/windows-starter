# Overview

The combination of the PowerShell and Python scripts aim to remove crud added by Microsoft and install some of the tools I use on every machine. The PowerShell applies various registry changes to disable telemetry, remove unnecessary taskbar features like Chat and Widgets, revert to the classic context menu, enables dark mode, and improves privacy by disabling Cortana, Bing search suggestions, Windows Tips, and location tracking. The Python script automates the installation of essential development tools and utilities such as Lua, MSVC, Node.js, and others. This provides an improved starting point for working with Windows 11.

# Install

Open terminal as an admin then run:

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted; ./run_me_as_admin.ps1`

and wait for it to complete. It can take roughly 15 minutes depending on what applications
you want to install via `install_apps.py`

# Before & After

## Before

![Before](./repo/before.png)

## After

![After](./repo/after.png)
