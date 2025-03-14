#!/bin/bash

# Warna untuk tampilan
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Bersihkan layar terminal
clear

# Tampilkan banner
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}     Microsoft OS ISO -SHARE IT HUB      ${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""

# Fungsi untuk menampilkan menu dan mendapatkan pilihan user
display_menu() {
    echo -e "${YELLOW}Pilih OS dari Microsoft:${NC}"
    echo "1. Windows Server 2016"
    echo "2. Windows Server 2019"
    echo "3. Windows Server 2022"
    echo ""
    read -p "Masukkan pilihan Anda (1-3): " choice
}

# Tampilkan menu
display_menu

# Proses pilihan user dan set variabel ISO serta image file
case $choice in
    1)
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195174&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2016.iso"
        img_file="windows2016.img"
        ;;
    2)
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2019.iso"
        img_file="windows2019.img"
        ;;
    3)
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195280&clcid=0x409&culture=en-us&country=US"
        iso_file="windows2022.iso"
        img_file="windows2022.img"
        ;;
    *)
        echo -e "${RED}Pilihan tidak valid. Keluar.${NC}"
        exit 1
        ;;
esac

# Mulai proses download ISO OS
echo ""
echo -e "${GREEN}Memulai download ${iso_file}...${NC}"
wget -O "$iso_file" "$iso_link"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Download ${iso_file} selesai.${NC}"
else
    echo -e "${RED}Download gagal. Silakan coba lagi.${NC}"
    exit 1
fi

# Persiapan instalasi QEMU dan dependensinya
echo ""
echo -e "${GREEN}Memeriksa dan menginstall QEMU serta dependensinya...${NC}"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y qemu qemu-kvm qemu-system-x86 qemu-utils

# Membuat image disk jika belum ada
if [ ! -f "$img_file" ]; then
    echo -e "${GREEN}Membuat image disk ${img_file} dengan ukuran 40G...${NC}"
    qemu-img create -f raw "$img_file" 40G
fi

# Mendownload ISO VirtIO jika belum ada
if [ ! -f "virtio-win.iso" ]; then
    echo -e "${GREEN}Mendownload VirtIO driver ISO...${NC}"
    wget -O virtio-win.iso 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-1/virtio-win-0.1.215.iso'
fi

# Menjalankan QEMU dengan parameter yang menyesuaikan versi OS yang dipilih
echo ""
echo -e "${GREEN}Menjalankan QEMU dengan konfigurasi untuk ${iso_file} dan ${img_file}...${NC}"

qemu-system-x86_64 \
-m 4G \
-cpu host \
-enable-kvm \
-boot order=d \
-drive file="$iso_file",media=cdrom \
-drive file="$img_file",format=raw,if=virtio \
-drive file=virtio-win.iso,media=cdrom \
-device usb-ehci,id=usb,bus=pci.0,addr=0x4 \
-device usb-tablet \
-vnc :0
