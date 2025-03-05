% ai_2_simple_astma.m

% Rozpoznawanie swistow astmatycznych (normalny oddech vs patologiczny)
  clear all; close all;

%% Parametry
  klasyfikator = 2;       % 1 = liniowy, 2 = SVM
  Ktestow = 100;          % liczba wszystkich testow: 10, 20, 30, 40, 50, 100
  C = [ 1, 2 ];           % ktore cechy w zbiorze cech: 1=ASE, 2=TI, 3=NASZA, np. [1,2]
  Ncech = length(C);      % liczba cech w zestawie cech
  P = 0.8;                % ulamek probek uzytych do uczenia

%% Wczytanie sygnalow  
  load sygnaly_astma.mat  % 130 wektorow (sygnalow) 1024-elementowych dla swistow i normy 
                          % 8000 probek sygnalu na sekunde
  sygnaly1 = oddechNorma;        clear oddechNorma;   % naturalny oddech: 1024 x 130
  sygnaly2 = oddechAstma;        clear oddechAstma;   % patologia, swist astmatyczny: 1024 x 130 

     figure               % sygnaly sa w kolumnach dwoch macierzy: 130 kolumn po 1024 elementy
     subplot(121); plot( sygnaly1 ); grid; title('Sygnaly normy (~szumy)');
     subplot(122); plot( sygnaly2 ); grid; title('Sygnaly patologii (~tony)');
     pause

%% Opcjonalne usuwanie "najtrudniejszych" sygnalow 
% Numery od najtrudniejszego do najlatwiejszego, pierwszych 20 przypadkow
%  ind1 = [41,47,37,46,18,22,36,20,50,11,53,39,99,49,79,127,1,7,63,12];                  % norma
%  ind2 = [100,117,96,119,123,126,107,92,113,101,83,105,130,109,111,108,110,118,78,104]; % patologia
% Usuwanie pierwszych Nout = ? sygnalow
%  sygnaly1(:,ind1(1:Nout))=[];
%  sygnaly2(:,ind2(1:Nout))=[];
% Tyle sygnalow nam zostalo
  [ N1, M1 ] = size( sygnaly1 );  % N=1024 - dlugosc sygnalow (liczba probek) 
  [ N2, M2 ] = size( sygnaly2 );  % M=130  - liczba sygnalow

  %% Normalizacja - opcjonalne przetwarzanie wstepne
   sygnaly1 = sygnaly1 ./ max(abs( sygnaly1 ));   % podziel kazda kolumne przez max(abs())
   sygnaly2 = sygnaly2 ./ max(abs( sygnaly2 ));

 %% Wstepne obliczenie/ekstrakcja trzech cech: ASE (C1), TI (C2), JA (C3)
  [ C_s1 ] = ekstrakcja_cech_astma( sygnaly1 );  % dla normy (sygnaly1)
  [ C_s2 ] = ekstrakcja_cech_astma( sygnaly2 );  % dla astmy (sygnaly2)
  rys1_ai_2_astma                                % program z opcjonalnymi rysunkami 
    
% Inicjalizacja wskaznikow jakosci rozpoznawania
% https://en.wikipedia.org/wiki/Sensitivity_and_specificity
  work = zeros( Ktestow );
  TP_n = work;     % true  positive: patologia zdiagnozowana jako patologia 
  TN_n = work;     % true  negative: norma     zdiagnozowana jako norma
  FP_n = work;     % false positive: norma     zdiagnozowana jako patologia
  FN_n = work;     % false negative: patologia zdiagnozowana jako norma
  ACC  = work; PRE = work; NPV = work; SEN = work; SPE = work; F1=work; % pozostale
  
% #########################################################################
% Procedura: 1) wielokrotne uczenie i testowanie roznymi zestawami danych
%            2) obserwowanie zmiennosci charakterystych jakosci rozpoznawania 
% #########################################################################

  M1u = round( P*M1 );  % liczba przykladow uzytych do uczenia normy
  M2u = round( P*M2 );  % liczba przykladow uzytych do uczenia patologii
  M1t = M1 - M1u;       % liczba przykladow uzytych do testowania normy
  M2t = M2 - M2u;       % liczba przykladow uzytych do testowania patologii
  
  for iTest = 1 : Ktestow

   %% Wybor sygnalow do: uczenia i testowania
      ind1 = randperm(M1);                      % losowa kolejnosc liczb [1,...,M1]
      ind2 = randperm(M2);                      % losowa kolejnosc liczb [1,...,M2]
      s1_u = sygnaly1(: , ind1( 1 : M1u ) );    % wybor sygnalow 1 do uczenia
      s2_u = sygnaly2(: , ind2( 1 : M2u ) );    % wybor sygnalow 2 do uczenia
      s1_t = sygnaly1(: , ind1( M1u+1 : M1 ) ); % wybor sygnalow 1 do testowania
      s2_t = sygnaly2(: , ind2( M2u+1 : M2 ) ); % wybor sygnalow 2 do testowania

   %% OBLICZANIE CECH
      X1_u = ekstrakcja_cech_astma( s1_u );     % dla uczenia normy
      X2_u = ekstrakcja_cech_astma( s2_u );     % dla uczenia patologii
      X1_t = ekstrakcja_cech_astma( s1_t );     % dla testowania normy
      X2_t = ekstrakcja_cech_astma( s2_t );     % dla testowania patologii
      x1_u =  X1_u(:, C(1:Ncech));              % tylko wybrane cechy
      x2_u =  X2_u(:, C(1:Ncech));              % j.w.
      x1_t =  X1_t(:, C(1:Ncech));              % j.w.
      x2_t =  X2_t(:, C(1:Ncech));              % j.w

   %% W wierszach zespoly cech, najpierw norma, potem astma   
      v_nauka = [ x1_u; x2_u ];                 % cechy do uczenia
      v_testy = [ x1_t; x2_t ];                 % cechy do testowania
   %% Informacja w group "co jest co" podczas uczenia: 0 = norma, 1 = astma  
      group( 1 : M1u )         = zeros( M1u, 1 );   % 0 = norma
      group( M1u+1 : M1u+M2u ) =  ones( M2u, 1 );   % 1 = astma
  
   %% Najpierw uczenie ("fitting"), potem rozpoznawanie ("predict")
      if( klasyfikator == 1 )      % liniowy
          classes = classify( v_testy, v_nauka, group );
      else                         % SVM
          svmStruct = fitcsvm( v_nauka, group, 'KernelFunction','RBF');
          classes   = predict( svmStruct, v_testy );
      end
      
      TP = 0; TN = 0; FP = 0; FN = 0; 
      for i = 1 : M1t  % sprawdzenie poprawnosci rozpoznania normy           
          if( classes(i)==0 ) TN = TN+1;
          else                FP = FP+1;
          end
      end
      for i = 1 : M2t  % sprawdzenie poprawnosci rozpoznania astmy
          if( classes(M1t+i)==1 ) TP = TP+1;
          else                    FN = FN+1;
          end
      end
      TP_n( iTest ) = TP;               % true positive
      TN_n( iTest ) = TN;               % true negative
      FP_n( iTest ) = FP;               % false positive
      FN_n( iTest ) = FN;               % false negative
      ACC(  iTest ) = (TP+TN) / (TP+TN+FP+FN); % accuracy (dokladnosc)
      PRE(  iTest ) = TP / ( TP+FP );   % positive predictive value (precision)
      NPV(  iTest ) = TN / ( TN+FN );   % negative predictive value
      SEN(  iTest ) = TP / ( TP+FN );   % sensitivity (czulosc), recall
      SPE(  iTest ) = TN / ( FP+TN );   % specificity (swoistosc), selectivity
      F1(   iTest ) = 2*PRE(iTest)*SEN(iTest) / ( PRE(iTest) + SEN(iTest) ); % F1
end

% #########################################################################
% Koniec petli ############################################################
% #########################################################################

%% Koncowe rysunki
   figure; Kt=Ktestow;
   subplot(221); plot(TP_n/M2t*100); title('SVM: True-Positive / Pos '); grid; ylabel('[%]'); axis([1,Kt,85,100]);
   subplot(222); plot(TN_n/M1t*100); title('SVM: True-Negative / Neg '); grid; ylabel('[%]'); axis([1,Kt,85,100]);
   subplot(223); plot( ACC*100); title('SVM: Accuracy'); grid; xlabel('iter'); ylabel('[%]'); axis([1,Kt,85,100]);
   subplot(224); plot( F1*100 ); title('SVM: F1'); grid; xlabel('iter'); ylabel('[%]'); axis([1,Kt,85,100]);
