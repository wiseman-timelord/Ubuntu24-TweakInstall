#!/bin/bash

# Windows-like Features Script for Ubuntu 24

# Exit on any error
set -e

# Log file for installation process
logfile="/var/log/ubuntu24_windows_features.log"

# Variables to track the status of features
declare -A STATUS=(
    ["SUDO_NOPASSWD"]="Disabled"
    ["AUTO_LOGIN"]="Disabled"
    ["WINDOWS_COMMANDS"]="Disabled"
    ["HANG_TIMEOUT"]=""
)

# Function to get current hang timeout
get_hang_timeout() {
    local milliseconds
    # Try gsettings first and strip 'uint32 ' prefix if present
    milliseconds=$(sudo -u "$SUDO_USER" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$SUDO_USER")/bus \
        gsettings get org.gnome.mutter check-alive-timeout 2>/dev/null | sed 's/uint32 //' || true)
    
    # Fallback to dconf if gsettings fails
    if [[ -z "$milliseconds" ]] || [[ "$milliseconds" == "No such key"* ]]; then
        milliseconds=$(sudo -u "$SUDO_USER" dconf read /org/gnome/mutter/check-alive-timeout 2>/dev/null || true)
    fi
    
    # Default to 5 seconds if no value found
    if [[ -z "$milliseconds" ]] || ! [[ "$milliseconds" =~ ^[0-9]+$ ]]; then
        milliseconds=5000
    fi
    
    # Convert to seconds
    echo $((milliseconds / 1000))
}

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
    # Update hang timeout status
    STATUS["HANG_TIMEOUT"]="$(get_hang_timeout)s"
    
    clear_screen "Main Menu"
    echo ""
    echo "1. Disable sudo password prompt (SUDO_NOPASSWD)          (Status: ${STATUS[SUDO_NOPASSWD]})"
    echo ""
    echo "2. Enable auto-login (AUTO_LOGIN)                        (Status: ${STATUS[AUTO_LOGIN]})"
    echo ""
    echo "3. Implement Windows-like commands (WINDOWS_COMMANDS)    (Status: ${STATUS[WINDOWS_COMMANDS]})"
    echo ""
    echo "4. Adjust GNOME hang timeout (Force Quit dialog)         (Current: ${STATUS[HANG_TIMEOUT]})"
    echo ""
    print_separator
    read -p "Selection = 1-4, Exit Program = X: " menu_choice
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

# Function to adjust GNOME hang timeout
adjust_hang_timeout() {
    clear_screen "Adjust GNOME Hang Timeout"
    
    # Get current value in seconds
    current_seconds=$(get_hang_timeout)
    
    echo "Current hang timeout: $current_seconds seconds"
    read -p "Enter new timeout in seconds (0=disable): " new_seconds
    
    # Validate input
    if [[ ! "$new_seconds" =~ ^[0-9]+$ ]]; then
        log_message "Invalid timeout value: $new_seconds"
        pause_and_report "Error: Must be a positive integer"
        return
    fi
    
    # Convert to milliseconds
    new_milliseconds=$((new_seconds * 1000))
    
    # Set the new timeout (using gsettings with proper uint32 format)
    if sudo -u "$SUDO_USER" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$SUDO_USER")/bus \
        gsettings set org.gnome.mutter check-alive-timeout "uint32 $new_milliseconds" 2>/dev/null; then
        log_message "Set hang timeout to ${new_seconds}s via gsettings"
    else
        sudo -u "$SUDO_USER" dconf write /org/gnome/mutter/check-alive-timeout "$new_milliseconds"
        log_message "Set hang timeout to ${new_seconds}s via dconf"
    fi
    
    check_error "Hang Timeout Adjustment"
    STATUS["HANG_TIMEOUT"]="${new_seconds}s"
    pause_and_report "Hang timeout updated to ${new_seconds} seconds"
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
            2) toggle_auto_login ;;
            3) implement_windows_commands ;;
            4) adjust_hang_timeout ;;
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
# Initialize hang timeout status
STATUS["HANG_TIMEOUT"]="$(get_hang_timeout)s"
main_menu_loop