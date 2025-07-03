<div align="center">
  <img src="https://github.com/fixploit03/NetCut-CLI/blob/main/img/LOGO%20NetCut%20CLI%20(revisi).png" width="35%"/>
  <br>
  <h2>NetCut CLI v1.0</h2>
</div>

`NetCut CLI` adalah script Bash sederhana yang memungkinkan pengguna Linux untuk `memindai`, `memutus`, dan `memulihkan` koneksi perangkat di jaringan lokal melalui teknik `ARP spoofing`.

## Latar Belakang

Terciptanya `NetCut CLI` karena saya terinspirasi dari salah satu aplikasi populer dijaman kejayaan warnet yaitu nama aplikasinya `NetCut`, dimana `NetCut` ini bisa memutuskan koneksi internet siapa saja yang ada di satu jaringan yang sama, walaupun dia bukan sebagai seorang Administrator jaringan `NetCut` bisa melakukannya. Nah, `NetCut` kan hanya ada di Sistem operasi `Windows`, saya membuat `NetCut CLI` ini agar user `Linux` seperti saya ini bisa merasakan yang namanya aplikasi `NetCut` di `Linux`, meski hanya memiliki interface `CLI`, tapi fungsinya sama seperti yang ada di aplikasi `NetCut` yang ada di `Windows`.

## Instalasi

```
sudo apt update
sudo apt install arp-scan dsniff net-tools git
git clone https://github.com/fixploit03/NetCut-CLI
cd NetCut-CLI
chmod +x NetCut-CLI
./NetCut-CLI
```
