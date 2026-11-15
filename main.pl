% =====================================================================
:- encoding(utf8).
:- [facts, rules].

% cevap(Ad, Değer): Değer = sayı | bilinmiyor | evet | hayir
:- dynamic cevap/2.

% ---------------------------------------------------------------------
% Sayısal değer: ilk ihtiyaçta sorulur, sonra hafızadan okunur.
% Kullanıcı Enter ile geçerse deger/2 başarısız olur.
% ---------------------------------------------------------------------
deger(P, V) :-
    cevap(P, X), !,
    number(X), V = X.
deger(P, V) :-
    sayisal(P, Birim, Min, Max, Soru),
    sor_sayi(Soru, Birim, Min, Max, X),
    assertz(cevap(P, X)),
    number(X), V = X.

% ---------------------------------------------------------------------
% Evet/hayır: ilk ihtiyaçta sorulur, sonra hafızadan okunur.
% ---------------------------------------------------------------------
evet(B) :-
    cevap(B, E), !,
    E == evet.
evet(B) :-
    soru(B, Metin),
    sor_evet_hayir(Metin, E),
    assertz(cevap(B, E)),
    E == evet.

hayir(B) :- \+ evet(B).

% ---------------------------------------------------------------------
% Girdi yardımcıları
% ---------------------------------------------------------------------
oku_satir(S) :-
    flush_output,
    read_line_to_string(user_input, S0),
    (   S0 == end_of_file -> S = ""
    ;   normalize_space(string(S), S0)
    ).

virgul_nokta(S0, S) :-
    split_string(S0, ",", "", Parts),
    atomic_list_concat(Parts, '.', A),
    atom_string(A, S).

sor_sayi(Soru, Birim, Min, Max, X) :-
    repeat,
      format("~w [~w, ~w..~w, Enter=bilmiyorum]: ", [Soru, Birim, Min, Max]),
      oku_satir(S0),
      virgul_nokta(S0, S),
      (   S == ""
      ->  X = bilinmiyor, !
      ;   number_string(N, S), N >= Min, N =< Max
      ->  X = N, !
      ;   format("  ~w ile ~w arasında bir sayı girin.~n", [Min, Max]), fail
      ).

sor_evet_hayir(Metin, E) :-
    repeat,
      format("~w (e/h): ", [Metin]),
      oku_satir(S0),
      string_lower(S0, S),
      (   memberchk(S, ["e", "evet"])
      ->  E = evet, !
      ;   memberchk(S, ["h", "hayır", "hayir"])
      ->  E = hayir, !
      ;   writeln('  Lütfen e veya h girin.'), fail
      ).

% ---------------------------------------------------------------------
% Ana giriş
% ---------------------------------------------------------------------
teshis :-
    retractall(cevap(_, _)),
    nl, writeln('=== Basit EKG Uzman Sistemi (eğitim amaçlı) ==='),
    writeln('Sorular yalnızca gerektiğinde sorulur.'), nl,
    findall(H, hastalik(H), L),
    findall(M, uyari(M), Ms0), list_to_set(Ms0, Ms),
    nl, writeln('--- Sonuç ---'),
    yaz_degerler,
    yaz_grup(ritim, 'Olası ritim değerlendirmeleri', L),
    yaz_grup(bulgu, 'Ek bulgular', L),
    yaz_uyarilar(Ms),
    yaz_teshis(L).

yaz_degerler :-
    findall(P=V, ( sayisal(P, _, _, _, _), cevap(P, V), number(V) ), Ds),
    (   Ds == []
    ->  true
    ;   format("Girilen ölçümler: ~w~n", [Ds])
    ).

yaz_grup(Tur, Baslik, L) :-
    findall(Ad-Ac, ( member(H, L), ad(H, Tur, Ad, Ac) ), Items),
    (   Items == []
    ->  format("~w: yok (girilen bulgulara uyan kural bulunamadı)~n", [Baslik])
    ;   format("~w:~n", [Baslik]),
        forall(member(Ad-Ac, Items),
               format("  - ~w~n      (~w)~n", [Ad, Ac]))
    ).

yaz_uyarilar([]) :- !.
yaz_uyarilar(Ms) :-
    writeln('Uyarılar:'),
    forall(member(M, Ms), format("  ! ~w~n", [M])).

yaz_teshis(L) :-
    findall(Ad, ( member(H, L), ad(H, _, Ad, _) ), Adlar),
    (   Adlar == []
    ->  writeln('Teşhis: Belirlenemedi')
    ;   atomic_list_concat(Adlar, ', ', Metin),
        format("~nTeşhis: ~w~n", [Metin])
    ).