#!/bin/bash

# تنظیمات تلگرام
CHAT_ID="6973533203"
BOT_TOKEN="8585245962:AAFCRtiVOjy5qw7xjdw9qg_9kQC4-lTutKw"

# دانلود zip از GitHub
cd /root
wget -O amirhossein.zip https://raw.githubusercontent.com/Amirhosseinamnn/amirhossein-reverse-tunell/main/amirhossein.zip

# ساخت فولدرها
mkdir -p /root/a /root/b /root/c

# ایجاد config.toml برای a
cat <<EOF >/root/a/config.toml
[server]
bind_addr = "0.0.0.0:3020"
transport = "tcpmux"
token = "mehrsam"
keepalive_period = 75
nodelay = true
heartbeat = 40
channel_size = 2048
mux_con = 8
mux_version = 2
mux_framesize = 32768
mux_recievebuffer = 4194304
mux_streambuffer = 2000000
sniffer = false
web_port = 0
sniffer_log = "/root/backhaul.json"
log_level = "info"
ports = ["4434"]
EOF

# ایجاد config.toml برای b
cat <<EOF >/root/b/config.toml
[server]
bind_addr = "0.0.0.0:3020"
transport = "tcpmux"
token = "mehrsam"
keepalive_period = 75
nodelay = true
heartbeat = 40
channel_size = 2048
mux_con = 8
mux_version = 2
mux_framesize = 32768
mux_recievebuffer = 4194304
mux_streambuffer = 2000000
sniffer = false
web_port = 0
sniffer_log = "/root/backhaul.json"
log_level = "info"
ports = ["4434"]
EOF

# ایجاد config.toml برای c
cat <<EOF >/root/c/config.toml
[server]
bind_addr = "0.0.0.0:2020"
transport = "tcpmux"
token = "mehrsam"
keepalive_period = 75
nodelay = true
heartbeat = 40
channel_size = 2048
mux_con = 8
mux_version = 2
mux_framesize = 32768
mux_recievebuffer = 4194304
mux_streambuffer = 2000000
sniffer = false
web_port = 0
sniffer_log = "/root/backhaul.json"
log_level = "info"
ports = [""]
EOF

# اکسترکت zip داخل فولدرها
unzip -o /root/amirhossein.zip -d /root/a/
unzip -o /root/amirhossein.zip -d /root/b/
unzip -o /root/amirhossein.zip -d /root/c/

# chmod +x فایل‌های backhaul
chmod +x /root/a/backhaul
chmod +x /root/b/backhaul
chmod +x /root/c/backhaul

# ساخت سرویس backhaula
cat <<EOF >/etc/systemd/system/backhaula.service
[Unit]
Description=Backhaul Reverse Tunnel Service
After=network.target

[Service]
Type=simple
ExecStart=/root/a/backhaul -c /root/a/config.toml
Restart=always
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

# ساخت سرویس backhaulb
cat <<EOF >/etc/systemd/system/backhaulb.service
[Unit]
Description=Backhaul Reverse Tunnel Service
After=network.target

[Service]
Type=simple
ExecStart=/root/b/backhaul -c /root/b/config.toml
Restart=always
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

# ساخت سرویس backhaulc
cat <<EOF >/etc/systemd/system/backhaulc.service
[Unit]
Description=Backhaul Reverse Tunnel Service
After=network.target

[Service]
Type=simple
ExecStart=/root/c/backhaul -c /root/c/config.toml
Restart=always
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

# فعال کردن سرویس‌ها
systemctl daemon-reload
systemctl enable backhaula.service
systemctl enable backhaulb.service
systemctl enable backhaulc.service

# اجرای سرویس‌ها
systemctl start backhaula.service
systemctl start backhaulb.service
systemctl start backhaulc.service

# دریافت IP ها
IPV4=$(curl -4 -s ifconfig.me)
IPV6=$(curl -6 -s ifconfig.me)

# پیام نهایی
MESSAGE="Setup Completed ✔️

IPv4: $IPV4
IPv6: $IPV6

Services started:
- backhaula
- backhaulb
- backhaulc"

# ارسال پیام به تلگرام
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
-d chat_id="${CHAT_ID}" \
-d text="$MESSAGE"

# باز کردن nano برای ویرایش نهایی
nano /root/c/config.toml
