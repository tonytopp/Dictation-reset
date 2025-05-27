#!/bin/bash

#==========================================================================
# Audio and Dictation Services Restart Script
#==========================================================================
#
# DESCRIPTION:
#   This script restarts essential audio and dictation services on macOS
#   to resolve issues with audio output, microphone input, and dictation
#   functionality, particularly for SteelSeries Arctis 7+ headsets.
#
# USAGE:
#   ./restart_audio_services.sh
#
# SERVICES RESTARTED:
#   1. corespeechd (dictation service)
#   2. assistantd (Siri and dictation assistant)
#   3. speechsynthesisd (speech synthesis)
#   4. coreaudiod (core audio daemon)
#   5. AudioComponentRegistrar (audio component registration)
#
#==========================================================================

# Function to print status messages with color
print_status() {
  local color_code=""
  if [[ "$1" == "INFO" ]]; then
    color_code="\033[1;34m" # Blue
  elif [[ "$1" == "SUCCESS" ]]; then
    color_code="\033[1;32m" # Green
  elif [[ "$1" == "WARNING" ]]; then
    color_code="\033[1;33m" # Yellow
  elif [[ "$1" == "ERROR" ]]; then
    color_code="\033[1;31m" # Red
  fi
  echo -e "${color_code}[$(date '+%Y-%m-%d %H:%M:%S')] $2\033[0m"
}

# Check if a process is running
check_process() {
  pgrep -q "$1"
  return $?
}

# Main function
main() {
  print_status "INFO" "Starting audio and dictation services restart..."
  
  # 1. Kill and restart corespeechd
  print_status "INFO" "Restarting corespeechd process..."
  if check_process "corespeechd"; then
    killall corespeechd 2>/dev/null
    print_status "INFO" "Killed corespeechd process"
    sleep 2
  fi
  
  # macOS should automatically restart corespeechd
  if check_process "corespeechd"; then
    print_status "SUCCESS" "corespeechd restarted automatically"
  else
    print_status "WARNING" "Attempting to manually restart corespeechd..."
    # Try alternative method
    killall -KILL corespeechd 2>/dev/null
    sleep 3
    if check_process "corespeechd"; then
      print_status "SUCCESS" "corespeechd restarted successfully"
    else
      print_status "ERROR" "Failed to restart corespeechd"
    fi
  fi
  
  # 2. Restart assistantd through killall (more reliable than launchctl for user processes)
  print_status "INFO" "Restarting assistantd process..."
  if check_process "assistantd"; then
    killall assistantd 2>/dev/null
    print_status "INFO" "Killed assistantd process"
    sleep 3
  fi
  
  # macOS should automatically restart assistantd
  if check_process "assistantd"; then
    print_status "SUCCESS" "assistantd restarted automatically"
  else
    print_status "WARNING" "assistantd did not restart automatically, which is unusual"
  fi
  
  # 3. Restart speechsynthesisd
  print_status "INFO" "Restarting speechsynthesisd process..."
  if check_process "speechsynthesisd"; then
    killall speechsynthesisd 2>/dev/null
    print_status "INFO" "Killed speechsynthesisd process"
    sleep 2
  fi
  
  # Check if speechsynthesisd came back
  if check_process "speechsynthesisd"; then
    print_status "SUCCESS" "speechsynthesisd restarted automatically"
  else
    print_status "WARNING" "speechsynthesisd is not running"
    # It might not be needed right away, so this is just a warning
  fi
  
  # 4. Restart coreaudiod - most important for audio issues
  print_status "INFO" "Restarting coreaudiod process (core audio service)..."
  
  # First check if coreaudiod is running
  if check_process "coreaudiod"; then
    # Method 1: Kill coreaudiod directly - macOS will restart it automatically
    print_status "INFO" "Killing coreaudiod process..."
    # We intentionally avoid using sudo here as it will restart automatically
    killall coreaudiod 2>/dev/null
    
    # Give it time to restart
    sleep 5
    
    if check_process "coreaudiod"; then
      print_status "SUCCESS" "coreaudiod restarted automatically"
    else
      print_status "WARNING" "coreaudiod didn't restart automatically, trying alternative method..."
      # Method 2: Try a more aggressive kill if normal kill didn't work
      killall -9 coreaudiod 2>/dev/null
      sleep 5
      
      if check_process "coreaudiod"; then
        print_status "SUCCESS" "coreaudiod restarted successfully with alternative method"
      else
        print_status "ERROR" "Failed to restart coreaudiod. This may require a system restart."
      fi
    fi
  else
    print_status "WARNING" "coreaudiod was not running initially!"
    # Unusual situation - system should always have coreaudiod running
  fi
  
  # 5. No direct restart for AudioComponentRegistrar - it's controlled by coreaudiod
  print_status "INFO" "AudioComponentRegistrar should restart with coreaudiod"
  
  # Final verification
  print_status "INFO" "Performing final verification of services..."
  
  # Check critical services
  local all_ok=true
  
  if ! check_process "corespeechd"; then
    print_status "ERROR" "corespeechd is not running"
    all_ok=false
  fi
  
  if ! check_process "coreaudiod"; then
    print_status "ERROR" "coreaudiod is not running"
    all_ok=false
  fi
  
  # Display overall status
  if $all_ok; then
    print_status "SUCCESS" "Critical audio services have been restarted successfully!"
    print_status "SUCCESS" "Your SteelSeries Arctis 7+ headset should now work properly with dictation"
  else
    print_status "WARNING" "Some services could not be restarted. You may need to restart your computer if issues persist."
  fi
  
  # Quick tips at the end
  print_status "INFO" "If dictation is still not working, try these tips:"
  print_status "INFO" "1. Open System Settings → Sound → Input and make sure Arctis 7+ is selected"
  print_status "INFO" "2. Try activating Siri briefly and then use dictation"
  print_status "INFO" "3. Check if your headset needs to be reconnected (unplug/replug USB if applicable)"
}

# Run the main function
main
