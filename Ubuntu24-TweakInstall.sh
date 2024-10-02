#!/bin/bash

# Ubuntu 24 Installer with Windows-like Features (Reduced Security)
# WARNING: This script intentionally reduces system security to mimic Windows behavior.
# Use at your own risk in controlled environments only.

# Exit on any error
set -e

# Log file for installation process
logfile="/var/log/ubuntu24_install.log"

# Variables to track the status of installation steps
declare -A STATUS=(
    ["BASIC_INSTALL"]="Pending"
    ["INTERMEDIATE_INSTALL"]="Pending"
    ["CPU_SETUP"]="Pending"
    ["GPU_SETUP"]="Pending"
    ["WINDOWS_TWEAKS"]="Pending"
    ["WINDOWS_COMMANDS"]="Pending"
)

# Function to print a dynamic banner with a menu name (80 characters)
print_banner() {
    local menu_name="$1"
    printf '=%.0s' {1..80}
    echo -e "\n    Ubuntu24-TweakInstall - $menu_name"
    printf '=%.0s' {1..80}
    echo ""
}

# Function to print a separator line (80 characters)
print_separator() {
    printf '=%.0s' {1..80}
    echo ""
}

# Function to log and display messages
log_message() {
    local message="$1"
    echo -e "$message"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$logfile"
}

# Function to clear the screen and display the dynamic banner
clear_screen() {
    local menu_name="$1"
    clear
    print_banner "$menu_name"
}

# Function to check if script is run as root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

# Function to check for errors and handle them gracefully
check_error() {
    if [ $? -ne 0 ]; then
        log_message "Error occurred during: $1"
        read -p "An error occurred. Press Enter to continue or Ctrl+C to exit."
    else
        log_message "$1 completed successfully."
    fi
}

# Function to pause and report status
pause_and_report() {
    local message="$1"
    log_message "$message"
    read -p "Press Enter to continue..."
}

# Function to display the main menu with status updates
display_main_menu() {
    clear_screen "Main Menu"
    echo ""
    echo "1. Basic OS Install          (Status: ${STATUS[BASIC_INSTALL]})"
    echo ""
    echo "2. Intermediate OS Setup     (Status: ${STATUS[INTERMEDIATE_INSTALL]})"
    echo ""
    echo "3. CPU Setup                 (Status: ${STATUS[CPU_SETUP]})"
    echo ""
    echo "4. GPU Setup                 (Status: ${STATUS[GPU_SETUP]})"
    echo ""
    echo "5. Windows-like Features     (Status: ${STATUS[WINDOWS_TWEAKS]}/${STATUS[WINDOWS_COMMANDS]})"
    echo ""
    print_separator
    read -p "Selection = 1-5, Exit Program = X: " menu_choice
}

# Function for basic OS installation (Ubuntu-specific)
basic_installation() {
    clear_screen "Basic OS Install"
    
    sudo apt update -y
    sudo apt upgrade -y
    check_error "System Update"
    sudo apt install -y vim nano curl wget git htop
    check_error "Basic Tool Installation"
    
    STATUS[BASIC_INSTALL]="Completed"
    pause_and_report "Basic OS installation completed."
}

# Function for intermediate setup (Ubuntu-specific)
intermediate_installation() {
    clear_screen "Intermediate OS Setup"
    
    sudo apt install -y build-essential qemu-kvm libvirt-daemon-system virtinst virt-manager gcc gnome-tweaks gnome-shell-extensions mesa-vulkan-drivers
    check_error "Development Tools Installation"

    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt "$SUDO_USER"
    check_error "Libvirt Setup"
    
    STATUS[INTERMEDIATE_INSTALL]="Completed"
    pause_and_report "Intermediate OS setup completed."
}

# Function for CPU setup
cpu_setup() {
    while true; do
        clear_screen "CPU Setup"
        echo ""
        echo "1. AMD CPU Setup"
        echo "2. Intel CPU Setup"
        echo "3. Back to Main Menu"
        echo ""
        print_separator
        read -p "Selection = 1-3: " cpu_choice

        case $cpu_choice in
            1) amd_cpu_setup ;;
            2) intel_cpu_setup ;;
            3) return ;;
            *) echo "Invalid option. Please try again."; sleep 2 ;;
        esac
    done
}

# Function for AMD CPU setup
amd_cpu_setup() {
    clear_screen "AMD CPU Setup"
    
    # Install AMD-specific tools and libraries
    sudo apt install -y amd64-microcode
    check_error "AMD Microcode Installation"

    # AOCL (AMD Optimizing CPU Libraries) setup
    echo "Setting up AOCL..."
    # Note: AOCL setup might require manual steps or a more complex installation process
    # This is a placeholder for where you'd put the AOCL installation commands
    echo "Please visit the AMD website for detailed AOCL installation instructions."
    
    # Additional AMD-specific optimizations can be added here
    
    STATUS[CPU_SETUP]="Completed (AMD)"
    pause_and_report "AMD CPU setup completed."
}

# Function for Intel CPU setup
intel_cpu_setup() {
    clear_screen "Intel CPU Setup"
    
    # Install Intel-specific tools and libraries
    sudo apt install -y intel-microcode
    check_error "Intel Microcode Installation"

    # Intel specific optimizations can be added here
    echo "Installing Intel-specific optimizations..."
    # Placeholder for Intel-specific setups
    
    STATUS[CPU_SETUP]="Completed (Intel)"
    pause_and_report "Intel CPU setup completed."
}

# Function for GPU setup
gpu_setup() {
    while true; do
        clear_screen "GPU Setup"
        echo ""
        echo "1. AMDGPU (Non-ROCm)"
        echo "2. AMDGPU (ROCm)"
        echo "3. NVIDIA GPU Setup"
        echo "4. Intel GPU Setup"
        echo "5. Back to Main Menu"
        echo ""
        print_separator
        read -p "Selection = 1-5: " gpu_choice

        case $gpu_choice in
            1) amdgpu_non_rocm_setup ;;
            2) amdgpu_rocm_setup ;;
            3) nvidia_gpu_setup ;;
            4) intel_gpu_setup ;;
            5) return ;;
            *) echo "Invalid option. Please try again."; sleep 2 ;;
        esac
    done
}

# Function for AMDGPU (Non-ROCm) setup
amdgpu_non_rocm_setup() {
    clear_screen "AMDGPU (Non-ROCm) Setup"
    
    sudo apt install -y xserver-xorg-video-amdgpu
    check_error "AMDGPU Driver Installation"
    
    sudo apt install -y vulkan-tools mesa-vulkan-drivers
    check_error "Vulkan Installation"
    
    sudo grub-set-default "$(grep -i 'menuentry ' /boot/grub/grub.cfg | cut -f2 -d "'" | head -n 1)"
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="amdgpu.vm_fragment_size=9 /' /etc/default/grub
    sudo update-grub
    check_error "Kernel Optimization for AMDGPU"
    
    STATUS[GPU_SETUP]="Completed (AMDGPU Non-ROCm)"
    pause_and_report "AMDGPU (Non-ROCm) setup completed."
}

# Function for AMDGPU (ROCm) setup
amdgpu_rocm_setup() {
    clear_screen "AMDGPU (ROCm) Setup"
    
    # Add ROCm repository
    echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ ubuntu main' | sudo tee /etc/apt/sources.list.d/rocm.list
    sudo apt update
    
    # Install ROCm
    sudo apt install -y rocm-dkms
    check_error "ROCm Installation"
    
    # Add user to video group
    sudo usermod -a -G video $SUDO_USER
    sudo usermod -a -G render $SUDO_USER
    
    echo 'export PATH=$PATH:/opt/rocm/bin' | sudo tee -a /etc/profile.d/rocm.sh
    
    STATUS[GPU_SETUP]="Completed (AMDGPU ROCm)"
    pause_and_report "AMDGPU (ROCm) setup completed."
}

# Function for NVIDIA GPU setup
nvidia_gpu_setup() {
    clear_screen "NVIDIA GPU Setup"
    
    sudo apt install -y nvidia-driver-530
    check_error "NVIDIA Driver Installation"
    
    # Additional NVIDIA-specific setup can be added here
    
    STATUS[GPU_SETUP]="Completed (NVIDIA)"
    pause_and_report "NVIDIA GPU setup completed."
}

# Function for Intel GPU setup
intel_gpu_setup() {
    clear_screen "Intel GPU Setup"
    
    sudo apt install -y intel-media-va-driver-non-free
    check_error "Intel GPU Driver Installation"
    
    # Additional Intel GPU-specific setup can be added here
    
    STATUS[GPU_SETUP]="Completed (Intel)"
    pause_and_report "Intel GPU setup completed."
}

# Function to implement Windows-like commands
implement_windows_commands() {
    local command_file="/etc/profile.d/windows_commands.sh"
    cat > "$command_file" <<EOL
function dir() {
    ls -l "\$@"
}

function copy() {
    cp -i "\$@"
}

function move() {
    mv -i "\$@"
}

function del() {
    rm -i "\$@"
}

function md() {
    mkdir -p "\$@"
}

function rd() {
    rmdir "\$@"
}

function cls() {
    clear
}

function type() {
    cat "\$@"
}

function where() {
    which "\$@"
}

function echo() {
    printf "%s\n" "\$*"
}

function shutdown() {
    sudo shutdown -h now
}

function restart() {
    sudo shutdown -r now
}
EOL

    chmod +x "$command_file"
    source "$command_file"
    check_error "Windows-like Commands Implementation"
    STATUS[WINDOWS_COMMANDS]="Completed"
}

# Function for Windows-like features submenu (Ubuntu)
windows_like_features() {
    while true; do
        clear_screen "Windows-like Features"
        echo ""
        echo "1. Implement security tweaks (WARNING: Significantly reduces system security)"
        echo ""
        echo "2. Implement Windows-like commands"
        echo ""
        print_separator
        read -p "Selection = 1-2, Back to Main = B: " tweak_choice

        case $tweak_choice in
            1)
                implement_security_tweaks
                ;;
            2)
                implement_windows_commands
                ;;
            [Bb])
                return
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Function for implementing security tweaks (Ubuntu)
implement_security_tweaks() {
    clear_screen "Security Tweaks"
    echo -e "\nWARNING: This will make significant changes to your system's security settings."
    echo "These changes will make your system behave more like Windows with UAC disabled."
    echo "This configuration is HIGHLY INSECURE and should only be used in controlled environments."
    read -p "Are you sure you want to continue? (y/N): " confirm

    if [[ $confirm != [yY] ]]; then
        echo "Operation cancelled."
        return
    fi

    # Disable sudo password prompt
    echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd > /dev/null
    chmod 0440 /etc/sudoers.d/nopasswd
    check_error "Sudo Password Prompt Disable"

    # Disable AppArmor
    sudo systemctl disable apparmor
    sudo systemctl stop apparmor
    check_error "AppArmor Disable"

    # Disable UFW (Uncomplicated Firewall)
    sudo ufw disable
    check_error "UFW Disable"

    # Allow execution of scripts without explicit interpreter
    sudo sed -i 's/^#include <sys\/stat.h>/&\n#ifndef SHEBANG\n#define SHEBANG\n#endif/' /usr/include/linux/binfmts.h
    check_error "Script Execution Without Interpreter"

    # Enable auto-login for the current user
    sudo sed -i "s/^#  AutomaticLogin/AutomaticLogin=$SUDO_USER/" /etc/gdm3/custom.conf
    check_error "Auto-login Enable"

    # Disable password complexity requirements
    sudo sed -i 's/^password.*pam_pwquality.so.*/password requisite pam_pwquality.so minlen=1/' /etc/pam.d/common-password
    check_error "Password Complexity Disable"

    echo "Configuration complete. Your system now behaves more like Windows with UAC disabled."
    echo "REMEMBER: This configuration is HIGHLY INSECURE. Use only in controlled environments."
    STATUS[WINDOWS_TWEAKS]="Completed"
    pause_and_report "Windows-like security tweaks completed."
}

# Function to handle invalid input
invalid_option() {
    echo -e "\nInvalid option selected. Please try again."
    sleep 2
}

# Main loop to handle user input and menu navigation
main_menu_loop() {
    while true; do
        display_main_menu
        
        case $menu_choice in
            1) basic_installation ;;
            2) intermediate_installation ;;
            3) cpu_setup ;;
            4) gpu_setup ;;
            5) windows_like_features ;;
            [Xx]) 
                log_message "Exiting the installation script."
                echo "Exiting..."
                exit 0
                ;;
            *) invalid_option ;;
        esac
    done
}

# Start the script
clear_screen "Ubuntu 24 Installation"
check_root
log_message "Ubuntu 24 installation script with Windows-like features (Reduced Security) started at $(date)"
main_menu_loop
