#!/bin/bash

# Windows-like Features Script for Ubuntu 24

# Exit on any error
set -e

# Log file for installation process
logfile="/var/log/ubuntu24_windows_features.log"

# Variables to track the status of features
declare -A STATUS=(
    ["SUDO_NOPASSWD"]="Disabled"
    ["APPARMOR"]="Enabled"
    ["UFW"]="Enabled"
    ["AUTO_LOGIN"]="Disabled"
    ["WINDOWS_COMMANDS"]="Disabled"
)

# Function to print a dynamic banner with a menu name (80 characters)
print_banner() {
    local menu_name="$1"
    printf '=%.0s' {1..80}
    echo -e "\n    Ubuntu24-Windows-like Features - $menu_name"
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
    echo "1. Disable sudo password prompt (SUDO_NOPASSWD)          (Status: ${STATUS[SUDO_NOPASSWD]})"
    echo ""
    echo "2. Disable AppArmor (APPARMOR)                           (Status: ${STATUS[APPARMOR]})"
    echo ""
    echo "3. Disable UFW (Uncomplicated Firewall) (UFW)            (Status: ${STATUS[UFW]})"
    echo ""
    echo "4. Enable auto-login (AUTO_LOGIN)                        (Status: ${STATUS[AUTO_LOGIN]})"
    echo ""
    echo "5. Implement Windows-like commands (WINDOWS_COMMANDS)    (Status: ${STATUS[WINDOWS_COMMANDS]})"
    echo ""
    print_separator
    read -p "Selection = 1-5, Exit Program = X: " menu_choice
}

# Function to toggle sudo password prompt
toggle_sudo_nopasswd() {
    clear_screen "Disable sudo password prompt"
    if [ "${STATUS[SUDO_NOPASSWD]}" == "Disabled" ]; then
        echo "$SUDO_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd > /dev/null
        chmod 0440 /etc/sudoers.d/nopasswd
        check_error "Sudo Password Prompt Disable"
        STATUS[SUDO_NOPASSWD]="Enabled"
        log_message "Sudo password prompt disabled."
    else
        sudo rm /etc/sudoers.d/nopasswd
        check_error "Sudo Password Prompt Enable"
        STATUS[SUDO_NOPASSWD]="Disabled"
        log_message "Sudo password prompt enabled."
    fi
    pause_and_report "Sudo password prompt status updated."
}

# Function to toggle AppArmor
toggle_apparmor() {
    clear_screen "Disable AppArmor"
    if [ "${STATUS[APPARMOR]}" == "Enabled" ]; then
        sudo systemctl disable apparmor
        sudo systemctl stop apparmor
        check_error "AppArmor Disable"
        STATUS[APPARMOR]="Disabled"
        log_message "AppArmor disabled."
    else
        sudo systemctl enable apparmor
        sudo systemctl start apparmor
        check_error "AppArmor Enable"
        STATUS[APPARMOR]="Enabled"
        log_message "AppArmor enabled."
    fi
    pause_and_report "AppArmor status updated."
}

# Function to toggle UFW
toggle_ufw() {
    clear_screen "Disable UFW"
    if [ "${STATUS[UFW]}" == "Enabled" ]; then
        sudo ufw disable
        check_error "UFW Disable"
        STATUS[UFW]="Disabled"
        log_message "UFW disabled."
    else
        sudo ufw enable
        check_error "UFW Enable"
        STATUS[UFW]="Enabled"
        log_message "UFW enabled."
    fi
    pause_and_report "UFW status updated."
}

# Function to toggle auto-login
toggle_auto_login() {
    clear_screen "Enable auto-login"
    if [ "${STATUS[AUTO_LOGIN]}" == "Disabled" ]; then
        sudo sed -i "s/^#  AutomaticLogin/AutomaticLogin=$SUDO_USER/" /etc/gdm3/custom.conf
        check_error "Auto-login Enable"
        STATUS[AUTO_LOGIN]="Enabled"
        log_message "Auto-login enabled."
    else
        sudo sed -i "s/^AutomaticLogin=$SUDO_USER/#  AutomaticLogin/" /etc/gdm3/custom.conf
        check_error "Auto-login Disable"
        STATUS[AUTO_LOGIN]="Disabled"
        log_message "Auto-login disabled."
    fi
    pause_and_report "Auto-login status updated."
}

# Function to implement Windows-like commands
implement_windows_commands() {
    clear_screen "Implement Windows-like Commands"
    log_message "Starting the implementation of Windows-like commands."

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

    log_message "Windows-like commands have been successfully implemented."
    echo "Windows-like commands have been successfully implemented."
    pause_and_report "Windows-like commands implementation completed."
    STATUS[WINDOWS_COMMANDS]="Enabled"
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
            1) toggle_sudo_nopasswd ;;
            2) toggle_apparmor ;;
            3) toggle_ufw ;;
            4) toggle_auto_login ;;
            5) implement_windows_commands ;;
            [Xx]) 
                log_message "Exiting the Windows-like Features script."
                echo "Exiting..."
                exit 0
                ;;
            *) invalid_option ;;
        esac
    done
}

# Start the script
clear_screen "Windows-like Features"
check_root
log_message "Windows-like Features script started at $(date)"
main_menu_loop
