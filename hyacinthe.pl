%%% INFO-501, TP3
%%% Cassiopée GOSSIN - Morgane FAREZ
%%%
%%% Lancez la "requête"
%%% jouer.
%%% pour commencer une partie !
%

% il faut déclarer les prédicats "dynamiques" qui vont être modifiés par le programme.
:- dynamic position/2, position_courante/1, epreuve/2.

% on remet à jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).

% position du joueur. Ce prédicat sera modifié au fur et à mesure de la partie (avec `retract` et `assert`)
position_courante(entree_arene).

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
position(lourde_chaussure, cours_forest).
position(petite_chaussure, cours_forest).
position(chaussure_hermes, ruelle).
position(disque_bois, arene_enfer).
position(disque_acier, arene_enfer).
position(disque_apollon, arene_enfer).

% epreuve des JO effectués ou non en fonction des directions des portes dans le palais. Evolue au long de la partie
epreuve(ouest, non).
epreuve(nord, non).
epreuve(est, non).

% changer l etat des epreuves : 
changer_epreuve(X) :-
        atom(X),
        epreuve(X, non),
        retract(epreuve(X, non)),
        assert(epreuve(X, oui)),
        !.

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

% les passages entre les différents lieux :
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

passage(dans_arene, X, terrain) :-
    position(disque, en_main).

passage(dans_arene, X, terrain) :-
    position(poeme, en_main).
    
passage(terrain, nord, devant_stix) :-
	write("Tu te réveille en sursaut."), nl
	write("Tu te relève avec difficulté."), nl.
	
passage(devant_stix, nord, maison) :-
	write("Tu as accepté ton sort."), nl,
	write("Tu rejoint Charon dans sa barque."), nl,
	write("Tu es jugé comme étant une bonne âme et va à Asphodèle."), nl
	write("Tu ne reverras plus jamais Apollon et tu ne deviendra jamais un héro."), nl, 
	fin.

passage(devant_stix, est, choix_stix) :- 
	write("Tu n'accepte pas ton sort."), nl,
	write("Toi : Hadès ! Attendez ! S'il vous plaît, il n'y a aucun moyen de retourner dans le monde des vivants ?"), nl, 
	write("Hadès : Tu veux vraiment eessayer de négocier avec moi ?"), nl, 
	write("Hadès : Très bien, tu as de la chance je suis d'humeur joueuse aujourd'hui."), nl, 
	write("Hadès : Faisons ainsi : Les JO des enfers vont bientôt avoir lieux. Si tu parviens à gagner les 3 épreuves alors tu remonteras à la surface."), nl, 
	write("Mais si tu échoue alors ton âme m'appartiendra pour toujours et tu seras condamné aux pire punitions du Tartar pour ton insolence."), nl, 
	write("Hadès : Alors mortel ? Que choisi tu ?"), nl, nl.
	
passage(choix_stix, nord, maison) :-
	write("Tu ne prend pas le rique."), nl, 
	write("Les punitions du Tartar sont les pires de toutes."), nl, 
	write("Tu rejoins Charon dans sa barque."), nl, 
	write("Tu es jugé et tu passes l'éternité à Asphodèle."), nl, 
	write("Tu ne reverra jamais Apollon et tu ne deviendra jamais un héro."), nl, 
	fin.
	
passage(choix_stix, est, palais) :-
	write("Toi : Je prend le risque !"), nl, 
	write("** Hadès s'esclaffe **"), nl, 
	write("Hadès : Très bien, qu'il en soit ainsi jeune mortel."), nl,
	write("Le dieu des mort vous téléporte tous les deux à son palais."), nl.
	
passage(palais, sud, maison) :-
	write("Tu tente de prendre la fuite !"), nl,
	write("Mais tu te fais rapidement rattrapé par Cerbère, le gardien des enfers."), nl, 
	write("Tu es jeté au Tartar sans plus d'explications."), nl, 
	write("Tu ne deviendra jamais un héro."), nl, 
	fin.
	
% aux enfers :
passage(palais, X, palais) :-
	epreuve(X, oui), 
	write("Tu as déja remporté cette épreuve."), nl.
	
passage(W, sud, palais) :-
	epreuve(ouest, oui), 
	epreuve(nord, oui), 
	epreuve(est, oui), 
	decrire(fin_trois_epreuve), !.
	
% passages pour la course 
passage(palais, ouest, asphodele) :-
	epreuve(ouest, non),
	write("Tu choisi l'épreuve de la course."), nl,
	write("Une nymphe t'acceuille et t'habille pour l'épreuve."), nl, 
	write("Mais les chaussures ne sont pas à ta taille."), nl, 
	write("Tu pars donc avec la nymphe à Asphodèle pour en trouver d'autres."), nl.
	
passage(asphodele, sud, asphodèle) :-
	write("Vous rentrez dans la boutique 'Tout ce que vous cherchez !'")
	write("Après près d'une heure de recherche, vous ne trouvez aucune chaussure dans cette boutique."), nl, 
	write("Vous décidez de sortir de la boutique et d'aller chercher des chaussures ailleurs."), nl.
	
passage(asphodele, est, cours_forest) :-
	write("Vous rentrer dans la boutique 'Cours forest !'."), nl,
	write("Vous y trouvez une magnifique paire de chaussure parfaitement à ta taille mais particulièrement lourde."), nl, 
	write("Et vous trouvez une autre paire de chaussure un peu trop petite mais très légère."), nl, 
	write("Nymphe : Tu prends les quelles ?"), nl. 

passage(cours_forest, ouest, asphodele) :-
	write("Vous sortez de la boutique 'Cours Forest !'"), nl.
	
passage(asphodele, ouest, ruelle) :-
	write("Tu remarque une petite ruelle sombre à l'ouest et tu t'y engage."), nl, 
	write("La nymphe ne t'a pas vu t' eclipser."), 
	write("En fouillant un peu, tu trouve un vieux carton où dedans tu y trouve les chaussure volantes d'Hermès !"), nl,
	write("Tu les met aux pieds, et en plus elles sont parfaitement à ta taille ! "), nl,
	write("Tu vas pouvoir courir avec !"), nl,
	prendre(chaussure_hermes).
	
passage(asphodele, nord, piste) :-
	write("Vous vous dirigez vers la piste de course."), nl,
	write("L'épreuve va bientôt commencer."), nl.
	
passage(ruelle, est, asphodele) :-
	write("Tu retrouve la nymphe."), nl, 
	write("Elle n'a meme pas remarqué ton départ."), nl.
	
passage(ruelle, ouest, fin_parfaite) :-
	write("Tu décides de prendre la fuite en volant avec les chuassures d'hermès."), nl,
	write("Tu réussi à remonter dans le monde des vivants sans te faire remarquer."), nl. 

passage(piste, sud, palais) :-
	write("Tu retourne au palais en ayant remporté l'épreuve de la course !"), nl.

passage(piste, est, maison) :-  % un piege si le joueur tente d aller la ou il faut pas 
	write("Tu tente de prendre la fuite !"), nl,
	write("Mais tu te fais rapidement rattrapé par Cerbère, le gardien des enfers."), nl, 
	write("Tu es jeté au Tartar sans plus d'explications."), nl, 
	write("Tu ne deviendras jamais un héro et Apollon passera le restant de ses jours à hérer sans but dans le monde des vivants en espérant ton retour sans savoir que cela n'arrivera jamais."), nl, 
	fin.
	
% passages pour le lancer de disque 
passage(palais, nord, arene_enfer) :-
	epreuve(nord, non),
	write("Tu choisi l'épreuve du lancer de disque."), nl,
	write("Une nymphe t'acceuille et t'habille pour l'épreuve."), nl, 
	write("Vous sortez du palais et vous vous dirigez vers le lieux de l'épreuve."), nl.

% il ne peut pas partir sans avoir pris un disque
passage(arene_enfer, nord, terrain_enfer) :-
	position(disque_bois, en_main).

passage(arene_enfer, nord, terrain_enfer) :-
	position(disque_acier, en_main).
	
passage(arene_enfer, nord, terrain_enfer) :-
	position(disque_apollon, en_main).


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

% l instruction lancer :
% lancer dans_arene
lancer(disque, nord):-
	position(disque, en_main),
	position_courante(dans_arene),
	write("Quel beau lancé !"), nl,
	write("Oh non ! Un violent coup de vent fait dévier le disque !"),nl,
	write("Mais je connais ce vent ! C'est maléfique Zéphyr, dieu du vent !"),nl,
	write("La jalousie le ronge depuis des années, il ne peut supporter de te voir avec quelqu'un d'autre..."), nl,
	write("Hélas ! Le disque revient dans ta direction à grande vitesse. Il te frappe sur la tempe. En tant que mortel, tu décèdes sur le coup..."),nl,
	write("Dans un dernier souffle, tu vois Apollon se précipiter vers toi mais il est trop tard."),nl
	aller(nord).
	
lancer(disque, sud):-
	position(disque, en_main),
	position_courante(dans_arene),
	write("Quel beau lancé !"),nl,
	write("Oh non ! Il file droit vers la ville !"),nl,
	write("Hermes qui passait par là ce le prend en pleine poire."),nl,
	write("Tu es banni des JO pour ta dangerosité."),nl,
	write("Tu devras affronter la colère du dieu de la ruse pour le restant de tes jours."),nl,
	fin.
	
lancer(disque, est):-
	position(disque, en_main),
	position_courante(dans_arene),
	write("Quel beau lancé !"),nl,
	write("Dommage pour la direction !"),nl,
	write("Mais attend, quelqu'un semble l'avoir arrêté."),nl,
	write("Zéphyr, le dieu du vent, a reçu ton disque en pleine tête."),nl,
	write("Tu es banni des JO pour ta dangerosité."),nl,
	fin.

lancer(disque, ouest):-
	position(disque, en_main),
	position_courante(dans_arene),
	write("Quel beau lancé !"),nl,
	write("Oh non, il file tout droit vers Apollon !"),nl,
	write("Il n'a pas le temps de l'esquiver et c'est le drame !"),nl,
	write("Rongé par les remords, tu ne veux plus jamais revoir un disque de ta vie."),nl,
	fin.
	
lancer(poeme, nord):-
	position(poeme, en_main),
	position_courante(dans_arene),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.
	
lancer(poeme, sud):-
	position(poeme, en_main),
	position_courante(dans_arene),
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
	position_courante(dans_arene),
	write("Tu oses lancer le poème d'Apollon !"), nl,
	write("Apollon est offensé."),nl,
	write("Tu n'es plus son apprenti désormais."),nl,
	write("Impossible de participer aux JO à présent."),nl,
	fin.	

% lancer terrain_enfer
lancer(disque_apollon, ouest) :- % ouest car c'est la qu'est apollon dans la premiere arene 
	position(disque_apollon, en_main),
	position_courante(terrain_enfer),
	write("Tu tire à l'ouest avec le disque d'apollon."), nl, 
	write("Le disque part jusqu'au bout du terrain, à la limite des spectateurs."), nl, 
	write("La foule se lève et t'acclame."), nl, 
	write("C'était un très bon choix."), nl, 
	write("Personne n'arrive a faire mieux que toi."), nl, 
	write("Tu gagne haut la main cette épreuve."), nl,
	write("Pour te préparer à la suite, tu dois te rendre au palais qui se trouve au sud."), nl, 
	changer_epreuve(nord), !.
	
lancer(disque_bois, ouest) :-
	position(disque_bois, en_main),
	position_courante(terrain_enfer),
	write("Tu tire à l'ouest avec le disque en bois."), nl, 
	write("Le disque est beaucoup trop lourd et se plante dans le sol presque à tes pieds."), nl, 
	write("Comme si il voulait de lui même se planter dans le sol."), nl, 
	write("Ca sent la magie dans l'air."), nl, 
	write("Encore un coup du dieux des morts."), nl, 
	write("Tu perds cette épreuve."), nl,
	decrireFin.

lancer(disque_acier, ouest) :-
	position(X, en_main),
	position_courante(terrain_enfer),
	write("Tu tire à l'ouest avec le disque en acier."), nl, 
	write("Le disque est beaucoup trop léger et se plante dans un panier à fruits rempli de grenades."), nl, 
	write("Comme si il voulait de lui même rejoindre les fruits."), nl, 
	write("Ca sent la magie dans l'air."), nl, 
	write("Encore un coup du dieux des morts."), nl, 
	write("Tu perds cette épreuve."), nl,
	decrireFin.

lancer(X, est) :- 
	position(X, en_main),
	position_courante(terrain_enfer),
	write("Tu tire à l'est."), nl, 
	write("La foule est morte de rire."), nl, 
	write("Tu as clairement tiré du mauvais coté."), nl, 
	write("Ton lancé a une distance négative."), nl, 
	write("Tu perd l'épreuve en bon dernier."), nl,
	decrireFin.
	
lancer(X, nord) :-
	position(X, en_main),
	position_courante(terrain_enfer),
	write("Tu tire vers le nord."), nl, 
	write("Le disque file tout droit vers les spectateurs."), nl, 
	write("Hadès arrive juste au bon moment, juste avant que le disque ne touche quelqu'un."), nl, 
	write("Il est furieux que tu t'en ai pris a son peuple."), nl, 
	write("Tu es condamné aux pires tortures du Tartar pour cet affront."), nl, 
	write("Hadès parlera à Apollon de ce que tu as fait."), nl, :
	write("Apollon lui même maudit ton nom à présent."), nl, 
	fin.
	
lancer(X, sud) :-
	position(X, en_main),
	position_courante(terrain_enfer),
	write("Tu tire vers le nord."), nl, 
	write("Le disque file tout droit vers Perséphone."), nl, 
	write("Hadès intersepte le disque juste avant qu'il ne la touche."), nl, 
	write("Hadès n'attend Pas une seconde avant de te jetter au Tartar."), nl, 
	write("Tu n'aurais pas du attaquer sa reine."), nl, 
	write("Hadès veillera lui même à ce que tu souffres chaque jour pour cet affront."), nl, :
	fin.

% si il n'a pas l'objet en main
lancer(X, Y) :- 
	\+ position(X, en_main),
	write("Tu n'as pas cet objet en ta possession."), nl.


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
	
decrire(devant_stix) :- 
	write("Tu es devant le Styx."), nl, 
	write("Tu reconnais Hadès, le dieux des morts, et Charon qui t'attentent devant une barque."), nl,
	write("Hadès : Bonjour Hyacinthe. Tu es mort."), nl,
	write("Hadès : Ce n'est pas la peine de m'en vouloir, les Moires en ont décidés ainsi."), nl,
	write("Hadès : C'est dommage, tu allais devenir un héro. Mais c'est ainsi."), nl,
	write("Hadès : Maintenant va avec Charon, le jugement t'attend."), nl,
	write("Hadès part vers l'est. Charon t'attend au nord."), nl.
	
decrire(choix_stix) :-
	write("Charon t'attend toujours au nord, proche de sa barque."), nl, 
	write("Hadès se dirige vers son palais à l'est"), nl.
	
décrire(palais) :-
	write("Le palais est immense !"), nl, 
	write("Tu te retrouve dans une grande pièce circulaire avec trois portes devant toi."), nl, 
	write("A l'ouest se trouve la porte pour l'épreuve de la course."), nl, 
	write("Au nord se trouve la porte pour l'épreuve du lancer de disque."), nl, 
	write("A l'est se trouve la porte pour l'épreuve de la lutte."), nl.
	
decrire(asphodele) :- 
	write("Vous vous retrouvez dans une rue animée d'Asphodèle"), nl, 
	write("Au sud il y a une boutique 'Tout ce que vous cherchez !'."), nl, 
	write("A l'est se trouve une autre boutique 'Cours forest !'."), nl, 
	write("Au nord se trouve le reste de la rue pour aller à la piste de course.").
	
decrire(cours_forest) :-
	write("Le choix est difficile entre les ('lourde_chaussure') et les ('petite_chaussure')."), nl, 
	write("La sortie est à l'ouest."), nl.
	
decrire(ruelle) :-
	write("A l'est se trouve la rue animée où tu as laissé la nymphe."), nl.

decrire(piste) :-
	position(chaussure_hermes, en_main),
	write("Tu te place sur le départ avec les chuassures d'hermès aux pieds."), nl, 
	write("Les chaussures magiques sont parfaites et elles te font gagner la course haut la main."). 
	write("Pour te préparer à la suite, tu dois te rendre au palais qui se trouve au sud."), nl, 
	changer_epreuve(ouest), !.

decrire(piste) :-
	\+ position(chaussure_hermes, en_main),
	\+ position(petite_chaussure, en_main),
	position(lourde_chaussure, en_main),
	write("Tu te place sur le départ avec les lourdes chaussures aux pieds."), nl,
	write("Hélas elle te ralentissent énormément dans ta course et tu perd en arrivant à la deuxième place."), nl, 
	decrireFin, !.
	
decrire(piste) :-
	\+ position(chaussure_hermes, en_main),
	position(petite_chaussure, en_main),
	write("Tu te place sur le départ avec les petites chaussures aux pieds."), nl,
	write("Hélas elle te font mal aux pieds et courir devient difficile."), nl, 
	write("Tu perd en arrivant à la deuxième place."), nl, 
	decrireFin, !.
	
decrire(piste) :- 
	\+ position(chaussure_hermes, en_main),
	\+ position(petite_chaussure, en_main),
	\+ position(lourde_chaussure, en_main),
	write("Tu te place sur le départ avec auncune chaussure aux pieds."), nl,;
	write("Le public est hilare en te voyant pied nu."), nl, 
	write("Tu effectue la course sans aucune gène aux pieds."), nl, 
	write("Grâce à cela, tu gagne la course haut la main."), nl, 
	write("Pour te préparer à la prochaine épreuve, tu dois te rendre au palais qui se trouve au sud."), nl,
	changer_epreuve(ouest).
	
decrire(arene_enfer) :-
	write("Vous arrivez à l'arène."), nl, 
	write("On te demande de choisir un disque pour cette épreuve."), nl, 
	write("Devant toi il y a une grand table où il ne reste plus que trois disques :"), nl,
	write("Un dique en bois ('disque_bois') gravé avec un dessin d'une narcisse."), nl, 
	write("Un disque en acier ('disque_acier') gravé avec un dessin d'une grenade (le fruit)."), nl, 
	write("Et un disque que tu reconnais au premier regard avec un soleil gravé, le disque d'apollon ('disque_apollon')"), nl, 
	write("exactement comme celui qui a mis fin a tes jours ..."), nl, 
	write("Tu remarque un peu de sang séché dessus. Encore un coup sordide du dieu des morts."), nl, 
	write("Dépèche toi de choisir, la foule t'attend au nord."), nl.

decrire(terrain_enfer) :- 
	write("Tu vas te placer au centre du terrain pour ton lancer."), nl, 
	write("Tu as un air de déjà vu."), nl,
	write("Au nord la foule t'acclame."), nl, 
	write("Au sud, parmi la foule tu remaque le roi Hadès et la reine Perséphone qui t'observent avec malice."), nl, 
	write("Cela t'inquiète, il a surement un piège."), nl, 
	write("Tu es le premier à tirer de tous ceux qui participent."), nl, 
	write("Il n'y a aucune indication de vers où il faut faire ton lancer."), nl, 
	write("A l'est et à l'ouest le terrain est exactement le même."), nl, 
	write("Tu regarde Hadès, son sourir s'élargie."), nl, 
	write("Il va falloir compter sur la chance pour ce coup là."), nl, 
	write("Tout le monde attend. Lance futur héro !"), nl.

% description des fins suivant le nombre d épreuve réussi 
% aucune epreuve reussi 
decrireFin :-
	epreuve(ouest, non),
	epreuve(nord, non),
	epreuve(est, non),
	write("Hadès t'avais prévenu. Tu es jeté au Tartar."), nl, 
	write("Tu ne reverra plus jamais Apollon et tu ne deviendra jamais un héro."), nl,
	fin, !.
	
% une epreuve reussi 
decrireFin :-
	epreuve(ouest, X),
	epreuve(nord, Y),
	epreuve(est, Z),
	(X == oui /\ Y == Z == non) \/ (Y == oui /\ X == Z == non) \/ (Z == oui /\ Y == X == non), % voir si ça marche 
	write("Hadès t'avais prévenu. Tu es jeté au Tartar."), nl, 
	write("Tu ne reverra plus jamais Apollon et tu ne deviendra jamais un héro."), nl,
	fin, !.

% deux epreuve reussi 
decrireFin :-
	epreuve(ouest, X),
	epreuve(nord, Y),
	epreuve(est, Z),
	(X == non /\ Y == Z == oui) \/ (Y == non /\ X == Z == oui) \/ (Z == non /\ Y == X == oui), % voir si ça marche 
	write("Hadès t'avais prévenu. Tu ne remonteras pas à la surface."), nl, 
	write("Cependant il sait lêtre clément. Tu ne finira pas au Tartar mais a Asphodèle."), nl, 
	write("Tu ne reverra plus jamais Apollon et tu ne deviendra jamais un héro."), nl,
	fin, !.

% trois epreuve reussi
decrire(fin_trois_epreuve) :-
	write("Tu retourne au palais."), nl, 
	write("Hadès t'y attend pour te faire remonter à la surface comme promis."), nl, 
	decrire(fin_parfaite).

% description de la bonne fin (trois epreuve reussi ou autre fin avec passage secret)
decrire(fin_parfaite) :- 
	write("Tu retrouve Apollon dans l'arène, au même endroit où tu es décédé. Il a l'air totalemnt vide."), nl,
	write("Tu te rapproche doucement de lui et met une main sur son épaule."), nl, 
	write("Ses yeux s'illuminent en te voyant. Il se lève d'un bond et saute dans tes bras pour te serrer très fort contre lui."), nl, 
	write("Quelques mois plus tard, tu participes aux JO et tu les remportent haut la main."), nl, 
	write("Toutes mes félicitations Hyacinthe !"), nl,
	write("Tu as réussi à devenir un héro et tu passeras le restant de tes jours avec l'homme de ta vie."), nl,
	write("Et cette fois si, même la mort elle même ne pourra pas vous séparer."), nl, 
	fin.

% regarder autour de soi
regarder :-
        position_courante(Place),
        decrire(Place), nl.

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
        
        

