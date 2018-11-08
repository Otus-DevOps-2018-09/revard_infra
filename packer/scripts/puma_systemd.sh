#~/bin/bash

cat <<EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server
After=network.target

# Uncomment for socket activation (see below)
# Requires=puma.socket

[Service]
# Foreground process (do not use --daemon in ExecStart or config.rb)
Type=simple

# Preferably configure a non-privileged user
# User=

# The path to the puma application root
# Also replace the "<WD>" place holders below with this path.
WorkingDirectory=/home/appuser/reddit

# Helpful for debugging socket activation, etc.
# Environment=PUMA_DEBUG=1

# The command to start Puma. This variant uses a binstub generated via
# Could not locate Gemfile or .bundle/ directory in the WorkingDirectory
# (replace "<WD>" below)
ExecStart=/usr/local/bin/puma

# Variant: Use config file with  directives instead:
# ExecStart=<WD>/sbin/puma -C config.rb
# Variant: Use Could not locate Gemfile or .bundle/ directory instead of binstub

Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable  puma.service
systemctl start puma.service
