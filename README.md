# Lingkungan Pengembangan Odoo 20 (Docker)

Kebutuhan Odoo 20: Python 3.12+ dan PostgreSQL 16+ (sudah dipenuhi image ini).
Prasyarat di host: Docker + Docker Compose v2, make, git.

## Mulai cepat
    make build      # clone Odoo branch 20.0 + install dependensi (pertama kali agak lama)
    make up         # jalankan Odoo + PostgreSQL
    make initdb     # buat database odoo20_dev (opsional, bisa juga lewat web)
    make install MODULE=hello_dev
Buka http://localhost:8069 (master password: `admin`, lihat config/odoo.conf).

## Alur kerja harian
| Perintah | Fungsi |
|---|---|
| `make logs` | Lihat log |
| `make update MODULE=x` | Upgrade modul setelah ubah model/data |
| `make test MODULE=x` | Jalankan unit test modul di DB terpisah |
| `make scaffold MODULE=x` | Buat kerangka modul baru di `addons/` |
| `make shell` / `make psql` | Masuk container / psql |
| `make src` | Clone source Odoo ke `./odoo-src` untuk autocomplete IDE |
| `make debug` | Jalankan dengan debugpy (VS Code: "Attach ke Odoo") |

- Mode default `--dev=reload,xml`: perubahan file Python otomatis reload, perubahan XML view terbaca tanpa restart.
- Ubah model/field -> `make update MODULE=nama`. Ubah XML saja -> cukup refresh browser.
- Dependensi Python tambahan: masukkan ke Dockerfile (pip install) lalu `make build up`.
- Modul pihak ketiga (OCA, dsb.): taruh di `addons/` atau mount folder baru dan tambahkan ke `addons_path`.
- Jika `git clone --branch 20.0` gagal, cek nama branch di github.com/odoo/odoo, lalu set `ODOO_BRANCH` di `.env`.
