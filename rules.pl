:- encoding(utf8).

% ---------------------------------------------------------------------
% 1) Eşik kuralları
% ---------------------------------------------------------------------
hiz_cok_yuksek :- deger(kalp_hizi, H), H >= 150.
hiz_yuksek     :- deger(kalp_hizi, H), H > 100.
hiz_normal     :- deger(kalp_hizi, H), H >= 60, H =< 100.
hiz_dusuk      :- deger(kalp_hizi, H), H < 60.

dar_qrs   :- deger(qrs_suresi, Q), Q < 120.
genis_qrs :- deger(qrs_suresi, Q), Q >= 120.

pr_uzun       :- deger(pr_araligi, P), P > 200.
qtc_uzun      :- deger(qtc, Q), Q > 460.
st_yukselmis  :- deger(st_genligi, S), S >= 0.1.
st_cokmus     :- deger(st_genligi, S), S =< -0.05.
r_dusuk       :- deger(r_genligi, R), R < 0.5.

% ---------------------------------------------------------------------
% 2) Durum kuralları
% ---------------------------------------------------------------------
hastalik(sinus_tasikardisi) :-
    hiz_yuksek, evet(duzenli), evet(p_var), dar_qrs.

hastalik(sinus_bradikardisi) :-
    hiz_dusuk, evet(duzenli), evet(p_var), dar_qrs.

hastalik(normal_sinus) :-
    hiz_normal, evet(duzenli), evet(p_var), dar_qrs.

hastalik(atriyal_fibrilasyon) :-
    hayir(duzenli), hayir(p_var), dar_qrs.

hastalik(atriyal_flutter) :-
    hayir(p_var), evet(testere_disi), dar_qrs.

hastalik(svt) :-
    hiz_cok_yuksek, evet(duzenli), hayir(p_var), hayir(testere_disi), dar_qrs.

hastalik(ventrikuler_tasikardi) :-
    hiz_yuksek, evet(duzenli), genis_qrs.

hastalik(birinci_derece_av_blok) :-
    evet(p_var), pr_uzun.

hastalik(tam_av_blok) :-
    hiz_dusuk, evet(p_var), evet(disosiye).

hastalik(uzamis_qtc)    :- qtc_uzun.
hastalik(st_elevasyonu) :- st_yukselmis.
hastalik(st_depresyonu) :- st_cokmus.
hastalik(dusuk_voltaj)  :- r_dusuk.

% ---------------------------------------------------------------------
% 3) Uyarı kuralları (durum + belirti)
% ---------------------------------------------------------------------
uyari('ACİL: Bayılma ile birlikte geniş QRS taşikardisi.') :-
    hastalik(ventrikuler_tasikardi), evet(bayilma).

uyari('ACİL: Bayılma ile birlikte tam AV blok.') :-
    hastalik(tam_av_blok), evet(bayilma).

uyari('ACİL: Göğüs ağrısı ile birlikte ST elevasyonu (akut koroner sendrom şüphesi).') :-
    hastalik(st_elevasyonu), evet(gogus_agrisi).

uyari('Semptomatik atriyal fibrilasyon olasılığı (çarpıntı).') :-
    hastalik(atriyal_fibrilasyon), evet(carpinti).

uyari('Atriyal fibrilasyon ile nefes darlığı: hemodinamik etki açısından değerlendirilmeli.') :-
    hastalik(atriyal_fibrilasyon), evet(nefes_darligi).

uyari('Semptomatik SVT olasılığı (çarpıntı).') :-
    hastalik(svt), evet(carpinti).

uyari('Semptomatik bradikardi olasılığı (bayılma).') :-
    hastalik(sinus_bradikardisi), evet(bayilma).

uyari('Uzamış QTc ile bayılma: aritmi riski açısından değerlendirilmeli.') :-
    hastalik(uzamis_qtc), evet(bayilma).

uyari('Ateş/enfeksiyon sinüs taşikardisine eşlik ediyor olabilir.') :-
    hastalik(sinus_tasikardisi), evet(ates).
