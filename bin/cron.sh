alias crone="crontab -e"
alias cronl="crontab -l"
cronsys(){
    grep CRON /var/log/syslog 
  if [[ $1 == "awsm" ]]; then
    grep CRON /var/log/syslog | grep awsm
  fi
}
