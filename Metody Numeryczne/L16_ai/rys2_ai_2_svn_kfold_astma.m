
% rys2_ai_4_svn_kfold_astma.m

% #########################################################################
% Rysunki dla ai_4_svn_kfold_astma.m ######################################
% #########################################################################

  figure;

% ACCURACy + PPV + NPV ================================================
  subplot(131);
  set(gca,'FontSize', 11, 'LineWidth', 1)
  hndl = boxplot( ACC.'*100, 'labels', lbl_char);
  title('Dokladnosc')
  set(hndl, 'LineWidth', 1)
  hold on
  plot(mean(PPV*100,2),'gx', 'MarkerSize', 11, 'LineWidth', 2);
  plot(mean(NPV*100,2),'b*', 'MarkerSize', 11, 'LineWidth', 2);
  legend('PPV', 'NPV', 'Location','SouthWest')
  xlabel('Metoda');
  ylabel('Efektywnosc [%]');
  grid on
  ylim([50 100]);
  text_h = findobj(gca,'type','text');
  set(text_h,'FontSize', 11, 'LineWidth', 1)
  for position = 1 : length(text_h)
      set(text_h(position),'Position',get(text_h(position),'Position') - [0 15 0])
  end
  set(gca,'FontSize', 11, 'LineWidth', 1)
    
% SENSITIVITY =========================================================
    
  subplot(132)
  set(gca,'FontSize',11, 'LineWidth', 1)
  hndl = boxplot( SEN'*100, lbl_char, 'outliersize', 0.1);
  set(hndl, 'LineWidth', 1)
  xlabel('Metoda');
  ylabel('Efektywnosc [%]');
  title('Czulosc');
  grid on
  text_h = findobj(gca,'type','text');
  set(text_h,'FontSize', 11, 'LineWidth', 1)
  ylim([0 100]);
  for position = 1 : length(text_h)
      set(text_h(position),'Position',get(text_h(position),'Position') - [0 15 0])
  end
  set(gca,'FontSize', 11, 'LineWidth', 1)
    
% SPECIFICITY =========================================================
   
  subplot(133);
  set(gca,'FontSize', 11, 'LineWidth', 1)
  hndl = boxplot( SPE'*100, lbl_char, 'outliersize', 0.1);
  set(hndl, 'LineWidth', 1)
  xlabel('Metoda');
  ylabel('Efektywnosc [%]');
  title('Swoistosc');
  grid on
  text_h = findobj(gca,'type','text');
  set(text_h,'FontSize', 11, 'LineWidth', 1)
  for position = 1 : length(text_h)
      set(text_h(position),'Position',get(text_h(position),'Position') - [0 15 0])
  end
  set(gca,'FontSize', 11, 'LineWidth', 1)
   
        
% TN FP TP FN =========================================================
    
  figure;

  subplot(121);
  set(gca,'FontSize', 11, 'LineWidth', 1)
  plot (mean(TN_n,2),'rx', 'MarkerSize', 11, 'LineWidth', 2);
  hold on
  plot (mean(FP_n,2),'b*', 'MarkerSize', 11, 'LineWidth', 2);
  hold off
  xlabel('Metoda');
  ylabel('Efektywnosc [%]');
  title('True-Negative / False-Positive');
  legend('TN', 'FP')
  ylim([0 ln])
  grid on

  subplot(122);    
  set(gca,'FontSize',11, 'LineWidth', 1)
  plot (mean(TP_n,2),'rx', 'MarkerSize', 11, 'LineWidth', 2);
  hold on
  plot (mean(FN_n,2),'b*', 'MarkerSize', 11, 'LineWidth', 2);
  hold off
  xlabel('Metoda');
  ylabel('Efektywnosc [%]');
  title('True-Positive / False-Negative');
  legend('TP', 'FN')
  ylim([0 ln])
  grid on
