
% rys_ai_4_svn_kfold_astma.m

% #########################################################################
% Rysunki dla ai_4_svn_kfold_astma.m ######################################
% #########################################################################

% Audio Spectral Envelope (ASE)
  edges = (1 : 0.25 : 5);
  h1 = histcounts(C_s1(:,1), edges );
  h2 = histcounts(C_s2(:,1), edges );
  figure
  bar(edges(1:end-1),[h1; h2]'); legend('Norma','Patologia');
  xlabel('wartosc ASE'); ylabel('liczba przypakow'); title('Histogram dla ASE'); pause

% Tonality Index (TI) 
  edges = (0 : 0.25 : 2);
  h1 = histcounts(C_s1(:,2), edges );
  h2 = histcounts(C_s2(:,2), edges );
  figure
  bar(edges(1:end-1),[h1; h2]'); legend('Norma','Patologia');
  xlabel('wartosc TI'); ylabel('liczba przypakow'); title('Histogram dla TI'); pause

% MOJA cecha: Energy Ratio (ER) (zakres swistow / calosc)  
  edges = (0 : 1 : 20);
  h1 = histcounts(C_s1(:,3), edges );
  h2 = histcounts(C_s2(:,3), edges );
  figure
  bar(edges(1:end-1),[h1; h2]'); legend('Norma','Patologia');
  xlabel('wartosc JA=ER'); ylabel('liczba przypakow'); title('Histogram dla JA=ER'); pause

% Teraz w przestrzeni 2D parami  
  figure
  plot( C_s1(:,2), C_s1(:,1), 'gs', C_s2(:,2), C_s2(:,1), 'ro' );
  xlabel('Tonality Index'); ylabel('Audio Spectral Envelope'); grid;
  legend('norma','astma'); title(' funkcja( TI, ASE )');
  pause
  figure
  plot( C_s1(:,3), C_s1(:,1), 'gs', C_s2(:,3), C_s2(:,1), 'ro' );
  xlabel('Energy Ratio'); ylabel('Audio Spectral Envelope');grid; 
  legend('norma','astma'); title(' funkcja( JA=ER, ASE )');
  pause
  figure
  plot( C_s1(:,3), C_s1(:,2), 'gs', C_s2(:,3), C_s2(:,2), 'ro' );
  xlabel('Energy Ratio'); ylabel('Tonality Index'); grid;
  legend('norma','astma'); title(' funkcja( JA=ER, TI )');
  pause
