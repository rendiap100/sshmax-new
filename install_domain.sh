#!/bin/bash

function pasang_domain() {
    clear
    echo -e "  .==========================================."
    echo -e "   |\e[1;32m SETUP DOMAIN \e[0m|"
    echo -e "   '=========================================='"
    echo -e "     \e[1;32m1)\e[0m Menggunakan Domain Pribadi"
    echo -e "   =========================================="
    read -p "  Pilih Menu Domain (enter) to continue with the domain script: " host
    echo ""
    
    if [[ $host == "1" ]]; then
        echo -e "   \e[1;32mMasukan Domain Anda!\e[0m"
        read -p "   Subdomain: " host1
        echo $host1 > /etc/xray/domain
        echo $host1 > /root/domain
        echo "Domain telah diatur."
    elif [[ $host == "2" ]]; then
        # Install cloudflare (cf) jika diperlukan
        wget ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        echo "Cloudflare telah diatur."
    else
        echo "Subdomain/Domain acak digunakan."
    fi
}

# Jalankan fungsi
pasang_domain

