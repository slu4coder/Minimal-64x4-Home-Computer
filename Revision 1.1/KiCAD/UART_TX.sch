EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 10
Title "UART Transmitter"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 5950 3600 1    50   Input ~ 0
BUS0
Text HLabel 6050 3600 1    50   Input ~ 0
BUS1
Text HLabel 6150 3600 1    50   Input ~ 0
BUS2
Text HLabel 6250 3600 1    50   Input ~ 0
BUS3
Text HLabel 6350 3600 1    50   Input ~ 0
BUS4
Text HLabel 6450 3600 1    50   Input ~ 0
BUS5
Text HLabel 8550 3600 1    50   Input ~ 0
BUS6
Text HLabel 8650 3600 1    50   Input ~ 0
BUS7
$Comp
L 8-Bit~CPU~32k:74HC161 U20
U 1 1 5F246ACF
P 3200 4100
F 0 "U20" V 3200 3900 50  0000 L CNN
F 1 "74HC161" V 3300 3900 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3200 4100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3200 4100 50  0001 C CNN
	1    3200 4100
	0    1    1    0   
$EndComp
Text GLabel 2900 3600 1    50   Input ~ 0
CLOCK
$Comp
L power:+5V #PWR071
U 1 1 5F249C63
P 3000 3600
F 0 "#PWR071" H 3000 3450 50  0001 C CNN
F 1 "+5V" V 3000 3800 50  0000 C CNN
F 2 "" H 3000 3600 50  0001 C CNN
F 3 "" H 3000 3600 50  0001 C CNN
	1    3000 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR072
U 1 1 5F249FB1
P 3100 3600
F 0 "#PWR072" H 3100 3450 50  0001 C CNN
F 1 "+5V" V 3100 3800 50  0000 C CNN
F 2 "" H 3100 3600 50  0001 C CNN
F 3 "" H 3100 3600 50  0001 C CNN
	1    3100 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR070
U 1 1 5F24A8B5
P 2400 4100
F 0 "#PWR070" H 2400 3850 50  0001 C CNN
F 1 "GND" H 2405 3927 50  0000 C CNN
F 2 "" H 2400 4100 50  0001 C CNN
F 3 "" H 2400 4100 50  0001 C CNN
	1    2400 4100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR077
U 1 1 5F24ABD2
P 4000 4100
F 0 "#PWR077" H 4000 3950 50  0001 C CNN
F 1 "+5V" H 4015 4273 50  0000 C CNN
F 2 "" H 4000 4100 50  0001 C CNN
F 3 "" H 4000 4100 50  0001 C CNN
	1    4000 4100
	1    0    0    -1  
$EndComp
NoConn ~ 3200 4600
NoConn ~ 3700 4600
NoConn ~ 3600 4600
NoConn ~ 3500 4600
Wire Wire Line
	3400 4600 3400 4700
$Comp
L 8-Bit~CPU~32k:74HC165 U?
U 1 1 5F24B552
P 5950 4100
AR Path="/5F24B552" Ref="U?"  Part="1" 
AR Path="/5F64487D/5F24B552" Ref="U21"  Part="1" 
F 0 "U21" V 6000 3900 50  0000 L CNN
F 1 "74HC165" V 6100 3900 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 5950 4100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS165" H 5950 4100 50  0001 C CNN
	1    5950 4100
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC165 U?
U 1 1 5F24CC1E
P 8750 4100
AR Path="/5F24CC1E" Ref="U?"  Part="1" 
AR Path="/5F64487D/5F24CC1E" Ref="U22"  Part="1" 
F 0 "U22" V 8800 3850 50  0000 L CNN
F 1 "74HC165" V 8900 3850 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 8750 4100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS165" H 8750 4100 50  0001 C CNN
	1    8750 4100
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR083
U 1 1 5F24D89F
P 6850 4100
F 0 "#PWR083" H 6850 3950 50  0001 C CNN
F 1 "+5V" H 6865 4273 50  0000 C CNN
F 2 "" H 6850 4100 50  0001 C CNN
F 3 "" H 6850 4100 50  0001 C CNN
	1    6850 4100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR093
U 1 1 5F24E18D
P 9650 4100
F 0 "#PWR093" H 9650 3950 50  0001 C CNN
F 1 "+5V" V 9650 4300 50  0000 C CNN
F 2 "" H 9650 4100 50  0001 C CNN
F 3 "" H 9650 4100 50  0001 C CNN
	1    9650 4100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR078
U 1 1 5F24EF8B
P 4950 4100
F 0 "#PWR078" H 4950 3850 50  0001 C CNN
F 1 "GND" H 4955 3927 50  0000 C CNN
F 2 "" H 4950 4100 50  0001 C CNN
F 3 "" H 4950 4100 50  0001 C CNN
	1    4950 4100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR084
U 1 1 5F24F2BD
P 7750 4100
F 0 "#PWR084" H 7750 3850 50  0001 C CNN
F 1 "GND" H 7755 3927 50  0000 C CNN
F 2 "" H 7750 4100 50  0001 C CNN
F 3 "" H 7750 4100 50  0001 C CNN
	1    7750 4100
	1    0    0    -1  
$EndComp
NoConn ~ 6450 4600
NoConn ~ 9250 4600
Wire Wire Line
	6550 3600 7400 3600
Wire Wire Line
	7400 3600 7400 4700
Wire Wire Line
	7400 4700 9350 4700
Wire Wire Line
	9350 4700 9350 4600
$Comp
L power:+5V #PWR092
U 1 1 5F24FC3C
P 9350 3600
F 0 "#PWR092" H 9350 3450 50  0001 C CNN
F 1 "+5V" V 9350 3800 50  0000 C CNN
F 2 "" H 9350 3600 50  0001 C CNN
F 3 "" H 9350 3600 50  0001 C CNN
	1    9350 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR082
U 1 1 5F2504D0
P 5850 3600
F 0 "#PWR082" H 5850 3350 50  0001 C CNN
F 1 "GND" V 5850 3400 50  0000 C CNN
F 2 "" H 5850 3600 50  0001 C CNN
F 3 "" H 5850 3600 50  0001 C CNN
	1    5850 3600
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR081
U 1 1 5F250B44
P 5750 3600
F 0 "#PWR081" H 5750 3450 50  0001 C CNN
F 1 "+5V" V 5750 3800 50  0000 C CNN
F 2 "" H 5750 3600 50  0001 C CNN
F 3 "" H 5750 3600 50  0001 C CNN
	1    5750 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 3600 5350 3250
Wire Wire Line
	5350 3250 4550 3250
Wire Wire Line
	4550 3250 4550 4700
Wire Wire Line
	4550 4700 3400 4700
Wire Wire Line
	5350 3250 8150 3250
Wire Wire Line
	8150 3250 8150 3600
Connection ~ 5350 3250
Wire Wire Line
	5550 3600 5550 3050
Wire Wire Line
	8350 3050 8350 3600
Text HLabel 6550 4600 3    50   Output ~ 0
TX
Wire Wire Line
	5550 3050 2700 3050
Wire Wire Line
	2700 3050 2700 3600
Wire Wire Line
	5550 3050 8350 3050
Connection ~ 5550 3050
$Comp
L power:+5V #PWR091
U 1 1 60A233B9
P 9250 3600
F 0 "#PWR091" H 9250 3450 50  0001 C CNN
F 1 "+5V" V 9250 3800 50  0000 C CNN
F 2 "" H 9250 3600 50  0001 C CNN
F 3 "" H 9250 3600 50  0001 C CNN
	1    9250 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR090
U 1 1 60A235A6
P 9150 3600
F 0 "#PWR090" H 9150 3450 50  0001 C CNN
F 1 "+5V" V 9150 3800 50  0000 C CNN
F 2 "" H 9150 3600 50  0001 C CNN
F 3 "" H 9150 3600 50  0001 C CNN
	1    9150 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR089
U 1 1 60A236C3
P 9050 3600
F 0 "#PWR089" H 9050 3450 50  0001 C CNN
F 1 "+5V" V 9050 3800 50  0000 C CNN
F 2 "" H 9050 3600 50  0001 C CNN
F 3 "" H 9050 3600 50  0001 C CNN
	1    9050 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR088
U 1 1 60A23852
P 8950 3600
F 0 "#PWR088" H 8950 3450 50  0001 C CNN
F 1 "+5V" V 8950 3800 50  0000 C CNN
F 2 "" H 8950 3600 50  0001 C CNN
F 3 "" H 8950 3600 50  0001 C CNN
	1    8950 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR087
U 1 1 60A239F6
P 8850 3600
F 0 "#PWR087" H 8850 3450 50  0001 C CNN
F 1 "+5V" V 8850 3800 50  0000 C CNN
F 2 "" H 8850 3600 50  0001 C CNN
F 3 "" H 8850 3600 50  0001 C CNN
	1    8850 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR086
U 1 1 60A23B22
P 8750 3600
F 0 "#PWR086" H 8750 3450 50  0001 C CNN
F 1 "+5V" V 8750 3800 50  0000 C CNN
F 2 "" H 8750 3600 50  0001 C CNN
F 3 "" H 8750 3600 50  0001 C CNN
	1    8750 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FF843D4
P 8050 3600
AR Path="/5F645851/5FF843D4" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/5FF843D4" Ref="#PWR085"  Part="1" 
F 0 "#PWR085" H 8050 3350 50  0001 C CNN
F 1 "GND" V 8050 3400 50  0000 C CNN
F 2 "" H 8050 3600 50  0001 C CNN
F 3 "" H 8050 3600 50  0001 C CNN
	1    8050 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FF84CA0
P 5250 3600
AR Path="/5F645851/5FF84CA0" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/5FF84CA0" Ref="#PWR079"  Part="1" 
F 0 "#PWR079" H 5250 3350 50  0001 C CNN
F 1 "GND" V 5250 3400 50  0000 C CNN
F 2 "" H 5250 3600 50  0001 C CNN
F 3 "" H 5250 3600 50  0001 C CNN
	1    5250 3600
	-1   0    0    1   
$EndComp
Text Notes 1700 3400 0    50   ~ 0
NAND from RX
Text HLabel 2000 2950 0    50   Input ~ 0
TI
Text GLabel 2000 3150 0    50   Input ~ 0
CLOCK
Text Notes 1450 2750 0    50   ~ 0
Transfers bus data only\nduring second clockphase.
$Comp
L Device:C_Small C26
U 1 1 606624D9
P 2700 2950
F 0 "C26" H 2800 2950 50  0000 L CNN
F 1 "100pF" H 2750 3050 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 2700 2950 50  0001 C CNN
F 3 "~" H 2700 2950 50  0001 C CNN
	1    2700 2950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR080
U 1 1 606629D4
P 2700 2850
F 0 "#PWR080" H 2700 2600 50  0001 C CNN
F 1 "GND" V 2700 2650 50  0000 C CNN
F 2 "" H 2700 2850 50  0001 C CNN
F 3 "" H 2700 2850 50  0001 C CNN
	1    2700 2850
	-1   0    0    1   
$EndComp
Text Notes 3150 3000 0    50   ~ 0
A longer trace was causing false triggering of this signal. 20pF\nwere enough to prevent that. For extra stability I've added 100pF.
$Comp
L power:GND #PWR?
U 1 1 6073229F
P 3700 3600
AR Path="/5F645851/6073229F" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/6073229F" Ref="#PWR076"  Part="1" 
F 0 "#PWR076" H 3700 3350 50  0001 C CNN
F 1 "GND" V 3700 3400 50  0000 C CNN
F 2 "" H 3700 3600 50  0001 C CNN
F 3 "" H 3700 3600 50  0001 C CNN
	1    3700 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60732670
P 3600 3600
AR Path="/5F645851/60732670" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/60732670" Ref="#PWR075"  Part="1" 
F 0 "#PWR075" H 3600 3350 50  0001 C CNN
F 1 "GND" V 3600 3400 50  0000 C CNN
F 2 "" H 3600 3600 50  0001 C CNN
F 3 "" H 3600 3600 50  0001 C CNN
	1    3600 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 607327FD
P 3500 3600
AR Path="/5F645851/607327FD" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/607327FD" Ref="#PWR074"  Part="1" 
F 0 "#PWR074" H 3500 3350 50  0001 C CNN
F 1 "GND" V 3500 3400 50  0000 C CNN
F 2 "" H 3500 3600 50  0001 C CNN
F 3 "" H 3500 3600 50  0001 C CNN
	1    3500 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60732923
P 3400 3600
AR Path="/5F645851/60732923" Ref="#PWR?"  Part="1" 
AR Path="/5F64487D/60732923" Ref="#PWR073"  Part="1" 
F 0 "#PWR073" H 3400 3350 50  0001 C CNN
F 1 "GND" V 3400 3400 50  0000 C CNN
F 2 "" H 3400 3600 50  0001 C CNN
F 3 "" H 3400 3600 50  0001 C CNN
	1    3400 3600
	-1   0    0    1   
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 607CBD09
P 3200 3600
F 0 "#PWR0101" H 3200 3450 50  0001 C CNN
F 1 "+5V" V 3200 3800 50  0000 C CNN
F 2 "" H 3200 3600 50  0001 C CNN
F 3 "" H 3200 3600 50  0001 C CNN
	1    3200 3600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 4 1 608B622D
P 2300 3050
AR Path="/5F645851/608B622D" Ref="U?"  Part="4" 
AR Path="/5F64487D/608B622D" Ref="U23"  Part="4" 
F 0 "U23" H 2300 3000 50  0000 C CNN
F 1 "74HC00" H 2300 3100 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2300 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 2300 3050 50  0001 C CNN
	4    2300 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 3050 2700 3050
Connection ~ 2700 3050
$EndSCHEMATC
