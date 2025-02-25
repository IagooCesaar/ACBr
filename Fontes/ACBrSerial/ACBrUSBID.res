        ��  ��                  ~  0   ��
 A C B R U S B I D                 ; Encontre Vendors ID em:  https://www.usb.org/developers
;
; Tipos de Equipamentos:
;    0-Diversos; 1-Impressora POS, 2-Impressoras Etiquetas, 3- SAT/MFE
;
; Protocolos ACBrPosPrinter
;    0-ppTexto, 1-ppEscPosEpson, 2-ppEscBematech, 3-ppEscDaruma, 4-ppEscVox,
;    5-ppEscDiebold, 6-ppEscEpsonP2, 7-ppCustomPos, 8-ppEscPosStar,
;    9-ppEscZJiang, 10-ppEscGPrinter, 11-ppEscDatecs, 12-ppEscSunmi
;
; Protocolos Impressoras Etiquetas
;    0-etqNenhum, 1-etqPpla, 2-etqPplb, 3-etqZPLII, 4-etqEpl2        
;
; Protocolos SAT/MFE
;    0-satNenhum, 1-satDinamico_cdecl, 2-satDinamico_stdcall, 3-mfe_Integrador_XML
;
;VID(Hex)=Descricao
[Vendors]
0483=STMicroelectronics
04b8=Epson
0525=PLX Technology
067b=Prolific
0a5f=Zebra
0b1b=Bematech
0dd4=Custom
0fe6=Sospita
154f=Shandong New
1753=Gertec
1cbe=Texas Instruments
1c8a=Shin Heung
20d1=Dascom
23b8=Daruma
2d84=Zhuhai J-Speed
3036=Control iD
324f=Sunmi

;Seçao do VID (Fabricante), com todos os PIDs (Modelos)
;PID(Hex)=Descrição do Modelo; Tipo Equipamento; Protocolo ACBr
;Se não desejar usar a Descriçao Padrão do Fabricante, use ',' na Descriçao do PID
[0483]
5742=Tec Toy,Q4;1;10
5743=Tanca,TP-550;1;10

[04b8]
0202=USB Controller;0;1
0e03=TM-T20;1;1
0e27=TM-T20X;1;1

[0525]
a4a7=Tanca, TS-1000;3;2

[067b]
2303=USB-to-Serial Comm Port;0

[0a5f]
00d3=GC420t;2;0

[0b1b]
0003=MP-4200 TH;1;0
0006=MP-5100 TH;1;2
0007=MP-2800 TH;1;1

[0dd4]
018e=Q3X;1;7
818e=Q3X;1;7

[0fe6]
811e=Tanca, TP-650;1;10

[154f]
1000=Elgin, L42;2;0
1300=Sunmi, NT210;1;8

[1cbe]
0002=Dimep, D-Print 250;1;1

[1c8a]
3001=Sweda, SI-300S;1;1
3002=Sweda, SI-300S;1;1

[1753]
0b00=G250

[20d1]
0700=Elgin, L42 PRO;2;0
7007=Elgin, I7;1;1
7008=Elgin, I9;1;1

[2d84]
7589=Elgin, L42DT;2;0
71a9=Tanca, TLP-300;2;0

[23b8]
0005=DR800;1;3

[3036]
0001=Print iD;1;1

[324f]
00d2=NT312;1;12

