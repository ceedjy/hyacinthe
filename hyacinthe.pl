%%% INFO-501, TP3
%%% Cassiopée GOSSIN - Morgane FAREZ
%%%
%%% Lancez la "requête"
%%% jouer.
%%% pour commencer une partie !
%

% il faut déclarer les prédicats "dynamiques" qui vont être modifiés par le programme.
:- dynamic position/2, position_courante/1.

% on remet à jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).

% position du joueur. Ce prédicat sera modifié au fur et à mesure de la partie (avec `retract` et `assert`)

% on déclare des opérateurs, pour autoriser `prendre disque` au lieu de `prendre(disque)`
:- op(1000, fx, prendre).
:- op(1000, fx, lacher).
:- op(1000, fx, aller).
:- op(1000, fx, lancer).

% quelques raccourcis
n :- aller(nord).
s :- aller(sud).
e :- aller(est).
o :- aller(ouest).


% position de quelques objets
position(poeme, dans_arene).
position(disque, dans_arene).


% ramasser un objet
prendre(X) :-
        atom(X),
        position(X, en_main),
        write("Vous l'avez déjà !"), nl,
        !.

prendre(X) :-
        atom(X),
        position_courante(P),
        position(X, P),
        retract(position(X, P)),
        assert(position(X, en_main)),
        write("OK."), nl,
        !.

prendre(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici."), nl,
        fail.


% déplacements
aller(Direction) :-
        atom(Direction),
        position_courante(Ici),
        passage(Ici, Direction, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        regarder, !.


passage(entree_arene, nord, dans_arene):-
	write("Tu entres dans l'arène."),nl,
	write("Apollon te suit."), nl.

passage(entree_arene, ouest, dans_arene):-
	write("Tu rejoins Apollon et vous vous dirigez ensemble à l'intérieur de l'arène."),nl,
	write("Apollon :  Oh Hyacinthe ! Tu tombes à pique, je viens justement de finir un poème en ton honneur ! Attend je vais te le lire :"),nl,
	write("Oh resplandissant Hyacinthe, ta beauté n'a d'égal que ton talent ..."), nl,
	write("** Tu rougis en entendant ce poème de ce très bel homme **"),nl,
	write("Toi : C'est ... c'est magnifique ! Mais tu me le chanteras quand je serai devenu un héro."), nl.
	

passage(entree_arene, est, maison):-
	write("Tu décides de tout abandonner et de retourner chez toi."), nl,
	write("Tu as manqué à ton devoir de héro."),nl,
	fin.

passage(entree_arene, sud, maison):-
	write("Tu pars en vacances."), nl,
	write("Tu as manqué les JO !"),nl,
	fin.


passage(dans_arene, nord, terrain) :-
    position(disque, en_main).
    
passage(dans_arene, sud, terrain) :-
    position(disque, en_main).
    
passage(dans_arene, est, terrain) :-
    position(disque, en_main).

passage(dans_arene, ouest, terrain) :-
    position(disque, en_main).


passage(dans_arene, nord, terrain) :-
    position(poeme, en_main).
    
passage(dans_arene, sud, terrain) :-
    position(poeme, en_main).
    
passage(dans_arene, est, terrain) :-
    position(poeme, en_main).

passage(dans_arene, ouest, terrain) :-
    position(poeme, en_main).
    

position_courante(entree_arene).


% affiche les instructions du jeu
oracle :-
        nl,
        write("Les commandes doivent être données avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl,
        write("jouer.                   -- pour commencer une partie."), nl,
        write("n.  s.  e.  o.           -- pour aller dans cette direction (nord / sud / est / ouest)."), nl,
        write("aller(direction)         -- pour aller dans cette direction."), nl,
        write("lancer(objet, direction) -- pour lancer l'objet dans cette direction."), nl,
        write("prendre(objet).          -- pour prendre un objet."), nl,
        write("lacher(objet).           -- pour lacher un objet en votre possession."), nl,
        write("regarder.                -- pour regarder autour de vous."), nl,
        write("oracle.            	-- pour revoir ce message !."), nl,
        write("fin.                     -- pour terminer la partie et quitter."), nl,
        nl.


lancer(disque, nord):-
	position(disque, en_main),
	write("Quel beau lancé !"), nl,
	write("Oh non ! Un violent coup de vent fait dévier le disque !"),nl,
	write("Mais je connais ce vent ! C'est maléfique Zéphyr, dieu du vent !"),nl,
	write("La jalousie le ronge depuis des années, il ne peut supporter de te voir avec quelqu'un d'autre..."), nl,
	write("Hélas ! Le disque revient dans ta direction à grande vitesse. Il te frappe sur la tempe. En tant que mortel, tu décèdes sur le coup..."),nl,
	write("Dans un dernier souffle, tu vois Apollon se précipiter vers toi mais il est trop tard."),nl.
	
lancer(disque, sud):-
	position(disque, en_main),
	write("Quel beau lancé !"),nl,
	write("Oh non ! Il file droit vers la ville !"),nl,
	write("Hermes qui passait par là ce le prend en pleine poire."),nl,
	write("Tu es banni des JO pour ta dangerosité."),nl,
	write("Tu devras affronter la colère du dieu de la ruse pour le restant de tes jours."),nl,
	fin.
	
lancer(disque, est):-
	position(disque, en_main),
	write("Quel beau lancé !"),nl,
	write("Dommage pour la direction !"),nl,
	write("Mais attend, quelqu'un semble l'avoir arrêté."),nl,
	write("Zéphyr, le dieu du vent, a reçu ton disque en pleine tête."),nl,
	write("Tu es banni des JO pour ta dangerosité."),nl,
	fin.

lancer(disque, ouest):-
	position(disque, en_main),
	write("Quel beau lancé !"),nl,
	write("Oh non, il file tout droit vers Apollon !"),nl,
	write("Il n'a pas le temps de l'esquiver et c'est le drame !"),nl,
	write("Rongé par les remords, tu ne veux plus jamais revoir un disque de ta vie."),nl,
	fin.
	
	
lancer(poeme, nord):-
	position(poeme, en_main),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.
	
lancer(poeme, sud):-
	position(poeme, en_main),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.
	
lancer(poeme, est):-
	position(poeme, en_main),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.

lancer(poeme, ouest):-
	position(poeme, en_main),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.	


% DESCRIPTION DES OBJETS ET EMPLACEMENTS
% Objets

% Emplacements
decrire(entree_arene) :-
	write("Comme tous les matins, tu viens devant l'arène prêt pour l'entrainement du jour."), nl,
	write("Apollon t'attend à l'ouest de l'entrée."), nl,
	write("L'entrée principale se trouve au nord."), nl.


decrire(dans_arene) :-
	write("Tu es dans l'arène."), nl,
	write("Tu t'apprêtes à t'entraîner pour le lancer de disque."), nl,
	write("Sur la table devant toi se trouve un ('disque') et le ('poeme') d'Apollon."), nl.
	

decrire(terrain) :-
	write("Tu es au centre du terrain"),nl, 
	write("Tu prépares ton lancé."),nl,
	write("Au nord se trouve la cible."), nl,
	write("A l'ouest Apollon t'observe et t'encourage."),nl,
	write("Au sud se trouve une superbe vue sur la ville."),nl,
	write("Enfin à l'est une légère brise souffle sur ton visage."), nl,
	write("Tout le monde retient son souffle, maintenant lance jeune héro !"), nl.

% regarder autour de soi
regarder :-
        position_courante(Place),
        decrire(Place), nl.
       % lister_objets(Place), nl.

% lancer une nouvelle partie
jouer :-
	write("Bonjour Hyacinthe ! Bienvenu dans cette nouvelle quête."),nl,
	write("Je suis l'Oracle et je t'accompagnerais tout au long de ton aventure."), nl,
	write("Voilà des mois que tu t'entraînes avec Apollon pour les JO. Ton moment de gloire approche jeune héro !"),nl,
	write("Voici les actions que les Moires te permettent de faire : "),nl,
        oracle,
        regarder.
        
        
% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.
        
        

