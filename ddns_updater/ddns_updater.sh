#!/bin/bash

# region Log Functions

function log() {
  timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
  level=$1
  message=$2
  line="$timestamp $level $message"
  if [ "$do_logging" = "true" ]; then
    echo "$line" >> $run_log
  fi
}

function log_info() {
  log "INFO" "$1"
}

function log_error() {
  log "ERROR" "$1"
}

function log_debug() {
  if [ "$log_level" = "debug" ]; then
    log "DEBUG" "$1"
  fi
}

# endregion Log Functions

# region Load Functions

function load_conf() {
  source "$config_file"
  log_debug "Loaded config file:'$config_file'"
}

function load_hostnames() {
  log_debug "Entering load_hostnames()"
  log_debug "Loading hostnames file: $hostnames"
  hostnames_file=$(cat $hostnames)
  log_debug "Loaded hostnames file: $hostnames"
  log_debug "Exiting load_hostnames()"
}

# endregion Load Functions

# region Networking Functions

function fetch_current_ip() {
  log_debug "Entering fetch_current_ip()"
  log_info "Fetching current public IP address"
  current_public_ip=$(curl --silent "$public_ip_fetch_url")
  log_info "Current public IPv4 address: $current_public_ip"
  log_debug "Exiting fetch_current_ip()"
}

function compare_ips() {
  log_debug "Entering compare_ips()"
  log_debug "Loading saved public IP address from $ip_file"
  previous_public_ip=$(cat $ip_file)
  log_debug "IP address $previous_public_ip loaded from $ip_file"
  log_debug "Comparing current and saved public IP addresses"
  if [ "$current_public_ip" = "$previous_public_ip" ]; then
    log_debug "Saved public IP matches current public IP"
    log_debug "Exiting script"
    exit 0
  else
    log_info "Saved and current public IP addresses do not match"
    log_info "Hostnames in $hostnames_file will be updated"
    log_debug "Updating ip_file: $ip_file"
    echo "$current_public_ip" > $ip_file
    log_debug "Updated ip_file"
  fi
  log_debug "Exiting compare_ips()"
}

function update_hostname() {
  log_debug "Entering update_hostname()"
  user_agent_string="$user_agent $user_agent_email"
  log_debug "Updating IP with User Agent [ $user_agent_string ] "
  log_debug "Calling curl to update IP"
  curl --silent --user-agent "$user_agent_string" "https://$noip_username:$noip_password@dynupdate.no-ip.com/nic/update?hostname=$1&myip=$current_public_ip"
  log_info "Updated $1"
  log_debug "Exiting update_hostname()"
}

function update_all_hostnames() {
  log_debug "Entering update_all_hostnames()"
  load_hostnames
  log_debug "Beginning iteration through hostnames file"
  for line in $hostnames_file 
  do
    log_debug "Updating $line from $hostnames_file"
    update_hostname $line
    log_debug "Updated $line from $hostnames_file"
  done
  log_debug "Finished iteration through hostnames file"
  log_debug "Exiting update_all_hostnames()"
}

# endregion Networking Functions

# Begin processing

config_file="./ddns_updater.conf"

load_conf

fetch_current_ip

compare_ips

update_all_hostnames
