EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 8268 11693 portrait
encoding utf-8
Sheet 1 10
Title "Minimal CPU System"
Date "2021-04-16"
Rev "1.5"
Comp ""
Comment1 ""
Comment2 "creativecommons.org/licenses/by-nc-sa/3.0/deed.en"
Comment3 "License: CC BY-NC-SA 3.0"
Comment4 "Author: Carsten Herting (Slu4)"
$EndDescr
$Sheet
S 5100 5100 650  1150
U 5EC573DA
F0 "Reg A" 50
F1 "RegA.sch" 50
F2 "BUS0" B L 5100 5200 50 
F3 "BUS1" B L 5100 5300 50 
F4 "BUS2" B L 5100 5400 50 
F5 "BUS3" B L 5100 5500 50 
F6 "BUS4" B L 5100 5600 50 
F7 "BUS5" B L 5100 5700 50 
F8 "BUS6" B L 5100 5800 50 
F9 "BUS7" B L 5100 5900 50 
F10 "~AI" I L 5100 6150 50 
F11 "~AO" I L 5100 6050 50 
F12 "R0" O R 5750 5200 50 
F13 "R1" O R 5750 5300 50 
F14 "R2" O R 5750 5400 50 
F15 "R3" O R 5750 5500 50 
F16 "R4" O R 5750 5600 50 
F17 "R5" O R 5750 5700 50 
F18 "R6" O R 5750 5800 50 
F19 "R7" O R 5750 5900 50 
$EndSheet
$Sheet
S 6200 2950 650  3750
U 5EC57909
F0 "ALU" 50
F1 "ALU.sch" 50
F2 "BUS0" O L 6200 4250 50 
F3 "BUS1" O L 6200 4350 50 
F4 "BUS2" O L 6200 4450 50 
F5 "BUS3" O L 6200 4550 50 
F6 "BUS4" O L 6200 4650 50 
F7 "BUS5" O L 6200 4750 50 
F8 "BUS6" O L 6200 4850 50 
F9 "BUS7" O L 6200 4950 50 
F10 "A0" I L 6200 5200 50 
F11 "A1" I L 6200 5300 50 
F12 "A2" I L 6200 5400 50 
F13 "A3" I L 6200 5500 50 
F14 "A4" I L 6200 5600 50 
F15 "A5" I L 6200 5700 50 
F16 "A6" I L 6200 5800 50 
F17 "A7" I L 6200 5900 50 
F18 "B0" I L 6200 3050 50 
F19 "B1" I L 6200 3150 50 
F20 "B2" I L 6200 3250 50 
F21 "B3" I L 6200 3350 50 
F22 "B4" I L 6200 3450 50 
F23 "B5" I L 6200 3550 50 
F24 "B6" I L 6200 3650 50 
F25 "B7" I L 6200 3750 50 
F26 "~EO" I R 6850 6400 50 
F27 "ES" I R 6850 6500 50 
F28 "EC" I R 6850 6600 50 
F29 "FLAG_C" O L 6200 6500 50 
F30 "FLAG_Z" O L 6200 6600 50 
F31 "FLAG_N" O L 6200 6400 50 
$EndSheet
Wire Wire Line
	5750 5200 6200 5200
Wire Wire Line
	6200 5300 5750 5300
Wire Wire Line
	5750 5400 6200 5400
Wire Wire Line
	5750 5500 6200 5500
Wire Wire Line
	5750 5600 6200 5600
Wire Wire Line
	5750 5700 6200 5700
Wire Wire Line
	5750 5800 6200 5800
Wire Wire Line
	5750 5900 6200 5900
Connection ~ 4650 7100
Connection ~ 4550 7200
Wire Wire Line
	5100 7300 4450 7300
Connection ~ 4450 7300
Wire Wire Line
	5100 7400 4350 7400
Connection ~ 4350 7400
Wire Wire Line
	5100 7500 4250 7500
Connection ~ 4250 7500
Wire Wire Line
	5100 7600 4150 7600
Connection ~ 4150 7600
Wire Wire Line
	5100 7700 4050 7700
Connection ~ 4050 7700
Wire Wire Line
	5100 7800 3950 7800
Connection ~ 3950 7800
Wire Wire Line
	4650 4250 6200 4250
Wire Wire Line
	4550 4350 6200 4350
Wire Wire Line
	4450 4450 6200 4450
Wire Wire Line
	4350 4550 6200 4550
Wire Wire Line
	4250 4650 6200 4650
Wire Wire Line
	4150 4750 6200 4750
Wire Wire Line
	4050 4850 6200 4850
Wire Wire Line
	3950 4950 6200 4950
Wire Wire Line
	5100 5200 4650 5200
Connection ~ 4650 5200
Wire Wire Line
	4650 5200 4650 7100
Wire Wire Line
	5100 5300 4550 5300
Connection ~ 4550 5300
Wire Wire Line
	4550 5300 4550 7200
Wire Wire Line
	5100 5400 4450 5400
Connection ~ 4450 5400
Wire Wire Line
	4450 5400 4450 7300
Wire Wire Line
	5100 5500 4350 5500
Connection ~ 4350 5500
Wire Wire Line
	4350 5500 4350 7400
Wire Wire Line
	5100 5600 4250 5600
Connection ~ 4250 5600
Wire Wire Line
	4250 5600 4250 7500
Wire Wire Line
	4150 5700 5100 5700
Connection ~ 4150 5700
Wire Wire Line
	4150 5700 4150 7600
Wire Wire Line
	5100 5800 4050 5800
Connection ~ 4050 5800
Wire Wire Line
	4050 5800 4050 7700
Wire Wire Line
	3950 5900 5100 5900
Connection ~ 3950 5900
Wire Wire Line
	3950 5900 3950 7800
Wire Wire Line
	2500 6600 2400 6600
Wire Wire Line
	2400 6600 2400 7100
$Comp
L Device:R R2
U 1 1 5EF6AFDA
P 3950 8050
F 0 "R2" V 4000 7850 50  0000 L CNN
F 1 "470" V 3950 7950 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3880 8050 50  0001 C CNN
F 3 "~" H 3950 8050 50  0001 C CNN
	1    3950 8050
	-1   0    0    1   
$EndComp
Wire Wire Line
	2250 6150 2500 6150
Wire Wire Line
	2250 6150 2250 7350
Wire Wire Line
	1850 8450 6000 8450
Wire Wire Line
	2500 5200 1950 5200
Wire Wire Line
	1950 8350 5900 8350
Wire Wire Line
	3150 5200 4650 5200
Wire Wire Line
	4550 5300 3150 5300
Wire Wire Line
	3150 5400 4450 5400
Wire Wire Line
	4350 5500 3150 5500
Wire Wire Line
	3150 5600 4250 5600
Wire Wire Line
	4150 5700 3150 5700
Wire Wire Line
	3150 7100 4650 7100
Wire Wire Line
	3150 7200 4550 7200
Wire Wire Line
	4450 7300 3150 7300
Wire Wire Line
	3150 7400 4350 7400
Wire Wire Line
	4250 7500 3150 7500
Wire Wire Line
	3150 7600 4150 7600
Wire Wire Line
	4050 7700 3150 7700
Wire Wire Line
	3150 7800 3950 7800
Connection ~ 4250 8200
$Comp
L Device:R R5
U 1 1 5ED8EC6D
P 4250 8050
F 0 "R5" V 4200 8150 50  0000 L CNN
F 1 "470" V 4250 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4180 8050 50  0001 C CNN
F 3 "~" H 4250 8050 50  0001 C CNN
	1    4250 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 8200 4350 8200
Connection ~ 4350 8200
$Comp
L Device:R R6
U 1 1 5ED8E729
P 4350 8050
F 0 "R6" V 4300 8150 50  0000 L CNN
F 1 "470" V 4350 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4280 8050 50  0001 C CNN
F 3 "~" H 4350 8050 50  0001 C CNN
	1    4350 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 8200 4450 8200
Connection ~ 4450 8200
$Comp
L Device:R R7
U 1 1 5ED8E208
P 4450 8050
F 0 "R7" V 4400 8150 50  0000 L CNN
F 1 "470" V 4450 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4380 8050 50  0001 C CNN
F 3 "~" H 4450 8050 50  0001 C CNN
	1    4450 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 8200 4550 8200
Connection ~ 4550 8200
$Comp
L Device:R R8
U 1 1 5ED8DB17
P 4550 8050
F 0 "R8" V 4500 8150 50  0000 L CNN
F 1 "470" V 4550 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4480 8050 50  0001 C CNN
F 3 "~" H 4550 8050 50  0001 C CNN
	1    4550 8050
	1    0    0    -1  
$EndComp
Connection ~ 4650 8200
Wire Wire Line
	4550 8200 4650 8200
$Comp
L Device:R R9
U 1 1 5ED0FC24
P 4650 8050
F 0 "R9" V 4600 8150 50  0000 L CNN
F 1 "470" V 4650 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4580 8050 50  0001 C CNN
F 3 "~" H 4650 8050 50  0001 C CNN
	1    4650 8050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 5ED8F666
P 4050 8050
F 0 "R3" V 4000 8150 50  0000 L CNN
F 1 "470" V 4050 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3980 8050 50  0001 C CNN
F 3 "~" H 4050 8050 50  0001 C CNN
	1    4050 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 7700 4050 7900
Wire Wire Line
	4150 7600 4150 7900
Wire Wire Line
	4650 7100 4650 7900
Wire Wire Line
	4550 7200 4550 7900
Wire Wire Line
	4450 7300 4450 7900
Wire Wire Line
	4350 7400 4350 7900
Wire Wire Line
	4250 7500 4250 7900
Wire Wire Line
	1950 5200 1950 7700
Wire Wire Line
	2500 7700 1950 7700
Connection ~ 1950 7700
$Sheet
S 2500 850  650  1050
U 5F645851
F0 "UART Receiver" 50
F1 "UART_RX.sch" 50
F2 "BUS0" O R 3150 950 50 
F3 "BUS1" O R 3150 1050 50 
F4 "BUS2" O R 3150 1150 50 
F5 "BUS3" O R 3150 1250 50 
F6 "BUS4" O R 3150 1350 50 
F7 "BUS5" O R 3150 1450 50 
F8 "BUS6" O R 3150 1550 50 
F9 "BUS7" O R 3150 1650 50 
F10 "TO" I R 3150 1800 50 
F11 "RX" I L 2500 1800 50 
$EndSheet
Wire Wire Line
	1650 8650 6950 8650
Wire Wire Line
	6950 8650 6950 6600
Wire Wire Line
	6950 6600 6850 6600
Wire Wire Line
	6850 6500 7000 6500
Wire Wire Line
	7000 6500 7000 8700
Wire Wire Line
	7000 8700 1600 8700
Wire Wire Line
	6850 6400 7050 6400
Wire Wire Line
	2350 6500 2500 6500
Wire Wire Line
	2350 6500 2350 7200
Wire Wire Line
	3150 950  4650 950 
Wire Wire Line
	4650 950  4650 2300
Wire Wire Line
	3150 1050 4550 1050
Wire Wire Line
	4550 1050 4550 2400
Wire Wire Line
	3150 1150 4450 1150
Wire Wire Line
	4450 1150 4450 2500
Wire Wire Line
	3150 1250 4350 1250
Wire Wire Line
	4350 1250 4350 2600
Wire Wire Line
	4250 1350 3150 1350
Wire Wire Line
	4250 1350 4250 2700
Wire Wire Line
	3150 1450 4150 1450
Wire Wire Line
	4150 1450 4150 2800
Wire Wire Line
	4050 1550 3150 1550
Wire Wire Line
	4050 1550 4050 2900
Wire Wire Line
	3150 1650 3950 1650
Wire Wire Line
	3950 1650 3950 3000
Wire Wire Line
	3150 2300 4650 2300
Wire Wire Line
	4550 2400 3150 2400
Wire Wire Line
	3150 2500 4450 2500
Wire Wire Line
	4350 2600 3150 2600
Wire Wire Line
	3150 2700 4250 2700
Wire Wire Line
	4150 2800 3150 2800
Wire Wire Line
	3150 2900 4050 2900
Wire Wire Line
	3950 3000 3150 3000
Wire Wire Line
	1950 7700 1950 8350
Wire Wire Line
	2500 5300 2000 5300
$Comp
L Connector:Conn_01x06_Female J1
U 1 1 5F351101
P 1650 1700
F 0 "J1" H 1550 2150 50  0000 C CNN
F 1 "UART" H 1550 2050 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x06_P2.54mm_Vertical" H 1650 1700 50  0001 C CNN
F 3 "~" H 1650 1700 50  0001 C CNN
	1    1650 1700
	-1   0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5F399079
P 2000 1700
F 0 "#FLG02" H 2000 1775 50  0001 C CNN
F 1 "PWR_FLAG" H 2250 1800 50  0000 C CNN
F 2 "" H 2000 1700 50  0001 C CNN
F 3 "~" H 2000 1700 50  0001 C CNN
	1    2000 1700
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5F399B07
P 2000 1500
F 0 "#FLG01" H 2000 1575 50  0001 C CNN
F 1 "PWR_FLAG" H 2250 1600 50  0000 C CNN
F 2 "" H 2000 1500 50  0001 C CNN
F 3 "~" H 2000 1500 50  0001 C CNN
	1    2000 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 2300 2350 1900
$Sheet
S 2500 2200 650  1050
U 5F64487D
F0 "UART Transmitter" 50
F1 "UART_TX.sch" 50
F2 "BUS0" I R 3150 2300 50 
F3 "BUS1" I R 3150 2400 50 
F4 "BUS2" I R 3150 2500 50 
F5 "BUS3" I R 3150 2600 50 
F6 "BUS4" I R 3150 2700 50 
F7 "BUS5" I R 3150 2800 50 
F8 "BUS6" I R 3150 2900 50 
F9 "BUS7" I R 3150 3000 50 
F10 "TX" O L 2500 2300 50 
F11 "TI" I R 3150 3150 50 
$EndSheet
Wire Wire Line
	5100 7200 4550 7200
Wire Wire Line
	5100 7100 4650 7100
Wire Wire Line
	5850 7800 5850 8300
Wire Wire Line
	5900 7700 5900 8350
Wire Wire Line
	7050 8750 1550 8750
Wire Wire Line
	7050 6400 7050 8750
$Sheet
S 5100 7000 650  900 
U 5EC5738F
F0 "PC" 50
F1 "PC.sch" 50
F2 "BUS0" B L 5100 7100 50 
F3 "BUS1" B L 5100 7200 50 
F4 "BUS2" B L 5100 7300 50 
F5 "BUS3" B L 5100 7400 50 
F6 "BUS4" B L 5100 7500 50 
F7 "BUS5" B L 5100 7600 50 
F8 "BUS6" B L 5100 7700 50 
F9 "BUS7" B L 5100 7800 50 
F10 "CE" I R 5750 7300 50 
F11 "HI" I R 5750 7700 50 
F12 "CI" I R 5750 7100 50 
F13 "CO" I R 5750 7200 50 
F14 "~HI" I R 5750 7800 50 
$EndSheet
Wire Wire Line
	3950 7800 3950 7900
Wire Wire Line
	2350 1900 1850 1900
$Comp
L power:GND #PWR03
U 1 1 5F46FAF8
P 2000 1500
F 0 "#PWR03" H 2000 1250 50  0001 C CNN
F 1 "GND" V 2000 1350 50  0000 R CNN
F 2 "" H 2000 1500 50  0001 C CNN
F 3 "" H 2000 1500 50  0001 C CNN
	1    2000 1500
	0    -1   -1   0   
$EndComp
NoConn ~ 1850 1600
NoConn ~ 1850 2000
$Comp
L power:+5V #PWR04
U 1 1 5F6BB48A
P 2000 1700
F 0 "#PWR04" H 2000 1550 50  0001 C CNN
F 1 "+5V" V 2000 1850 50  0000 L CNN
F 2 "" H 2000 1700 50  0001 C CNN
F 3 "" H 2000 1700 50  0001 C CNN
	1    2000 1700
	0    1    1    0   
$EndComp
Connection ~ 4150 8200
Wire Wire Line
	4150 8200 4250 8200
Wire Wire Line
	4050 8200 4150 8200
$Comp
L Device:R R4
U 1 1 5ED8F236
P 4150 8050
F 0 "R4" V 4100 8150 50  0000 L CNN
F 1 "470" V 4150 8000 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4080 8050 50  0001 C CNN
F 3 "~" H 4150 8050 50  0001 C CNN
	1    4150 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 6050 5100 6050
Connection ~ 2000 1700
Connection ~ 2000 1500
Wire Wire Line
	6200 3750 5750 3750
Wire Wire Line
	5750 3650 6200 3650
Wire Wire Line
	6200 3550 5750 3550
Wire Wire Line
	5750 3450 6200 3450
Wire Wire Line
	6200 3350 5750 3350
Wire Wire Line
	5750 3250 6200 3250
Wire Wire Line
	5750 3150 6200 3150
Wire Wire Line
	5750 3050 6200 3050
Wire Wire Line
	3150 3900 5100 3900
Wire Wire Line
	3150 4000 5100 4000
$Sheet
S 5100 2950 650  1150
U 5EC5A568
F0 "Reg B" 50
F1 "RegB.sch" 50
F2 "BUS0" B L 5100 3050 50 
F3 "BUS1" B L 5100 3150 50 
F4 "BUS2" B L 5100 3250 50 
F5 "BUS3" B L 5100 3350 50 
F6 "BUS4" B L 5100 3450 50 
F7 "BUS5" B L 5100 3550 50 
F8 "BUS6" B L 5100 3650 50 
F9 "BUS7" B L 5100 3750 50 
F10 "~BI" I L 5100 4000 50 
F11 "~BO" I L 5100 3900 50 
F12 "R0" O R 5750 3050 50 
F13 "R1" O R 5750 3150 50 
F14 "R2" O R 5750 3250 50 
F15 "R3" O R 5750 3350 50 
F16 "R4" O R 5750 3450 50 
F17 "R5" O R 5750 3550 50 
F18 "R6" O R 5750 3650 50 
F19 "R7" O R 5750 3750 50 
$EndSheet
Connection ~ 3950 3000
Wire Wire Line
	3950 3000 3950 3750
Connection ~ 3950 3750
Wire Wire Line
	5100 3750 3950 3750
Connection ~ 4050 2900
Wire Wire Line
	4050 2900 4050 3650
Wire Wire Line
	5100 3650 4050 3650
Connection ~ 4050 3650
Connection ~ 4150 2800
Wire Wire Line
	4150 2800 4150 3550
Wire Wire Line
	4150 3550 5100 3550
Connection ~ 4150 3550
Connection ~ 4250 2700
Wire Wire Line
	4250 2700 4250 3450
Wire Wire Line
	5100 3450 4250 3450
Connection ~ 4250 3450
Connection ~ 4350 2600
Wire Wire Line
	4350 2600 4350 3350
Wire Wire Line
	4350 3350 5100 3350
Connection ~ 4350 3350
Connection ~ 4450 2500
Wire Wire Line
	4450 2500 4450 3250
Wire Wire Line
	5100 3250 4450 3250
Connection ~ 4450 3250
Connection ~ 4550 2400
Wire Wire Line
	4550 2400 4550 3150
Wire Wire Line
	5100 3150 4550 3150
Connection ~ 4550 3150
Connection ~ 4650 2300
Wire Wire Line
	4650 2300 4650 3050
Wire Wire Line
	5100 3050 4650 3050
Connection ~ 4650 3050
Wire Wire Line
	3150 6150 5100 6150
Wire Wire Line
	2000 8300 5850 8300
Wire Wire Line
	3950 8200 4050 8200
Connection ~ 4050 8200
Wire Wire Line
	1850 4950 2500 4950
$Sheet
S 2500 7000 650  900 
U 5EC57456
F0 "Memory" 50
F1 "RAM.sch" 50
F2 "BUS0" B R 3150 7100 50 
F3 "BUS1" B R 3150 7200 50 
F4 "BUS2" B R 3150 7300 50 
F5 "BUS3" B R 3150 7400 50 
F6 "BUS4" B R 3150 7500 50 
F7 "BUS5" B R 3150 7600 50 
F8 "BUS6" B R 3150 7700 50 
F9 "BUS7" B R 3150 7800 50 
F10 "RI" I L 2500 7200 50 
F11 "~RO" I L 2500 7100 50 
F12 "MI" I L 2500 7350 50 
F13 "HI" I L 2500 7700 50 
F14 "ME" I L 2500 7450 50 
F15 "~HI" I L 2500 7800 50 
F16 "EC" I L 2500 7600 50 
$EndSheet
Wire Wire Line
	1750 8550 6100 8550
Wire Wire Line
	1750 4750 2500 4750
Wire Wire Line
	1750 4750 1750 8550
Wire Wire Line
	1800 8500 6050 8500
Wire Wire Line
	2500 4850 1800 4850
Wire Wire Line
	1800 4850 1800 8500
Wire Wire Line
	1850 4950 1850 8450
Wire Wire Line
	2200 7450 2200 6050
Wire Wire Line
	2200 6050 2500 6050
Wire Wire Line
	2000 5300 2000 7800
Wire Wire Line
	2000 7800 2500 7800
Connection ~ 2000 7800
Wire Wire Line
	2000 7800 2000 8300
Wire Wire Line
	1850 1500 2000 1500
Wire Wire Line
	1850 1700 2000 1700
Wire Wire Line
	1650 4450 1650 7600
Wire Wire Line
	1650 4450 2500 4450
Wire Wire Line
	1600 8700 1600 4350
Wire Wire Line
	1600 4350 2500 4350
Wire Wire Line
	1550 8750 1550 4250
Wire Wire Line
	1550 4250 2500 4250
$Sheet
S 2500 3550 650  3150
U 5EC57429
F0 "Control Logic" 50
F1 "IR.sch" 50
F2 "BUS0" I R 3150 5200 50 
F3 "BUS1" I R 3150 5300 50 
F4 "BUS2" I R 3150 5400 50 
F5 "BUS3" I R 3150 5500 50 
F6 "BUS4" I R 3150 5600 50 
F7 "BUS5" I R 3150 5700 50 
F8 "CO" O L 2500 4850 50 
F9 "CI" O L 2500 4750 50 
F10 "HI" O L 2500 5200 50 
F11 "~AI" O R 3150 6150 50 
F12 "~AO" O R 3150 6050 50 
F13 "~BI" O R 3150 4000 50 
F14 "~BO" O R 3150 3900 50 
F15 "MI" O L 2500 6150 50 
F16 "~EO" O L 2500 4250 50 
F17 "ES" O L 2500 4350 50 
F18 "EC" O L 2500 4450 50 
F19 "RI" O L 2500 6500 50 
F20 "~RO" O L 2500 6600 50 
F21 "CE" O L 2500 4950 50 
F22 "FLAG_C" I R 3150 6500 50 
F23 "FLAG_N" I R 3150 6400 50 
F24 "FLAG_Z" I R 3150 6600 50 
F25 "~HI" O L 2500 5300 50 
F26 "TI" O R 3150 3650 50 
F27 "TO" O R 3150 3750 50 
F28 "ME" O L 2500 6050 50 
$EndSheet
$Comp
L power:+5V #PWR05
U 1 1 5ED8FF17
P 4650 8200
F 0 "#PWR05" H 4650 8050 50  0001 C CNN
F 1 "+5V" V 4650 8400 50  0000 C CNN
F 2 "" H 4650 8200 50  0001 C CNN
F 3 "" H 4650 8200 50  0001 C CNN
	1    4650 8200
	0    1    1    0   
$EndComp
$Comp
L Device:CP_Small C1
U 1 1 600A41D4
P 1800 9400
AR Path="/600A41D4" Ref="C1"  Part="1" 
AR Path="/6026EA31/600A41D4" Ref="C?"  Part="1" 
F 0 "C1" H 1700 9550 50  0000 L CNN
F 1 "47µF" H 1700 9250 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 1838 9250 50  0001 C CNN
F 3 "~" H 1800 9400 50  0001 C CNN
	1    1800 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41DA
P 1950 9400
AR Path="/5F645851/600A41DA" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41DA" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41DA" Ref="C?"  Part="1" 
AR Path="/600A41DA" Ref="C2"  Part="1" 
AR Path="/6026EA31/600A41DA" Ref="C?"  Part="1" 
F 0 "C2" H 1900 9550 50  0000 L CNN
F 1 "100nF" H 1850 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 1950 9400 50  0001 C CNN
F 3 "~" H 1950 9400 50  0001 C CNN
	1    1950 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41E0
P 2100 9400
AR Path="/5F645851/600A41E0" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41E0" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41E0" Ref="C?"  Part="1" 
AR Path="/600A41E0" Ref="C3"  Part="1" 
AR Path="/6026EA31/600A41E0" Ref="C?"  Part="1" 
F 0 "C3" H 2050 9550 50  0000 L CNN
F 1 "100nF" H 2000 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2100 9400 50  0001 C CNN
F 3 "~" H 2100 9400 50  0001 C CNN
	1    2100 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41E6
P 2250 9400
AR Path="/5F645851/600A41E6" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41E6" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41E6" Ref="C?"  Part="1" 
AR Path="/600A41E6" Ref="C4"  Part="1" 
AR Path="/6026EA31/600A41E6" Ref="C?"  Part="1" 
F 0 "C4" H 2200 9550 50  0000 L CNN
F 1 "100nF" H 2150 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2250 9400 50  0001 C CNN
F 3 "~" H 2250 9400 50  0001 C CNN
	1    2250 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41EC
P 2400 9400
AR Path="/5F645851/600A41EC" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41EC" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41EC" Ref="C?"  Part="1" 
AR Path="/600A41EC" Ref="C5"  Part="1" 
AR Path="/6026EA31/600A41EC" Ref="C?"  Part="1" 
F 0 "C5" H 2350 9550 50  0000 L CNN
F 1 "100nF" H 2300 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2400 9400 50  0001 C CNN
F 3 "~" H 2400 9400 50  0001 C CNN
	1    2400 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41F2
P 2550 9400
AR Path="/5F645851/600A41F2" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41F2" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41F2" Ref="C?"  Part="1" 
AR Path="/600A41F2" Ref="C6"  Part="1" 
AR Path="/6026EA31/600A41F2" Ref="C?"  Part="1" 
F 0 "C6" H 2500 9550 50  0000 L CNN
F 1 "100nF" H 2450 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2550 9400 50  0001 C CNN
F 3 "~" H 2550 9400 50  0001 C CNN
	1    2550 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41F8
P 2700 9400
AR Path="/5F645851/600A41F8" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41F8" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41F8" Ref="C?"  Part="1" 
AR Path="/600A41F8" Ref="C7"  Part="1" 
AR Path="/6026EA31/600A41F8" Ref="C?"  Part="1" 
F 0 "C7" H 2650 9550 50  0000 L CNN
F 1 "100nF" H 2600 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2700 9400 50  0001 C CNN
F 3 "~" H 2700 9400 50  0001 C CNN
	1    2700 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A41FE
P 2850 9400
AR Path="/5F645851/600A41FE" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A41FE" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A41FE" Ref="C?"  Part="1" 
AR Path="/600A41FE" Ref="C8"  Part="1" 
AR Path="/6026EA31/600A41FE" Ref="C?"  Part="1" 
F 0 "C8" H 2800 9550 50  0000 L CNN
F 1 "100nF" H 2750 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 2850 9400 50  0001 C CNN
F 3 "~" H 2850 9400 50  0001 C CNN
	1    2850 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4204
P 3000 9400
AR Path="/5F645851/600A4204" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4204" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4204" Ref="C?"  Part="1" 
AR Path="/600A4204" Ref="C9"  Part="1" 
AR Path="/6026EA31/600A4204" Ref="C?"  Part="1" 
F 0 "C9" H 2950 9550 50  0000 L CNN
F 1 "100nF" H 2900 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3000 9400 50  0001 C CNN
F 3 "~" H 3000 9400 50  0001 C CNN
	1    3000 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A420A
P 3150 9400
AR Path="/5F645851/600A420A" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A420A" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A420A" Ref="C?"  Part="1" 
AR Path="/600A420A" Ref="C10"  Part="1" 
AR Path="/6026EA31/600A420A" Ref="C?"  Part="1" 
F 0 "C10" H 3100 9550 50  0000 L CNN
F 1 "100nF" H 3050 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3150 9400 50  0001 C CNN
F 3 "~" H 3150 9400 50  0001 C CNN
	1    3150 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4210
P 3300 9400
AR Path="/5F645851/600A4210" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4210" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4210" Ref="C?"  Part="1" 
AR Path="/600A4210" Ref="C11"  Part="1" 
AR Path="/6026EA31/600A4210" Ref="C?"  Part="1" 
F 0 "C11" H 3250 9550 50  0000 L CNN
F 1 "100nF" H 3200 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3300 9400 50  0001 C CNN
F 3 "~" H 3300 9400 50  0001 C CNN
	1    3300 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4216
P 3450 9400
AR Path="/5F645851/600A4216" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4216" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4216" Ref="C?"  Part="1" 
AR Path="/600A4216" Ref="C12"  Part="1" 
AR Path="/6026EA31/600A4216" Ref="C?"  Part="1" 
F 0 "C12" H 3400 9550 50  0000 L CNN
F 1 "100nF" H 3350 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3450 9400 50  0001 C CNN
F 3 "~" H 3450 9400 50  0001 C CNN
	1    3450 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A421C
P 3600 9400
AR Path="/5F645851/600A421C" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A421C" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A421C" Ref="C?"  Part="1" 
AR Path="/600A421C" Ref="C13"  Part="1" 
AR Path="/6026EA31/600A421C" Ref="C?"  Part="1" 
F 0 "C13" H 3550 9550 50  0000 L CNN
F 1 "100nF" H 3500 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3600 9400 50  0001 C CNN
F 3 "~" H 3600 9400 50  0001 C CNN
	1    3600 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4222
P 3750 9400
AR Path="/5F645851/600A4222" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4222" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4222" Ref="C?"  Part="1" 
AR Path="/600A4222" Ref="C14"  Part="1" 
AR Path="/6026EA31/600A4222" Ref="C?"  Part="1" 
F 0 "C14" H 3700 9550 50  0000 L CNN
F 1 "100nF" H 3650 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3750 9400 50  0001 C CNN
F 3 "~" H 3750 9400 50  0001 C CNN
	1    3750 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A422E
P 3900 9400
AR Path="/5F645851/600A422E" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A422E" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A422E" Ref="C?"  Part="1" 
AR Path="/600A422E" Ref="C15"  Part="1" 
AR Path="/6026EA31/600A422E" Ref="C?"  Part="1" 
F 0 "C15" H 3850 9550 50  0000 L CNN
F 1 "100nF" H 3800 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 3900 9400 50  0001 C CNN
F 3 "~" H 3900 9400 50  0001 C CNN
	1    3900 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4234
P 4050 9400
AR Path="/5F645851/600A4234" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4234" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4234" Ref="C?"  Part="1" 
AR Path="/600A4234" Ref="C16"  Part="1" 
AR Path="/6026EA31/600A4234" Ref="C?"  Part="1" 
F 0 "C16" H 4000 9550 50  0000 L CNN
F 1 "100nF" H 3950 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4050 9400 50  0001 C CNN
F 3 "~" H 4050 9400 50  0001 C CNN
	1    4050 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A423A
P 4200 9400
AR Path="/5F645851/600A423A" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A423A" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A423A" Ref="C?"  Part="1" 
AR Path="/600A423A" Ref="C17"  Part="1" 
AR Path="/6026EA31/600A423A" Ref="C?"  Part="1" 
F 0 "C17" H 4150 9550 50  0000 L CNN
F 1 "100nF" H 4100 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4200 9400 50  0001 C CNN
F 3 "~" H 4200 9400 50  0001 C CNN
	1    4200 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4240
P 4350 9400
AR Path="/5F645851/600A4240" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4240" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4240" Ref="C?"  Part="1" 
AR Path="/600A4240" Ref="C18"  Part="1" 
AR Path="/6026EA31/600A4240" Ref="C?"  Part="1" 
F 0 "C18" H 4300 9550 50  0000 L CNN
F 1 "100nF" H 4250 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4350 9400 50  0001 C CNN
F 3 "~" H 4350 9400 50  0001 C CNN
	1    4350 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 600A4246
P 4500 9400
AR Path="/5F645851/600A4246" Ref="C?"  Part="1" 
AR Path="/5F64487D/600A4246" Ref="C?"  Part="1" 
AR Path="/5EC57456/600A4246" Ref="C?"  Part="1" 
AR Path="/600A4246" Ref="C19"  Part="1" 
AR Path="/6026EA31/600A4246" Ref="C?"  Part="1" 
F 0 "C19" H 4450 9550 50  0000 L CNN
F 1 "100nF" H 4400 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4500 9400 50  0001 C CNN
F 3 "~" H 4500 9400 50  0001 C CNN
	1    4500 9400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 9300 1950 9300
Connection ~ 1950 9300
Wire Wire Line
	1950 9300 2100 9300
Connection ~ 2100 9300
Wire Wire Line
	2100 9300 2250 9300
Connection ~ 2250 9300
Wire Wire Line
	2250 9300 2400 9300
Connection ~ 2400 9300
Wire Wire Line
	2400 9300 2550 9300
Connection ~ 2550 9300
Wire Wire Line
	2550 9300 2700 9300
Connection ~ 2700 9300
Wire Wire Line
	2700 9300 2850 9300
Connection ~ 2850 9300
Wire Wire Line
	2850 9300 3000 9300
Connection ~ 3000 9300
Wire Wire Line
	3000 9300 3150 9300
Connection ~ 3150 9300
Wire Wire Line
	3150 9300 3300 9300
Connection ~ 3300 9300
Wire Wire Line
	3300 9300 3450 9300
Connection ~ 3450 9300
Wire Wire Line
	3450 9300 3600 9300
Connection ~ 3600 9300
Wire Wire Line
	3600 9300 3750 9300
Connection ~ 3750 9300
Connection ~ 3900 9300
Wire Wire Line
	3900 9300 4050 9300
Connection ~ 4050 9300
Wire Wire Line
	4050 9300 4200 9300
Connection ~ 4200 9300
Wire Wire Line
	4200 9300 4350 9300
Connection ~ 4350 9300
Wire Wire Line
	4350 9300 4500 9300
Connection ~ 4500 9300
Wire Wire Line
	1800 9500 1950 9500
Connection ~ 1950 9500
Wire Wire Line
	1950 9500 2100 9500
Connection ~ 2100 9500
Wire Wire Line
	2100 9500 2250 9500
Connection ~ 2250 9500
Wire Wire Line
	2250 9500 2400 9500
Connection ~ 2400 9500
Wire Wire Line
	2400 9500 2550 9500
Connection ~ 2550 9500
Wire Wire Line
	2550 9500 2700 9500
Connection ~ 2700 9500
Wire Wire Line
	2700 9500 2850 9500
Connection ~ 2850 9500
Wire Wire Line
	2850 9500 3000 9500
Connection ~ 3000 9500
Wire Wire Line
	3000 9500 3150 9500
Connection ~ 3150 9500
Wire Wire Line
	3150 9500 3300 9500
Connection ~ 3300 9500
Wire Wire Line
	3300 9500 3450 9500
Connection ~ 3450 9500
Wire Wire Line
	3450 9500 3600 9500
Connection ~ 3600 9500
Wire Wire Line
	3600 9500 3750 9500
Connection ~ 3750 9500
Connection ~ 3900 9500
Wire Wire Line
	3900 9500 4050 9500
Connection ~ 4050 9500
Wire Wire Line
	4050 9500 4200 9500
Connection ~ 4200 9500
Wire Wire Line
	4200 9500 4350 9500
Connection ~ 4350 9500
Wire Wire Line
	4350 9500 4500 9500
Connection ~ 4500 9500
$Comp
L power:GND #PWR014
U 1 1 600A42A2
P 6900 9500
AR Path="/600A42A2" Ref="#PWR014"  Part="1" 
AR Path="/6026EA31/600A42A2" Ref="#PWR?"  Part="1" 
F 0 "#PWR014" H 6900 9250 50  0001 C CNN
F 1 "GND" H 7100 9400 50  0000 R CNN
F 2 "" H 6900 9500 50  0001 C CNN
F 3 "" H 6900 9500 50  0001 C CNN
	1    6900 9500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR013
U 1 1 600A42A8
P 6900 9300
AR Path="/600A42A8" Ref="#PWR013"  Part="1" 
AR Path="/6026EA31/600A42A8" Ref="#PWR?"  Part="1" 
F 0 "#PWR013" H 6900 9150 50  0001 C CNN
F 1 "+5V" H 6950 9400 50  0000 L CNN
F 2 "" H 6900 9300 50  0001 C CNN
F 3 "" H 6900 9300 50  0001 C CNN
	1    6900 9300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 7100 2500 7100
Wire Wire Line
	2350 7200 2500 7200
Wire Wire Line
	2250 7350 2500 7350
Wire Wire Line
	2200 7450 2500 7450
Wire Wire Line
	6100 7100 5750 7100
Wire Wire Line
	6100 7100 6100 8550
Wire Wire Line
	5750 7200 6050 7200
Wire Wire Line
	6050 7200 6050 8500
Wire Wire Line
	6000 7300 5750 7300
Wire Wire Line
	6000 7300 6000 8450
Wire Wire Line
	5850 7800 5750 7800
Wire Wire Line
	5900 7700 5750 7700
Wire Wire Line
	6200 6400 3150 6400
Wire Wire Line
	6200 6500 3150 6500
Wire Wire Line
	6200 6600 3150 6600
Connection ~ 3950 4950
Wire Wire Line
	3950 4950 3950 5900
Connection ~ 4050 4850
Wire Wire Line
	4050 4850 4050 5800
Connection ~ 4150 4750
Wire Wire Line
	4150 4750 4150 5700
Connection ~ 4250 4650
Wire Wire Line
	4250 4650 4250 5600
Connection ~ 4350 4550
Wire Wire Line
	4350 4550 4350 5500
Connection ~ 4450 4450
Wire Wire Line
	4450 4450 4450 5400
Connection ~ 4550 4350
Wire Wire Line
	4550 4350 4550 5300
Connection ~ 4650 4250
Wire Wire Line
	4650 4250 4650 5200
Wire Wire Line
	4650 3050 4650 4250
Wire Wire Line
	4550 3150 4550 4350
Wire Wire Line
	4450 3250 4450 4450
Wire Wire Line
	4350 3350 4350 4550
Wire Wire Line
	4250 3450 4250 4650
Wire Wire Line
	4150 3550 4150 4750
Wire Wire Line
	4050 3650 4050 4850
Wire Wire Line
	3950 3750 3950 4950
Text Notes 3050 8200 0    50   ~ 0
Bus is tied to $ff if\nnot driven actively.
Wire Wire Line
	1850 1800 2500 1800
Wire Wire Line
	1650 7600 2500 7600
$Comp
L Device:C_Small C?
U 1 1 6060F16D
P 4650 9400
AR Path="/5F645851/6060F16D" Ref="C?"  Part="1" 
AR Path="/5F64487D/6060F16D" Ref="C?"  Part="1" 
AR Path="/5EC57456/6060F16D" Ref="C?"  Part="1" 
AR Path="/6060F16D" Ref="C20"  Part="1" 
AR Path="/6026EA31/6060F16D" Ref="C?"  Part="1" 
F 0 "C20" H 4600 9550 50  0000 L CNN
F 1 "100nF" H 4550 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4650 9400 50  0001 C CNN
F 3 "~" H 4650 9400 50  0001 C CNN
	1    4650 9400
	1    0    0    -1  
$EndComp
Connection ~ 4650 9300
Wire Wire Line
	4650 9300 4800 9300
Connection ~ 4650 9500
Wire Wire Line
	4650 9500 4800 9500
$Comp
L Device:C_Small C?
U 1 1 6060F41A
P 4800 9400
AR Path="/5F645851/6060F41A" Ref="C?"  Part="1" 
AR Path="/5F64487D/6060F41A" Ref="C?"  Part="1" 
AR Path="/5EC57456/6060F41A" Ref="C?"  Part="1" 
AR Path="/6060F41A" Ref="C21"  Part="1" 
AR Path="/6026EA31/6060F41A" Ref="C?"  Part="1" 
F 0 "C21" H 4750 9550 50  0000 L CNN
F 1 "100nF" H 4700 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4800 9400 50  0001 C CNN
F 3 "~" H 4800 9400 50  0001 C CNN
	1    4800 9400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 9300 3900 9300
Wire Wire Line
	3750 9500 3900 9500
$Comp
L Device:C_Small C?
U 1 1 6059C132
P 4950 9400
AR Path="/5F645851/6059C132" Ref="C?"  Part="1" 
AR Path="/5F64487D/6059C132" Ref="C?"  Part="1" 
AR Path="/5EC57456/6059C132" Ref="C?"  Part="1" 
AR Path="/6059C132" Ref="C22"  Part="1" 
AR Path="/6026EA31/6059C132" Ref="C?"  Part="1" 
F 0 "C22" H 4900 9550 50  0000 L CNN
F 1 "100nF" H 4850 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 4950 9400 50  0001 C CNN
F 3 "~" H 4950 9400 50  0001 C CNN
	1    4950 9400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 9300 4950 9300
Connection ~ 4800 9300
Wire Wire Line
	4800 9500 4950 9500
Connection ~ 4800 9500
Wire Wire Line
	4500 9300 4650 9300
Wire Wire Line
	4500 9500 4650 9500
$Comp
L Device:C_Small C?
U 1 1 6092F5EE
P 5100 9400
AR Path="/5F645851/6092F5EE" Ref="C?"  Part="1" 
AR Path="/5F64487D/6092F5EE" Ref="C?"  Part="1" 
AR Path="/5EC57456/6092F5EE" Ref="C?"  Part="1" 
AR Path="/6092F5EE" Ref="C23"  Part="1" 
AR Path="/6026EA31/6092F5EE" Ref="C?"  Part="1" 
F 0 "C23" H 5050 9550 50  0000 L CNN
F 1 "100nF" H 5000 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5100 9400 50  0001 C CNN
F 3 "~" H 5100 9400 50  0001 C CNN
	1    5100 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 6092F9C9
P 5250 9400
AR Path="/5F645851/6092F9C9" Ref="C?"  Part="1" 
AR Path="/5F64487D/6092F9C9" Ref="C?"  Part="1" 
AR Path="/5EC57456/6092F9C9" Ref="C?"  Part="1" 
AR Path="/6092F9C9" Ref="C24"  Part="1" 
AR Path="/6026EA31/6092F9C9" Ref="C?"  Part="1" 
F 0 "C24" H 5200 9550 50  0000 L CNN
F 1 "100nF" H 5150 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5250 9400 50  0001 C CNN
F 3 "~" H 5250 9400 50  0001 C CNN
	1    5250 9400
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 6092FC42
P 5400 9400
AR Path="/5F645851/6092FC42" Ref="C?"  Part="1" 
AR Path="/5F64487D/6092FC42" Ref="C?"  Part="1" 
AR Path="/5EC57456/6092FC42" Ref="C?"  Part="1" 
AR Path="/6092FC42" Ref="C25"  Part="1" 
AR Path="/6026EA31/6092FC42" Ref="C?"  Part="1" 
F 0 "C25" H 5350 9550 50  0000 L CNN
F 1 "100nF" H 5300 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5400 9400 50  0001 C CNN
F 3 "~" H 5400 9400 50  0001 C CNN
	1    5400 9400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 9300 5100 9300
Connection ~ 4950 9300
Connection ~ 5100 9300
Wire Wire Line
	5100 9300 5250 9300
Connection ~ 5250 9300
Wire Wire Line
	5250 9300 5400 9300
Wire Wire Line
	5400 9300 5550 9300
Wire Wire Line
	4950 9500 5100 9500
Connection ~ 4950 9500
Connection ~ 5100 9500
Wire Wire Line
	5100 9500 5250 9500
Connection ~ 5250 9500
Wire Wire Line
	5250 9500 5400 9500
Wire Wire Line
	5400 9500 5550 9500
Wire Wire Line
	2350 2300 2500 2300
Connection ~ 1650 7600
Wire Wire Line
	1650 7600 1650 8650
$Sheet
S 5100 850  1750 1050
U 60B12F32
F0 "Clock and Reset" 50
F1 "ClockAndReset.sch" 50
$EndSheet
$Comp
L Mechanical:MountingHole H1
U 1 1 607422A4
P 750 10850
F 0 "H1" H 700 11000 50  0000 L CNN
F 1 "M2" H 700 10700 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 750 10850 50  0001 C CNN
F 3 "~" H 750 10850 50  0001 C CNN
	1    750  10850
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 60742DC1
P 950 10850
F 0 "H2" H 900 11000 50  0000 L CNN
F 1 "M2" H 900 10700 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 950 10850 50  0001 C CNN
F 3 "~" H 950 10850 50  0001 C CNN
	1    950  10850
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 60742F96
P 1150 10850
F 0 "H3" H 1100 11000 50  0000 L CNN
F 1 "M2" H 1100 10700 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 1150 10850 50  0001 C CNN
F 3 "~" H 1150 10850 50  0001 C CNN
	1    1150 10850
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 60743138
P 1350 10850
F 0 "H4" H 1300 11000 50  0000 L CNN
F 1 "M2" H 1300 10700 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.2mm_M2" H 1350 10850 50  0001 C CNN
F 3 "~" H 1350 10850 50  0001 C CNN
	1    1350 10850
	1    0    0    -1  
$EndComp
Connection ~ 5400 9300
Connection ~ 5400 9500
$Comp
L Device:C_Small C?
U 1 1 607DBBB8
P 5550 9400
AR Path="/5F645851/607DBBB8" Ref="C?"  Part="1" 
AR Path="/5F64487D/607DBBB8" Ref="C?"  Part="1" 
AR Path="/5EC57456/607DBBB8" Ref="C?"  Part="1" 
AR Path="/607DBBB8" Ref="C29"  Part="1" 
AR Path="/6026EA31/607DBBB8" Ref="C?"  Part="1" 
F 0 "C29" H 5500 9550 50  0000 L CNN
F 1 "100nF" H 5450 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5550 9400 50  0001 C CNN
F 3 "~" H 5550 9400 50  0001 C CNN
	1    5550 9400
	1    0    0    -1  
$EndComp
Connection ~ 5550 9300
Wire Wire Line
	5550 9300 5700 9300
Connection ~ 5550 9500
Wire Wire Line
	5550 9500 5700 9500
$Comp
L Device:C_Small C?
U 1 1 607DBEDB
P 5700 9400
AR Path="/5F645851/607DBEDB" Ref="C?"  Part="1" 
AR Path="/5F64487D/607DBEDB" Ref="C?"  Part="1" 
AR Path="/5EC57456/607DBEDB" Ref="C?"  Part="1" 
AR Path="/607DBEDB" Ref="C30"  Part="1" 
AR Path="/6026EA31/607DBEDB" Ref="C?"  Part="1" 
F 0 "C30" H 5650 9550 50  0000 L CNN
F 1 "100nF" H 5600 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5700 9400 50  0001 C CNN
F 3 "~" H 5700 9400 50  0001 C CNN
	1    5700 9400
	1    0    0    -1  
$EndComp
Connection ~ 5700 9300
Connection ~ 5700 9500
Wire Wire Line
	5700 9500 5850 9500
Wire Wire Line
	5700 9300 5850 9300
$Comp
L Device:C_Small C?
U 1 1 607DC250
P 5850 9400
AR Path="/5F645851/607DC250" Ref="C?"  Part="1" 
AR Path="/5F64487D/607DC250" Ref="C?"  Part="1" 
AR Path="/5EC57456/607DC250" Ref="C?"  Part="1" 
AR Path="/607DC250" Ref="C31"  Part="1" 
AR Path="/6026EA31/607DC250" Ref="C?"  Part="1" 
F 0 "C31" H 5800 9550 50  0000 L CNN
F 1 "100nF" H 5750 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 5850 9400 50  0001 C CNN
F 3 "~" H 5850 9400 50  0001 C CNN
	1    5850 9400
	1    0    0    -1  
$EndComp
Connection ~ 5850 9300
Wire Wire Line
	5850 9300 6000 9300
Connection ~ 5850 9500
Wire Wire Line
	5850 9500 6000 9500
$Comp
L Device:C_Small C?
U 1 1 607DC46B
P 6000 9400
AR Path="/5F645851/607DC46B" Ref="C?"  Part="1" 
AR Path="/5F64487D/607DC46B" Ref="C?"  Part="1" 
AR Path="/5EC57456/607DC46B" Ref="C?"  Part="1" 
AR Path="/607DC46B" Ref="C32"  Part="1" 
AR Path="/6026EA31/607DC46B" Ref="C?"  Part="1" 
F 0 "C32" H 5950 9550 50  0000 L CNN
F 1 "100nF" H 5900 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6000 9400 50  0001 C CNN
F 3 "~" H 6000 9400 50  0001 C CNN
	1    6000 9400
	1    0    0    -1  
$EndComp
Connection ~ 6000 9300
Wire Wire Line
	6000 9300 6150 9300
Connection ~ 6000 9500
Wire Wire Line
	6000 9500 6150 9500
$Comp
L Device:C_Small C?
U 1 1 607DC695
P 6150 9400
AR Path="/5F645851/607DC695" Ref="C?"  Part="1" 
AR Path="/5F64487D/607DC695" Ref="C?"  Part="1" 
AR Path="/5EC57456/607DC695" Ref="C?"  Part="1" 
AR Path="/607DC695" Ref="C33"  Part="1" 
AR Path="/6026EA31/607DC695" Ref="C?"  Part="1" 
F 0 "C33" H 6100 9550 50  0000 L CNN
F 1 "100nF" H 6050 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6150 9400 50  0001 C CNN
F 3 "~" H 6150 9400 50  0001 C CNN
	1    6150 9400
	1    0    0    -1  
$EndComp
Connection ~ 6150 9300
Wire Wire Line
	6150 9300 6300 9300
Connection ~ 6150 9500
Wire Wire Line
	6150 9500 6300 9500
$Comp
L Device:C_Small C?
U 1 1 60841A33
P 6300 9400
AR Path="/5F645851/60841A33" Ref="C?"  Part="1" 
AR Path="/5F64487D/60841A33" Ref="C?"  Part="1" 
AR Path="/5EC57456/60841A33" Ref="C?"  Part="1" 
AR Path="/60841A33" Ref="C34"  Part="1" 
AR Path="/6026EA31/60841A33" Ref="C?"  Part="1" 
F 0 "C34" H 6250 9550 50  0000 L CNN
F 1 "100nF" H 6200 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6300 9400 50  0001 C CNN
F 3 "~" H 6300 9400 50  0001 C CNN
	1    6300 9400
	1    0    0    -1  
$EndComp
Connection ~ 6300 9300
Wire Wire Line
	6300 9300 6450 9300
Connection ~ 6300 9500
Wire Wire Line
	6300 9500 6450 9500
$Comp
L Device:C_Small C?
U 1 1 60841C63
P 6450 9400
AR Path="/5F645851/60841C63" Ref="C?"  Part="1" 
AR Path="/5F64487D/60841C63" Ref="C?"  Part="1" 
AR Path="/5EC57456/60841C63" Ref="C?"  Part="1" 
AR Path="/60841C63" Ref="C35"  Part="1" 
AR Path="/6026EA31/60841C63" Ref="C?"  Part="1" 
F 0 "C35" H 6400 9550 50  0000 L CNN
F 1 "100nF" H 6350 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6450 9400 50  0001 C CNN
F 3 "~" H 6450 9400 50  0001 C CNN
	1    6450 9400
	1    0    0    -1  
$EndComp
Connection ~ 6450 9300
Wire Wire Line
	6450 9300 6600 9300
Connection ~ 6450 9500
Wire Wire Line
	6450 9500 6600 9500
$Comp
L Device:C_Small C?
U 1 1 6084B49D
P 6600 9400
AR Path="/5F645851/6084B49D" Ref="C?"  Part="1" 
AR Path="/5F64487D/6084B49D" Ref="C?"  Part="1" 
AR Path="/5EC57456/6084B49D" Ref="C?"  Part="1" 
AR Path="/6084B49D" Ref="C36"  Part="1" 
AR Path="/6026EA31/6084B49D" Ref="C?"  Part="1" 
F 0 "C36" H 6550 9550 50  0000 L CNN
F 1 "100nF" H 6500 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6600 9400 50  0001 C CNN
F 3 "~" H 6600 9400 50  0001 C CNN
	1    6600 9400
	1    0    0    -1  
$EndComp
Connection ~ 6600 9300
Wire Wire Line
	6600 9300 6750 9300
Connection ~ 6600 9500
Wire Wire Line
	6600 9500 6750 9500
$Comp
L Device:C_Small C?
U 1 1 609328A7
P 6750 9400
AR Path="/5F645851/609328A7" Ref="C?"  Part="1" 
AR Path="/5F64487D/609328A7" Ref="C?"  Part="1" 
AR Path="/5EC57456/609328A7" Ref="C?"  Part="1" 
AR Path="/609328A7" Ref="C37"  Part="1" 
AR Path="/6026EA31/609328A7" Ref="C?"  Part="1" 
F 0 "C37" H 6700 9550 50  0000 L CNN
F 1 "100nF" H 6650 9200 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P2.50mm" H 6750 9400 50  0001 C CNN
F 3 "~" H 6750 9400 50  0001 C CNN
	1    6750 9400
	1    0    0    -1  
$EndComp
Connection ~ 6750 9300
Wire Wire Line
	6750 9300 6900 9300
Connection ~ 6750 9500
Wire Wire Line
	6750 9500 6900 9500
Wire Wire Line
	3150 3650 3250 3650
Wire Wire Line
	3250 3650 3250 3150
Wire Wire Line
	3250 3150 3150 3150
Wire Wire Line
	3150 3750 3300 3750
Wire Wire Line
	3300 3750 3300 1800
Wire Wire Line
	3300 1800 3150 1800
$EndSCHEMATC
