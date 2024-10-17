% Test rand gen

clear all; close all;

if(0) % generator multiplikatywny
  disp('GEN mult')
  r = rand_mult(10000,123); % (ile liczb, pierwsza liczba)
  
  figure;
  plot(r,'bo'); pause
  hist(r,20); pause
end

if(0) % generator multiplikatywny + adytywny
  disp('GEN mult+add')
  r = rand_multadd(10000,123); % (ile liczb, pierwsza liczba)
  
  figure;
  plot(r,'bo'); pause
  hist(r,20); pause
end

if(0) % R[0,1] --> Dowolny rozk³ad o zadanej dystrybuancie
      % F(x) = 1-exp(-lamb*x) = r  --> x=?
   disp('Równomierny R[0,1] --> o dowolnej dystrybuancie');
   N = 10000; 
   lamb = 2;
   r = rand(1,N);
   x = - (1/lamb)*log(1 - r);
   
   figure;
   subplot(221); plot(r,'b.');
   subplot(222); hist(r,20);
   subplot(223); plot(x,'b.');
   subplot(224); hist(x,20); pause
end

if(1)  % rand 1D Równomierny[0,1] --> rand 2D Normalny(0,1)
   disp('Równomierny R[0,1] --> Normalny (0,1)')
   N = 10000; 
   r1 = rand(1,N);
   r2 = rand(1,N);
   n1 = sqrt(-2*log(r1)) .* cos(2*pi*r2);
   n2 = sqrt(-2*log(r1)) .* sin(2*pi*r2);
   
   figure;
   subplot(111); plot(n1,n2,'b*'); pause
   figure;
   subplot(211); hist(n1,20); title('n1');
   subplot(212); hist(n2,20); title('n2'); pause
end

if(0)  % randn(0,1) --> randn(s,d)
   disp('Normalny (0,1) --> Normalny (sred,var)')
   N = 10000; k=-(N-1):(N-1);
   r = randn(1,N);
   
   figure;
   hist(r,20); pause
   disp('CORR r'); plot( k,xcorr(r) ); title('AutoCorr(k)'); pause

   s = 5; d = 3;
   r = d*r + s;
   
   figure;
   hist(r,20); pause
   disp('CORR r'); plot( k,xcorr(r) ); title('AutoCorr(k)'); pause
end

if(0) % PRBS Rysunek
disp('Max Length PRBS na rysunku')
    N = 12;  % 2,3,4,5,9,12
    L = 2*(2^N);
    buf = ones(1,N);
    for n = 1 : L
      if(N==1)  y(n)=xor(buf(1), buf(2)); end % N=2 oct(7)              111
      if(N==3)  y(n)=xor(buf(2), buf(3)); end % N=3 oct(13)           1 011 
      if(N==4)  y(n)=xor(buf(3), buf(4)); end % N=4 oct(23)          10 011  
      if(N==5)  y(n)=xor(buf(3), buf(5)); end % N=5 oct(45)         100 101 
      if(N==9)  y(n)=xor(buf(5), buf(9)); end % N=9 oct(1021) 1 000 010 001
      if(N==12) y(n)=xor(buf(6), xor(buf(8), xor(buf(11), buf(12)))); end % N=12 oct(10123) 1 000 001 010 011
      buf = [ y(n) buf(1:N-1) ];
    end
    figure;
    subplot(211); stem(y,'bo'); title('y(n)')
    subplot(212); stem(-L+1:L-1,xcorr(y-mean(y))); grid; title('Ryy(k)'); axis tight;
    pause
end

if(0) % ML-PRBS DAB
   size = 2^10; 
   Vector = [1 1 1 1 1 1 1 1 1 ];               % initialization word/register
   PRBS= zeros(1,size);
   CounterPRBS = 1;
   for i = 0 : size-1
       NewBit =  xor(Vector(5),Vector(9));     % calculate a new bit
       Vector = [NewBit Vector(1:end-1)];      % store it in a work register
       PRBS(CounterPRBS) = NewBit;             % write the bit into output sequense
       CounterPRBS = CounterPRBS + 1;          % incease the counter
   end
   b = PRBS;
   figure;
   subplot(311); plot(b,'bo'); title('b(n)'); 
   subplot(312); stem(-size+1:size-1,xcorr(b-mean(b))); title('Auto-Corr( b(n) )');
   subplot(313); plot(abs(fft(b-mean(b)))); title('FFT( b(n) )')
   pause
end   

if(0) % ML-PRBS ADSL
    disp('Max Length PRBS w modemach ADSL')

    b(1:9) = ones(1,9);
    for n = 10 : 512
        b(n) = xor( b(n-4), b(n-9));
    end
    figure;
    subplot(311); plot(b,'bo');
    subplot(312); plot(xcorr(b));
    subplot(313); plot(abs(fft(b)));
    pause

    for n = 1 : 512
        if( b(n) == 0 ) b(n)=-1; end
    end
    figure;
    subplot(311); plot(b,'bo');
    subplot(312); plot(xcorr(b-mean(b)));
    subplot(313); plot(abs(fft(b)));
end

if(0) % obliczanie pi metod¹ rzutu w kwadrat opisany na kole
   disp('Oblicz PI strzelajac do tarczy')
   n  = 1000000;  % ?
   nk = 0;
   for i=0 : n
       x = rand(1,1)*2.0 - 1.0;
       y = rand(1,1)*2.0 - 1.0;
       if(x*x + y*y <= 1.0)
          nk = nk + 1;
       end
   end
   pi, mypi = 4.0 * nk / n, pause
end

if(0) % Testowanie precyzji estymacji (obliczeñ) - u nas wartoœæ skuteczna sinusoidy
    disp('Testowanie precyzji estymatorów, u nas wartoœci skutecznej')
    t = 0: 2*pi/100 : 2*pi-2*pi/100;
    for i = 1:10000
        f = rand*2*pi; x = sin(t+f);
        x_sk1(i) = sqrt( sum(x.^2) / length(t) );
        x_sk2(i) = max( abs(x) ) / sqrt(2);
    end
    figure;
    subplot(211); hist(x_sk1,30); axis([0.703 0.711 0 2000]);
    subplot(212); hist(x_sk2,30); axis([0.703 0.711 0 2000]);
end    