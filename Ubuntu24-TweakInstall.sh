#!/bin/bash

# Ubuntu 24 Installer with Windows-like Features
# WARNING: Some features in this script may reduce system security. Use with caution.

# Exit on any error
set -e

# Log file for installation process
logfile="/var/log/ubuntu24_install.log"

# Variables to track the status of installation steps
declare -A STATUS=(
    ["BASIC_INSTALL"]="Pending"
    ["INTERMEDIATE_INSTALL"]="Pending"
    ["AMDGPU_INSTALL"]="Pending"
    ["MULTI_GPU_INSTALL"]="Pending"
    ["WINDOWS_TWEAKS"]="Pending"
    ["WINDOWS_COMMANDS"]="Pending"
)

# Function to print a dynamic banner with a menu name
print_banner() {
    local menu_name="$1"
    printf '=%.0s' {1..80}
    echo -e "\n    Ubuntu24-TweakInstall - $menu_name"
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

# Function to display the main menu with status updates
display_main_menu() {
    clear_screen "Main Menu"
    echo "1. Basic OS Install          (Status: ${STATUS[BASIC_INSTALL]})"
    echo "2. Intermediate OS Setup     (Status: ${STATUS[INTERMEDIATE_INSTALL]})"
    echo "3. AMDGPU & AOCL Setup       (Status: ${STATUS[AMDGPU_INSTALL]})"
    echo "4. Multi-GPU Setup           (Status: ${STATUS[MULTI_GPU_INSTALL]})"
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
    
    pause_and_report "Intermediate OS setup completed."
}

# Function for AMDGPU and AOCL installation (Ubuntu-specific)
specialized_amdgpu_aocl_installation() {
    clear_screen "AMDGPU & AOCL Setup"
    
    sudo apt install -y xserver-xorg-video-amdgpu
    check_error "AMDGPU Driver Installation"
    
    echo "AOCL installation may require manual steps. Visit the AMD website for more information."
    
    sudo apt install -y vulkan-tools mesa-vulkan-drivers
    check_error "Vulkan Installation"
    
    sudo grubby --update-kernel=ALL --args="amdgpu.vm_fragment_size=9"
    check_error "Kernel Optimization for AMDGPU"
    
    pause_and_report "Specialized AMDGPU installation completed."
}

# Function for Multi-GPU setup (Ubuntu-specific)
setup_multi_gpu() {
    clear_screen "Multi-GPU Setup"
    
    sudo apt install -y nvidia-driver-530
    check_error "NVIDIA Driver Installation"
    
    lspci | grep -E "VGA|3D"
    check_error "GPU Detection"

    echo "Multi-GPU setup may require additional configuration based on your specific hardware."
    
    pause_and_report "Multi-GPU setup completed."
}

# Function to implement Windows-like commands (no changes needed)
implement_windows_commands() {
    local command_file="/etc/profile.d/windows_commands.sh"
    cat > "$command_file" <<EOL
function dir() { ... }
EOL

    chmod +x "$command_file"
    source "$command_file"
    check_error "Windows-like Commands Implementation"
}

# Function for Windows-like features submenu (Ubuntu)
windows_like_features() {
    while true; do
        clear_screen "Windows-like Features"
        echo "1. Implement security tweaks (WARNING: Reduces system security)"
        echo "2. Implement Windows-like commands"
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
    echo "These changes will make your system more vulnerable to security threats."
    read -p "Are you sure you want to continue? (y/N): " confirm

    if [[ $confirm != [yY] ]]; then
        echo "Operation cancelled."
        return
    fi

    create_mime_handler
    disable_auth_prompts

    echo "Configuration complete. Your system now behaves more like Windows in terms of script execution and authorization."
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
            3) specialized_amdgpu_aocl_installation ;;
            4) setup_multi_gpu ;;
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
log_message "Ubuntu 24 installation script with Windows-like features started at $(date)"
main_menu_loop

