% FIT ČVUT
% BI-ZNS ZS2024
% Nikita Bardatskii
% Task 01 - Detekce chyb v paragonech v jazyce PROLOG

% hlavni telo programu, tento kod je zodpovedny za vypsani textu uvadejiciho uzivatele do problematiky, volani dotazu a vypis reseni

main :- identification.

identification:-
  retractall(known(_,_,_)),
  writeln('Vítá vás jednoduchý expertní systém pro detekci chyb v paragonech'),
    writeln('Prosím odpovídejte na dotazy ano nebo ne. Každou odpověď je třeba zakončit tečkou.'), nl,
  error(Error_type), nl,
  write('Popsaná chyba je: '), write(Error_type), write('.'), nl.
identification:-
  write('Nebyla detekovaná žádná chyba.') ,nl.


% Knowledge Base


error('chyba č. 1 - neplatné IČO odběratele'):-
   receipt_type('faktura'),
   has('udaje o odběrateli'),
   has('IČO odběratele'),
   invalid_ico('odběratele').

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

error('chyba č. 7 - jedná se o zjednodušený daňový doklad, ale celková částka je přes 10.000 Kč'):-
    receipt_type('zjednodušený daňový doklad (paragon)'),
    total_sum('> 10000').

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
    invalid_ico('dodavatele').

error('chyba č. 13 - chybí údaje o sazbě DPH'):-
    receipt_type('danovy doklad'),
    missing('sazba DPH').

receipt_type('faktura'):-
    known('receipt_type', 'paragon', 'ano' ), !, fail.

receipt_type('faktura'):-
    known('receipt_type', 'paragon', 'ne' ), !.

receipt_type('faktura'):-
    receipt_type('danovy doklad'),
    ask_with_instructions('Jedna se o:',
                          'faktura',
                          '(nezjednodušený daňový doklad)',
                          'receipt_type',
                          'paragon').

receipt_type('paragon'):-
    known('receipt_type', 'faktura', 'ano' ), !, fail.

receipt_type('paragon'):-
    known('receipt_type', 'faktura', 'ne' ), !.

receipt_type('paragon'):-
    receipt_type('danovy doklad'),
    ask_with_instructions('Jedna se o:',
                          'paragon',
                          '(zjednodušený daňový doklad)',
                          'receipt_type' ,
                          'paragon').

receipt_type('danovy doklad'):-
    has('udaje o dodavateli'),
    ask('Jedna se o:', 'danovy doklad', '(dodavatel je platce DPH, je uvedeno DIČ a ma vycislenou DPH)', 'receipt_type').


total_sum(Condition):-
    has('celkova částka'),
    ask('Pro celkovou částku platí: ', Condition, 'kc', 'total_sum').

has(Attribute):-
    known('missing', Attribute, 'ano'), !, fail.

has(Attribute):-
    known('missing', Attribute, 'ne'), !.

has(Attribute):-
    ask('Obsahuje:', Attribute, '','has').

missing(Attribute):-
    known('has', Attribute, 'ano'), !, fail.

missing(Attribute):-
    known('has', Attribute, 'ne'), !.

missing(Attribute):-
    ask('Chybi:', Attribute, '', 'missing').

invalid_ico('dodavatele'):-
    ask_ico_and_check('dodavatele').

invalid_ico('odběratele'):-
    ask_ico_and_check('odberatele').

invalid(Attribute):-
    ask_with_instructions('Je atribut chybný: ', Attribute, '', Attribute, Attribute).


% Interface

ask(Question, Value, Note, Predicate):-
    ask_with_instructions(Question, Value, Note, Predicate, 'no instructions').

% check if this questions was answered with `ano` (yes)
ask_with_instructions(_, Value, _, Predicate, _):-
    known(Predicate, Value, 'ano'), % check if such fact with `ano` answer exists in the KB.
    !. % if exists, stop backtracking and return success.

% check if this questions was answered with `ne` (no)
ask_with_instructions(_, Value, _, Predicate, _):-
    known(Predicate, Value, 'ne'), % check if such fact with `ne` answer exists in the KB.
    !, fail. % if exists, stop backtracking and return failure.

ask_with_instructions(Question, Value, Note, Predicate, Instructions):-
    instructions(Instructions),
    repeat,
    write(Question), write(' '), write(Value), write(' '), write(Note),
    write('? (ano nebo ne): '),
    read(Answer),
    (
        Answer = 'ano' ->
            asserta(known(Predicate, Value, 'ano')), !;
        Answer = 'ne' ->
            asserta(known(Predicate, Value, 'ne')), !, fail;
        writeln('Nesprávný vstup, prosím odpovězte ano nebo ne:'), fail
    ).

ask_ico_and_check(Which):-
    known('IČO', Which, 'valid'), !.

ask_ico_and_check(Which):-
    known('IČO', Which, 'invalid'), !, fail.

ask_ico_and_check(Which):-
    write('Napište IČO '), write(Which), write(':'), nl,
    read_ico(ICO),
    check_ico(ICO, Result),
    process_ico_check_result('IČO', Which, Result).

process_ico_check_result(Attribute, Which, 'valid') :-
    asserta(known(Attribute, Which, 'valid')), !, fail.
process_ico_check_result(Attribute, Which, 'invalid') :-
    asserta(known(Attribute, Which, 'invalid')), !.

% Utility functions

check_ico(ICO, Result) :-
    % Convert character codes to digits
    string_codes(ICO, Codes),
    maplist(code_digit, Codes, Digits),
    length(Digits, 8),
    Multipliers = [8,7,6,5,4,3,2],
    nth0(7, Digits, C),
    write('Control digit (C): '), write(C), nl,
    append(Check_sum_digits, [C], Digits),
    check_sum(Check_sum_digits, Multipliers, 0, Check_sum),
    write('Check sum: '), write(Check_sum), nl,
    Residual is Check_sum mod 11,
    write('Residual: '), write(Residual), nl,
    check_ico_control_digit(Residual, C),
    write('ICO: '), write(ICO), write(' je spravne.'), nl,
    Result = 'valid', !.

check_ico(ICO, Result) :-
    write('ICO: '), write(ICO), write(' je chybne.'), nl,
    Result = 'invalid', !.

check_ico_control_digit(0, 1) :- true.
check_ico_control_digit(10, 1) :- true.
check_ico_control_digit(1, 0) :- true.
check_ico_control_digit(Residual, Check_digit) :-
    Check_digit is 11 - Residual.

% Sums up the first 7 digits times the corresponding multipliers.
check_sum([], [], Accumulated_sum, Accumulated_sum).

check_sum([D|Ds], [M|Ms], Accumulated_sum, Output_check_sum) :-
    New_accumulated_sum is Accumulated_sum + D*M,
    check_sum(Ds, Ms, New_accumulated_sum, Output_check_sum).

% Helper: convert a char code to a digit (0..9). Fails if not a digit.
code_digit(Code, Digit) :-
    Code >= 0'0,
    Code =< 0'9,
    Digit is Code - 0'0.

read_ico(ICO):-
    repeat,
    read(ICO_input),
    convert_to_string(ICO_input, ICO), !.

% Input is a number, convert to string
convert_to_string(Input, String) :-
    number(Input),
    number_string(Input, String),
    is_eight_digit_number(String).

% Input is already a string
convert_to_string(Input, String) :-
    string(Input),
    String = Input,
    is_eight_digit_number(String).

% Input is an atom, convert to string
convert_to_string(Input, String) :-
    atom(Input),
    atom_string(Input, String),
    is_eight_digit_number(String).

is_eight_digit_number(Input):-
    string_chars(Input, Chars),
    length(Chars, 8),
    maplist(is_digit_char, Chars), !.

is_eight_digit_number(Input):-
    write('Vstup \''), write(Input), write('\' neni osmi-cislicovy identifikator.'), nl, fail.

% Helper predicate to check if a character is a digit
is_digit_char(Char) :-
    char_code(Char, Code),
    Code >= 0'0,
    Code =< 0'9.

process_result(Predicate, Value, 'ano'):-
    asserta(known(Predicate, Value, 'ano')), !.

process_result(Predicate, Value, 'ne'):-
    asserta(known(Predicate, Value, 'ne')), !, fail.

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
    writeln('Je potřeba zkontrolovat chybnost atributu: datum vyhotoveni'),
    nl,
    writeln('Jak ověřit chybnost/správnost datumu vyhotovení:'),
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

instructions('paragon'):-
    nl,
    writeln('Je potřeba zkontrolovat jestli se jedná o paragon (zjednodušený daňový doklad) nebo o fakturu.'),
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


