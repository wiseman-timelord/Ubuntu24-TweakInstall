# Ubuntu24-TweakInstall
Status: Extremely Experimental AND Un-Tested.

### Description:
In transitioning to Ubuntu, there were some things I noticed, that could be done differently, to make it more user-friendly for life-long windows users, that are somewhat old-dogs/grumpy-goats, like am I. 

### Features:
- Basic OS installation includes system updates and essential tools like vim, nano, curl, wget, git, and htop.
- Intermediate OS setup installs development tools, QEMU, libvirt, GCC, GNOME tweaks, and Vulkan drivers.
- CPU setup offers options for AMD and Intel CPU-specific tools and optimizations.
- GPU setup provides options for AMDGPU (Non-ROCm and ROCm), NVIDIA, and Intel GPU drivers and optimizations.
- Windows-like features include adding basic Windows-like commands to the terminal, `cd..`, `dir`, etc.
- The main menu dynamically updates with the status of each installation step.
- The script includes a function to implement Windows-like commands such as dir, copy, move, del, md, rd, cls, type, where, echo, shutdown, and restart.
- The script has option for disable sudo password prompts, AppArmor, and password complexity requirements to mimic Windows Disable, `UAC` and `Software Protection`, type actions.

### Preview:
- The `Main Menu` interface...
```
================================================================================
    Ubuntu24-TweakInstall - Main Menu
================================================================================

1. Basic OS Install          (Status: Pending)

2. Intermediate OS Setup     (Status: Pending)

3. CPU Setup                 (Status: Pending)

4. GPU Setup                 (Status: Pending)

5. Windows-like Features     (Status: Pending/Pending)

================================================================================
Selection = 1-5, Exit Program = X: 

```
- The example option execution output, in this case `Basic OS Install`...
```
================================================================================
    Ubuntu24-TweakInstall - Basic OS Install
================================================================================
Get:1 http://archive.ubuntu.com/ubuntu oracular InRelease [126 kB]
Hit:2 http://security.ubuntu.com/ubuntu oracular-security InRelease            
Hit:3 https://ppa.launchpadcontent.net/graphics-drivers/ppa/ubuntu oracular InRelease
Hit:4 http://archive.ubuntu.com/ubuntu oracular-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu oracular-backports InRelease
Get:6 http://archive.ubuntu.com/ubuntu oracular/main amd64 Packages [1,438 kB]
Get:7 http://archive.ubuntu.com/ubuntu oracular/main amd64 c-n-f Metadata [31.2 kB]
...

...
update-alternatives: using /usr/bin/vim.basic to provide /usr/bin/vim (vim) in a
uto mode
update-alternatives: using /usr/bin/vim.basic to provide /usr/bin/vimdiff (vimdi
ff) in auto mode
Setting up git (1:2.45.2-1ubuntu1) ...
Processing triggers for hicolor-icon-theme (0.18-1) ...
Processing triggers for gnome-menus (3.36.0-1.1ubuntu3) ...
Processing triggers for man-db (2.12.1-3) ...
Processing triggers for desktop-file-utils (0.27-2build1) ...
Basic Tool Installation completed successfully.
Basic OS installation completed.
Press Enter to continue...
```

### INSTRUCTIONS:
1) download and copy file `Ubuntu24-TweakInstall.sh` to a suitable directory.
2) As required, then make the file executable with the  `chmod +x Ubuntu24-TweakInstall.sh`, then run `./Fedora40-TweakInstall.sh`.
3) Investigate the menu, take a look at what it offers, plan what features you intend to use, and select them (ensuring to note errors that pop up).
4) Restart computer, to enable all tweaks/installs to take effect. 
5) If there are issues with anything immediately, then check the notes you made (if any), and investigate appropriately to complete relating install/tweak.
5) Move on to next stage, whatever you determine to be of interest, probal, App Center/Software Manager; At this point any new issues are your own doing.

### Notation:
- `Intermediate OS Setup` includes things like, `KVM` for Machine Emulation and `LLM` things for Model Interference, if you dont need that, then dont use the option.
- `Start + e` :- Go to `Settings>Keyboard>Add Custom`, then type in `nautilus` for the command, and put `Start + e` in the Shortcut, and give it a fitting title like `Explorer Shortcut`. 
- Its a continuation of the `Fedora40-TweakInstall` project in my other repository; `Ubuntu24-TweakInstall` will be somewhat, better/safer and more complete/advanced.
- Windows Commands in the terminal are (dont expect them to all work perfect, fixing is done here `/etc/profile.d/windows_commands.sh`)...
```
`dir` - Lists directory contents in a detailed format.
`copy` - Copies files and directories.
`move` - Moves files and directories.
`del` - Deletes files and directories.
`md` - Creates directories.
`rd` - Removes directories.
`cls` - Clears the terminal screen.
`type` - Displays the contents of a file.
`where` - Locates the binary, source, or manual page files for a command.
`echo` - Prints text to the terminal.
`shutdown` - Shuts down the system.
`restart` - Restarts the system.
```

### Development 
Required updates I have noticed from use...
- The prompts need to be conformed towards my current standards of format found in other recent programs.
- The windows commands do not include `copy`. Possibly install of them introduces screen garbage in the title.

### Warning:
Development was stopped, due continuing sound issues on fedora 40, through multiple, claude and gpt, assisted sessions to fix the sound, and during the proces GPT said basically `the KVM abilities of Fedora 40 are the same as in Ubuntu`, hence I installed Ubuntu 24.10 beta instead. After using all the tweaks/installs on Fedora40, I then merges all the scripts and instructions into one script, ready for conversion to `Ubuntu 24.10` compatibility, and thats where the project is now heading. The current implementation available for download is UN-TESTED, but basically the same but merged version of the known working version, and has been checked over by claude sonnet after creation, so use at your own risk and asses output for errors.
