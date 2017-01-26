%khf1.erl

-module(khf1).
-author('specialized864@gmail.com').
-vsn('2016-09-25').
-export([
			feldarabolasa/2,
			listafeldarabolasa/3,
			listalistafeldarabolasa/5,
			matrixAssembler/3,
			egyMatrixAssembler/4,
			egyMatrixInvoker/5,
			takeIndex/2,
			lastItem/1
		]).
-compile(export_all).

%% @type matrix() = [row()].
%% @type row() = [any()].
%% @type parameter() = {subRows(), subCols()}.
%% @type subRows() = integer().
%% @type subCols() = integer().
%% @spec khf1:feldarabolasa(L::matrix(), P::parameter()) -> LL::[[any()]].
%%   Az LL lista az Mx matrix P parameteru feldarabolasa.
feldarabolasa(L,{R,C}) -> 
	Columns = length(hd(L)),
	Remainder = Columns rem C,
	NewCol = Columns div C,
	if 
		Remainder =:= 0 -> Modulo = NewCol;
		Remainder > 0 -> Modulo = NewCol + 1
	end,
	LL = listafeldarabolasa(L,C,Modulo),
	matrixAssembler(LL,Modulo,R).
	

%% @spec khf1:listafeldarabolasa(L::matrix(), C::integer(), CCD::integer()) -> [LL::any()].
%%   Matrix sorait tartalmazo listak tovabb bontasa, hogy azokbol reszmatrixokat tudjunk csinalni
listafeldarabolasa([],_C,_CCD) -> [];
listafeldarabolasa([H|T],C,CCD) ->
	listalistafeldarabolasa(H,1,C,C,CCD) ++ listafeldarabolasa(T,C,CCD).


%% @spec khf1:listalistafeldarabolasa(H::row(), A::integer(), B::integer, C::integer(), CCD::integer()) -> [LL::any()].
%%   Matrix soraibol allo listanak a sorainak megtovabb bontasa es osszefuzese	
listalistafeldarabolasa(_H,_A,_B,_C,0) -> [];
listalistafeldarabolasa(H,A,B,C,CCD) -> 
	[lists:sublist(H,A,B) | listalistafeldarabolasa(H,A+C,B,C,CCD-1)].

	
%% @spec khf1:matrixAssembler(L::matrixElements(), Modulo::integer(), R::integer()) -> [LL::any()].
%%   Meghivja az egyMatrixInvoker-t plusz egy parameterrel es visszaadja az L matrix reszmatrixainak elemeibol allo listabol konstrualt reszmatrixok listajat
matrixAssembler(L,Modulo,R) ->
	N = length(L),
	egyMatrixInvoker(0,L,Modulo,R,N).
	

%% @spec khf1:egyMatrixInvoker(PosVar::integer(), L::matrixElements(), Modulo::integer(), R::integer(), N::integer()) -> [LL::any()].
%%   Az egyMatrixAssembler fuggvenyeket meghivja a megfelelo parameterekkel, hogy visszaadja a matrix reszmatrixokra bontasat	
egyMatrixInvoker(PosVar,L,Modulo,R,N) ->
	RModVar = PosVar div Modulo,
	CalculatedPosVar = ((PosVar rem Modulo)+1)+(RModVar*R*Modulo),
	if
		CalculatedPosVar > N -> []; %CalculatedPosVar; %egyMatrixAssembler(L,9,Modulo,R);
		CalculatedPosVar =< N -> [egyMatrixAssembler(L,CalculatedPosVar,Modulo,R) | egyMatrixInvoker(PosVar+1,L,Modulo,R,N)]
	end.
	

%% @spec khf1:egyMatrixAssembler(L::matrixElements(), KezdoPoz::integer(), Modulo::integer(), R::integer) -> [LL::any()].
%%   Osszerakja nekunk az adott a matrix reszmatrixainak sorainak a listajabol a parameterek altal meghatarozott reszmatrixot
egyMatrixAssembler(_L,_KezdoPoz, _Modulo, 0) -> [];
egyMatrixAssembler(L,KezdoPoz, Modulo, R) ->
	{A,B} = takeIndex(L,KezdoPoz),
	if
		A=:= ok 		-> B ++ egyMatrixAssembler(L,KezdoPoz+Modulo,Modulo,R-1);
		A=:= overflow	-> []
	end.


%% @spec khf1:takeIndex(L::matrixElements(), Index::integer()) -> {SUCCESS::atom(),LL::any()}.
%%   Visszaadja az adott indexu elemet a listabol. Ha nagyobb az index, akkor az utolsot es ezt jelzi a par elso kifejezeseben egy atommal
takeIndex([H|_],1) -> {ok,H};
takeIndex(L,Index) when length(L)>= Index -> takeIndex(tl(L),Index-1);
takeIndex(L,_Index) -> lastItem(L).


%% @spec khf1:lastItem(L::matrixElements()) -> [LL::any()].
%%   Visszaadja a lista utolso elemet
lastItem([X]) -> {overflow,X};
lastItem([_|T]) -> lastItem(T).


%% TODO
%	-warnings, de tenyleg kell az oda?
%	-komment rendesen
%	-parameterek rendesen
%	-egeszet refaktoral, mert szar