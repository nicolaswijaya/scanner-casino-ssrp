# HighLowUltimate - Casino Card Scanner & Predictor

**HighLowUltimate** adalah script pembantu (helper tool) berbasis **SAMP Moonloader (Lua)** dan **Python** yang dirancang khusus untuk mempermudah pemain dalam membaca sistem permainan kasino **High or Low** (Tebak Kartu) di server *State Side Roleplay (SSRP)*.

Script ini otomatis memindai kartu yang keluar melalui TextDraw server, mencatat riwayat kartu, dan menghitung persentase probabilitas (AI Prediction) secara real-time untuk merekomendasikan keputusan terbaik (**HIGH** atau **LOW**).

---

## Fitur Utama

- 🔍 **Auto TextDraw Scanner:** Membaca kartu yang dikeluarkan oleh dealer kasino secara otomatis tanpa input manual.
- 🧮 **Real-time Probability Engine:** Menghitung sisa kartu dalam deck standar (52 kartu) untuk memberikan persentase kemenangan langkah berikutnya.
- 📋 **Card History Tracker:** Mencatat urutan kartu yang sudah keluar agar perhitungan probabilitas tetap akurat selama permainan berlangsung.
- 🎛️ **Modern ImGui Interface:** Tampilan menu overlay hitam yang bersih dan responsif di dalam game, lengkap dengan tombol input manual darurat.
- 🖥️ **External Python Sync:** Dilengkapi backend Python (`scanner.py`) untuk kebutuhan monitoring log atau pengembangan eksternal.

---

## 📂 Struktur Proyek

Sesuai dengan workspace VS Code Anda, struktur folder proyek ini adalah sebagai berikut:

```text
HighLowUltimate/
├── templates/
│   └── HighnLowUltimate.lua  # Script utama Moonloader (masuk ke folder moonloader SAMP)
├── requirements.txt          # Daftar dependency untuk script Python
└── scanner.py                # Service Python eksternal untuk sinkronisasi data/log
```

---

## Petunjuk Instalasi & Cara Pakai

### 1. Memasang Script Lua (Moonloader)
1. Pastikan GTA SA-MP Anda sudah terpasang **Moonloader** dan **SAMPFuncs**.
2. Pastikan Anda sudah memiliki library `samp.events` di dalam folder `moonloader/lib`.
3. Pindahkan file `HighnLowUltimate.lua` dari folder `templates/` ke dalam direktori permainan Anda:
   `C:\Program Files (x86)\Rockstar Games\GTA San Andreas\moonloader\`

### 2. Menjalankan Python Service (Opsional)
Jika Anda ingin mengaktifkan fungsi log eksternal atau sinkronisasi data melalui terminal laptop:
1. Buka terminal atau command prompt di folder proyek ini.
2. Instal semua dependensi yang diperlukan dengan perintah:
   ```bash
   pip install -r requirements.txt
   ```
3. Jalankan script Python:
   ```bash
   python scanner.py
   ```

### 3. Cara Penggunaan di Dalam Game
- Masuk ke kasino di server SSRP dan dekati meja permainan **High or Low**.
- Tekan tombol **`F4`** pada keyboard untuk menampilkan atau menyembunyikan menu **CARD SCANNER & PREDICTOR**.
- Saat permainan dimulai, script akan otomatis menangkap kartu pertama. Perhatikan bagian **`AI PREDICTION / NEXT MOVE`** untuk melihat rekomendasi pilihan terbaik beserta persentase peluangnya.
- Jika TextDraw server gagal terbaca karena koneksi/lag, Anda bisa menekan tombol manual (**A, 2-10, J, Q, K**) di menu GUI untuk memasukkan kartu yang tertera di layar.
- Tekan **RESET HISTORY** setiap kali deck kartu kasino di-reshuffle/direset oleh dealer.

---

## ⚠️ Catatan & Disclaimer
* **Gunakan dengan Bijak:** Script ini dibuat untuk keperluan edukasi mengenai logika probabilitas matematika dalam pemrograman game. Penggunaan script modifikasi pihak ketiga di server publik sepenuhnya merupakan tanggung jawab masing-masing pemain.
