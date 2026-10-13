# Çalışma düzeni

## Dosya yerleşimi

- `src/`: MATLAB parametre, giriş ve sonuç işleme scriptleri.
- `models/`: düzenlenebilir Simulink `.slx` modelleri.
- `data/`: tekrar kullanılan deney girdileri ve seçilmiş sonuç kayıtları.
- `figures/`: rapora veya karşılaştırmaya alınan grafikler.
- `reports/`: rapor PDF'leri.

Her ödev kendi numaralı klasöründe tutulur. Yeni ödev `assignments/assignment-04/` gibi sıradaki numarayı alır; ana README tablosuna eklenir. Ders slaytları, ZIP kopyaları, `.slxc` dosyaları ve `slprj/` önbelleği yüklenmez.

## Bir işi tamamlama

1. [İş listesinden](docs/ROADMAP.md) bir madde seçin veya GitHub issue açın.
2. Genişleyen işler için `hw1/...`, `hw2/...`, `hw3/...` veya `docs/...` adlı bir branch açın.
3. `setup_autonomous` ile ödevi seçin; çalışma alanını temizleyip parametreleri yeniden yükleyin.
4. Model ya da parametre değişikliği yaptıysanız etkilenen senaryoyu tekrar çalıştırın.
5. Giriş profili, solver, örnekleme süresi, kazanç/kovaryans ve bitiş süresini sonuçlarla birlikte kaydedin.
6. Seçilen grafikleri/verileri ilgili alt klasöre alın ve README'yi güncelleyin.
7. `git status` ve `git diff --stat` ile kapsamı gözden geçirip açıklayıcı bir commit oluşturun.

Örnek commit mesajları:

```text
hw1: add tire force comparison for aggressive steering
hw2: compare EKF measurement covariance settings
hw3: document Stanley gain tracking metrics
docs: update simulation instructions
```

Simulink modelleri ikili dosyalar olduğu için tek bir model üzerinde eşzamanlı değişikliklerden kaçının. Model değişikliğini, etkilediği davranışı ve doğrulama senaryosunu commit veya PR açıklamasında belirtin.
