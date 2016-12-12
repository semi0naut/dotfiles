To install these services first link them to `/etc/systemd/system/`

Next, run `systemctl enable <script-name>.serivoce`

And then finally you can force start with `systemctl start <script-name>.service`
