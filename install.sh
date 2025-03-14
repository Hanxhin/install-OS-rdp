#!/bin/bash

# Bersihkan layar terminal dan tampilkan banner
clear
echo "=========================================="
echo "     Microsoft OS ISO & QEMU Installer    "
echo "=========================================="
echo ""

# Tampilkan menu pilihan OS
echo "Pilih OS dari Microsoft:"
echo "1. Windows Server 2016"
echo "2. Windows Server 2019"
echo "3. Windows Server 2022"
read -p "Masukkan pilihan Anda (1-3): " choice

# Set variabel ISO dan image file sesuai pilihan
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
        echo "Pilihan tidak valid. Keluar."
        exit 1
        ;;
esac

# Mulai proses download ISO dengan tampilan progress secara real time
echo ""
echo "Memulai download ${iso_file}..."
wget --progress=bar:force:noscroll -O "$iso_file" "$iso_link"
if [ $? -ne 0 ]; then
    echo "Download gagal. Keluar."
    exit 1
fi
echo "Download ${iso_file} selesai."

# Membuat image disk jika belum ada
if [ ! -f "$img_file" ]; then
    echo "Membuat image disk ${img_file} dengan ukuran 40G..."
    qemu-img create -f raw "$img_file" 40G
fi

# Langsung menjalankan QEMU dengan konfigurasi yang ditentukan
echo ""
echo "Menjalankan QEMU..."
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
