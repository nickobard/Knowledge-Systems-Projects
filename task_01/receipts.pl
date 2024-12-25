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
  write('Nejsem schopen provést detekci.') ,nl.


% Knowledge Base
error('chyba č. 1 - neplatné IČO odběratele'):-
   \+ receipt_type('zjednodušený daňový doklad (paragon)'),
   has('udaje o odběrateli'),
   has('IČO odběratele'),
   \+ valid('IČO odběratele').


error('chyba č. 2 - chybí údaje o dodavateli (IČO,DIČ)'):-
    \+ has('IČO dodavetele');
    \+ (receipt_type('danovy doklad'), has('DIČ dodavatel')).


error('chyba č. 3 - chybí údaje of zápisu dodavatele do obchodního rejstříku'):-
    total_sum('> 10000'),
    has('udaje o dodavateli'),
    has('udaje o zapisu do obchodniho rejstriku').

error('chyba č. 4 - chybí údaje of zápisu dodavatele do živnostenského rejstříku'):-
    total_sum('> 10000'),
    has('udaje o dodavateli'),
    has('udaje o zapisu do živnostenského rejstriku').

error('chyba č. 5 - chybné datum vyhotovení účetního dokladu (30.2.2024)'):-
    has('datum vyhotoveni'),
    \+ valid('datum vyhotoveni').

error('chyba č. 6 - chybějící datum vyhotovení účetního dokladu'):-
    \+ has('datum vyhotoveni').

error('chyba č. 7 - jedná se o zjednodušený daňový doklad, ale celková částka je přes 10.000 Kč'):-
    receipt_type('zjednodušený daňový doklad (paragon)'),
    total_sum('> 10000').

error('chyba č. 8 - chybí celková částka'):-
    \+ has('total sum').

error('chyba č. 9 - chybná celková částka.'):-
    has('total sum'),
    \+ valid('total sum').

error('chyba č. 10 - chybí rekapitulace DPH.'):-
    receipt_type('danovy doklad'),
    \+ has('rekapitulace DPH'),
    \+ has('sazba DPH pro celkovou částku').

error('chyba č. 11 - chybná sazba DPH'):-
    has('učtované potraviny'),
    \+ has('sazba DPH 12%').

error('chyba č. 12 - neplatné IČO dodavatele.'):-
    has('udaje o dodavateli'),
    has('IČO dodavatele'),
    \+ valid('IČO dodavatele').

error('chyba č. 13 - chybí údaje o sazbě DPH'):-
    receipt_type('danovy doklad'),
    \+ has('sazba DPH').

% Knowledge Base

receipt_type('zjednodušený daňový doklad (paragon)'):-
    receipt_type('danovy doklad'),
    ask('Jedna se o: ', 'zjednoduseny danovy doklad').

receipt_type('danovy doklad'):-
    ask('Jedna se o: ', 'danovy doklad (dodavatel je platce DPH a ma vycislenou DPH)').

total_sum(Condition):-
    has('total sum'),
    ask('The receipt sum is: ', Condition).
has(Attribute):-
    ask('Has: ', Attribute).
valid(Attribute):-
    write('You need check validity of the attribute: '), write(Attribute),
    nl, nl,
    instructions(Attribute), nl,
    ask('Has valid: ', Attribute).

% Interface

% check if this questions was answered with `yes`
ask(Question, Value):-
    known(Question, Value, 'yes'), % check if such fact with `yes` answer exists in the KB.
    !. % if exists, stop backtracking and return success.

% check if this questions was answered with `no`
ask(Question, Value):-
    known(Question, Value, 'no'), % check if such fact with `yes` answer exists in the KB.
    !, fail. % if exists, stop backtracking and return failure.

ask(Question, Value):-
    repeat,
    write(Question), write(Value),
    write('? (yes or no): '),
    read(Answer),
        (
            Answer = 'yes' ->
                asserta(known(Question, Value, 'yes')), !;
            Answer = 'no' ->
                asserta(known(Question, Value, 'no')), !, fail;
            writeln('Invalid input, please answer yes or no.'), fail
        ).

% Instructions for validation

instructions('IČO odběratele'):-
    write("Here are instructions how to check the IČO."),
    nl.

instructions('IČO dodavatele'):-
    instructions('IČO odběratele').

instructions('datum vyhotoveni'):-
    write("Here are instructions how to check the datum vyhotoveni."),
    nl.

instructions('total sum'):-
    write("Here are instructions how to check the total sum."),
    nl.

% ----------------------
% Báze znalostí
% ----------------------
druh('babočka kopřivová'):-
  rad(motyli),
  skupina(motylicz),
  barva('oranžová se skvrnami').
druh('acraea acrita'):-
  rad(motyli),
  zije('Afrika'),
  barva('oranžová se skvrnami').
druh('bělopásek távolníkový'):-
  rad(motyli),
  skupina(motylicz),
  barva('černá s bílými skvrnami').
druh('modrásek jehlicovitý'):-
  rad(motyli),
  skupina(motylicz),
  barva('modrá').
druh('včela medonosná'):-
  rad(blanokridli),
  celed(vceloviti),
  obrana('bodnutí žihadlem').
druh('čmelák lesní'):-
  rad(blanokridli),
  celed(vceloviti),
  zije('Česká republika'),
  telo('zavalité').
druh('žlutnatka obecná'):-
  skupina(mouchy),
  barva('žlutá').
druh('bzučivka obecná'):-
  skupina(mouchy),
  barva('černá').
druh('slunéčko sedmitečné'):-
  kridla('krovky i blanitá'),
  celed(slunecka),
  barva('červená s černými tečkami'),
  pocettecek(sedm).


rad(motyli):-
  kridla('velká s šupinkami'),
  velikost('4-5 cm'),
  larva(housenka).
rad(dvoukridli):-
  kridla('blanitá'),
  kridlapocet('dvě').
rad(blanokridli):-
  kridla('blanitá'),
  kridlapocet('dva páry').

celed(slunecka):-
  dravost(hmyz).
celed(vceloviti):-
  zvuk('bzučí'),
  opylovac('opylovač').

skupina(mouchy):-
  rad(dvoukridli),
  zvuk('bzučí').
skupina(motylicz):-
  zije('Česká republika').

% ----------------------
% Uživatelské rozhraní
% ----------------------

% ziskani hodnoty atributu od uzivatele

kridlapocet(X):-dotaz('Má křídla: ', kridlapocet , X).
barva(X):- dotaz('Převládá na těle jedince barva ', barva, X).
velikost(X):- dotaz('Velikost jedince je ', velikost, X).
larva(X):- dotaz('Je larva ',larva, X).
zije(X):- dotaz('Žije v: ', zije, X).
obrana(X):- dotaz('Bráni se ', obrana, X).
zvuk(X):- dotaz('Zvuk: ', zvuk, X).
pocettecek(X):- dotaz('Počet teček je ',pocettecek, X).
telo(X):- dotaz('Má tělo ', telo,X).
dravost(X):-dotaz('Loví jiný ', dravy, X).
opylovac(X):-dotaz('Je to ', opyluje, X).
kridla(X):- dotaz('Má křídla: ', kridla, X).

% uzivatelske rozhrani, implementace klauzule dotaz

% otestuje, zda je zaznam odpovedi ano pro danou kombinaci atributu a hodnoty jiz v bazi faktu
dotaz(O,X,Y):-
    writeln('1. dotaz'),
  known(ano,O,X,Y),  !.

% otestuje, zda je zaznam odpovedi ne pro danou kombinac atribut a hodnoty jiz v bazi faktu
dotaz(O,X,Y):-
writeln('2. dotaz'),
  known(ne,O, X,Y),
  !, fail.

% otestuje, zda byl polozen stejny dotaz na stejny typ atributu, ale bez vazby na soucasnou hodnotu atributu a byla na nej odpoved ano.
dotaz(O,X,_):-
  writeln('3. dotaz'),
  known(ano,O,X,_),  !, fail.

% dotaz, zobrazi otazku a nacte hodnotu ze vstupu
dotaz(O,X,Y):-
writeln('4. dotaz'),
write(O), write(Y) , write(', X: ('), write(X), write(')'),
write('? (ano nebo ne): '),
read(A),
asserta(known(A,O,X,Y)),
A = ano.