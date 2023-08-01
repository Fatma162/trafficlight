char count23[]={
0b00100011,0b00100010,0b00100001,0b00100000,
0b00011001,0b00011000,0b00010111,0b00010110,
0b00010101,0b00010100,0b00010011,0b00010010,
0b00010001,0b00010000,0b00001001,0b00001000,
0b00000111,0b00000110,0b00000101,0b00000100,
0b00000011,0b00000010,0b00000001,0b00000000
} ;
char count15[]={
0b00010101,0b00010100,0b00010011,0b00010010,
0b00010001,0b00010000,0b00001001,0b00001000,
0b00000111,0b00000110,0b00000101,0b00000100,
0b00000011,0b00000010,0b00000001,0b00000000
} ;
signed char counter1=0;
signed char counter2=0;
signed char counteryellow=3;
signed char countinterrupt=0;
void interrupt(){
   if(intf_bit==1){
      intf_bit=0;
      countinterrupt++;
   }
}
void main(){
   adcon1=7;             //to change porta from analog to digital
   trisb.b0=1;           //pin B0 is input
   GIE_bit=1;            //Global activated
   INTE_bit=1;          //interput enable bit activated
   INTEDG_bit=0;       //pulldown(falling edage)
   trisc=0;trisa=0;trisd=0;trisb.B6=0; trisb.B7=0;
   trise.b1=0; trise.b2=0;
   portc=0;    portd=0;
   portb.b6=0; portb.b7=0; porte.b1=0; porte.b2=0;
   porta.b0=0;porta.b1=0;porta.b2=0; porta.b3=1;porta.b4=1;porta.b5=1;
   while(1){
      //auto
      while(portb.b1==0){
        for(counter1=0;counter1<=23;counter1++){
            if(portb.b1==1)break;
            porte.b1=porte.b2=1;      //2SSD for west  on
            portb.b6=portb.b7=1;      //2SSD for south on
            portc=count23[counter1];
            portd=count23[counter1+3];
            porta.b5=1;     //Green SOUTH Off
            porta.b4=1;    //Yellow south off
            porta.b0=0;    //Red west off
            porta.B3=1;      //red south off
            porta.b1=0;    //yellow west off
            porta.b0=1;     //RED WEST ON
            porta.b5=0;     //Green SOUTH ON
            delay_ms(1000);
            if(portd==0){
              while(counter1<=23){
               if(portb.b1==1){porta.b5=0;break;}
               portc=count23[counter1];
               portd=count23[counter1];
               porta.b5=1;   //green south off
               porta.b4=0;   //yellow south on
               delay_ms(1000);
               counter1++;
               if(portc==0&&portd==0){
                portb.b1=1;
                porta.b4=1;   //yellow south off
                porta.b0=0;    //red west off
                portb.b1=1;       //to out of the loop
                }
              }
            }
        }
        for(counter2=0;counter2<=15;counter2++){
          if(portb.b1==1)break;
          porte.B1=porte.b2=0;
          portb.B6=portb.b7=0;
          porta.b0=0;    //red west off
          porta.b4=1;      //yellow south off
          porte.B1=porte.b2=1;
          portb.B6=portb.b7=1;
          porta.b5=1;       //Green south off
          portc=count15[counter2];
          portd=count15[counter2+3];
          porta.B3=0;     //red south on
          porta.B2=1;    //green west on
          delay_ms(1000);
          if(portd==0){
             while(counter2<=15){
             if(portb.b1==1){porta.b2=1;break;}
             portc=count15[counter2];
             portd=count15[counter2];
             porta.B2=0;    //green west off
             porta.b1=1;    //yellow west on
             counter2++;
             delay_ms(1000);
             }
          }
        }
        }
        while(portb.b1==1){
          portc=0;     portd=0;
          //manual
          if(countinterrupt==1){
            porta.B3=1;     //red south off
            porta.b4=1;     //yellow south off
            porta.b5=0;     //green south on
            porta.b0=1;     //red   west on
            porta.b1=0;     //yellow west off
            porta.B2=0;     //green west off
          }
          if(countinterrupt==2){
            for(counteryellow=3;counteryellow>=0;counteryellow--){
            if(counteryellow==0){ 
            counteryellow=3; countinterrupt=3; break;}
            porta.b5=1;    //green south off
            porta.b4=0;    //yellow south on
            portb.b6=1;
            portd=counteryellow;
            delay_ms(1000);
            }
          }
         if(countinterrupt==3){
            porta.b4=1;    //yellow south off
            porta.b0=0;     // red west off
            porta.b2=1;     //Green west on
            porta.b3=0;     //Red south on
         }
          if(countinterrupt==4){
            for(counteryellow=3;counteryellow>=0;counteryellow--){
              if (counteryellow==0){counteryellow=3;  break;}
              porta.b2=0;     //green west off
              porta.b1=1;     //yellow west on
              porte.b1=1;     //first  7 seg. right is on
              portc=counteryellow;
              delay_ms(1000);
            }
            porta.b1=0;       //yellow west off
            porta.b0=1;      //red west on
            porta.B3=1;    //red south off
            porta.B5=0;   //green south on
            countinterrupt=1;
          }
        }
    }
}