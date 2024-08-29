#!/bin/bash

# Fungsi pemasangan domain
function pasang_domain() {
  clear
  echo -e "  .==========================================."
  echo -e "   |\e[1;32mSETUP DOMAIN \e[0m|"
  echo -e "   '==========================================.'"
  echo -e "     \e[1;32m1)\e[0m Menggunakan Domain Pribadi"
  echo -e "   ============================================"
  
  read -p "  Pilih Menu Domain (enter) to continue with the domain script : " host
  echo ""
  
  if [[ $host == "1" ]]; then
    echo -e "   \e[1;32mMasukan Domain Anda ! $NC"
    read -p "   Subdomain: " host1
    echo "IP=" >> /var/lib/kyt/ipvps.conf
    echo $host1 > /etc/xray/domain
    echo $host1 > /root/domain
    echo ""
  elif [[ $host == "2" ]]; then
    # Install Cloudflare script
    wget ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear
  else
    echo "Random Subdomain/Domain is Used"
    clear
  fi
}

# Fungsi pemasangan SSL
function pasang_ssl() {
  clear
  echo "Memasang SSL Pada Domain"
  
  rm -rf /etc/xray/xray.key /etc/xray/xray.crt
  domain=$(cat /root/domain)
  STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
  
  rm -rf /root/.acme.sh
  mkdir /root/.acme.sh
  systemctl stop $STOPWEBSERVER
  systemctl stop nginx
  
  curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
  chmod +x /root/.acme.sh/acme.sh
  /root/.acme.sh/acme.sh --upgrade --auto-upgrade
  /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
  /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
  
  chmod 777 /etc/xray/xray.key
  echo "SSL Certificate berhasil dipasang"
}

# Menjalankan fungsi
pasang_domain
pasang_ssl
