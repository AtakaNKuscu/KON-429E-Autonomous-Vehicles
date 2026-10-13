# Ödev 3 — Stanley yol takibi

Sabit hızlı kinematik bisiklet modeliyle waypoint tabanlı yol takibi; Stanley kazancının yanal hata, yönelim hatası ve direksiyon komutuna etkisi. [Teslim raporu](reports/Autonomous_Vehicles_HW3.pdf) ve [karşılaştırma grafikleri](figures/) burada saklanır.

| Dosya | Görev |
| --- | --- |
| `models/hw3_model.slx` | Kinematik araç modeli ve Stanley denetleyicisi |
| `src/params_hw3.m` | Yol noktaları, dingil mesafesi, sabit hız ve nominal kazanç |
| `src/hw3_plot.m` | `k = 0.1, 0.4, 1.0, 10.0` için simülasyonları ve karşılaştırma grafiklerini üretir |

## Tek kazançla çalıştırma

Repo kökünden:

```matlab
clear;
setup_autonomous('hw3');
params_hw3;
out = sim('hw3_model');
```

Nominal değerler `L = 2.2 m`, `v = 5 m/s`, `k = 1.0`. Modelin solver ayarı `ode4`, sabit adımı `0.05 s`, bitiş süresi `120 s`'dir. Stanley denetleyicisi ön aks merkezini referans alır.

## Kazanç karşılaştırması

```matlab
setup_autonomous('hw3');
hw3_plot;
```

`hw3_plot` çalışma alanını temizler, `params_hw3` çağırır ve dört kazancın simülasyonunu başlatır. Yörünge, ön aks yanal hatası, yönelim hatası ve direksiyon açısını işler. `out.X_log`, `out.Y_log`, `out.seg_idx_log`, `out.e_front_log`, `out.theta_e_log`, `out.delta_log` sinyallerine bağımlıdır.

`figures/` altındaki JPG'ler önceki teslimden korunan çıktılardır. Script yeni figürleri ekranda oluşturur; arşiv görsellerini otomatik güncellemez. Kaynak ve model dosyaları özgün teslim sürümünden değiştirilmeden taşınmıştır.
