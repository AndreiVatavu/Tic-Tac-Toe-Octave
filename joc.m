function [] = joc ()

	% Creez interfata
	f = figure( 'Name', 'X si 0', 'Visible','off', 'NumberTitle', 'off', ...
				'Position',[360,500,520,460], 'CloseRequestFcn',@my_closereq);

	% Alege X sau 0
	% Creez butoanele cu ajutorul carora jucatorul alege daca vrea sa fie cu X sau cu 0
	X = uicontrol ( 'Style','pushbutton', 'UserData', 'X', 'Position', ...
					[ 105, 180, 100, 100 ], 'fontsize', 50, 'String', 'X', ...
					'Callback',{@xCallback f} );
	O = uicontrol ( 'Style','pushbutton', 'UserData', '0', 'Position', ...
					[ 255, 180, 100, 100 ], 'fontsize', 50, 'String', '0', ...
					'Callback',{@oCallback f} );
					
	% Afisez un text la executia aplicatiei
	text = uicontrol ( 'Style', 'text', 'Position', [ 130, 310, 200, 40 ], ...
					'fontsize', 20, 'fontweight', 'bold', 'String', 'Choose X or 0' );

	% In text2 memorez scorul
	global text2;
	text2 = uicontrol ( 'Style', 'text', 'Position', [ 400, 100, 100, 140 ], ...
					'String', "SCORE:\n\nPlayer = 0\n AI = 0\nTies = 0" );
	
	% Setez figura sa fie vizibila
	set ( f, 'Visible', 'on' );
	
endfunction


% Daca a fost ales X
function xCallback ( f, source )
	
	start_joc ( f, 'X' );
	
endfunction

% Daca a fost ales 0
function oCallback ( f, source )
	
	start_joc ( f, '0' );

endfunction

% Functie care creeaza jocul
function start_joc ( f, c )
	
	% Variabilele in care memorez scorul
	global Player = 0;
	global AI = 0;
	global Ties = 0;

	% Matricea asociata tablei de joc
	% ( folosita la gasirea celei mai bune mutari a AI-ului )
	global board;
	board = zeros(3);
	% first_move specifica daca AI-ul face pentru prima data o mutare
	global first_move;
	first_move = 1;

	for i = 1 : 3
		for j = 1 : 3
			% Fiecare element al matricei "buton" este un buton
			% Creez fiecare buton si adaug proprietatile necesare
			buton(i, j) = uicontrol ( 'Style','pushbutton', 'Position', ...
					[ 80 + 100 * ( j - 1 ), 270 - 100 * ( i - 1 ), ...
					100, 100 ], 'fontsize', 50 );
		endfor
	endfor

	% Daca AI-ul este primul
	if ( c == '0' )
		pause(1);
		set ( buton(1), 'String', 'X')
		first_move = 0;
		board(1) = 1;
	endif
	
	% Creez butonul de restart
	restart = uicontrol ( 'Style', 'pushbutton', 'Position', [ 400, 295, 100, 50 ], ...
						'String', 'RESTART', 'Callback', {@Reset buton}, 'enable', 'off' );

	% Setez fiecarui buton din tabla de joc functia care trebuie executata la apasarea butonului
	% iar in 'Userdata' memorez X sau 0 ( depinde cu ce a ales jucatorul sa fie )
	set ( buton(1 : 3, 1 : 3), 'UserData', c, 'Callback',{@Callback buton f restart} );
	
	% Creez mesajele ce apar la finalul partidei
	global mesaj_final;
	mesaj_final = uicontrol ( 'Style', 'text',  'Position', [ 130, 390, 200, 40 ], 'fontsize', 20,  'Visible', 'off' );

endfunction	

	
% Functia care este executata la apasarea unui buton din tabla de joc
function Callback ( source, eventdata, buton, f, restart )
	
	global Player;
	global AI;
	global Ties;
	global text2;
	global board;
	global mesaj_final;

	% Extrag caracterul ( X sau 0 ) cu care joaca utilizatorul
	c = get ( source, 'Userdata' );

	% Verific daca in casuta curenta se afla ceva
	% Daca nu se afla nimic se adauga ceea ce a a ales utilizatorul
	a = get ( source, 'String' );
	if ( strcmp ( a, '' ) )

		%Mutarea jucatorului
		player_move ( source, buton, c );

		% Mutarea AI-ului

		% Aflu daca cineva a castigat sau daca este egalitate
		[winner, v] = win ( board );
		if ( winner == 0 )
			AI_move ( buton, c );
		endif
		
		% Aflu daca cineva a castigat sau daca este egalitate
		[winner, v] = win ( board );

		game_over ( f, buton, restart, v );

		% Daca a castigat cineva actualizez scorul
		if ( winner == -1 )
			Player = Player + 1;
			AI = AI + 0;
			set ( mesaj_final, 'String', 'AI CASTIGAT', 'Visible', 'on' );
		else
			if ( winner == 1 )
				Player = Player + 0;
				AI = AI + 1;
				set ( mesaj_final, 'String', 'AI PIERDUT :(', 'Visible', 'on' );
			endif
		endif
		
		% Daca este egalitate
		if ( v == -1 )
			set ( buton(1 : 3, 1 : 3), 'enable', 'off' );
			set ( restart, 'enable', 'on' );
			Ties = Ties + 1;
			set ( mesaj_final, 'String', 'EGALITATE', 'Visible', 'on' );
		endif
		
		set ( text2, 'String', [ "SCORE:\n\nPlayer = ", num2str(Player), ...
			"\n AI = ", num2str(AI), "\nTies = ", num2str(Ties) ] );

	endif
		
endfunction


function player_move ( source, buton, c )

	global board;

	% Adaug mutarea utilizatorului pe tabla de joc
	set ( source, 'String', c );

	% Adaug mutare si pe matricea asociata tablei de joc
	% Utilizator = -1
	% AI = 1
	for i = 1 : 9
		if ( buton(i) == source )
			board(i) = -1;
		endif
	endfor

endfunction

function AI_move ( buton, c )

	global board;
	global first_move;
	% Verific daca mai exista mutari posibile
	sw = 0;
	for i = 1 : 9
		if ( board(i) == 0 )
			sw = 1;
		endif
	endfor
	if ( sw == 1 )

		% Daca AI-ul muta pentru prima data in aceasta runda sunt doar doua cazuri
		if ( first_move )
			if ( board(2, 2) == 0 )
				move = 5;
			else
				move = 1;
			endif
			first_move = 0;
		else
			% Se cauta cea mai buna mutare folosinduse algoritmul minimax
			[score move] = minimax ( board, 1 );
		endif
		
		board( move ) = 1;
		% Se asteapta jumatate de secunda inainte ca AI-ul sa puna mutarea
		pause( 0.5 );
		if ( c == 'X' )
			set ( buton( move ), 'String', '0' );
			
			%set ( buton ( 1 : 3, 1 : 3 ), 'Userdata', '0' );
		else
			set ( buton( move ), 'String', 'X' );
			
			%set ( buton ( 1 : 3, 1 : 3 ), 'Userdata', 'X' );
		endif
	endif

endfunction


function Reset ( source, eventdata, buton )
	% Resetez tabla pentru inceperea unei noi partide
	delete ( buton );
	delete ( source );
	global mesaj_final
	delete ( mesaj_final );
endfunction

% In cazul in care se primeste semnalul de inchidere a ferestrei de joc
function my_closereq(src,callbackdata)
% Afisez o casuta de dialog
   selection = questdlg('Close This Game?',...
      'Close Request',...
      'Yes','No','No'); 
	switch selection, 
		case 'Yes',
	  	% Se inchide fereastra
			delete(gcf);
			clear all;
		case 'No'
		% Se continua jocul
			return 
	endswitch
endfunction

function game_over ( f, buton, restart, v )

	% Daca jocul a fost castigat de cineva
	if ( v != 0 && v != -1 )
		set ( buton(1 : 3, 1 : 3), 'enable', 'off' );
		set ( buton(v), 'enable', 'on', 'backgroundcolor', 'green' );
		set ( restart, 'enable', 'on' );
	endif

	% Daca este remiza
	if ( v == -1 )
		set ( buton(1 : 3, 1 : 3), 'enable', 'off' );
		set ( restart, 'enable', 'on' );
	endif

endfunction