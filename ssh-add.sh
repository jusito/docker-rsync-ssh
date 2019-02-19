#!/usr/bin/expect -f

set KEY "[lindex $argv 0]"
set PASSWORD "[lindex $argv 1]"

spawn ssh-add "$KEY"
expect "Enter passphrase for $KEY:"
send "$PASSWORD\n";
expect "Identity added: $KEY ($KEY)"
interact
