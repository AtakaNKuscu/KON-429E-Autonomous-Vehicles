# Doğrulama kaydı

**Tarih:** 13 Ekim 2026  
**Ortam:** MATLAB 25.2.0.3055257 (R2025b) Update 2, Simulink 25.2, Windows.

## Dosya bütünlüğü

- **40 dosya**, toplam **5.192.108 byte**, kaynak/hedef SHA-256 karşılaştırmasıyla doğrulandı.
- Üç teslim ZIP'indeki kodlar, modeller, raporlar ve EKF veri dosyası kökteki sürümleriyle aynı bulundu.
- `.slx` dosyaları ve algoritma kaynakları değiştirilmeden taşındı; yeni repo yerleşimi `setup_autonomous` üzerinden çalıştırıldı.

## MATLAB / Simulink çalıştırma kontrolleri

Üç model için **8 simülasyon** ve bunlara ait sonuç işleme scriptleri çalıştırıldı. Dört deney grubunun tamamı başarıyla tamamlandı:

| Deney | Simülasyon sayısı | Çalıştırma |
| --- | --- | --- |
| Ödev 1 nominal giriş | 1 | `parameters`, `sample_input`, `sim` (44 s), `sonuc`, `test` |
| Ödev 1 agresif giriş | 1 | `parameters`, `sample_input_b`, `sim` (24 s), `sonuc`, `test` |
| Ödev 2 EKF karşılaştırması | 2 | `ekf_init`, nominal `sim`, `plot_ekf_results_out`, `50R` ile `sim`, `ekf_comparison` |
| Ödev 3 Stanley kazanç taraması | 4 | `hw3_plot` → `params_hw3` ve `k = 0.1, 0.4, 1.0, 10.0` koşuları |

Ödev 1'in iki koşusunda X/Y/hız; EKF'nin iki koşusunda durum/kovaryans dizileri; Stanley taramasının son koşusunda X/Y/direksiyon dizileri için sonlu değer kontrolleri geçti. Grafik ve özet üretimi her deney grubunda tamamlandı.

## Sayısal gözlemler

Ödev 1 nominal koşusu `44 s`, agresif koşusu `24 s`'ye ulaştı. Nominal son konum yaklaşık `(-0.819757, 95.723794) m`, agresif son konum `(69.437374, -139.439044) m` oldu. Agresif koşuda lastik kuvvetleri modeldeki boyuna `±15000 N` ve yanal `±9000 N` sınırlarına ulaşıyor.

Ödev 2 konum RMSE'si nominal `R` ile **0.7662 m**, `50R` ile **0.3263 m** oldu. Bu, mevcut veri ve modeldeki karşılaştırmadır; daha büyük ölçüm kovaryansının her koşulda daha iyi olduğunu göstermez.

Ödev 3'ün script tarafından son waypoint'e göre kesilen sonuçları:

| Stanley kazancı k | Ön aks yanal hata RMS [m] | En büyük mutlak direksiyon [rad] |
| --- | --- | --- |
| 0.1 | 1.6176 | 0.5236 |
| 0.4 | 0.8461 | 0.5236 |
| 1.0 | 0.6090 | 0.5236 |
| 10.0 | 0.6995 | 0.5236 |

Bu dört koşuda en düşük RMS hata `k = 1.0` ile elde edildi; kazancı 10'a çıkarmak hatayı daha da düşürmedi. Tüm kazançlar için script son waypoint koşulunu buldu.

## Bilinen sınırlar

- EKF veri dosyasındaki `f` fonksiyon tutamacı, veriyi hazırlayan bilgisayardaki kaynak script yoluna referans veriyor. `load` sırasında bu kaynak bulunamadığına ilişkin MATLAB uyarısı oluşuyor. Taşınan model tahmin/güncelleme denklemlerini kendi MATLAB Function bloklarında içeriyor; bu tutamacı kullanmadan iki EKF koşusu tamamlandı. Orijinal veri dosyası değiştirilmedi.
- `sonuc.m` bazı isteğe bağlı tanı grafikleri için doğrudan çalışma alanı değişkenlerini arıyor. `test.m`, tanı sinyallerini `out` üzerinden okuduğu için iki Ödev 1 koşusunda ayrıntılı grafikler onunla da kontrol edildi.
- Mevcut raporlar ve JPG/PNG dosyaları önceki teslimlerden korunmuştur; bu kontrolde yeniden oluşturulmuş dosyalar gibi sunulmadı.
- Bu kayıt modelin çalışmasını ve dosya bağımlılıklarını doğrular. Farklı girişler, solver sürümleri veya tüm fiziksel geçerlilik aralığı için doğrulama iddiası içermez.
