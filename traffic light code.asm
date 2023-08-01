
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;traffic light code.c,19 :: 		void interrupt(){
;traffic light code.c,20 :: 		if(intf_bit==1){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;traffic light code.c,21 :: 		intf_bit=0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;traffic light code.c,22 :: 		countinterrupt++;
	INCF       _countinterrupt+0, 1
;traffic light code.c,23 :: 		}
L_interrupt0:
;traffic light code.c,24 :: 		}
L_end_interrupt:
L__interrupt46:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;traffic light code.c,25 :: 		void main(){
;traffic light code.c,26 :: 		adcon1=7;             //to change porta from analog to digital
	MOVLW      7
	MOVWF      ADCON1+0
;traffic light code.c,27 :: 		trisb.b0=1;           //pin B0 is input
	BSF        TRISB+0, 0
;traffic light code.c,28 :: 		GIE_bit=1;            //Global activated
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;traffic light code.c,29 :: 		INTE_bit=1;          //interput enable bit activated
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;traffic light code.c,30 :: 		INTEDG_bit=0;       //pulldown(falling edage)
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;traffic light code.c,31 :: 		trisc=0;trisa=0;trisd=0;trisb.B6=0; trisb.B7=0;
	CLRF       TRISC+0
	CLRF       TRISA+0
	CLRF       TRISD+0
	BCF        TRISB+0, 6
	BCF        TRISB+0, 7
;traffic light code.c,32 :: 		trise.b1=0; trise.b2=0;
	BCF        TRISE+0, 1
	BCF        TRISE+0, 2
;traffic light code.c,33 :: 		portc=0;    portd=0;
	CLRF       PORTC+0
	CLRF       PORTD+0
;traffic light code.c,34 :: 		portb.b6=0; portb.b7=0; porte.b1=0; porte.b2=0;
	BCF        PORTB+0, 6
	BCF        PORTB+0, 7
	BCF        PORTE+0, 1
	BCF        PORTE+0, 2
;traffic light code.c,35 :: 		porta.b0=0;porta.b1=0;porta.b2=0; porta.b3=1;porta.b4=1;porta.b5=1;
	BCF        PORTA+0, 0
	BCF        PORTA+0, 1
	BCF        PORTA+0, 2
	BSF        PORTA+0, 3
	BSF        PORTA+0, 4
	BSF        PORTA+0, 5
;traffic light code.c,36 :: 		while(1){
L_main1:
;traffic light code.c,38 :: 		while(portb.b1==0){
L_main3:
	BTFSC      PORTB+0, 1
	GOTO       L_main4
;traffic light code.c,39 :: 		for(counter1=0;counter1<=23;counter1++){
	CLRF       _counter1+0
L_main5:
	MOVLW      128
	XORLW      23
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter1+0, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main6
;traffic light code.c,40 :: 		if(portb.b1==1)break;
	BTFSS      PORTB+0, 1
	GOTO       L_main8
	GOTO       L_main6
L_main8:
;traffic light code.c,41 :: 		porte.b1=porte.b2=1;      //2SSD for west  on
	BSF        PORTE+0, 2
	BTFSC      PORTE+0, 2
	GOTO       L__main48
	BCF        PORTE+0, 1
	GOTO       L__main49
L__main48:
	BSF        PORTE+0, 1
L__main49:
;traffic light code.c,42 :: 		portb.b6=portb.b7=1;      //2SSD for south on
	BSF        PORTB+0, 7
	BTFSC      PORTB+0, 7
	GOTO       L__main50
	BCF        PORTB+0, 6
	GOTO       L__main51
L__main50:
	BSF        PORTB+0, 6
L__main51:
;traffic light code.c,43 :: 		portc=count23[counter1];
	MOVF       _counter1+0, 0
	ADDLW      _count23+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic light code.c,44 :: 		portd=count23[counter1+3];
	MOVLW      3
	ADDWF      _counter1+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      _counter1+0, 7
	MOVLW      255
	MOVWF      R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _count23+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;traffic light code.c,45 :: 		porta.b5=1;     //Green SOUTH Off
	BSF        PORTA+0, 5
;traffic light code.c,46 :: 		porta.b4=1;    //Yellow south off
	BSF        PORTA+0, 4
;traffic light code.c,47 :: 		porta.b0=0;    //Red west off
	BCF        PORTA+0, 0
;traffic light code.c,48 :: 		porta.B3=1;      //red south off
	BSF        PORTA+0, 3
;traffic light code.c,49 :: 		porta.b1=0;    //yellow west off
	BCF        PORTA+0, 1
;traffic light code.c,50 :: 		porta.b0=1;     //RED WEST ON
	BSF        PORTA+0, 0
;traffic light code.c,51 :: 		porta.b5=0;     //Green SOUTH ON
	BCF        PORTA+0, 5
;traffic light code.c,52 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;traffic light code.c,53 :: 		if(portd==0){
	MOVF       PORTD+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;traffic light code.c,54 :: 		while(counter1<=23){
L_main11:
	MOVLW      128
	XORLW      23
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter1+0, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main12
;traffic light code.c,55 :: 		if(portb.b1==1){porta.b5=0;break;}
	BTFSS      PORTB+0, 1
	GOTO       L_main13
	BCF        PORTA+0, 5
	GOTO       L_main12
L_main13:
;traffic light code.c,56 :: 		portc=count23[counter1];
	MOVF       _counter1+0, 0
	ADDLW      _count23+0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic light code.c,57 :: 		portd=count23[counter1];
	MOVF       R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;traffic light code.c,58 :: 		porta.b5=1;   //green south off
	BSF        PORTA+0, 5
;traffic light code.c,59 :: 		porta.b4=0;   //yellow south on
	BCF        PORTA+0, 4
;traffic light code.c,60 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
	NOP
;traffic light code.c,61 :: 		counter1++;
	INCF       _counter1+0, 1
;traffic light code.c,62 :: 		if(portc==0&&portd==0){
	MOVF       PORTC+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main17
	MOVF       PORTD+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main17
L__main44:
;traffic light code.c,63 :: 		portb.b1=1;
	BSF        PORTB+0, 1
;traffic light code.c,64 :: 		porta.b4=1;   //yellow south off
	BSF        PORTA+0, 4
;traffic light code.c,65 :: 		porta.b0=0;    //red west off
	BCF        PORTA+0, 0
;traffic light code.c,66 :: 		portb.b1=1;       //to out of the loop
	BSF        PORTB+0, 1
;traffic light code.c,67 :: 		}
L_main17:
;traffic light code.c,68 :: 		}
	GOTO       L_main11
L_main12:
;traffic light code.c,69 :: 		}
L_main10:
;traffic light code.c,39 :: 		for(counter1=0;counter1<=23;counter1++){
	INCF       _counter1+0, 1
;traffic light code.c,70 :: 		}
	GOTO       L_main5
L_main6:
;traffic light code.c,71 :: 		for(counter2=0;counter2<=15;counter2++){
	CLRF       _counter2+0
L_main18:
	MOVLW      128
	XORLW      15
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter2+0, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;traffic light code.c,72 :: 		if(portb.b1==1)break;
	BTFSS      PORTB+0, 1
	GOTO       L_main21
	GOTO       L_main19
L_main21:
;traffic light code.c,73 :: 		porte.B1=porte.b2=0;
	BCF        PORTE+0, 2
	BTFSC      PORTE+0, 2
	GOTO       L__main52
	BCF        PORTE+0, 1
	GOTO       L__main53
L__main52:
	BSF        PORTE+0, 1
L__main53:
;traffic light code.c,74 :: 		portb.B6=portb.b7=0;
	BCF        PORTB+0, 7
	BTFSC      PORTB+0, 7
	GOTO       L__main54
	BCF        PORTB+0, 6
	GOTO       L__main55
L__main54:
	BSF        PORTB+0, 6
L__main55:
;traffic light code.c,75 :: 		porta.b0=0;    //red west off
	BCF        PORTA+0, 0
;traffic light code.c,76 :: 		porta.b4=1;      //yellow south off
	BSF        PORTA+0, 4
;traffic light code.c,77 :: 		porte.B1=porte.b2=1;
	BSF        PORTE+0, 2
	BTFSC      PORTE+0, 2
	GOTO       L__main56
	BCF        PORTE+0, 1
	GOTO       L__main57
L__main56:
	BSF        PORTE+0, 1
L__main57:
;traffic light code.c,78 :: 		portb.B6=portb.b7=1;
	BSF        PORTB+0, 7
	BTFSC      PORTB+0, 7
	GOTO       L__main58
	BCF        PORTB+0, 6
	GOTO       L__main59
L__main58:
	BSF        PORTB+0, 6
L__main59:
;traffic light code.c,79 :: 		porta.b5=1;       //Green south off
	BSF        PORTA+0, 5
;traffic light code.c,80 :: 		portc=count15[counter2];
	MOVF       _counter2+0, 0
	ADDLW      _count15+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic light code.c,81 :: 		portd=count15[counter2+3];
	MOVLW      3
	ADDWF      _counter2+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      _counter2+0, 7
	MOVLW      255
	MOVWF      R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _count15+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;traffic light code.c,82 :: 		porta.B3=0;     //red south on
	BCF        PORTA+0, 3
;traffic light code.c,83 :: 		porta.B2=1;    //green west on
	BSF        PORTA+0, 2
;traffic light code.c,84 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main22:
	DECFSZ     R13+0, 1
	GOTO       L_main22
	DECFSZ     R12+0, 1
	GOTO       L_main22
	DECFSZ     R11+0, 1
	GOTO       L_main22
	NOP
	NOP
;traffic light code.c,85 :: 		if(portd==0){
	MOVF       PORTD+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;traffic light code.c,86 :: 		while(counter2<=15){
L_main24:
	MOVLW      128
	XORLW      15
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter2+0, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main25
;traffic light code.c,87 :: 		if(portb.b1==1){porta.b2=1;break;}
	BTFSS      PORTB+0, 1
	GOTO       L_main26
	BSF        PORTA+0, 2
	GOTO       L_main25
L_main26:
;traffic light code.c,88 :: 		portc=count15[counter2];
	MOVF       _counter2+0, 0
	ADDLW      _count15+0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic light code.c,89 :: 		portd=count15[counter2];
	MOVF       R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;traffic light code.c,90 :: 		porta.B2=0;    //green west off
	BCF        PORTA+0, 2
;traffic light code.c,91 :: 		porta.b1=1;    //yellow west on
	BSF        PORTA+0, 1
;traffic light code.c,92 :: 		counter2++;
	INCF       _counter2+0, 1
;traffic light code.c,93 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;traffic light code.c,94 :: 		}
	GOTO       L_main24
L_main25:
;traffic light code.c,95 :: 		}
L_main23:
;traffic light code.c,71 :: 		for(counter2=0;counter2<=15;counter2++){
	INCF       _counter2+0, 1
;traffic light code.c,96 :: 		}
	GOTO       L_main18
L_main19:
;traffic light code.c,97 :: 		}
	GOTO       L_main3
L_main4:
;traffic light code.c,98 :: 		while(portb.b1==1){
L_main28:
	BTFSS      PORTB+0, 1
	GOTO       L_main29
;traffic light code.c,99 :: 		portc=0;     portd=0;
	CLRF       PORTC+0
	CLRF       PORTD+0
;traffic light code.c,101 :: 		if(countinterrupt==1){
	MOVF       _countinterrupt+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main30
;traffic light code.c,102 :: 		porta.B3=1;     //red south off
	BSF        PORTA+0, 3
;traffic light code.c,103 :: 		porta.b4=1;     //yellow south off
	BSF        PORTA+0, 4
;traffic light code.c,104 :: 		porta.b5=0;     //green south on
	BCF        PORTA+0, 5
;traffic light code.c,105 :: 		porta.b0=1;     //red   west on
	BSF        PORTA+0, 0
;traffic light code.c,106 :: 		porta.b1=0;     //yellow west off
	BCF        PORTA+0, 1
;traffic light code.c,107 :: 		porta.B2=0;     //green west off
	BCF        PORTA+0, 2
;traffic light code.c,108 :: 		}
L_main30:
;traffic light code.c,109 :: 		if(countinterrupt==2){
	MOVF       _countinterrupt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;traffic light code.c,110 :: 		for(counteryellow=3;counteryellow>=0;counteryellow--){
	MOVLW      3
	MOVWF      _counteryellow+0
L_main32:
	MOVLW      128
	XORWF      _counteryellow+0, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main33
;traffic light code.c,111 :: 		if(counteryellow==0){
	MOVF       _counteryellow+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;traffic light code.c,112 :: 		counteryellow=3; countinterrupt=3; break;}
	MOVLW      3
	MOVWF      _counteryellow+0
	MOVLW      3
	MOVWF      _countinterrupt+0
	GOTO       L_main33
L_main35:
;traffic light code.c,113 :: 		porta.b5=1;    //green south off
	BSF        PORTA+0, 5
;traffic light code.c,114 :: 		porta.b4=0;    //yellow south on
	BCF        PORTA+0, 4
;traffic light code.c,115 :: 		portb.b6=1;
	BSF        PORTB+0, 6
;traffic light code.c,116 :: 		portd=counteryellow;
	MOVF       _counteryellow+0, 0
	MOVWF      PORTD+0
;traffic light code.c,117 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;traffic light code.c,110 :: 		for(counteryellow=3;counteryellow>=0;counteryellow--){
	DECF       _counteryellow+0, 1
;traffic light code.c,118 :: 		}
	GOTO       L_main32
L_main33:
;traffic light code.c,119 :: 		}
L_main31:
;traffic light code.c,120 :: 		if(countinterrupt==3){
	MOVF       _countinterrupt+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main37
;traffic light code.c,121 :: 		porta.b4=1;    //yellow south off
	BSF        PORTA+0, 4
;traffic light code.c,122 :: 		porta.b0=0;     // red west off
	BCF        PORTA+0, 0
;traffic light code.c,123 :: 		porta.b2=1;     //Green west on
	BSF        PORTA+0, 2
;traffic light code.c,124 :: 		porta.b3=0;     //Red south on
	BCF        PORTA+0, 3
;traffic light code.c,125 :: 		}
L_main37:
;traffic light code.c,126 :: 		if(countinterrupt==4){
	MOVF       _countinterrupt+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main38
;traffic light code.c,127 :: 		for(counteryellow=3;counteryellow>=0;counteryellow--){
	MOVLW      3
	MOVWF      _counteryellow+0
L_main39:
	MOVLW      128
	XORWF      _counteryellow+0, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main40
;traffic light code.c,128 :: 		if (counteryellow==0){counteryellow=3;  break;}
	MOVF       _counteryellow+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main42
	MOVLW      3
	MOVWF      _counteryellow+0
	GOTO       L_main40
L_main42:
;traffic light code.c,129 :: 		porta.b2=0;     //green west off
	BCF        PORTA+0, 2
;traffic light code.c,130 :: 		porta.b1=1;     //yellow west on
	BSF        PORTA+0, 1
;traffic light code.c,131 :: 		porte.b1=1;     //first  7 seg. right is on
	BSF        PORTE+0, 1
;traffic light code.c,132 :: 		portc=counteryellow;
	MOVF       _counteryellow+0, 0
	MOVWF      PORTC+0
;traffic light code.c,133 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	NOP
	NOP
;traffic light code.c,127 :: 		for(counteryellow=3;counteryellow>=0;counteryellow--){
	DECF       _counteryellow+0, 1
;traffic light code.c,134 :: 		}
	GOTO       L_main39
L_main40:
;traffic light code.c,135 :: 		porta.b1=0;       //yellow west off
	BCF        PORTA+0, 1
;traffic light code.c,136 :: 		porta.b0=1;      //red west on
	BSF        PORTA+0, 0
;traffic light code.c,137 :: 		porta.B3=1;    //red south off
	BSF        PORTA+0, 3
;traffic light code.c,138 :: 		porta.B5=0;   //green south on
	BCF        PORTA+0, 5
;traffic light code.c,139 :: 		countinterrupt=1;
	MOVLW      1
	MOVWF      _countinterrupt+0
;traffic light code.c,140 :: 		}
L_main38:
;traffic light code.c,141 :: 		}
	GOTO       L_main28
L_main29:
;traffic light code.c,142 :: 		}
	GOTO       L_main1
;traffic light code.c,143 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
