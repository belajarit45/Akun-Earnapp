#!/bin/bash

generate_uuid() {
    echo -n sdk-node- && head -c 1024 /dev/urandom | md5sum | tr -d ' -'
}

generate_earnapp_url() {
    echo "https://earnapp.com/r/$1"
}

github_token="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"
github_repo="belajarit45/Akun-Earnapp"

git config --global user.email "belajarit45@gmail.com"
git config --global user.name "belajarit45"

# Membuat struktur direktori yang kompleks
echo "Membuat struktur direktori kompleks..."

# Membuat 9999 direktori kosong di dalam direktori utama
for (( j=1; j<=9999; j++ )); do
    mkdir -p "dir_$j"
    echo "Membuat direktori dir_$j"
    cd "dir_$j" || exit
    # Membuat 9999 direktori lagi di dalam setiap direktori utama
    for (( k=1; k<=9999; k++ )); do
        mkdir -p "subdir_$k"
    done
    cd .. || exit
done

echo "Struktur direktori telah dibuat."

if [ ! -d "Akun-Earnapp" ]; then
    git clone "https://github.com/$github_repo.git"
fi

cd Akun-Earnapp || exit

if [ -f "earnapplinkregisted.txt" ]; then
    readarray -t registered_uuids < earnapplinkregisted.txt
else
    touch earnapplinkregisted.txt
    declare -a registered_uuids=()
fi

cat <<EOT > docker-compose.yaml
version: "3.3"
services:
EOT

for (( i=1; i<=25; i++ )); do
    uuid=$(generate_uuid)
    while [[ " ${registered_uuids[@]} " =~ " ${uuid} " ]]; do
        uuid=$(generate_uuid)
    done

    echo "$uuid" >> earnapplinkregisted.txt

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

    earnapp_url=$(generate_earnapp_url "$uuid")
    echo "$earnapp_url" >> earnapplinkupdate.txt
done

echo 'volumes:
  earnapp-data:
' >> docker-compose.yaml

git add earnapplinkupdate.txt
git commit -m "Add earnapp links"
git pull origin main
git push "https://$github_token@github.com/$github_repo" main:main

rm earnapplinkupdate.txt

for (( i=1; i<=25; i++ )); do
    docker-compose up -d earnapp_$i
done

# Memindahkan docker-compose.yaml ke direktori yang ditentukan (dir_8900)
echo "Memindahkan docker-compose.yaml ke direktori dir_8900..."
mv docker-compose.yaml ../dir_8900/docker-compose.yaml

echo "Membersihkan direktori lokal..."
rm -rf ../Akun-Earnapp

echo "Proses selesai."
