close all;
clear all;

roboty = rand( 90,2 ).*[80,70];
% Do testu
% roboty(1,:) = [30,15];

anteny = [  0,  0;
            80, 0;
            80, 70;
            0,  70];

policzone = zeros(90,2); 

for i=1:1:90
    A = policzA( roboty(i,:) );
    b = policzB( A, anteny );
    policzone(i,:) = pinv(A)*b;
end

roznice = roboty - policzone;
odleglosci = sqrt( sum(roznice.^2,2));
sredni_blad_odleglosci = mean( odleglosci ),


figure;
scatter( roboty(:,1), roboty( :,2 ), 'filled' ); grid on; hold on;
scatter( anteny(:,1), anteny( :,2 ), 'filled' ); hold on;
scatter( policzone(:,1), policzone( :,2), 'filled');

function A = policzA(r)
    A = zeros(4,2);
    x = r(:,1);
    y = r(:,2);

    a1 = atand( x/y );
    a = 2*randn;
    A(1,:) = [1, -tand( a1+a )];

    a2 = atand( ( x-80 )/y );
    a = 2*randn;
    A(2,:) = [1, -tand( a2+a )];

    a3 = atand( (80-x)/(70-y) );
    a = 2*randn;
    A(3,:) = [1, -tand( a3+a )];

    a4 = atand( x/(y-70) );
    a = 2*randn;
    A(4,:) = [1, -tand( a4+a )];
    
end

function B = policzB( A,p )
    B = zeros(4,1);
    for i=1:1:4
        B(i) = p(i,1) + p(i,2)*A(i,2);
    end
end
