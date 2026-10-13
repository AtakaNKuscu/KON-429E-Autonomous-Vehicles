# Ödev 2 — Extended Kalman Filter

Kinematik bisiklet modeli ve gürültülü konum ölçümleriyle iki boyutlu konum/yönelim kestirimi. [Teslim raporu](reports/Autonomous_Vehicles_HW2.pdf), [EKF model şeması](figures/simulink_model.png) ve [sonuçlar](figures/) arşivlenmiştir.

| Dosya | Görev |
| --- | --- |
| `models/hw2_model.slx` | Ayrı prediction/update blokları içeren EKF modeli |
| `data/hw2_ekf_data.mat` | Ders verisi: gerçek durumlar, ölçümler, girişler ve kovaryanslar |
| `src/ekf_init.m` | Veriyi yükler; başlangıç durumunu, kovaryansı ve Simulink giriş zaman serilerini hazırlar |
| `src/plot_ekf_results_out.m` | `out.x_hat_log` ve `out.P_log` üzerinden grafikler, hata ölçütleri ve belirsizlik elipsleri |
| `src/ekf_comparison.m` | Önceden üretilmiş `out_normal` ve `out_largeR` çıktılarını karşılaştırır |

## Nominal deney

Repo kökünden:

```matlab
setup_autonomous('hw2');
ekf_init;
out = sim('hw2_model');
plot_ekf_results_out;
```

`ekf_init` çalışma alanını temizler. Model bitiş süresini verideki `T` değişkeninden, sabit adımı `dt` değişkeninden alır; ikisi de simülasyondan önce yüklenmelidir.

## Ölçüm kovaryansı karşılaştırması

Raporla aynı şekilde ikinci koşuda `R` 50 kat artırılır:

```matlab
setup_autonomous('hw2');
ekf_init;
R_original = R;
out_normal = sim('hw2_model');
R = 50 * R_original;
out_largeR = sim('hw2_model');
ekf_comparison;
R = R_original;
```

İki koşu arasında `ekf_init` yeniden çalıştırılmamalıdır: çalışma alanını temizleyerek `out_normal` çıktısını siler. `ekf_comparison` yalnızca mevcut çıktıları işler, simülasyonları başlatmaz. Karşılaştırma scripti veriyi tekrar yüklediğinden `R` değişkeni de nominal değerine döner.

`hw2_ekf_data.mat` ders kapsamında sağlanan giriş verisidir; deney sırasında üzerine yazılmaz. Çalıştırma ve sayısal sonuç kontrolleri [VALIDATION.md](../../docs/VALIDATION.md) içinde belirtilir.

Verinin içindeki eski `f` fonksiyon tutamacı yüklenirken üretici script bulunamadığı uyarısı görülebilir. Modelin kendi prediction/update blokları bu tutamacı kullanmadan çalışır; iki kovaryans koşusu yerel kontrolde tamamlanmıştır.
