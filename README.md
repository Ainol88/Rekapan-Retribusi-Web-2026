# ReL Rekapan Retribusi Web 2026

Aplikasi web responsif untuk pencatatan dan rekapitulasi retribusi UPT Pengelolaan Transportasi.

## Status

Tahap persiapan. Aplikasi akan mempertahankan APK Android yang sudah ada dan dikembangkan sebagai proyek web terpisah.

## Rencana teknologi

- Frontend web responsif
- Supabase Auth dan PostgreSQL untuk sinkronisasi data lintas perangkat
- Row Level Security (RLS) untuk membatasi akses data pengguna
- Hosting statis melalui GitHub Pages

## Keamanan

Jangan pernah menyimpan Supabase service-role key atau kata sandi di frontend/repository publik. Gunakan publishable/anon key dengan kebijakan RLS yang benar.
