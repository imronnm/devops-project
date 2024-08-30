# Study Case: Mengatasi Konflik Git (Teguh vs Reyhan)

## Kasusnya

Jadi, ada dua developer, Reyhan dan Teguh, yang lagi kerja bareng di project yang sama, dan mereka kebetulan ngedit file yang sama, yaitu `index.html`. Reyhan udah lebih dulu nge-push perubahan yang dia buat ke repository online (misalnya di GitHub), tapi Teguh belum nge-push perubahan yang dia buat. Waktu Teguh coba nge-push, ternyata Git nolak dan bilang ada konflik. Ini terjadi karena Git bingung, ada dua versi dari `index.html` yang berbeda dan harus digabungin.

## Kenapa Bisa Ada Konflik?

Git gak bisa otomatis gabungin perubahan Reyhan dan Teguh karena mereka berdua ngedit bagian yang sama di file `index.html`. Misalnya Reyhan benerin typo di deskripsi, sementara Teguh nambahin header baru. Karena perubahan mereka terjadi di bagian yang berbeda, Git gak tau mana yang harus dipake.

## Solusi: Mengatasi Konflik Git

Untuk menyelesaikan konflik ini, Teguh harus melakukan beberapa langkah berikut:

### 1. **Tarik Perubahan Terbaru dari Remote Repository (git pull)**

Teguh harus ngambil dulu perubahan yang udah dipush Reyhan ke repository online sebelum dia bisa nge-push perubahan dia sendiri.

**Command:**
```bash
git pull origin main
```

Ini bakal ngambil semua perubahan terbaru dari branch main di remote repository. Setelah itu, Git bakal kasih tau Teguh kalau ada konflik di index.html.

### 2. **Periksa Konflik di File**

Git bakal kasih tanda di index.html bagian mana aja yang ada konflik. Biasanya tampilannya kayak gini:

```bash
<<<<<<< HEAD
  <!-- Perubahan Teguh -->
  <header>Ini header baru dari Teguh</header>
=======
  <!-- Perubahan Reyhan -->
  <p>Deskripsi yang udah diperbaiki oleh Reyhan</p>
>>>>>>> commit-id
```

- Bagian atas (<<<<< HEAD) itu perubahan yang Teguh lakuin.
- Bagian bawah (======) itu perubahan yang Reyhan lakuin.
- ======= adalah pemisah antara kedua perubahan.

### 3. **Gabungkan Perubahan Secara Manual**

Teguh harus milih mana perubahan yang mau dipertahankan, atau bisa juga gabungin dua-duanya. Misalnya Teguh pengen nyimpen kedua perubahan:

```bash
  <!-- Gabungan perubahan Reyhan dan Teguh -->
  <header>Ini header baru dari Teguh</header>
  <p>Deskripsi yang udah diperbaiki oleh Reyhan</p>
```

Setelah selesai ngegabungin, Teguh harus hapus tanda-tanda konflik (<<<<<<<, =======, >>>>>>>) biar file-nya bersih.

### 4. **Tambahkan dan Commit Perubahan yang Sudah Digabung**

Setelah semua konflik diselesaikan, Teguh bisa nge-add lagi file index.html yang udah di-fix.

**Command**
```bash
git add index.html
git commit -m "fix: Resolve conflict between header adjustment and typo fix"
```
### 5. **Push Perubahan ke Repository**

Setelah konflik selesai dan udah di-commit, Teguh bisa nge-push lagi perubahan yang dia buat ke repository online.

Command:
```bash
git push origin main
```

Sekarang, perubahan Teguh udah berhasil di-push, dan repository online punya versi terbaru yang gabungan dari perubahan Teguh dan Reyhan.

## Kesimpulan

Konflik kayak gini sering kejadian kalau kerja bareng di project yang sama. Solusinya adalah tarik dulu perubahan terbaru, fix konfliknya, terus baru push lagi. Dengan Git, semua bisa dikelola dengan rapi, dan perubahan dari semua orang bisa digabungin dengan aman.

