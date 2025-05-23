close all;
clear all;

room_wsp = [0,0;60,0;60,40;0,40];
UWB_wsp = [5.5,4.5;5.5,20;5.5,34];
Reciever_wsp = [54,10.5;54,16.5;54,24.5;54,30.5];
x_sector = 44;
y_sector = 20;

figure;
plot(room_wsp(:,1), room_wsp(:,2), "-go"); hold on;
plot(Reciever_wsp(:,1),Reciever_wsp(:,2), "-bo"); hold on;
plot(UWB_wsp(:,1), UWB_wsp(:,2), "-ro"); hold on;
rectangle('Position',[x_sector y_sector 1 1],'EdgeColor','b','FaceColor','g','LineWidth',1);

for a = 1:length(UWB_wsp)
   for b = 1:length(Reciever_wsp)
      if wektorsektor(UWB_wsp(a,1),UWB_wsp(a,2),Reciever_wsp(b,1),Reciever_wsp(b,2),x_sector,y_sector,1,1) > -0.5
          line ([UWB_wsp(a,1),Reciever_wsp(b,1)], [UWB_wsp(a,2),Reciever_wsp(b,2)], 'Color', 'r');  
      else
          line ([UWB_wsp(a,1),Reciever_wsp(b,1)], [UWB_wsp(a,2),Reciever_wsp(b,2)], 'Color', 'g');
      end  
   end
end



    
