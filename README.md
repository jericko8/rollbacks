Berikut adalah README yang diperbarui dengan tautan lisensi MIT:

---

# Rollbacks Script for Airchain Node Monitoring

Script ini digunakan untuk memantau eror pada Node Airchain, dan melakukan rollback otomatis jika diperlukan.

## Error Handling

Beberapa error yang bisa ditangani untuk saat ini menggunakan script ini adalah:
- "Failed to Init VRF"
- "Failed to Validate VRF"
- "Switchyard client connection error"
- "» Failed to Transact Verify pod"
- "» Failed to get transaction by hash: not found"
- "RPC Erorr"

## Cara Menggunakan

1. Clone repositori ini:
   ```bash
   git clone https://github.com/jericko8/rollbacks.git
   ```

2. Berikan akses kepada file dengan perintah berikut:
   ```bash
   chmod +x ~/rollbacks/main.sh
   chmod +x ~/rollbacks/function.sh
   ```

3. Buat screen untuk menjalankan script:
   ```bash
   screen -S monitor
   ```

4. Jalankan script di dalam screen:
   ```bash
   ~/rollbacks/main.sh
   ```

5. Untuk keluar dari screen, gunakan kombinasi tombol `Ctrl + A + D`.

## Pembaruan Script

Script ini baru menangani 6 error yang ditemukan secara pribadi selama menjalankan node Airchain. Jika di kemudian hari ditemukan error yang berbeda, kode akan diupdate.

Untuk mendapatkan pembaruan kode, gunakan perintah berikut:
```bash
cd ~/rollbacks && git stash && git pull
```

Setelah mendapatkan pembaruan, berikan kembali akses kepada file dengan cara yang telah disebutkan di atas.

## Lisensi

Repositori ini dilindungi dengan lisensi [MIT](https://opensource.org/license/MIT).

---










