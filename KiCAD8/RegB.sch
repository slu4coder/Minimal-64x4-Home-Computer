EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 10
Title "B Register"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 5500 3300 0    50   Output ~ 0
R0
Text HLabel 5500 3400 0    50   Output ~ 0
R1
Text HLabel 5500 3500 0    50   Output ~ 0
R2
Text HLabel 5500 3600 0    50   Output ~ 0
R3
Text HLabel 5500 3700 0    50   Output ~ 0
R4
Text HLabel 5500 3800 0    50   Output ~ 0
R5
Text HLabel 5500 3900 0    50   Output ~ 0
R6
Text HLabel 5500 4000 0    50   Output ~ 0
R7
Text HLabel 7300 5300 3    50   BiDi ~ 0
BUS0
Text HLabel 7200 5300 3    50   BiDi ~ 0
BUS1
Text HLabel 7100 5300 3    50   BiDi ~ 0
BUS2
Text HLabel 7000 5300 3    50   BiDi ~ 0
BUS3
Text HLabel 6900 5300 3    50   BiDi ~ 0
BUS4
Text HLabel 6800 5300 3    50   BiDi ~ 0
BUS5
Text HLabel 6700 5300 3    50   BiDi ~ 0
BUS6
Text HLabel 6600 5300 3    50   BiDi ~ 0
BUS7
Text HLabel 3450 1500 0    50   Input ~ 0
~BI
$Comp
L 74xx:74HC245 U?
U 1 1 5F392B66
P 6800 4800
AR Path="/5EC573DA/5F392B66" Ref="U?"  Part="1" 
AR Path="/5EC5A568/5F392B66" Ref="U33"  Part="1" 
F 0 "U33" V 6900 4700 50  0000 L CNN
F 1 "74HC245" V 6800 4700 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 6800 4800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 6800 4800 50  0001 C CNN
	1    6800 4800
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F392B6C
P 3100 2450
AR Path="/5EC573DA/5F392B6C" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B6C" Ref="#PWR0118"  Part="1" 
F 0 "#PWR0118" H 3100 2200 50  0001 C CNN
F 1 "GND" V 3105 2322 50  0000 R CNN
F 2 "" H 3100 2450 50  0001 C CNN
F 3 "" H 3100 2450 50  0001 C CNN
	1    3100 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F392B72
P 6000 4800
AR Path="/5EC573DA/5F392B72" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B72" Ref="#PWR0124"  Part="1" 
F 0 "#PWR0124" H 6000 4550 50  0001 C CNN
F 1 "GND" V 6005 4672 50  0000 R CNN
F 2 "" H 6000 4800 50  0001 C CNN
F 3 "" H 6000 4800 50  0001 C CNN
	1    6000 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5F392B78
P 7600 4800
AR Path="/5EC573DA/5F392B78" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B78" Ref="#PWR0130"  Part="1" 
F 0 "#PWR0130" H 7600 4650 50  0001 C CNN
F 1 "+5V" V 7615 4928 50  0000 L CNN
F 2 "" H 7600 4800 50  0001 C CNN
F 3 "" H 7600 4800 50  0001 C CNN
	1    7600 4800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5F392B7E
P 4900 2450
AR Path="/5EC573DA/5F392B7E" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B7E" Ref="#PWR0122"  Part="1" 
F 0 "#PWR0122" H 4900 2300 50  0001 C CNN
F 1 "+5V" V 4915 2578 50  0000 L CNN
F 2 "" H 4900 2450 50  0001 C CNN
F 3 "" H 4900 2450 50  0001 C CNN
	1    4900 2450
	1    0    0    -1  
$EndComp
Text GLabel 6300 1950 1    50   Input ~ 0
CLOCK
Text GLabel 3600 1950 1    50   Input ~ 0
CLOCK
Wire Wire Line
	3700 1950 3800 1950
$Comp
L power:GND #PWR?
U 1 1 5F392B88
P 3400 1950
AR Path="/5EC573DA/5F392B88" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B88" Ref="#PWR0119"  Part="1" 
F 0 "#PWR0119" H 3400 1700 50  0001 C CNN
F 1 "GND" V 3405 1777 50  0000 C CNN
F 2 "" H 3400 1950 50  0001 C CNN
F 3 "" H 3400 1950 50  0001 C CNN
	1    3400 1950
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F392B8E
P 4000 1950
AR Path="/5EC573DA/5F392B8E" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B8E" Ref="#PWR0120"  Part="1" 
F 0 "#PWR0120" H 4000 1700 50  0001 C CNN
F 1 "GND" V 4005 1777 50  0000 C CNN
F 2 "" H 4000 1950 50  0001 C CNN
F 3 "" H 4000 1950 50  0001 C CNN
	1    4000 1950
	-1   0    0    1   
$EndComp
Wire Wire Line
	3800 1500 6500 1500
$Comp
L power:+5V #PWR?
U 1 1 5F392B9A
P 6400 4300
AR Path="/5EC573DA/5F392B9A" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392B9A" Ref="#PWR0126"  Part="1" 
F 0 "#PWR0126" H 6400 4150 50  0001 C CNN
F 1 "+5V" H 6500 4400 50  0000 C CNN
F 2 "" H 6400 4300 50  0001 C CNN
F 3 "" H 6400 4300 50  0001 C CNN
	1    6400 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 4300 6300 4300
Text HLabel 5500 4300 0    50   Input ~ 0
~BO
Wire Wire Line
	7200 4300 7200 3400
Wire Wire Line
	7000 4300 7000 3600
Wire Wire Line
	6900 4300 6900 3700
Wire Wire Line
	6900 2950 4600 2950
Wire Wire Line
	4500 2950 4500 3000
Wire Wire Line
	4500 3000 6800 3000
Wire Wire Line
	6800 3000 6800 3800
Wire Wire Line
	6700 4300 6700 3900
Wire Wire Line
	6700 3050 4400 3050
Wire Wire Line
	4400 3050 4400 2950
Wire Wire Line
	4300 2950 4300 3100
Wire Wire Line
	4300 3100 6600 3100
Wire Wire Line
	6600 3100 6600 4000
Wire Wire Line
	5500 3300 7300 3300
Connection ~ 7300 3300
Wire Wire Line
	7300 3300 7300 4300
Wire Wire Line
	5500 3400 7200 3400
Connection ~ 7200 3400
Wire Wire Line
	5500 3500 7100 3500
Connection ~ 7100 3500
Wire Wire Line
	7100 3500 7100 4300
Wire Wire Line
	5500 3600 7000 3600
Connection ~ 7000 3600
Wire Wire Line
	5500 3700 6900 3700
Connection ~ 6900 3700
Wire Wire Line
	6900 3700 6900 2950
Wire Wire Line
	5500 3800 6800 3800
Connection ~ 6800 3800
Wire Wire Line
	6800 3800 6800 4300
Wire Wire Line
	5500 3900 6700 3900
Connection ~ 6700 3900
Wire Wire Line
	6700 3900 6700 3050
Wire Wire Line
	5500 4000 6600 4000
Connection ~ 6600 4000
Wire Wire Line
	6600 4000 6600 4300
Wire Wire Line
	6500 1500 6500 1950
$Comp
L power:GND #PWR?
U 1 1 5F392BF9
P 5800 2450
AR Path="/5EC573DA/5F392BF9" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392BF9" Ref="#PWR0123"  Part="1" 
F 0 "#PWR0123" H 5800 2200 50  0001 C CNN
F 1 "GND" V 5805 2322 50  0000 R CNN
F 2 "" H 5800 2450 50  0001 C CNN
F 3 "" H 5800 2450 50  0001 C CNN
	1    5800 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 3600 7000 2950
Wire Wire Line
	7100 2950 7100 3500
Wire Wire Line
	7200 3400 7200 2950
Wire Wire Line
	7300 2950 7300 3300
$Comp
L power:GND #PWR?
U 1 1 5F392C04
P 6700 1950
AR Path="/5EC573DA/5F392C04" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392C04" Ref="#PWR0127"  Part="1" 
F 0 "#PWR0127" H 6700 1700 50  0001 C CNN
F 1 "GND" V 6705 1777 50  0000 C CNN
F 2 "" H 6700 1950 50  0001 C CNN
F 3 "" H 6700 1950 50  0001 C CNN
	1    6700 1950
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5F392C0A
P 7600 2450
AR Path="/5EC573DA/5F392C0A" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392C0A" Ref="#PWR0129"  Part="1" 
F 0 "#PWR0129" H 7600 2300 50  0001 C CNN
F 1 "+5V" V 7615 2578 50  0000 L CNN
F 2 "" H 7600 2450 50  0001 C CNN
F 3 "" H 7600 2450 50  0001 C CNN
	1    7600 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5F392C10
P 6100 1950
AR Path="/5EC573DA/5F392C10" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/5F392C10" Ref="#PWR0125"  Part="1" 
F 0 "#PWR0125" H 6100 1700 50  0001 C CNN
F 1 "GND" V 6105 1777 50  0000 C CNN
F 2 "" H 6100 1950 50  0001 C CNN
F 3 "" H 6100 1950 50  0001 C CNN
	1    6100 1950
	-1   0    0    1   
$EndComp
Wire Wire Line
	6400 1950 6500 1950
$Comp
L 8-Bit~CPU~32k:74HC173 U31
U 1 1 60C71C05
P 4000 2450
F 0 "U31" V 4150 2250 50  0000 L CNN
F 1 "74HC173" V 4000 2250 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 4000 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 4000 2450 50  0001 C CNN
	1    4000 2450
	0    1    1    0   
$EndComp
Connection ~ 3800 1950
$Comp
L 8-Bit~CPU~32k:74HC173 U32
U 1 1 60C72ED2
P 6700 2450
F 0 "U32" V 6800 2350 50  0000 L CNN
F 1 "74HC173" V 6700 2300 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6700 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 6700 2450 50  0001 C CNN
	1    6700 2450
	0    1    1    0   
$EndComp
Connection ~ 6500 1950
Wire Wire Line
	3450 1500 3800 1500
Connection ~ 3800 1500
Wire Wire Line
	3800 1500 3800 1950
$Comp
L power:GND #PWR?
U 1 1 6017DA39
P 6800 1950
AR Path="/5EC573DA/6017DA39" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/6017DA39" Ref="#PWR0128"  Part="1" 
F 0 "#PWR0128" H 6800 1700 50  0001 C CNN
F 1 "GND" V 6805 1777 50  0000 C CNN
F 2 "" H 6800 1950 50  0001 C CNN
F 3 "" H 6800 1950 50  0001 C CNN
	1    6800 1950
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6017DB9B
P 4100 1950
AR Path="/5EC573DA/6017DB9B" Ref="#PWR?"  Part="1" 
AR Path="/5EC5A568/6017DB9B" Ref="#PWR0121"  Part="1" 
F 0 "#PWR0121" H 4100 1700 50  0001 C CNN
F 1 "GND" V 4105 1777 50  0000 C CNN
F 2 "" H 4100 1950 50  0001 C CNN
F 3 "" H 4100 1950 50  0001 C CNN
	1    4100 1950
	-1   0    0    1   
$EndComp
Text HLabel 7300 1950 1    50   BiDi ~ 0
BUS0
Text HLabel 7200 1950 1    50   BiDi ~ 0
BUS1
Text HLabel 7100 1950 1    50   BiDi ~ 0
BUS2
Text HLabel 7000 1950 1    50   BiDi ~ 0
BUS3
Text HLabel 4600 1950 1    50   BiDi ~ 0
BUS4
Text HLabel 4500 1950 1    50   BiDi ~ 0
BUS5
Text HLabel 4400 1950 1    50   BiDi ~ 0
BUS6
Text HLabel 4300 1950 1    50   BiDi ~ 0
BUS7
$EndSCHEMATC
