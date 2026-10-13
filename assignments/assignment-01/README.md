# Ödev 1 — araç dinamiği modeli

Doğrusal olmayan bisiklet araç modeli; boyuna ve yanal dinamikler, tekerlek kayması, lastik kuvvetlerinin doyumu ve farklı girişlerin yörüngeye etkisi. [Teslim raporu](reports/Autonomous_Vehicles_HW1.pdf) ve [grafikler](figures/) birlikte saklanır.

| Dosya | Görev |
| --- | --- |
| `models/hw1_model.slx` | Araç, tekerlek ve lastik alt modellerini içeren Simulink modeli |
| `src/parameters.m` | Kütle, geometri, lastik, sürtünme ve kuvvet sınırları |
| `src/sample_input.m` | 44 saniyelik nominal direksiyon ve tork profili |
| `src/sample_input_b.m` | 24 saniyelik agresif giriş profili |
| `src/sonuc.m` | `out` simülasyon çıktısından temel yörünge, konum, yaw ve hız grafikleri |
| `src/test.m` | `out` içindeki lastik, kayma ve kuvvet sinyalleriyle ayrıntılı tanı grafikleri; birim test değildir |

## Nominal deney

Repo kökünden:

```matlab
clear;
setup_autonomous('hw1');
parameters;
sample_input;
out = sim('hw1_model', 'StopTime', '44');
sonuc;
test;
```

## Agresif giriş deneyi

```matlab
clear;
setup_autonomous('hw1');
parameters;
sample_input_b;
out = sim('hw1_model', 'StopTime', '24');
sonuc;
test;
```

Modelin saklanan varsayılan bitiş süresi `44 s` olduğu için ikinci deneyde `StopTime` açıkça `24` seçilir. `sim` çağrısındaki ayar `.slx` dosyasını değiştirmez.

Modelin solver ayarı `ode14x`, sabit adımı `0.001 s`'dir. Çıktılar `out.X_out`, `out.Y_out`, `out.psi_out`, `out.V_out` gibi alanlarda **Structure With Time** biçimindedir. `sonuc` ve `test` için önce simülasyon çalıştırılmalıdır.

`sonuc.m` içindeki bazı isteğe bağlı grafikler `out` yerine doğrudan çalışma alanındaki sinyal değişkenlerini arar. Ayrıntılı lastik/kayma incelemesi için `test.m` kullanın. Kaynaklar teslim sürümünden değiştirilmeden taşınmıştır; mevcut sonuçlara ilişkin kontroller [doğrulama kaydındadır](../../docs/VALIDATION.md).
