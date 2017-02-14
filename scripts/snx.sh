#!/bin/bash
server=$SNX_SERVER
user=$SNX_USER
password=$SNX_PASSWORD

/usr/bin/expect <<EOF
set timeout 10
log_user 0
send_user "Disconnecting old sessions...\n"
spawn snx -d
expect {
        timeout { exit 2 }
        eof {
               sleep 1
               send_user "Connecting to VPN...\n"
               spawn -ignore HUP /bin/sh -c "snx -s $server -p 443 -u $user"
               expect {
                       "password:" {
                                      send "$password\r"
                                      expect {
                                              "Do you accept" {
                                                               send_user "Accepting certificate\n"
                                                               send "y\r"
                                                               exp_continue
                                              }
                                              "connected." {
                                                            send_user "Connected!\n"
                                                            exit 0
                                              }
                                              "Connection aborted." {
                                                                     send_user "Connection aborted.\n"
                                                                     exit 0
                                              }
                                              "Authentication failed" {
                                                                       send_user "Auth failed.\n"
                                                                       exit 0
                                              }
                                              eof {
                                                   send_user "Error!\n"
                                                   exit 0
                                              }
                                              timeout {
                                                       send_user "Timeout!\n"
                                                       exit 0
                                              }
                                      }
                                   }
                      eof {
                           send_user "Error!\n"
                           exit 0
                      }
                      timeout {
                               send_user "Timeout!\n"
                               exit 0
                      }
              }
       }
}
expect eof
exit 1

}
EOF


while [ 1 ]; do

  if [ $(ip add sh dev tunsnx | grep inet | wc -l) -ne 0 ]; then
     break
  fi

  sleep 5

done


/usr/sbin/danted -f /etc/danted.conf -D

/bin/bash
