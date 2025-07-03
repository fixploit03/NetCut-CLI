<div align="center">
  <img src="https://github.com/fixploit03/NetCut-CLI/blob/main/img/LOGO%20NetCut%20CLI%20(revisi).png" width="35%"/>
  <br>
  <h2>NetCut CLI v1.0</h2>
</div>

<p align="center">
  <a href="https://github.com/fixploit03/NetCut-CLI#instalasi">Instalasi</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/fixploit03/NetCut-CLI#demonstrasi">Demonstrasi</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="https://github.com/fixploit03/NetCut-CLI#lisensi">Lisensi</a>
</p>

<div align="center">

  <!-- Badge Bagian Atas -->
  <img src="https://img.shields.io/github/v/release/Fixploit03/netcut-cli?color=blue" alt="Release">
  <img src="https://img.shields.io/github/license/Fixploit03/netcut-cli" alt="License">
  <img src="https://img.shields.io/badge/platform-Linux-yellow" alt="Platform">

  <br>

  <!-- Badge Bagian Bawah -->
  <img src="https://img.shields.io/github/stars/Fixploit03/netcut-cli?style=social" alt="Stars">
  <img src="https://img.shields.io/github/forks/Fixploit03/netcut-cli?style=social" alt="Forks">

</div><br>

`NetCut CLI` adalah script Bash sederhana yang memungkinkan pengguna Linux untuk `memindai`, `memutus`, dan `memulihkan` koneksi perangkat di jaringan lokal melalui teknik [ARP spoofing](https://github.com/fixploit03/NetCut-CLI/blob/main/doc/arp_spoofing.md).

> Disclaimer: Script ini saya buat semata-mata hanya untuk tujuan edukasi dan pembelajaran saja, tolong jangan salah gunakan script ini untuk tujuan negatif atau merugikan orang lain dan gunakanlah script ini dengan bijak!

## Latar Belakang

Terciptanya `NetCut CLI` karena saya terinspirasi dari salah satu aplikasi populer dijaman kejayaan warnet yaitu nama aplikasinya `NetCut`, dimana `NetCut` ini bisa memutuskan koneksi internet siapa saja yang ada di satu jaringan yang sama, walaupun dia bukan sebagai seorang Administrator jaringan `NetCut` bisa melakukannya. Nah, `NetCut` kan hanya ada di Sistem operasi `Windows`, saya membuat `NetCut CLI` ini agar user `Linux` seperti saya ini bisa merasakan yang namanya aplikasi `NetCut` di `Linux`, meski hanya memiliki interface `CLI`, tapi fungsinya sama seperti yang ada di aplikasi `NetCut` yang ada di `Windows`.

## Fitur 

1. Scan Target
2. Putuskan Koneksi Target
3. Pulihkan Koneksi Target

## Instalasi

```
sudo apt update
sudo apt install arp-scan dsniff net-tools git
git clone https://github.com/fixploit03/NetCut-CLI
cd NetCut-CLI
cd src
chmod +x NetCut-CLI
sudo ./NetCut-CLI
```

## Demonstrasi

https://github.com/user-attachments/assets/e6ec2e60-2fed-495b-a69d-11109311987f

## Lisensi

**Hak Cipta © 2025 Rofi (Fixploit03)**

Script ini dilisensikan secara `gratis`. Anda diizinkan untuk `menggunakan`, `menyalin`, `memodifikasi`, `menggabungkan`, `menerbitkan`, `mendistribusikan`, `melisensikan ulang`, dan `menjual salinan script ini`, dengan syarat:

Pemberitahuan hak cipta dan lisensi ini disertakan dalam semua salinan atau bagian substansial dari script.

Script diberikan "**sebagaimana adanya**", tanpa jaminan apa pun, termasuk jaminan kelayakan untuk diperjualbelikan, kesesuaian untuk tujuan tertentu, atau bebas dari pelanggaran.

Lihat [LICENSE](https://github.com/fixploit03/NetCut-CLI/blob/main/LICENSE) untuk detail lebih lengkap.

## Dukungan

Jika Anda menyukai proyek ini atau merasa bahwa proyek ini bermanfaat, Anda dapat mendukung proyek ini dengan cara berikut:

- Beri bintang pada repositori ini di GitHub untuk membantu orang lain menemukannya.
- Beri umpan balik dengan membuka [issue](https://github.com/fixploit03/NetCut-CLI/issues) atau memberikan saran perbaikan.

## Kontak

- **Pembuat**: Rofi (Fixploit03)
- **GitHub**: fixploit03
- **Email**: fixploit03@gmail.com

> Terimakasih untuk komunitas Open-Source untuk inspirasi dan dukungannya.
