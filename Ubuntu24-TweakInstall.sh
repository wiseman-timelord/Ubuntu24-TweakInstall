#!/bin/bash

# Function to print the menu
print_menu() {
    clear
    echo "================================================================================"
    echo "    Ubuntu 24 - Tweaks and Installer"
    echo "================================================================================"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "    1. Launch Program"
    echo ""
    echo "    2. Check Files"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "--------------------------------------------------------------------------------"
    echo -n "Selection; Menu Options 1-2, Exit Batch = X: "
}

# Function to check files
check_files() {
    echo "Checking files..."
    if [ -f "launcher.py" ] && [ -f "scripts/interface.py" ] && [ -f "scripts/utility.py" ]; then
        echo "All required Python scripts are present."
    else
        echo "Error: One or more Python scripts are missing."
    fi
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    print_menu
    read choice
    case $choice in
        1)
            echo "Launching the program..."
            python3 launcher.py
            read -p "Press Enter to continue..."
			;;
        2)
            check_files
            ;;
        [Xx])
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, or X."
            read -p "Press Enter to continue..."
            ;;
    esac
done
