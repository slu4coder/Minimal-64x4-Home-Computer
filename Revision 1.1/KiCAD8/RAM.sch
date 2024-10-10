EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 8 10
Title "RAM, ROM and MAR"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
Text HLabel 6250 4100 0    50   Input ~ 0
~RO
Text HLabel 1100 1100 0    50   Input ~ 0
MI
Text HLabel 1100 1550 0    50   Input ~ 0
ME
Text HLabel 1100 1400 0    50   Input ~ 0
HI
Text GLabel 8500 2000 1    50   Input ~ 0
CLOCK
$Comp
L power:+5V #PWR?
U 1 1 5EFDEA03
P 7300 2500
AR Path="/5EC5738F/5EFDEA03" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEA03" Ref="#PWR0153"  Part="1" 
F 0 "#PWR0153" H 7300 2350 50  0001 C CNN
F 1 "+5V" H 7315 2673 50  0000 C CNN
F 2 "" H 7300 2500 50  0001 C CNN
F 3 "" H 7300 2500 50  0001 C CNN
	1    7300 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EFDEA09
P 5700 2500
AR Path="/5EC5738F/5EFDEA09" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEA09" Ref="#PWR0149"  Part="1" 
F 0 "#PWR0149" H 5700 2250 50  0001 C CNN
F 1 "GND" H 5705 2327 50  0000 C CNN
F 2 "" H 5700 2500 50  0001 C CNN
F 3 "" H 5700 2500 50  0001 C CNN
	1    5700 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EFDEA0F
P 8000 2500
AR Path="/5EC5738F/5EFDEA0F" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEA0F" Ref="#PWR0154"  Part="1" 
F 0 "#PWR0154" H 8000 2250 50  0001 C CNN
F 1 "GND" H 8005 2327 50  0000 C CNN
F 2 "" H 8000 2500 50  0001 C CNN
F 3 "" H 8000 2500 50  0001 C CNN
	1    8000 2500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5EFDEA15
P 9600 2500
AR Path="/5EC5738F/5EFDEA15" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEA15" Ref="#PWR0158"  Part="1" 
F 0 "#PWR0158" H 9600 2350 50  0001 C CNN
F 1 "+5V" H 9615 2673 50  0000 C CNN
F 2 "" H 9600 2500 50  0001 C CNN
F 3 "" H 9600 2500 50  0001 C CNN
	1    9600 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 2000 8700 2000
Wire Wire Line
	6400 2000 6400 1550
Wire Wire Line
	6400 1550 8700 1550
Wire Wire Line
	8700 1550 8700 2000
Wire Wire Line
	8800 3000 7650 3000
Wire Wire Line
	7650 3000 7650 1650
Wire Wire Line
	7650 1650 6300 1650
Wire Wire Line
	6300 1650 6300 2000
Text GLabel 6200 2000 1    50   Input ~ 0
CLOCK
Wire Wire Line
	6500 2000 6500 900 
Wire Wire Line
	8800 900  8800 2000
Text GLabel 3800 2000 1    50   Input ~ 0
CLOCK
$Comp
L power:+5V #PWR?
U 1 1 5EFDEA9A
P 2600 2500
AR Path="/5EC5738F/5EFDEA9A" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEA9A" Ref="#PWR0139"  Part="1" 
F 0 "#PWR0139" H 2600 2350 50  0001 C CNN
F 1 "+5V" H 2615 2673 50  0000 C CNN
F 2 "" H 2600 2500 50  0001 C CNN
F 3 "" H 2600 2500 50  0001 C CNN
	1    2600 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EFDEAA0
P 1000 2500
AR Path="/5EC5738F/5EFDEAA0" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEAA0" Ref="#PWR0132"  Part="1" 
F 0 "#PWR0132" H 1000 2250 50  0001 C CNN
F 1 "GND" H 1005 2327 50  0000 C CNN
F 2 "" H 1000 2500 50  0001 C CNN
F 3 "" H 1000 2500 50  0001 C CNN
	1    1000 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EFDEAA6
P 3300 2500
AR Path="/5EC5738F/5EFDEAA6" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEAA6" Ref="#PWR0141"  Part="1" 
F 0 "#PWR0141" H 3300 2250 50  0001 C CNN
F 1 "GND" H 3305 2327 50  0000 C CNN
F 2 "" H 3300 2500 50  0001 C CNN
F 3 "" H 3300 2500 50  0001 C CNN
	1    3300 2500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5EFDEAAC
P 4900 2500
AR Path="/5EC5738F/5EFDEAAC" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5EFDEAAC" Ref="#PWR0144"  Part="1" 
F 0 "#PWR0144" H 4900 2350 50  0001 C CNN
F 1 "+5V" H 4915 2673 50  0000 C CNN
F 2 "" H 4900 2500 50  0001 C CNN
F 3 "" H 4900 2500 50  0001 C CNN
	1    4900 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 2000 1700 1550
Wire Wire Line
	1700 1550 4000 1550
Wire Wire Line
	4000 1550 4000 2000
Wire Wire Line
	4100 3000 2950 3000
Wire Wire Line
	2950 3000 2950 1650
Wire Wire Line
	2950 1650 1600 1650
Wire Wire Line
	1600 1650 1600 2000
Wire Wire Line
	1800 2000 1800 1300
Wire Wire Line
	4100 1300 4100 2000
Wire Wire Line
	6500 3000 5300 3000
Wire Wire Line
	5300 3000 5300 1650
Wire Wire Line
	5300 1650 3900 1650
Wire Wire Line
	3900 1650 3900 2000
NoConn ~ 1800 3000
Wire Wire Line
	4000 1550 6400 1550
Connection ~ 4000 1550
Connection ~ 6400 1550
Wire Wire Line
	1100 1550 1700 1550
Connection ~ 1700 1550
Text HLabel 1100 800  0    50   Input ~ 0
~HI
Connection ~ 1800 1300
Connection ~ 6500 900 
$Comp
L power:GND #PWR?
U 1 1 5F341280
P 9350 5400
AR Path="/5EC5738F/5F341280" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5F341280" Ref="#PWR0157"  Part="1" 
F 0 "#PWR0157" H 9350 5150 50  0001 C CNN
F 1 "GND" H 9500 5350 50  0000 C CNN
F 2 "" H 9350 5400 50  0001 C CNN
F 3 "" H 9350 5400 50  0001 C CNN
	1    9350 5400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5F341CBA
P 8050 4400
AR Path="/5EC5738F/5F341CBA" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5F341CBA" Ref="#PWR0155"  Part="1" 
F 0 "#PWR0155" H 8050 4250 50  0001 C CNN
F 1 "+5V" V 8050 4600 50  0000 C CNN
F 2 "" H 8050 4400 50  0001 C CNN
F 3 "" H 8050 4400 50  0001 C CNN
	1    8050 4400
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U34
U 1 1 5F128879
P 1800 2500
F 0 "U34" V 2000 2000 50  0000 L CNN
F 1 "74HC161" V 1800 2300 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 1800 2500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 1800 2500 50  0001 C CNN
	1    1800 2500
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U36
U 1 1 5F129C59
P 4100 2500
F 0 "U36" V 4350 1950 50  0000 L CNN
F 1 "74HC161" V 4100 2300 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 4100 2500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 4100 2500 50  0001 C CNN
	1    4100 2500
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U39
U 1 1 5F12A684
P 6500 2500
F 0 "U39" V 6750 1950 50  0000 L CNN
F 1 "74HC161" V 6500 2350 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6500 2500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 6500 2500 50  0001 C CNN
	1    6500 2500
	0    1    1    0   
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC161 U41
U 1 1 5F12B63B
P 8800 2500
F 0 "U41" V 9050 1950 50  0000 L CNN
F 1 "74HC161" V 8800 2350 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 8800 2500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 8800 2500 50  0001 C CNN
	1    8800 2500
	0    1    1    0   
$EndComp
Connection ~ 8700 2000
$Comp
L 8-Bit~CPU~32k:CY62256 U40
U 1 1 5EFDB22D
P 8750 4900
F 0 "U40" V 8650 5050 50  0000 R CNN
F 1 "CY62256 RAM" V 8800 5300 50  0000 R CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 8750 4900 50  0001 C CNN
F 3 "" H 8750 4900 50  0001 C CNN
	1    8750 4900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1800 900  6500 900 
Text Label 2000 3000 3    50   ~ 0
M15
Wire Wire Line
	1800 1300 4100 1300
Wire Wire Line
	6500 900  8800 900 
Text Label 2100 3000 3    50   ~ 0
M14
Text Label 2200 3000 3    50   ~ 0
M13
$Comp
L power:+5V #PWR?
U 1 1 5FAA0823
P 5550 4400
AR Path="/5EC5738F/5FAA0823" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FAA0823" Ref="#PWR0148"  Part="1" 
F 0 "#PWR0148" H 5550 4250 50  0001 C CNN
F 1 "+5V" V 5550 4600 50  0000 C CNN
F 2 "" H 5550 4400 50  0001 C CNN
F 3 "" H 5550 4400 50  0001 C CNN
	1    5550 4400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FAAC23C
P 7050 5400
AR Path="/5EC5738F/5FAAC23C" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FAAC23C" Ref="#PWR0152"  Part="1" 
F 0 "#PWR0152" H 7050 5150 50  0001 C CNN
F 1 "GND" H 7200 5350 50  0000 C CNN
F 2 "" H 7050 5400 50  0001 C CNN
F 3 "" H 7050 5400 50  0001 C CNN
	1    7050 5400
	1    0    0    -1  
$EndComp
Text Label 9300 3000 3    50   ~ 0
M0
Text Label 9200 3000 3    50   ~ 0
M1
Text Label 9100 3000 3    50   ~ 0
M2
Text Label 7000 3000 3    50   ~ 0
M4
Text Label 6900 3000 3    50   ~ 0
M5
Text Label 6800 3000 3    50   ~ 0
M6
Text Label 6700 3000 3    50   ~ 0
M7
Text Label 4600 3000 3    50   ~ 0
M8
Text Label 4500 3000 3    50   ~ 0
M9
Text Label 4400 3000 3    50   ~ 0
M10
Text Label 4300 3000 3    50   ~ 0
M11
Text Label 2300 3000 3    50   ~ 0
M12
Text Label 8750 4400 1    50   ~ 0
M0
Text Label 8550 4400 1    50   ~ 0
M1
Text Label 8450 4400 1    50   ~ 0
M2
Text Label 8350 4400 1    50   ~ 0
M3
Text Label 8250 4400 1    50   ~ 0
M4
Text Label 8050 5400 3    50   ~ 0
M5
Text Label 8150 5400 3    50   ~ 0
M6
Text Label 8250 5400 3    50   ~ 0
M7
Text Label 8350 5400 3    50   ~ 0
M8
Text Label 8450 5400 3    50   ~ 0
M9
Text Label 8550 5400 3    50   ~ 0
M10
Text Label 8650 5400 3    50   ~ 0
M11
Text Label 8750 5400 3    50   ~ 0
M12
Text Label 8850 5400 3    50   ~ 0
M13
Text Label 8950 5400 3    50   ~ 0
M14
Text Label 9000 3000 3    50   ~ 0
M3
$Comp
L power:+5V #PWR?
U 1 1 5FE2E005
P 3600 2000
AR Path="/5EC5738F/5FE2E005" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FE2E005" Ref="#PWR0142"  Part="1" 
F 0 "#PWR0142" H 3600 1850 50  0001 C CNN
F 1 "+5V" H 3615 2173 50  0000 C CNN
F 2 "" H 3600 2000 50  0001 C CNN
F 3 "" H 3600 2000 50  0001 C CNN
	1    3600 2000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5FE2E2FA
P 1300 2000
AR Path="/5EC5738F/5FE2E2FA" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/5FE2E2FA" Ref="#PWR0133"  Part="1" 
F 0 "#PWR0133" H 1300 1850 50  0001 C CNN
F 1 "+5V" H 1315 2173 50  0000 C CNN
F 2 "" H 1300 2000 50  0001 C CNN
F 3 "" H 1300 2000 50  0001 C CNN
	1    1300 2000
	1    0    0    -1  
$EndComp
Text Notes 1800 1050 0    50   ~ 0
~MIL
Text Notes 1800 1450 0    50   ~ 0
~MIH
Text Label 6250 4400 1    50   ~ 0
M11
Text Label 6450 4400 1    50   ~ 0
M10
Text Label 6150 4400 1    50   ~ 0
M9
Text Label 6050 4400 1    50   ~ 0
M8
Text Label 5850 5400 3    50   ~ 0
M12
Text Label 5950 5400 3    50   ~ 0
M7
Text Label 6050 5400 3    50   ~ 0
M6
Text Label 6150 5400 3    50   ~ 0
M5
Text Label 6250 5400 3    50   ~ 0
M4
Text Label 6350 5400 3    50   ~ 0
M3
Text Label 6450 5400 3    50   ~ 0
M2
Text Label 6550 5400 3    50   ~ 0
M1
Text Label 6650 5400 3    50   ~ 0
M0
Text Notes 3550 3700 0    50   ~ 0
~ROM_CE
Text Notes 3550 3300 0    50   ~ 0
~RAM_CE
$Comp
L 74xx:74HC00 U?
U 1 1 600CA0EA
P 1500 900
AR Path="/5F64487D/600CA0EA" Ref="U?"  Part="2" 
AR Path="/5EC57456/600CA0EA" Ref="U19"  Part="1" 
F 0 "U19" H 1500 850 50  0000 C CNN
F 1 "74HC00" H 1500 950 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1500 900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 1500 900 50  0001 C CNN
	1    1500 900 
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 2 1 600CA0F0
P 1500 1300
AR Path="/5F64487D/600CA0F0" Ref="U?"  Part="4" 
AR Path="/5EC57456/600CA0F0" Ref="U19"  Part="2" 
F 0 "U19" H 1500 1250 50  0000 C CNN
F 1 "74HC00" H 1500 1350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1500 1300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 1500 1300 50  0001 C CNN
	2    1500 1300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 5 1 60102040
P 1250 7250
AR Path="/5F64487D/60102040" Ref="U?"  Part="5" 
AR Path="/5EC57456/60102040" Ref="U19"  Part="5" 
F 0 "U19" V 1350 7250 50  0000 C CNN
F 1 "74HC00" V 1150 7250 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1250 7250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 1250 7250 50  0001 C CNN
	5    1250 7250
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60102052
P 1750 7250
AR Path="/5F64487D/60102052" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60102052" Ref="#PWR0134"  Part="1" 
F 0 "#PWR0134" H 1750 7100 50  0001 C CNN
F 1 "+5V" V 1750 7450 50  0000 C CNN
F 2 "" H 1750 7250 50  0001 C CNN
F 3 "" H 1750 7250 50  0001 C CNN
	1    1750 7250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60102059
P 750 7250
AR Path="/5F64487D/60102059" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60102059" Ref="#PWR0131"  Part="1" 
F 0 "#PWR0131" H 750 7000 50  0001 C CNN
F 1 "GND" H 755 7077 50  0000 C CNN
F 2 "" H 750 7250 50  0001 C CNN
F 3 "" H 750 7250 50  0001 C CNN
	1    750  7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	8850 3300 8850 4400
Wire Wire Line
	6350 4100 6350 4400
Wire Wire Line
	8650 4400 8650 4100
Text HLabel 4750 4050 0    50   Input ~ 0
RI
Wire Wire Line
	8150 3950 8150 4400
$Comp
L 74xx:74HC00 U?
U 3 1 5FC71C44
P 5200 3950
AR Path="/5F64487D/5FC71C44" Ref="U?"  Part="3" 
AR Path="/5EC57456/5FC71C44" Ref="U19"  Part="3" 
F 0 "U19" H 5200 3900 50  0000 C CNN
F 1 "74HC00" H 5200 4000 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 5200 3950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 5200 3950 50  0001 C CNN
	3    5200 3950
	1    0    0    1   
$EndComp
Text Label 5950 4400 1    50   ~ 0
M13
Text Label 5850 4400 1    50   ~ 0
M14
Connection ~ 6350 4100
Wire Wire Line
	6350 4100 8650 4100
Wire Wire Line
	6250 4100 6350 4100
Wire Wire Line
	5500 3950 5650 3950
Wire Wire Line
	5650 4400 5650 3950
Connection ~ 5650 3950
Wire Wire Line
	5650 3950 8150 3950
Text GLabel 1500 2000 1    50   Input ~ 0
CLOCK
$Comp
L power:+5V #PWR?
U 1 1 600231A2
P 6000 2000
AR Path="/5EC5738F/600231A2" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/600231A2" Ref="#PWR0150"  Part="1" 
F 0 "#PWR0150" H 6000 1850 50  0001 C CNN
F 1 "+5V" H 6015 2173 50  0000 C CNN
F 2 "" H 6000 2000 50  0001 C CNN
F 3 "" H 6000 2000 50  0001 C CNN
	1    6000 2000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60023767
P 8300 2000
AR Path="/5EC5738F/60023767" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60023767" Ref="#PWR0156"  Part="1" 
F 0 "#PWR0156" H 8300 1850 50  0001 C CNN
F 1 "+5V" H 8315 2173 50  0000 C CNN
F 2 "" H 8300 2000 50  0001 C CNN
F 3 "" H 8300 2000 50  0001 C CNN
	1    8300 2000
	1    0    0    -1  
$EndComp
Text GLabel 4900 3850 0    50   Input ~ 0
CLOCK
Wire Wire Line
	1200 1000 1200 1100
Wire Wire Line
	1100 1400 1200 1400
Wire Wire Line
	1100 1100 1200 1100
Wire Wire Line
	1100 800  1200 800 
Text Notes 8950 1300 0    50   ~ 0
A separate reset of the MAR is not needed:\nDuring the time RESET is pressed,\nthe clock runs with SC=0 and PC=0.\nThis ensures that with CO|MI => MAL=0.\nAfter reset is released CO|MI|HI => MAH=0.
Text Notes 4750 3650 0    50   ~ 0
Writes during valid\nsecond clock phase.
$Comp
L 8-Bit~CPU~32k:SST39SF040A U38
U 1 1 6052A485
P 6450 4900
F 0 "U38" V 6350 5100 50  0000 R CNN
F 1 "SST39SF040A FLASH" V 6500 5500 50  0000 R CNN
F 2 "Package_DIP:DIP-32_W15.24mm_Socket" H 6450 4900 50  0001 C CNN
F 3 "" H 6450 4900 50  0001 C CNN
	1    6450 4900
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74HC00 U?
U 5 1 605DDF28
P 2500 7250
AR Path="/5F64487D/605DDF28" Ref="U?"  Part="5" 
AR Path="/5EC57456/605DDF28" Ref="U35"  Part="5" 
F 0 "U35" V 2600 7250 50  0000 C CNN
F 1 "74HC00" V 2400 7250 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2500 7250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 2500 7250 50  0001 C CNN
	5    2500 7250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 605DEC14
P 2000 7250
AR Path="/5F64487D/605DEC14" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/605DEC14" Ref="#PWR0135"  Part="1" 
F 0 "#PWR0135" H 2000 7000 50  0001 C CNN
F 1 "GND" H 2005 7077 50  0000 C CNN
F 2 "" H 2000 7250 50  0001 C CNN
F 3 "" H 2000 7250 50  0001 C CNN
	1    2000 7250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 605DEF47
P 3000 7250
AR Path="/5F64487D/605DEF47" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/605DEF47" Ref="#PWR0140"  Part="1" 
F 0 "#PWR0140" H 3000 7100 50  0001 C CNN
F 1 "+5V" V 3000 7450 50  0000 C CNN
F 2 "" H 3000 7250 50  0001 C CNN
F 3 "" H 3000 7250 50  0001 C CNN
	1    3000 7250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 1 1 605DFFE7
P 3250 3300
AR Path="/5F64487D/605DFFE7" Ref="U?"  Part="3" 
AR Path="/5EC57456/605DFFE7" Ref="U35"  Part="1" 
F 0 "U35" H 3250 3250 50  0000 C CNN
F 1 "74HC00" H 3250 3350 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 3250 3300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3250 3300 50  0001 C CNN
	1    3250 3300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U?
U 2 1 605E0D7C
P 3250 3700
AR Path="/5F64487D/605E0D7C" Ref="U?"  Part="3" 
AR Path="/5EC57456/605E0D7C" Ref="U35"  Part="2" 
F 0 "U35" H 3250 3650 50  0000 C CNN
F 1 "74HC00" H 3250 3750 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 3250 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3250 3700 50  0001 C CNN
	2    3250 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 3200 2000 3200
Wire Wire Line
	2000 3200 2000 3000
Wire Wire Line
	3550 3300 8850 3300
Wire Wire Line
	6550 3700 3550 3700
$Comp
L Device:R R10
U 1 1 606492D0
P 2700 3800
F 0 "R10" V 2800 3700 50  0000 L CNN
F 1 "4.7k" V 2700 3700 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2630 3800 50  0001 C CNN
F 3 "~" H 2700 3800 50  0001 C CNN
	1    2700 3800
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60649F6F
P 2550 3800
AR Path="/5F64487D/60649F6F" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60649F6F" Ref="#PWR0138"  Part="1" 
F 0 "#PWR0138" H 2550 3650 50  0001 C CNN
F 1 "+5V" V 2550 4000 50  0000 C CNN
F 2 "" H 2550 3800 50  0001 C CNN
F 3 "" H 2550 3800 50  0001 C CNN
	1    2550 3800
	0    -1   -1   0   
$EndComp
Text Label 5650 3950 0    50   ~ 0
~RI_VALID
Wire Wire Line
	2600 3600 2950 3600
Wire Wire Line
	2850 3400 2950 3400
Text HLabel 9000 2000 1    50   BiDi ~ 0
BUS3
Text HLabel 9100 2000 1    50   BiDi ~ 0
BUS2
Text HLabel 9200 2000 1    50   BiDi ~ 0
BUS1
Text HLabel 9300 2000 1    50   BiDi ~ 0
BUS0
Text HLabel 4300 2000 1    50   BiDi ~ 0
BUS3
Text HLabel 4400 2000 1    50   BiDi ~ 0
BUS2
Text HLabel 4500 2000 1    50   BiDi ~ 0
BUS1
Text HLabel 4600 2000 1    50   BiDi ~ 0
BUS0
Text HLabel 7000 2000 1    50   BiDi ~ 0
BUS4
Text HLabel 6900 2000 1    50   BiDi ~ 0
BUS5
Text HLabel 6800 2000 1    50   BiDi ~ 0
BUS6
Text HLabel 6700 2000 1    50   BiDi ~ 0
BUS7
Text HLabel 2300 2000 1    50   BiDi ~ 0
BUS4
Text HLabel 2200 2000 1    50   BiDi ~ 0
BUS5
Text HLabel 2100 2000 1    50   BiDi ~ 0
BUS6
Text HLabel 2000 2000 1    50   BiDi ~ 0
BUS7
Text HLabel 9250 5400 3    50   BiDi ~ 0
BUS2
Text HLabel 9150 5400 3    50   BiDi ~ 0
BUS1
Text HLabel 9050 5400 3    50   BiDi ~ 0
BUS0
Text HLabel 6950 5400 3    50   BiDi ~ 0
BUS2
Text HLabel 6850 5400 3    50   BiDi ~ 0
BUS1
Text HLabel 6750 5400 3    50   BiDi ~ 0
BUS0
Text HLabel 9350 4400 1    50   BiDi ~ 0
BUS3
Text HLabel 9250 4400 1    50   BiDi ~ 0
BUS4
Text HLabel 9150 4400 1    50   BiDi ~ 0
BUS5
Text HLabel 9050 4400 1    50   BiDi ~ 0
BUS6
Text HLabel 8950 4400 1    50   BiDi ~ 0
BUS7
Text HLabel 7050 4400 1    50   BiDi ~ 0
BUS3
Text HLabel 6950 4400 1    50   BiDi ~ 0
BUS4
Text HLabel 6850 4400 1    50   BiDi ~ 0
BUS5
Text HLabel 6750 4400 1    50   BiDi ~ 0
BUS6
Text HLabel 6650 4400 1    50   BiDi ~ 0
BUS7
Wire Wire Line
	6550 4400 6550 3700
Connection ~ 1200 1100
Wire Wire Line
	1200 1100 1200 1200
Text Notes 6800 3950 0    50   ~ 0
No instability found on this line.
Text Notes 4450 4300 0    50   ~ 0
>=140pF
$Comp
L power:GND #PWR?
U 1 1 6084CEAB
P 4900 4250
AR Path="/5EC57429/6084CEAB" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/6084CEAB" Ref="#PWR0145"  Part="1" 
F 0 "#PWR0145" H 4900 4000 50  0001 C CNN
F 1 "GND" V 4900 4150 50  0000 R CNN
F 2 "" H 4900 4250 50  0001 C CNN
F 3 "" H 4900 4250 50  0001 C CNN
	1    4900 4250
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 6084CEB1
P 4900 4150
AR Path="/5EC57429/6084CEB1" Ref="C?"  Part="1" 
AR Path="/5EC57456/6084CEB1" Ref="C27"  Part="1" 
F 0 "C27" H 4800 4250 50  0000 C CNN
F 1 "470pF" H 5100 4150 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 4900 4150 50  0001 C CNN
F 3 "~" H 4900 4150 50  0001 C CNN
	1    4900 4150
	-1   0    0    1   
$EndComp
Wire Wire Line
	4750 4050 4900 4050
Connection ~ 4900 4050
Wire Wire Line
	2850 3400 2850 3800
Wire Wire Line
	2950 3800 2850 3800
Connection ~ 2850 3800
$Comp
L 74xx:74HC00 U19
U 4 1 608BC007
P 1250 6600
AR Path="/5EC57456/608BC007" Ref="U19"  Part="4" 
AR Path="/5F645851/608BC007" Ref="U?"  Part="1" 
AR Path="/5EC57429/608BC007" Ref="U?"  Part="4" 
AR Path="/5F64487D/608BC007" Ref="U?"  Part="4" 
F 0 "U19" H 1250 6550 50  0000 C CNN
F 1 "74HC00" H 1250 6650 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1250 6600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1250 6600 50  0001 C CNN
	4    1250 6600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC04 U?
U 3 1 6092B034
P 2300 3600
AR Path="/5F645851/6092B034" Ref="U?"  Part="3" 
AR Path="/5EC57429/6092B034" Ref="U?"  Part="3" 
AR Path="/5EC57456/6092B034" Ref="U1"  Part="3" 
F 0 "U1" H 2250 3650 50  0000 C CNN
F 1 "74HC04" H 2300 3550 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2300 3600 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 2300 3600 50  0001 C CNN
	3    2300 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 3600 2000 3200
Connection ~ 2000 3200
NoConn ~ 1550 6600
Wire Wire Line
	950  6500 950  6700
$Comp
L power:GND #PWR?
U 1 1 60A29ABB
P 950 6700
AR Path="/5F64487D/60A29ABB" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60A29ABB" Ref="#PWR0196"  Part="1" 
F 0 "#PWR0196" H 950 6450 50  0001 C CNN
F 1 "GND" H 955 6527 50  0000 C CNN
F 2 "" H 950 6700 50  0001 C CNN
F 3 "" H 950 6700 50  0001 C CNN
	1    950  6700
	1    0    0    -1  
$EndComp
Connection ~ 950  6700
Text Notes 2150 6950 0    50   ~ 0
NAND_C in Control
$Comp
L 74xx:74HC04 U1
U 2 1 60921A1A
P 6650 7000
AR Path="/5EC57456/60921A1A" Ref="U1"  Part="2" 
AR Path="/5EC57429/60921A1A" Ref="U?"  Part="2" 
AR Path="/60921A1A" Ref="U?"  Part="2" 
AR Path="/60B12F32/60921A1A" Ref="U?"  Part="2" 
F 0 "U1" V 6650 7000 50  0000 C CNN
F 1 "74HC04" V 6550 7000 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6650 7000 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 6650 7000 50  0001 C CNN
	2    6650 7000
	0    1    -1   0   
$EndComp
Text HLabel 6350 7500 3    50   Input ~ 0
EC
Text HLabel 6150 7500 3    50   Input ~ 0
HI
Connection ~ 6250 6700
Wire Wire Line
	6250 6900 6250 6700
$Comp
L 74xx:74HC00 U?
U 4 1 60A5043E
P 6250 7200
AR Path="/5F64487D/60A5043E" Ref="U?"  Part="3" 
AR Path="/5EC57456/60A5043E" Ref="U35"  Part="4" 
AR Path="/5EC57429/60A5043E" Ref="U?"  Part="4" 
F 0 "U35" H 6250 7150 50  0000 C CNN
F 1 "74HC00" H 6250 7250 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 6250 7200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6250 7200 50  0001 C CNN
	4    6250 7200
	0    1    -1   0   
$EndComp
Text Notes 6750 5850 2    50   ~ 0
BANK REGISTER
$Comp
L power:+5V #PWR?
U 1 1 605AC98D
P 5150 6200
AR Path="/5EC573DA/605AC98D" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/605AC98D" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/605AC98D" Ref="#PWR0151"  Part="1" 
F 0 "#PWR0151" H 5150 6050 50  0001 C CNN
F 1 "+5V" V 5150 6300 50  0000 L CNN
F 2 "" H 5150 6200 50  0001 C CNN
F 3 "" H 5150 6200 50  0001 C CNN
	1    5150 6200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 605AC4A4
P 6950 6200
AR Path="/5F64487D/605AC4A4" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/605AC4A4" Ref="#PWR0143"  Part="1" 
F 0 "#PWR0143" H 6950 5950 50  0001 C CNN
F 1 "GND" H 6955 6027 50  0000 C CNN
F 2 "" H 6950 6200 50  0001 C CNN
F 3 "" H 6950 6200 50  0001 C CNN
	1    6950 6200
	1    0    0    -1  
$EndComp
Text HLabel 5550 6700 3    50   BiDi ~ 0
BUS3
Text HLabel 5450 6700 3    50   BiDi ~ 0
BUS2
Text HLabel 5650 6700 3    50   BiDi ~ 0
BUS1
Text HLabel 5750 6700 3    50   BiDi ~ 0
BUS0
Wire Wire Line
	6350 6700 6250 6700
$Comp
L power:GND #PWR?
U 1 1 6057B2C9
P 5950 6700
AR Path="/5EC573DA/6057B2C9" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/6057B2C9" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/6057B2C9" Ref="#PWR0147"  Part="1" 
F 0 "#PWR0147" H 5950 6450 50  0001 C CNN
F 1 "GND" V 5950 6600 50  0000 R CNN
F 2 "" H 5950 6700 50  0001 C CNN
F 3 "" H 5950 6700 50  0001 C CNN
	1    5950 6700
	1    0    0    -1  
$EndComp
$Comp
L 8-Bit~CPU~32k:74HC173 U37
U 1 1 604D19F1
P 6050 6200
F 0 "U37" V 6200 6150 50  0000 L CNN
F 1 "74HC173" V 6100 6000 50  0000 L CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 6050 6200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 6050 6200 50  0001 C CNN
	1    6050 6200
	0    -1   -1   0   
$EndComp
Text GLabel 6650 7300 3    50   Input ~ 0
~RESET
$Comp
L power:GND #PWR?
U 1 1 60785435
P 6050 6700
AR Path="/5EC573DA/60785435" Ref="#PWR?"  Part="1" 
AR Path="/5EC57429/60785435" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60785435" Ref="#PWR0146"  Part="1" 
F 0 "#PWR0146" H 6050 6450 50  0001 C CNN
F 1 "GND" V 6050 6600 50  0000 R CNN
F 2 "" H 6050 6700 50  0001 C CNN
F 3 "" H 6050 6700 50  0001 C CNN
	1    6050 6700
	1    0    0    -1  
$EndComp
Text GLabel 6450 6700 3    50   Input ~ 0
CLOCK
Wire Wire Line
	5750 5700 5750 5400
Wire Wire Line
	5650 5700 5650 5400
Wire Wire Line
	5550 5700 5550 5400
Wire Wire Line
	5450 5700 5450 4100
Wire Wire Line
	5450 4100 5750 4100
Wire Wire Line
	5750 4100 5750 4400
$Comp
L Connector_Generic:Conn_02x16_Odd_Even J3
U 1 1 60777BD9
P 2450 4900
F 0 "J3" V 2500 5250 50  0001 C CNN
F 1 "EXPANSION PORT" V 2500 4750 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x16_P2.54mm_Vertical" H 2450 4900 50  0001 C CNN
F 3 "~" H 2450 4900 50  0001 C CNN
	1    2450 4900
	0    1    -1   0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60778F98
P 3150 5100
AR Path="/5F64487D/60778F98" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/60778F98" Ref="#PWR0136"  Part="1" 
F 0 "#PWR0136" H 3150 4850 50  0001 C CNN
F 1 "GND" V 3155 4927 50  0000 C CNN
F 2 "" H 3150 5100 50  0001 C CNN
F 3 "" H 3150 5100 50  0001 C CNN
	1    3150 5100
	-1   0    0    -1  
$EndComp
NoConn ~ 3150 4600
$Comp
L power:+5V #PWR?
U 1 1 6077B9F6
P 3050 5100
AR Path="/5F64487D/6077B9F6" Ref="#PWR?"  Part="1" 
AR Path="/5EC57456/6077B9F6" Ref="#PWR0137"  Part="1" 
F 0 "#PWR0137" H 3050 4950 50  0001 C CNN
F 1 "+5V" V 3050 5300 50  0000 C CNN
F 2 "" H 3050 5100 50  0001 C CNN
F 3 "" H 3050 5100 50  0001 C CNN
	1    3050 5100
	1    0    0    1   
$EndComp
Text GLabel 3050 4600 1    50   Input ~ 0
~RESET
Text GLabel 2950 5100 3    50   Input ~ 0
CLOCK
Text HLabel 2950 4600 1    50   Input ~ 0
RI
Text HLabel 2850 5100 3    50   Input ~ 0
~RO
Text Notes 2850 4300 1    50   ~ 0
~INH~
Text HLabel 2750 5100 3    50   BiDi ~ 0
BUS0
Text HLabel 2750 4600 1    50   BiDi ~ 0
BUS1
Text HLabel 2650 5100 3    50   BiDi ~ 0
BUS2
Text HLabel 2550 5100 3    50   BiDi ~ 0
BUS4
Text HLabel 2450 5100 3    50   BiDi ~ 0
BUS6
Text HLabel 2450 4600 1    50   BiDi ~ 0
BUS7
Text HLabel 2550 4600 1    50   BiDi ~ 0
BUS5
Text HLabel 2650 4600 1    50   BiDi ~ 0
BUS3
Text Label 2350 5100 3    50   ~ 0
M0
Text Label 2250 5100 3    50   ~ 0
M2
Text Label 2150 5100 3    50   ~ 0
M4
Text Label 2050 5100 3    50   ~ 0
M6
Text Label 1950 5100 3    50   ~ 0
M8
Text Label 1850 5100 3    50   ~ 0
M10
Text Label 1750 5100 3    50   ~ 0
M12
Text Label 1650 5100 3    50   ~ 0
M14
Text Label 2350 4600 1    50   ~ 0
M1
Text Label 2250 4600 1    50   ~ 0
M3
Text Label 2150 4600 1    50   ~ 0
M5
Text Label 2050 4600 1    50   ~ 0
M7
Text Label 1950 4600 1    50   ~ 0
M9
Text Label 1850 4600 1    50   ~ 0
M11
Text Label 1750 4600 1    50   ~ 0
M13
Text Label 1650 4600 1    50   ~ 0
M15
Wire Wire Line
	2850 4600 2850 3800
$EndSCHEMATC
