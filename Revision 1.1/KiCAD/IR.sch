EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 9 10
Title "Control Logic"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 6450 4450 1    50   Output ~ 0
CO
Text HLabel 6350 4450 1    50   Output ~ 0
CI
Text HLabel 9850 4450 1    50   Output ~ 0
~AI
Text HLabel 9750 5450 3    50   Output ~ 0
~AO
Text HLabel 9650 5450 3    50   Output ~ 0
~BI
Text HLabel 9550 5450 3    50   Output ~ 0
~BO
Text HLabel 9550 4450 1    50   Output ~ 0
MI
Text HLabel 6450 5850 3    50   Output ~ 0
~EO
Text HLabel 6550 5850 3    50   Output ~ 0
ES
Text HLabel 6650 5850 3    50   Output ~ 0
EC
Text HLabel 9750 4450 1    50   Output ~ 0
~RO
$Comp
L power:+5V #PWR?
U 1 1 5FA1E152
P 8450 4450
AR Path="/5EC573DA/5FA1E152" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA1E152" Ref="#PWR0184"  Part="1" 
F 0 "#PWR0184" H 8450 4300 50  0001 C CNN
F 1 "+5V" V 8450 4550 50  0000 L CNN
F 2 "" H 8450 4450 50  0001 C CNN
F 3 "" H 8450 4450 50  0001 C CNN
	1    8450 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FA36417
P 9850 5450
AR Path="/5EC573DA/5FA36417" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA36417" Ref="#PWR0191"  Part="1" 
F 0 "#PWR0191" H 9850 5200 50  0001 C CNN
F 1 "GND" V 9850 5350 50  0000 R CNN
F 2 "" H 9850 5450 50  0001 C CNN
F 3 "" H 9850 5450 50  0001 C CNN
	1    9850 5450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5FA1DAD5
P 5350 4450
AR Path="/5EC573DA/5FA1DAD5" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA1DAD5" Ref="#PWR0170"  Part="1" 
F 0 "#PWR0170" H 5350 4300 50  0001 C CNN
F 1 "+5V" V 5350 4550 50  0000 L CNN
F 2 "" H 5350 4450 50  0001 C CNN
F 3 "" H 5350 4450 50  0001 C CNN
	1    5350 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FB90580
P 6750 5450
AR Path="/5EC573DA/5FB90580" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FB90580" Ref="#PWR0177"  Part="1" 
F 0 "#PWR0177" H 6750 5200 50  0001 C CNN
F 1 "GND" V 6750 5350 50  0000 R CNN
F 2 "" H 6750 5450 50  0001 C CNN
F 3 "" H 6750 5450 50  0001 C CNN
	1    6750 5450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0190
U 1 1 5F0344C4
P 9350 4450
F 0 "#PWR0190" H 9350 4200 50  0001 C CNN
F 1 "GND" V 9350 4250 50  0000 C CNN
F 2 "" H 9350 4450 50  0001 C CNN
F 3 "" H 9350 4450 50  0001 C CNN
	1    9350 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0176
U 1 1 5F03518A
P 6250 4450
F 0 "#PWR0176" H 6250 4200 50  0001 C CNN
F 1 "GND" V 6250 4250 50  0000 C CNN
F 2 "" H 6250 4450 50  0001 C CNN
F 3 "" H 6250 4450 50  0001 C CNN
	1    6250 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0175
U 1 1 5F47098C
P 6050 4450
F 0 "#PWR0175" H 6050 4200 50  0001 C CNN
F 1 "GND" V 6050 4250 50  0000 C CNN
F 2 "" H 6050 4450 50  0001 C CNN
F 3 "" H 6050 4450 50  0001 C CNN
	1    6050 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0189
U 1 1 5F470BD8
P 9150 4450
F 0 "#PWR0189" H 9150 4200 50  0001 C CNN
F 1 "GND" V 9150 4250 50  0000 C CNN
F 2 "" H 9150 4450 50  0001 C CNN
F 3 "" H 9150 4450 50  0001 C CNN
	1    9150 4450
	-1   0    0    1   
$EndComp
Text HLabel 6950 4050 0    50   Output ~ 0
TI
Text HLabel 6950 3650 0    50   Output ~ 0
TO
$Comp
L 8-Bit~CPU~32k:74HC08 U?
U 5 1 6018D24D
P 1250 7350
AR Path="/5F645851/6018D24D" Ref="U?"  Part="5" 
AR Path="/5EC57429/6018D24D" Ref="U42"  Part="5" 
F 0 "U42" V 1350 7350 50  0000 C CNN
F 1 "74HC08" V 1150 7350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1250 7350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 1250 7350 50  0001 C CNN
	5    1250 7350
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6018D253
P 750 7350
AR Path="/5F645851/6018D253" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/6018D253" Ref="#PWR0159"  Part="1" 
F 0 "#PWR0159" H 750 7100 50  0001 C CNN
F 1 "GND" H 755 7177 50  0000 C CNN
F 2 "" H 750 7350 50  0001 C CNN
F 3 "" H 750 7350 50  0001 C CNN
	1    750  7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 6018D259
P 1750 7350
AR Path="/5F645851/6018D259" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/6018D259" Ref="#PWR0161"  Part="1" 
F 0 "#PWR0161" H 1750 7200 50  0001 C CNN
F 1 "+5V" V 1765 7523 50  0000 C CNN
F 2 "" H 1750 7350 50  0001 C CNN
F 3 "" H 1750 7350 50  0001 C CNN
	1    1750 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 601D0E98
P 5250 4450
AR Path="/5EC573DA/601D0E98" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/601D0E98" Ref="#PWR0169"  Part="1" 
F 0 "#PWR0169" H 5250 4300 50  0001 C CNN
F 1 "+5V" V 5250 4550 50  0000 L CNN
F 2 "" H 5250 4450 50  0001 C CNN
F 3 "" H 5250 4450 50  0001 C CNN
	1    5250 4450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 601D13A7
P 8350 4450
AR Path="/5EC573DA/601D13A7" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/601D13A7" Ref="#PWR0183"  Part="1" 
F 0 "#PWR0183" H 8350 4300 50  0001 C CNN
F 1 "+5V" V 8350 4550 50  0000 L CNN
F 2 "" H 8350 4450 50  0001 C CNN
F 3 "" H 8350 4450 50  0001 C CNN
	1    8350 4450
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC04 U?
U 7 1 5FFCCF87
P 2450 7350
AR Path="/5EC57456/5FFCCF87" Ref="U?"  Part="7" 
AR Path="/5EC57429/5FFCCF87" Ref="U1"  Part="7" 
F 0 "U1" V 2550 7350 50  0000 C CNN
F 1 "74HC04" V 2350 7350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2450 7350 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 2450 7350 50  0001 C CNN
	7    2450 7350
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FFCCF99
P 1950 7350
AR Path="/5F645851/5FFCCF99" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FFCCF99" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FFCCF99" Ref="#PWR0163"  Part="1" 
F 0 "#PWR0163" H 1950 7100 50  0001 C CNN
F 1 "GND" H 1955 7177 50  0000 C CNN
F 2 "" H 1950 7350 50  0001 C CNN
F 3 "" H 1950 7350 50  0001 C CNN
	1    1950 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5FFCCF9F
P 2950 7350
AR Path="/5EC5738F/5FFCCF9F" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FFCCF9F" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FFCCF9F" Ref="#PWR0166"  Part="1" 
F 0 "#PWR0166" H 2950 7200 50  0001 C CNN
F 1 "+5V" H 2965 7523 50  0000 C CNN
F 2 "" H 2950 7350 50  0001 C CNN
F 3 "" H 2950 7350 50  0001 C CNN
	1    2950 7350
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:SST39SF010A U45
U 1 1 5FFF254E
P 6150 4950
F 0 "U45" V 6050 5100 50  0000 R CNN
F 1 "SST39SF010A MSB" V 6200 5300 50  0000 R CNN
F 2 "Package_DIP:DIP-32_W15.24mm_Socket" H 6150 4950 50  0001 C CNN
F 3 "" H 6150 4950 50  0001 C CNN
	1    6150 4950
	0    -1   -1   0   
$EndComp
$Comp
L 8-Bit~CPU~32k:SST39SF010A U47
U 1 1 5FFF7540
P 9250 4950
F 0 "U47" V 9150 5100 50  0000 R CNN
F 1 "SST39SF010A LSB" V 9300 5300 50  0000 R CNN
F 2 "Package_DIP:DIP-32_W15.24mm_Socket" H 9250 4950 50  0001 C CNN
F 3 "" H 9250 4950 50  0001 C CNN
	1    9250 4950
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0171
U 1 1 5FFFD5EF
P 5350 5450
F 0 "#PWR0171" H 5350 5200 50  0001 C CNN
F 1 "GND" V 5350 5250 50  0000 C CNN
F 2 "" H 5350 5450 50  0001 C CNN
F 3 "" H 5350 5450 50  0001 C CNN
	1    5350 5450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0185
U 1 1 5FFFDC66
P 8450 5450
F 0 "#PWR0185" H 8450 5200 50  0001 C CNN
F 1 "GND" V 8450 5250 50  0000 C CNN
F 2 "" H 8450 5450 50  0001 C CNN
F 3 "" H 8450 5450 50  0001 C CNN
	1    8450 5450
	1    0    0    -1  
$EndComp
Text GLabel 7400 1700 0    50   Input ~ 0
CLOCK
$Comp
L power:+5V #PWR?
U 1 1 5FA53785
P 8300 2100
AR Path="/5EC573DA/5FA53785" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA53785" Ref="#PWR0182"  Part="1" 
F 0 "#PWR0182" H 8300 1950 50  0001 C CNN
F 1 "+5V" V 8300 2200 50  0000 L CNN
F 2 "" H 8300 2100 50  0001 C CNN
F 3 "" H 8300 2100 50  0001 C CNN
	1    8300 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FA36B57
P 7500 2600
AR Path="/5EC573DA/5FA36B57" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA36B57" Ref="#PWR0178"  Part="1" 
F 0 "#PWR0178" H 7500 2350 50  0001 C CNN
F 1 "GND" H 7550 2450 50  0000 R CNN
F 2 "" H 7500 2600 50  0001 C CNN
F 3 "" H 7500 2600 50  0001 C CNN
	1    7500 2600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 600133B6
P 8200 2100
AR Path="/5EC573DA/600133B6" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/600133B6" Ref="#PWR0181"  Part="1" 
F 0 "#PWR0181" H 8200 1950 50  0001 C CNN
F 1 "+5V" V 8200 2200 50  0000 L CNN
F 2 "" H 8200 2100 50  0001 C CNN
F 3 "" H 8200 2100 50  0001 C CNN
	1    8200 2100
	1    0    0    -1  
$EndComp
NoConn ~ 8500 2100
NoConn ~ 8600 2100
NoConn ~ 8700 2100
NoConn ~ 8800 2100
$Comp
L power:+5V #PWR?
U 1 1 5FA37491
P 9100 2600
AR Path="/5EC573DA/5FA37491" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FA37491" Ref="#PWR0188"  Part="1" 
F 0 "#PWR0188" H 9100 2450 50  0001 C CNN
F 1 "+5V" V 9115 2728 50  0000 L CNN
F 2 "" H 9100 2600 50  0001 C CNN
F 3 "" H 9100 2600 50  0001 C CNN
	1    9100 2600
	1    0    0    -1  
$EndComp
NoConn ~ 8300 3100
$Comp
L power:+5V #PWR?
U 1 1 6001360D
P 8100 2100
AR Path="/5EC573DA/6001360D" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/6001360D" Ref="#PWR0180"  Part="1" 
F 0 "#PWR0180" H 8100 1950 50  0001 C CNN
F 1 "+5V" V 8100 2200 50  0000 L CNN
F 2 "" H 8100 2100 50  0001 C CNN
F 3 "" H 8100 2100 50  0001 C CNN
	1    8100 2100
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U46
U 1 1 5F109570
P 8300 2600
F 0 "U46" V 8400 2550 50  0000 L CNN
F 1 "74HC161" V 8300 2500 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 8300 2600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 8300 2600 50  0001 C CNN
	1    8300 2600
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC08 U42
U 1 1 60341101
P 7250 3650
F 0 "U42" H 7250 3700 50  0000 C CNN
F 1 "74HC08" H 7250 3600 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7250 3650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7250 3650 50  0001 C CNN
	1    7250 3650
	-1   0    0    1   
$EndComp
Text Notes 6750 4400 1    50   ~ 0
~IC
$Comp
L 8-Bit~CPU~32k:74HC08 U42
U 3 1 60050FB4
P 7250 4050
F 0 "U42" H 7350 4000 50  0000 R CNN
F 1 "74HC08" H 7400 4100 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7250 4050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7250 4050 50  0001 C CNN
	3    7250 4050
	-1   0    0    1   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC08 U42
U 4 1 601797B4
P 5300 1600
AR Path="/5EC57429/601797B4" Ref="U42"  Part="4" 
AR Path="/5F64487D/601797B4" Ref="U?"  Part="4" 
F 0 "U42" H 5350 1550 50  0000 R CNN
F 1 "74HC08" H 5450 1650 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 5300 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 5300 1600 50  0001 C CNN
	4    5300 1600
	-1   0    0    1   
$EndComp
Text HLabel 6450 3650 0    50   Output ~ 0
ME
Connection ~ 6550 3650
Wire Wire Line
	6450 3650 6550 3650
Text HLabel 6450 3850 0    50   Output ~ 0
CE
Wire Wire Line
	6550 3650 6550 3850
Wire Wire Line
	6550 3850 6550 4450
Connection ~ 6550 3850
Wire Wire Line
	6550 3850 6450 3850
$Comp
L Device:C_Small C28
U 1 1 600733D2
P 7650 3850
F 0 "C28" V 7550 3950 50  0000 C CNN
F 1 "470pF" V 7750 3900 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 7650 3850 50  0001 C CNN
F 3 "~" H 7650 3850 50  0001 C CNN
	1    7650 3850
	0    1    1    0   
$EndComp
Text Notes 7750 1300 0    50   ~ 0
STEP COUNTER
Text Notes 4150 1300 0    50   ~ 0
INSTRUCTION REGISTER
Text Notes 1750 1350 0    50   ~ 0
FLAGS REGISTER
Text Notes 6650 4400 1    50   ~ 0
TR
Text Label 8800 3100 3    50   ~ 0
Step0
Text Label 8700 3100 3    50   ~ 0
Step1
Text Label 8600 3100 3    50   ~ 0
Step2
Text Label 8500 3100 3    50   ~ 0
Step3
Text Label 9450 5450 3    50   ~ 0
Step0
Text Label 9350 5450 3    50   ~ 0
Step1
Text Label 9250 5450 3    50   ~ 0
Step2
Text Label 9150 5450 3    50   ~ 0
Step3
Text Label 6350 5450 3    50   ~ 0
Step0
Text Label 6250 5450 3    50   ~ 0
Step1
Text Label 6150 5450 3    50   ~ 0
Step2
Text Label 6050 5450 3    50   ~ 0
Step3
Text Label 6150 4450 1    50   ~ 0
Flag0
Text Label 9250 4450 1    50   ~ 0
Flag0
Text Label 5950 4450 1    50   ~ 0
Flag1
Text Label 9050 4450 1    50   ~ 0
Flag1
Text Label 5550 5450 3    50   ~ 0
Flag2
Text Label 8650 5450 3    50   ~ 0
Flag2
Text Label 9050 5450 3    50   ~ 0
Inst0
Text Label 8950 5450 3    50   ~ 0
Inst1
Text Label 8850 5450 3    50   ~ 0
Inst2
Text Label 8750 5450 3    50   ~ 0
Inst3
Text Label 5950 5450 3    50   ~ 0
Inst0
Text Label 5850 5450 3    50   ~ 0
Inst1
Text Label 5750 5450 3    50   ~ 0
Inst2
Text Label 5650 5450 3    50   ~ 0
Inst3
Text Label 5750 4450 1    50   ~ 0
Inst4
Text Label 5850 4450 1    50   ~ 0
Inst5
Text Label 8850 4450 1    50   ~ 0
Inst4
Text Label 8950 4450 1    50   ~ 0
Inst5
$Comp
L power:GND #PWR0186
U 1 1 605476B9
P 8550 5450
F 0 "#PWR0186" H 8550 5200 50  0001 C CNN
F 1 "GND" V 8550 5250 50  0000 C CNN
F 2 "" H 8550 5450 50  0001 C CNN
F 3 "" H 8550 5450 50  0001 C CNN
	1    8550 5450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0187
U 1 1 60547A15
P 8650 4450
F 0 "#PWR0187" H 8650 4200 50  0001 C CNN
F 1 "GND" V 8650 4250 50  0000 C CNN
F 2 "" H 8650 4450 50  0001 C CNN
F 3 "" H 8650 4450 50  0001 C CNN
	1    8650 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0174
U 1 1 605482B7
P 5550 4450
F 0 "#PWR0174" H 5550 4200 50  0001 C CNN
F 1 "GND" V 5550 4250 50  0000 C CNN
F 2 "" H 5550 4450 50  0001 C CNN
F 3 "" H 5550 4450 50  0001 C CNN
	1    5550 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0173
U 1 1 60548AFF
P 5450 5450
F 0 "#PWR0173" H 5450 5200 50  0001 C CNN
F 1 "GND" V 5450 5250 50  0000 C CNN
F 2 "" H 5450 5450 50  0001 C CNN
F 3 "" H 5450 5450 50  0001 C CNN
	1    5450 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 2200 7200 2200
Text GLabel 7200 2000 0    50   Input ~ 0
~RESET
$Comp
L 8-Bit~CPU~32k:74HC08 U42
U 2 1 60392726
P 7500 2100
F 0 "U42" H 7600 2050 50  0000 R CNN
F 1 "74HC08" H 7650 2150 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7500 2100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7500 2100 50  0001 C CNN
	2    7500 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0179
U 1 1 600ACCE3
P 7750 3850
F 0 "#PWR0179" H 7750 3600 50  0001 C CNN
F 1 "GND" V 7750 3700 50  0000 R CNN
F 2 "" H 7750 3850 50  0001 C CNN
F 3 "" H 7750 3850 50  0001 C CNN
	1    7750 3850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7550 3750 7550 3850
Connection ~ 7550 3850
Wire Wire Line
	7550 3850 7550 3950
Wire Wire Line
	6650 3850 7550 3850
Wire Wire Line
	9450 4150 9450 4450
Wire Wire Line
	6750 2200 6750 4450
Text Notes 7600 4100 0    50   ~ 0
>=140pF
Wire Wire Line
	6650 5450 6650 5850
Wire Wire Line
	1350 1750 1350 5750
Text HLabel 3000 2100 1    50   Input ~ 0
FLAG_Z
Text Label 2800 3100 3    50   ~ 0
Flag2
Text Label 2900 3100 3    50   ~ 0
Flag1
Text Label 3000 3100 3    50   ~ 0
Flag0
Text Notes 1350 1750 0    50   ~ 0
~FI~ together with ~EO~
Connection ~ 2100 2100
Wire Wire Line
	2100 2100 2100 1750
$Comp
L power:GND #PWR?
U 1 1 5FFC5F2B
P 2500 2100
AR Path="/5EC573DA/5FFC5F2B" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5FFC5F2B" Ref="#PWR0165"  Part="1" 
F 0 "#PWR0165" H 2500 1850 50  0001 C CNN
F 1 "GND" V 2505 1927 50  0000 C CNN
F 2 "" H 2500 2100 50  0001 C CNN
F 3 "" H 2500 2100 50  0001 C CNN
	1    2500 2100
	-1   0    0    1   
$EndComp
Wire Wire Line
	2100 1750 1350 1750
$Comp
L 8-Bit~CPU~32k:74HC173 U43
U 1 1 5F10528C
P 2400 2600
F 0 "U43" V 2500 2500 50  0000 L CNN
F 1 "74HC173" V 2400 2500 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 2400 2600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 2400 2600 50  0001 C CNN
	1    2400 2600
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F030AD8
P 1800 2100
AR Path="/5EC573DA/5F030AD8" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5F030AD8" Ref="#PWR0162"  Part="1" 
F 0 "#PWR0162" H 1800 1850 50  0001 C CNN
F 1 "GND" V 1805 1927 50  0000 C CNN
F 2 "" H 1800 2100 50  0001 C CNN
F 3 "" H 1800 2100 50  0001 C CNN
	1    1800 2100
	-1   0    0    1   
$EndComp
Text GLabel 2000 2100 1    50   Input ~ 0
CLOCK
Wire Wire Line
	2100 2100 2200 2100
$Comp
L power:GND #PWR?
U 1 1 5F996FBD
P 2400 2100
AR Path="/5EC573DA/5F996FBD" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5F996FBD" Ref="#PWR0164"  Part="1" 
F 0 "#PWR0164" H 2400 1850 50  0001 C CNN
F 1 "GND" V 2400 2000 50  0000 R CNN
F 2 "" H 2400 2100 50  0001 C CNN
F 3 "" H 2400 2100 50  0001 C CNN
	1    2400 2100
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5F97666F
P 3300 2600
AR Path="/5EC573DA/5F97666F" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5F97666F" Ref="#PWR0167"  Part="1" 
F 0 "#PWR0167" H 3300 2450 50  0001 C CNN
F 1 "+5V" V 3300 2700 50  0000 L CNN
F 2 "" H 3300 2600 50  0001 C CNN
F 3 "" H 3300 2600 50  0001 C CNN
	1    3300 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F9762E3
P 1500 2600
AR Path="/5EC573DA/5F9762E3" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/5F9762E3" Ref="#PWR0160"  Part="1" 
F 0 "#PWR0160" H 1500 2350 50  0001 C CNN
F 1 "GND" H 1600 2450 50  0000 R CNN
F 2 "" H 1500 2600 50  0001 C CNN
F 3 "" H 1500 2600 50  0001 C CNN
	1    1500 2600
	1    0    0    -1  
$EndComp
Text HLabel 2800 2100 1    50   Input ~ 0
FLAG_N
Text HLabel 2900 2100 1    50   Input ~ 0
FLAG_C
Text HLabel 9650 4450 1    50   Output ~ 0
RI
Connection ~ 8350 4150
Wire Wire Line
	7550 4150 8350 4150
Wire Wire Line
	8350 3550 7550 3550
Connection ~ 8350 3550
Wire Wire Line
	8350 3550 8450 3550
Text HLabel 8450 3550 2    50   Output ~ 0
~HI
$Comp
L 74xx:74HC04 U1
U 1 1 5F4FBC20
P 8350 3850
F 0 "U1" V 8350 3850 50  0000 C CNN
F 1 "74HC04" V 8250 3850 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 8350 3850 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 8350 3850 50  0001 C CNN
	1    8350 3850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8350 4150 9450 4150
Connection ~ 9450 4150
Wire Wire Line
	6550 1700 6550 3650
Wire Wire Line
	6550 1700 5600 1700
Text Notes 7100 4800 0    50   ~ 0
The cap prevents\nfalse triggering of\nLEVEL-triggered\nfunctions due to in-\nevitable switching\nspikes in CTRL.
Text HLabel 9550 4150 2    50   Output ~ 0
HI
Text GLabel 5000 1400 2    50   Input ~ 0
CLOCK
Text HLabel 4700 2100 1    50   Input ~ 0
BUS4
Text HLabel 4600 2100 1    50   Input ~ 0
BUS5
Text Label 4700 3100 3    50   ~ 0
Inst4
Text Label 4600 3100 3    50   ~ 0
Inst5
Text Label 5100 3100 3    50   ~ 0
Inst0
Text Label 5000 3100 3    50   ~ 0
Inst1
Text Label 4900 3100 3    50   ~ 0
Inst2
Text Label 4800 3100 3    50   ~ 0
Inst3
Text HLabel 5100 2100 1    50   Input ~ 0
BUS0
Text HLabel 5000 2100 1    50   Input ~ 0
BUS1
Text HLabel 4900 2100 1    50   Input ~ 0
BUS2
Text HLabel 4800 2100 1    50   Input ~ 0
BUS3
$Comp
L 8-Bit~CPU~32k:74HC174 U44
U 1 1 607BBF00
P 4700 2600
F 0 "U44" V 4650 2500 50  0000 L CNN
F 1 "74HC174" V 4750 2400 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 4700 2600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS174" H 4700 2600 50  0001 C CNN
	1    4700 2600
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 607BF785
P 5400 2600
AR Path="/5EC573DA/607BF785" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/607BF785" Ref="#PWR0172"  Part="1" 
F 0 "#PWR0172" H 5400 2450 50  0001 C CNN
F 1 "+5V" V 5400 2700 50  0000 L CNN
F 2 "" H 5400 2600 50  0001 C CNN
F 3 "" H 5400 2600 50  0001 C CNN
	1    5400 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 607BFBE8
P 3900 2600
AR Path="/5EC573DA/607BFBE8" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/607BFBE8" Ref="#PWR0168"  Part="1" 
F 0 "#PWR0168" H 3900 2350 50  0001 C CNN
F 1 "GND" H 4000 2450 50  0000 R CNN
F 2 "" H 3900 2600 50  0001 C CNN
F 3 "" H 3900 2600 50  0001 C CNN
	1    3900 2600
	1    0    0    -1  
$EndComp
Text Notes 3850 1450 0    50   ~ 0
NAND from MAR
Wire Wire Line
	6550 5850 6550 5450
Text Notes 6550 4400 1    50   ~ 0
CEME
Wire Wire Line
	6450 5450 6450 5750
Wire Wire Line
	1350 5750 6450 5750
Connection ~ 6450 5750
Wire Wire Line
	6450 5750 6450 5850
Wire Wire Line
	6650 3850 6650 4450
Wire Wire Line
	9450 1500 9450 4150
Wire Wire Line
	9550 4150 9450 4150
Text Notes 5600 1500 0    50   ~ 0
HI
Text Notes 5600 1700 0    50   ~ 0
CEME
$Comp
L 74xx:74HC04 U1
U 4 1 6087CB2C
P 4400 1800
AR Path="/5EC57429/6087CB2C" Ref="U1"  Part="4" 
AR Path="/6087CB2C" Ref="U?"  Part="4" 
AR Path="/60B12F32/6087CB2C" Ref="U?"  Part="4" 
F 0 "U1" V 4400 1800 50  0000 C CNN
F 1 "74HC04" V 4300 1800 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 4400 1800 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 4400 1800 50  0001 C CNN
	4    4400 1800
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 608A6850
P 4200 2100
AR Path="/5EC573DA/608A6850" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/608A6850" Ref="#PWR0203"  Part="1" 
F 0 "#PWR0203" H 4200 1950 50  0001 C CNN
F 1 "+5V" V 4200 2200 50  0000 L CNN
F 2 "" H 4200 2100 50  0001 C CNN
F 3 "" H 4200 2100 50  0001 C CNN
	1    4200 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60866E65
P 2700 2100
AR Path="/5EC573DA/60866E65" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/60866E65" Ref="#PWR094"  Part="1" 
F 0 "#PWR094" H 2700 1850 50  0001 C CNN
F 1 "GND" V 2705 1927 50  0000 C CNN
F 2 "" H 2700 2100 50  0001 C CNN
F 3 "" H 2700 2100 50  0001 C CNN
	1    2700 2100
	-1   0    0    1   
$EndComp
NoConn ~ 2700 3100
$Comp
L power:GND #PWR095
U 1 1 60867BAD
P 5650 4450
F 0 "#PWR095" H 5650 4200 50  0001 C CNN
F 1 "GND" V 5650 4250 50  0000 C CNN
F 2 "" H 5650 4450 50  0001 C CNN
F 3 "" H 5650 4450 50  0001 C CNN
	1    5650 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR096
U 1 1 60867D91
P 8750 4450
F 0 "#PWR096" H 8750 4200 50  0001 C CNN
F 1 "GND" V 8750 4250 50  0000 C CNN
F 2 "" H 8750 4450 50  0001 C CNN
F 3 "" H 8750 4450 50  0001 C CNN
	1    8750 4450
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74HC04 U1
U 6 1 608F829E
P 2450 6850
AR Path="/5EC57429/608F829E" Ref="U1"  Part="6" 
AR Path="/608F829E" Ref="U?"  Part="6" 
AR Path="/6026EA31/608F829E" Ref="U?"  Part="6" 
AR Path="/60B12F32/608F829E" Ref="U?"  Part="6" 
F 0 "U1" H 2300 6800 50  0000 L CNN
F 1 "74HC04" H 2300 6900 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2450 6850 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 2450 6850 50  0001 C CNN
	6    2450 6850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 3 1 6096D82B
P 4700 1500
AR Path="/5F64487D/6096D82B" Ref="U?"  Part="5" 
AR Path="/5EC57456/6096D82B" Ref="U?"  Part="3" 
AR Path="/5EC57909/6096D82B" Ref="U?"  Part="3" 
AR Path="/5EC57429/6096D82B" Ref="U35"  Part="3" 
F 0 "U35" H 4700 1550 50  0000 C CNN
F 1 "74HC00" H 4700 1450 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 4700 1500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 4700 1500 50  0001 C CNN
	3    4700 1500
	-1   0    0    1   
$EndComp
Wire Wire Line
	9450 1500 5600 1500
$Comp
L 74xx:74HC04 U?
U 5 1 608C3DF9
P 7700 1700
AR Path="/5EC57456/608C3DF9" Ref="U?"  Part="5" 
AR Path="/5EC57429/608C3DF9" Ref="U1"  Part="5" 
AR Path="/5F645851/608C3DF9" Ref="U?"  Part="5" 
F 0 "U1" H 7650 1650 50  0000 C CNN
F 1 "74HC04" H 7700 1750 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7700 1700 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 7700 1700 50  0001 C CNN
	5    7700 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 1700 8000 2100
NoConn ~ 2750 6850
$Comp
L power:GND #PWR?
U 1 1 60A2E7BA
P 2150 6850
AR Path="/5F645851/60A2E7BA" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60A2E7BA" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/60A2E7BA" Ref="#PWR0201"  Part="1" 
F 0 "#PWR0201" H 2150 6600 50  0001 C CNN
F 1 "GND" H 2155 6677 50  0000 C CNN
F 2 "" H 2150 6850 50  0001 C CNN
F 3 "" H 2150 6850 50  0001 C CNN
	1    2150 6850
	-1   0    0    1   
$EndComp
$EndSCHEMATC
