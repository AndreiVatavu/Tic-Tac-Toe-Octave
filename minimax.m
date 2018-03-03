% Functia minimax returneaza
% 10 utilizatorul castiga
% -10 calculatorul castiga
% 0 daca mutarea va duce la un egal
% Trebuie sa calculez cea mai proasta mutare pentru adversar
% Mai multe detalii in readme

function [ score move ] = minimax ( board, player )
	
	% Verifica daca a castigat cineva
	winner = win ( board );
	% Daca ne aflam intr-un caz in care cineva castiga
	if ( winner )
		% Deoarece functia este una recursiva si la fiecare apelare
		% argumentul player alterneaza intre -1 si 1, cand se va gasi un
		% castigator, castigatorul va fi cel anterior nu cel curent, din acest
		% motiv voi inmulti 10 cu variabila player curenta pentru a sti cine a castigat
		score = 10 * player;
		return;
	endif

	move = 0;
	% Initializez scorul 
	score = 11 * player;
	k = 1;
	% Parcurg tabla de joc
	for i = 1 : 9
		% Daca in casuta curenta nu este nimic, se incearca mutarea
		if ( board(i) == 0 )
			% Realizez mutarea
			board(i) = player;
			% Aflu ce scor se obtine pentru mutarea curenta
			t_score = minimax(board, -1 * player );
			v(k) = t_score;
			k++;
			% Daca se obtine un scor mai bun se salveaza scorul si mutarea
			% Daca jucatorul curent este utilizatorul se calculeaza maximul
			% ( cea mai buna mutare pentru el )
			if ( player == -1 )
				if ( t_score > score )
					score = t_score;
					move = i;
				endif
			else
				% Daca jucatorul curent este AI-ul se calculeaza minimul
				% ( cea mai proasta mutare pentru utilizator )
				if ( t_score < score )
					score = t_score;
					move = i;
				endif
			endif
			%Refac tabla la loc
			board(i) = 0;
		endif
	endfor

	% Daca nu s-a gasit nici-o mutare castigatoare
	if ( move == 0 )
		score = 0;
		return;
	endif

endfunction