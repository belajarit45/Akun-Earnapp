#!/bin/bash

# Fungsi untuk generate UUID baru
generate_uuid() {
    echo -n sdk-node- && head -c 1024 /dev/urandom | md5sum | tr -d ' -'
}

# Fungsi untuk membuat URL earnapp
generate_earnapp_url() {
    echo "https://earnapp.com/r/$1"
}

# Token GitHub (ganti dengan token GitHub Anda)
github_token="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"

# Nama repo GitHub
github_repo="belajarit45/Akun-Earnapp"

# Set identitas pengguna Git
git config --global user.email "belajarit45@gmail.com"
git config --global user.name "belajarit45"

# Cek apakah repo lokal sudah ada, jika belum clone dari GitHub
if [ ! -d "Akun-Earnapp" ]; then
    git clone "https://github.com/$github_repo.git"
fi

# Navigasi ke direktori repo lokal
cd Akun-Earnapp || exit

# Baca file earnapplinkregisted.txt untuk mendapatkan UUID yang sudah terdaftar
if [ -f "earnapplinkregisted.txt" ]; then
    readarray -t registered_uuids < earnapplinkregisted.txt
else
    touch earnapplinkregisted.txt
    declare -a registered_uuids=()
fi

# Mulai menulis ke docker-compose.yaml (overwrite jika sudah ada)
cat <<EOT > docker-compose.yaml
version: "3.3"
services:
EOT

# Loop untuk membuat 25 container dan menghasilkan UUID serta URL baru
for (( i=1; i<=25; i++ )); do
    uuid=$(generate_uuid)
    # Pastikan UUID unik
    while [[ " ${registered_uuids[@]} " =~ " ${uuid} " ]]; do
        uuid=$(generate_uuid)
    done

    # Tambahkan UUID ke file registered
    echo "$uuid" >> earnapplinkregisted.txt

    # Tambahkan konfigurasi container ke docker-compose.yaml
    cat <<EOT >> docker-compose.yaml
  earnapp_$i:
    container_name: earnapp-container_$i
    image: fazalfarhan01/earnapp:lite
    restart: always
    volumes:
      - earnapp-data:/etc/earnapp
    environment:
      EARNAPP_UUID: $uuid

EOT

    # Tambahkan URL ke earnapplinkupdate.txt
    earnapp_url=$(generate_earnapp_url "$uuid")
    echo "$earnapp_url" >> earnapplinkupdate.txt
done

# Definisi volume earnapp-data di luar services
echo 'volumes:
  earnapp-data:
' >> docker-compose.yaml

# Commit dan push earnapplinkupdate.txt ke GitHub
git add earnapplinkupdate.txt
git commit -m "Add earnapp links"
git pull origin main
git push "https://$github_token@github.com/$github_repo" main:main

# Hapus earnapplinkupdate.txt dari direktori lokal
rm earnapplinkupdate.txt

# Jalankan container menggunakan docker-compose satu per satu
for (( i=1; i<=25; i++ )); do
    docker-compose up -d earnapp_$i
done

# Pindahkan docker-compose.yaml ke luar dari folder Akun-Earnapp
mv docker-compose.yaml ..

# Hapus seluruh folder Akun-Earnapp setelah selesai
rm -rf Akun-Earnapp
