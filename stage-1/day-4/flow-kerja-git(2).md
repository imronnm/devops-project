# Cara Kerja Git: Flow yang Gampang Dipahami
![git](assets/images/github-flow.png) <br>

Bayangin kamu lagi ngerjain project bareng temen-temen. Setiap kali kamu ngerjain sesuatu, Git itu kerja di belakang layar buat bantu kamu nge-track semua perubahan. Ini dia flow sederhananya:

1. **Bikin Project Baru (Repository)**  
   Anggap ini kayak kamu bikin folder baru di laptop buat nyimpen semua file project kamu. Git bakal nge-track semua file yang ada di folder ini.

2. **Tambah File (Staging)**  
   Waktu kamu nambahin file atau ngerjain perubahan di file yang udah ada, kamu siapin file itu buat di-save sama Git. Di sini Git kayak ngumpulin dulu semua perubahan yang udah kamu siapin, tapi belum bener-bener di-save.

3. **Save Perubahan (Commit)**  
   Kalau kamu udah yakin sama perubahan yang kamu lakuin, kamu bisa "commit". Ini ibarat kamu nge-save perubahan ke dalam catatan Git. Jadi, setiap commit itu kayak satu halaman di buku catatan yang nyatet apa aja yang berubah.

4. **Liat Riwayat Perubahan (Log)**  
   Kamu bisa kapan aja liat daftar commit yang udah kamu bikin. Ini ngebantu kamu buat inget perubahan apa yang udah pernah kamu lakuin, siapa yang ngerjain, dan kapan dilakuin.

5. **Bikin Versi Baru (Branch)**  
   Misalnya kamu pengen coba fitur baru tapi nggak mau ngacak-ngacak project utama, kamu bisa bikin cabang baru (branch). Ini kayak kamu bikin salinan project, tapi masih terhubung sama project utama. Kalau udah beres dan kamu suka, kamu bisa ngegabungin lagi ke project utama.

6. **Gabungin Perubahan (Merge)**  
   Kalau fitur baru di branch udah siap, kamu bisa gabungin (merge) perubahan itu ke project utama. Ini kayak kamu balik nyatuin cabang tadi ke project utama, jadi semua perubahan aman terintegrasi.

7. **Balik ke Versi Sebelumnya (Checkout)**  
   Kalau ada yang salah atau kamu mau liat versi lama, kamu bisa kapan aja balik ke commit yang lebih lama. Ini ibarat kamu buka halaman-halaman sebelumnya di buku catatan Git.

## Contoh Kasus

Bayangin kamu sama temen-temen lagi bikin website:

- **Hari 1**: Kamu commit tampilan awal website.
- **Hari 2**: Temen kamu commit fitur login.
- **Hari 3**: Kamu bikin branch buat coba desain baru tanpa ngacak-ngacak desain lama.
- **Hari 4**: Desain baru oke, kamu merge ke project utama.
- **Hari 5**: Ada bug, kamu balik ke commit sebelumnya buat cek apa yang salah.

Git bikin kerjaan kayak gini jadi teratur dan gampang buat dikelola.

## Kesimpulan
Git itu bikin proses ngoding jadi lebih gampang dan teratur. Dari nyimpen perubahan, liat riwayat, sampe coba-coba fitur baru tanpa takut ngerusak project utama, semua bisa diatur dengan flow Git yang simpel ini.
