# Ubuntu 22-24 - Tweaks & Installer
- Installer Script Status: Beta (Early, but working).
- Tweaker Script Status: Alpha (Do not use, danger).

### Description:
This project became 2 tools, one for install and one for tweaking. The Installer saves time, researching and finding the correct commands, to do basic stuff after install of `Ubuntu 24.04`, ensuring system updates and installations, are printed and errors handled. The tweaker script focuses on implementing Windows-like features and other tweaks, including the addition of Windows-like common commands to go along side the relating common linux commands, but also significantly reducing system security for home where reduced password security is acceptable.

### Features:
- Basic OS installation includes system updates and essential tools like vim, nano, curl, wget, git, and htop. (Installer)
- Intermediate OS setup installs development tools, QEMU, libvirt, GCC, GNOME tweaks, and Vulkan drivers. (Installer)
- Wine libraries for better, audio, graphics, USB device, Linux integration with X11, multimedia formats, font rendering, and image formats.
- CPU setup offers options for AMD and Intel CPU-specific tools and optimizations. (Installer)
- GPU setup provides options for AMDGPU (Non-ROCm and ROCm), NVIDIA, and Intel GPU drivers and optimizations. (Installer)
- The main menu dynamically updates with the status of each installation step. (Both)
- Option to implement Windows-like commands such as dir, copy, move, del, md, rd, cls, type, where, echo, shutdown, and restart. (Tweaker)
- Option for disable sudo password prompts, AppArmor, and password complexity requirements to mimic Windows Disable, `UAC` and `Software Protection`, type actions. (Tweaker)
- Windows-like features include adding basic Windows-like commands to the terminal, `cd..`, `dir`, etc. (Tweaker)

### Preview:
- The `Main Menu` for the `Installer`...
```
================================================================================
    Ubuntu-PostInstall-Setup - Main Menu
================================================================================


    1. Action - Basic, Update and Install, of Packages

    2. Submenu - Software, Virtualization, Wine, Python

    3. Submenu - CPU-Specific Optimization and Drivers

    4. Submenu - GPU-Specific Optimization and Drivers


================================================================================
Selection = 1-4, Exit Program = X: 

```
- The `Main Menu` for the `Tweaker`...
```
================================================================================
    Ubuntu24-Windows-like Features - Main Menu
================================================================================

    1. Disable sudo password prompt (SUDO_NOPASSWD)          (Status: Enabled)

    2. Disable AppArmor (APPARMOR)                           (Status: Enabled)

    3. Disable UFW (Uncomplicated Firewall) (UFW)            (Status: Enabled)

    4. Enable auto-login (AUTO_LOGIN)                        (Status: Disabled)

    5. Implement Windows-like commands (WINDOWS_COMMANDS)    (Status: Enabled)

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
2) As required, then make the file executable with the  `chmod +x Ubuntu24-TweakInstall.sh`, then run either, `sudo ./Ubuntu24-Installer.sh` or `sudo ./Ubuntu24-Tweaker.sh`.
3) Investigate the appropriate menus, take a look at what it offers, plan what features you intend to use, and select them (ensuring to note errors that pop up).
4) Restart computer, to enable all tweaks/installs to take effect. 
5) If there are issues with anything immediately, then check the notes you made (if any), and investigate appropriately to complete relating install/tweak.
5) Move on to next stage, whatever you determine to be of interest, probal, App Center/Software Manager; At this point any new issues are your own doing.

### Notation:
- Minimum Windows 10 for Vertio/Kvm/QEmu Drivers from `Virtio-Win-0.1.262.Iso`, Windows 7-81 did not complete Setup.  
- For `Ubuntu 24.04` Assistance, go for example, here `https://chatgpt.com/g/g-sQSBQqeR8-sysadmin-for-ubuntu-22-04` or here `https://chatgpt.com/g/g-OPkIvf0HN-java-21-postgresql-16`, and prompt mentioning your version is 24.04. 
- Would make a better GPT for 24, but people also need to, go fund me or patreon, to assist in paying gpt subscription to do so again..
- Its for 24, because thats the version I was using at the time, this may later expand like 22-24 or there will be new version ie Ubuntu26-TweakInstall.
- I was unable to install `24.04.x`, so I installed `22.04 LTS` then upgraded to `24.04.1 LTS`, other people also had issues installing on nvme, `24.10 Beta` did not have these issues, but was beta. 
- Its a continuation of the `Fedora40-TweakInstall` project, `Ubuntu24-TweakInstall` is more safer/complete. `Fedora40-TweakInstall` is hidden due to untested tweaks, that require inspection/fixing/testing, which wont happen unless I reinstall Fedora.
- Windows Commands in the terminal are (dont expect them to all work perfect, fixing/improving is done here `/etc/profile.d/windows_commands.sh`)...
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
- Immediate work...
1. Remove opensnitch (did not work).
2. Remove Apparmor (dangerous).
- Required updates I have noticed from use...
1. `Start + e` :- Go to `Settings>Keyboard>Add Custom`, then type in `nautilus` for the command, and put `Start + e` in the Shortcut, and give it a fitting title like `Explorer Shortcut`. NEed to add this and other tweaks for keyboard shortcuts from windows.
2. The, prompts and menus, need to be conformed towards my current standards of format found in other recent programs.
3. The windows commands do not include `copy`. Possibly install of them introduces screen garbage in the title...
```
================================================================================
-e \n    Ubuntu24-Windows-like Features - Main Menu
================================================================================
```
- The Individual `VM` related install seems odd now, needs to be made into Modular submenu again. `LLM` option had to be removed, error with build-tools was it? But still, LLM was a bad choice, because people will want custom Torch version possibly. Maybe Just expand out the options for the VM setup, so as to include different VM modules.

### Warnings:
- Tweaker = Experimental (use at own risk). Alike the Installer, you are NOT intended to just use ALL of the features, but more so, be selective, and backup before hand, I am postponing further development untill I have a bootable hd cloner working. For now I would keep the tweaker open, and ensure you can still run for example `Firefox`, just to make sure new complex processes can still run, and then if they dont, then you will be able to un-do the relating tweaks, and try again. Again the "Tweaker" script is extremely experimental, so I advise first trying them out on a VM of the OS you intend to use them on. Or just dont use the tweaker for now.
- If there is some issue with a device, after restarting, after using the Installer, then try re-starting again, this fixed itself for me, but I had a blank screen on one of the monitors, its an iffy old monitor prone to issues though.
