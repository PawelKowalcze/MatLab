function kryt = zar_kryterium(a,i,u)
um = zar_model(a,i);         % napiecie z modelu dla aktualnego a oraz zadanego i
kryt = sum (abs( u - um ) ); % suma wartosci bezwzg. odchylek modelu od rzeczywistosci