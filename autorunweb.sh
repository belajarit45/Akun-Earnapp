#!/bin/bash

# Array of URLs
urls=(
  "https://earnapp.com/r/sdk-node-f990e57aa8e38f8eb57354daf09e4b19"
  "https://earnapp.com/r/sdk-node-d8716424c8a9b8ca040a94a3da51b234"
  "https://earnapp.com/r/sdk-node-446d5be9feb3b1d6818d03f6322a0853"
  "https://earnapp.com/r/sdk-node-034b04be2868131f56f5e152dd2a8649"
  "https://earnapp.com/r/sdk-node-5dbb621f4f3e6681335914404b90a6ef"
  "https://earnapp.com/r/sdk-node-c79909658f1bfbadfc996cd4eb3e001e"
  "https://earnapp.com/r/sdk-node-105a8a514ec67b7532d9ec67b995f976"
  "https://earnapp.com/r/sdk-node-3adcdf322358210f6d0f8e9273676e85"
  "https://earnapp.com/r/sdk-node-00759eeb87202e0cffdeaf18a0710589"
  "https://earnapp.com/r/sdk-node-6cfb5613305103662a0ec6339ab7bcca"
  "https://earnapp.com/r/sdk-node-1bbf7562f2ab8418ed3c079fd60a997d"
  "https://earnapp.com/r/sdk-node-be339f9f11ae4bcaf0bd9d1b300eaa5a"
  "https://earnapp.com/r/sdk-node-8405b4ab747dd23fa9fb90499ef1a2e8"
  "https://earnapp.com/r/sdk-node-a83010c8c206e668f1b4304536a752b5"
  "https://earnapp.com/r/sdk-node-f965a512729b2ebe80a2dfb9feecf75a"
  "https://earnapp.com/r/sdk-node-c8284e720a8d3c3de6f72c252c8a6948"
  "https://earnapp.com/r/sdk-node-aa9b74dba36fdeb64fdae4fb8d43804f"
  "https://earnapp.com/r/sdk-node-cdedc0fc57eead46d18b7ce42f075adc"
  "https://earnapp.com/r/sdk-node-6bf886f30b0265e8daad83fcd03f3328"
  "https://earnapp.com/r/sdk-node-9ab57d045014d02ad685a71c67c98fff"
  "https://earnapp.com/r/sdk-node-aba559b98c06af93638cfd8cbb8fd219"
  "https://earnapp.com/r/sdk-node-27143e7e50c40b9eb130dbe1a1f52128"
  "https://earnapp.com/r/sdk-node-b489d579f349ef0ec06f01c1d1442869"
  "https://earnapp.com/r/sdk-node-a51087c358427a7d0384d9474b856e22"
  "https://earnapp.com/r/sdk-node-746169bae025be378f8b0feeb9f18acf"
)

# Function to open URL in browser
open_url() {
  termux-open-url "$1"
}

# Loop through each URL
for (( i=0; i<${#urls[@]}; i++ )); do
  # Display current link number
  echo "Membuka link ke-$((i+1)) dari ${#urls[@]}"
  
  # Open URL
  open_url "${urls[$i]}"
  
  # Check if we need to sleep
  if (( ($i + 1) % 5 == 0 && ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 5 menit..."
    sleep 300  # Sleep for 5 minutes
  elif (( ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 10 detik..."
    sleep 10   # Sleep for 10 seconds
  fi
done

echo "Selesai!"
