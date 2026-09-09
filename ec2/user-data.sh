#!/bin/bash
# The boot checklist 📋 (lesson 12): runs ONCE, as root, on first boot.
# This one turns a blank rented computer into a tiny web server — no SSH needed.
dnf install -y nginx
echo "<h1>🖥️ hello from $(hostname) — set up by user-data, no human touched me</h1>" \
  > /usr/share/nginx/html/index.html
systemctl enable --now nginx
