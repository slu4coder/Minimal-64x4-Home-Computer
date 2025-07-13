EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 10
Title "Program Counter"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 1450 1250 0    50   Input ~ 0
CE
Text HLabel 4450 1900 1    50   BiDi ~ 0
BUS0
Text HLabel 4350 1900 1    50   BiDi ~ 0
BUS1
Text HLabel 4250 1900 1    50   BiDi ~ 0
BUS2
Text HLabel 4150 1900 1    50   BiDi ~ 0
BUS3
Text HLabel 2150 1900 1    50   BiDi ~ 0
BUS4
Text HLabel 2050 1900 1    50   BiDi ~ 0
BUS5
Text HLabel 1950 1900 1    50   BiDi ~ 0
BUS6
Text HLabel 1850 1900 1    50   BiDi ~ 0
BUS7
Text GLabel 8350 1900 1    50   Input ~ 0
CLOCK
$Comp
L 74xx:74HC245 U30
U 1 1 5F907909
P 8650 3800
F 0 "U30" V 8550 3650 50  0000 L CNN
F 1 "74HC245" V 8650 3650 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 8650 3800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 8650 3800 50  0001 C CNN
	1    8650 3800
	0    1    -1   0   
$EndComp
$Comp
L power:+5V #PWR0112
U 1 1 5F9174F1
P 7150 2400
F 0 "#PWR0112" H 7150 2250 50  0001 C CNN
F 1 "+5V" H 7165 2573 50  0000 C CNN
F 2 "" H 7150 2400 50  0001 C CNN
F 3 "" H 7150 2400 50  0001 C CNN
	1    7150 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 5F917B6A
P 5550 2400
F 0 "#PWR0111" H 5550 2150 50  0001 C CNN
F 1 "GND" H 5555 2227 50  0000 C CNN
F 2 "" H 5550 2400 50  0001 C CNN
F 3 "" H 5550 2400 50  0001 C CNN
	1    5550 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 5F918649
P 7850 2400
F 0 "#PWR0113" H 7850 2150 50  0001 C CNN
F 1 "GND" H 7855 2227 50  0000 C CNN
F 2 "" H 7850 2400 50  0001 C CNN
F 3 "" H 7850 2400 50  0001 C CNN
	1    7850 2400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0116
U 1 1 5F91896C
P 9450 2400
F 0 "#PWR0116" H 9450 2250 50  0001 C CNN
F 1 "+5V" H 9465 2573 50  0000 C CNN
F 2 "" H 9450 2400 50  0001 C CNN
F 3 "" H 9450 2400 50  0001 C CNN
	1    9450 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5F91BFCD
P 7850 3800
F 0 "#PWR0114" H 7850 3550 50  0001 C CNN
F 1 "GND" H 7855 3627 50  0000 C CNN
F 2 "" H 7850 3800 50  0001 C CNN
F 3 "" H 7850 3800 50  0001 C CNN
	1    7850 3800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0117
U 1 1 5F91C5A3
P 9450 3800
F 0 "#PWR0117" H 9450 3650 50  0001 C CNN
F 1 "+5V" H 9465 3973 50  0000 C CNN
F 2 "" H 9450 3800 50  0001 C CNN
F 3 "" H 9450 3800 50  0001 C CNN
	1    9450 3800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0115
U 1 1 5F91C9DC
P 8250 4300
F 0 "#PWR0115" H 8250 4050 50  0001 C CNN
F 1 "GND" H 8350 4300 50  0000 C CNN
F 2 "" H 8250 4300 50  0001 C CNN
F 3 "" H 8250 4300 50  0001 C CNN
	1    8250 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 1900 8550 1900
Wire Wire Line
	6250 1900 6250 1250
Wire Wire Line
	6250 1250 8550 1250
Wire Wire Line
	8550 1250 8550 1900
Wire Wire Line
	8650 2900 7550 2900
Wire Wire Line
	7550 2900 7550 1550
Wire Wire Line
	7550 1550 6150 1550
Wire Wire Line
	6150 1550 6150 1900
Text GLabel 6050 1900 1    50   Input ~ 0
CLOCK
Wire Wire Line
	6350 1900 6350 1450
Wire Wire Line
	6350 1450 8650 1450
Wire Wire Line
	8650 1450 8650 1900
Text GLabel 3650 1900 1    50   Input ~ 0
CLOCK
Wire Wire Line
	4050 3100 2150 3100
Wire Wire Line
	2150 3100 2150 2900
Wire Wire Line
	2050 2900 2050 3150
Wire Wire Line
	2050 3150 3950 3150
Wire Wire Line
	3850 3200 1950 3200
Wire Wire Line
	1950 3200 1950 2900
Wire Wire Line
	1850 2900 1850 3250
Wire Wire Line
	1850 3250 3750 3250
$Comp
L power:+5V #PWR0105
U 1 1 5F952707
P 2450 2400
F 0 "#PWR0105" H 2450 2250 50  0001 C CNN
F 1 "+5V" H 2465 2573 50  0000 C CNN
F 2 "" H 2450 2400 50  0001 C CNN
F 3 "" H 2450 2400 50  0001 C CNN
	1    2450 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5F952711
P 850 2400
F 0 "#PWR0103" H 850 2150 50  0001 C CNN
F 1 "GND" H 855 2227 50  0000 C CNN
F 2 "" H 850 2400 50  0001 C CNN
F 3 "" H 850 2400 50  0001 C CNN
	1    850  2400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 5F952725
P 4750 2400
F 0 "#PWR0109" H 4750 2250 50  0001 C CNN
F 1 "+5V" H 4765 2573 50  0000 C CNN
F 2 "" H 4750 2400 50  0001 C CNN
F 3 "" H 4750 2400 50  0001 C CNN
	1    4750 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5F95272F
P 3150 3800
F 0 "#PWR0107" H 3150 3550 50  0001 C CNN
F 1 "GND" H 3155 3627 50  0000 C CNN
F 2 "" H 3150 3800 50  0001 C CNN
F 3 "" H 3150 3800 50  0001 C CNN
	1    3150 3800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0110
U 1 1 5F952739
P 4750 3800
F 0 "#PWR0110" H 4750 3650 50  0001 C CNN
F 1 "+5V" H 4765 3973 50  0000 C CNN
F 2 "" H 4750 3800 50  0001 C CNN
F 3 "" H 4750 3800 50  0001 C CNN
	1    4750 3800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5F952743
P 3550 4300
F 0 "#PWR0108" H 3550 4050 50  0001 C CNN
F 1 "GND" H 3555 4127 50  0000 C CNN
F 2 "" H 3550 4300 50  0001 C CNN
F 3 "" H 3550 4300 50  0001 C CNN
	1    3550 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1250 3850 1250
Wire Wire Line
	3850 1250 3850 1900
Wire Wire Line
	3950 2900 2900 2900
Wire Wire Line
	2900 2900 2900 1550
Wire Wire Line
	2900 1550 1450 1550
Wire Wire Line
	1450 1550 1450 1900
Text GLabel 1350 1900 1    50   Input ~ 0
CLOCK
Wire Wire Line
	1650 1900 1650 1350
Wire Wire Line
	1650 1350 3950 1350
Wire Wire Line
	3950 1350 3950 1900
Wire Wire Line
	6350 2900 5150 2900
Wire Wire Line
	5150 2900 5150 1550
Wire Wire Line
	5150 1550 3750 1550
Wire Wire Line
	3750 1550 3750 1900
NoConn ~ 1650 2900
Wire Wire Line
	3850 1250 6250 1250
Connection ~ 3850 1250
Connection ~ 6250 1250
Wire Wire Line
	1450 1250 1550 1250
Connection ~ 1550 1250
Wire Wire Line
	3100 4850 8150 4850
Wire Wire Line
	6550 2900 6550 3250
Wire Wire Line
	6550 3250 8450 3250
Wire Wire Line
	6650 3200 6650 2900
Wire Wire Line
	8550 3200 6650 3200
Wire Wire Line
	6750 2900 6750 3150
Wire Wire Line
	6750 3150 8650 3150
Wire Wire Line
	6850 3100 6850 2900
Wire Wire Line
	8750 3100 6850 3100
Wire Wire Line
	3100 4450 3450 4450
$Comp
L 8-Bit~CPU~32k:74HC161 U29
U 1 1 60C8AA8D
P 8650 2400
F 0 "U29" V 8750 2250 50  0000 L CNN
F 1 "74HC161" V 8650 2250 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 8650 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 8650 2400 50  0001 C CNN
	1    8650 2400
	0    1    1    0   
$EndComp
Connection ~ 8550 1900
$Comp
L 8-Bit~CPU~32k:74HC161 U28
U 1 1 60C8C27B
P 6350 2400
F 0 "U28" V 6450 2250 50  0000 L CNN
F 1 "74HC161" V 6350 2250 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6350 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 6350 2400 50  0001 C CNN
	1    6350 2400
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U26
U 1 1 60C8CE09
P 3950 2400
F 0 "U26" V 4050 2250 50  0000 L CNN
F 1 "74HC161" V 3950 2250 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3950 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3950 2400 50  0001 C CNN
	1    3950 2400
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U25
U 1 1 60C8D87F
P 1650 2400
F 0 "U25" V 1750 2250 50  0000 L CNN
F 1 "74HC161" V 1650 2250 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 1650 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 1650 2400 50  0001 C CNN
	1    1650 2400
	0    1    1    0   
$EndComp
$Comp
L 74xx:74HC00 U24
U 1 1 60CD4364
P 2800 4450
F 0 "U24" H 2800 4500 50  0000 C CNN
F 1 "74HC00" H 2800 4400 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2800 4450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 4450 50  0001 C CNN
	1    2800 4450
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U24
U 2 1 60CD78C7
P 2800 4850
F 0 "U24" H 2800 4900 50  0000 C CNN
F 1 "74HC00" H 2800 4800 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2800 4850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 4850 50  0001 C CNN
	2    2800 4850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U24
U 3 1 60CD9715
P 2800 5250
F 0 "U24" H 2800 5300 50  0000 C CNN
F 1 "74HC00" H 2800 5200 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2800 5250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 5250 50  0001 C CNN
	3    2800 5250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U24
U 4 1 60CDBC9F
P 2800 5650
F 0 "U24" H 2800 5700 50  0000 C CNN
F 1 "74HC00" H 2800 5600 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2800 5650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 5650 50  0001 C CNN
	4    2800 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5F0C68C8
P 3150 2400
F 0 "#PWR0106" H 3150 2150 50  0001 C CNN
F 1 "GND" H 3155 2227 50  0000 C CNN
F 2 "" H 3150 2400 50  0001 C CNN
F 3 "" H 3150 2400 50  0001 C CNN
	1    3150 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1250 1550 1900
$Comp
L 74xx:74HC245 U27
U 1 1 5F9526C6
P 3950 3800
F 0 "U27" V 3850 3700 50  0000 L CNN
F 1 "74HC245" V 3950 3650 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 3950 3800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 3950 3800 50  0001 C CNN
	1    3950 3800
	0    1    -1   0   
$EndComp
Wire Wire Line
	3750 3250 3750 3300
Wire Wire Line
	3850 3200 3850 3300
Wire Wire Line
	3950 3150 3950 3300
Wire Wire Line
	4050 3100 4050 3300
Wire Wire Line
	4150 2900 4150 3300
Wire Wire Line
	4250 2900 4250 3300
Wire Wire Line
	4350 2900 4350 3300
Wire Wire Line
	4450 2900 4450 3300
Wire Wire Line
	9150 2900 9150 3300
Wire Wire Line
	9050 2900 9050 3300
Wire Wire Line
	8950 2900 8950 3300
Wire Wire Line
	8850 2900 8850 3300
Wire Wire Line
	8750 3100 8750 3300
Wire Wire Line
	8650 3150 8650 3300
Wire Wire Line
	8550 3200 8550 3300
Wire Wire Line
	8450 3250 8450 3300
$Comp
L power:+5V #PWR0104
U 1 1 5F6B82BA
P 1700 7350
F 0 "#PWR0104" H 1700 7200 50  0001 C CNN
F 1 "+5V" H 1715 7523 50  0000 C CNN
F 2 "" H 1700 7350 50  0001 C CNN
F 3 "" H 1700 7350 50  0001 C CNN
	1    1700 7350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F6B8630
P 700 7350
AR Path="/5F645851/5F6B8630" Ref="#PWR?"  Part="1" 
AR Path="/5EC5738F/5F6B8630" Ref="#PWR0102"  Part="1" 
F 0 "#PWR0102" H 700 7100 50  0001 C CNN
F 1 "GND" H 705 7177 50  0000 C CNN
F 2 "" H 700 7350 50  0001 C CNN
F 3 "" H 700 7350 50  0001 C CNN
	1    700  7350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U24
U 5 1 5FBE46F7
P 1200 7350
F 0 "U24" V 1300 7350 50  0000 C CNN
F 1 "74HC00" V 1100 7350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1200 7350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1200 7350 50  0001 C CNN
	5    1200 7350
	0    1    1    0   
$EndComp
Text Notes 3100 4450 0    50   ~ 0
~COH
Text Notes 3100 4850 0    50   ~ 0
~COL
Text Notes 3100 5250 0    50   ~ 0
~CIL
Text Notes 3100 5650 0    50   ~ 0
~CIH
Wire Wire Line
	3450 4450 3450 4300
Wire Wire Line
	8150 4850 8150 4300
Wire Wire Line
	8650 1450 9650 1450
Wire Wire Line
	9650 1450 9650 5250
Connection ~ 8650 1450
Wire Wire Line
	3100 5250 9650 5250
Wire Wire Line
	3100 5650 9750 5650
Wire Wire Line
	9750 5650 9750 1350
Wire Wire Line
	9750 1350 3950 1350
Connection ~ 3950 1350
Text GLabel 5850 1900 1    50   Input ~ 0
~RESET
Text GLabel 8150 1900 1    50   Input ~ 0
~RESET
Text GLabel 3450 1900 1    50   Input ~ 0
~RESET
Text GLabel 1150 1900 1    50   Input ~ 0
~RESET
Connection ~ 2500 4650
Wire Wire Line
	2500 4650 2500 4750
Wire Wire Line
	2500 4550 2500 4650
Wire Wire Line
	2400 4650 2500 4650
Text HLabel 2400 4650 0    50   Input ~ 0
CO
Connection ~ 2500 5050
Wire Wire Line
	2500 5050 2500 4950
Wire Wire Line
	2500 5150 2500 5050
Wire Wire Line
	2400 5050 2500 5050
Text HLabel 2400 5050 0    50   Input ~ 0
~HI
Connection ~ 2500 5450
Wire Wire Line
	2500 5450 2500 5550
Wire Wire Line
	2500 5350 2500 5450
Wire Wire Line
	2400 5450 2500 5450
Text HLabel 2400 5450 0    50   Input ~ 0
CI
Text HLabel 2000 4350 0    50   Input ~ 0
HI
Wire Wire Line
	2150 5750 2500 5750
Wire Wire Line
	2150 4350 2500 4350
Wire Wire Line
	2000 4350 2150 4350
Connection ~ 2150 4350
Wire Wire Line
	2150 4350 2150 5750
Text HLabel 9150 4300 3    50   BiDi ~ 0
BUS0
Text HLabel 9050 4300 3    50   BiDi ~ 0
BUS1
Text HLabel 8950 4300 3    50   BiDi ~ 0
BUS2
Text HLabel 8850 4300 3    50   BiDi ~ 0
BUS3
Text HLabel 8750 4300 3    50   BiDi ~ 0
BUS4
Text HLabel 8650 4300 3    50   BiDi ~ 0
BUS5
Text HLabel 8550 4300 3    50   BiDi ~ 0
BUS6
Text HLabel 8450 4300 3    50   BiDi ~ 0
BUS7
Text HLabel 4450 4300 3    50   BiDi ~ 0
BUS0
Text HLabel 4350 4300 3    50   BiDi ~ 0
BUS1
Text HLabel 4250 4300 3    50   BiDi ~ 0
BUS2
Text HLabel 4150 4300 3    50   BiDi ~ 0
BUS3
Text HLabel 4050 4300 3    50   BiDi ~ 0
BUS4
Text HLabel 3950 4300 3    50   BiDi ~ 0
BUS5
Text HLabel 3850 4300 3    50   BiDi ~ 0
BUS6
Text HLabel 3750 4300 3    50   BiDi ~ 0
BUS7
Text HLabel 9150 1900 1    50   BiDi ~ 0
BUS0
Text HLabel 9050 1900 1    50   BiDi ~ 0
BUS1
Text HLabel 8950 1900 1    50   BiDi ~ 0
BUS2
Text HLabel 8850 1900 1    50   BiDi ~ 0
BUS3
Text HLabel 6850 1900 1    50   BiDi ~ 0
BUS4
Text HLabel 6750 1900 1    50   BiDi ~ 0
BUS5
Text HLabel 6650 1900 1    50   BiDi ~ 0
BUS6
Text HLabel 6550 1900 1    50   BiDi ~ 0
BUS7
$EndSCHEMATC
