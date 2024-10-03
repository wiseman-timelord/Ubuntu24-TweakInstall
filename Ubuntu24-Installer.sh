#!/bin/bash

# Ubuntu Post-Install Setup Script

# Initialization
set -e

# Variables
logfile="/var/log/ubuntu_post_install.log"

# Maps/Lists
declare -A STATUS=(
    ["BASIC_INSTALL"]="Pending"
    ["SOFTWARE_MANAGERS"]="Pending"
    ["CPU_SETUP"]="Pending"
    ["GPU_SETUP"]="Pending"
)

# Function to print a dynamic banner with a menu name (80 characters)
print_banner() {
    local menu_name="$1"
    printf '=%.0s' {1..80}
    echo -e "\n    Ubuntu-PostInstall-Setup - $menu_name"
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
        echo "An error occurred during $1. Check the log file at $logfile for details."
        read -p "Press Enter to continue or Ctrl+C to exit."
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

# Main Menu with its own input handler
display_main_menu() {
    while true; do
        clear_screen "Main Menu"
        echo ""
        echo "1. Setup-Install Basic Requirements          (Status: ${STATUS[BASIC_INSTALL]})"
        echo ""
        echo "2. Setup-Install Software Managers           (Status: ${STATUS[SOFTWARE_MANAGERS]})"
        echo ""
        echo "3. CPU Setup                                (Status: ${STATUS[CPU_SETUP]})"
        echo ""
        echo "4. GPU Setup                                (Status: ${STATUS[GPU_SETUP]})"
        echo ""
        print_separator
        read -p "Selection = 1-4, Exit Program = X: " menu_choice

        case $menu_choice in
            1) basic_installation ;;
            2) setup_software_managers_menu ;;
            3) cpu_setup ;;
            4) gpu_setup ;;
            [Xx]) 
                log_message "Exiting the installation script."
                echo "Exiting..."
                exit 0
                ;;
            *) invalid_option ;;
        esac
    done
}

# Function for Software Manager Setup Menu with its own input handler
setup_software_managers_menu() {
    while true; do
        clear_screen "Setup-Install Software Managers"
        echo ""
        echo "1. Install Gnome Software Manager"
        echo ""
        echo "2. Install Synaptic Package Manager"
        echo ""
        echo "3. Enable Snap Applications/Packages"
        echo ""
        print_separator
        read -p "Selection; Menu Options = 1-3, Back to Main = B: " software_choice

        case $software_choice in
            1) install_gnome_software_manager ;;
            2) install_synaptic_package_manager ;;
            3) enable_snap_packages ;;
            [Bb]) 
                if [ "${STATUS[SOFTWARE_MANAGERS]}" == "Pending" ]; then
                    STATUS[SOFTWARE_MANAGERS]="Partially Completed"
                fi
                return ;;
            *) echo "Invalid option. Please try again."; sleep 2 ;;
        esac
    done
}

# Function for CPU setup with its own input handler
cpu_setup() {
    while true; do
        clear_screen "CPU Setup"
        echo ""
        echo "1. AMD CPU Setup"
        echo ""
        echo "2. Intel CPU Setup"
        echo ""
        print_separator
        read -p "Selection; Menu Options = 1-2, Back to Main = B: " cpu_choice

        case $cpu_choice in
            1) amd_cpu_setup ;;
            2) intel_cpu_setup ;;
            [Bb]) return ;;
            *) echo "Invalid option. Please try again."; sleep 2 ;;
        esac
    done
}

# Function for GPU setup with its own input handler
gpu_setup() {
    while true; do
        clear_screen "GPU Setup"
        echo ""
        echo "1. AMDGPU (Non-ROCm)"
        echo "" 
        echo "2. AMDGPU (ROCm)"
        echo ""
        echo "3. NVIDIA GPU Setup"
        echo ""
        echo "4. Intel GPU Setup"
        echo ""
        print_separator
        read -p "Selection; Menu Options = 1-4, Back to Main = B: " gpu_choice

        case $gpu_choice in
            1) amdgpu_non_rocm_setup ;;
            2) amdgpu_rocm_setup ;;
            3) nvidia_gpu_setup ;;
            4) intel_gpu_setup ;;
            [Bb]) return ;;
            *) echo "Invalid option. Please try again."; sleep 2 ;;
        esac
    done
}

# Function for basic OS installation (Ubuntu-specific)
basic_installation() {
    clear_screen "Setup-Install Basic Requirements"
    
    sudo apt update -y
    sudo apt upgrade -y --fix-missing
    check_error "System Update"
    sudo apt install -y vim nano curl wget git htop
    check_error "Basic Tool Installation"
    
    STATUS[BASIC_INSTALL]="Completed"
    pause_and_report "Basic OS installation completed."
}

# Function to install Gnome Software Manager
install_gnome_software_manager() {
    clear_screen "Installing Gnome Software Manager"
    
    sudo apt update
    sudo apt install -y gnome-software
    check_error "Gnome Software Manager Installation"
    
    STATUS[SOFTWARE_MANAGERS]="Completed"
    pause_and_report "Gnome Software Manager installation completed."
}

# Function to install Synaptic Package Manager
install_synaptic_package_manager() {
    clear_screen "Installing Synaptic Package Manager"
    
    sudo apt update
    sudo apt install -y synaptic
    check_error "Synaptic Package Manager Installation"
    
    STATUS[SOFTWARE_MANAGERS]="Completed"
    pause_and_report "Synaptic Package Manager installation completed."
}

# Function to enable Snap applications
enable_snap_packages() {
    clear_screen "Enabling Snap Applications/Packages"
    
    sudo apt update
    sudo apt install -y snapd
    check_error "Snap Installation"
    
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
    check_error "Snap Daemon Setup"
    
    STATUS[SOFTWARE_MANAGERS]="Completed"
    pause_and_report "Snap applications enabled and Snap Daemon configured."
}

# Function for AMD CPU setup
amd_cpu_setup() {
    clear_screen "AMD CPU Setup"
    
    sudo apt install -y amd64-microcode
    check_error "AMD Microcode Installation"

    echo "Setting up AOCL..."
    echo "Please visit the AMD website for detailed AOCL installation instructions."
    
    STATUS[CPU_SETUP]="Completed (AMD)"
    pause_and_report "AMD CPU setup completed."
}

# Function for Intel CPU setup
intel_cpu_setup() {
    clear_screen "Intel CPU Setup"
    
    sudo apt install -y intel-microcode
    check_error "Intel Microcode Installation"

    STATUS[CPU_SETUP]="Completed (Intel)"
    pause_and_report "Intel CPU setup completed."
}

# Function for AMDGPU (Non-ROCm) setup
amdgpu_non_rocm_setup() {
    clear_screen "AMDGPU (Non-ROCm) Setup"
    
    sudo apt install -y xserver-xorg-video-amdgpu
    check_error "AMDGPU Driver Installation"
    
    sudo apt install -y vulkan-tools mesa-vulkan-drivers
    check_error "Vulkan Installation"
    
    read -p "Do you want to optimize kernel parameters for AMDGPU? (y/n): " optimize
    if [[ $optimize == "y" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="amdgpu.vm_fragment_size=9 /' /etc/default/grub
        sudo update-grub
        check_error "Kernel Optimization for AMDGPU"
    fi
    
    STATUS[GPU_SETUP]="Completed (AMDGPU Non-ROCm)"
    pause_and_report "AMDGPU (Non-ROCm) setup completed."
}

# Function for AMDGPU (ROCm) setup
amdgpu_rocm_setup() {
    clear_screen "AMDGPU (ROCm) Setup"
    
    # Add ROCm repository (using Ubuntu-specific repo)
    echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ ubuntu main' | sudo tee /etc/apt/sources.list.d/rocm.list
    sudo apt update
    
    sudo apt install -y rocm-dkms
    check_error "ROCm Installation"
    
    sudo usermod -a -G video $SUDO_USER
    sudo usermod -a -G render $SUDO_USER
    
    echo 'export PATH=$PATH:/opt/rocm/bin' | sudo tee -a /etc/profile.d/rocm.sh
    
    STATUS[GPU_SETUP]="Completed (AMDGPU ROCm)"
    pause_and_report "AMDGPU (ROCm) setup completed."
}

# Function for NVIDIA GPU setup
nvidia_gpu_setup() {
    clear_screen "NVIDIA GPU Setup"
    
    # Install the recommended NVIDIA driver
    ubuntu-drivers devices
    read -p "Enter the recommended driver version (e.g., nvidia-driver-XXX): " nvidia_driver
    sudo apt install -y $nvidia_driver
    check_error "NVIDIA Driver Installation"
    
    STATUS[GPU_SETUP]="Completed (NVIDIA)"
    pause_and_report "NVIDIA GPU setup completed."
}

# Function for Intel GPU setup
intel_gpu_setup() {
    clear_screen "Intel GPU Setup"
    
    sudo apt install -y intel-media-va-driver-non-free
    check_error "Intel GPU Driver Installation"
    
    STATUS[GPU_SETUP]="Completed (Intel)"
    pause_and_report "Intel GPU setup completed."
}

# Function to handle invalid input
invalid_option() {
    echo -e "\nInvalid option selected. Please try again."
    sleep 2
}

# Start the script
clear_screen "Ubuntu Post-Install Setup"
check_root
log_message "Ubuntu post-installation setup script started at $(date)"
display_main_menu
