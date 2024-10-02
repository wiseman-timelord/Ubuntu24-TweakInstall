# Ubuntu24-TweakInstall
Repository still being Setup...
Its my tweaks for Ubuntu, likely themed towards tuning it towards being windows-user friendly.

### OLD DESCRIPTION FROM FEDORA40-TWEAKINSTALL BELOW...
### Description:
In transitioning to Fedora, there were some things I noticed, that could be done differently, to make it more user-friendly for life-long windows users, that are somewhat old-dogs/grumpy-goatslike myself. 

### Features:
- provides an interactive menu-driven installer for Fedora 40, guiding users through basic OS installation, intermediate setup, AMDGPU and AOCL configuration, and multi-GPU setup, while logging the process and providing status updates for each step.
- Configures a Fedora system to behave more like Windows by disabling security features, creating a MIME handler for shell scripts, and removing authorization prompts, significantly reducing system security and potentially exposing the system to serious vulnerabilities.
- Enables basic msdos commands in the terminal, that then shortcut to actual terminal commands, for convinience, so as for basic commands like, `cd..` or `dir`, to do equivalent things in the Terminal.

### Preview:
- The Main Menu...
```
================================================================================
    Fedora 40 Installer with Windows-like Features
================================================================================

    Main Menu:

1. Basic OS Install          (Status: Pending)
2. Intermediate OS Setup     (Status: Pending)
3. AMDGPU & AOCL Setup       (Status: Pending)
4. Multi-GPU Setup           (Status: Pending)
5. Windows-like Features     (Status: Pending/Pending)

================================================================================
Select an option (1-5 or X to exit): _
```

### INSTRUCTIONS:
1) download and copy file `Fedora40-TweakInstall.sh` to a suitable directory.
2) As required, then make the file executable with the  `chmod +x Fedora40-TweakInstall.sh`, then run `./Fedora40-TweakInstall.sh`.
3) Investigate the menu, take a look at what it offers, plan what features you intend to use, and select them, ensuring to note any errors in notepad, but if the errors are of no relating interest to you, then just ignore and carry on.
4) Investigate completion of the given errors that were of interest to you in a, GPT or claude, session, ensuring to mention your, basic hardware config and fedora version, at the start. 
5) Restart computer, to enable all tweaks/installs to take effect.

### Notation:
- `Start + e` :- Go to `Settings>Keyboard>Add Custom`, then type in `nautilus` for the command, and put `Start + e` in the Shortcut, and give it a fitting title like `Explorer Shortcut`. 
- I am unable to test the final product as now on Ubuntu, hence my `Ubuntu24-TweakInstall` project, but, if `Fedora40-TweakInstall` does not work, and you, can fix it and feel inspired, then feel free to upload to a fork.

### Warning:
Development was stopped, due continuing sound issues on fedora 40, through multiple, claude and gpt, assisted sessions to fix the sound, and during the proces GPT said basically `the KVM abilities of Fedora 40 are the same as in Ubuntu`, hence I installed Ubuntu 24.10 beta instead. After using all the tweaks/installs on Fedora40, I then merges all the scripts and instructions into one script, ready for conversion to `Ubuntu 24.10` compatibility, and thats where the project is now heading. The current implementation available for download is UN-TESTED, but basically the same but merged version of the known working version, and has been checked over by claude sonnet after creation, so use at your own risk and asses output for errors.
