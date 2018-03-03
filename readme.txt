
				Tic Tac Toe		


	Pentru inceput creez fereastra jocului, apoi afisez un text care ii indica
utilizatorului sa aleaga X sau 0. Creez doua butoane, unul pentru X si unul
pentru 0. La apasarea unuia dintre butoane este apelata functia "start_joc", iar
utilizatorul va juca cu simbolul ales.
	Functia "start_joc" afiseaza tabla de joc astfel: creeaza o matrice de
butoane si le pozitioneaza in asa fel incat sa rezulte tabla de joc. La apasarea
oricarui buton este apelata functia "Callback", care verifica daca se poate muta
in acea casuta, daca da, se va realiza mutarea, iar apoi va muta si AI-ul.
	La finalul partidei butonul de restart devine disponibil, iar la apasarea
acestuia va incepe o noua partida de joc.
	Daca utilizatorul doreste sa inchida aplicatia o poate face prin apasarea
butonului X. Daca va face asta va aparea o casuta de dialog ( setata de mine )
care il va intreba daca este sigur sa inchida aceasta fereastra, daca alege da
toate variabilele globale vor fi golite.
