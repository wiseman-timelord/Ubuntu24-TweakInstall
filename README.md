# Ubuntu24-TweakInstall
Status: Extremely Experimental AND Un-Tested.

### Description:
In transitioning to Ubuntu, there were some things I noticed, that could be done differently, to make it more user-friendly for life-long windows users, that are somewhat old-dogs/grumpy-goats, like am I (Its a continuation of the `Fedora40-TweakInstall` project). 

### Features:
- Basic OS installation includes system updates and essential tools like vim, nano, curl, wget, git, and htop.
- Intermediate OS setup installs development tools, QEMU, libvirt, GCC, GNOME tweaks, and Vulkan drivers.
- CPU setup offers options for AMD and Intel CPU-specific tools and optimizations.
- GPU setup provides options for AMDGPU (Non-ROCm and ROCm), NVIDIA, and Intel GPU drivers and optimizations.
- Windows-like features include adding basic Windows-like commands to the terminal, `cd..`, `copy`, `dir`, etc.
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

### INSTRUCTIONS:
1) download and copy file `Ubuntu24-TweakInstall.sh` to a suitable directory.
2) As required, then make the file executable with the  `chmod +x Ubuntu24-TweakInstall.sh`, then run `./Fedora40-TweakInstall.sh`.
3) Investigate the menu, take a look at what it offers, plan what features you intend to use, and select them (ensuring to note errors that pop up).
4) Restart computer, to enable all tweaks/installs to take effect.
5) Move on to next stage, whatever you determine to be of interest. After this point any new issues that develop with the OS are your own doing, but if there are issues with anything immediately, then check the notes, and investigate completion of the relating errors that are of relevance, hence you will have a head-start in investigating relevant updates requried to complete relating install/tweak.

### Notation:
- `Start + e` :- Go to `Settings>Keyboard>Add Custom`, then type in `nautilus` for the command, and put `Start + e` in the Shortcut, and give it a fitting title like `Explorer Shortcut`. 
- I am unable to test the final product as now on Ubuntu, hence my `Ubuntu24-TweakInstall` project, but, if `Fedora40-TweakInstall` does not work, and you, can fix it and feel inspired, then feel free to upload to a fork.

### Warning:
Development was stopped, due continuing sound issues on fedora 40, through multiple, claude and gpt, assisted sessions to fix the sound, and during the proces GPT said basically `the KVM abilities of Fedora 40 are the same as in Ubuntu`, hence I installed Ubuntu 24.10 beta instead. After using all the tweaks/installs on Fedora40, I then merges all the scripts and instructions into one script, ready for conversion to `Ubuntu 24.10` compatibility, and thats where the project is now heading. The current implementation available for download is UN-TESTED, but basically the same but merged version of the known working version, and has been checked over by claude sonnet after creation, so use at your own risk and asses output for errors.
