# -------------------------------------------------------------------------
#
#  BI-ZNS: Šablona pro úlohu Inferenční systém s dopředným řetězením
#  (c) 2022 Ladislava Smítková Janků <ladislava.smitkova@fit.cvut.cz>
#
# -------------------------------------------------------------------------

import parser
import tfact
import truleitem
import trule
import itertools


def substitutions(atoms: list[str], rule: trule.TRule):
    variables = rule._listOfArguments
    atoms_combinations = itertools.product(atoms, len(variables))
    for combination in atoms_combinations:
        theta = {x: y for x, y in zip(variables, combination)}
        yield theta


def has_variable(x: tfact.TFact):
    pass


def unify(x, y, substitutions):
    """
     Unify algorithm, simplified for this task.
    """
    pass


def solve(facts: list[tfact.TFact], rules: list[trule.TRule], atoms):
    # ======================================================================
    # Zde doplňte vhodný kód, který provede doplnění faktů v seznamu facts.
    # Seznam rules obsahuje pravidla a vektor atoms seznam všech atomů.
    # Po dokončení této procedury musí být v seznamu facts všechny fakty,
    # které lze podle daných pravidel odvodit.
    # Při implementaci se nemusíte omezovat pouze na tuto funkci. Pokud se
    # vám to hodí, upravte si (třeba v zájmu unifikace) i třídu TRule.
    # ======================================================================
    while True:
        new = []
        for rule in rules:
            thetas = substitutions(atoms, rule)
            for theta in thetas:
                q = rule.evaluate(args=theta, facts=facts)
                if q is None:
                    continue
                # if our consequent (with applied substitution theta) doesn't unify with any of the existing and new facts,
                # then the list contains only TRUE values. The all() checks if all are TRUE, then the new fact q can be added
                # to KB without problem that it may unify with some other fact.
                if all([unify(q, fact) is None for fact in facts + new]):
                    new.append(q)
        # First iteration, where we checked every rule, if we can infer some new facts.
        # If there are new facts inferred, then add them to know facts. Start over because with new facts
        # we can go again through each rule from the beginning and infer new facts.
        # Otherwise, if there are no new facts after whole iteration, it is pointless to continue, next iteration
        # will not infer new facts. Break from the while loop.
        if len(new) != 0:
            facts = facts + new
        else:
            break


"""
    Často kladené otázky
     --------------------

Jak přidám fakt?

	facts.append( tfact.TFact('zvire(slon)'))

Jak projdu (a vypíšu) všecha pravidla uložená ve vektoru rules?

	for rule in rules:
		rule.print()
		print()


Jak zjistím počet argumentů pravidla?

	numOfRuleArgs = rules[0].argNum()
	print( numOfRuleArgs)

Jak vyhodnotím pravidlo ?

	rule = rules[0]
	argNames = ['tony','abe']
	newFact = rule.evaluate( argNames, facts)
	if newFact is None:
		print("None.")
	else:
		newFact.print()
		print()

    Pokud je newFact None, potom nelze pravidlo vyhodnotit.
    V opačném případě je vrácen důsledek pravidla.
    Parametr argNames obsahuje vektor s dosazovanými atomy.
    Parametr facts obsahuje všechny doposud známé fakty.

Jak porovnám dva fakty?

	print( f.compare(f))	# napíše True

    Porovnává se název faktů i názvy jejich parametrů.

Jak jsou pravidla v paměti organizovaná?

    Všechna pravidla jsou uložena v seznamu instancí třídy TRule.
    Každé pravidlo (třída TRule) obsahuje seznam instancí třídy TRuleItem.
    Tento seznam vytvořil parser tak, aby namodeloval chování pravidla.
    Zjednodušeně řečeno se jedná o sekvenci faktů a operací. Tato sekvence
    se prochází při každém vyhodnocování pravidla.

Jak zjistím seznam predikátů použitých v pravidle?

    Upravte si třídu TRule podle svých záměrů.
    Pro predikáty se používá třída TFact, stejně jako pro fakty.
    Jsou schované ve třídě TRuleItem v instancích, které mají nastavený
    typ na R_FACT. Typ zjistíte voláním TRuleItem.getType().
    
"""
