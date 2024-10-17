% ai_2_svm_kfold_astma.m

% Rozpoznawanie swistow astmatycznych (normalny oddech vs patologiczny)
  clear all; close all;

%% Parametry
  klasyfikator = 1;     % 1 = liniowy, 2 = SVM
  Kblokow = 10;         % liczba blokow sygnalu do cross-walidacji "k-fold": 5, 10  
  Ktestow = 25;         % liczba wszystkich testow: 10, 20, 30, 40, 50  
  Nout = 0;             % 0, 10, 20 - liczba usunietych "najtrudniejszych" sygnalow
  trybpracy = 2;        % 1 = osobno cechy ASE, TI, MOJE
                        % 2 = cechy parami: ASE+TI, ASE+MOJE, TI+MOJE
                        % 3 = wszystkie cechy razem

%% Wczytanie sygnalow  
  load sygnaly_astma.mat  % 130 wektorow (sygnalow) 1024-elementowych dla swistow i normy 
                          % 8000 probek sygnalu na sekunde

  sygnaly1 = oddechNorma;   clear oddechNorma;   % naturalny oddech 
  sygnaly2 = oddechAstma;   clear oddechAstma;   % patologia, swist astmatyczny

     figure           % sygnaly sa w kolumnach dwoch macierzy
     subplot(121); plot( sygnaly1 ); grid; title('Sygnaly normy (~szumy)');
     subplot(122); plot( sygnaly2 ); grid; title('Sygnaly patologii (~tony)');
     pause

%% Opcjonalne usuwanie "najtrudniejszych" sygnalow 
% Numery od najtrudniejszego do najlatwiejszego, pierwszych 20 przypadkow
%  ind1 = [41,47,37,46,18,22,36,20,50,11,53,39,99,49,79,127,1,7,63,12]; % norma
%  ind2 = [100,117,96,119,123,126,107,92,113,101,83,105,130,109,111,108,110,118,78,104]; % patologia
% Usuwanie pirwszych Nout sygnalow
%  sygnaly1(:,ind1(1:Nout))=[];
%  sygnaly2(:,ind2(1:Nout))=[];
% Tyle sygnalow nam zostalo
 [ N1, M1 ] = size( sygnaly1 );  % N=1024 - dlugosc sygnalow (liczba probek) 
 [ N2, M2 ] = size( sygnaly2 );  % M=130  - liczba sygnalow
  
%% Normalizacja - opcjonalne przetwarzanie wstepne
if(0)
  sygnaly1 = sygnaly1 ./ max(abs( sygnaly1 ));   % podziel kazda kolumne przez max(ab())
  sygnaly2 = sygnaly2 ./ max(abs( sygnaly2 ));
end

%% Obliczenie/ekstrakcja trzech cech: ASE (C1), TI (C2), JA (C3)
  [ C_s1 ] = ekstrakcja_cech_astma( sygnaly1 );  % dla normy (sygnaly1)
  [ C_s2 ] = ekstrakcja_cech_astma( sygnaly2 );  % dla astmy (sygnaly2)

%% Rysunki - opcjonalnie, usun wstawiajac z przodu "%"

   rys1_ai_2_astma   % program z opcjonalnymi rysunkami 
   
%% Wybor trybu pracy i cech do testowania (obecnie tylko trzy)  
  if( trybpracy == 1 )     % rozpoznawanie pojedynczymi cechami, podajemy ich numery
      C = [ 1; 2; 3 ];  lbl_char = {'ASE'; 'TI'; 'JA'};
  elseif( trybpracy == 2 ) % rozpoznawanie parami cech, ich numery w kolejnych wierszach
      C = [ 1, 2; 1, 3; 2, 3 ];  lbl_char = {'ASE + TI', 'ASE + JA', 'TI + JA'};
  elseif( trybpracy == 3 )
      C = [ 1, 2, 3 ];  lbl_char = {'ASE + TI + JA'};
  end
  [ Nzestawow, Ncech ] = size(C);    % liczba zestawow cech i liczba cech w zestawie

% Inicjalizacja wskaznikow jakosci rozpoznawania
% https://en.wikipedia.org/wiki/Sensitivity_and_specificity
  work = zeros(Nzestawow, Ktestow);
  TP_n = work;     % true  positive: patologia zdiagnozowana jako patologia 
  TN_n = work;     % true  negative: norma     zdiagnozowana jako norma
  FP_n = work;     % false positive: norma     zdiagnozowana jako patologia
  FN_n = work;     % false negative: patologia zdiagnozowana jako norma
  ACC  = work; PPV = work; NPV = work; SEN = work; SPE = work; % pozostale
  
% #########################################################################
% Procedura "K-fold": uczenie (Kfold-1) blokami, testowanie jednym blokiem
% #########################################################################

  indices = crossvalind('Kfold', Ktestow, Kblokow-1);  % numery blokow do rozpoznawania
  M1_block = M1 / Kblokow;   % liczba sygnalow normalnych w jednym z Kblokow blokow 
  M2_block = M2 / Kblokow;   % liczba sygnalow patologicznych w jednym z Kblokow blokow 
  i_rand = 1;

  for iTest = 1 : Ktestow
    
    iTest,
    if( (iTest ~= 1) && ( mod(iTest-1, Kblokow) == 0) )
        i_rand = i_rand + 1
        ind_1 = randperm(M1);       % sortowanie po pelnym "obrocie" K-fold
        ind_2 = randperm(M2);
        sygnaly1 = sygnaly1(:, ind_1);
        sygnaly2 = sygnaly2(:, ind_2);
    end
    M2_vec = false( M2, 1 );         % zerowanie maski do wyboru bloku sygnalow astmy
    M1_vec = false( M1, 1 );         % zerowanie maski do wyboru bloku sygnalow astmy
                                     % ustawienie maski na sygnaly do rozpoznania 
    M2_vec( indices(iTest)*M2_block : indices(iTest)*M2_block + M2_block-1) = true;  % 
    M1_vec( indices(iTest)*M2_block : indices(iTest)*M2_block + M2_block-1) = true;  % 
    s1u = sygnaly1(: , ~M1_vec );    % wybor sygnalow do nauczania (~maska)
    s1t = sygnaly1(: ,  M1_vec );    % wybor sygnalow do rozpoznawania
    s2u = sygnaly2(: , ~M2_vec );    % wybor sygnalow do nauczania (~maska)
    s2t = sygnaly2(: ,  M2_vec);     % wybor sygnalow do rozpoznawania
    
    %################
    % OBLICZANIE CECH
    %################

    X1_u = ekstrakcja_cech_astma( s1u );  % dla uczenia normy
    X2_u = ekstrakcja_cech_astma( s2u );  % dla uczenia patologii
    X1_t = ekstrakcja_cech_astma( s1t );  % dla testowania normy
    X2_t = ekstrakcja_cech_astma( s2t );  % dla testowania patologii
   
    for iZ = 1 : Nzestawow
      % iZ
        x1_u =  X1_u(:, C(iZ,1:Ncech));  % stan 1 - norma
        x2_u =  X2_u(:, C(iZ,1:Ncech));  % stan 2 - astma
        x1_t =  X1_t(:, C(iZ,1:Ncech));  % stan 1 - norma
        x2_t =  X2_t(:, C(iZ,1:Ncech));  % stan 2 - astma
        v_nauka = [ x1_u; x2_u ];
        v_testy = [ x1_t; x2_t ];
        group = zeros( length(x1_u)+length(x2_u), 1 );
        group( length(x1_u)+1 : length(x1_u)+length(x2_u), 1 ) = 1;
  
      % Najpierw uczenie ("fitting"), potem rozpoznawanie ("predict")
         
        if( klasyfikator == 1 )      % liniowy
            classes = classify( v_testy, v_nauka, group );
        else                         % SVM
            svmStruct = fitcsvm( v_nauka, group, 'KernelFunction','RBF');
            classes   = predict( svmStruct, v_testy );
            CLS( :, iZ, iTest ) = classes;
        end

        TP = 0; FP = 0; FN = 0; TN = 0;
        for i = 1 : length( x1_t )
            if( classes(i)==0 ) TN = TN+1;
            else                FP = FP+1;
            end
        end
        [ln dummy]= size( X1_t );
        for i = 1 : length( x2_t )
            if( classes(ln+i)==1 ) TP = TP+1;
            else                   FN = FN+1;
            end
        end
        TP_n( iZ, iTest ) = TP;               % true positive
        TN_n( iZ, iTest ) = TN;               % true negative
        FP_n( iZ, iTest ) = FP;               % false positive
        FN_n( iZ, iTest ) = FN;               % false negative
        ACC(  iZ, iTest ) = (TN+TP) / (TN+TP+FP+FN); % accuracy (dokladnosc)
        PPV(  iZ, iTest ) = TP / ( TP+FP );   % positive predictive value (precision)
        NPV(  iZ, iTest ) = TN / ( TN+FN );   % negative predictive value
        SEN(  iZ, iTest ) = TP / ( TP+FN );   % sensitivity (czulosc), recall
        SPE(  iZ, iTest ) = TN / ( FP+TN );   % specificity (swoistosc), selectivity
    end
end

% #########################################################################
% Koniec procedury "K-fold" ###############################################
% #########################################################################

%% Koncowe rysunki

   rys2_ai_2_svn_kfold_astma   % program z koncowymi rysunkami 
