% =====================================================================
:- encoding(utf8).

% ---------------------------------------------------------------------
% Sayısal ölçümler: sayisal(Ad, Birim, Min, Max, SoruMetni)
% Min-Max, kullanıcı girişini doğrulamak için makul fizyolojik aralıktır.
% ---------------------------------------------------------------------
sayisal(kalp_hizi,  'atım/dk', 20,   300, 'Kalp hızı (frekans)').
sayisal(qrs_suresi, 'ms',      40,   300, 'QRS süresi').
sayisal(pr_araligi, 'ms',      60,   600, 'PR aralığı').
sayisal(qtc,        'ms',      250,  700, 'Düzeltilmiş QT (QTc)').
sayisal(st_genligi, 'mV',      -0.5, 0.5, 'ST segmenti genliği (yükselme +, çökme -)').
sayisal(r_genligi,  'mV',      0.1,  5.0, 'R dalgası genliği').

% ---------------------------------------------------------------------
% Evet/hayır soruları: soru(Ad, SoruMetni)
% ---------------------------------------------------------------------
% EKG gözlemleri
soru(duzenli,      'Ritim düzenli mi?').
soru(p_var,        'P dalgası görülüyor mu?').
soru(testere_disi, 'Testere dişi şeklinde dalgalar var mı?').
soru(disosiye,     'P dalgaları ile QRS birbirinden bağımsız mı?').
% Belirtiler
soru(carpinti,     'Çarpıntı hissi var mı?').
soru(gogus_agrisi, 'Göğüs ağrısı var mı?').
soru(bayilma,      'Bayılma / göz kararması oldu mu?').
soru(nefes_darligi,'Nefes darlığı var mı?').
soru(ates,         'Ateş / grip-nezle benzeri enfeksiyon belirtisi var mı?').

% ---------------------------------------------------------------------
% Durum tanımları: ad(Id, Tur, GörünenAd, Açıklama)
% Tur: ritim | bulgu
% ---------------------------------------------------------------------
ad(sinus_tasikardisi, ritim, 'Sinüs taşikardisi',
   'Düzenli, P dalgalı, dar QRS ve hız > 100.').
ad(sinus_bradikardisi, ritim, 'Sinüs bradikardisi',
   'Düzenli, P dalgalı, dar QRS ve hız < 60.').
ad(normal_sinus, ritim, 'Normal sinüs ritmi',
   'Düzenli, P dalgalı, dar QRS ve hız 60-100.').
ad(atriyal_fibrilasyon, ritim, 'Atriyal fibrilasyon',
   'Düzensiz ritim, P dalgası yok, dar QRS.').
ad(atriyal_flutter, ritim, 'Atriyal flutter',
   'P yerine testere dişi dalgaları, dar QRS.').
ad(svt, ritim, 'Supraventriküler taşikardi (SVT)',
   'Hız >= 150, düzenli, P yok, testere dişi yok, dar QRS.').
ad(ventrikuler_tasikardi, ritim, 'Ventriküler taşikardi şüphesi',
   'Düzenli, geniş QRS (>= 120 ms) ve hız > 100.').
ad(birinci_derece_av_blok, ritim, '1. derece AV blok',
   'P dalgası var ve PR > 200 ms.').
ad(tam_av_blok, ritim, 'Tam (3. derece) AV blok',
   'Hız < 60, P dalgası var ve P ile QRS birbirinden bağımsız.').
ad(uzamis_qtc, bulgu, 'Uzamış QTc',
   'QTc > 460 ms.').
ad(st_elevasyonu, bulgu, 'ST elevasyonu',
   'ST genliği >= +0.1 mV.').
ad(st_depresyonu, bulgu, 'ST depresyonu',
   'ST genliği <= -0.05 mV.').
ad(dusuk_voltaj, bulgu, 'Düşük voltaj',
   'R dalgası genliği < 0.5 mV.').
