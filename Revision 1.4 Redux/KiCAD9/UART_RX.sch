EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 10
Title "UART Receiver"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
$Comp
L 74xx:74HC164 U16
U 1 1 5F3EC220
P 8250 3550
F 0 "U16" V 8250 3350 50  0000 L CNN
F 1 "74HC164" V 8350 3350 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 9150 3250 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT164.pdf" H 9150 3250 50  0001 C CNN
	1    8250 3550
	0    -1   1    0   
$EndComp
$Comp
L power:+5V #PWR058
U 1 1 5F277CF9
P 7050 3550
F 0 "#PWR058" H 7050 3400 50  0001 C CNN
F 1 "+5V" V 7065 3723 50  0000 C CNN
F 2 "" H 7050 3550 50  0001 C CNN
F 3 "" H 7050 3550 50  0001 C CNN
	1    7050 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR063
U 1 1 5F282A37
P 8350 3150
F 0 "#PWR063" H 8350 3000 50  0001 C CNN
F 1 "+5V" V 8350 3350 50  0000 C CNN
F 2 "" H 8350 3150 50  0001 C CNN
F 3 "" H 8350 3150 50  0001 C CNN
	1    8350 3150
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR060
U 1 1 5F2C1CA1
P 7750 3550
F 0 "#PWR060" H 7750 3400 50  0001 C CNN
F 1 "+5V" V 7765 3723 50  0000 C CNN
F 2 "" H 7750 3550 50  0001 C CNN
F 3 "" H 7750 3550 50  0001 C CNN
	1    7750 3550
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR064
U 1 1 5F2C2967
P 8850 3550
F 0 "#PWR064" H 8850 3300 50  0001 C CNN
F 1 "GND" H 8855 3377 50  0000 C CNN
F 2 "" H 8850 3550 50  0001 C CNN
F 3 "" H 8850 3550 50  0001 C CNN
	1    8850 3550
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR048
U 1 1 5F669B0D
P 5550 3550
F 0 "#PWR048" H 5550 3300 50  0001 C CNN
F 1 "GND" H 5555 3377 50  0000 C CNN
F 2 "" H 5550 3550 50  0001 C CNN
F 3 "" H 5550 3550 50  0001 C CNN
	1    5550 3550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U13
U 5 1 5F4BD32D
P 1350 7300
F 0 "U13" V 1250 7300 50  0000 C CNN
F 1 "74HC00" V 1450 7300 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1350 7300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 1350 7300 50  0001 C CNN
	5    1350 7300
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR044
U 1 1 5F4C1B60
P 850 7300
F 0 "#PWR044" H 850 7050 50  0001 C CNN
F 1 "GND" H 855 7127 50  0000 C CNN
F 2 "" H 850 7300 50  0001 C CNN
F 3 "" H 850 7300 50  0001 C CNN
	1    850  7300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR045
U 1 1 5F4CCAD4
P 1850 7300
F 0 "#PWR045" H 1850 7150 50  0001 C CNN
F 1 "+5V" V 1850 7500 50  0000 C CNN
F 2 "" H 1850 7300 50  0001 C CNN
F 3 "" H 1850 7300 50  0001 C CNN
	1    1850 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 1300 2750 1300
Text Notes 3350 1900 0    50   ~ 0
~Q
Text Notes 3350 1400 0    50   ~ 0
Q
Wire Wire Line
	3350 1600 3350 1400
Wire Wire Line
	2750 1700 3350 1600
Wire Wire Line
	2750 1800 2750 1700
Wire Wire Line
	3350 1700 3350 1900
Wire Wire Line
	2750 1600 3350 1700
Wire Wire Line
	2750 1500 2750 1600
NoConn ~ 5750 2500
NoConn ~ 6250 2500
NoConn ~ 6150 2500
NoConn ~ 6050 2500
$Comp
L power:+5V #PWR054
U 1 1 5F269515
P 6550 2000
F 0 "#PWR054" H 6550 1850 50  0001 C CNN
F 1 "+5V" V 6565 2173 50  0000 C CNN
F 2 "" H 6550 2000 50  0001 C CNN
F 3 "" H 6550 2000 50  0001 C CNN
	1    6550 2000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR046
U 1 1 5F269219
P 4950 2000
F 0 "#PWR046" H 4950 1750 50  0001 C CNN
F 1 "GND" H 4955 1827 50  0000 C CNN
F 2 "" H 4950 2000 50  0001 C CNN
F 3 "" H 4950 2000 50  0001 C CNN
	1    4950 2000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR050
U 1 1 5F268D2F
P 5750 1500
F 0 "#PWR050" H 5750 1350 50  0001 C CNN
F 1 "+5V" V 5750 1700 50  0000 C CNN
F 2 "" H 5750 1500 50  0001 C CNN
F 3 "" H 5750 1500 50  0001 C CNN
	1    5750 1500
	1    0    0    -1  
$EndComp
Text GLabel 4850 1050 0    50   Input ~ 0
CLOCK
$Comp
L 74xx:74HC00 U13
U 2 1 5F3EAE60
P 3050 1900
F 0 "U13" H 3000 1950 50  0000 C CNN
F 1 "74HC00" H 3050 1850 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 3050 1900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3050 1900 50  0001 C CNN
	2    3050 1900
	1    0    0    -1  
$EndComp
Connection ~ 3350 1400
$Comp
L 74xx:74HC00 U13
U 1 1 5F3E9CE8
P 3050 1400
F 0 "U13" H 3000 1450 50  0000 C CNN
F 1 "74HC00" H 3050 1350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 3050 1400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3050 1400 50  0001 C CNN
	1    3050 1400
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U14
U 1 1 5F3E8875
P 5750 2000
F 0 "U14" V 5750 1850 50  0000 L CNN
F 1 "74HC161" V 5850 1850 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 5750 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 5750 2000 50  0001 C CNN
	1    5750 2000
	0    1    1    0   
$EndComp
Text HLabel 2450 1300 0    50   Input ~ 0
RX
Text Notes 2500 2000 0    50   ~ 0
~RESET
Text Notes 2600 1300 0    50   ~ 0
~SET
Text Notes 4400 1300 0    50   ~ 0
AND from ALU
Wire Wire Line
	2750 1300 2750 800 
Connection ~ 2750 1300
$Comp
L 8-Bit~CPU~32k:74HC193 U15
U 1 1 5FF9DAD5
P 6350 3550
F 0 "U15" V 6300 3450 50  0000 L CNN
F 1 "74HC193" V 6400 3350 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6350 3550 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74ls193.pdf" H 6350 3550 50  0001 C CNN
	1    6350 3550
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR053
U 1 1 5FFA32A3
P 6450 3050
F 0 "#PWR053" H 6450 2900 50  0001 C CNN
F 1 "+5V" V 6450 3250 50  0000 C CNN
F 2 "" H 6450 3050 50  0001 C CNN
F 3 "" H 6450 3050 50  0001 C CNN
	1    6450 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR055
U 1 1 5FFA37B4
P 6550 3050
F 0 "#PWR055" H 6550 2800 50  0001 C CNN
F 1 "GND" V 6550 2850 50  0000 C CNN
F 2 "" H 6550 3050 50  0001 C CNN
F 3 "" H 6550 3050 50  0001 C CNN
	1    6550 3050
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR057
U 1 1 5FFA3AD7
P 6750 3050
F 0 "#PWR057" H 6750 2800 50  0001 C CNN
F 1 "GND" V 6750 2850 50  0000 C CNN
F 2 "" H 6750 3050 50  0001 C CNN
F 3 "" H 6750 3050 50  0001 C CNN
	1    6750 3050
	-1   0    0    1   
$EndComp
NoConn ~ 6450 4050
NoConn ~ 6550 4050
NoConn ~ 6650 4050
NoConn ~ 6750 4050
$Comp
L power:+5V #PWR052
U 1 1 5FFAA905
P 6050 3050
F 0 "#PWR052" H 6050 2900 50  0001 C CNN
F 1 "+5V" V 6050 3250 50  0000 C CNN
F 2 "" H 6050 3050 50  0001 C CNN
F 3 "" H 6050 3050 50  0001 C CNN
	1    6050 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 3050 6250 2700
NoConn ~ 6250 4050
Wire Wire Line
	5950 2600 5950 3050
Wire Wire Line
	5950 2600 5950 2500
Connection ~ 5950 2600
Wire Wire Line
	4650 1600 4650 4050
$Comp
L power:GND #PWR051
U 1 1 5FFF5052
P 5850 3050
F 0 "#PWR051" H 5850 2800 50  0001 C CNN
F 1 "GND" V 5850 2850 50  0000 C CNN
F 2 "" H 5850 3050 50  0001 C CNN
F 3 "" H 5850 3050 50  0001 C CNN
	1    5850 3050
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR056
U 1 1 5FFF7661
P 6650 3050
F 0 "#PWR056" H 6650 2900 50  0001 C CNN
F 1 "+5V" V 6650 3250 50  0000 C CNN
F 2 "" H 6650 3050 50  0001 C CNN
F 3 "" H 6650 3050 50  0001 C CNN
	1    6650 3050
	1    0    0    -1  
$EndComp
Text Notes 5800 4700 2    50   ~ 0
DATA_READY (SYNC)
$Comp
L power:+5V #PWR062
U 1 1 601038D6
P 8050 3150
F 0 "#PWR062" H 8050 3000 50  0001 C CNN
F 1 "+5V" V 8065 3323 50  0000 C CNN
F 2 "" H 8050 3150 50  0001 C CNN
F 3 "" H 8050 3150 50  0001 C CNN
	1    8050 3150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4550 1400 4550 2700
Wire Wire Line
	4550 2700 6250 2700
Connection ~ 4550 1400
Wire Wire Line
	4550 1400 4650 1400
Text Notes 3350 5550 0    50   ~ 0
Sync DR is needed to prevent DR going high during the second\nphase of the clock (this would allow for erasing the value while\nskipping the register store at the rising edge of the clock).\n\nSometimes DR goes high right after a TO polling. Since\nTO remains valid 50ns after the falling edge of the clock,\nthis activates the output for 50ns. However, this is not a\nproblem, since no other component is outputing. Also\nno reset is performed since CLOCK is low during that "pulse".\n
Text Notes 6400 6350 0    50   ~ 0
DR=TO=1 =>\nactive only during\nsecond clockphase:\n\nOnly after reading a\nvalue, the circuit\n(including DR) is\nreset and ready to\nreceive.\nATTENTION: RX\nhas to have reached\nthe HIGH stop bit\nfor that!
Text Notes 1300 1800 0    50   ~ 0
A falling edge at RX\nactivates the counter\nfor the duration of one\n10 bits.\nThen, this shift register\nremains frozes and DR\nis signaled.
Text Notes 5600 1100 0    50   ~ 0
Using ~CLOCK~ instead of CLOCK ensures that ~TCD~\nhappens IN SYNC with the changing control signals.
Text Notes 6400 5200 0    50   ~ 0
Output is only switched on\nif DR and TO are present.
Text Notes 4750 4050 0    50   ~ 0
LOW = timer stop
Text Notes 4750 2700 0    50   ~ 0
HIGH = timer start
Wire Wire Line
	2750 800  8250 800 
Wire Wire Line
	8550 2600 8550 3150
Wire Wire Line
	5950 2600 8550 2600
Wire Wire Line
	8250 3150 8250 800 
$Comp
L 74xx:74HC164 U18
U 1 1 606E97BD
P 9650 3550
F 0 "U18" V 9650 3350 50  0000 L CNN
F 1 "74HC164" V 9750 3350 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 10550 3250 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT164.pdf" H 10550 3250 50  0001 C CNN
	1    9650 3550
	0    -1   1    0   
$EndComp
$Comp
L power:+5V #PWR067
U 1 1 606EAB9D
P 9450 3150
F 0 "#PWR067" H 9450 3000 50  0001 C CNN
F 1 "+5V" V 9465 3323 50  0000 C CNN
F 2 "" H 9450 3150 50  0001 C CNN
F 3 "" H 9450 3150 50  0001 C CNN
	1    9450 3150
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR066
U 1 1 606EB13A
P 9150 3550
F 0 "#PWR066" H 9150 3400 50  0001 C CNN
F 1 "+5V" V 9165 3723 50  0000 C CNN
F 2 "" H 9150 3550 50  0001 C CNN
F 3 "" H 9150 3550 50  0001 C CNN
	1    9150 3550
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR069
U 1 1 606EB633
P 10250 3550
F 0 "#PWR069" H 10250 3300 50  0001 C CNN
F 1 "GND" H 10255 3377 50  0000 C CNN
F 2 "" H 10250 3550 50  0001 C CNN
F 3 "" H 10250 3550 50  0001 C CNN
	1    10250 3550
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR068
U 1 1 606EB943
P 9750 3150
F 0 "#PWR068" H 9750 3000 50  0001 C CNN
F 1 "+5V" V 9750 3350 50  0000 C CNN
F 2 "" H 9750 3150 50  0001 C CNN
F 3 "" H 9750 3150 50  0001 C CNN
	1    9750 3150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8550 2600 9950 2600
Wire Wire Line
	9950 2600 9950 3150
Connection ~ 8550 2600
Wire Wire Line
	9650 3150 9650 2800
Wire Wire Line
	9650 2800 9000 2800
Wire Wire Line
	9000 2800 9000 3950
Wire Wire Line
	9000 3950 8650 3950
NoConn ~ 7950 3950
Connection ~ 8650 3950
NoConn ~ 9450 3950
NoConn ~ 9550 3950
NoConn ~ 9650 3950
NoConn ~ 9750 3950
NoConn ~ 9850 3950
NoConn ~ 9950 3950
NoConn ~ 10050 3950
$Comp
L 8-Bit~CPU~32k:74HC08 U?
U 4 1 60A3817E
P 4950 1500
AR Path="/5EC57909/60A3817E" Ref="U?"  Part="1" 
AR Path="/5F645851/60A3817E" Ref="U9"  Part="4" 
F 0 "U9" H 4900 1550 50  0000 C CNN
F 1 "74HC08" H 4950 1450 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 4950 1500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 4950 1500 50  0001 C CNN
	4    4950 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 1400 4550 1400
$Comp
L 74xx:74HC00 U23
U 5 1 6088BC6A
P 2550 7300
F 0 "U23" V 2450 7300 50  0000 C CNN
F 1 "74HC00" V 2650 7300 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2550 7300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 2550 7300 50  0001 C CNN
	5    2550 7300
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 6088BC70
P 2050 7300
F 0 "#PWR01" H 2050 7050 50  0001 C CNN
F 1 "GND" H 2055 7127 50  0000 C CNN
F 2 "" H 2050 7300 50  0001 C CNN
F 3 "" H 2050 7300 50  0001 C CNN
	1    2050 7300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 6088BC76
P 3050 7300
F 0 "#PWR02" H 3050 7150 50  0001 C CNN
F 1 "+5V" V 3050 7500 50  0000 C CNN
F 2 "" H 3050 7300 50  0001 C CNN
F 3 "" H 3050 7300 50  0001 C CNN
	1    3050 7300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U23
U 2 1 6088E054
P 6150 4950
F 0 "U23" V 6200 4950 50  0000 C CNN
F 1 "74HC00" V 6100 4950 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6150 4950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6150 4950 50  0001 C CNN
	2    6150 4950
	0    -1   1    0   
$EndComp
$Comp
L 74xx:74HC00 U23
U 3 1 6088F0B6
P 5150 1050
F 0 "U23" V 5200 1050 50  0000 C CNN
F 1 "74HC00" V 5100 1050 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 5150 1050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 5150 1050 50  0001 C CNN
	3    5150 1050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U23
U 1 1 6088C975
P 6050 4350
F 0 "U23" V 6100 4350 50  0000 C CNN
F 1 "74HC00" V 6000 4350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6050 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6050 4350 50  0001 C CNN
	1    6050 4350
	0    1    1    0   
$EndComp
Text HLabel 6250 4650 1    50   Input ~ 0
TO
Connection ~ 6150 5250
$Comp
L 74xx:74HC00 U13
U 3 1 5F27E679
P 6050 6150
F 0 "U13" V 6100 6150 50  0000 C CNN
F 1 "74HC00" V 6000 6150 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6050 6150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6050 6150 50  0001 C CNN
	3    6050 6150
	0    -1   1    0   
$EndComp
Wire Wire Line
	2750 2000 2750 6450
Wire Wire Line
	9350 3950 9350 4250
Wire Wire Line
	6150 5250 6250 5250
Wire Wire Line
	9350 4250 8750 4250
Wire Wire Line
	8650 3950 8650 4250
Wire Wire Line
	8550 3950 8550 4250
Wire Wire Line
	8450 3950 8450 4250
Wire Wire Line
	8350 3950 8350 4250
Wire Wire Line
	8250 3950 8250 4250
Wire Wire Line
	8150 3950 8150 4250
Wire Wire Line
	8050 3950 8050 4250
Text Notes 8000 5950 0    50   ~ 0
If no data is present,\nreading will yield $ff\nsince 74HC245 remains\ninactive and the bus\nlines are tied HIGH.
Text HLabel 8050 5250 3    50   Output ~ 0
BUS7
Text HLabel 8150 5250 3    50   Output ~ 0
BUS6
Text HLabel 8250 5250 3    50   Output ~ 0
BUS5
Text HLabel 8350 5250 3    50   Output ~ 0
BUS4
Text HLabel 8450 5250 3    50   Output ~ 0
BUS3
Text HLabel 8550 5250 3    50   Output ~ 0
BUS2
Text HLabel 8650 5250 3    50   Output ~ 0
BUS1
Text HLabel 8750 5250 3    50   Output ~ 0
BUS0
Wire Wire Line
	6050 4050 6150 4050
Wire Wire Line
	5950 4050 6050 4050
Connection ~ 6050 4050
Wire Wire Line
	5950 4050 4650 4050
Connection ~ 5950 4050
Connection ~ 6250 5250
Wire Wire Line
	6250 5250 7750 5250
Wire Wire Line
	6050 5250 6150 5250
Text GLabel 5950 5850 1    50   Input ~ 0
CLOCK
Wire Wire Line
	6050 6450 2750 6450
$Comp
L 74xx:74HC00 U13
U 4 1 5F281BD9
P 6150 5550
F 0 "U13" V 6200 5550 50  0000 C CNN
F 1 "74HC00" V 6100 5550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6150 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6150 5550 50  0001 C CNN
	4    6150 5550
	0    1    1    0   
$EndComp
Wire Wire Line
	5550 1500 5650 1500
Wire Wire Line
	5650 1500 5750 1500
Connection ~ 5650 1500
Connection ~ 5750 1500
Text Notes 2200 6950 0    50   ~ 0
NAND_D used in TX
Wire Wire Line
	5450 1050 5450 1500
Wire Wire Line
	4850 950  4850 1150
$Comp
L power:GND #PWR061
U 1 1 605A31B0
P 7850 5250
F 0 "#PWR061" H 7850 5000 50  0001 C CNN
F 1 "GND" H 7855 5077 50  0000 C CNN
F 2 "" H 7850 5250 50  0001 C CNN
F 3 "" H 7850 5250 50  0001 C CNN
	1    7850 5250
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC245 U17
U 1 1 5FFA18B1
P 8250 4750
F 0 "U17" V 8200 4700 50  0000 L CNN
F 1 "74HC245" V 8300 4600 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 8250 4750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 8250 4750 50  0001 C CNN
	1    8250 4750
	0    1    -1   0   
$EndComp
$Comp
L power:GND #PWR059
U 1 1 5F2C2D6C
P 7450 4750
F 0 "#PWR059" H 7450 4500 50  0001 C CNN
F 1 "GND" H 7455 4577 50  0000 C CNN
F 2 "" H 7450 4750 50  0001 C CNN
F 3 "" H 7450 4750 50  0001 C CNN
	1    7450 4750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR065
U 1 1 5F2C2012
P 9050 4750
F 0 "#PWR065" H 9050 4600 50  0001 C CNN
F 1 "+5V" V 9065 4923 50  0000 C CNN
F 2 "" H 9050 4750 50  0001 C CNN
F 3 "" H 9050 4750 50  0001 C CNN
	1    9050 4750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0202
U 1 1 6080ED79
P 5950 1500
F 0 "#PWR0202" H 5950 1250 50  0001 C CNN
F 1 "GND" V 5950 1300 50  0000 C CNN
F 2 "" H 5950 1500 50  0001 C CNN
F 3 "" H 5950 1500 50  0001 C CNN
	1    5950 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0204
U 1 1 6080F403
P 6050 1500
F 0 "#PWR0204" H 6050 1250 50  0001 C CNN
F 1 "GND" V 6050 1300 50  0000 C CNN
F 2 "" H 6050 1500 50  0001 C CNN
F 3 "" H 6050 1500 50  0001 C CNN
	1    6050 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0205
U 1 1 6080F53F
P 6150 1500
F 0 "#PWR0205" H 6150 1250 50  0001 C CNN
F 1 "GND" V 6150 1300 50  0000 C CNN
F 2 "" H 6150 1500 50  0001 C CNN
F 3 "" H 6150 1500 50  0001 C CNN
	1    6150 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0206
U 1 1 6080F676
P 6250 1500
F 0 "#PWR0206" H 6250 1250 50  0001 C CNN
F 1 "GND" V 6250 1300 50  0000 C CNN
F 2 "" H 6250 1500 50  0001 C CNN
F 3 "" H 6250 1500 50  0001 C CNN
	1    6250 1500
	-1   0    0    1   
$EndComp
$EndSCHEMATC
