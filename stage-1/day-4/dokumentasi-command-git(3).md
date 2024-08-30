# Dokumentasi Command Git

## 1. `git init`
**Fungsi:** Buat mulai project baru dengan Git.

Ini kayak kamu bilang ke Git, "Oke, gue mau mulai nyimpen semua perubahan di folder ini." Setelah kamu jalankan command ini, Git bakal bikin folder tersembunyi yang isinya semua data yang dibutuhin buat nge-track perubahan.

**Contoh:**
```bash
git init
```
## 2. `git add`
**Fungsi:** Siapin file buat di-commit.

Command ini buat nge-mark file atau perubahan yang udah kamu lakuin, supaya Git tau apa aja yang bakal di-save nanti pas kamu commit.

**Contoh:**
```bash
git add nama_file.txt
```
Atau kalau mau nge-add semua file yang berubah:
```bash
git add .
```

## 3. git commit
**Fungsi:** Save perubahan yang udah kamu siapin.

Ini kayak kamu nge-save snapshot dari project kamu sekarang. Jangan lupa tambahin pesan (message) biar kamu inget apa yang berubah di commit ini.

**Contoh:**
```bash
git commit -m "isi pesan tentang perubahan yang udah dilakuin"
```

## 4. git status
**Fungsi:** Liat status dari file-file kamu.

Ini buat ngecek file mana aja yang udah berubah, mana yang udah di-add, dan mana yang belum.

**Contoh:**
```bash
git status
```

## 5. git log
**Fungsi:** Liat riwayat commit yang udah kamu lakuin.

Ini bakal nampilin daftar commit yang udah kamu bikin, lengkap sama pesannya, siapa yang commit, dan kapan.

**Contoh:**
```bash
git log
```

# 6. git branch
**Fungsi:** Buat nge-manage cabang (branch) di project kamu.

git branch aja bakal nampilin semua cabang yang ada.

**Contoh buat menampilkan semua branch yang ada:**
```bash
git branch
```

git branch nama branch buat bikin cabang baru.
**Contoh membuat branch baru:**
```bash
git branch nama-branch
```

# 7. git checkout
**Fungsi:** Pindah ke cabang lain atau balik ke commit tertentu.

git checkout nama_branch buat pindah ke cabang lain.

**Contoh:**
```bash
git checkout fitur-baru
```

git checkout commit_id buat balik ke commit lama.

**Contoh:**
```bash
git checkout commit_id
```


# 8. git merge
**Fungsi:** Gabungin perubahan dari satu branch ke branch lain.

Ini biasanya dipake buat gabungin branch yang udah dites ke branch utama (biasanya disebut main atau master).

**Contoh:**
```bash
git merge fitur-baru
```

# 9. git clone
**Fungsi:** Download project Git dari repository lain.

Misalnya kamu nemu project keren di GitHub, kamu bisa clone ke komputer kamu buat mulai kerja atau coba-coba.

**Contoh:**
```bash
git clone url_repository
```

# 10. git pull
**Fungsi:** Ambil perubahan terbaru dari remote repository ke local repository kamu.

Kalau ada temen yang udah nge-push perubahan ke repository online (misalnya di GitHub), kamu bisa ambil perubahan itu ke project kamu.

**Contoh:**
```bash
git pull
```

# 11. git push
**Fungsi:** Kirim perubahan dari local repository ke remote repository.

Ini kebalikannya git pull. Kamu nge-upload perubahan dari komputer kamu ke repository online.

**Contoh:**
```bash
git push origin main
```

# 12. git remote
**Fungsi:** Nge-manage remote repository yang terhubung ke project kamu.

git remote -v buat liat remote repository yang ada.

**Contoh:**
```bash
git remote -v
```

git remote add nama_remote url_repository buat nambah remote repository baru.

**Contoh:**
```bash
git remote add origin https://github.com/nama_user/nama_repo.git
```

# 13. git diff
**Fungsi:** Liat perbedaan antara file sebelum dan sesudah perubahan.

Kalau kamu pengen tau apa yang beda antara file yang udah diubah sama versi sebelumnya, command ini bakal nampilin bedanya.

**Contoh:**
```bash
git diff
```

# 14. git stash
**Fungsi:** Simpen sementara perubahan yang belum siap di-commit.

Kalau kamu lagi kerja dan tiba-tiba harus beralih ke task lain, kamu bisa stash dulu perubahan yang belum siap. Perubahannya bakal disimpen sementara dan bisa diambil lagi nanti.

**Contoh:**
```bash
git stash
```

Buat balikin perubahan yang udah di-stash:
**Contoh:**
```bash
git stash pop
``` 

# 15. git revert
**Fungsi:** Bikin commit baru yang ngebalikin perubahan dari commit sebelumnya.

Kalau kamu mau nge-cancel perubahan dari commit tertentu, tapi tetep pengen riwayatnya terekam, kamu bisa pake git revert.

**Contoh:**
```bash
git revert commit_id
```