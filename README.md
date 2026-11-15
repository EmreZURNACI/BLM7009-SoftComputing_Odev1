# Prolog İle Basit EKG Uzman Sistemi

Kural tabanlı küçük bir uzman sistem. Kullanıcıya EKG ölçümlerini (kalp hızı, QRS süresi, ST genliği vb.) ve evet/hayır sorularını sorar, cevaplara göre olası ritim, ek bulgu ve uyarıları listeler.


## Gereksinimler

- [SWI-Prolog](https://www.swi-prolog.org/) (`swipl`)

## Çalıştırma

```
swipl main.pl
?- teshis.
```

Çıkmak için `halt.` yazın. Yeni bir hasta için `teshis.` komutunu tekrar çalıştırmanız yeterlidir; önceki cevaplar otomatik silinir.

## Dosya yapısı

| Dosya | Görevi |
|---|---|
| `facts.pl` | Fact'ler: sayısal ölçümler (`sayisal/5`), evet/hayır soruları (`soru/2`), durum adları ve açıklamaları (`ad/4`) |
| `rules.pl` | Kurallar: eşik kuralları, durum kuralları (`hastalik/1`), uyarı kuralları (`uyari/1`) |
| `main.pl` | Giriş noktası: soru sorma, cevapları saklama, rapor yazdırma |

## Nasıl çalışır?

1. `teshis/0` bütün `hastalik/1` ve `uyari/1` kurallarını dener.
2. Bir kural bir değere ihtiyaç duyduğunda (`deger/2`, `evet/1`, `hayir/1`) kullanıcıya sorulur, cevap saklanır. Aynı soru bir daha sorulmaz, gereksiz sorular hiç sorulmaz.
3. Sonuç iki grupta yazdırılır: **ritim değerlendirmeleri** ve **ek bulgular**. Altında belirti + EKG birleşiminden doğan **uyarılar** gelir.

### Girdi kuralları

- Sayısal sorularda geçerli aralık gösterilir. Aralık dışı değerler reddedilir ve soru tekrarlanır.
- Ondalık için nokta veya virgül kullanılabilir.
- Sayısal bir ölçümü bilmiyorsanız Enter ile geçebilirsiniz. O ölçüme dayanan kural tetiklenmez.
- Evet/hayır sorularında `e` / `h` (veya `evet` / `hayır`) girilir. Bu sorular boş geçilemez.

## Kural katmanları

`rules.pl` üç katmandan oluşur.

**1. Eşik kuralları** sayısal değeri bir bulguya çevirir:

| Bulgu | Koşul |
|---|---|
| `hiz_yuksek` | kalp hızı > 100 atım/dk |
| `hiz_normal` | 60 ≤ kalp hızı ≤ 100 |
| `hiz_dusuk` | kalp hızı < 60 |
| `hiz_cok_yuksek` | kalp hızı ≥ 150 |
| `dar_qrs` / `genis_qrs` | QRS < 120 ms / ≥ 120 ms |
| `pr_uzun` | PR > 200 ms |
| `qtc_uzun` | QTc > 460 ms |
| `st_yukselmis` | ST genliği ≥ +0.1 mV |
| `st_cokmus` | ST genliği ≤ -0.05 mV |
| `r_dusuk` | R genliği < 0.5 mV |

**2. Durum kuralları** (`hastalik/1`) bulguları birleştirir. Örnek:

```prolog
hastalik(sinus_tasikardisi) :-
    hiz_yuksek, evet(duzenli), evet(p_var), dar_qrs.
```

Desteklenen durumlar: sinüs taşikardisi, sinüs bradikardisi, normal sinüs ritmi, atriyal fibrilasyon, atriyal flutter, SVT, ventriküler taşikardi şüphesi, 1. derece AV blok, tam AV blok, uzamış QTc, ST elevasyonu, ST depresyonu, düşük voltaj.

**3. Uyarı kuralları** (`uyari/1`) durum ile belirtiyi birleştirir. Belirti sorusu yalnızca ilgili durum bulunduğunda sorulur:

```prolog
uyari('Ateş/enfeksiyon sinüs taşikardisine eşlik ediyor olabilir.') :-
    hastalik(sinus_tasikardisi), evet(ates).
```

## Genişletme

### Yeni sayısal ölçüm eklemek

1. `facts.pl`: ölçümü tanımlayın.
   ```prolog
   sayisal(p_genligi, 'mV', 0.0, 1.0, 'P dalgası genliği').
   ```
2. `rules.pl`: eşik kuralını yazın.
   ```prolog
   p_yuksek :- deger(p_genligi, G), G > 0.25.
   ```
3. `rules.pl`: bunu kullanan bir durum kuralı ekleyin.
4. `facts.pl`: durum için bir `ad/4` satırı ekleyin.

### Yeni evet/hayır sorusu veya belirti eklemek

```prolog
% facts.pl
soru(nezle, 'Nezle belirtisi var mı?').

% rules.pl
uyari('Enfeksiyon belirtileriyle birlikte sinüs taşikardisi.') :-
    hastalik(sinus_tasikardisi), evet(ates), evet(nezle).
```

### Yeni durum eklemek

```prolog
% facts.pl
ad(akut_koroner, bulgu, 'Akut koroner sendrom şüphesi', 'ST yükselmesi ve göğüs ağrısı.').

% rules.pl
hastalik(akut_koroner) :- st_yukselmis, evet(gogus_agrisi).
```

Eşikleri değiştirmek için yalnızca `rules.pl` içindeki eşik kurallarını düzenlemeniz yeterlidir.