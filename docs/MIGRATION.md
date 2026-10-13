# Taşıma kaydı

**Tarih:** 13 Ekim 2026

`KON-429E Autonomous Vehicles` ders klasöründeki kaynaklardan ayrı bir repo kopyası hazırlandı. Özgün kodlar, Simulink modelleri, raporlar ve grafikler değiştirilmedi veya silinmedi.

| Yerel kaynak | Repo konumu |
| --- | --- |
| `parameters.m`, `sample_input*.m`, `sonuc.m`, `test.m`, `hw1_model.slx` | `assignments/assignment-01/` |
| `ekf_*.m`, `plot_ekf_results_out.m`, `hw2_ekf_data.mat`, `hw2_model.slx` | `assignments/assignment-02/` |
| `params_hw3.m`, `hw3_plot.m`, `hw3_model.slx` | `assignments/assignment-03/` |
| Her ödevin raporu ve grafikleri | İlgili bölümün `reports/` ve `figures/` klasörleri |
| `simulink_model.png` | Ödev 2'nin EKF model şeması |

Üç teslim ZIP'indeki kod, model, veri ve raporlar kökteki dosyalarla SHA-256 karşılaştırmasında aynı bulundu. ZIP'lerde bulunan `.slxc` dosyaları da eşleşti; ancak bunlar yeniden üretilebilir önbellekler olduğu için repoya alınmadı.

Tek tek dosya yolları, boyutları ve ilk kopyalama özetleri [file-manifest.json](file-manifest.json) içindedir. Manifest ilk taşımanın kaydıdır; daha sonraki geliştirmelerin özetleriyle güncellenmesi gerekmez. Git satır sonlarını normalize ettiği için metin dosyalarının checkout sonrası byte özetleri değişebilir.

## Yerelde bırakılanlar

- `Week*.pdf`: ders slaytları.
- `KON429E___Homework_*.pdf`: öğretim elemanının ödev yönergeleri.
- Teslim ZIP'leri: içlerindeki kaynaklar ve raporlar ayrı dosyalar olarak taşındı.
- `slprj/`, `.slxc` ve diğer geçici MATLAB / Simulink dosyaları.

Repo düzeni için README dosyaları, `setup_autonomous.m`, `.gitignore`, `.gitattributes` ve iş kaydı eklendi. Algoritma, araç parametresi ve model solver ayarları değiştirilmedi.
