% FIT ČVUT
% BI-ZNS ZS2024
% Nikita Bardatskii
% Task 01 - Detekce chyb v paragonech v jazyce PROLOG

% hlavni telo programu, tento kod je zodpovedny za vypsani textu uvadejiciho uzivatele do problematiky, volani dotazu a vypis reseni

main :- identifikace.

identifikace:-
  retractall(known(_,_,_)),
  writeln('Vítá vás jednoduchý expertní systém pro detekci chyb v paragonech'),
    writeln('Prosím odpovídejte na dotazy ano nebo ne. Každou odpověď je třeba zakončit tečkou.'), nl,
  error(Error_type), nl,
  write('Popsaná chyba je: '), write(Error_type), write('.'), nl.
identifikace:-
  write('Nebyla detekovaná žádná chyba.') ,nl.


% Knowledge Base

error('chyba č. 1 - neplatné IČO odběratele'):-
   receipt_type('faktura'),
   has('udaje o odběrateli'),
   has('IČO odběratele'),
   invalid('IČO odběratele').

error('chyba č. 7 - jedná se o zjednodušený daňový doklad, ale celková částka je přes 10.000 Kč'):-
    receipt_type('zjednodušený daňový doklad (paragon)'),
    total_sum('> 10000').

error('chyba č. 2 - chybí údaje o dodavateli (IČO,DIČ)'):-
    missing('udaje o dodavateli');
    missing('IČO dodavatele');
    missing('DIČ dodavatele').

error('chyba č. 3 - chybí údaje of zápisu dodavatele do obchodního rejstříku'):-
    total_sum('> 10000'),
    has('udaje o dodavateli'),
    missing('udaje o zapisu do obchodniho rejstriku').

error('chyba č. 4 - chybí údaje of zápisu dodavatele do živnostenského rejstříku'):-
    total_sum('> 10000'),
    has('udaje o dodavateli'),
    missing('udaje o zapisu do živnostenského rejstriku').

error('chyba č. 5 - chybné datum vyhotovení účetního dokladu (30.2.2024)'):-
    has('datum vyhotoveni'),
    invalid('datum vyhotoveni').

error('chyba č. 6 - chybějící datum vyhotovení účetního dokladu'):-
    missing('datum vyhotoveni').

error('chyba č. 8 - chybí celková částka'):-
    missing('celkova částka').

error('chyba č. 9 - chybná celková částka'):-
    has('celkova částka'),
    invalid('celkova částka').

error('chyba č. 10 - chybí rekapitulace DPH'):-
    receipt_type('danovy doklad'),
    missing('rekapitulace DPH'),
    missing('sazba DPH pro celkovou částku').

error('chyba č. 11 - chybná sazba DPH'):-
    has('učtované potraviny'),
    has('sazba DPH'),
    missing('sazba DPH 12%').

error('chyba č. 12 - neplatné IČO dodavatele'):-
    has('udaje o dodavateli'),
    has('IČO dodavatele'),
    invalid('IČO dodavatele').

error('chyba č. 13 - chybí údaje o sazbě DPH'):-
    receipt_type('danovy doklad'),
    missing('sazba DPH').

receipt_type('faktura'):-
    receipt_type('danovy doklad'),
    ask_with_instructions('Jedna se o: ', 'fakturu (nezjednodušený daňový doklad (paragon))', 'zjednodušený daňový doklad (paragon)').

receipt_type('zjednodušený daňový doklad (paragon)'):-
    receipt_type('danovy doklad'),
    ask_with_instructions('Jedna se o: ', 'zjednodušený daňový doklad (paragon)', 'zjednodušený daňový doklad (paragon)').

receipt_type('danovy doklad'):-
    has('udaje o dodavateli'),
    ask('Jedna se o: ', 'danovy doklad (dodavatel je platce DPH, je uvedeno DIČ a ma vycislenou DPH)').


total_sum(Condition):-
    has('celkova částka'),
    ask('Pro celkovou částku platí: ', Condition).

has(Attribute):-
    ask('Obsahuje: ', Attribute).

missing(Attribute):-
    ask('Chybi: ', Attribute).

invalid(Attribute):-
    ask_with_instructions('Je atribut nespravný: ', Attribute, Attribute).


% Interface


ask(Question, Value):-
    ask_with_instructions(Question, Value, 'no instructions').


% check if this questions was answered with `ano` (yes)
ask_with_instructions(Question, Value, _):-
    known(Question, Value, 'ano'), % check if such fact with `ano` answer exists in the KB.
    !. % if exists, stop backtracking and return success.

% check if this questions was answered with `ne` (no)
ask_with_instructions(Question, Value, _):-
    known(Question, Value, 'ne'), % check if such fact with `ne` answer exists in the KB.
    !, fail. % if exists, stop backtracking and return failure.

ask_with_instructions(Question, Value, Instructions):-
    instructions(Instructions),
    repeat,
    write(Question), write(Value),
    write('? (ano nebo ne): '),
    read(Answer),
        (
            Answer = 'ano' ->
                asserta(known(Question, Value, 'ano')), !;
            Answer = 'ne' ->
                asserta(known(Question, Value, 'ne')), !, fail;
            writeln('Nepsrávný vstup, prosím odpovězte: ano nebo ne:'), fail
        ).


% Instructions for validation

instructions('IČO odběratele'):-
    nl,
    writeln('Je potřeba zkontrolovat správnost atributu: IČO odběratele'),
    nl,
    writeln('Jak ověřit platnost identifikačního čísla (IČO):'),
    nl,
    writeln('1.- První až sedmou číslici (zleva) vynásobíme čísly 8, 7, 6, 5, 4, 3, 2 a součiny sečteme.'),
    writeln('2 - Spočítáme zbytek po dělení jedenácti: zbytek = soucet % 11'),
    writeln('3 - Pro poslední osmou číslici c musí platit:'),
    writeln('\ta) - je-li zbytek 0 nebo 10, pak c = 1'),
    writeln('\tb) - je-li zbytek 1, pak c = 0'),
    writeln('\tc) - v ostatních případech je c = 11 - zbytek'),
    nl.

instructions('IČO dodavatele'):-
    instructions('IČO odběratele').

instructions('datum vyhotoveni'):-
    nl,
    writeln('Je potřeba zkontrolovat správnost atributu: datum vyhotoveni'),
    nl,
    writeln('Jak ověřit správnost datumu vyhotovení:'),
    nl,
    writeln('Správný datum vyhotovení není v budoucnosti nebo v hluboké minulosti. Pro zjednodušení uvažujeme pouze rok 2024.'),
    nl.

instructions('celkova částka'):-
    nl,
    writeln('Je potřeba zkontrolovat správnost atributu: celkova částka'),
    nl,
    writeln('Jak ověřít správnost celkové částky:'),
    nl,
    writeln('Celková částka musí být stejná jako součet částek u položek uvedených na dokladu.'),
    nl.

instructions('zjednodušený daňový doklad (paragon)'):-
    nl,
    writeln('Je potřeba zkontrolovat jestli se jedná o zjednodušený daňový doklad (paragon)'),
    nl,
    writeln('Jak vypadá zjednodušený daňový doklad:'),
    nl,
    writeln('Daňový doklad lze vystavit (mimo vyjímky definované zákonem) jako zjednodušený daňový doklad, pokud celková částka za plnění na daňovém dokladu není vyšší než 10 000 Kč.'),
    writeln('Zákon určuje, že na zjednodušeném daňovém dokladu nemusí být:'),
    writeln('a) označení osoby, pro kterou se plnění uskutečňuje,'),
    writeln('b) daňové identifikační číslo osoby, pro kterou se plnění uskutečňuje,'),
    writeln('c) jednotkovou cenu bez daně a slevu, není-li obsažena v jednotkové ceně,'),
    writeln('d) základ daně,'),
    writeln('e) výši daně.'),
    nl.

instructions('no instructions').


