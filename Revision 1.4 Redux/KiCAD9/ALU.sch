EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 10
Title "Arithmetic and Logic Unit"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 6100 6900 3    50   Output ~ 0
BUS0
Text HLabel 6000 6900 3    50   Output ~ 0
BUS1
Text HLabel 5900 6900 3    50   Output ~ 0
BUS2
Text HLabel 5800 6900 3    50   Output ~ 0
BUS3
Text HLabel 5700 6900 3    50   Output ~ 0
BUS4
Text HLabel 5600 6900 3    50   Output ~ 0
BUS5
Text HLabel 5500 6900 3    50   Output ~ 0
BUS6
Text HLabel 5400 6900 3    50   Output ~ 0
BUS7
Text HLabel 5900 3450 1    50   Input ~ 0
A0
Text HLabel 5800 3450 1    50   Input ~ 0
A1
Text HLabel 5700 3450 1    50   Input ~ 0
A2
Text HLabel 5600 3450 1    50   Input ~ 0
A3
Text HLabel 3800 3450 1    50   Input ~ 0
A4
Text HLabel 3700 3450 1    50   Input ~ 0
A5
Text HLabel 3600 3450 1    50   Input ~ 0
A6
Text HLabel 3500 3450 1    50   Input ~ 0
A7
Text HLabel 2400 1100 0    50   Input ~ 0
B0
Text HLabel 2400 1450 0    50   Input ~ 0
B1
Text HLabel 2400 1800 0    50   Input ~ 0
B2
Text HLabel 2400 2150 0    50   Input ~ 0
B3
Text HLabel 2400 2500 0    50   Input ~ 0
B4
Text HLabel 2400 2850 0    50   Input ~ 0
B5
Text HLabel 2400 3200 0    50   Input ~ 0
B6
Text HLabel 2400 3550 0    50   Input ~ 0
B7
Text HLabel 5100 6900 3    50   Input ~ 0
~EO
Text HLabel 2050 900  0    50   Input ~ 0
ES
Text HLabel 6100 3450 1    50   Input ~ 0
EC
Text HLabel 3700 4950 3    50   Output ~ 0
FLAG_N
$Comp
L 74xx:74HC245 U12
U 1 1 5F7F7837
P 5600 6400
F 0 "U12" V 5600 6100 50  0000 L CNN
F 1 "74HC245" V 5600 6300 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 5600 6400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 5600 6400 50  0001 C CNN
	1    5600 6400
	0    1    -1   0   
$EndComp
$Comp
L power:GND #PWR041
U 1 1 5F7FBFF7
P 5200 6900
F 0 "#PWR041" H 5200 6650 50  0001 C CNN
F 1 "GND" V 5200 6700 50  0000 C CNN
F 2 "" H 5200 6900 50  0001 C CNN
F 3 "" H 5200 6900 50  0001 C CNN
	1    5200 6900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR039
U 1 1 5F7FC568
P 4800 3950
F 0 "#PWR039" H 4800 3700 50  0001 C CNN
F 1 "GND" H 4805 3777 50  0000 C CNN
F 2 "" H 4800 3950 50  0001 C CNN
F 3 "" H 4800 3950 50  0001 C CNN
	1    4800 3950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR035
U 1 1 5F7FCBA0
P 2700 3950
F 0 "#PWR035" H 2700 3700 50  0001 C CNN
F 1 "GND" H 2705 3777 50  0000 C CNN
F 2 "" H 2700 3950 50  0001 C CNN
F 3 "" H 2700 3950 50  0001 C CNN
	1    2700 3950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR040
U 1 1 5F7FCFBC
P 4800 6400
F 0 "#PWR040" H 4800 6150 50  0001 C CNN
F 1 "GND" H 4805 6227 50  0000 C CNN
F 2 "" H 4800 6400 50  0001 C CNN
F 3 "" H 4800 6400 50  0001 C CNN
	1    4800 6400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR038
U 1 1 5F7FD37A
P 4300 3950
F 0 "#PWR038" H 4300 3800 50  0001 C CNN
F 1 "+5V" H 4315 4123 50  0000 C CNN
F 2 "" H 4300 3950 50  0001 C CNN
F 3 "" H 4300 3950 50  0001 C CNN
	1    4300 3950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR042
U 1 1 5F7FDC57
P 6400 3950
F 0 "#PWR042" H 6400 3800 50  0001 C CNN
F 1 "+5V" H 6415 4123 50  0000 C CNN
F 2 "" H 6400 3950 50  0001 C CNN
F 3 "" H 6400 3950 50  0001 C CNN
	1    6400 3950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR043
U 1 1 5F7FE169
P 6400 6400
F 0 "#PWR043" H 6400 6250 50  0001 C CNN
F 1 "+5V" H 6415 6573 50  0000 C CNN
F 2 "" H 6400 6400 50  0001 C CNN
F 3 "" H 6400 6400 50  0001 C CNN
	1    6400 6400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 4550 4000 4550
Wire Wire Line
	4000 4550 4000 4450
Wire Wire Line
	3900 4450 3900 4650
Wire Wire Line
	3900 4650 5600 4650
Wire Wire Line
	5500 4750 3800 4750
Wire Wire Line
	3800 4750 3800 4450
Wire Wire Line
	3700 4450 3700 4850
Wire Wire Line
	3700 4850 5400 4850
Wire Wire Line
	5600 4450 4550 4450
Wire Wire Line
	4550 4450 4550 3450
Wire Wire Line
	4550 3450 4000 3450
Text HLabel 3500 4950 3    50   Output ~ 0
FLAG_C
Wire Wire Line
	3700 4950 3700 4850
Connection ~ 3700 4850
Wire Wire Line
	3500 4450 3500 4950
$Comp
L 74xx:74HC86 U6
U 1 1 5F82176D
P 2700 3450
F 0 "U6" H 2700 3400 50  0000 C CNN
F 1 "74HC86" H 2750 3500 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 3450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 3450 50  0001 C CNN
	1    2700 3450
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U6
U 2 1 5F825276
P 2700 3100
F 0 "U6" H 2700 3050 50  0000 C CNN
F 1 "74HC86" H 2750 3150 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 3100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 3100 50  0001 C CNN
	2    2700 3100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U6
U 3 1 5F8270A9
P 2700 2750
F 0 "U6" H 2700 2700 50  0000 C CNN
F 1 "74HC86" H 2750 2800 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 2750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 2750 50  0001 C CNN
	3    2700 2750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U6
U 4 1 5F828D45
P 2700 2400
F 0 "U6" H 2700 2350 50  0000 C CNN
F 1 "74HC86" H 2700 2450 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 2400 50  0001 C CNN
	4    2700 2400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U8
U 1 1 5F847955
P 2700 2050
F 0 "U8" H 2700 2000 50  0000 C CNN
F 1 "74HC86" H 2700 2100 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 2050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 2050 50  0001 C CNN
	1    2700 2050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U8
U 2 1 5F848A59
P 2700 1700
F 0 "U8" H 2700 1650 50  0000 C CNN
F 1 "74HC86" H 2700 1750 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 1700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 1700 50  0001 C CNN
	2    2700 1700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U8
U 3 1 5F849CE8
P 2700 1350
F 0 "U8" H 2700 1300 50  0000 C CNN
F 1 "74HC86" H 2700 1400 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 1350 50  0001 C CNN
	3    2700 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC86 U8
U 4 1 5F84AD01
P 2700 1000
F 0 "U8" H 2700 950 50  0000 C CNN
F 1 "74HC86" H 2700 1050 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2700 1000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2700 1000 50  0001 C CNN
	4    2700 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 3350 2200 3350
Wire Wire Line
	2200 3000 2400 3000
Wire Wire Line
	2200 3000 2200 2650
Wire Wire Line
	2200 2650 2400 2650
Connection ~ 2200 3000
Wire Wire Line
	2200 2650 2200 2300
Wire Wire Line
	2200 2300 2400 2300
Connection ~ 2200 2650
Wire Wire Line
	2400 1950 2200 1950
Wire Wire Line
	2200 1950 2200 1600
Wire Wire Line
	2200 1600 2400 1600
Wire Wire Line
	2200 1600 2200 1250
Wire Wire Line
	2200 1250 2400 1250
Connection ~ 2200 1600
Wire Wire Line
	2200 900  2400 900 
Connection ~ 2200 1250
Wire Wire Line
	5800 4450 5800 5050
Wire Wire Line
	5700 4550 5700 5250
Wire Wire Line
	7550 5050 5800 5050
Connection ~ 5800 5050
Wire Wire Line
	5800 5050 5800 5900
Wire Wire Line
	7550 5250 5700 5250
Connection ~ 5700 5250
Wire Wire Line
	5700 5250 5700 5900
$Comp
L 8-Bit~CPU~32k:74HC283 U11
U 1 1 60C784DD
P 5600 3950
F 0 "U11" V 5600 4150 50  0000 L CNN
F 1 "74HC283" V 5600 3750 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 5600 3950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS283" H 5600 3950 50  0001 C CNN
	1    5600 3950
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC283 U10
U 1 1 60C7A01A
P 3500 3950
F 0 "U10" V 3500 4150 50  0000 L CNN
F 1 "74HC283" V 3500 3650 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3500 3950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS283" H 3500 3950 50  0001 C CNN
	1    3500 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	2200 1250 2200 900 
$Comp
L 74xx:74HC86 U6
U 5 1 5F5229C8
P 1300 6600
F 0 "U6" V 1400 6600 50  0000 C CNN
F 1 "74HC86" V 1200 6600 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1300 6600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 1300 6600 50  0001 C CNN
	5    1300 6600
	0    1    1    0   
$EndComp
$Comp
L 74xx:74HC86 U8
U 5 1 5F523D3A
P 2500 6600
F 0 "U8" V 2600 6600 50  0000 C CNN
F 1 "74HC86" V 2400 6600 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2500 6600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC86" H 2500 6600 50  0001 C CNN
	5    2500 6600
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR029
U 1 1 5F538161
P 800 6600
F 0 "#PWR029" H 800 6350 50  0001 C CNN
F 1 "GND" H 805 6427 50  0000 C CNN
F 2 "" H 800 6600 50  0001 C CNN
F 3 "" H 800 6600 50  0001 C CNN
	1    800  6600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR033
U 1 1 5F5384E9
P 2000 6600
F 0 "#PWR033" H 2000 6350 50  0001 C CNN
F 1 "GND" H 2005 6427 50  0000 C CNN
F 2 "" H 2000 6600 50  0001 C CNN
F 3 "" H 2000 6600 50  0001 C CNN
	1    2000 6600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR030
U 1 1 5F5388B6
P 800 7350
F 0 "#PWR030" H 800 7100 50  0001 C CNN
F 1 "GND" H 805 7177 50  0000 C CNN
F 2 "" H 800 7350 50  0001 C CNN
F 3 "" H 800 7350 50  0001 C CNN
	1    800  7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR032
U 1 1 5F538FD9
P 1800 7350
F 0 "#PWR032" H 1800 7200 50  0001 C CNN
F 1 "+5V" H 1815 7523 50  0000 C CNN
F 2 "" H 1800 7350 50  0001 C CNN
F 3 "" H 1800 7350 50  0001 C CNN
	1    1800 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR036
U 1 1 5F5394E7
P 3000 6600
F 0 "#PWR036" H 3000 6450 50  0001 C CNN
F 1 "+5V" H 3015 6773 50  0000 C CNN
F 2 "" H 3000 6600 50  0001 C CNN
F 3 "" H 3000 6600 50  0001 C CNN
	1    3000 6600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR031
U 1 1 5F539E97
P 1800 6600
F 0 "#PWR031" H 1800 6450 50  0001 C CNN
F 1 "+5V" H 1815 6773 50  0000 C CNN
F 2 "" H 1800 6600 50  0001 C CNN
F 3 "" H 1800 6600 50  0001 C CNN
	1    1800 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 3350 2200 3000
Wire Wire Line
	2200 2300 2200 1950
Connection ~ 2200 1950
Connection ~ 2200 2300
Wire Wire Line
	2200 900  2050 900 
Connection ~ 2200 900 
Wire Wire Line
	3100 3450 3100 3100
Wire Wire Line
	3100 3100 3000 3100
Wire Wire Line
	3200 3450 3200 2750
Wire Wire Line
	3200 2750 3000 2750
Wire Wire Line
	3300 3450 3300 2400
Wire Wire Line
	3300 2400 3000 2400
Wire Wire Line
	3000 2050 5100 2050
Wire Wire Line
	5100 2050 5100 3450
Wire Wire Line
	3000 1700 5200 1700
Wire Wire Line
	5200 1700 5200 3450
Wire Wire Line
	3000 1350 5300 1350
Wire Wire Line
	5300 1350 5300 3450
Wire Wire Line
	3000 1000 5400 1000
Wire Wire Line
	5400 1000 5400 3450
Text HLabel 9350 5150 2    50   Output ~ 0
FLAG_Z
Wire Wire Line
	6100 5900 6100 4450
Wire Wire Line
	6000 4650 6000 5900
Connection ~ 6000 4650
Wire Wire Line
	6000 4450 6000 4650
Wire Wire Line
	6000 4650 7550 4650
Wire Wire Line
	5400 5850 5400 5900
Wire Wire Line
	5400 4850 5400 5850
Connection ~ 5400 5850
Wire Wire Line
	7550 5850 5400 5850
Wire Wire Line
	5500 5650 5500 5900
Wire Wire Line
	5500 4750 5500 5650
Connection ~ 5500 5650
Wire Wire Line
	7550 5650 5500 5650
Wire Wire Line
	5600 5450 5600 5900
Wire Wire Line
	5600 4650 5600 5450
Connection ~ 5600 5450
Wire Wire Line
	7550 5450 5600 5450
Wire Wire Line
	6100 4450 7550 4450
Connection ~ 6100 4450
Wire Wire Line
	5900 4450 5900 4850
Wire Wire Line
	7550 4850 5900 4850
Connection ~ 5900 4850
Wire Wire Line
	5900 4850 5900 5900
$Comp
L 8-Bit~CPU~32k:74HC08 U9
U 1 1 60A2A5D8
P 8450 4750
F 0 "U9" H 8450 4800 50  0000 C CNN
F 1 "74HC08" H 8450 4700 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 8450 4750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 8450 4750 50  0001 C CNN
	1    8450 4750
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC08 U9
U 5 1 60A2E1BF
P 2500 7350
F 0 "U9" V 2600 7350 50  0000 C CNN
F 1 "74HC08" V 2400 7350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2500 7350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 2500 7350 50  0001 C CNN
	5    2500 7350
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR034
U 1 1 60A32205
P 2000 7350
F 0 "#PWR034" H 2000 7100 50  0001 C CNN
F 1 "GND" H 2005 7177 50  0000 C CNN
F 2 "" H 2000 7350 50  0001 C CNN
F 3 "" H 2000 7350 50  0001 C CNN
	1    2000 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR037
U 1 1 60A332CF
P 3000 7350
F 0 "#PWR037" H 3000 7200 50  0001 C CNN
F 1 "+5V" H 3015 7523 50  0000 C CNN
F 2 "" H 3000 7350 50  0001 C CNN
F 3 "" H 3000 7350 50  0001 C CNN
	1    3000 7350
	1    0    0    -1  
$EndComp
Text Notes 3000 7500 0    50   ~ 0
AND_D used in RX\n
$Comp
L 8-Bit~CPU~32k:74HC08 U9
U 3 1 608232EE
P 9050 5150
F 0 "U9" H 9050 5200 50  0000 C CNN
F 1 "74HC08" H 9050 5100 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 9050 5150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 9050 5150 50  0001 C CNN
	3    9050 5150
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC08 U?
U 2 1 6098346E
P 8450 5550
AR Path="/5EC57429/6098346E" Ref="U?"  Part="4" 
AR Path="/5F64487D/6098346E" Ref="U?"  Part="4" 
AR Path="/5EC57909/6098346E" Ref="U9"  Part="2" 
F 0 "U9" H 8500 5500 50  0000 R CNN
F 1 "74HC08" H 8600 5600 50  0000 R CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 8450 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 8450 5550 50  0001 C CNN
	2    8450 5550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC02 U7
U 4 1 60A32CA2
P 7850 5750
F 0 "U7" H 7850 5800 50  0000 C CNN
F 1 "74HC02" H 7850 5700 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7850 5750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc02" H 7850 5750 50  0001 C CNN
	4    7850 5750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC02 U7
U 3 1 60A3823B
P 7850 5350
F 0 "U7" H 7850 5400 50  0000 C CNN
F 1 "74HC02" H 7850 5300 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7850 5350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc02" H 7850 5350 50  0001 C CNN
	3    7850 5350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC02 U7
U 2 1 60A38D09
P 7850 4950
F 0 "U7" H 7850 5000 50  0000 C CNN
F 1 "74HC02" H 7850 4900 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7850 4950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc02" H 7850 4950 50  0001 C CNN
	2    7850 4950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC02 U7
U 1 1 60A39697
P 7850 4550
F 0 "U7" H 7850 4600 50  0000 C CNN
F 1 "74HC02" H 7850 4500 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 7850 4550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc02" H 7850 4550 50  0001 C CNN
	1    7850 4550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC02 U7
U 5 1 60A3A025
P 1300 7350
F 0 "U7" V 1400 7350 50  0000 C CNN
F 1 "74HC02" V 1200 7350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1300 7350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc02" H 1300 7350 50  0001 C CNN
	5    1300 7350
	0    1    1    0   
$EndComp
Wire Wire Line
	8150 4550 8150 4650
Wire Wire Line
	8150 4950 8150 4850
Wire Wire Line
	8150 5750 8150 5650
Wire Wire Line
	8150 5450 8150 5350
Wire Wire Line
	8750 5550 8750 5250
Wire Wire Line
	8750 5050 8750 4750
$EndSCHEMATC
