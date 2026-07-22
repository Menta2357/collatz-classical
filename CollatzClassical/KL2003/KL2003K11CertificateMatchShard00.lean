import CollatzClassical.KL2003.KL2003K11CertificateDataRouter
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace CollatzClassical.KL2003.K11CertificateMatch

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_0 : K11RowValid 0 := by
  change (1 : Rat) <= (647532569 / 100000000 : Rat) /\
    (1056009872904051000221031 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (11529707 / 2500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (321017511 / 50000000 : Rat) - (647532569 / 100000000 : Rat) /\
    (0 : Rat) < (1056009872904051000221031 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_1 : K11RowValid 1 := by
  change (1 : Rat) <= (141403089 / 50000000 : Rat) /\
    (461913604831 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (181678789 / 20000000 : Rat) - (141403089 / 50000000 : Rat) /\
    (0 : Rat) < (461913604831 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_2 : K11RowValid 2 := by
  change (1 : Rat) <= (11529707 / 2500000 : Rat) /\
    (15054631335090042985650779331 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (208853927 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (70403499 / 25000000 : Rat) - (11529707 / 2500000 : Rat) /\
    (0 : Rat) < (15054631335090042985650779331 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_3 : K11RowValid 3 := by
  change (1 : Rat) <= (465878247 / 100000000 : Rat) /\
    (3804157020910582240201 / 1284828180250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (470737733 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (550281 / 250000 : Rat) - (465878247 / 100000000 : Rat) /\
    (0 : Rat) < (3804157020910582240201 / 1284828180250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_4 : K11RowValid 4 := by
  change (1 : Rat) <= (550281 / 250000 : Rat) /\
    (1788575399 / 1284828180250000 : Rat) = (1600000000 / 5139312721 : Rat) * (707016983 / 100000000 : Rat) - (550281 / 250000 : Rat) /\
    (0 : Rat) < (1788575399 / 1284828180250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_5 : K11RowValid 5 := by
  change (1 : Rat) <= (666742391 / 100000000 : Rat) /\
    (43546150062934484009897547119 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (78432163 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (219618551 / 50000000 : Rat) - (666742391 / 100000000 : Rat) /\
    (0 : Rat) < (43546150062934484009897547119 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_6 : K11RowValid 6 := by
  change (1 : Rat) <= (181678789 / 20000000 : Rat) /\
    (2964877469764808446515199 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (303880419 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (916237119 / 100000000 : Rat) - (181678789 / 20000000 : Rat) /\
    (0 : Rat) < (2964877469764808446515199 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_7 : K11RowValid 7 := by
  change (1 : Rat) <= (20025891 / 12500000 : Rat) /\
    (65634340589 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (51459691 / 10000000 : Rat) - (20025891 / 12500000 : Rat) /\
    (0 : Rat) < (65634340589 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_8 : K11RowValid 8 := by
  change (1 : Rat) <= (38580913 / 4000000 : Rat) /\
    (1260395715947841399902355323 / 205572508840000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (179036359 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (6460067 / 1000000 : Rat) - (38580913 / 4000000 : Rat) /\
    (0 : Rat) < (1260395715947841399902355323 / 205572508840000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_9 : K11RowValid 9 := by
  change (1 : Rat) <= (122668669 / 20000000 : Rat) /\
    (14705019433256469766603 / 3778906412500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (27500271 / 5000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (70406331 / 12500000 : Rat) - (122668669 / 20000000 : Rat) /\
    (0 : Rat) < (14705019433256469766603 / 3778906412500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_10 : K11RowValid 10 := by
  change (1 : Rat) <= (208853927 / 100000000 : Rat) /\
    (680938094633 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (670853953 / 100000000 : Rat) - (208853927 / 100000000 : Rat) /\
    (0 : Rat) < (680938094633 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_11 : K11RowValid 11 := by
  change (1 : Rat) <= (142266387 / 50000000 : Rat) /\
    (18579765955093040262365006387 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (203440061 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (78618523 / 50000000 : Rat) - (142266387 / 50000000 : Rat) /\
    (0 : Rat) < (18579765955093040262365006387 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_12 : K11RowValid 12 := by
  change (1 : Rat) <= (14613251 / 2500000 : Rat) /\
    (954179956892052267974883 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1466247999 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (81567523 / 50000000 : Rat) - (14613251 / 2500000 : Rat) /\
    (0 : Rat) < (954179956892052267974883 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_13 : K11RowValid 13 := by
  change (1 : Rat) <= (113909901 / 50000000 : Rat) /\
    (371942849379 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (731773719 / 100000000 : Rat) - (113909901 / 50000000 : Rat) /\
    (0 : Rat) < (371942849379 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_14 : K11RowValid 14 := by
  change (1 : Rat) <= (470737733 / 50000000 : Rat) /\
    (24583185734358300590863633061 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (10104039 / 4000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (122668669 / 20000000 : Rat) - (470737733 / 50000000 : Rat) /\
    (0 : Rat) < (24583185734358300590863633061 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_15 : K11RowValid 15 := by
  change (1 : Rat) <= (769940297 / 100000000 : Rat) /\
    (1255018791886953844917843 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1241787791 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (244187283 / 50000000 : Rat) - (769940297 / 100000000 : Rat) /\
    (0 : Rat) < (1255018791886953844917843 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_16 : K11RowValid 16 := by
  change (1 : Rat) <= (5368079 / 3125000 : Rat) /\
    (17507967041 / 16060352253125000 : Rat) = (1600000000 / 5139312721 : Rat) * (137941271 / 25000000 : Rat) - (5368079 / 3125000 : Rat) /\
    (0 : Rat) < (17507967041 / 16060352253125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_17 : K11RowValid 17 := by
  change (1 : Rat) <= (424414293 / 100000000 : Rat) /\
    (3253971710672212905153983037 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (65961853 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (272498341 / 100000000 : Rat) - (424414293 / 100000000 : Rat) /\
    (0 : Rat) < (3253971710672212905153983037 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_18 : K11RowValid 18 := by
  change (1 : Rat) <= (707016983 / 100000000 : Rat) /\
    (3395126890112855130497 / 755781282500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (385054709 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (18700369 / 2500000 : Rat) - (707016983 / 100000000 : Rat) /\
    (0 : Rat) < (3395126890112855130497 / 755781282500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_19 : K11RowValid 19 := by
  change (1 : Rat) <= (341988419 / 100000000 : Rat) /\
    (1113398621901 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1098491591 / 100000000 : Rat) - (341988419 / 100000000 : Rat) /\
    (0 : Rat) < (1113398621901 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_20 : K11RowValid 20 := by
  change (1 : Rat) <= (493726171 / 100000000 : Rat) /\
    (32195513264896165135218985269 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (11128907 / 2000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (113909901 / 50000000 : Rat) - (493726171 / 100000000 : Rat) /\
    (0 : Rat) < (32195513264896165135218985269 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_21 : K11RowValid 21 := by
  change (1 : Rat) <= (565980423 / 100000000 : Rat) /\
    (1846984738212051732544611 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (440350177 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (371747491 / 100000000 : Rat) - (565980423 / 100000000 : Rat) /\
    (0 : Rat) < (1846984738212051732544611 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_22 : K11RowValid 22 := by
  change (1 : Rat) <= (78432163 / 50000000 : Rat) /\
    (254958554477 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (100771917 / 20000000 : Rat) - (78432163 / 50000000 : Rat) /\
    (0 : Rat) < (254958554477 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_23 : K11RowValid 23 := by
  change (1 : Rat) <= (284928663 / 25000000 : Rat) /\
    (148917974260791714420255274193 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (181752141 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (769940297 / 100000000 : Rat) - (284928663 / 25000000 : Rat) /\
    (0 : Rat) < (148917974260791714420255274193 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_24 : K11RowValid 24 := by
  change (1 : Rat) <= (380524133 / 50000000 : Rat) /\
    (2485435810603666794147357 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4422911 / 625000 : Rat) + (784931055601 / 1000000000000 : Rat) * (688893917 / 100000000 : Rat) - (380524133 / 50000000 : Rat) /\
    (0 : Rat) < (2485435810603666794147357 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_25 : K11RowValid 25 := by
  change (1 : Rat) <= (46724123 / 12500000 : Rat) /\
    (152488531317 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (1200650161 / 100000000 : Rat) - (46724123 / 12500000 : Rat) /\
    (0 : Rat) < (152488531317 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_26 : K11RowValid 26 := by
  change (1 : Rat) <= (303880419 / 50000000 : Rat) /\
    (39705507221162974903218513997 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (20643833 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (197738213 / 50000000 : Rat) - (303880419 / 50000000 : Rat) /\
    (0 : Rat) < (39705507221162974903218513997 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_27 : K11RowValid 27 := by
  change (1 : Rat) <= (24469801 / 5000000 : Rat) /\
    (798317745919630003755061 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (251245081 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (212093941 / 50000000 : Rat) - (24469801 / 5000000 : Rat) /\
    (0 : Rat) < (798317745919630003755061 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_28 : K11RowValid 28 := by
  change (1 : Rat) <= (200462121 / 50000000 : Rat) /\
    (654666058759 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1287797729 / 100000000 : Rat) - (200462121 / 50000000 : Rat) /\
    (0 : Rat) < (654666058759 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_29 : K11RowValid 29 := by
  change (1 : Rat) <= (22890123 / 4000000 : Rat) /\
    (74794675874347409970415670811 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (146395481 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (341988419 / 100000000 : Rat) - (22890123 / 4000000 : Rat) /\
    (0 : Rat) < (74794675874347409970415670811 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_30 : K11RowValid 30 := by
  change (1 : Rat) <= (51459691 / 10000000 : Rat) /\
    (1678283425850542819674319 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (837534361 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (323405839 / 100000000 : Rat) - (51459691 / 10000000 : Rat) /\
    (0 : Rat) < (1678283425850542819674319 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_31 : K11RowValid 31 := by
  change (1 : Rat) <= (393968733 / 100000000 : Rat) /\
    (1283616847507 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4943188 / 390625 : Rat) - (393968733 / 100000000 : Rat) /\
    (0 : Rat) < (1283616847507 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_32 : K11RowValid 32 := by
  change (1 : Rat) <= (711503301 / 100000000 : Rat) /\
    (46535595310015951735026194177 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (129772293 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (238525433 / 50000000 : Rat) - (711503301 / 100000000 : Rat) /\
    (0 : Rat) < (46535595310015951735026194177 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_33 : K11RowValid 33 := by
  change (1 : Rat) <= (527471077 / 50000000 : Rat) /\
    (1721992403112900818429969 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (29073449 / 2000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (383713489 / 50000000 : Rat) - (527471077 / 50000000 : Rat) /\
    (0 : Rat) < (1721992403112900818429969 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_34 : K11RowValid 34 := by
  change (1 : Rat) <= (179036359 / 100000000 : Rat) /\
    (581869777161 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (287538881 / 50000000 : Rat) - (179036359 / 100000000 : Rat) /\
    (0 : Rat) < (581869777161 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_35 : K11RowValid 35 := by
  change (1 : Rat) <= (31437329 / 2000000 : Rat) /\
    (102645358916462565622963925183 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (35278749 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (539160007 / 50000000 : Rat) - (31437329 / 2000000 : Rat) /\
    (0 : Rat) < (102645358916462565622963925183 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_36 : K11RowValid 36 := by
  change (1 : Rat) <= (212093941 / 50000000 : Rat) /\
    (345472071099391566926179 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (377755779 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (97646499 / 25000000 : Rat) - (212093941 / 50000000 : Rat) /\
    (0 : Rat) < (345472071099391566926179 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_37 : K11RowValid 37 := by
  change (1 : Rat) <= (45136579 / 20000000 : Rat) /\
    (8654286973 / 6046250260000000 : Rat) = (1600000000 / 5139312721 : Rat) * (362454909 / 50000000 : Rat) - (45136579 / 20000000 : Rat) /\
    (0 : Rat) < (8654286973 / 6046250260000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_38 : K11RowValid 38 := by
  change (1 : Rat) <= (27500271 / 5000000 : Rat) /\
    (21113532550938228470235497 / 6046250260000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (231109237 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1699121 / 500000 : Rat) - (27500271 / 5000000 : Rat) /\
    (0 : Rat) < (21113532550938228470235497 / 6046250260000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_39 : K11RowValid 39 := by
  change (1 : Rat) <= (467388189 / 100000000 : Rat) /\
    (763555667401361555387217 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (578787213 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (68162577 / 50000000 : Rat) - (467388189 / 100000000 : Rat) /\
    (0 : Rat) < (763555667401361555387217 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_40 : K11RowValid 40 := by
  change (1 : Rat) <= (367488183 / 100000000 : Rat) /\
    (1197490924057 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (590199341 / 50000000 : Rat) - (367488183 / 100000000 : Rat) /\
    (0 : Rat) < (1197490924057 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_41 : K11RowValid 41 := by
  change (1 : Rat) <= (429949563 / 50000000 : Rat) /\
    (112305735993302150879762840337 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (621987229 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (473608073 / 100000000 : Rat) - (429949563 / 50000000 : Rat) /\
    (0 : Rat) < (112305735993302150879762840337 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_42 : K11RowValid 42 := by
  change (1 : Rat) <= (670853953 / 100000000 : Rat) /\
    (437885739640065976793301 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1262920569 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (70751381 / 20000000 : Rat) - (670853953 / 100000000 : Rat) /\
    (0 : Rat) < (437885739640065976793301 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_43 : K11RowValid 43 := by
  change (1 : Rat) <= (12151181 / 5000000 : Rat) /\
    (39551526499 / 25696563605000000 : Rat) = (1600000000 / 5139312721 : Rat) * (780609483 / 100000000 : Rat) - (12151181 / 5000000 : Rat) /\
    (0 : Rat) < (39551526499 / 25696563605000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_44 : K11RowValid 44 := by
  change (1 : Rat) <= (773716511 / 100000000 : Rat) /\
    (25199740547464901497139182809 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (133281951 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (130124561 / 25000000 : Rat) - (773716511 / 100000000 : Rat) /\
    (0 : Rat) < (25199740547464901497139182809 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_45 : K11RowValid 45 := by
  change (1 : Rat) <= (2541267733 / 100000000 : Rat) /\
    (1037029862999676298506667 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (515510497 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (379138027 / 12500000 : Rat) - (2541267733 / 100000000 : Rat) /\
    (0 : Rat) < (1037029862999676298506667 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_46 : K11RowValid 46 := by
  change (1 : Rat) <= (203440061 / 100000000 : Rat) /\
    (39114216707 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (20420757 / 3125000 : Rat) - (203440061 / 100000000 : Rat) /\
    (0 : Rat) < (39114216707 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_47 : K11RowValid 47 := by
  change (1 : Rat) <= (680403789 / 100000000 : Rat) /\
    (5233568494379095654566806581 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (405297833 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (393968733 / 100000000 : Rat) - (680403789 / 100000000 : Rat) /\
    (0 : Rat) < (5233568494379095654566806581 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_48 : K11RowValid 48 := by
  change (1 : Rat) <= (437289547 / 100000000 : Rat) /\
    (714365630883252234247831 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (616016463 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (156388311 / 50000000 : Rat) - (437289547 / 100000000 : Rat) /\
    (0 : Rat) < (714365630883252234247831 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_49 : K11RowValid 49 := by
  change (1 : Rat) <= (93027563 / 50000000 : Rat) /\
    (302870471077 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (597622551 / 100000000 : Rat) - (93027563 / 50000000 : Rat) /\
    (0 : Rat) < (302870471077 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_50 : K11RowValid 50 := by
  change (1 : Rat) <= (1466247999 / 100000000 : Rat) /\
    (1915505088719865470610999289 / 205572508840000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (21932489 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (10034481 / 1000000 : Rat) - (1466247999 / 100000000 : Rat) /\
    (0 : Rat) < (1915505088719865470610999289 / 205572508840000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_51 : K11RowValid 51 := by
  change (1 : Rat) <= (256433613 / 10000000 : Rat) /\
    (1673318563132543787952719 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (628241083 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (603556239 / 20000000 : Rat) - (256433613 / 10000000 : Rat) /\
    (0 : Rat) < (1673318563132543787952719 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_52 : K11RowValid 52 := by
  change (1 : Rat) <= (68162577 / 50000000 : Rat) /\
    (221727757983 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (109471569 / 25000000 : Rat) - (68162577 / 50000000 : Rat) /\
    (0 : Rat) < (221727757983 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_53 : K11RowValid 53 := by
  change (1 : Rat) <= (1117748509 / 50000000 : Rat) /\
    (58384118113528644567044396887 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (11192591 / 6250000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (309893023 / 20000000 : Rat) - (1117748509 / 50000000 : Rat) /\
    (0 : Rat) < (58384118113528644567044396887 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_54 : K11RowValid 54 := by
  change (1 : Rat) <= (731773719 / 100000000 : Rat) /\
    (2390618455674186245883943 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (444842237 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (755841383 / 100000000 : Rat) - (731773719 / 100000000 : Rat) /\
    (0 : Rat) < (2390618455674186245883943 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_55 : K11RowValid 55 := by
  change (1 : Rat) <= (523226591 / 50000000 : Rat) /\
    (1707308235889 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1680641739 / 50000000 : Rat) - (523226591 / 50000000 : Rat) /\
    (0 : Rat) < (1707308235889 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_56 : K11RowValid 56 := by
  change (1 : Rat) <= (186036937 / 50000000 : Rat) /\
    (9700310751421613267153319181 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (63393229 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (41674149 / 20000000 : Rat) - (186036937 / 50000000 : Rat) /\
    (0 : Rat) < (9700310751421613267153319181 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_57 : K11RowValid 57 := by
  change (1 : Rat) <= (319961081 / 50000000 : Rat) /\
    (1043525111071493258927949 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1701644267 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (70169869 / 50000000 : Rat) - (319961081 / 50000000 : Rat) /\
    (0 : Rat) < (1043525111071493258927949 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_58 : K11RowValid 58 := by
  change (1 : Rat) <= (10104039 / 4000000 : Rat) /\
    (32921819881 / 20557250884000000 : Rat) = (1600000000 / 5139312721 : Rat) * (405686321 / 50000000 : Rat) - (10104039 / 4000000 : Rat) /\
    (0 : Rat) < (32921819881 / 20557250884000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_59 : K11RowValid 59 := by
  change (1 : Rat) <= (695850069 / 100000000 : Rat) /\
    (45382316607708627851982609957 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (8267143 / 6250000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (232685053 / 50000000 : Rat) - (695850069 / 100000000 : Rat) /\
    (0 : Rat) < (45382316607708627851982609957 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_60 : K11RowValid 60 := by
  change (1 : Rat) <= (613430203 / 20000000 : Rat) /\
    (2164143890962725576141 / 111144306250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (90572889 / 4000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (188090669 / 6250000 : Rat) - (613430203 / 20000000 : Rat) /\
    (0 : Rat) < (2164143890962725576141 / 111144306250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_61 : K11RowValid 61 := by
  change (1 : Rat) <= (65938111 / 50000000 : Rat) /\
    (215338989969 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (84719197 / 20000000 : Rat) - (65938111 / 50000000 : Rat) /\
    (0 : Rat) < (215338989969 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_62 : K11RowValid 62 := by
  change (1 : Rat) <= (1241787791 / 100000000 : Rat) /\
    (81057436963536761313500742093 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (15581463 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (424119397 / 50000000 : Rat) - (1241787791 / 100000000 : Rat) /\
    (0 : Rat) < (81057436963536761313500742093 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_63 : K11RowValid 63 := by
  change (1 : Rat) <= (414897063 / 100000000 : Rat) /\
    (1357305293939986292488757 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (258253881 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (426147317 / 100000000 : Rat) - (414897063 / 100000000 : Rat) /\
    (0 : Rat) < (1357305293939986292488757 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_64 : K11RowValid 64 := by
  change (1 : Rat) <= (156388311 / 50000000 : Rat) /\
    (510261995769 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1004661183 / 100000000 : Rat) - (156388311 / 50000000 : Rat) /\
    (0 : Rat) < (510261995769 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_65 : K11RowValid 65 := by
  change (1 : Rat) <= (466084247 / 100000000 : Rat) /\
    (3046886227877762859349121589 / 1027862544200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (398956693 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (12151181 / 5000000 : Rat) - (466084247 / 100000000 : Rat) /\
    (0 : Rat) < (3046886227877762859349121589 / 1027862544200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_66 : K11RowValid 66 := by
  change (1 : Rat) <= (137941271 / 25000000 : Rat) /\
    (899535616368415146778059 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1175433967 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (118368779 / 50000000 : Rat) - (137941271 / 25000000 : Rat) /\
    (0 : Rat) < (899535616368415146778059 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_67 : K11RowValid 67 := by
  change (1 : Rat) <= (4964373 / 3125000 : Rat) /\
    (16239311067 / 16060352253125000 : Rat) = (1600000000 / 5139312721 : Rat) * (510269631 / 100000000 : Rat) - (4964373 / 3125000 : Rat) /\
    (0 : Rat) < (16239311067 / 16060352253125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_68 : K11RowValid 68 := by
  change (1 : Rat) <= (634270023 / 20000000 : Rat) /\
    (413977492169437534507089093709 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (175085561 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2176850661 / 100000000 : Rat) - (634270023 / 20000000 : Rat) /\
    (0 : Rat) < (413977492169437534507089093709 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_69 : K11RowValid 69 := by
  change (1 : Rat) <= (759541697 / 100000000 : Rat) /\
    (2480596093733045017469161 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (352631943 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (268336041 / 100000000 : Rat) - (759541697 / 100000000 : Rat) /\
    (0 : Rat) < (2480596093733045017469161 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_70 : K11RowValid 70 := by
  change (1 : Rat) <= (65961853 / 50000000 : Rat) /\
    (215376367987 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (423748507 / 100000000 : Rat) - (65961853 / 50000000 : Rat) /\
    (0 : Rat) < (215376367987 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_71 : K11RowValid 71 := by
  change (1 : Rat) <= (475333323 / 50000000 : Rat) /\
    (62066247028087587076759083539 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (21541881 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (314052731 / 50000000 : Rat) - (475333323 / 50000000 : Rat) /\
    (0 : Rat) < (62066247028087587076759083539 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_72 : K11RowValid 72 := by
  change (1 : Rat) <= (814219873 / 100000000 : Rat) /\
    (2654313074719329943071953 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (421433049 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (703010193 / 100000000 : Rat) - (814219873 / 100000000 : Rat) /\
    (0 : Rat) < (2654313074719329943071953 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_73 : K11RowValid 73 := by
  change (1 : Rat) <= (39278487 / 12500000 : Rat) /\
    (128099266873 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (50466139 / 5000000 : Rat) - (39278487 / 12500000 : Rat) /\
    (0 : Rat) < (128099266873 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_74 : K11RowValid 74 := by
  change (1 : Rat) <= (385054709 / 100000000 : Rat) /\
    (25191259873717457461884614147 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (396104867 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (93027563 / 50000000 : Rat) - (385054709 / 100000000 : Rat) /\
    (0 : Rat) < (25191259873717457461884614147 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_75 : K11RowValid 75 := by
  change (1 : Rat) <= (307643727 / 50000000 : Rat) /\
    (1003707304090373830854687 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (13766823 / 1562500 : Rat) + (784931055601 / 1000000000000 : Rat) * (217207647 / 50000000 : Rat) - (307643727 / 50000000 : Rat) /\
    (0 : Rat) < (1003707304090373830854687 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_76 : K11RowValid 76 := by
  change (1 : Rat) <= (39584139 / 25000000 : Rat) /\
    (128887467781 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (101717699 / 20000000 : Rat) - (39584139 / 25000000 : Rat) /\
    (0 : Rat) < (128887467781 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_77 : K11RowValid 77 := by
  change (1 : Rat) <= (575988797 / 20000000 : Rat) /\
    (93995154748317648119561562269 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4002217 / 2500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (502942901 / 25000000 : Rat) - (575988797 / 20000000 : Rat) /\
    (0 : Rat) < (93995154748317648119561562269 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_78 : K11RowValid 78 := by
  change (1 : Rat) <= (1098491591 / 100000000 : Rat) /\
    (897208807495256747171649 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (106093691 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (265709569 / 25000000 : Rat) - (1098491591 / 100000000 : Rat) /\
    (0 : Rat) < (897208807495256747171649 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_79 : K11RowValid 79 := by
  change (1 : Rat) <= (206971443 / 100000000 : Rat) /\
    (673306373597 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (664807277 / 100000000 : Rat) - (206971443 / 100000000 : Rat) /\
    (0 : Rat) < (673306373597 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_80 : K11RowValid 80 := by
  change (1 : Rat) <= (188090669 / 6250000 : Rat) /\
    (392811814736589628796995766849 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (73115811 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2106897721 / 100000000 : Rat) - (188090669 / 6250000 : Rat) /\
    (0 : Rat) < (392811814736589628796995766849 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_81 : K11RowValid 81 := by
  change (1 : Rat) <= (606822683 / 100000000 : Rat) /\
    (494901862834950638783289 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (26744301 / 3125000 : Rat) + (784931055601 / 1000000000000 : Rat) * (108412409 / 25000000 : Rat) - (606822683 / 100000000 : Rat) /\
    (0 : Rat) < (494901862834950638783289 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_82 : K11RowValid 82 := by
  change (1 : Rat) <= (11128907 / 2000000 : Rat) /\
    (36348074053 / 10278625442000000 : Rat) = (1600000000 / 5139312721 : Rat) * (893671401 / 50000000 : Rat) - (11128907 / 2000000 : Rat) /\
    (0 : Rat) < (36348074053 / 10278625442000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_83 : K11RowValid 83 := by
  change (1 : Rat) <= (97698543 / 6250000 : Rat) /\
    (102040914457410045219279785879 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (36559599 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (523226591 / 50000000 : Rat) - (97698543 / 6250000 : Rat) /\
    (0 : Rat) < (102040914457410045219279785879 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_84 : K11RowValid 84 := by
  change (1 : Rat) <= (426147317 / 100000000 : Rat) /\
    (1390945901435906942736277 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (695448579 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (267076437 / 100000000 : Rat) - (426147317 / 100000000 : Rat) /\
    (0 : Rat) < (1390945901435906942736277 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_85 : K11RowValid 85 := by
  change (1 : Rat) <= (336615699 / 100000000 : Rat) /\
    (1097640993021 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (540617013 / 50000000 : Rat) - (336615699 / 100000000 : Rat) /\
    (0 : Rat) < (1097640993021 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_86 : K11RowValid 86 := by
  change (1 : Rat) <= (440350177 / 50000000 : Rat) /\
    (14366941948301899226864778297 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1296313 / 800000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (73772913 / 12500000 : Rat) - (440350177 / 50000000 : Rat) /\
    (0 : Rat) < (14366941948301899226864778297 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_87 : K11RowValid 87 := by
  change (1 : Rat) <= (2462452853 / 100000000 : Rat) /\
    (8036851869826463028272899 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (843988003 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2802410819 / 100000000 : Rat) - (2462452853 / 100000000 : Rat) /\
    (0 : Rat) < (8036851869826463028272899 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_88 : K11RowValid 88 := by
  change (1 : Rat) <= (120169457 / 50000000 : Rat) /\
    (391364237503 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (771986013 / 100000000 : Rat) - (120169457 / 50000000 : Rat) /\
    (0 : Rat) < (391364237503 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_89 : K11RowValid 89 := by
  change (1 : Rat) <= (529452269 / 50000000 : Rat) /\
    (138218072014435983443068089661 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (256972313 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (695850069 / 100000000 : Rat) - (529452269 / 50000000 : Rat) /\
    (0 : Rat) < (138218072014435983443068089661 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_90 : K11RowValid 90 := by
  change (1 : Rat) <= (100771917 / 20000000 : Rat) /\
    (822424253777846640412993 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (340690133 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (253394433 / 50000000 : Rat) - (100771917 / 20000000 : Rat) /\
    (0 : Rat) < (822424253777846640412993 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_91 : K11RowValid 91 := by
  change (1 : Rat) <= (242141287 / 100000000 : Rat) /\
    (790641588073 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (777775367 / 100000000 : Rat) - (242141287 / 100000000 : Rat) /\
    (0 : Rat) < (790641588073 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_92 : K11RowValid 92 := by
  change (1 : Rat) <= (67746123 / 25000000 : Rat) /\
    (17680041900718329792424272759 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (27451879 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (65938111 / 50000000 : Rat) - (67746123 / 25000000 : Rat) /\
    (0 : Rat) < (17680041900718329792424272759 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_93 : K11RowValid 93 := by
  change (1 : Rat) <= (143843203 / 25000000 : Rat) /\
    (375570579760986154135333 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1433847089 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (32863973 / 20000000 : Rat) - (143843203 / 25000000 : Rat) /\
    (0 : Rat) < (375570579760986154135333 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_94 : K11RowValid 94 := by
  change (1 : Rat) <= (181752141 / 100000000 : Rat) /\
    (591289714339 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (583801051 / 100000000 : Rat) - (181752141 / 100000000 : Rat) /\
    (0 : Rat) < (591289714339 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_95 : K11RowValid 95 := by
  change (1 : Rat) <= (162588117 / 25000000 : Rat) /\
    (84876525413919532562014559647 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (214202923 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (414897063 / 100000000 : Rat) - (162588117 / 25000000 : Rat) /\
    (0 : Rat) < (84876525413919532562014559647 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_96 : K11RowValid 96 := by
  change (1 : Rat) <= (382605799 / 50000000 : Rat) /\
    (2498950625705533181463001 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (547214201 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (540797081 / 100000000 : Rat) - (382605799 / 50000000 : Rat) /\
    (0 : Rat) < (2498950625705533181463001 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_97 : K11RowValid 97 := by
  change (1 : Rat) <= (8793177 / 6250000 : Rat) /\
    (28785895383 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (14122161 / 3125000 : Rat) - (8793177 / 6250000 : Rat) /\
    (0 : Rat) < (28785895383 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_98 : K11RowValid 98 := by
  change (1 : Rat) <= (4422911 / 625000 : Rat) /\
    (9220767065210321694541504223 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (113329033 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (45288167 / 10000000 : Rat) - (4422911 / 625000 : Rat) /\
    (0 : Rat) < (9220767065210321694541504223 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_99 : K11RowValid 99 := by
  change (1 : Rat) <= (185259059 / 25000000 : Rat) /\
    (483093797906458890524969 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (446353389 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (153408489 / 20000000 : Rat) - (185259059 / 25000000 : Rat) /\
    (0 : Rat) < (483093797906458890524969 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_100 : K11RowValid 100 := by
  change (1 : Rat) <= (490858591 / 100000000 : Rat) /\
    (1603861563889 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (788336689 / 50000000 : Rat) - (490858591 / 100000000 : Rat) /\
    (0 : Rat) < (1603861563889 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_101 : K11RowValid 101 := by
  change (1 : Rat) <= (370487823 / 100000000 : Rat) /\
    (12106329795920435393742244789 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (59275871 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (39603981 / 25000000 : Rat) - (370487823 / 100000000 : Rat) /\
    (0 : Rat) < (12106329795920435393742244789 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_102 : K11RowValid 102 := by
  change (1 : Rat) <= (1200650161 / 100000000 : Rat) /\
    (115346206465872584391113 / 15115625650000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (783990853 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (609336601 / 50000000 : Rat) - (1200650161 / 100000000 : Rat) /\
    (0 : Rat) < (115346206465872584391113 / 15115625650000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_103 : K11RowValid 103 := by
  change (1 : Rat) <= (146052769 / 100000000 : Rat) /\
    (477541025551 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (234566041 / 50000000 : Rat) - (146052769 / 100000000 : Rat) /\
    (0 : Rat) < (477541025551 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_104 : K11RowValid 104 := by
  change (1 : Rat) <= (277333919 / 25000000 : Rat) /\
    (144730400636550624708164997207 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (269713523 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (669190303 / 100000000 : Rat) - (277333919 / 25000000 : Rat) /\
    (0 : Rat) < (144730400636550624708164997207 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_105 : K11RowValid 105 := by
  change (1 : Rat) <= (786912723 / 100000000 : Rat) /\
    (2565374748688530165347921 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (252843531 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (801955601 / 100000000 : Rat) - (786912723 / 100000000 : Rat) /\
    (0 : Rat) < (2565374748688530165347921 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_106 : K11RowValid 106 := by
  change (1 : Rat) <= (20643833 / 12500000 : Rat) /\
    (67052900407 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (530475903 / 100000000 : Rat) - (20643833 / 12500000 : Rat) /\
    (0 : Rat) < (67052900407 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_107 : K11RowValid 107 := by
  change (1 : Rat) <= (698946223 / 50000000 : Rat) /\
    (91300507253069431113107407587 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (97199029 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (475333323 / 50000000 : Rat) - (698946223 / 50000000 : Rat) /\
    (0 : Rat) < (91300507253069431113107407587 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_108 : K11RowValid 108 := by
  change (1 : Rat) <= (222020819 / 50000000 : Rat) /\
    (723988378623047151489979 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (197514501 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (204514299 / 50000000 : Rat) - (222020819 / 50000000 : Rat) /\
    (0 : Rat) < (723988378623047151489979 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_109 : K11RowValid 109 := by
  change (1 : Rat) <= (367950749 / 100000000 : Rat) /\
    (1201362821971 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1181884479 / 100000000 : Rat) - (367950749 / 100000000 : Rat) /\
    (0 : Rat) < (1201362821971 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_110 : K11RowValid 110 := by
  change (1 : Rat) <= (251245081 / 50000000 : Rat) /\
    (120611382950674620397218127 / 37789064125000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (125625257 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (9424711 / 3125000 : Rat) - (251245081 / 50000000 : Rat) /\
    (0 : Rat) < (120611382950674620397218127 / 37789064125000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_111 : K11RowValid 111 := by
  change (1 : Rat) <= (200512781 / 50000000 : Rat) /\
    (1309217535503820005964017 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (924852407 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (144083377 / 100000000 : Rat) - (200512781 / 50000000 : Rat) /\
    (0 : Rat) < (1309217535503820005964017 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_112 : K11RowValid 112 := by
  change (1 : Rat) <= (267076437 / 100000000 : Rat) /\
    (51167443819 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (6862951 / 800000 : Rat) - (267076437 / 100000000 : Rat) /\
    (0 : Rat) < (51167443819 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_113 : K11RowValid 113 := by
  change (1 : Rat) <= (45712807 / 5000000 : Rat) /\
    (59601659699615146558210313863 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (19548221 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (307643727 / 50000000 : Rat) - (45712807 / 5000000 : Rat) /\
    (0 : Rat) < (59601659699615146558210313863 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_114 : K11RowValid 114 := by
  change (1 : Rat) <= (1287797729 / 100000000 : Rat) /\
    (840750864136214646041977 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (548353103 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (110638137 / 20000000 : Rat) - (1287797729 / 100000000 : Rat) /\
    (0 : Rat) < (840750864136214646041977 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_115 : K11RowValid 115 := by
  change (1 : Rat) <= (125881879 / 100000000 : Rat) /\
    (413111917241 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (202170861 / 50000000 : Rat) - (125881879 / 100000000 : Rat) /\
    (0 : Rat) < (413111917241 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_116 : K11RowValid 116 := by
  change (1 : Rat) <= (916114871 / 25000000 : Rat) /\
    (239145296383221661792057316153 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (14201381 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1286721137 / 50000000 : Rat) - (916114871 / 25000000 : Rat) /\
    (0 : Rat) < (239145296383221661792057316153 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_117 : K11RowValid 117 := by
  change (1 : Rat) <= (242235009 / 50000000 : Rat) /\
    (157975079050955583141417 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (268982711 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (51052777 / 10000000 : Rat) - (242235009 / 50000000 : Rat) /\
    (0 : Rat) < (157975079050955583141417 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_118 : K11RowValid 118 := by
  change (1 : Rat) <= (146395481 / 50000000 : Rat) /\
    (478999786199 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (235116449 / 25000000 : Rat) - (146395481 / 50000000 : Rat) /\
    (0 : Rat) < (478999786199 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_119 : K11RowValid 119 := by
  change (1 : Rat) <= (9301179 / 2500000 : Rat) /\
    (1430333242911769274461420897 / 604625026000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (17234719 / 6250000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (101721321 / 50000000 : Rat) - (9301179 / 2500000 : Rat) /\
    (0 : Rat) < (1430333242911769274461420897 / 604625026000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_120 : K11RowValid 120 := by
  change (1 : Rat) <= (253394433 / 50000000 : Rat) /\
    (4863275927297001811323 / 1511562565000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (81110723 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (6545771 / 5000000 : Rat) - (253394433 / 50000000 : Rat) /\
    (0 : Rat) < (4863275927297001811323 / 1511562565000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_121 : K11RowValid 121 := by
  change (1 : Rat) <= (327392537 / 100000000 : Rat) /\
    (1067435436823 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1051608561 / 100000000 : Rat) - (327392537 / 100000000 : Rat) /\
    (0 : Rat) < (1067435436823 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_122 : K11RowValid 122 := by
  change (1 : Rat) <= (837534361 / 100000000 : Rat) /\
    (21876222964262325125896980119 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (126479767 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (107875551 / 20000000 : Rat) - (837534361 / 100000000 : Rat) /\
    (0 : Rat) < (21876222964262325125896980119 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_123 : K11RowValid 123 := by
  change (1 : Rat) <= (176630441 / 20000000 : Rat) /\
    (576792108060325209896709 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (699316453 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (114079429 / 20000000 : Rat) - (176630441 / 20000000 : Rat) /\
    (0 : Rat) < (576792108060325209896709 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_124 : K11RowValid 124 := by
  change (1 : Rat) <= (32863973 / 20000000 : Rat) /\
    (107258499467 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (263903659 / 50000000 : Rat) - (32863973 / 20000000 : Rat) /\
    (0 : Rat) < (107258499467 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_125 : K11RowValid 125 := by
  change (1 : Rat) <= (70042839 / 4000000 : Rat) /\
    (114358910910715444529940207857 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (30252863 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (605634153 / 50000000 : Rat) - (70042839 / 4000000 : Rat) /\
    (0 : Rat) < (114358910910715444529940207857 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_126 : K11RowValid 126 := by
  change (1 : Rat) <= (4943188 / 390625 : Rat) /\
    (4128761451662148940697453 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2014176 / 390625 : Rat) + (784931055601 / 1000000000000 : Rat) * (1407675693 / 100000000 : Rat) - (4943188 / 390625 : Rat) /\
    (0 : Rat) < (4128761451662148940697453 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_127 : K11RowValid 127 := by
  change (1 : Rat) <= (11277343 / 5000000 : Rat) /\
    (36781019697 / 25696563605000000 : Rat) = (1600000000 / 5139312721 : Rat) * (22639777 / 3125000 : Rat) - (11277343 / 5000000 : Rat) /\
    (0 : Rat) < (36781019697 / 25696563605000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_128 : K11RowValid 128 := by
  change (1 : Rat) <= (112992753 / 20000000 : Rat) /\
    (73709691250856008423333560827 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (333068213 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (327893283 / 100000000 : Rat) - (112992753 / 20000000 : Rat) /\
    (0 : Rat) < (73709691250856008423333560827 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_129 : K11RowValid 129 := by
  change (1 : Rat) <= (56553753 / 12500000 : Rat) /\
    (1475347435134320125181973 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (949486943 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (199801813 / 100000000 : Rat) - (56553753 / 12500000 : Rat) /\
    (0 : Rat) < (1475347435134320125181973 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_130 : K11RowValid 130 := by
  change (1 : Rat) <= (129772293 / 100000000 : Rat) /\
    (24785397691 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (416838011 / 100000000 : Rat) - (129772293 / 100000000 : Rat) /\
    (0 : Rat) < (24785397691 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_131 : K11RowValid 131 := by
  change (1 : Rat) <= (1550434333 / 50000000 : Rat) /\
    (202358725147187503032763705823 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (42560797 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1078574567 / 50000000 : Rat) - (1550434333 / 50000000 : Rat) /\
    (0 : Rat) < (202358725147187503032763705823 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_132 : K11RowValid 132 := by
  change (1 : Rat) <= (791459067 / 100000000 : Rat) /\
    (2579733355248206081322463 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (648153363 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (751241503 / 100000000 : Rat) - (791459067 / 100000000 : Rat) /\
    (0 : Rat) < (2579733355248206081322463 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_133 : K11RowValid 133 := by
  change (1 : Rat) <= (128302527 / 100000000 : Rat) /\
    (421252454033 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (412117019 / 100000000 : Rat) - (128302527 / 100000000 : Rat) /\
    (0 : Rat) < (421252454033 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_134 : K11RowValid 134 := by
  change (1 : Rat) <= (29073449 / 2000000 : Rat) /\
    (189711747979472311356182946823 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (112403173 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1008463567 / 100000000 : Rat) - (29073449 / 2000000 : Rat) /\
    (0 : Rat) < (189711747979472311356182946823 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_135 : K11RowValid 135 := by
  change (1 : Rat) <= (210920401 / 20000000 : Rat) /\
    (6888406060204845985433 / 1027862544200000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (71231573 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2122073 / 200000 : Rat) - (210920401 / 20000000 : Rat) /\
    (0 : Rat) < (6888406060204845985433 / 1027862544200000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_136 : K11RowValid 136 := by
  change (1 : Rat) <= (609336601 / 50000000 : Rat) /\
    (116888811687 / 15115625650000000 : Rat) = (1600000000 / 5139312721 : Rat) * (782893333 / 20000000 : Rat) - (609336601 / 50000000 : Rat) /\
    (0 : Rat) < (116888811687 / 15115625650000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_137 : K11RowValid 137 := by
  change (1 : Rat) <= (205794253 / 50000000 : Rat) /\
    (3363193506105082153325781463 / 1284828180250000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (234384801 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (15044127 / 6250000 : Rat) - (205794253 / 50000000 : Rat) /\
    (0 : Rat) < (3363193506105082153325781463 / 1284828180250000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_138 : K11RowValid 138 := by
  change (1 : Rat) <= (287538881 / 50000000 : Rat) /\
    (938489307850487356080859 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (136767127 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (95095579 / 50000000 : Rat) - (287538881 / 50000000 : Rat) /\
    (0 : Rat) < (938489307850487356080859 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_139 : K11RowValid 139 := by
  change (1 : Rat) <= (125167341 / 50000000 : Rat) /\
    (407344955139 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (100511643 / 12500000 : Rat) - (125167341 / 50000000 : Rat) /\
    (0 : Rat) < (407344955139 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_140 : K11RowValid 140 := by
  change (1 : Rat) <= (211800547 / 25000000 : Rat) /\
    (27638996630641009594476137307 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (121364079 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (143843203 / 25000000 : Rat) - (211800547 / 25000000 : Rat) /\
    (0 : Rat) < (27638996630641009594476137307 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_141 : K11RowValid 141 := by
  change (1 : Rat) <= (131183403 / 6250000 : Rat) /\
    (1370393334819316432797951 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1012155141 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (374228031 / 20000000 : Rat) - (131183403 / 6250000 : Rat) /\
    (0 : Rat) < (1370393334819316432797951 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_142 : K11RowValid 142 := by
  change (1 : Rat) <= (35278749 / 20000000 : Rat) /\
    (114883333971 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (113317899 / 20000000 : Rat) - (35278749 / 20000000 : Rat) /\
    (0 : Rat) < (114883333971 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_143 : K11RowValid 143 := by
  change (1 : Rat) <= (191756083 / 20000000 : Rat) /\
    (31305356994380750042494595773 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (70477149 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (162588117 / 25000000 : Rat) - (191756083 / 20000000 : Rat) /\
    (0 : Rat) < (31305356994380750042494595773 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_144 : K11RowValid 144 := by
  change (1 : Rat) <= (204514299 / 50000000 : Rat) /\
    (334424221347895727519763 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (31114901 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (99422803 / 25000000 : Rat) - (204514299 / 50000000 : Rat) /\
    (0 : Rat) < (334424221347895727519763 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_145 : K11RowValid 145 := by
  change (1 : Rat) <= (127350931 / 50000000 : Rat) /\
    (416280506749 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (163624169 / 20000000 : Rat) - (127350931 / 50000000 : Rat) /\
    (0 : Rat) < (416280506749 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_146 : K11RowValid 146 := by
  change (1 : Rat) <= (377755779 / 100000000 : Rat) /\
    (3071513073614084037327970913 / 1284828180250000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (577645727 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (8793177 / 6250000 : Rat) - (377755779 / 100000000 : Rat) /\
    (0 : Rat) < (3071513073614084037327970913 / 1284828180250000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_147 : K11RowValid 147 := by
  change (1 : Rat) <= (525929787 / 100000000 : Rat) /\
    (1715096620729685000626629 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (25734467 / 2000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (159682949 / 100000000 : Rat) - (525929787 / 100000000 : Rat) /\
    (0 : Rat) < (1715096620729685000626629 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_148 : K11RowValid 148 := by
  change (1 : Rat) <= (16684443 / 10000000 : Rat) /\
    (54487300597 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (133979101 / 25000000 : Rat) - (16684443 / 10000000 : Rat) /\
    (0 : Rat) < (54487300597 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_149 : K11RowValid 149 := by
  change (1 : Rat) <= (1077688707 / 100000000 : Rat) /\
    (140809332855313834472802354233 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (309864451 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (697497457 / 100000000 : Rat) - (1077688707 / 100000000 : Rat) /\
    (0 : Rat) < (140809332855313834472802354233 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_150 : K11RowValid 150 := by
  change (1 : Rat) <= (362454909 / 50000000 : Rat) /\
    (295616656047361452195157 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (720836509 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (43965717 / 12500000 : Rat) - (362454909 / 50000000 : Rat) /\
    (0 : Rat) < (295616656047361452195157 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_151 : K11RowValid 151 := by
  change (1 : Rat) <= (337811243 / 100000000 : Rat) /\
    (1103153277797 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1085074201 / 100000000 : Rat) - (337811243 / 100000000 : Rat) /\
    (0 : Rat) < (1103153277797 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_152 : K11RowValid 152 := by
  change (1 : Rat) <= (110638137 / 20000000 : Rat) /\
    (72273435342510750185952432763 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1700469 / 1000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (355601827 / 100000000 : Rat) - (110638137 / 20000000 : Rat) /\
    (0 : Rat) < (72273435342510750185952432763 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_153 : K11RowValid 153 := by
  change (1 : Rat) <= (987751629 / 100000000 : Rat) /\
    (1612341699964786031360997 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (584114351 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (513358757 / 50000000 : Rat) - (987751629 / 100000000 : Rat) /\
    (0 : Rat) < (1612341699964786031360997 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_154 : K11RowValid 154 := by
  change (1 : Rat) <= (231109237 / 100000000 : Rat) /\
    (755145296123 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (742339623 / 100000000 : Rat) - (231109237 / 100000000 : Rat) /\
    (0 : Rat) < (755145296123 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_155 : K11RowValid 155 := by
  change (1 : Rat) <= (372445907 / 100000000 : Rat) /\
    (12156218236184389276251697761 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (594890941 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (33274969 / 25000000 : Rat) - (372445907 / 100000000 : Rat) /\
    (0 : Rat) < (12156218236184389276251697761 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_156 : K11RowValid 156 := by
  change (1 : Rat) <= (265912823 / 50000000 : Rat) /\
    (1734867912442862361603727 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1139367093 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (225639887 / 100000000 : Rat) - (265912823 / 50000000 : Rat) /\
    (0 : Rat) < (1734867912442862361603727 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_157 : K11RowValid 157 := by
  change (1 : Rat) <= (16235429 / 12500000 : Rat) /\
    (52809407691 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (208597499 / 50000000 : Rat) - (16235429 / 12500000 : Rat) /\
    (0 : Rat) < (52809407691 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_158 : K11RowValid 158 := by
  change (1 : Rat) <= (578787213 / 50000000 : Rat) /\
    (151178748868994253757025412629 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (185857453 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (781727341 / 100000000 : Rat) - (578787213 / 50000000 : Rat) /\
    (0 : Rat) < (151178748868994253757025412629 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_159 : K11RowValid 159 := by
  change (1 : Rat) <= (1024129333 / 50000000 : Rat) /\
    (6682677212368071886690659 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (319932199 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2355689379 / 100000000 : Rat) - (1024129333 / 50000000 : Rat) /\
    (0 : Rat) < (6682677212368071886690659 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_160 : K11RowValid 160 := by
  change (1 : Rat) <= (28497563 / 20000000 : Rat) /\
    (92436601077 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (457681189 / 100000000 : Rat) - (28497563 / 20000000 : Rat) /\
    (0 : Rat) < (92436601077 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_161 : K11RowValid 161 := by
  change (1 : Rat) <= (1744545289 / 100000000 : Rat) /\
    (113930869598521296827752147623 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (181159761 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (600006767 / 50000000 : Rat) - (1744545289 / 100000000 : Rat) /\
    (0 : Rat) < (113930869598521296827752147623 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_162 : K11RowValid 162 := by
  change (1 : Rat) <= (590199341 / 50000000 : Rat) /\
    (3854991778110012449459247 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (150650347 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1264817007 / 100000000 : Rat) - (590199341 / 50000000 : Rat) /\
    (0 : Rat) < (3854991778110012449459247 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_163 : K11RowValid 163 := by
  change (1 : Rat) <= (319373037 / 100000000 : Rat) /\
    (1045001496323 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (256462337 / 25000000 : Rat) - (319373037 / 100000000 : Rat) /\
    (0 : Rat) < (1045001496323 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_164 : K11RowValid 164 := by
  change (1 : Rat) <= (114079429 / 20000000 : Rat) /\
    (3721238388945644855944811363 / 1027862544200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (88205599 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (18321227 / 5000000 : Rat) - (114079429 / 20000000 : Rat) /\
    (0 : Rat) < (3721238388945644855944811363 / 1027862544200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_165 : K11RowValid 165 := by
  change (1 : Rat) <= (102639179 / 20000000 : Rat) /\
    (167790431352303770149401 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (993010353 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (25995481 / 10000000 : Rat) - (102639179 / 20000000 : Rat) /\
    (0 : Rat) < (167790431352303770149401 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_166 : K11RowValid 166 := by
  change (1 : Rat) <= (621987229 / 100000000 : Rat) /\
    (2030500759891 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (499467017 / 25000000 : Rat) - (621987229 / 100000000 : Rat) /\
    (0 : Rat) < (2030500759891 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_167 : K11RowValid 167 := by
  change (1 : Rat) <= (130847919 / 20000000 : Rat) /\
    (85465274007133545907039404333 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (327710881 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (392540357 / 100000000 : Rat) - (130847919 / 20000000 : Rat) /\
    (0 : Rat) < (85465274007133545907039404333 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_168 : K11RowValid 168 := by
  change (1 : Rat) <= (1484374683 / 100000000 : Rat) /\
    (4846850136831447577789183 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (39125401 / 5000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1580725823 / 100000000 : Rat) - (1484374683 / 100000000 : Rat) /\
    (0 : Rat) < (4846850136831447577789183 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_169 : K11RowValid 169 := by
  change (1 : Rat) <= (13761493 / 10000000 : Rat) /\
    (44925147547 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (442029131 / 100000000 : Rat) - (13761493 / 10000000 : Rat) /\
    (0 : Rat) < (44925147547 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_170 : K11RowValid 170 := by
  change (1 : Rat) <= (1262920569 / 100000000 : Rat) /\
    (9687726162167491793383075903 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (3027717 / 2000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (864241079 / 100000000 : Rat) - (1262920569 / 100000000 : Rat) /\
    (0 : Rat) < (9687726162167491793383075903 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_171 : K11RowValid 171 := by
  change (1 : Rat) <= (280228589 / 50000000 : Rat) /\
    (1827520530795114666509801 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (315745371 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (588787881 / 100000000 : Rat) - (280228589 / 50000000 : Rat) /\
    (0 : Rat) < (1827520530795114666509801 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_172 : K11RowValid 172 := by
  change (1 : Rat) <= (199801813 / 100000000 : Rat) /\
    (651970236827 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (641777907 / 100000000 : Rat) - (199801813 / 100000000 : Rat) /\
    (0 : Rat) < (651970236827 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_173 : K11RowValid 173 := by
  change (1 : Rat) <= (239950967 / 100000000 : Rat) /\
    (15743895880007561834750858217 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (213873677 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (61618593 / 50000000 : Rat) - (239950967 / 100000000 : Rat) /\
    (0 : Rat) < (15743895880007561834750858217 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_174 : K11RowValid 174 := by
  change (1 : Rat) <= (780609483 / 100000000 : Rat) /\
    (1272285597105591798283371 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2043327131 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (92027051 / 50000000 : Rat) - (780609483 / 100000000 : Rat) /\
    (0 : Rat) < (1272285597105591798283371 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_175 : K11RowValid 175 := by
  change (1 : Rat) <= (45838019 / 20000000 : Rat) /\
    (149847860301 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (920219 / 125000 : Rat) - (45838019 / 20000000 : Rat) /\
    (0 : Rat) < (149847860301 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_176 : K11RowValid 176 := by
  change (1 : Rat) <= (751241503 / 100000000 : Rat) /\
    (49121017952670040602662424521 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (6996553 / 3125000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (242235009 / 50000000 : Rat) - (751241503 / 100000000 : Rat) /\
    (0 : Rat) < (49121017952670040602662424521 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_177 : K11RowValid 177 := by
  change (1 : Rat) <= (763589289 / 100000000 : Rat) /\
    (124603237377452596755641 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (831500501 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (15660921 / 5000000 : Rat) - (763589289 / 100000000 : Rat) /\
    (0 : Rat) < (124603237377452596755641 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_178 : K11RowValid 178 := by
  change (1 : Rat) <= (133281951 / 100000000 : Rat) /\
    (434546001329 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (53513911 / 12500000 : Rat) - (133281951 / 100000000 : Rat) /\
    (0 : Rat) < (434546001329 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_179 : K11RowValid 179 := by
  change (1 : Rat) <= (104714811 / 20000000 : Rat) /\
    (3416605742125656888708445599 / 1027862544200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (85971259 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (16706471 / 5000000 : Rat) - (104714811 / 20000000 : Rat) /\
    (0 : Rat) < (3416605742125656888708445599 / 1027862544200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_180 : K11RowValid 180 := by
  change (1 : Rat) <= (1217150523 / 100000000 : Rat) /\
    (3972165461405947324069519 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (91990647 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1368217039 / 100000000 : Rat) - (1217150523 / 100000000 : Rat) /\
    (0 : Rat) < (3972165461405947324069519 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_181 : K11RowValid 181 := by
  change (1 : Rat) <= (697180719 / 100000000 : Rat) /\
    (2276407373601 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2239395009 / 100000000 : Rat) - (697180719 / 100000000 : Rat) /\
    (0 : Rat) < (2276407373601 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_182 : K11RowValid 182 := by
  change (1 : Rat) <= (515510497 / 100000000 : Rat) /\
    (33584906016148520615974436381 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (340450201 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (145552949 / 50000000 : Rat) - (515510497 / 100000000 : Rat) /\
    (0 : Rat) < (33584906016148520615974436381 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_183 : K11RowValid 183 := by
  change (1 : Rat) <= (148962583 / 25000000 : Rat) /\
    (1945120403778680298608899 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (694568481 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (483626819 / 100000000 : Rat) - (148962583 / 25000000 : Rat) /\
    (0 : Rat) < (1945120403778680298608899 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_184 : K11RowValid 184 := by
  change (1 : Rat) <= (41912719 / 20000000 : Rat) /\
    (137271601601 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (33656673 / 5000000 : Rat) - (41912719 / 20000000 : Rat) /\
    (0 : Rat) < (137271601601 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_185 : K11RowValid 185 := by
  change (1 : Rat) <= (162759249 / 12500000 : Rat) /\
    (84990090475352916488986681511 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (105551607 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (439428719 / 50000000 : Rat) - (162759249 / 12500000 : Rat) /\
    (0 : Rat) < (84990090475352916488986681511 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_186 : K11RowValid 186 := by
  change (1 : Rat) <= (20420757 / 3125000 : Rat) /\
    (2130445697736130939691921 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (435401747 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (659819601 / 100000000 : Rat) - (20420757 / 3125000 : Rat) /\
    (0 : Rat) < (2130445697736130939691921 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_187 : K11RowValid 187 := by
  change (1 : Rat) <= (94574031 / 50000000 : Rat) /\
    (307405451649 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (121511457 / 20000000 : Rat) - (94574031 / 50000000 : Rat) /\
    (0 : Rat) < (307405451649 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_188 : K11RowValid 188 := by
  change (1 : Rat) <= (2279764493 / 100000000 : Rat) /\
    (59494837662969292537248490643 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (64054611 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (312772347 / 20000000 : Rat) - (2279764493 / 100000000 : Rat) /\
    (0 : Rat) < (59494837662969292537248490643 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_189 : K11RowValid 189 := by
  change (1 : Rat) <= (211479607 / 25000000 : Rat) /\
    (2762630092820383621340277 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (674934593 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (810000437 / 100000000 : Rat) - (211479607 / 25000000 : Rat) /\
    (0 : Rat) < (2762630092820383621340277 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_190 : K11RowValid 190 := by
  change (1 : Rat) <= (405297833 / 100000000 : Rat) /\
    (1319869366407 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (650923009 / 50000000 : Rat) - (405297833 / 100000000 : Rat) /\
    (0 : Rat) < (1319869366407 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_191 : K11RowValid 191 := by
  change (1 : Rat) <= (173387271 / 50000000 : Rat) /\
    (1413387191164962101261179989 / 642414090125000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (23469159 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (6404781 / 3125000 : Rat) - (173387271 / 50000000 : Rat) /\
    (0 : Rat) < (1413387191164962101261179989 / 642414090125000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_192 : K11RowValid 192 := by
  change (1 : Rat) <= (404609431 / 100000000 : Rat) /\
    (263899912638092129352797 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (159342659 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (39894557 / 20000000 : Rat) - (404609431 / 100000000 : Rat) /\
    (0 : Rat) < (263899912638092129352797 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_193 : K11RowValid 193 := by
  change (1 : Rat) <= (519622443 / 100000000 : Rat) /\
    (1698173002597 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (417266239 / 25000000 : Rat) - (519622443 / 100000000 : Rat) /\
    (0 : Rat) < (1698173002597 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_194 : K11RowValid 194 := by
  change (1 : Rat) <= (616016463 / 100000000 : Rat) /\
    (80301474348902763216884257061 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (160542739 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (402364669 / 100000000 : Rat) - (616016463 / 100000000 : Rat) /\
    (0 : Rat) < (80301474348902763216884257061 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_195 : K11RowValid 195 := by
  change (1 : Rat) <= (1228020123 / 100000000 : Rat) /\
    (4008935209922412877316517 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (304027757 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (358635877 / 100000000 : Rat) - (1228020123 / 100000000 : Rat) /\
    (0 : Rat) < (4008935209922412877316517 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_196 : K11RowValid 196 := by
  change (1 : Rat) <= (159682949 / 100000000 : Rat) /\
    (521677505771 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (64114151 / 12500000 : Rat) - (159682949 / 100000000 : Rat) /\
    (0 : Rat) < (521677505771 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_197 : K11RowValid 197 := by
  change (1 : Rat) <= (3613998147 / 100000000 : Rat) /\
    (235936662624354644004736593801 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (113906509 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1271896129 / 50000000 : Rat) - (3613998147 / 100000000 : Rat) /\
    (0 : Rat) < (235936662624354644004736593801 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_198 : K11RowValid 198 := by
  change (1 : Rat) <= (597622551 / 100000000 : Rat) /\
    (1949605232485460843104963 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (316097111 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (510624003 / 100000000 : Rat) - (597622551 / 100000000 : Rat) /\
    (0 : Rat) < (1949605232485460843104963 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_199 : K11RowValid 199 := by
  change (1 : Rat) <= (200572171 / 100000000 : Rat) /\
    (654901112709 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (644252353 / 100000000 : Rat) - (200572171 / 100000000 : Rat) /\
    (0 : Rat) < (654901112709 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_200 : K11RowValid 200 := by
  change (1 : Rat) <= (355966087 / 100000000 : Rat) /\
    (46304236737540372592527251063 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (563634123 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (128302527 / 100000000 : Rat) - (355966087 / 100000000 : Rat) /\
    (0 : Rat) < (46304236737540372592527251063 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_201 : K11RowValid 201 := by
  change (1 : Rat) <= (165444989 / 25000000 : Rat) /\
    (2161149736845574905400421 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (166881357 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (181208101 / 100000000 : Rat) - (165444989 / 25000000 : Rat) /\
    (0 : Rat) < (2161149736845574905400421 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_202 : K11RowValid 202 := by
  change (1 : Rat) <= (21932489 / 12500000 : Rat) /\
    (71879107431 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (281794979 / 50000000 : Rat) - (21932489 / 12500000 : Rat) /\
    (0 : Rat) < (71879107431 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_203 : K11RowValid 203 := by
  change (1 : Rat) <= (203557583 / 12500000 : Rat) /\
    (42517551835232375004439759769 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (232675971 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (210920401 / 20000000 : Rat) - (203557583 / 12500000 : Rat) /\
    (0 : Rat) < (42517551835232375004439759769 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_204 : K11RowValid 204 := by
  change (1 : Rat) <= (513358757 / 50000000 : Rat) /\
    (837418754989750927530471 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1195748779 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (208442151 / 25000000 : Rat) - (513358757 / 50000000 : Rat) /\
    (0 : Rat) < (837418754989750927530471 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_205 : K11RowValid 205 := by
  change (1 : Rat) <= (5507479 / 3125000 : Rat) /\
    (17914659641 / 16060352253125000 : Rat) = (1600000000 / 5139312721 : Rat) * (70761687 / 12500000 : Rat) - (5507479 / 3125000 : Rat) /\
    (0 : Rat) < (17914659641 / 16060352253125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_206 : K11RowValid 206 := by
  change (1 : Rat) <= (628241083 / 100000000 : Rat) /\
    (41013041572643777367228464757 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (158129777 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (205794253 / 50000000 : Rat) - (628241083 / 100000000 : Rat) /\
    (0 : Rat) < (41013041572643777367228464757 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_207 : K11RowValid 207 := by
  change (1 : Rat) <= (919697183 / 100000000 : Rat) /\
    (176644183798606300392017 / 30231251300000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (76101027 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1020773409 / 100000000 : Rat) - (919697183 / 100000000 : Rat) /\
    (0 : Rat) < (176644183798606300392017 / 30231251300000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_208 : K11RowValid 208 := by
  change (1 : Rat) <= (233971203 / 100000000 : Rat) /\
    (44851436861 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (46970779 / 6250000 : Rat) - (233971203 / 100000000 : Rat) /\
    (0 : Rat) < (44851436861 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_209 : K11RowValid 209 := by
  change (1 : Rat) <= (541335339 / 100000000 : Rat) /\
    (17667832532606716778672154249 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (694234299 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (57792321 / 25000000 : Rat) - (541335339 / 100000000 : Rat) /\
    (0 : Rat) < (17667832532606716778672154249 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_210 : K11RowValid 210 := by
  change (1 : Rat) <= (109471569 / 25000000 : Rat) /\
    (22278656022365349940133 / 8030176126562500000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (18007349 / 2500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (4252773 / 1562500 : Rat) - (109471569 / 25000000 : Rat) /\
    (0 : Rat) < (22278656022365349940133 / 8030176126562500000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_211 : K11RowValid 211 := by
  change (1 : Rat) <= (66551543 / 50000000 : Rat) /\
    (218057921497 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (213768381 / 50000000 : Rat) - (66551543 / 50000000 : Rat) /\
    (0 : Rat) < (218057921497 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_212 : K11RowValid 212 := by
  change (1 : Rat) <= (1305284701 / 50000000 : Rat) /\
    (170456202505383427536838402971 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (423785269 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (880965059 / 50000000 : Rat) - (1305284701 / 50000000 : Rat) /\
    (0 : Rat) < (170456202505383427536838402971 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_213 : K11RowValid 213 := by
  change (1 : Rat) <= (614419071 / 50000000 : Rat) /\
    (801836190351496011892951 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1288164671 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (210923031 / 20000000 : Rat) - (614419071 / 50000000 : Rat) /\
    (0 : Rat) < (801836190351496011892951 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_214 : K11RowValid 214 := by
  change (1 : Rat) <= (11192591 / 6250000 : Rat) /\
    (36492749889 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (287611309 / 50000000 : Rat) - (11192591 / 6250000 : Rat) /\
    (0 : Rat) < (36492749889 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_215 : K11RowValid 215 := by
  change (1 : Rat) <= (1294355361 / 100000000 : Rat) /\
    (168780995656574395040455126703 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (122531191 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (892972087 / 100000000 : Rat) - (1294355361 / 100000000 : Rat) /\
    (0 : Rat) < (168780995656574395040455126703 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_216 : K11RowValid 216 := by
  change (1 : Rat) <= (300446967 / 20000000 : Rat) /\
    (306292508472059146199757 / 32120704506250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (179048329 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (110738317 / 6250000 : Rat) - (300446967 / 20000000 : Rat) /\
    (0 : Rat) < (306292508472059146199757 / 32120704506250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_217 : K11RowValid 217 := by
  change (1 : Rat) <= (138891511 / 25000000 : Rat) /\
    (452678788569 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (356903681 / 20000000 : Rat) - (138891511 / 25000000 : Rat) /\
    (0 : Rat) < (452678788569 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_218 : K11RowValid 218 := by
  change (1 : Rat) <= (444842237 / 100000000 : Rat) /\
    (29078877664113494045628628749 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (68691857 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (120102821 / 50000000 : Rat) - (444842237 / 100000000 : Rat) /\
    (0 : Rat) < (29078877664113494045628628749 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_219 : K11RowValid 219 := by
  change (1 : Rat) <= (668156639 / 100000000 : Rat) /\
    (1089104138163314912944223 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1591269523 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (110044063 / 50000000 : Rat) - (668156639 / 100000000 : Rat) /\
    (0 : Rat) < (1089104138163314912944223 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_220 : K11RowValid 220 := by
  change (1 : Rat) <= (138305841 / 50000000 : Rat) /\
    (450360096639 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (888496773 / 100000000 : Rat) - (138305841 / 50000000 : Rat) /\
    (0 : Rat) < (450360096639 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_221 : K11RowValid 221 := by
  change (1 : Rat) <= (24885483 / 3125000 : Rat) /\
    (51931198819023136734142286371 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (247556633 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (255643659 / 50000000 : Rat) - (24885483 / 3125000 : Rat) /\
    (0 : Rat) < (51931198819023136734142286371 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_222 : K11RowValid 222 := by
  change (1 : Rat) <= (1680641739 / 50000000 : Rat) /\
    (10970584994176128588992031 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (752342261 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (3685468511 / 100000000 : Rat) - (1680641739 / 50000000 : Rat) /\
    (0 : Rat) < (10970584994176128588992031 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_223 : K11RowValid 223 := by
  change (1 : Rat) <= (12884509 / 10000000 : Rat) /\
    (42032461011 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (413859769 / 100000000 : Rat) - (12884509 / 10000000 : Rat) /\
    (0 : Rat) < (42032461011 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_224 : K11RowValid 224 := by
  change (1 : Rat) <= (1580725823 / 100000000 : Rat) /\
    (12131495349686230092476451499 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (51925837 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1077688707 / 100000000 : Rat) - (1580725823 / 100000000 : Rat) /\
    (0 : Rat) < (12131495349686230092476451499 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_225 : K11RowValid 225 := by
  change (1 : Rat) <= (87023447 / 20000000 : Rat) /\
    (355107513795042615630479 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (319592407 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (106894799 / 25000000 : Rat) - (87023447 / 20000000 : Rat) /\
    (0 : Rat) < (355107513795042615630479 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_226 : K11RowValid 226 := by
  change (1 : Rat) <= (63393229 / 25000000 : Rat) /\
    (207375033891 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (814494589 / 100000000 : Rat) - (63393229 / 25000000 : Rat) /\
    (0 : Rat) < (207375033891 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_227 : K11RowValid 227 := by
  change (1 : Rat) <= (52520791 / 10000000 : Rat) /\
    (1369903539917704304787439011 / 411145017680000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (102835081 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (5646219 / 2000000 : Rat) - (52520791 / 10000000 : Rat) /\
    (0 : Rat) < (1369903539917704304787439011 / 411145017680000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_228 : K11RowValid 228 := by
  change (1 : Rat) <= (633992527 / 100000000 : Rat) /\
    (2066631551128264368691357 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (812785839 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (162957917 / 100000000 : Rat) - (633992527 / 100000000 : Rat) /\
    (0 : Rat) < (2066631551128264368691357 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_229 : K11RowValid 229 := by
  change (1 : Rat) <= (266492437 / 100000000 : Rat) /\
    (868475608923 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (34239721 / 4000000 : Rat) - (266492437 / 100000000 : Rat) /\
    (0 : Rat) < (868475608923 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_230 : K11RowValid 230 := by
  change (1 : Rat) <= (1701644267 / 100000000 : Rat) /\
    (222206088220884514511663573133 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (723557267 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (889355557 / 100000000 : Rat) - (1701644267 / 100000000 : Rat) /\
    (0 : Rat) < (222206088220884514511663573133 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_231 : K11RowValid 231 := by
  change (1 : Rat) <= (1133441551 / 100000000 : Rat) /\
    (1849041157172225014702813 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2743382921 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (177949853 / 50000000 : Rat) - (1133441551 / 100000000 : Rat) /\
    (0 : Rat) < (1849041157172225014702813 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_232 : K11RowValid 232 := by
  change (1 : Rat) <= (24520467 / 12500000 : Rat) /\
    (79822039293 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (630092139 / 100000000 : Rat) - (24520467 / 12500000 : Rat) /\
    (0 : Rat) < (79822039293 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_233 : K11RowValid 233 := by
  change (1 : Rat) <= (119022317 / 20000000 : Rat) /\
    (77672023283187155363680042283 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (7143353 / 3125000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (372445907 / 100000000 : Rat) - (119022317 / 20000000 : Rat) /\
    (0 : Rat) < (77672023283187155363680042283 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_234 : K11RowValid 234 := by
  change (1 : Rat) <= (405686321 / 50000000 : Rat) /\
    (165422160530563058419997 / 32120704506250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (21731499 / 4000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (51137757 / 6250000 : Rat) - (405686321 / 50000000 : Rat) /\
    (0 : Rat) < (165422160530563058419997 / 32120704506250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_235 : K11RowValid 235 := by
  change (1 : Rat) <= (284938397 / 100000000 : Rat) /\
    (54752738339 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (915242787 / 100000000 : Rat) - (284938397 / 100000000 : Rat) /\
    (0 : Rat) < (54752738339 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_236 : K11RowValid 236 := by
  change (1 : Rat) <= (161402589 / 50000000 : Rat) /\
    (5267243893432482928021535501 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (449975319 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (16235429 / 12500000 : Rat) - (161402589 / 50000000 : Rat) /\
    (0 : Rat) < (5267243893432482928021535501 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_237 : K11RowValid 237 := by
  change (1 : Rat) <= (554048139 / 100000000 : Rat) /\
    (1808359920350935307613861 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (993372777 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (311856741 / 100000000 : Rat) - (554048139 / 100000000 : Rat) /\
    (0 : Rat) < (1808359920350935307613861 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_238 : K11RowValid 238 := by
  change (1 : Rat) <= (8267143 / 6250000 : Rat) /\
    (26813773897 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (2124373 / 500000 : Rat) - (8267143 / 6250000 : Rat) /\
    (0 : Rat) < (26813773897 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_239 : K11RowValid 239 := by
  change (1 : Rat) <= (521870167 / 20000000 : Rat) /\
    (42598790090388602727664790253 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (223986681 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (225660037 / 12500000 : Rat) - (521870167 / 20000000 : Rat) /\
    (0 : Rat) < (42598790090388602727664790253 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_240 : K11RowValid 240 := by
  change (1 : Rat) <= (149660953 / 10000000 : Rat) /\
    (2441590176677847275291447 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (652064849 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (824025207 / 50000000 : Rat) - (149660953 / 10000000 : Rat) /\
    (0 : Rat) < (2441590176677847275291447 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_241 : K11RowValid 241 := by
  change (1 : Rat) <= (166474923 / 100000000 : Rat) /\
    (545698604517 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (267364761 / 50000000 : Rat) - (166474923 / 100000000 : Rat) /\
    (0 : Rat) < (545698604517 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_242 : K11RowValid 242 := by
  change (1 : Rat) <= (90572889 / 4000000 : Rat) /\
    (73932211231328106942443456371 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (177548709 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (392573659 / 25000000 : Rat) - (90572889 / 4000000 : Rat) /\
    (0 : Rat) < (73932211231328106942443456371 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_243 : K11RowValid 243 := by
  change (1 : Rat) <= (825503151 / 100000000 : Rat) /\
    (107728264085055037806429 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (606413691 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (32446749 / 4000000 : Rat) - (825503151 / 100000000 : Rat) /\
    (0 : Rat) < (107728264085055037806429 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_244 : K11RowValid 244 := by
  change (1 : Rat) <= (493477557 / 100000000 : Rat) /\
    (1608181897403 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (396271421 / 25000000 : Rat) - (493477557 / 100000000 : Rat) /\
    (0 : Rat) < (1608181897403 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_245 : K11RowValid 245 := by
  change (1 : Rat) <= (510377933 / 100000000 : Rat) /\
    (66553466214872354583537324713 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (40963703 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (317473377 / 100000000 : Rat) - (510377933 / 100000000 : Rat) /\
    (0 : Rat) < (66553466214872354583537324713 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_246 : K11RowValid 246 := by
  change (1 : Rat) <= (84719197 / 20000000 : Rat) /\
    (1379553383345309827976757 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (168284329 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (272675317 / 100000000 : Rat) - (84719197 / 20000000 : Rat) /\
    (0 : Rat) < (1379553383345309827976757 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_247 : K11RowValid 247 := by
  change (1 : Rat) <= (110435439 / 50000000 : Rat) /\
    (359498080481 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (70945327 / 10000000 : Rat) - (110435439 / 50000000 : Rat) /\
    (0 : Rat) < (359498080481 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_248 : K11RowValid 248 := by
  change (1 : Rat) <= (6320527 / 800000 : Rat) /\
    (20584415710032895599718769251 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (218794083 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (102639179 / 20000000 : Rat) - (6320527 / 800000 : Rat) /\
    (0 : Rat) < (20584415710032895599718769251 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_249 : K11RowValid 249 := by
  change (1 : Rat) <= (38359237 / 4000000 : Rat) /\
    (97803473846799952575309 / 16060352253125000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (704607001 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (29446029 / 3125000 : Rat) - (38359237 / 4000000 : Rat) /\
    (0 : Rat) < (97803473846799952575309 / 16060352253125000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_250 : K11RowValid 250 := by
  change (1 : Rat) <= (15581463 / 10000000 : Rat) /\
    (50752309177 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (250243943 / 50000000 : Rat) - (15581463 / 10000000 : Rat) /\
    (0 : Rat) < (50752309177 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_251 : K11RowValid 251 := by
  change (1 : Rat) <= (48052043 / 5000000 : Rat) /\
    (31362025256009768489301442973 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (201556819 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (159636917 / 25000000 : Rat) - (48052043 / 5000000 : Rat) /\
    (0 : Rat) < (31362025256009768489301442973 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_252 : K11RowValid 252 := by
  change (1 : Rat) <= (228929757 / 25000000 : Rat) /\
    (149425022121920316955577 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (266823077 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (53039737 / 5000000 : Rat) - (228929757 / 25000000 : Rat) /\
    (0 : Rat) < (149425022121920316955577 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_253 : K11RowValid 253 := by
  change (1 : Rat) <= (111413699 / 50000000 : Rat) /\
    (364235635021 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (178934439 / 25000000 : Rat) - (111413699 / 50000000 : Rat) /\
    (0 : Rat) < (364235635021 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_254 : K11RowValid 254 := by
  change (1 : Rat) <= (258253881 / 100000000 : Rat) /\
    (16886737023531800287574860451 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (220741137 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (67363979 / 50000000 : Rat) - (258253881 / 100000000 : Rat) /\
    (0 : Rat) < (16886737023531800287574860451 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_255 : K11RowValid 255 := by
  change (1 : Rat) <= (36603083 / 5000000 : Rat) /\
    (2388519927289364281973049 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1856707203 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (196222969 / 100000000 : Rat) - (36603083 / 5000000 : Rat) /\
    (0 : Rat) < (2388519927289364281973049 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_256 : K11RowValid 256 := by
  change (1 : Rat) <= (39894557 / 20000000 : Rat) /\
    (130431240403 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (320360523 / 50000000 : Rat) - (39894557 / 20000000 : Rat) /\
    (0 : Rat) < (130431240403 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_257 : K11RowValid 257 := by
  change (1 : Rat) <= (201539953 / 25000000 : Rat) /\
    (26338115263350285857370108497 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (60497153 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (126528713 / 25000000 : Rat) - (201539953 / 25000000 : Rat) /\
    (0 : Rat) < (26338115263350285857370108497 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_258 : K11RowValid 258 := by
  change (1 : Rat) <= (1004661183 / 100000000 : Rat) /\
    (3276873263724910559552587 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2157181873 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (424337547 / 100000000 : Rat) - (1004661183 / 100000000 : Rat) /\
    (0 : Rat) < (3276873263724910559552587 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_259 : K11RowValid 259 := by
  change (1 : Rat) <= (130867043 / 100000000 : Rat) /\
    (425950445997 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (105088607 / 25000000 : Rat) - (130867043 / 100000000 : Rat) /\
    (0 : Rat) < (425950445997 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_260 : K11RowValid 260 := by
  change (1 : Rat) <= (366239101 / 100000000 : Rat) /\
    (4782556949463372864023882493 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (112198431 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (23550997 / 10000000 : Rat) - (366239101 / 100000000 : Rat) /\
    (0 : Rat) < (4782556949463372864023882493 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_261 : K11RowValid 261 := by
  change (1 : Rat) <= (126397763 / 20000000 : Rat) /\
    (2060424617684052351468209 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (255631931 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (602370929 / 100000000 : Rat) - (126397763 / 20000000 : Rat) /\
    (0 : Rat) < (2060424617684052351468209 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_262 : K11RowValid 262 := by
  change (1 : Rat) <= (398956693 / 100000000 : Rat) /\
    (1299737008347 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1281477817 / 100000000 : Rat) - (398956693 / 100000000 : Rat) /\
    (0 : Rat) < (1299737008347 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_263 : K11RowValid 263 := by
  change (1 : Rat) <= (486376797 / 100000000 : Rat) /\
    (12689389663285207960801453211 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (131661687 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (45838019 / 20000000 : Rat) - (486376797 / 100000000 : Rat) /\
    (0 : Rat) < (12689389663285207960801453211 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_264 : K11RowValid 264 := by
  change (1 : Rat) <= (510624003 / 100000000 : Rat) /\
    (832956561874394883069703 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (181453441 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (181327943 / 50000000 : Rat) - (510624003 / 100000000 : Rat) /\
    (0 : Rat) < (832956561874394883069703 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_265 : K11RowValid 265 := by
  change (1 : Rat) <= (29865041 / 20000000 : Rat) /\
    (97755513439 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (59955423 / 12500000 : Rat) - (29865041 / 20000000 : Rat) /\
    (0 : Rat) < (97755513439 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_266 : K11RowValid 266 := by
  change (1 : Rat) <= (1175433967 / 100000000 : Rat) /\
    (76673692714041084612030871103 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (327668051 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (381519687 / 50000000 : Rat) - (1175433967 / 100000000 : Rat) /\
    (0 : Rat) < (76673692714041084612030871103 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_267 : K11RowValid 267 := by
  change (1 : Rat) <= (747679543 / 100000000 : Rat) /\
    (609919809847871891564929 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (526945293 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (185885249 / 25000000 : Rat) - (747679543 / 100000000 : Rat) /\
    (0 : Rat) < (609919809847871891564929 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_268 : K11RowValid 268 := by
  change (1 : Rat) <= (181208101 / 100000000 : Rat) /\
    (592582447179 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (582053557 / 100000000 : Rat) - (181208101 / 100000000 : Rat) /\
    (0 : Rat) < (592582447179 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_269 : K11RowValid 269 := by
  change (1 : Rat) <= (39318517 / 5000000 : Rat) /\
    (1208285215191116883291640753 / 241850010400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2870297 / 1562500 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (103667129 / 20000000 : Rat) - (39318517 / 5000000 : Rat) /\
    (0 : Rat) < (1208285215191116883291640753 / 241850010400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_270 : K11RowValid 270 := by
  change (1 : Rat) <= (510269631 / 100000000 : Rat) /\
    (1663465524407898135996459 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (246355919 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (454659179 / 100000000 : Rat) - (510269631 / 100000000 : Rat) /\
    (0 : Rat) < (1663465524407898135996459 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_271 : K11RowValid 271 := by
  change (1 : Rat) <= (373680201 / 100000000 : Rat) /\
    (1219814863079 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (600143947 / 50000000 : Rat) - (373680201 / 100000000 : Rat) /\
    (0 : Rat) < (1219814863079 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_272 : K11RowValid 272 := by
  change (1 : Rat) <= (209296709 / 20000000 : Rat) /\
    (266602092898369381985323251 / 40150880632812500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (170891451 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2610358 / 390625 : Rat) - (209296709 / 20000000 : Rat) /\
    (0 : Rat) < (266602092898369381985323251 / 40150880632812500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_273 : K11RowValid 273 := by
  change (1 : Rat) <= (517838891 / 100000000 : Rat) /\
    (1689730424997751024641773 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1065179641 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (237245613 / 100000000 : Rat) - (517838891 / 100000000 : Rat) /\
    (0 : Rat) < (1689730424997751024641773 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_274 : K11RowValid 274 := by
  change (1 : Rat) <= (175085561 / 50000000 : Rat) /\
    (570689278519 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1124775027 / 100000000 : Rat) - (175085561 / 50000000 : Rat) /\
    (0 : Rat) < (570689278519 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_275 : K11RowValid 275 := by
  change (1 : Rat) <= (720242803 / 100000000 : Rat) /\
    (1882230975971226805323453187 / 411145017680000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (30722783 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (9695723 / 2000000 : Rat) - (720242803 / 100000000 : Rat) /\
    (0 : Rat) < (1882230975971226805323453187 / 411145017680000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_276 : K11RowValid 276 := by
  change (1 : Rat) <= (1020773409 / 100000000 : Rat) /\
    (1664889211908437894748851 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (739687309 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (356850931 / 50000000 : Rat) - (1020773409 / 100000000 : Rat) /\
    (0 : Rat) < (1664889211908437894748851 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_277 : K11RowValid 277 := by
  change (1 : Rat) <= (144814911 / 50000000 : Rat) /\
    (472907217169 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (58144499 / 6250000 : Rat) - (144814911 / 50000000 : Rat) /\
    (0 : Rat) < (472907217169 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_278 : K11RowValid 278 := by
  change (1 : Rat) <= (352631943 / 20000000 : Rat) /\
    (57526483991201329796304845383 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (18771533 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (305025807 / 25000000 : Rat) - (352631943 / 20000000 : Rat) /\
    (0 : Rat) < (57526483991201329796304845383 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_279 : K11RowValid 279 := by
  change (1 : Rat) <= (389396577 / 100000000 : Rat) /\
    (636786876839334356681343 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (413558533 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (166030783 / 50000000 : Rat) - (389396577 / 100000000 : Rat) /\
    (0 : Rat) < (636786876839334356681343 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_280 : K11RowValid 280 := by
  change (1 : Rat) <= (71344249 / 25000000 : Rat) /\
    (232344108471 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (916651597 / 100000000 : Rat) - (71344249 / 25000000 : Rat) /\
    (0 : Rat) < (232344108471 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_281 : K11RowValid 281 := by
  change (1 : Rat) <= (86528309 / 25000000 : Rat) /\
    (11320154847324802458900161123 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (65340353 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (47048267 / 25000000 : Rat) - (86528309 / 25000000 : Rat) /\
    (0 : Rat) < (11320154847324802458900161123 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_282 : K11RowValid 282 := by
  change (1 : Rat) <= (423748507 / 100000000 : Rat) /\
    (1382333279815283085137919 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4190297 / 400000 : Rat) + (784931055601 / 1000000000000 : Rat) * (124357439 / 100000000 : Rat) - (423748507 / 100000000 : Rat) /\
    (0 : Rat) < (1382333279815283085137919 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_283 : K11RowValid 283 := by
  change (1 : Rat) <= (56131711 / 25000000 : Rat) /\
    (183606204369 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1442393 / 200000 : Rat) - (56131711 / 25000000 : Rat) /\
    (0 : Rat) < (183606204369 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_284 : K11RowValid 284 := by
  change (1 : Rat) <= (579760111 / 50000000 : Rat) /\
    (15129231409359575315779493463 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (403607937 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (73492127 / 10000000 : Rat) - (579760111 / 50000000 : Rat) /\
    (0 : Rat) < (15129231409359575315779493463 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_285 : K11RowValid 285 := by
  change (1 : Rat) <= (584654737 / 100000000 : Rat) /\
    (381176650454536021778191 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (9679387 / 1000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (72187471 / 20000000 : Rat) - (584654737 / 100000000 : Rat) /\
    (0 : Rat) < (381176650454536021778191 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_286 : K11RowValid 286 := by
  change (1 : Rat) <= (21541881 / 10000000 : Rat) /\
    (4140143047 / 3023125130000000 : Rat) = (1600000000 / 5139312721 : Rat) * (345970417 / 50000000 : Rat) - (21541881 / 10000000 : Rat) /\
    (0 : Rat) < (4140143047 / 3023125130000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_287 : K11RowValid 287 := by
  change (1 : Rat) <= (268461729 / 50000000 : Rat) /\
    (34949316478454393178877100799 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (9855177 / 6250000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (173387271 / 50000000 : Rat) - (268461729 / 50000000 : Rat) /\
    (0 : Rat) < (34949316478454393178877100799 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_288 : K11RowValid 288 := by
  change (1 : Rat) <= (595310571 / 25000000 : Rat) /\
    (1942583920887045955273797 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (226554577 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (713495557 / 25000000 : Rat) - (595310571 / 25000000 : Rat) /\
    (0 : Rat) < (1942583920887045955273797 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_289 : K11RowValid 289 := by
  change (1 : Rat) <= (347601 / 160000 : Rat) /\
    (1134227679 / 822290035360000 : Rat) = (1600000000 / 5139312721 : Rat) * (174456189 / 25000000 : Rat) - (347601 / 160000 : Rat) /\
    (0 : Rat) < (1134227679 / 822290035360000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_290 : K11RowValid 290 := by
  change (1 : Rat) <= (421433049 / 50000000 : Rat) /\
    (109955733533853499467389708867 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (359352881 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (519622443 / 100000000 : Rat) - (421433049 / 50000000 : Rat) /\
    (0 : Rat) < (109955733533853499467389708867 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_291 : K11RowValid 291 := by
  change (1 : Rat) <= (361270243 / 100000000 : Rat) /\
    (235814531625342264455451 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (612235897 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (43485531 / 20000000 : Rat) - (361270243 / 100000000 : Rat) /\
    (0 : Rat) < (235814531625342264455451 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_292 : K11RowValid 292 := by
  change (1 : Rat) <= (112094789 / 50000000 : Rat) /\
    (365734489131 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (90014147 / 12500000 : Rat) - (112094789 / 50000000 : Rat) /\
    (0 : Rat) < (365734489131 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_293 : K11RowValid 293 := by
  change (1 : Rat) <= (209809699 / 12500000 : Rat) /\
    (219164964652311689316517117143 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (77777541 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1124290847 / 100000000 : Rat) - (209809699 / 12500000 : Rat) /\
    (0 : Rat) < (219164964652311689316517117143 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_294 : K11RowValid 294 := by
  change (1 : Rat) <= (50466139 / 5000000 : Rat) /\
    (3289573079540785013194719 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (365225069 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (996158239 / 100000000 : Rat) - (50466139 / 5000000 : Rat) /\
    (0 : Rat) < (3289573079540785013194719 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_295 : K11RowValid 295 := by
  change (1 : Rat) <= (9111019 / 6250000 : Rat) /\
    (29852027301 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (468244057 / 100000000 : Rat) - (9111019 / 6250000 : Rat) /\
    (0 : Rat) < (29852027301 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_296 : K11RowValid 296 := by
  change (1 : Rat) <= (513524947 / 12500000 : Rat) /\
    (268073747315299945811451391599 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (150114473 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1443540471 / 50000000 : Rat) - (513524947 / 12500000 : Rat) /\
    (0 : Rat) < (268073747315299945811451391599 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_297 : K11RowValid 297 := by
  change (1 : Rat) <= (2244363 / 390625 : Rat) /\
    (1875782605772445107950849 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (199632423 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (573624769 / 100000000 : Rat) - (2244363 / 390625 : Rat) /\
    (0 : Rat) < (1875782605772445107950849 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_298 : K11RowValid 298 := by
  change (1 : Rat) <= (396104867 / 100000000 : Rat) /\
    (1293376886893 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1272317547 / 100000000 : Rat) - (396104867 / 100000000 : Rat) /\
    (0 : Rat) < (1293376886893 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_299 : K11RowValid 299 := by
  change (1 : Rat) <= (1356088 / 390625 : Rat) /\
    (45297170052195711042457186701 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (246611989 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (192200229 / 100000000 : Rat) - (1356088 / 390625 : Rat) /\
    (0 : Rat) < (45297170052195711042457186701 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_300 : K11RowValid 300 := by
  change (1 : Rat) <= (463271741 / 100000000 : Rat) /\
    (302582429768568037662653 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (137699171 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (30656893 / 20000000 : Rat) - (463271741 / 100000000 : Rat) /\
    (0 : Rat) < (302582429768568037662653 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_301 : K11RowValid 301 := by
  change (1 : Rat) <= (211118373 / 100000000 : Rat) /\
    (690404277067 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (678127519 / 100000000 : Rat) - (211118373 / 100000000 : Rat) /\
    (0 : Rat) < (690404277067 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_302 : K11RowValid 302 := by
  change (1 : Rat) <= (13766823 / 1562500 : Rat) /\
    (115196338766806943348530952899 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (175426263 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (587488171 / 100000000 : Rat) - (13766823 / 1562500 : Rat) /\
    (0 : Rat) < (115196338766806943348530952899 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_303 : K11RowValid 303 := by
  change (1 : Rat) <= (2858589509 / 100000000 : Rat) /\
    (1166183547591297979080621 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (6598129027 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (128104301 / 12500000 : Rat) - (2858589509 / 100000000 : Rat) /\
    (0 : Rat) < (1166183547591297979080621 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_304 : K11RowValid 304 := by
  change (1 : Rat) <= (7049327 / 4000000 : Rat) /\
    (1359671249 / 1209250052000000 : Rat) = (1600000000 / 5139312721 : Rat) * (113214747 / 20000000 : Rat) - (7049327 / 4000000 : Rat) /\
    (0 : Rat) < (1359671249 / 1209250052000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_305 : K11RowValid 305 := by
  change (1 : Rat) <= (484250239 / 25000000 : Rat) /\
    (252885302089758339123829951987 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (80953283 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1341080923 / 100000000 : Rat) - (484250239 / 25000000 : Rat) /\
    (0 : Rat) < (252885302089758339123829951987 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_306 : K11RowValid 306 := by
  change (1 : Rat) <= (101717699 / 20000000 : Rat) /\
    (48772071070988917443583 / 15115625650000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (142003533 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (267647791 / 50000000 : Rat) - (101717699 / 20000000 : Rat) /\
    (0 : Rat) < (48772071070988917443583 / 15115625650000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_307 : K11RowValid 307 := by
  change (1 : Rat) <= (226713843 / 100000000 : Rat) /\
    (739443303197 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (364110649 / 50000000 : Rat) - (226713843 / 100000000 : Rat) /\
    (0 : Rat) < (739443303197 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_308 : K11RowValid 308 := by
  change (1 : Rat) <= (22434587 / 6250000 : Rat) /\
    (46954897753354306130814902933 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (183957219 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (173739757 / 100000000 : Rat) - (22434587 / 6250000 : Rat) /\
    (0 : Rat) < (46954897753354306130814902933 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_309 : K11RowValid 309 := by
  change (1 : Rat) <= (222263387 / 50000000 : Rat) /\
    (1453350816471473268074541 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (131494237 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (149091821 / 100000000 : Rat) - (222263387 / 50000000 : Rat) /\
    (0 : Rat) < (1453350816471473268074541 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_310 : K11RowValid 310 := by
  change (1 : Rat) <= (4002217 / 2500000 : Rat) /\
    (13019697543 / 12848281802500000 : Rat) = (1600000000 / 5139312721 : Rat) * (128554111 / 25000000 : Rat) - (4002217 / 2500000 : Rat) /\
    (0 : Rat) < (13019697543 / 12848281802500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_311 : K11RowValid 311 := by
  change (1 : Rat) <= (288431837 / 20000000 : Rat) /\
    (188249891612752259103655219927 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (119131581 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (919697183 / 100000000 : Rat) - (288431837 / 20000000 : Rat) /\
    (0 : Rat) < (188249891612752259103655219927 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_312 : K11RowValid 312 := by
  change (1 : Rat) <= (51137757 / 6250000 : Rat) /\
    (1333836026052872036952721 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (310669727 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (213144401 / 50000000 : Rat) - (51137757 / 6250000 : Rat) /\
    (0 : Rat) < (1333836026052872036952721 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_313 : K11RowValid 313 := by
  change (1 : Rat) <= (12286987 / 10000000 : Rat) /\
    (40208138373 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (39466693 / 10000000 : Rat) - (12286987 / 10000000 : Rat) /\
    (0 : Rat) < (40208138373 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_314 : K11RowValid 314 := by
  change (1 : Rat) <= (106093691 / 12500000 : Rat) /\
    (13822323567673963538201933993 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (86052363 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (65894497 / 12500000 : Rat) - (106093691 / 12500000 : Rat) /\
    (0 : Rat) < (13822323567673963538201933993 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_315 : K11RowValid 315 := by
  change (1 : Rat) <= (802838019 / 100000000 : Rat) /\
    (2618797530407387545677309 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (539815683 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (808708029 / 100000000 : Rat) - (802838019 / 100000000 : Rat) /\
    (0 : Rat) < (2618797530407387545677309 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_316 : K11RowValid 316 := by
  change (1 : Rat) <= (168088071 / 50000000 : Rat) /\
    (548861348809 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (539911069 / 50000000 : Rat) - (168088071 / 50000000 : Rat) /\
    (0 : Rat) < (548861348809 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_317 : K11RowValid 317 := by
  change (1 : Rat) <= (323589629 / 100000000 : Rat) /\
    (21041116129073181905509926767 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (437946527 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (66551543 / 50000000 : Rat) - (323589629 / 100000000 : Rat) /\
    (0 : Rat) < (21041116129073181905509926767 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_318 : K11RowValid 318 := by
  change (1 : Rat) <= (664807277 / 100000000 : Rat) /\
    (271168546498811528463593 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (55439049 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (61893033 / 12500000 : Rat) - (664807277 / 100000000 : Rat) /\
    (0 : Rat) < (271168546498811528463593 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_319 : K11RowValid 319 := by
  change (1 : Rat) <= (31843893 / 25000000 : Rat) /\
    (104418937147 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (102284893 / 25000000 : Rat) - (31843893 / 25000000 : Rat) /\
    (0 : Rat) < (104418937147 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_320 : K11RowValid 320 := by
  change (1 : Rat) <= (824025207 / 50000000 : Rat) /\
    (26891442925307292118989333067 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (44596871 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (141504243 / 12500000 : Rat) - (824025207 / 50000000 : Rat) /\
    (0 : Rat) < (26891442925307292118989333067 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_321 : K11RowValid 321 := by
  change (1 : Rat) <= (928090813 / 100000000 : Rat) /\
    (3030263693102193389901399 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (31169411 / 4000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (873319319 / 100000000 : Rat) - (928090813 / 100000000 : Rat) /\
    (0 : Rat) < (3030263693102193389901399 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_322 : K11RowValid 322 := by
  change (1 : Rat) <= (73115811 / 50000000 : Rat) /\
    (238421468269 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (46970657 / 10000000 : Rat) - (73115811 / 50000000 : Rat) /\
    (0 : Rat) < (238421468269 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_323 : K11RowValid 323 := by
  change (1 : Rat) <= (1875134691 / 100000000 : Rat) /\
    (244925970524687670018183788009 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (21790537 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1294355361 / 100000000 : Rat) - (1875134691 / 100000000 : Rat) /\
    (0 : Rat) < (244925970524687670018183788009 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_324 : K11RowValid 324 := by
  change (1 : Rat) <= (32446749 / 4000000 : Rat) /\
    (330709574836352795926653 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (12734859 / 1000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (66040893 / 12500000 : Rat) - (32446749 / 4000000 : Rat) /\
    (0 : Rat) < (330709574836352795926653 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_325 : K11RowValid 325 := by
  change (1 : Rat) <= (206814463 / 50000000 : Rat) /\
    (674617316177 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (664303047 / 50000000 : Rat) - (206814463 / 50000000 : Rat) /\
    (0 : Rat) < (674617316177 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_326 : K11RowValid 326 := by
  change (1 : Rat) <= (26744301 / 3125000 : Rat) /\
    (27957167856697876974154197359 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (238537447 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (138891511 / 25000000 : Rat) - (26744301 / 3125000 : Rat) /\
    (0 : Rat) < (27957167856697876974154197359 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_327 : K11RowValid 327 := by
  change (1 : Rat) <= (262378527 / 50000000 : Rat) /\
    (1711840906874372459287537 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (366049459 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (378168497 / 100000000 : Rat) - (262378527 / 50000000 : Rat) /\
    (0 : Rat) < (1711840906874372459287537 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_328 : K11RowValid 328 := by
  change (1 : Rat) <= (272675317 / 100000000 : Rat) /\
    (890639192443 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (175170577 / 20000000 : Rat) - (272675317 / 100000000 : Rat) /\
    (0 : Rat) < (890639192443 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_329 : K11RowValid 329 := by
  change (1 : Rat) <= (932026097 / 100000000 : Rat) /\
    (121662500844640809728955047739 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (120799771 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (635794531 / 100000000 : Rat) - (932026097 / 100000000 : Rat) /\
    (0 : Rat) < (121662500844640809728955047739 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_330 : K11RowValid 330 := by
  change (1 : Rat) <= (893671401 / 50000000 : Rat) /\
    (1457508109761595750015603 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (35661607 / 5000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (498545843 / 25000000 : Rat) - (893671401 / 50000000 : Rat) /\
    (0 : Rat) < (1457508109761595750015603 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_331 : K11RowValid 331 := by
  change (1 : Rat) <= (153550447 / 100000000 : Rat) /\
    (500017663713 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (246607583 / 50000000 : Rat) - (153550447 / 100000000 : Rat) /\
    (0 : Rat) < (500017663713 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_332 : K11RowValid 332 := by
  change (1 : Rat) <= (1081699741 / 100000000 : Rat) /\
    (141295056491361629676468163977 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (46828571 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (727469633 / 100000000 : Rat) - (1081699741 / 100000000 : Rat) /\
    (0 : Rat) < (141295056491361629676468163977 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_333 : K11RowValid 333 := by
  change (1 : Rat) <= (290751649 / 50000000 : Rat) /\
    (946932117704741042907743 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (294723737 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (311969183 / 50000000 : Rat) - (290751649 / 50000000 : Rat) /\
    (0 : Rat) < (946932117704741042907743 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_334 : K11RowValid 334 := by
  change (1 : Rat) <= (36559599 / 12500000 : Rat) /\
    (119584641121 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (939456659 / 100000000 : Rat) - (36559599 / 12500000 : Rat) /\
    (0 : Rat) < (119584641121 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_335 : K11RowValid 335 := by
  change (1 : Rat) <= (117748041 / 50000000 : Rat) /\
    (30776004095624981420888707837 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (227677579 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (117015573 / 100000000 : Rat) - (117748041 / 50000000 : Rat) /\
    (0 : Rat) < (30776004095624981420888707837 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_336 : K11RowValid 336 := by
  change (1 : Rat) <= (1145211813 / 100000000 : Rat) /\
    (233765072178318658662327 / 32120704506250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (190104719 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (15786487 / 6250000 : Rat) - (1145211813 / 100000000 : Rat) /\
    (0 : Rat) < (233765072178318658662327 / 32120704506250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_337 : K11RowValid 337 := by
  change (1 : Rat) <= (269092033 / 100000000 : Rat) /\
    (878883348207 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (864343117 / 100000000 : Rat) - (269092033 / 100000000 : Rat) /\
    (0 : Rat) < (878883348207 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_338 : K11RowValid 338 := by
  change (1 : Rat) <= (695448579 / 100000000 : Rat) /\
    (18154882195607836128450126543 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (33460867 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (87023447 / 20000000 : Rat) - (695448579 / 100000000 : Rat) /\
    (0 : Rat) < (18154882195607836128450126543 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_339 : K11RowValid 339 := by
  change (1 : Rat) <= (178994081 / 25000000 : Rat) /\
    (2339211070070664868711193 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (625023631 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (416348633 / 100000000 : Rat) - (178994081 / 25000000 : Rat) /\
    (0 : Rat) < (2339211070070664868711193 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_340 : K11RowValid 340 := by
  change (1 : Rat) <= (203296077 / 100000000 : Rat) /\
    (662944504483 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (81625217 / 12500000 : Rat) - (203296077 / 100000000 : Rat) /\
    (0 : Rat) < (662944504483 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_341 : K11RowValid 341 := by
  change (1 : Rat) <= (793776501 / 100000000 : Rat) /\
    (20721371627576941284080380011 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (226283701 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (102835219 / 20000000 : Rat) - (793776501 / 100000000 : Rat) /\
    (0 : Rat) < (20721371627576941284080380011 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_342 : K11RowValid 342 := by
  change (1 : Rat) <= (540617013 / 50000000 : Rat) /\
    (1765580234936745679598051 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (95110661 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (594436131 / 50000000 : Rat) - (540617013 / 50000000 : Rat) /\
    (0 : Rat) < (1765580234936745679598051 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_343 : K11RowValid 343 := by
  change (1 : Rat) <= (199972667 / 50000000 : Rat) /\
    (651834603093 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (321163351 / 25000000 : Rat) - (199972667 / 50000000 : Rat) /\
    (0 : Rat) < (651834603093 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_344 : K11RowValid 344 := by
  change (1 : Rat) <= (424337547 / 100000000 : Rat) /\
    (55379002426931838337972302329 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (97016069 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (215758641 / 100000000 : Rat) - (424337547 / 100000000 : Rat) /\
    (0 : Rat) < (55379002426931838337972302329 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_345 : K11RowValid 345 := by
  change (1 : Rat) <= (648072023 / 100000000 : Rat) /\
    (2115197498165815385220441 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (739062133 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (532509721 / 100000000 : Rat) - (648072023 / 100000000 : Rat) /\
    (0 : Rat) < (2115197498165815385220441 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_346 : K11RowValid 346 := by
  change (1 : Rat) <= (1296313 / 800000 : Rat) /\
    (4233502327 / 4111450176800000 : Rat) = (1600000000 / 5139312721 : Rat) * (65060177 / 12500000 : Rat) - (1296313 / 800000 : Rat) /\
    (0 : Rat) < (4233502327 / 4111450176800000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_347 : K11RowValid 347 := by
  change (1 : Rat) <= (1654383033 / 100000000 : Rat) /\
    (43183305101957012788419226769 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (40778863 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (220763401 / 20000000 : Rat) - (1654383033 / 100000000 : Rat) /\
    (0 : Rat) < (43183305101957012788419226769 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_348 : K11RowValid 348 := by
  change (1 : Rat) <= (637411059 / 100000000 : Rat) /\
    (416254780871549166135211 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (26336071 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (128986091 / 20000000 : Rat) - (637411059 / 100000000 : Rat) /\
    (0 : Rat) < (416254780871549166135211 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_349 : K11RowValid 349 := by
  change (1 : Rat) <= (264063583 / 100000000 : Rat) /\
    (859135260657 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (848191369 / 100000000 : Rat) - (264063583 / 100000000 : Rat) /\
    (0 : Rat) < (859135260657 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_350 : K11RowValid 350 := by
  change (1 : Rat) <= (843988003 / 100000000 : Rat) /\
    (110142662605216788016276866479 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (161959789 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (564103991 / 100000000 : Rat) - (843988003 / 100000000 : Rat) /\
    (0 : Rat) < (110142662605216788016276866479 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_351 : K11RowValid 351 := by
  change (1 : Rat) <= (569269973 / 100000000 : Rat) /\
    (11593181174189628185817 / 3212070450625000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (103563283 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (3249177 / 625000 : Rat) - (569269973 / 100000000 : Rat) /\
    (0 : Rat) < (11593181174189628185817 / 3212070450625000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_352 : K11RowValid 352 := by
  change (1 : Rat) <= (51753539 / 12500000 : Rat) /\
    (169060530381 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (166236119 / 12500000 : Rat) - (51753539 / 12500000 : Rat) /\
    (0 : Rat) < (169060530381 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_353 : K11RowValid 353 := by
  change (1 : Rat) <= (18856489 / 4000000 : Rat) /\
    (30727060741384900192981356569 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (263920307 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (138347601 / 50000000 : Rat) - (18856489 / 4000000 : Rat) /\
    (0 : Rat) < (30727060741384900192981356569 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_354 : K11RowValid 354 := by
  change (1 : Rat) <= (771986013 / 100000000 : Rat) /\
    (2520631548333728605755879 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2039332507 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (174652199 / 100000000 : Rat) - (771986013 / 100000000 : Rat) /\
    (0 : Rat) < (2520631548333728605755879 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_355 : K11RowValid 355 := by
  change (1 : Rat) <= (11364603 / 2000000 : Rat) /\
    (37088985237 / 10278625442000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1825196433 / 100000000 : Rat) - (11364603 / 2000000 : Rat) /\
    (0 : Rat) < (37088985237 / 10278625442000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_356 : K11RowValid 356 := by
  change (1 : Rat) <= (810183363 / 100000000 : Rat) /\
    (26428789938721499112407205829 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (187415603 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (133610141 / 25000000 : Rat) - (810183363 / 100000000 : Rat) /\
    (0 : Rat) < (26428789938721499112407205829 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_357 : K11RowValid 357 := by
  change (1 : Rat) <= (1285526623 / 100000000 : Rat) /\
    (838478747501938830958071 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2862555117 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (100477751 / 20000000 : Rat) - (1285526623 / 100000000 : Rat) /\
    (0 : Rat) < (838478747501938830958071 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_358 : K11RowValid 358 := by
  change (1 : Rat) <= (256972313 / 100000000 : Rat) /\
    (836454306327 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (12897089 / 1562500 : Rat) - (256972313 / 100000000 : Rat) /\
    (0 : Rat) < (836454306327 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_359 : K11RowValid 359 := by
  change (1 : Rat) <= (3109421231 / 100000000 : Rat) /\
    (50746713392043355184749340949 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (128466617 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (272736621 / 12500000 : Rat) - (3109421231 / 100000000 : Rat) /\
    (0 : Rat) < (50746713392043355184749340949 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_360 : K11RowValid 360 := by
  change (1 : Rat) <= (240702451 / 50000000 : Rat) /\
    (1572354651986038178483211 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (27124723 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (441174091 / 100000000 : Rat) - (240702451 / 50000000 : Rat) /\
    (0 : Rat) < (1572354651986038178483211 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_361 : K11RowValid 361 := by
  change (1 : Rat) <= (211108281 / 50000000 : Rat) /\
    (689148257399 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (339047551 / 25000000 : Rat) - (211108281 / 50000000 : Rat) /\
    (0 : Rat) < (689148257399 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_362 : K11RowValid 362 := by
  change (1 : Rat) <= (340690133 / 100000000 : Rat) /\
    (11089244566918427989058871509 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (381696001 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (39426861 / 25000000 : Rat) - (340690133 / 100000000 : Rat) /\
    (0 : Rat) < (11089244566918427989058871509 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_363 : K11RowValid 363 := by
  change (1 : Rat) <= (302754471 / 50000000 : Rat) /\
    (1976672132090422643490397 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1593374583 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (139440157 / 100000000 : Rat) - (302754471 / 50000000 : Rat) /\
    (0 : Rat) < (1976672132090422643490397 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_364 : K11RowValid 364 := by
  change (1 : Rat) <= (237245613 / 100000000 : Rat) /\
    (772707657027 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (381025053 / 50000000 : Rat) - (237245613 / 100000000 : Rat) /\
    (0 : Rat) < (772707657027 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_365 : K11RowValid 365 := by
  change (1 : Rat) <= (1185319489 / 100000000 : Rat) /\
    (4557137124614792629003488753 / 604625026000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (200261037 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (399131129 / 50000000 : Rat) - (1185319489 / 100000000 : Rat) /\
    (0 : Rat) < (4557137124614792629003488753 / 604625026000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_366 : K11RowValid 366 := by
  change (1 : Rat) <= (777775367 / 100000000 : Rat) /\
    (101546061744771988910349 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (240954703 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (24344269 / 4000000 : Rat) - (777775367 / 100000000 : Rat) /\
    (0 : Rat) < (101546061744771988910349 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_367 : K11RowValid 367 := by
  change (1 : Rat) <= (277807659 / 100000000 : Rat) /\
    (904910069861 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (446169169 / 50000000 : Rat) - (277807659 / 100000000 : Rat) /\
    (0 : Rat) < (904910069861 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_368 : K11RowValid 368 := by
  change (1 : Rat) <= (717066751 / 100000000 : Rat) /\
    (93498810789709881762177955921 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (28756041 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (477905609 / 100000000 : Rat) - (717066751 / 100000000 : Rat) /\
    (0 : Rat) < (93498810789709881762177955921 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_369 : K11RowValid 369 := by
  change (1 : Rat) <= (27141179 / 3125000 : Rat) /\
    (2837906112773552732903697 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (540487331 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (892117457 / 100000000 : Rat) - (27141179 / 3125000 : Rat) /\
    (0 : Rat) < (2837906112773552732903697 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_370 : K11RowValid 370 := by
  change (1 : Rat) <= (27451879 / 10000000 : Rat) /\
    (89679947241 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (440887127 / 50000000 : Rat) - (27451879 / 10000000 : Rat) /\
    (0 : Rat) < (89679947241 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_371 : K11RowValid 371 := by
  change (1 : Rat) <= (84428121 / 20000000 : Rat) /\
    (27611774685415191494235457191 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (35790711 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (110435439 / 50000000 : Rat) - (84428121 / 20000000 : Rat) /\
    (0 : Rat) < (27611774685415191494235457191 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_372 : K11RowValid 372 := by
  change (1 : Rat) <= (33973791 / 10000000 : Rat) /\
    (276428321477069896010041 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (149608777 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (48867321 / 25000000 : Rat) - (33973791 / 10000000 : Rat) /\
    (0 : Rat) < (276428321477069896010041 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_373 : K11RowValid 373 := by
  change (1 : Rat) <= (154626413 / 100000000 : Rat) /\
    (505466500227 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (31041953 / 6250000 : Rat) - (154626413 / 100000000 : Rat) /\
    (0 : Rat) < (505466500227 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_374 : K11RowValid 374 := by
  change (1 : Rat) <= (1433847089 / 100000000 : Rat) /\
    (7481236276526510636881355053 / 822290035360000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (136158811 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (38359237 / 4000000 : Rat) - (1433847089 / 100000000 : Rat) /\
    (0 : Rat) < (7481236276526510636881355053 / 822290035360000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_375 : K11RowValid 375 := by
  change (1 : Rat) <= (438143711 / 50000000 : Rat) /\
    (714927644928752373566849 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (436561901 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (192520769 / 25000000 : Rat) - (438143711 / 50000000 : Rat) /\
    (0 : Rat) < (714927644928752373566849 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_376 : K11RowValid 376 := by
  change (1 : Rat) <= (124357439 / 100000000 : Rat) /\
    (406196318481 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (399445109 / 100000000 : Rat) - (124357439 / 100000000 : Rat) /\
    (0 : Rat) < (406196318481 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_377 : K11RowValid 377 := by
  change (1 : Rat) <= (349746157 / 25000000 : Rat) /\
    (9126627629633674775089511267 / 1027862544200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (151028737 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (48052043 / 5000000 : Rat) - (349746157 / 25000000 : Rat) /\
    (0 : Rat) < (9126627629633674775089511267 / 1027862544200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_378 : K11RowValid 378 := by
  change (1 : Rat) <= (583801051 / 100000000 : Rat) /\
    (59524778676386833894433 / 16060352253125000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (5662069 / 1562500 : Rat) + (784931055601 / 1000000000000 : Rat) * (18751073 / 3125000 : Rat) - (583801051 / 100000000 : Rat) /\
    (0 : Rat) < (59524778676386833894433 / 16060352253125000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_379 : K11RowValid 379 := by
  change (1 : Rat) <= (596162993 / 100000000 : Rat) /\
    (1944685666047 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1914918749 / 100000000 : Rat) - (596162993 / 100000000 : Rat) /\
    (0 : Rat) < (1944685666047 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_380 : K11RowValid 380 := by
  change (1 : Rat) <= (72187471 / 20000000 : Rat) /\
    (4723328832519880069834776921 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (273040601 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (19614609 / 10000000 : Rat) - (72187471 / 20000000 : Rat) /\
    (0 : Rat) < (4723328832519880069834776921 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_381 : K11RowValid 381 := by
  change (1 : Rat) <= (714532763 / 100000000 : Rat) /\
    (2332148939394927090914293 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1976949469 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (126199733 / 100000000 : Rat) - (714532763 / 100000000 : Rat) /\
    (0 : Rat) < (2332148939394927090914293 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_382 : K11RowValid 382 := by
  change (1 : Rat) <= (214202923 / 100000000 : Rat) /\
    (696950716517 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (137607063 / 20000000 : Rat) - (214202923 / 100000000 : Rat) /\
    (0 : Rat) < (696950716517 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_383 : K11RowValid 383 := by
  change (1 : Rat) <= (1005572741 / 100000000 : Rat) /\
    (65584874624144977060370208459 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (123818827 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (343703411 / 50000000 : Rat) - (1005572741 / 100000000 : Rat) /\
    (0 : Rat) < (65584874624144977060370208459 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_384 : K11RowValid 384 := by
  change (1 : Rat) <= (713495557 / 25000000 : Rat) /\
    (9312543385139423292636757 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1692916369 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (950135317 / 100000000 : Rat) - (713495557 / 25000000 : Rat) /\
    (0 : Rat) < (9312543385139423292636757 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_385 : K11RowValid 385 := by
  change (1 : Rat) <= (106616009 / 50000000 : Rat) /\
    (348684049511 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (6849167 / 1000000 : Rat) - (106616009 / 50000000 : Rat) /\
    (0 : Rat) < (348684049511 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_386 : K11RowValid 386 := by
  change (1 : Rat) <= (547214201 / 50000000 : Rat) /\
    (247298198704502200850607879 / 35566178000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (227006899 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (363866799 / 50000000 : Rat) - (547214201 / 50000000 : Rat) /\
    (0 : Rat) < (247298198704502200850607879 / 35566178000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_387 : K11RowValid 387 := by
  change (1 : Rat) <= (448886023 / 100000000 : Rat) /\
    (1463298698380560478175117 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (290694117 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (456582477 / 100000000 : Rat) - (448886023 / 100000000 : Rat) /\
    (0 : Rat) < (1463298698380560478175117 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_388 : K11RowValid 388 := by
  change (1 : Rat) <= (30150681 / 12500000 : Rat) /\
    (98389886999 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (96846173 / 12500000 : Rat) - (30150681 / 12500000 : Rat) /\
    (0 : Rat) < (98389886999 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_389 : K11RowValid 389 := by
  change (1 : Rat) <= (83931069 / 25000000 : Rat) /\
    (43931390034910907943865246267 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (243513901 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (130867043 / 100000000 : Rat) - (83931069 / 25000000 : Rat) /\
    (0 : Rat) < (43931390034910907943865246267 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_390 : K11RowValid 390 := by
  change (1 : Rat) <= (14122161 / 3125000 : Rat) /\
    (295148263018835902330701 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1011848439 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (34880781 / 20000000 : Rat) - (14122161 / 3125000 : Rat) /\
    (0 : Rat) < (295148263018835902330701 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_391 : K11RowValid 391 := by
  change (1 : Rat) <= (74749379 / 50000000 : Rat) /\
    (244818449741 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (480200849 / 100000000 : Rat) - (74749379 / 50000000 : Rat) /\
    (0 : Rat) < (244818449741 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_392 : K11RowValid 392 := by
  change (1 : Rat) <= (996158239 / 100000000 : Rat) /\
    (63511452611476616382445363 / 10037720158203125000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (356591217 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2457816 / 390625 : Rat) - (996158239 / 100000000 : Rat) /\
    (0 : Rat) < (63511452611476616382445363 / 10037720158203125000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_393 : K11RowValid 393 := by
  change (1 : Rat) <= (95156937 / 10000000 : Rat) /\
    (24234309019988021850843 / 4015088063281250000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (135356869 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2760283 / 781250 : Rat) - (95156937 / 10000000 : Rat) /\
    (0 : Rat) < (24234309019988021850843 / 4015088063281250000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_394 : K11RowValid 394 := by
  change (1 : Rat) <= (113329033 / 50000000 : Rat) /\
    (368644471207 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (728042137 / 100000000 : Rat) - (113329033 / 50000000 : Rat) /\
    (0 : Rat) < (368644471207 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_395 : K11RowValid 395 := by
  change (1 : Rat) <= (730506137 / 100000000 : Rat) /\
    (95424292302729835170540180427 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (197811 / 100000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (475501683 / 100000000 : Rat) - (730506137 / 100000000 : Rat) /\
    (0 : Rat) < (95424292302729835170540180427 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_396 : K11RowValid 396 := by
  change (1 : Rat) <= (342213337 / 50000000 : Rat) /\
    (2233459630192211527463637 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (249762531 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (673832597 / 100000000 : Rat) - (342213337 / 50000000 : Rat) /\
    (0 : Rat) < (2233459630192211527463637 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_397 : K11RowValid 397 := by
  change (1 : Rat) <= (256673861 / 100000000 : Rat) /\
    (839414514219 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (824455049 / 100000000 : Rat) - (256673861 / 100000000 : Rat) /\
    (0 : Rat) < (839414514219 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_398 : K11RowValid 398 := by
  change (1 : Rat) <= (446353389 / 100000000 : Rat) /\
    (58206944655021483418255243373 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (791128331 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (142208517 / 100000000 : Rat) - (446353389 / 100000000 : Rat) /\
    (0 : Rat) < (58206944655021483418255243373 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_399 : K11RowValid 399 := by
  change (1 : Rat) <= (443375057 / 100000000 : Rat) /\
    (1448377346772610148558089 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (941657427 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (191371209 / 100000000 : Rat) - (443375057 / 100000000 : Rat) /\
    (0 : Rat) < (1448377346772610148558089 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_400 : K11RowValid 400 := by
  change (1 : Rat) <= (30656893 / 20000000 : Rat) /\
    (99978764147 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (492360813 / 100000000 : Rat) - (30656893 / 20000000 : Rat) /\
    (0 : Rat) < (99978764147 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_401 : K11RowValid 401 := by
  change (1 : Rat) <= (1096010563 / 100000000 : Rat) /\
    (143204567774836002237356558767 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (17745011 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (747679543 / 100000000 : Rat) - (1096010563 / 100000000 : Rat) /\
    (0 : Rat) < (143204567774836002237356558767 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_402 : K11RowValid 402 := by
  change (1 : Rat) <= (788336689 / 50000000 : Rat) /\
    (1029100198762046134638669 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (596498067 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (354418189 / 20000000 : Rat) - (788336689 / 50000000 : Rat) /\
    (0 : Rat) < (1029100198762046134638669 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_403 : K11RowValid 403 := by
  change (1 : Rat) <= (373727397 / 100000000 : Rat) /\
    (1221611682763 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (300109873 / 25000000 : Rat) - (373727397 / 100000000 : Rat) /\
    (0 : Rat) < (1221611682763 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_404 : K11RowValid 404 := by
  change (1 : Rat) <= (575594987 / 50000000 : Rat) /\
    (15042201756663173256548610237 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (78779107 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (78345173 / 10000000 : Rat) - (575594987 / 50000000 : Rat) /\
    (0 : Rat) < (15042201756663173256548610237 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_405 : K11RowValid 405 := by
  change (1 : Rat) <= (813048469 / 100000000 : Rat) /\
    (531071951544139512800381 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (483066843 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (168844861 / 20000000 : Rat) - (813048469 / 100000000 : Rat) /\
    (0 : Rat) < (531071951544139512800381 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_406 : K11RowValid 406 := by
  change (1 : Rat) <= (59275871 / 12500000 : Rat) /\
    (193321345009 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (380796789 / 25000000 : Rat) - (59275871 / 12500000 : Rat) /\
    (0 : Rat) < (193321345009 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_407 : K11RowValid 407 := by
  change (1 : Rat) <= (3013779 / 500000 : Rat) /\
    (39361224020793990172196428759 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (319663273 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (178862111 / 50000000 : Rat) - (3013779 / 500000 : Rat) /\
    (0 : Rat) < (39361224020793990172196428759 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_408 : K11RowValid 408 := by
  change (1 : Rat) <= (267647791 / 50000000 : Rat) /\
    (218492572048175862589597 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (171295671 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (51275357 / 12500000 : Rat) - (267647791 / 50000000 : Rat) /\
    (0 : Rat) < (218492572048175862589597 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_409 : K11RowValid 409 := by
  change (1 : Rat) <= (169432633 / 50000000 : Rat) /\
    (32533563271 / 15115625650000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1088459799 / 100000000 : Rat) - (169432633 / 50000000 : Rat) /\
    (0 : Rat) < (32533563271 / 15115625650000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_410 : K11RowValid 410 := by
  change (1 : Rat) <= (783990853 / 100000000 : Rat) /\
    (102278107558496808463336864579 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (178300581 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (517838891 / 100000000 : Rat) - (783990853 / 100000000 : Rat) /\
    (0 : Rat) < (102278107558496808463336864579 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_411 : K11RowValid 411 := by
  change (1 : Rat) <= (810032267 / 50000000 : Rat) /\
    (5285944842307517961485761 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (283564423 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1614080641 / 100000000 : Rat) - (810032267 / 50000000 : Rat) /\
    (0 : Rat) < (5285944842307517961485761 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_412 : K11RowValid 412 := by
  change (1 : Rat) <= (153326293 / 100000000 : Rat) /\
    (29454195691 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (7695237 / 1562500 : Rat) - (153326293 / 100000000 : Rat) /\
    (0 : Rat) < (29454195691 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_413 : K11RowValid 413 := by
  change (1 : Rat) <= (1026995921 / 100000000 : Rat) /\
    (4190437492174394412856030933 / 642414090125000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (168007673 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (21651757 / 3125000 : Rat) - (1026995921 / 100000000 : Rat) /\
    (0 : Rat) < (4190437492174394412856030933 / 642414090125000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_414 : K11RowValid 414 := by
  change (1 : Rat) <= (234566041 / 50000000 : Rat) /\
    (764277312209796065513661 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (56371341 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (242940541 / 50000000 : Rat) - (234566041 / 50000000 : Rat) /\
    (0 : Rat) < (764277312209796065513661 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_415 : K11RowValid 415 := by
  change (1 : Rat) <= (225398717 / 100000000 : Rat) /\
    (2555103187 / 1778308900000000 : Rat) = (1600000000 / 5139312721 : Rat) * (36199851 / 5000000 : Rat) - (225398717 / 100000000 : Rat) /\
    (0 : Rat) < (2555103187 / 1778308900000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_416 : K11RowValid 416 := by
  change (1 : Rat) <= (487188791 / 100000000 : Rat) /\
    (31759816098742313858196051959 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (128074353 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (144814911 / 50000000 : Rat) - (487188791 / 100000000 : Rat) /\
    (0 : Rat) < (31759816098742313858196051959 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_417 : K11RowValid 417 := by
  change (1 : Rat) <= (774716603 / 100000000 : Rat) /\
    (1265072794259261138356607 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1018966141 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (89343167 / 50000000 : Rat) - (774716603 / 100000000 : Rat) /\
    (0 : Rat) < (1265072794259261138356607 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_418 : K11RowValid 418 := by
  change (1 : Rat) <= (269713523 / 50000000 : Rat) /\
    (879420373917 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (866339387 / 50000000 : Rat) - (269713523 / 50000000 : Rat) /\
    (0 : Rat) < (879420373917 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_419 : K11RowValid 419 := by
  change (1 : Rat) <= (321040571 / 50000000 : Rat) /\
    (4925599417604821992520632089 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (302862701 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (389396577 / 100000000 : Rat) - (321040571 / 50000000 : Rat) /\
    (0 : Rat) < (4925599417604821992520632089 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_420 : K11RowValid 420 := by
  change (1 : Rat) <= (808708029 / 100000000 : Rat) /\
    (2642323937656257343090657 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (137859951 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (483501217 / 100000000 : Rat) - (808708029 / 100000000 : Rat) /\
    (0 : Rat) < (2642323937656257343090657 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_421 : K11RowValid 421 := by
  change (1 : Rat) <= (152591007 / 100000000 : Rat) /\
    (498214699953 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (3829167 / 781250 : Rat) - (152591007 / 100000000 : Rat) /\
    (0 : Rat) < (498214699953 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_422 : K11RowValid 422 := by
  change (1 : Rat) <= (252843531 / 50000000 : Rat) /\
    (32952200357635266761204104327 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (44153257 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (155304783 / 50000000 : Rat) - (252843531 / 50000000 : Rat) /\
    (0 : Rat) < (32952200357635266761204104327 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_423 : K11RowValid 423 := by
  change (1 : Rat) <= (114345379 / 12500000 : Rat) /\
    (2984934977969772799668383 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (321876621 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1037741023 / 100000000 : Rat) - (114345379 / 12500000 : Rat) /\
    (0 : Rat) < (2984934977969772799668383 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_424 : K11RowValid 424 := by
  change (1 : Rat) <= (741939 / 125000 : Rat) /\
    (2423093981 / 642414090125000 : Rat) = (1600000000 / 5139312721 : Rat) * (953264741 / 50000000 : Rat) - (741939 / 125000 : Rat) /\
    (0 : Rat) < (2423093981 / 642414090125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_425 : K11RowValid 425 := by
  change (1 : Rat) <= (102904219 / 25000000 : Rat) /\
    (536551162604371148121538283 / 205572508840000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (39315673 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2229907 / 1000000 : Rat) - (102904219 / 25000000 : Rat) /\
    (0 : Rat) < (536551162604371148121538283 / 205572508840000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_426 : K11RowValid 426 := by
  change (1 : Rat) <= (530475903 / 100000000 : Rat) /\
    (865941869921746993836583 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (306956127 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (216165223 / 50000000 : Rat) - (530475903 / 100000000 : Rat) /\
    (0 : Rat) < (865941869921746993836583 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_427 : K11RowValid 427 := by
  change (1 : Rat) <= (191232033 / 100000000 : Rat) /\
    (624940408207 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (614251153 / 100000000 : Rat) - (191232033 / 100000000 : Rat) /\
    (0 : Rat) < (624940408207 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_428 : K11RowValid 428 := by
  change (1 : Rat) <= (878635471 / 100000000 : Rat) /\
    (114697601127545653552451294553 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (90194127 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (584654737 / 100000000 : Rat) - (878635471 / 100000000 : Rat) /\
    (0 : Rat) < (114697601127545653552451294553 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_429 : K11RowValid 429 := by
  change (1 : Rat) <= (928944541 / 100000000 : Rat) /\
    (47309301909687329829027 / 8030176126562500000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (549042271 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (15089187 / 1562500 : Rat) - (928944541 / 100000000 : Rat) /\
    (0 : Rat) < (47309301909687329829027 / 8030176126562500000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_430 : K11RowValid 430 := by
  change (1 : Rat) <= (97199029 / 50000000 : Rat) /\
    (317791452091 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (124884131 / 20000000 : Rat) - (97199029 / 50000000 : Rat) /\
    (0 : Rat) < (317791452091 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_431 : K11RowValid 431 := by
  change (1 : Rat) <= (75406227 / 10000000 : Rat) /\
    (9854547120444945043247946059 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (165766437 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (49933811 / 10000000 : Rat) - (75406227 / 10000000 : Rat) /\
    (0 : Rat) < (9854547120444945043247946059 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_432 : K11RowValid 432 := by
  change (1 : Rat) <= (290829631 / 50000000 : Rat) /\
    (1900265437941678755953629 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (660222637 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (479169949 / 100000000 : Rat) - (290829631 / 50000000 : Rat) /\
    (0 : Rat) < (1900265437941678755953629 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_433 : K11RowValid 433 := by
  change (1 : Rat) <= (188788963 / 50000000 : Rat) /\
    (615269701677 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (303201917 / 25000000 : Rat) - (188788963 / 50000000 : Rat) /\
    (0 : Rat) < (615269701677 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_434 : K11RowValid 434 := by
  change (1 : Rat) <= (197514501 / 50000000 : Rat) /\
    (82675801710073313659356569 / 32891601414400000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (287181347 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (347601 / 160000 : Rat) - (197514501 / 50000000 : Rat) /\
    (0 : Rat) < (82675801710073313659356569 / 32891601414400000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_435 : K11RowValid 435 := by
  change (1 : Rat) <= (137749711 / 25000000 : Rat) /\
    (180106294471378276936853 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (548751561 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (26667093 / 10000000 : Rat) - (137749711 / 25000000 : Rat) /\
    (0 : Rat) < (180106294471378276936853 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_436 : K11RowValid 436 := by
  change (1 : Rat) <= (401401393 / 100000000 : Rat) /\
    (1309927979647 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (322332593 / 25000000 : Rat) - (401401393 / 100000000 : Rat) /\
    (0 : Rat) < (1309927979647 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_437 : K11RowValid 437 := by
  change (1 : Rat) <= (113946123 / 20000000 : Rat) /\
    (438067737094330729489238943 / 120925005200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (56114229 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (35531799 / 10000000 : Rat) - (113946123 / 20000000 : Rat) /\
    (0 : Rat) < (438067737094330729489238943 / 120925005200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_438 : K11RowValid 438 := by
  change (1 : Rat) <= (1181884479 / 100000000 : Rat) /\
    (771612921022275648180591 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2329157421 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (116381871 / 20000000 : Rat) - (1181884479 / 100000000 : Rat) /\
    (0 : Rat) < (771612921022275648180591 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_439 : K11RowValid 439 := by
  change (1 : Rat) <= (80246207 / 50000000 : Rat) /\
    (261952900753 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (128878317 / 25000000 : Rat) - (80246207 / 50000000 : Rat) /\
    (0 : Rat) < (261952900753 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_440 : K11RowValid 440 := by
  change (1 : Rat) <= (240039909 / 10000000 : Rat) /\
    (39181144549769824247591010477 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (141758369 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (209368133 / 12500000 : Rat) - (240039909 / 10000000 : Rat) /\
    (0 : Rat) < (39181144549769824247591010477 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_441 : K11RowValid 441 := by
  change (1 : Rat) <= (82314283 / 12500000 : Rat) /\
    (214715112751767161301227 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (89540827 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (66137387 / 10000000 : Rat) - (82314283 / 12500000 : Rat) /\
    (0 : Rat) < (214715112751767161301227 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_442 : K11RowValid 442 := by
  change (1 : Rat) <= (125625257 / 50000000 : Rat) /\
    (24060059159 / 15115625650000000 : Rat) = (1600000000 / 5139312721 : Rat) * (807034863 / 100000000 : Rat) - (125625257 / 50000000 : Rat) /\
    (0 : Rat) < (24060059159 / 15115625650000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_443 : K11RowValid 443 := by
  change (1 : Rat) <= (29817339 / 10000000 : Rat) /\
    (2425149135060758820070590211 / 1284828180250000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (74760459 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (9111019 / 6250000 : Rat) - (29817339 / 10000000 : Rat) /\
    (0 : Rat) < (2425149135060758820070590211 / 1284828180250000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_444 : K11RowValid 444 := by
  change (1 : Rat) <= (311969183 / 50000000 : Rat) /\
    (1019116045448414408851151 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (324849339 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (75337231 / 50000000 : Rat) - (311969183 / 50000000 : Rat) /\
    (0 : Rat) < (1019116045448414408851151 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_445 : K11RowValid 445 := by
  change (1 : Rat) <= (303266131 / 100000000 : Rat) /\
    (987103247549 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (194822559 / 20000000 : Rat) - (303266131 / 100000000 : Rat) /\
    (0 : Rat) < (987103247549 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_446 : K11RowValid 446 := by
  change (1 : Rat) <= (924852407 / 100000000 : Rat) /\
    (471463882449104109063853347 / 80301761265625000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (374468909 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2244363 / 390625 : Rat) - (924852407 / 100000000 : Rat) /\
    (0 : Rat) < (471463882449104109063853347 / 80301761265625000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_447 : K11RowValid 447 := by
  change (1 : Rat) <= (681265869 / 100000000 : Rat) /\
    (1112567038421695307980711 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (240521671 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (195471591 / 50000000 : Rat) - (681265869 / 100000000 : Rat) /\
    (0 : Rat) < (1112567038421695307980711 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_448 : K11RowValid 448 := by
  change (1 : Rat) <= (15786487 / 6250000 : Rat) /\
    (51440998873 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (811317449 / 100000000 : Rat) - (15786487 / 6250000 : Rat) /\
    (0 : Rat) < (51440998873 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_449 : K11RowValid 449 := by
  change (1 : Rat) <= (6898653 / 1250000 : Rat) /\
    (35117693668165239246179359 / 10037720158203125000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (102014273 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1356088 / 390625 : Rat) - (6898653 / 1250000 : Rat) /\
    (0 : Rat) < (35117693668165239246179359 / 10037720158203125000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_450 : K11RowValid 450 := by
  change (1 : Rat) <= (6862951 / 800000 : Rat) /\
    (2795967810941857418354211 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (373645239 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (944725091 / 100000000 : Rat) - (6862951 / 800000 : Rat) /\
    (0 : Rat) < (2795967810941857418354211 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_451 : K11RowValid 451 := by
  change (1 : Rat) <= (12082451 / 5000000 : Rat) /\
    (39394840829 / 25696563605000000 : Rat) = (1600000000 / 5139312721 : Rat) * (776194169 / 100000000 : Rat) - (12082451 / 5000000 : Rat) /\
    (0 : Rat) < (39394840829 / 25696563605000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_452 : K11RowValid 452 := by
  change (1 : Rat) <= (84501777 / 20000000 : Rat) /\
    (55021109368971761143523417009 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (432177097 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (204696361 / 100000000 : Rat) - (84501777 / 20000000 : Rat) /\
    (0 : Rat) < (55021109368971761143523417009 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_453 : K11RowValid 453 := by
  change (1 : Rat) <= (456271841 / 100000000 : Rat) /\
    (745153927349459727478119 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4757347 / 800000 : Rat) + (784931055601 / 1000000000000 : Rat) * (172713639 / 50000000 : Rat) - (456271841 / 100000000 : Rat) /\
    (0 : Rat) < (745153927349459727478119 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_454 : K11RowValid 454 := by
  change (1 : Rat) <= (19548221 / 12500000 : Rat) /\
    (63541780659 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (251161211 / 50000000 : Rat) - (19548221 / 12500000 : Rat) /\
    (0 : Rat) < (63541780659 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_455 : K11RowValid 455 := by
  change (1 : Rat) <= (3414187803 / 100000000 : Rat) /\
    (445632391462619053896315241677 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (114802667 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2376152933 / 100000000 : Rat) - (3414187803 / 100000000 : Rat) /\
    (0 : Rat) < (445632391462619053896315241677 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_456 : K11RowValid 456 := by
  change (1 : Rat) <= (1366580087 / 100000000 : Rat) /\
    (278519704549086157567779 / 32120704506250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (313020111 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (70016099 / 6250000 : Rat) - (1366580087 / 100000000 : Rat) /\
    (0 : Rat) < (278519704549086157567779 / 32120704506250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_457 : K11RowValid 457 := by
  change (1 : Rat) <= (126131571 / 100000000 : Rat) /\
    (414239985309 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (405143751 / 100000000 : Rat) - (126131571 / 100000000 : Rat) /\
    (0 : Rat) < (414239985309 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_458 : K11RowValid 458 := by
  change (1 : Rat) <= (548353103 / 20000000 : Rat) /\
    (358058981330006454750029774681 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (124907263 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1921333649 / 100000000 : Rat) - (548353103 / 20000000 : Rat) /\
    (0 : Rat) < (358058981330006454750029774681 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_459 : K11RowValid 459 := by
  change (1 : Rat) <= (1314812711 / 100000000 : Rat) /\
    (857966501366816474703457 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (174443973 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (307338017 / 20000000 : Rat) - (1314812711 / 100000000 : Rat) /\
    (0 : Rat) < (857966501366816474703457 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_460 : K11RowValid 460 := by
  change (1 : Rat) <= (164443301 / 25000000 : Rat) /\
    (536887467979 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1056407607 / 50000000 : Rat) - (164443301 / 25000000 : Rat) /\
    (0 : Rat) < (536887467979 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_461 : K11RowValid 461 := by
  change (1 : Rat) <= (192102013 / 50000000 : Rat) /\
    (25059732010915826408352905901 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (227904119 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (111337029 / 50000000 : Rat) - (192102013 / 50000000 : Rat) /\
    (0 : Rat) < (25059732010915826408352905901 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_462 : K11RowValid 462 := by
  change (1 : Rat) <= (202170861 / 50000000 : Rat) /\
    (1320819191104675619507147 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (992954629 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (121296907 / 100000000 : Rat) - (202170861 / 50000000 : Rat) /\
    (0 : Rat) < (1320819191104675619507147 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_463 : K11RowValid 463 := by
  change (1 : Rat) <= (365939 / 200000 : Rat) /\
    (1189389981 / 1027862544200000 : Rat) = (1600000000 / 5139312721 : Rat) * (9182989 / 1562500 : Rat) - (365939 / 200000 : Rat) /\
    (0 : Rat) < (1189389981 / 1027862544200000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_464 : K11RowValid 464 := by
  change (1 : Rat) <= (65610911 / 10000000 : Rat) /\
    (42769816898243616149110533781 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (29206953 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (217037549 / 50000000 : Rat) - (65610911 / 10000000 : Rat) /\
    (0 : Rat) < (42769816898243616149110533781 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_465 : K11RowValid 465 := by
  change (1 : Rat) <= (1393777293 / 100000000 : Rat) /\
    (2272708891318355700113219 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1070413641 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (675556739 / 50000000 : Rat) - (1393777293 / 100000000 : Rat) /\
    (0 : Rat) < (2272708891318355700113219 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_466 : K11RowValid 466 := by
  change (1 : Rat) <= (14201381 / 10000000 : Rat) /\
    (46290932299 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (114039663 / 25000000 : Rat) - (14201381 / 10000000 : Rat) /\
    (0 : Rat) < (46290932299 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_467 : K11RowValid 467 := by
  change (1 : Rat) <= (496003233 / 25000000 : Rat) /\
    (129531922389549069062803602921 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (14637159 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (688968609 / 50000000 : Rat) - (496003233 / 25000000 : Rat) /\
    (0 : Rat) < (129531922389549069062803602921 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_468 : K11RowValid 468 := by
  change (1 : Rat) <= (526659923 / 100000000 : Rat) /\
    (50585509312575520537337 / 15115625650000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (164493683 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (270239049 / 50000000 : Rat) - (526659923 / 100000000 : Rat) /\
    (0 : Rat) < (50585509312575520537337 / 15115625650000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_469 : K11RowValid 469 := by
  change (1 : Rat) <= (14010281 / 5000000 : Rat) /\
    (45751915399 / 25696563605000000 : Rat) = (1600000000 / 5139312721 : Rat) * (225010191 / 25000000 : Rat) - (14010281 / 5000000 : Rat) /\
    (0 : Rat) < (45751915399 / 25696563605000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_470 : K11RowValid 470 := by
  change (1 : Rat) <= (268982711 / 100000000 : Rat) /\
    (8772988305852878018102118513 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (323315527 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (29913577 / 25000000 : Rat) - (268982711 / 100000000 : Rat) /\
    (0 : Rat) < (8772988305852878018102118513 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_471 : K11RowValid 471 := by
  change (1 : Rat) <= (405700891 / 100000000 : Rat) /\
    (662157852025251647657649 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (853976429 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (89075569 / 50000000 : Rat) - (405700891 / 100000000 : Rat) /\
    (0 : Rat) < (662157852025251647657649 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_472 : K11RowValid 472 := by
  change (1 : Rat) <= (38184489 / 20000000 : Rat) /\
    (124497415431 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (613256733 / 100000000 : Rat) - (38184489 / 20000000 : Rat) /\
    (0 : Rat) < (124497415431 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_473 : K11RowValid 473 := by
  change (1 : Rat) <= (292874543 / 25000000 : Rat) /\
    (30575868804189195338762924871 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (57163999 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (146310159 / 20000000 : Rat) - (292874543 / 25000000 : Rat) /\
    (0 : Rat) < (30575868804189195338762924871 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_474 : K11RowValid 474 := by
  change (1 : Rat) <= (235116449 / 25000000 : Rat) /\
    (122759943443853545638421 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (558457139 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (12486101 / 4000000 : Rat) - (235116449 / 25000000 : Rat) /\
    (0 : Rat) < (122759943443853545638421 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_475 : K11RowValid 475 := by
  change (1 : Rat) <= (222817823 / 100000000 : Rat) /\
    (727790573617 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (715707 / 100000 : Rat) - (222817823 / 100000000 : Rat) /\
    (0 : Rat) < (727790573617 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_476 : K11RowValid 476 := by
  change (1 : Rat) <= (100477751 / 20000000 : Rat) /\
    (65581042871979550701559714719 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (10348321 / 5000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (311318951 / 100000000 : Rat) - (100477751 / 20000000 : Rat) /\
    (0 : Rat) < (65581042871979550701559714719 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_477 : K11RowValid 477 := by
  change (1 : Rat) <= (235222387 / 25000000 : Rat) /\
    (3068320830533430593954853 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (508199953 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (997125093 / 100000000 : Rat) - (235222387 / 25000000 : Rat) /\
    (0 : Rat) < (3068320830533430593954853 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_478 : K11RowValid 478 := by
  change (1 : Rat) <= (17234719 / 6250000 : Rat) /\
    (56200439601 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (221436667 / 25000000 : Rat) - (17234719 / 6250000 : Rat) /\
    (0 : Rat) < (56200439601 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_479 : K11RowValid 479 := by
  change (1 : Rat) <= (336596157 / 100000000 : Rat) /\
    (10979225692908705284242533917 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (101121019 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (31843893 / 25000000 : Rat) - (336596157 / 100000000 : Rat) /\
    (0 : Rat) < (10979225692908705284242533917 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_480 : K11RowValid 480 := by
  change (1 : Rat) <= (60090769 / 12500000 : Rat) /\
    (785639505447683105961697 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (364085781 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (161815457 / 50000000 : Rat) - (60090769 / 12500000 : Rat) /\
    (0 : Rat) < (785639505447683105961697 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_481 : K11RowValid 481 := by
  change (1 : Rat) <= (234344189 / 100000000 : Rat) /\
    (765179871731 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (752730523 / 100000000 : Rat) - (234344189 / 100000000 : Rat) /\
    (0 : Rat) < (765179871731 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_482 : K11RowValid 482 := by
  change (1 : Rat) <= (81110723 / 6250000 : Rat) /\
    (169301947703028951980162998703 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (127555159 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (866060087 / 100000000 : Rat) - (81110723 / 6250000 : Rat) /\
    (0 : Rat) < (169301947703028951980162998703 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_483 : K11RowValid 483 := by
  change (1 : Rat) <= (570874191 / 50000000 : Rat) /\
    (745331970895233872875857 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (580072761 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (244902417 / 20000000 : Rat) - (570874191 / 50000000 : Rat) /\
    (0 : Rat) < (745331970895233872875857 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_484 : K11RowValid 484 := by
  change (1 : Rat) <= (3507089 / 2500000 : Rat) /\
    (11488620831 / 12848281802500000 : Rat) = (1600000000 / 5139312721 : Rat) * (90120193 / 20000000 : Rat) - (3507089 / 2500000 : Rat) /\
    (0 : Rat) < (11488620831 / 12848281802500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_485 : K11RowValid 485 := by
  change (1 : Rat) <= (322049649 / 12500000 : Rat) /\
    (336294932045725784513079881867 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (117869923 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1805339443 / 100000000 : Rat) - (322049649 / 12500000 : Rat) /\
    (0 : Rat) < (336294932045725784513079881867 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_486 : K11RowValid 486 := by
  change (1 : Rat) <= (1051608561 / 100000000 : Rat) /\
    (3431627204063117741260821 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (312791011 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (843500501 / 100000000 : Rat) - (1051608561 / 100000000 : Rat) /\
    (0 : Rat) < (3431627204063117741260821 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_487 : K11RowValid 487 := by
  change (1 : Rat) <= (406954493 / 100000000 : Rat) /\
    (1325256994547 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (130716733 / 10000000 : Rat) - (406954493 / 100000000 : Rat) /\
    (0 : Rat) < (1325256994547 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_488 : K11RowValid 488 := by
  change (1 : Rat) <= (317758473 / 50000000 : Rat) /\
    (41455205460806671305417400247 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (172280423 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (206814463 / 50000000 : Rat) - (317758473 / 50000000 : Rat) /\
    (0 : Rat) < (41455205460806671305417400247 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_489 : K11RowValid 489 := by
  change (1 : Rat) <= (446265161 / 100000000 : Rat) /\
    (1455997778469116940523939 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (67578651 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (300505059 / 100000000 : Rat) - (446265161 / 100000000 : Rat) /\
    (0 : Rat) < (1455997778469116940523939 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_490 : K11RowValid 490 := by
  change (1 : Rat) <= (126479767 / 50000000 : Rat) /\
    (411707783993 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (812524359 / 100000000 : Rat) - (126479767 / 50000000 : Rat) /\
    (0 : Rat) < (411707783993 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_491 : K11RowValid 491 := by
  change (1 : Rat) <= (783418401 / 100000000 : Rat) /\
    (12759372754373550918717636393 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (18920717 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (65424097 / 12500000 : Rat) - (783418401 / 100000000 : Rat) /\
    (0 : Rat) < (12759372754373550918717636393 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_492 : K11RowValid 492 := by
  change (1 : Rat) <= (472013481 / 50000000 : Rat) /\
    (769975564604758127935801 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (931636037 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (208293881 / 25000000 : Rat) - (472013481 / 50000000 : Rat) /\
    (0 : Rat) < (769975564604758127935801 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_493 : K11RowValid 493 := by
  change (1 : Rat) <= (5221577 / 2500000 : Rat) /\
    (16980218983 / 12848281802500000 : Rat) = (1600000000 / 5139312721 : Rat) * (83860419 / 12500000 : Rat) - (5221577 / 2500000 : Rat) /\
    (0 : Rat) < (16980218983 / 12848281802500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_494 : K11RowValid 494 := by
  change (1 : Rat) <= (699316453 / 50000000 : Rat) /\
    (182514667437470963483197374393 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (281006661 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (932026097 / 100000000 : Rat) - (699316453 / 50000000 : Rat) /\
    (0 : Rat) < (182514667437470963483197374393 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_495 : K11RowValid 495 := by
  change (1 : Rat) <= (47836667 / 5000000 : Rat) /\
    (1561030215300961458684621 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (72372471 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (552028301 / 50000000 : Rat) - (47836667 / 5000000 : Rat) /\
    (0 : Rat) < (1561030215300961458684621 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_496 : K11RowValid 496 := by
  change (1 : Rat) <= (101035279 / 50000000 : Rat) /\
    (330165515841 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (649065281 / 100000000 : Rat) - (101035279 / 50000000 : Rat) /\
    (0 : Rat) < (330165515841 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_497 : K11RowValid 497 := by
  change (1 : Rat) <= (141269427 / 50000000 : Rat) /\
    (36937464723466169751817189543 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (26711739 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (153550447 / 100000000 : Rat) - (141269427 / 50000000 : Rat) /\
    (0 : Rat) < (36937464723466169751817189543 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_498 : K11RowValid 498 := by
  change (1 : Rat) <= (263903659 / 50000000 : Rat) /\
    (86090557856917025759319 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (55125573 / 4000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (6290839 / 5000000 : Rat) - (263903659 / 50000000 : Rat) /\
    (0 : Rat) < (86090557856917025759319 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_499 : K11RowValid 499 := by
  change (1 : Rat) <= (242845503 / 100000000 : Rat) /\
    (791594456337 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (780037359 / 100000000 : Rat) - (242845503 / 100000000 : Rat) /\
    (0 : Rat) < (791594456337 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_500 : K11RowValid 500 := by
  change (1 : Rat) <= (192520769 / 25000000 : Rat) /\
    (100454340045199700692726225083 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (5164303 / 2000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (490267107 / 100000000 : Rat) - (192520769 / 25000000 : Rat) /\
    (0 : Rat) < (100454340045199700692726225083 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_501 : K11RowValid 501 := by
  change (1 : Rat) <= (912309891 / 100000000 : Rat) /\
    (148881538530745205210609 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (116635479 / 6250000 : Rat) + (784931055601 / 1000000000000 : Rat) * (21105329 / 5000000 : Rat) - (912309891 / 100000000 : Rat) /\
    (0 : Rat) < (148881538530745205210609 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_502 : K11RowValid 502 := by
  change (1 : Rat) <= (30252863 / 20000000 : Rat) /\
    (98417429777 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (60733993 / 12500000 : Rat) - (30252863 / 20000000 : Rat) /\
    (0 : Rat) < (98417429777 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_503 : K11RowValid 503 := by
  change (1 : Rat) <= (376341441 / 100000000 : Rat) /\
    (24653091179740579657641310929 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (144710637 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (117748041 / 50000000 : Rat) - (376341441 / 100000000 : Rat) /\
    (0 : Rat) < (24653091179740579657641310929 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_504 : K11RowValid 504 := by
  change (1 : Rat) <= (331212827 / 50000000 : Rat) /\
    (2159573670764106353153257 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (355388819 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (702971817 / 100000000 : Rat) - (331212827 / 50000000 : Rat) /\
    (0 : Rat) < (2159573670764106353153257 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_505 : K11RowValid 505 := by
  change (1 : Rat) <= (44833581 / 12500000 : Rat) /\
    (146238716099 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (1152069697 / 100000000 : Rat) - (44833581 / 12500000 : Rat) /\
    (0 : Rat) < (146238716099 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_506 : K11RowValid 506 := by
  change (1 : Rat) <= (2014176 / 390625 : Rat) /\
    (67299797381626188501031149577 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (220152033 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (269092033 / 100000000 : Rat) - (2014176 / 390625 : Rat) /\
    (0 : Rat) < (67299797381626188501031149577 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_507 : K11RowValid 507 := by
  change (1 : Rat) <= (116482159 / 25000000 : Rat) /\
    (757976658851671262504541 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (901974861 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (117921821 / 50000000 : Rat) - (116482159 / 25000000 : Rat) /\
    (0 : Rat) < (757976658851671262504541 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_508 : K11RowValid 508 := by
  change (1 : Rat) <= (64561093 / 50000000 : Rat) /\
    (211863435947 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (414749823 / 100000000 : Rat) - (64561093 / 50000000 : Rat) /\
    (0 : Rat) < (211863435947 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_509 : K11RowValid 509 := by
  change (1 : Rat) <= (1112952481 / 100000000 : Rat) /\
    (2134890371530922291465904217 / 302312513000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (84908659 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (178994081 / 25000000 : Rat) - (1112952481 / 100000000 : Rat) /\
    (0 : Rat) < (2134890371530922291465904217 / 302312513000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_510 : K11RowValid 510 := by
  change (1 : Rat) <= (22639777 / 3125000 : Rat) /\
    (2364583157395376490379277 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (160614951 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (668159437 / 100000000 : Rat) - (22639777 / 3125000 : Rat) /\
    (0 : Rat) < (2364583157395376490379277 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_511 : K11RowValid 511 := by
  change (1 : Rat) <= (53313177 / 20000000 : Rat) /\
    (174286975383 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (856228947 / 100000000 : Rat) - (53313177 / 20000000 : Rat) /\
    (0 : Rat) < (174286975383 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_512 : K11RowValid 512 := by
  change (1 : Rat) <= (4300053 / 400000 : Rat) /\
    (140372284309373260531535888621 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (63907793 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (735883909 / 100000000 : Rat) - (4300053 / 400000 : Rat) /\
    (0 : Rat) < (140372284309373260531535888621 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_513 : K11RowValid 513 := by
  change (1 : Rat) <= (106143591 / 20000000 : Rat) /\
    (3465085108437580289243 / 1027862544200000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (607098111 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (870683 / 200000 : Rat) - (106143591 / 20000000 : Rat) /\
    (0 : Rat) < (3465085108437580289243 / 1027862544200000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_514 : K11RowValid 514 := by
  change (1 : Rat) <= (333068213 / 100000000 : Rat) /\
    (1086368362427 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (267459811 / 25000000 : Rat) - (333068213 / 100000000 : Rat) /\
    (0 : Rat) < (1086368362427 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_515 : K11RowValid 515 := by
  change (1 : Rat) <= (341395571 / 50000000 : Rat) /\
    (44647462193996276921197184723 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (385959991 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (199972667 / 50000000 : Rat) - (341395571 / 50000000 : Rat) /\
    (0 : Rat) < (44647462193996276921197184723 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_516 : K11RowValid 516 := by
  change (1 : Rat) <= (456582477 / 100000000 : Rat) /\
    (1492955708135064225545069 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (240936437 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (199436589 / 100000000 : Rat) - (456582477 / 100000000 : Rat) /\
    (0 : Rat) < (1492955708135064225545069 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_517 : K11RowValid 517 := by
  change (1 : Rat) <= (447274947 / 100000000 : Rat) /\
    (85970488189 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (718339777 / 50000000 : Rat) - (447274947 / 100000000 : Rat) /\
    (0 : Rat) < (85970488189 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_518 : K11RowValid 518 := by
  change (1 : Rat) <= (949486943 / 100000000 : Rat) /\
    (124015890196581570649244209293 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (15269391 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (641148197 / 100000000 : Rat) - (949486943 / 100000000 : Rat) /\
    (0 : Rat) < (124015890196581570649244209293 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_519 : K11RowValid 519 := by
  change (1 : Rat) <= (846953717 / 100000000 : Rat) /\
    (690463762672475820404011 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (593984489 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (151958891 / 25000000 : Rat) - (846953717 / 100000000 : Rat) /\
    (0 : Rat) < (690463762672475820404011 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_520 : K11RowValid 520 := by
  change (1 : Rat) <= (176595431 / 100000000 : Rat) /\
    (578191222249 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (567237327 / 100000000 : Rat) - (176595431 / 100000000 : Rat) /\
    (0 : Rat) < (578191222249 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_521 : K11RowValid 521 := by
  change (1 : Rat) <= (587776571 / 25000000 : Rat) /\
    (306916325208662340911854272827 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (189494017 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1629341283 / 100000000 : Rat) - (587776571 / 25000000 : Rat) /\
    (0 : Rat) < (306916325208662340911854272827 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_522 : K11RowValid 522 := by
  change (1 : Rat) <= (416838011 / 100000000 : Rat) /\
    (1362732898181145371163163 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (43148931 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (394138203 / 100000000 : Rat) - (416838011 / 100000000 : Rat) /\
    (0 : Rat) < (1362732898181145371163163 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_523 : K11RowValid 523 := by
  change (1 : Rat) <= (137246199 / 50000000 : Rat) /\
    (449170402521 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (440844741 / 50000000 : Rat) - (137246199 / 50000000 : Rat) /\
    (0 : Rat) < (449170402521 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_524 : K11RowValid 524 := by
  change (1 : Rat) <= (407835289 / 100000000 : Rat) /\
    (53314497982692285771063877813 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (36208699 / 12500000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (225803277 / 100000000 : Rat) - (407835289 / 100000000 : Rat) /\
    (0 : Rat) < (53314497982692285771063877813 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_525 : K11RowValid 525 := by
  change (1 : Rat) <= (194815271 / 50000000 : Rat) /\
    (1273739613232629640203191 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (962554413 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (114612471 / 100000000 : Rat) - (194815271 / 50000000 : Rat) /\
    (0 : Rat) < (1273739613232629640203191 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_526 : K11RowValid 526 := by
  change (1 : Rat) <= (42560797 / 20000000 : Rat) /\
    (138562001363 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (27341673 / 4000000 : Rat) - (42560797 / 20000000 : Rat) /\
    (0 : Rat) < (138562001363 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_527 : K11RowValid 527 := by
  change (1 : Rat) <= (83314547 / 10000000 : Rat) /\
    (4345282267056928258300126279 / 822290035360000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (252070031 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (21458191 / 4000000 : Rat) - (83314547 / 10000000 : Rat) /\
    (0 : Rat) < (4345282267056928258300126279 / 822290035360000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_528 : K11RowValid 528 := by
  change (1 : Rat) <= (346656889 / 50000000 : Rat) /\
    (453128144779853566977011 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (569073401 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (86371891 / 20000000 : Rat) - (346656889 / 50000000 : Rat) /\
    (0 : Rat) < (453128144779853566977011 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_529 : K11RowValid 529 := by
  change (1 : Rat) <= (387392537 / 100000000 : Rat) /\
    (1262575436823 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (124433291 / 10000000 : Rat) - (387392537 / 100000000 : Rat) /\
    (0 : Rat) < (1262575436823 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_530 : K11RowValid 530 := by
  change (1 : Rat) <= (648153363 / 100000000 : Rat) /\
    (16927498760216613645145712277 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (65602527 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (86340333 / 20000000 : Rat) - (648153363 / 100000000 : Rat) /\
    (0 : Rat) < (16927498760216613645145712277 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_531 : K11RowValid 531 := by
  change (1 : Rat) <= (16219043 / 1250000 : Rat) /\
    (211658458484434589765113 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (426392619 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (74196153 / 5000000 : Rat) - (16219043 / 1250000 : Rat) /\
    (0 : Rat) < (211658458484434589765113 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_532 : K11RowValid 532 := by
  change (1 : Rat) <= (42713651 / 20000000 : Rat) /\
    (139495345629 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (685996717 / 100000000 : Rat) - (42713651 / 20000000 : Rat) /\
    (0 : Rat) < (139495345629 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_533 : K11RowValid 533 := by
  change (1 : Rat) <= (163091747 / 20000000 : Rat) /\
    (106466277149196014194859052627 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (55029113 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (518775483 / 100000000 : Rat) - (163091747 / 20000000 : Rat) /\
    (0 : Rat) < (106466277149196014194859052627 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_534 : K11RowValid 534 := by
  change (1 : Rat) <= (412117019 / 100000000 : Rat) /\
    (1343860390237928404260679 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (164067619 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (264740999 / 100000000 : Rat) - (412117019 / 100000000 : Rat) /\
    (0 : Rat) < (1343860390237928404260679 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_535 : K11RowValid 535 := by
  change (1 : Rat) <= (178650691 / 100000000 : Rat) /\
    (584728259789 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (573838971 / 100000000 : Rat) - (178650691 / 100000000 : Rat) /\
    (0 : Rat) < (584728259789 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_536 : K11RowValid 536 := by
  change (1 : Rat) <= (354418189 / 20000000 : Rat) /\
    (231184571883237445005843293349 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (39013693 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1216516221 / 100000000 : Rat) - (354418189 / 20000000 : Rat) /\
    (0 : Rat) < (231184571883237445005843293349 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_537 : K11RowValid 537 := by
  change (1 : Rat) <= (86129393 / 6250000 : Rat) /\
    (2247037386487249957817447 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (157828251 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (752631207 / 50000000 : Rat) - (86129393 / 6250000 : Rat) /\
    (0 : Rat) < (2247037386487249957817447 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_538 : K11RowValid 538 := by
  change (1 : Rat) <= (112403173 / 100000000 : Rat) /\
    (21501196251 / 30231251300000000 : Rat) = (1600000000 / 5139312721 : Rat) * (361047139 / 100000000 : Rat) - (112403173 / 100000000 : Rat) /\
    (0 : Rat) < (21501196251 / 30231251300000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_539 : K11RowValid 539 := by
  change (1 : Rat) <= (2212452987 / 50000000 : Rat) /\
    (577607691427131879187498360039 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (162719507 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (3109421231 / 100000000 : Rat) - (2212452987 / 50000000 : Rat) /\
    (0 : Rat) < (577607691427131879187498360039 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_540 : K11RowValid 540 := by
  change (1 : Rat) <= (909697321 / 100000000 : Rat) /\
    (2969491795168948659857449 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (171693981 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (818459369 / 100000000 : Rat) - (909697321 / 100000000 : Rat) /\
    (0 : Rat) < (2969491795168948659857449 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_541 : K11RowValid 541 := by
  change (1 : Rat) <= (828160611 / 100000000 : Rat) /\
    (2702456567469 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (665027979 / 25000000 : Rat) - (828160611 / 100000000 : Rat) /\
    (0 : Rat) < (2702456567469 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_542 : K11RowValid 542 := by
  change (1 : Rat) <= (71231573 / 10000000 : Rat) /\
    (23224419592797758500742437399 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (203323463 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (104088671 / 25000000 : Rat) - (71231573 / 10000000 : Rat) /\
    (0 : Rat) < (23224419592797758500742437399 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_543 : K11RowValid 543 := by
  change (1 : Rat) <= (476321201 / 100000000 : Rat) /\
    (777641195587047204538839 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1195599663 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (66311959 / 50000000 : Rat) - (476321201 / 100000000 : Rat) /\
    (0 : Rat) < (777641195587047204538839 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_544 : K11RowValid 544 := by
  change (1 : Rat) <= (84968131 / 20000000 : Rat) /\
    (277072105549 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (68230949 / 5000000 : Rat) - (84968131 / 20000000 : Rat) /\
    (0 : Rat) < (277072105549 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_545 : K11RowValid 545 := by
  change (1 : Rat) <= (53987163 / 6250000 : Rat) /\
    (11271702007557612779416888507 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (166945807 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (57708003 / 10000000 : Rat) - (53987163 / 6250000 : Rat) /\
    (0 : Rat) < (11271702007557612779416888507 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_546 : K11RowValid 546 := by
  change (1 : Rat) <= (782893333 / 20000000 : Rat) /\
    (12778752841700945266168119 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (416139019 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (3666603639 / 100000000 : Rat) - (782893333 / 20000000 : Rat) /\
    (0 : Rat) < (12778752841700945266168119 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_547 : K11RowValid 547 := by
  change (1 : Rat) <= (12762727 / 10000000 : Rat) /\
    (41654249833 / 51393127210000000 : Rat) = (1600000000 / 5139312721 : Rat) * (409948043 / 100000000 : Rat) - (12762727 / 10000000 : Rat) /\
    (0 : Rat) < (41654249833 / 51393127210000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_548 : K11RowValid 548 := by
  change (1 : Rat) <= (1720296113 / 100000000 : Rat) /\
    (224521947945019436503569461641 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (33933391 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1185319489 / 100000000 : Rat) - (1720296113 / 100000000 : Rat) /\
    (0 : Rat) < (224521947945019436503569461641 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_549 : K11RowValid 549 := by
  change (1 : Rat) <= (373554 / 78125 : Rat) /\
    (1558886368526884751937561 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (43896481 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (469876441 / 100000000 : Rat) - (373554 / 78125 : Rat) /\
    (0 : Rat) < (1558886368526884751937561 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_550 : K11RowValid 550 := by
  change (1 : Rat) <= (234384801 / 100000000 : Rat) /\
    (764211646479 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (752860971 / 100000000 : Rat) - (234384801 / 100000000 : Rat) /\
    (0 : Rat) < (764211646479 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_551 : K11RowValid 551 := by
  change (1 : Rat) <= (430287007 / 100000000 : Rat) /\
    (14048653595635935947716986689 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (309762659 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (59329081 / 25000000 : Rat) - (430287007 / 100000000 : Rat) /\
    (0 : Rat) < (14048653595635935947716986689 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_552 : K11RowValid 552 := by
  change (1 : Rat) <= (242940541 / 50000000 : Rat) /\
    (1588545072493784638591323 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (48826843 / 4000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (134859163 / 100000000 : Rat) - (242940541 / 50000000 : Rat) /\
    (0 : Rat) < (1588545072493784638591323 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_553 : K11RowValid 553 := by
  change (1 : Rat) <= (79400769 / 50000000 : Rat) /\
    (259421117551 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (127520513 / 25000000 : Rat) - (79400769 / 50000000 : Rat) /\
    (0 : Rat) < (259421117551 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_554 : K11RowValid 554 := by
  change (1 : Rat) <= (136767127 / 10000000 : Rat) /\
    (5577639492880382959783607251 / 642414090125000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (468527999 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (27141179 / 3125000 : Rat) - (136767127 / 10000000 : Rat) /\
    (0 : Rat) < (5577639492880382959783607251 / 642414090125000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_555 : K11RowValid 555 := by
  change (1 : Rat) <= (141535479 / 20000000 : Rat) /\
    (2308112362085704092179253 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (362227361 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (326901493 / 100000000 : Rat) - (141535479 / 20000000 : Rat) /\
    (0 : Rat) < (2308112362085704092179253 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_556 : K11RowValid 556 := by
  change (1 : Rat) <= (103949793 / 50000000 : Rat) /\
    (338489783247 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (33389427 / 5000000 : Rat) - (103949793 / 50000000 : Rat) /\
    (0 : Rat) < (338489783247 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_557 : K11RowValid 557 := by
  change (1 : Rat) <= (323337039 / 50000000 : Rat) /\
    (8443671609833335395828899427 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (49849433 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (40452683 / 10000000 : Rat) - (323337039 / 50000000 : Rat) /\
    (0 : Rat) < (8443671609833335395828899427 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_558 : K11RowValid 558 := by
  change (1 : Rat) <= (100511643 / 12500000 : Rat) /\
    (2624977848233352852830069 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (70876073 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (799521589 / 100000000 : Rat) - (100511643 / 12500000 : Rat) /\
    (0 : Rat) < (2624977848233352852830069 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_559 : K11RowValid 559 := by
  change (1 : Rat) <= (114882789 / 25000000 : Rat) /\
    (374668341131 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (184505923 / 12500000 : Rat) - (114882789 / 25000000 : Rat) /\
    (0 : Rat) < (374668341131 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_560 : K11RowValid 560 := by
  change (1 : Rat) <= (109042959 / 20000000 : Rat) /\
    (555828020911833084502571573 / 160603522531250000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (55569463 / 5000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1106317 / 781250 : Rat) - (109042959 / 20000000 : Rat) /\
    (0 : Rat) < (555828020911833084502571573 / 160603522531250000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_561 : K11RowValid 561 := by
  change (1 : Rat) <= (64782817 / 12500000 : Rat) /\
    (211409372833727324323469 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (163610181 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (50086989 / 12500000 : Rat) - (64782817 / 12500000 : Rat) /\
    (0 : Rat) < (211409372833727324323469 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_562 : K11RowValid 562 := by
  change (1 : Rat) <= (121364079 / 100000000 : Rat) /\
    (395322851041 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (389830219 / 100000000 : Rat) - (121364079 / 100000000 : Rat) /\
    (0 : Rat) < (395322851041 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_563 : K11RowValid 563 := by
  change (1 : Rat) <= (1268327881 / 100000000 : Rat) /\
    (2587640410754130806435644583 / 321207045062500000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (174873833 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (13482607 / 1562500 : Rat) - (1268327881 / 100000000 : Rat) /\
    (0 : Rat) < (2587640410754130806435644583 / 321207045062500000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_564 : K11RowValid 564 := by
  change (1 : Rat) <= (158237271 / 12500000 : Rat) /\
    (2065826979413558408221931 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (174153581 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (633690411 / 50000000 : Rat) - (158237271 / 12500000 : Rat) /\
    (0 : Rat) < (2065826979413558408221931 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_565 : K11RowValid 565 := by
  change (1 : Rat) <= (48561701 / 25000000 : Rat) /\
    (549125611 / 444577225000000 : Rat) = (1600000000 / 5139312721 : Rat) * (19497963 / 3125000 : Rat) - (48561701 / 25000000 : Rat) /\
    (0 : Rat) < (549125611 / 444577225000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_566 : K11RowValid 566 := by
  change (1 : Rat) <= (1012155141 / 50000000 : Rat) /\
    (66062105790856244204796784533 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (180703631 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (349746157 / 25000000 : Rat) - (1012155141 / 50000000 : Rat) /\
    (0 : Rat) < (66062105790856244204796784533 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_567 : K11RowValid 567 := by
  change (1 : Rat) <= (757278051 / 100000000 : Rat) /\
    (1235517321941027899422467 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (463576777 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (298517827 / 50000000 : Rat) - (757278051 / 100000000 : Rat) /\
    (0 : Rat) < (1235517321941027899422467 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_568 : K11RowValid 568 := by
  change (1 : Rat) <= (216165223 / 50000000 : Rat) /\
    (705998298217 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1388676733 / 100000000 : Rat) - (216165223 / 50000000 : Rat) /\
    (0 : Rat) < (705998298217 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_569 : K11RowValid 569 := by
  change (1 : Rat) <= (921391921 / 100000000 : Rat) /\
    (120382190791882592799979889431 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (297248059 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (589186399 / 100000000 : Rat) - (921391921 / 100000000 : Rat) /\
    (0 : Rat) < (120382190791882592799979889431 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_570 : K11RowValid 570 := by
  change (1 : Rat) <= (113317899 / 20000000 : Rat) /\
    (1849830897930337028812989 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (364593229 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (432618109 / 100000000 : Rat) - (113317899 / 20000000 : Rat) /\
    (0 : Rat) < (1849830897930337028812989 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_571 : K11RowValid 571 := by
  change (1 : Rat) <= (114272843 / 50000000 : Rat) /\
    (371505264197 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (734105309 / 100000000 : Rat) - (114272843 / 50000000 : Rat) /\
    (0 : Rat) < (371505264197 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_572 : K11RowValid 572 := by
  change (1 : Rat) <= (1050026127 / 100000000 : Rat) /\
    (137127853707212965869861392947 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (144033581 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (714532763 / 100000000 : Rat) - (1050026127 / 100000000 : Rat) /\
    (0 : Rat) < (137127853707212965869861392947 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_573 : K11RowValid 573 := by
  change (1 : Rat) <= (1542352663 / 100000000 : Rat) /\
    (2516328779447187326194017 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (282142189 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (702713377 / 50000000 : Rat) - (1542352663 / 100000000 : Rat) /\
    (0 : Rat) < (2516328779447187326194017 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_574 : K11RowValid 574 := by
  change (1 : Rat) <= (70477149 / 50000000 : Rat) /\
    (13576734563 / 15115625650000000 : Rat) = (1600000000 / 5139312721 : Rat) * (14148607 / 3125000 : Rat) - (70477149 / 50000000 : Rat) /\
    (0 : Rat) < (13576734563 / 15115625650000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_575 : K11RowValid 575 := by
  change (1 : Rat) <= (727546137 / 50000000 : Rat) /\
    (190050620300242051319760085229 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (32506599 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1005572741 / 100000000 : Rat) - (727546137 / 50000000 : Rat) /\
    (0 : Rat) < (190050620300242051319760085229 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_576 : K11RowValid 576 := by
  change (1 : Rat) <= (125560571 / 25000000 : Rat) /\
    (65528115522915493315717 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (196126781 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (19371077 / 4000000 : Rat) - (125560571 / 25000000 : Rat) /\
    (0 : Rat) < (65528115522915493315717 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_577 : K11RowValid 577 := by
  change (1 : Rat) <= (210436313 / 100000000 : Rat) /\
    (688438762327 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (675936693 / 100000000 : Rat) - (210436313 / 100000000 : Rat) /\
    (0 : Rat) < (688438762327 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_578 : K11RowValid 578 := by
  change (1 : Rat) <= (31114901 / 10000000 : Rat) /\
    (40741222089724041672368727509 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (642899 / 312500 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (175650861 / 100000000 : Rat) - (31114901 / 10000000 : Rat) /\
    (0 : Rat) < (40741222089724041672368727509 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_579 : K11RowValid 579 := by
  change (1 : Rat) <= (849573671 / 100000000 : Rat) /\
    (2771280870294815551115887 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (921758247 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (351164847 / 100000000 : Rat) - (849573671 / 100000000 : Rat) /\
    (0 : Rat) < (2771280870294815551115887 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_580 : K11RowValid 580 := by
  change (1 : Rat) <= (139227659 / 50000000 : Rat) /\
    (452986249861 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (178883733 / 20000000 : Rat) - (139227659 / 50000000 : Rat) /\
    (0 : Rat) < (452986249861 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_581 : K11RowValid 581 := by
  change (1 : Rat) <= (142066831 / 20000000 : Rat) /\
    (92799674396483014932650213887 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (50656819 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (448886023 / 100000000 : Rat) - (142066831 / 20000000 : Rat) /\
    (0 : Rat) < (92799674396483014932650213887 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_582 : K11RowValid 582 := by
  change (1 : Rat) <= (163624169 / 20000000 : Rat) /\
    (1335514096649918148794737 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (443968811 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (345051697 / 50000000 : Rat) - (163624169 / 20000000 : Rat) /\
    (0 : Rat) < (1335514096649918148794737 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_583 : K11RowValid 583 := by
  change (1 : Rat) <= (138704149 / 100000000 : Rat) /\
    (453788820571 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (222763891 / 50000000 : Rat) - (138704149 / 100000000 : Rat) /\
    (0 : Rat) < (453788820571 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_584 : K11RowValid 584 := by
  change (1 : Rat) <= (116381871 / 20000000 : Rat) /\
    (18976999092422576338025778661 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (352113127 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (83931069 / 25000000 : Rat) - (116381871 / 20000000 : Rat) /\
    (0 : Rat) < (18976999092422576338025778661 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_585 : K11RowValid 585 := by
  change (1 : Rat) <= (268059403 / 25000000 : Rat) /\
    (875621769509919884394183 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (562505189 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (285730823 / 25000000 : Rat) - (268059403 / 25000000 : Rat) /\
    (0 : Rat) < (875621769509919884394183 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_586 : K11RowValid 586 := by
  change (1 : Rat) <= (577645727 / 100000000 : Rat) /\
    (1883797606833 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (463859987 / 25000000 : Rat) - (577645727 / 100000000 : Rat) /\
    (0 : Rat) < (1883797606833 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_587 : K11RowValid 587 := by
  change (1 : Rat) <= (84511617 / 25000000 : Rat) /\
    (21983883688584649692207793051 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (41029657 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (74749379 / 50000000 : Rat) - (84511617 / 25000000 : Rat) /\
    (0 : Rat) < (21983883688584649692207793051 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_588 : K11RowValid 588 := by
  change (1 : Rat) <= (663552249 / 100000000 : Rat) /\
    (433863784089826936942521 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (700336921 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (113518201 / 20000000 : Rat) - (663552249 / 100000000 : Rat) /\
    (0 : Rat) < (433863784089826936942521 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_589 : K11RowValid 589 := by
  change (1 : Rat) <= (73301501 / 50000000 : Rat) /\
    (240242305779 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (470899471 / 100000000 : Rat) - (73301501 / 50000000 : Rat) /\
    (0 : Rat) < (240242305779 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_590 : K11RowValid 590 := by
  change (1 : Rat) <= (25734467 / 2000000 : Rat) /\
    (168035948857167712087660122737 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (7583709 / 3125000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (860957673 / 100000000 : Rat) - (25734467 / 2000000 : Rat) /\
    (0 : Rat) < (168035948857167712087660122737 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_591 : K11RowValid 591 := by
  change (1 : Rat) <= (610873769 / 100000000 : Rat) /\
    (1995705280124534170180147 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (480152839 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (587809907 / 100000000 : Rat) - (610873769 / 100000000 : Rat) /\
    (0 : Rat) < (1995705280124534170180147 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_592 : K11RowValid 592 := by
  change (1 : Rat) <= (175846809 / 100000000 : Rat) /\
    (575959042711 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (564832699 / 100000000 : Rat) - (175846809 / 100000000 : Rat) /\
    (0 : Rat) < (575959042711 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_593 : K11RowValid 593 := by
  change (1 : Rat) <= (1074581033 / 100000000 : Rat) /\
    (140341888364045840902476981153 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (75363783 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (730506137 / 100000000 : Rat) - (1074581033 / 100000000 : Rat) /\
    (0 : Rat) < (140341888364045840902476981153 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_594 : K11RowValid 594 := by
  change (1 : Rat) <= (133979101 / 25000000 : Rat) /\
    (1745923298837066049443167 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (46253009 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (535994527 / 100000000 : Rat) - (133979101 / 25000000 : Rat) /\
    (0 : Rat) < (1745923298837066049443167 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_595 : K11RowValid 595 := by
  change (1 : Rat) <= (48595601 / 12500000 : Rat) /\
    (158596059679 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (249748149 / 20000000 : Rat) - (48595601 / 12500000 : Rat) /\
    (0 : Rat) < (158596059679 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_596 : K11RowValid 596 := by
  change (1 : Rat) <= (85026989 / 20000000 : Rat) /\
    (55336807571920845814537614509 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (51435961 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (256673861 / 100000000 : Rat) - (85026989 / 20000000 : Rat) /\
    (0 : Rat) < (55336807571920845814537614509 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_597 : K11RowValid 597 := by
  change (1 : Rat) <= (199290271 / 25000000 : Rat) /\
    (325563422672242813479621 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (107430029 / 5000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (20423301 / 12500000 : Rat) - (199290271 / 25000000 : Rat) /\
    (0 : Rat) < (325563422672242813479621 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_598 : K11RowValid 598 := by
  change (1 : Rat) <= (309864451 / 100000000 : Rat) /\
    (1011590018829 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (995307079 / 100000000 : Rat) - (309864451 / 100000000 : Rat) /\
    (0 : Rat) < (1011590018829 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_599 : K11RowValid 599 := by
  change (1 : Rat) <= (10574211 / 1562500 : Rat) /\
    (88288817326751819477826868633 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (170309909 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (443375057 / 100000000 : Rat) - (10574211 / 1562500 : Rat) /\
    (0 : Rat) < (88288817326751819477826868633 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_600 : K11RowValid 600 := by
  change (1 : Rat) <= (1111881023 / 100000000 : Rat) /\
    (3630725989140359695712289 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (287863073 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (845661409 / 100000000 : Rat) - (1111881023 / 100000000 : Rat) /\
    (0 : Rat) < (3630725989140359695712289 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_601 : K11RowValid 601 := by
  change (1 : Rat) <= (89781523 / 50000000 : Rat) /\
    (292735345917 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (7209619 / 1250000 : Rat) - (89781523 / 50000000 : Rat) /\
    (0 : Rat) < (292735345917 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_602 : K11RowValid 602 := by
  change (1 : Rat) <= (720836509 / 50000000 : Rat) /\
    (94145523036042598683021787899 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (802141 / 625000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (498203171 / 50000000 : Rat) - (720836509 / 50000000 : Rat) /\
    (0 : Rat) < (94145523036042598683021787899 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_603 : K11RowValid 603 := by
  change (1 : Rat) <= (645536313 / 100000000 : Rat) /\
    (2105823468840523297272763 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (120387477 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (631415803 / 100000000 : Rat) - (645536313 / 100000000 : Rat) /\
    (0 : Rat) < (2105823468840523297272763 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_604 : K11RowValid 604 := by
  change (1 : Rat) <= (194029031 / 50000000 : Rat) /\
    (631938396649 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (38952207 / 3125000 : Rat) - (194029031 / 50000000 : Rat) /\
    (0 : Rat) < (631938396649 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_605 : K11RowValid 605 := by
  change (1 : Rat) <= (480471267 / 100000000 : Rat) /\
    (31375404571030812444628171071 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (8399291 / 3125000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (141029959 / 50000000 : Rat) - (480471267 / 100000000 : Rat) /\
    (0 : Rat) < (31375404571030812444628171071 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_606 : K11RowValid 606 := by
  change (1 : Rat) <= (1085074201 / 100000000 : Rat) /\
    (3543386440642935533151241 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1528230157 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (170104521 / 100000000 : Rat) - (1085074201 / 100000000 : Rat) /\
    (0 : Rat) < (3543386440642935533151241 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_607 : K11RowValid 607 := by
  change (1 : Rat) <= (254829583 / 100000000 : Rat) /\
    (829600974657 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (204632773 / 25000000 : Rat) - (254829583 / 100000000 : Rat) /\
    (0 : Rat) < (829600974657 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_608 : K11RowValid 608 := by
  change (1 : Rat) <= (24733183 / 2000000 : Rat) /\
    (161285307151746592166215419261 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (29835397 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (813048469 / 100000000 : Rat) - (24733183 / 2000000 : Rat) /\
    (0 : Rat) < (161285307151746592166215419261 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_609 : K11RowValid 609 := by
  change (1 : Rat) <= (601396619 / 50000000 : Rat) /\
    (3926015290186306664371153 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1107614167 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1093045393 / 100000000 : Rat) - (601396619 / 50000000 : Rat) /\
    (0 : Rat) < (3926015290186306664371153 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_610 : K11RowValid 610 := by
  change (1 : Rat) <= (1700469 / 1000000 : Rat) /\
    (5556633851 / 5139312721000000 : Rat) = (1600000000 / 5139312721 : Rat) * (54620297 / 10000000 : Rat) - (1700469 / 1000000 : Rat) /\
    (0 : Rat) < (5556633851 / 5139312721000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_611 : K11RowValid 611 := by
  change (1 : Rat) <= (833056769 / 100000000 : Rat) /\
    (108748582851872510993741073433 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (128970439 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (563634257 / 100000000 : Rat) - (833056769 / 100000000 : Rat) /\
    (0 : Rat) < (108748582851872510993741073433 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_612 : K11RowValid 612 := by
  change (1 : Rat) <= (307338017 / 20000000 : Rat) /\
    (1002618844208173702499741 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (113998527 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (346333021 / 20000000 : Rat) - (307338017 / 20000000 : Rat) /\
    (0 : Rat) < (1002618844208173702499741 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_613 : K11RowValid 613 := by
  change (1 : Rat) <= (201443761 / 100000000 : Rat) /\
    (655726616319 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (323525981 / 50000000 : Rat) - (201443761 / 100000000 : Rat) /\
    (0 : Rat) < (655726616319 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_614 : K11RowValid 614 := by
  change (1 : Rat) <= (584114351 / 100000000 : Rat) /\
    (7645111660338970886152039261 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (191887673 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (33028469 / 10000000 : Rat) - (584114351 / 100000000 : Rat) /\
    (0 : Rat) < (7645111660338970886152039261 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_615 : K11RowValid 615 := by
  change (1 : Rat) <= (44553671 / 12500000 : Rat) /\
    (582698504352384566226941 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (76903877 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (105036221 / 50000000 : Rat) - (44553671 / 12500000 : Rat) /\
    (0 : Rat) < (582698504352384566226941 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_616 : K11RowValid 616 := by
  change (1 : Rat) <= (121296907 / 100000000 : Rat) /\
    (395636946053 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (194807229 / 50000000 : Rat) - (121296907 / 100000000 : Rat) /\
    (0 : Rat) < (395636946053 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_617 : K11RowValid 617 := by
  change (1 : Rat) <= (957550819 / 50000000 : Rat) /\
    (62510931037043998965209564823 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (124268169 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (326585567 / 25000000 : Rat) - (957550819 / 50000000 : Rat) /\
    (0 : Rat) < (62510931037043998965209564823 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_618 : K11RowValid 618 := by
  change (1 : Rat) <= (742339623 / 100000000 : Rat) /\
    (303188299477790046853109 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (586334227 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (89147829 / 12500000 : Rat) - (742339623 / 100000000 : Rat) /\
    (0 : Rat) < (303188299477790046853109 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_619 : K11RowValid 619 := by
  change (1 : Rat) <= (116682921 / 100000000 : Rat) /\
    (381381261959 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (374794001 / 100000000 : Rat) - (116682921 / 100000000 : Rat) /\
    (0 : Rat) < (381381261959 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_620 : K11RowValid 620 := by
  change (1 : Rat) <= (1467799093 / 100000000 : Rat) /\
    (95851618204049363558065197779 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (36846727 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (505381691 / 50000000 : Rat) - (1467799093 / 100000000 : Rat) /\
    (0 : Rat) < (95851618204049363558065197779 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_621 : K11RowValid 621 := by
  change (1 : Rat) <= (207280083 / 25000000 : Rat) /\
    (2701516319659701139770153 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (94504973 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (906364393 / 100000000 : Rat) - (207280083 / 25000000 : Rat) /\
    (0 : Rat) < (2701516319659701139770153 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_622 : K11RowValid 622 := by
  change (1 : Rat) <= (594890941 / 100000000 : Rat) /\
    (1940911039539 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (955416413 / 50000000 : Rat) - (594890941 / 100000000 : Rat) /\
    (0 : Rat) < (1940911039539 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_623 : K11RowValid 623 := by
  change (1 : Rat) <= (382531501 / 100000000 : Rat) /\
    (12466201289984877864833462001 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (262559631 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (53453929 / 25000000 : Rat) - (382531501 / 100000000 : Rat) /\
    (0 : Rat) < (12466201289984877864833462001 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_624 : K11RowValid 624 := by
  change (1 : Rat) <= (64885043 / 10000000 : Rat) /\
    (132529513582197709781079 / 32120704506250000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (850595159 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (9493399 / 6250000 : Rat) - (64885043 / 10000000 : Rat) /\
    (0 : Rat) < (132529513582197709781079 / 32120704506250000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_625 : K11RowValid 625 := by
  change (1 : Rat) <= (1839441 / 781250 : Rat) /\
    (6019171039 / 4015088063281250 : Rat) = (1600000000 / 5139312721 : Rat) * (189069371 / 25000000 : Rat) - (1839441 / 781250 : Rat) /\
    (0 : Rat) < (6019171039 / 4015088063281250 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_626 : K11RowValid 626 := by
  change (1 : Rat) <= (1139367093 / 100000000 : Rat) /\
    (148538287272259129613534541907 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (39763319 / 25000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (774716603 / 100000000 : Rat) - (1139367093 / 100000000 : Rat) /\
    (0 : Rat) < (148538287272259129613534541907 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_627 : K11RowValid 627 := by
  change (1 : Rat) <= (780933787 / 50000000 : Rat) /\
    (1275166235491453423927367 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2757639899 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (224014727 / 25000000 : Rat) - (780933787 / 50000000 : Rat) /\
    (0 : Rat) < (1275166235491453423927367 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_628 : K11RowValid 628 := by
  change (1 : Rat) <= (89075569 / 50000000 : Rat) /\
    (289507986751 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (4470581 / 781250 : Rat) - (89075569 / 50000000 : Rat) /\
    (0 : Rat) < (289507986751 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_629 : K11RowValid 629 := by
  change (1 : Rat) <= (476301477 / 50000000 : Rat) /\
    (62134901447175890050690108499 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (31697421 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (321040571 / 50000000 : Rat) - (476301477 / 50000000 : Rat) /\
    (0 : Rat) < (62134901447175890050690108499 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_630 : K11RowValid 630 := by
  change (1 : Rat) <= (208597499 / 50000000 : Rat) /\
    (1361180114701180576406989 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (54344873 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (423732109 / 100000000 : Rat) - (208597499 / 50000000 : Rat) /\
    (0 : Rat) < (1361180114701180576406989 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_631 : K11RowValid 631 := by
  change (1 : Rat) <= (2209187 / 1000000 : Rat) /\
    (7211832173 / 5139312721000000 : Rat) = (1600000000 / 5139312721 : Rat) * (709606879 / 100000000 : Rat) - (2209187 / 1000000 : Rat) /\
    (0 : Rat) < (7211832173 / 5139312721000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_632 : K11RowValid 632 := by
  change (1 : Rat) <= (65822271 / 20000000 : Rat) /\
    (5365495746077320442122920603 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (406255821 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (18005187 / 12500000 : Rat) - (65822271 / 20000000 : Rat) /\
    (0 : Rat) < (5365495746077320442122920603 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_633 : K11RowValid 633 := by
  change (1 : Rat) <= (756725697 / 100000000 : Rat) /\
    (2467930296341093239755169 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2128473697 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (119854689 / 100000000 : Rat) - (756725697 / 100000000 : Rat) /\
    (0 : Rat) < (2467930296341093239755169 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_634 : K11RowValid 634 := by
  change (1 : Rat) <= (185857453 / 100000000 : Rat) /\
    (605104440387 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (596987611 / 100000000 : Rat) - (185857453 / 100000000 : Rat) /\
    (0 : Rat) < (605104440387 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_635 : K11RowValid 635 := by
  change (1 : Rat) <= (278147029 / 20000000 : Rat) /\
    (22693580571379254456451517051 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (166822151 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (114345379 / 12500000 : Rat) - (278147029 / 20000000 : Rat) /\
    (0 : Rat) < (22693580571379254456451517051 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_636 : K11RowValid 636 := by
  change (1 : Rat) <= (280086261 / 25000000 : Rat) /\
    (914389690561968537340173 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (82386173 / 3125000 : Rat) + (784931055601 / 1000000000000 : Rat) * (95416013 / 25000000 : Rat) - (280086261 / 25000000 : Rat) /\
    (0 : Rat) < (914389690561968537340173 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_637 : K11RowValid 637 := by
  change (1 : Rat) <= (106782911 / 50000000 : Rat) /\
    (348712289169 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (342994451 / 50000000 : Rat) - (106782911 / 50000000 : Rat) /\
    (0 : Rat) < (348712289169 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_638 : K11RowValid 638 := by
  change (1 : Rat) <= (319932199 / 50000000 : Rat) /\
    (20883629440215926553520041011 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (195336513 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (102904219 / 25000000 : Rat) - (319932199 / 50000000 : Rat) /\
    (0 : Rat) < (20883629440215926553520041011 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_639 : K11RowValid 639 := by
  change (1 : Rat) <= (81894981 / 12500000 : Rat) /\
    (267114722629390291432649 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (196491167 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (84850569 / 12500000 : Rat) - (81894981 / 12500000 : Rat) /\
    (0 : Rat) < (267114722629390291432649 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_640 : K11RowValid 640 := by
  change (1 : Rat) <= (364326661 / 100000000 : Rat) /\
    (1190123245419 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (585121823 / 50000000 : Rat) - (364326661 / 100000000 : Rat) /\
    (0 : Rat) < (1190123245419 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_641 : K11RowValid 641 := by
  change (1 : Rat) <= (428166381 / 100000000 : Rat) /\
    (55721682806327850773149721767 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (647316697 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (161106543 / 100000000 : Rat) - (428166381 / 100000000 : Rat) /\
    (0 : Rat) < (55721682806327850773149721767 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_642 : K11RowValid 642 := by
  change (1 : Rat) <= (457681189 / 100000000 : Rat) /\
    (74768813130719542376731 / 25696563605000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (893786313 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (11429211 / 5000000 : Rat) - (457681189 / 100000000 : Rat) /\
    (0 : Rat) < (74768813130719542376731 / 25696563605000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_643 : K11RowValid 643 := by
  change (1 : Rat) <= (17846241 / 12500000 : Rat) /\
    (58006668239 / 64241409012500000 : Rat) = (1600000000 / 5139312721 : Rat) * (458587357 / 100000000 : Rat) - (17846241 / 12500000 : Rat) /\
    (0 : Rat) < (58006668239 / 64241409012500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_644 : K11RowValid 644 := by
  change (1 : Rat) <= (244902417 / 20000000 : Rat) /\
    (376404659103430806091053301 / 48370002080000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (135553359 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (33617693 / 4000000 : Rat) - (244902417 / 20000000 : Rat) /\
    (0 : Rat) < (376404659103430806091053301 / 48370002080000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_645 : K11RowValid 645 := by
  change (1 : Rat) <= (1981681301 / 100000000 : Rat) /\
    (6470940001651261994137281 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (402044629 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2205733761 / 100000000 : Rat) - (1981681301 / 100000000 : Rat) /\
    (0 : Rat) < (6470940001651261994137281 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_646 : K11RowValid 646 := by
  change (1 : Rat) <= (181159761 / 100000000 : Rat) /\
    (591759380319 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (116379657 / 20000000 : Rat) - (181159761 / 100000000 : Rat) /\
    (0 : Rat) < (591759380319 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_647 : K11RowValid 647 := by
  change (1 : Rat) <= (279422281 / 25000000 : Rat) /\
    (14581836360977530449612176363 / 2055725088400000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (91375929 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (75406227 / 10000000 : Rat) - (279422281 / 25000000 : Rat) /\
    (0 : Rat) < (14581836360977530449612176363 / 2055725088400000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_648 : K11RowValid 648 := by
  change (1 : Rat) <= (871379659 / 100000000 : Rat) /\
    (2842780693159531541261807 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (64713431 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (853464367 / 100000000 : Rat) - (871379659 / 100000000 : Rat) /\
    (0 : Rat) < (2842780693159531541261807 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_649 : K11RowValid 649 := by
  change (1 : Rat) <= (402868183 / 100000000 : Rat) /\
    (1316621944057 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1294041809 / 100000000 : Rat) - (402868183 / 100000000 : Rat) /\
    (0 : Rat) < (1316621944057 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_650 : K11RowValid 650 := by
  change (1 : Rat) <= (150650347 / 25000000 : Rat) /\
    (39386757327264715156365090747 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (229455269 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (188788963 / 50000000 : Rat) - (150650347 / 25000000 : Rat) /\
    (0 : Rat) < (39386757327264715156365090747 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_651 : K11RowValid 651 := by
  change (1 : Rat) <= (448998087 / 100000000 : Rat) /\
    (732934653795864002920499 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (719792383 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (143266419 / 50000000 : Rat) - (448998087 / 100000000 : Rat) /\
    (0 : Rat) < (732934653795864002920499 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_652 : K11RowValid 652 := by
  change (1 : Rat) <= (300505059 / 100000000 : Rat) /\
    (980356444461 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (965244033 / 100000000 : Rat) - (300505059 / 100000000 : Rat) /\
    (0 : Rat) < (980356444461 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_653 : K11RowValid 653 := by
  change (1 : Rat) <= (826168711 / 100000000 : Rat) /\
    (26943798482827659863339633159 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (81970279 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (137749711 / 25000000 : Rat) - (826168711 / 100000000 : Rat) /\
    (0 : Rat) < (26943798482827659863339633159 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_654 : K11RowValid 654 := by
  change (1 : Rat) <= (256462337 / 25000000 : Rat) /\
    (418046742398952015060757 / 64241409012500000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (103086359 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (122479317 / 12500000 : Rat) - (256462337 / 25000000 : Rat) /\
    (0 : Rat) < (418046742398952015060757 / 64241409012500000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_655 : K11RowValid 655 := by
  change (1 : Rat) <= (80519759 / 50000000 : Rat) /\
    (263879445761 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (517270607 / 100000000 : Rat) - (80519759 / 50000000 : Rat) /\
    (0 : Rat) < (263879445761 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_656 : K11RowValid 656 := by
  change (1 : Rat) <= (848523403 / 100000000 : Rat) /\
    (22140368989017260619706570787 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (75551527 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (113946123 / 20000000 : Rat) - (848523403 / 100000000 : Rat) /\
    (0 : Rat) < (22140368989017260619706570787 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_657 : K11RowValid 657 := by
  change (1 : Rat) <= (207129011 / 50000000 : Rat) /\
    (10802386157384957159977 / 4111450176800000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (161671353 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (3196137 / 800000 : Rat) - (207129011 / 50000000 : Rat) /\
    (0 : Rat) < (10802386157384957159977 / 4111450176800000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_658 : K11RowValid 658 := by
  change (1 : Rat) <= (88205599 / 50000000 : Rat) /\
    (288595875121 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (566645557 / 100000000 : Rat) - (88205599 / 50000000 : Rat) /\
    (0 : Rat) < (288595875121 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_659 : K11RowValid 659 := by
  change (1 : Rat) <= (288087859 / 100000000 : Rat) /\
    (9362086589674444284924221349 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (45433759 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (38628221 / 25000000 : Rat) - (288087859 / 100000000 : Rat) /\
    (0 : Rat) < (9362086589674444284924221349 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_660 : K11RowValid 660 := by
  change (1 : Rat) <= (1126631907 / 100000000 : Rat) /\
    (3674747414348650075767709 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2802868889 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (323630429 / 100000000 : Rat) - (1126631907 / 100000000 : Rat) /\
    (0 : Rat) < (3674747414348650075767709 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_661 : K11RowValid 661 := by
  change (1 : Rat) <= (430277391 / 100000000 : Rat) /\
    (1402875009089 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (138208217 / 10000000 : Rat) - (430277391 / 100000000 : Rat) /\
    (0 : Rat) < (1402875009089 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_662 : K11RowValid 662 := by
  change (1 : Rat) <= (993010353 / 100000000 : Rat) /\
    (16206584322709682572282709827 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (107011503 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (82314283 / 12500000 : Rat) - (993010353 / 100000000 : Rat) /\
    (0 : Rat) < (16206584322709682572282709827 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_663 : K11RowValid 663 := by
  change (1 : Rat) <= (932170441 / 100000000 : Rat) /\
    (3043506334252715186634669 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (402134511 / 20000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (390094189 / 100000000 : Rat) - (932170441 / 100000000 : Rat) /\
    (0 : Rat) < (3043506334252715186634669 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_664 : K11RowValid 664 := by
  change (1 : Rat) <= (27862601 / 20000000 : Rat) /\
    (90960552679 / 102786254420000000 : Rat) = (1600000000 / 5139312721 : Rat) * (447483471 / 100000000 : Rat) - (27862601 / 20000000 : Rat) /\
    (0 : Rat) < (90960552679 / 102786254420000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_665 : K11RowValid 665 := by
  change (1 : Rat) <= (241407533 / 50000000 : Rat) /\
    (62955882712956086690904677767 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (216792263 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (295230543 / 100000000 : Rat) - (241407533 / 50000000 : Rat) /\
    (0 : Rat) < (62955882712956086690904677767 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_666 : K11RowValid 666 := by
  change (1 : Rat) <= (499467017 / 25000000 : Rat) /\
    (1629276434552923504938987 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (17186913 / 5000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (602235947 / 25000000 : Rat) - (499467017 / 25000000 : Rat) /\
    (0 : Rat) < (1629276434552923504938987 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_667 : K11RowValid 667 := by
  change (1 : Rat) <= (295743281 / 100000000 : Rat) /\
    (963406422399 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (118743607 / 12500000 : Rat) - (295743281 / 100000000 : Rat) /\
    (0 : Rat) < (963406422399 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_668 : K11RowValid 668 := by
  change (1 : Rat) <= (123356057 / 25000000 : Rat) /\
    (32229625165967871238690757529 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (350061627 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (136639441 / 50000000 : Rat) - (123356057 / 25000000 : Rat) /\
    (0 : Rat) < (32229625165967871238690757529 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_669 : K11RowValid 669 := by
  change (1 : Rat) <= (634302563 / 100000000 : Rat) /\
    (2066777421331381254933481 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (996082517 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (413025961 / 100000000 : Rat) - (634302563 / 100000000 : Rat) /\
    (0 : Rat) < (2066777421331381254933481 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_670 : K11RowValid 670 := by
  change (1 : Rat) <= (327710881 / 100000000 : Rat) /\
    (1071666582799 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1052631107 / 100000000 : Rat) - (327710881 / 100000000 : Rat) /\
    (0 : Rat) < (1071666582799 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_671 : K11RowValid 671 := by
  change (1 : Rat) <= (254944343 / 25000000 : Rat) /\
    (133061457552675123058112959861 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (7887759 / 4000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (681265869 / 100000000 : Rat) - (254944343 / 25000000 : Rat) /\
    (0 : Rat) < (133061457552675123058112959861 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_672 : K11RowValid 672 := by
  change (1 : Rat) <= (849754499 / 100000000 : Rat) /\
    (2773737986982256191701099 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (478063 / 125000 : Rat) + (784931055601 / 1000000000000 : Rat) * (930895019 / 100000000 : Rat) - (849754499 / 100000000 : Rat) /\
    (0 : Rat) < (2773737986982256191701099 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_673 : K11RowValid 673 := by
  change (1 : Rat) <= (136168297 / 100000000 : Rat) /\
    (443030993863 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (10934561 / 2500000 : Rat) - (136168297 / 100000000 : Rat) /\
    (0 : Rat) < (443030993863 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_674 : K11RowValid 674 := by
  change (1 : Rat) <= (39125401 / 5000000 : Rat) /\
    (25548451880361847695207172683 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (189302581 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (128587507 / 25000000 : Rat) - (39125401 / 5000000 : Rat) /\
    (0 : Rat) < (25548451880361847695207172683 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_675 : K11RowValid 675 := by
  change (1 : Rat) <= (658847441 / 100000000 : Rat) /\
    (1074946799127535559453287 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (99635379 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (222094247 / 50000000 : Rat) - (658847441 / 100000000 : Rat) /\
    (0 : Rat) < (1074946799127535559453287 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_676 : K11RowValid 676 := by
  change (1 : Rat) <= (117921821 / 50000000 : Rat) /\
    (386051215059 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (189386719 / 25000000 : Rat) - (117921821 / 50000000 : Rat) /\
    (0 : Rat) < (386051215059 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_677 : K11RowValid 677 := by
  change (1 : Rat) <= (211694859 / 50000000 : Rat) /\
    (1101637819640229865778128363 / 411145017680000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (54453423 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (4814227 / 2000000 : Rat) - (211694859 / 50000000 : Rat) /\
    (0 : Rat) < (1101637819640229865778128363 / 411145017680000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_678 : K11RowValid 678 := by
  change (1 : Rat) <= (442029131 / 100000000 : Rat) /\
    (144598091504962381478931 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (97090379 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (25507411 / 10000000 : Rat) - (442029131 / 100000000 : Rat) /\
    (0 : Rat) < (144598091504962381478931 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_679 : K11RowValid 679 := by
  change (1 : Rat) <= (580824477 / 100000000 : Rat) /\
    (1896685728083 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (74626013 / 4000000 : Rat) - (580824477 / 100000000 : Rat) /\
    (0 : Rat) < (1896685728083 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_680 : K11RowValid 680 := by
  change (1 : Rat) <= (668159437 / 100000000 : Rat) /\
    (21804236337915978501464051 / 5139312721000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (187267661 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (108379 / 25000 : Rat) - (668159437 / 100000000 : Rat) /\
    (0 : Rat) < (21804236337915978501464051 / 5139312721000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_681 : K11RowValid 681 := by
  change (1 : Rat) <= (1491391431 / 100000000 : Rat) /\
    (972863715581694359737167 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1728303303 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (105808527 / 20000000 : Rat) - (1491391431 / 100000000 : Rat) /\
    (0 : Rat) < (972863715581694359737167 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_682 : K11RowValid 682 := by
  change (1 : Rat) <= (3027717 / 2000000 : Rat) /\
    (9906312043 / 10278625442000000 : Rat) = (1600000000 / 5139312721 : Rat) * (19450493 / 4000000 : Rat) - (3027717 / 2000000 : Rat) /\
    (0 : Rat) < (9906312043 / 10278625442000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_683 : K11RowValid 683 := by
  change (1 : Rat) <= (3783934139 / 100000000 : Rat) /\
    (494067552811156419428508229699 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (127260959 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (2661635371 / 100000000 : Rat) - (3783934139 / 100000000 : Rat) /\
    (0 : Rat) < (494067552811156419428508229699 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_684 : K11RowValid 684 := by
  change (1 : Rat) <= (461421871 / 100000000 : Rat) /\
    (753100099327257224222369 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (380343211 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (218497889 / 50000000 : Rat) - (461421871 / 100000000 : Rat) /\
    (0 : Rat) < (753100099327257224222369 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_685 : K11RowValid 685 := by
  change (1 : Rat) <= (223175903 / 100000000 : Rat) /\
    (729091437937 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (716857179 / 100000000 : Rat) - (223175903 / 100000000 : Rat) /\
    (0 : Rat) < (729091437937 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_686 : K11RowValid 686 := by
  change (1 : Rat) <= (315745371 / 100000000 : Rat) /\
    (8214906950977114666797750429 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (504864689 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (22543541 / 20000000 : Rat) - (315745371 / 100000000 : Rat) /\
    (0 : Rat) < (8214906950977114666797750429 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_687 : K11RowValid 687 := by
  change (1 : Rat) <= (245967573 / 50000000 : Rat) /\
    (803124772881365235522159 / 256965636050000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1216864663 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (72040879 / 50000000 : Rat) - (245967573 / 50000000 : Rat) /\
    (0 : Rat) < (803124772881365235522159 / 256965636050000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_688 : K11RowValid 688 := by
  change (1 : Rat) <= (199436589 / 100000000 : Rat) /\
    (649119451331 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (32030239 / 5000000 : Rat) - (199436589 / 100000000 : Rat) /\
    (0 : Rat) < (649119451331 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_689 : K11RowValid 689 := by
  change (1 : Rat) <= (479079833 / 25000000 : Rat) /\
    (250129544446406042039011576499 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (25935983 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1304812571 / 100000000 : Rat) - (479079833 / 25000000 : Rat) /\
    (0 : Rat) < (250129544446406042039011576499 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_690 : K11RowValid 690 := by
  change (1 : Rat) <= (641777907 / 100000000 : Rat) /\
    (122983715851776236658097 / 30231251300000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (309243277 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (327005569 / 100000000 : Rat) - (641777907 / 100000000 : Rat) /\
    (0 : Rat) < (122983715851776236658097 / 30231251300000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_691 : K11RowValid 691 := by
  change (1 : Rat) <= (24092979 / 6250000 : Rat) /\
    (78538514141 / 32120704506250000 : Rat) = (1600000000 / 5139312721 : Rat) * (15477679 / 1250000 : Rat) - (24092979 / 6250000 : Rat) /\
    (0 : Rat) < (78538514141 / 32120704506250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_692 : K11RowValid 692 := by
  change (1 : Rat) <= (151958891 / 25000000 : Rat) /\
    (39655608556077131778351596197 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (43265353 / 20000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (192102013 / 50000000 : Rat) - (151958891 / 25000000 : Rat) /\
    (0 : Rat) < (39655608556077131778351596197 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_693 : K11RowValid 693 := by
  change (1 : Rat) <= (51825831 / 6250000 : Rat) /\
    (2706938358534838260702263 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (28795447 / 10000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (942205303 / 100000000 : Rat) - (51825831 / 6250000 : Rat) /\
    (0 : Rat) < (2706938358534838260702263 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_694 : K11RowValid 694 := by
  change (1 : Rat) <= (213873677 / 100000000 : Rat) /\
    (700706854883 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (171744439 / 25000000 : Rat) - (213873677 / 100000000 : Rat) /\
    (0 : Rat) < (700706854883 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_695 : K11RowValid 695 := by
  change (1 : Rat) <= (357043821 / 100000000 : Rat) /\
    (2910629978321220588836484737 / 1284828180250000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (333082733 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (11255673 / 6250000 : Rat) - (357043821 / 100000000 : Rat) /\
    (0 : Rat) < (2910629978321220588836484737 / 1284828180250000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_696 : K11RowValid 696 := by
  change (1 : Rat) <= (394138203 / 100000000 : Rat) /\
    (51374446759560481582719 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (787829621 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (7586239 / 4000000 : Rat) - (394138203 / 100000000 : Rat) /\
    (0 : Rat) < (51374446759560481582719 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_697 : K11RowValid 697 := by
  change (1 : Rat) <= (208934707 / 100000000 : Rat) /\
    (680856492253 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (41944589 / 6250000 : Rat) - (208934707 / 100000000 : Rat) /\
    (0 : Rat) < (680856492253 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_698 : K11RowValid 698 := by
  change (1 : Rat) <= (2043327131 / 100000000 : Rat) /\
    (266949015052738724963570078517 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (132658639 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1393777293 / 100000000 : Rat) - (2043327131 / 100000000 : Rat) /\
    (0 : Rat) < (266949015052738724963570078517 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_699 : K11RowValid 699 := by
  change (1 : Rat) <= (294367637 / 25000000 : Rat) /\
    (3841118247806271876213409 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (191970193 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1195532129 / 100000000 : Rat) - (294367637 / 25000000 : Rat) /\
    (0 : Rat) < (3841118247806271876213409 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_700 : K11RowValid 700 := by
  change (1 : Rat) <= (114612471 / 100000000 : Rat) /\
    (375404456409 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (184071783 / 50000000 : Rat) - (114612471 / 100000000 : Rat) /\
    (0 : Rat) < (375404456409 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_701 : K11RowValid 701 := by
  change (1 : Rat) <= (554035791 / 20000000 : Rat) /\
    (18082424822032763387565746157 / 1027862544200000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (112409577 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (97214853 / 5000000 : Rat) - (554035791 / 20000000 : Rat) /\
    (0 : Rat) < (18082424822032763387565746157 / 1027862544200000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_702 : K11RowValid 702 := by
  change (1 : Rat) <= (920219 / 125000 : Rat) /\
    (239909107514809982575667 / 51393127210000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (480590061 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (74727027 / 10000000 : Rat) - (920219 / 125000 : Rat) /\
    (0 : Rat) < (239909107514809982575667 / 51393127210000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_703 : K11RowValid 703 := by
  change (1 : Rat) <= (438310953 / 100000000 : Rat) /\
    (1433093466887 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (351971639 / 25000000 : Rat) - (438310953 / 100000000 : Rat) /\
    (0 : Rat) < (1433093466887 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_704 : K11RowValid 704 := by
  change (1 : Rat) <= (449474419 / 100000000 : Rat) /\
    (1833744618066881124824189371 / 642414090125000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (105118641 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (8530659 / 3125000 : Rat) - (449474419 / 100000000 : Rat) /\
    (0 : Rat) < (1833744618066881124824189371 / 642414090125000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_705 : K11RowValid 705 := by
  change (1 : Rat) <= (253311183 / 50000000 : Rat) /\
    (1651272520579192297987469 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1292306271 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (132870989 / 100000000 : Rat) - (253311183 / 50000000 : Rat) /\
    (0 : Rat) < (1651272520579192297987469 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_706 : K11RowValid 706 := by
  change (1 : Rat) <= (6996553 / 3125000 : Rat) /\
    (22863949287 / 16060352253125000 : Rat) = (1600000000 / 5139312721 : Rat) * (359574967 / 50000000 : Rat) - (6996553 / 3125000 : Rat) /\
    (0 : Rat) < (22863949287 / 16060352253125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_707 : K11RowValid 707 := by
  change (1 : Rat) <= (118929297 / 20000000 : Rat) /\
    (38842664291749894308444923199 / 10278625442000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (85648883 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (192396871 / 50000000 : Rat) - (118929297 / 20000000 : Rat) /\
    (0 : Rat) < (38842664291749894308444923199 / 10278625442000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_708 : K11RowValid 708 := by
  change (1 : Rat) <= (316258751 / 20000000 : Rat) /\
    (5159924514273599798004009 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (904618863 / 50000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (1296970729 / 100000000 : Rat) - (316258751 / 20000000 : Rat) /\
    (0 : Rat) < (5159924514273599798004009 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_709 : K11RowValid 709 := by
  change (1 : Rat) <= (5153011 / 4000000 : Rat) /\
    (16760247069 / 20557250884000000 : Rat) = (1600000000 / 5139312721 : Rat) * (413796121 / 100000000 : Rat) - (5153011 / 4000000 : Rat) /\
    (0 : Rat) < (16760247069 / 20557250884000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_710 : K11RowValid 710 := by
  change (1 : Rat) <= (831500501 / 50000000 : Rat) /\
    (217187386853221032486356618579 / 20557250884000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (193554963 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (1139304891 / 100000000 : Rat) - (831500501 / 50000000 : Rat) /\
    (0 : Rat) < (217187386853221032486356618579 / 20557250884000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_711 : K11RowValid 711 := by
  change (1 : Rat) <= (50017937 / 10000000 : Rat) /\
    (65316986623835840042509 / 20557250884000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (2773299 / 1000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (21089229 / 4000000 : Rat) - (50017937 / 10000000 : Rat) /\
    (0 : Rat) < (65316986623835840042509 / 20557250884000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_712 : K11RowValid 712 := by
  change (1 : Rat) <= (280359763 / 100000000 : Rat) /\
    (913157554877 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (900535881 / 100000000 : Rat) - (280359763 / 100000000 : Rat) /\
    (0 : Rat) < (913157554877 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_713 : K11RowValid 713 := by
  change (1 : Rat) <= (4844327 / 1250000 : Rat) /\
    (10132315338539026766020576537 / 4111450176800000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (306349943 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (41537873 / 20000000 : Rat) - (4844327 / 1250000 : Rat) /\
    (0 : Rat) < (10132315338539026766020576537 / 4111450176800000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_714 : K11RowValid 714 := by
  change (1 : Rat) <= (53513911 / 12500000 : Rat) /\
    (350002465450190418973933 / 128482818025000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (1040397053 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (33190573 / 25000000 : Rat) - (53513911 / 12500000 : Rat) /\
    (0 : Rat) < (350002465450190418973933 / 128482818025000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_715 : K11RowValid 715 := by
  change (1 : Rat) <= (193028801 / 100000000 : Rat) /\
    (629101322479 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (620022501 / 100000000 : Rat) - (193028801 / 100000000 : Rat) /\
    (0 : Rat) < (629101322479 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_716 : K11RowValid 716 := by
  change (1 : Rat) <= (752631207 / 50000000 : Rat) /\
    (49150302087845037383119027403 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (583457503 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (235222387 / 25000000 : Rat) - (752631207 / 50000000 : Rat) /\
    (0 : Rat) < (49150302087845037383119027403 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_717 : K11RowValid 717 := by
  change (1 : Rat) <= (237787599 / 12500000 : Rat) /\
    (1241902217538275208768467 / 102786254420000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (5107577143 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (79543827 / 20000000 : Rat) - (237787599 / 12500000 : Rat) /\
    (0 : Rat) < (1241902217538275208768467 / 102786254420000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_718 : K11RowValid 718 := by
  change (1 : Rat) <= (85971259 / 50000000 : Rat) /\
    (279780914261 / 256965636050000000 : Rat) = (1600000000 / 5139312721 : Rat) * (552291831 / 100000000 : Rat) - (85971259 / 50000000 : Rat) /\
    (0 : Rat) < (279780914261 / 256965636050000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_719 : K11RowValid 719 := by
  change (1 : Rat) <= (576371999 / 100000000 : Rat) /\
    (4424922625388546084398496149 / 1209250052000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (33038701 / 10000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (336596157 / 100000000 : Rat) - (576371999 / 100000000 : Rat) /\
    (0 : Rat) < (4424922625388546084398496149 / 1209250052000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_720 : K11RowValid 720 := by
  change (1 : Rat) <= (873995839 / 100000000 : Rat) /\
    (2853287581273423518023271 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (483853939 / 100000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (921558951 / 100000000 : Rat) - (873995839 / 100000000 : Rat) /\
    (0 : Rat) < (2853287581273423518023271 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_721 : K11RowValid 721 := by
  change (1 : Rat) <= (77097317 / 25000000 : Rat) /\
    (251986930443 / 128482818025000000 : Rat) = (1600000000 / 5139312721 : Rat) * (198113737 / 20000000 : Rat) - (77097317 / 25000000 : Rat) /\
    (0 : Rat) < (251986930443 / 128482818025000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_722 : K11RowValid 722 := by
  change (1 : Rat) <= (91990647 / 20000000 : Rat) /\
    (1500488965451279237724484853 / 513931272100000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (291947921 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (4943437 / 2500000 : Rat) - (91990647 / 20000000 : Rat) /\
    (0 : Rat) < (1500488965451279237724484853 / 513931272100000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_723 : K11RowValid 723 := by
  change (1 : Rat) <= (25595419 / 6250000 : Rat) /\
    (1339612170078238168960417 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (73540073 / 12500000 : Rat) + (784931055601 / 1000000000000 : Rat) * (288391777 / 100000000 : Rat) - (25595419 / 6250000 : Rat) /\
    (0 : Rat) < (1339612170078238168960417 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_724 : K11RowValid 724 := by
  change (1 : Rat) <= (134270721 / 100000000 : Rat) /\
    (436306858159 / 513931272100000000 : Rat) = (1600000000 / 5139312721 : Rat) * (53910911 / 12500000 : Rat) - (134270721 / 100000000 : Rat) /\
    (0 : Rat) < (436306858159 / 513931272100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_725 : K11RowValid 725 := by
  change (1 : Rat) <= (740527767 / 50000000 : Rat) /\
    (48309817074172305382831840017 / 5139312721000000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (189607011 / 100000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (252710793 / 25000000 : Rat) - (740527767 / 50000000 : Rat) /\
    (0 : Rat) < (48309817074172305382831840017 / 5139312721000000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_726 : K11RowValid 726 := by
  change (1 : Rat) <= (2239395009 / 100000000 : Rat) /\
    (7306108888297857223790321 / 513931272100000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (158583637 / 25000000 : Rat) + (784931055601 / 1000000000000 : Rat) * (2601390001 / 100000000 : Rat) - (2239395009 / 100000000 : Rat) /\
    (0 : Rat) < (7306108888297857223790321 / 513931272100000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_727 : K11RowValid 727 := by
  change (1 : Rat) <= (6931449 / 5000000 : Rat) /\
    (22539337271 / 25696563605000000 : Rat) = (1600000000 / 5139312721 : Rat) * (111321583 / 25000000 : Rat) - (6931449 / 5000000 : Rat) /\
    (0 : Rat) < (22539337271 / 25696563605000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_row_valid_728 : K11RowValid 728 := by
  change (1 : Rat) <= (3666603639 / 100000000 : Rat) /\
    (59815574499293691698742778681 / 2569656360500000000000000000000000 : Rat) = (1600000000 / 5139312721 : Rat) * (67774369 / 50000000 : Rat) + (56270922444980089 / 40000000000000000 : Rat) * (322049649 / 12500000 : Rat) - (3666603639 / 100000000 : Rat) /\
    (0 : Rat) < (59815574499293691698742778681 / 2569656360500000000000000000000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial⟩

theorem k11_rows_shard_0 (index : Nat)
    (hlo : 0 <= index) (hhi : index < 729) :
    K11RowValid index := by
  interval_cases index
  · exact k11_row_valid_0
  · exact k11_row_valid_1
  · exact k11_row_valid_2
  · exact k11_row_valid_3
  · exact k11_row_valid_4
  · exact k11_row_valid_5
  · exact k11_row_valid_6
  · exact k11_row_valid_7
  · exact k11_row_valid_8
  · exact k11_row_valid_9
  · exact k11_row_valid_10
  · exact k11_row_valid_11
  · exact k11_row_valid_12
  · exact k11_row_valid_13
  · exact k11_row_valid_14
  · exact k11_row_valid_15
  · exact k11_row_valid_16
  · exact k11_row_valid_17
  · exact k11_row_valid_18
  · exact k11_row_valid_19
  · exact k11_row_valid_20
  · exact k11_row_valid_21
  · exact k11_row_valid_22
  · exact k11_row_valid_23
  · exact k11_row_valid_24
  · exact k11_row_valid_25
  · exact k11_row_valid_26
  · exact k11_row_valid_27
  · exact k11_row_valid_28
  · exact k11_row_valid_29
  · exact k11_row_valid_30
  · exact k11_row_valid_31
  · exact k11_row_valid_32
  · exact k11_row_valid_33
  · exact k11_row_valid_34
  · exact k11_row_valid_35
  · exact k11_row_valid_36
  · exact k11_row_valid_37
  · exact k11_row_valid_38
  · exact k11_row_valid_39
  · exact k11_row_valid_40
  · exact k11_row_valid_41
  · exact k11_row_valid_42
  · exact k11_row_valid_43
  · exact k11_row_valid_44
  · exact k11_row_valid_45
  · exact k11_row_valid_46
  · exact k11_row_valid_47
  · exact k11_row_valid_48
  · exact k11_row_valid_49
  · exact k11_row_valid_50
  · exact k11_row_valid_51
  · exact k11_row_valid_52
  · exact k11_row_valid_53
  · exact k11_row_valid_54
  · exact k11_row_valid_55
  · exact k11_row_valid_56
  · exact k11_row_valid_57
  · exact k11_row_valid_58
  · exact k11_row_valid_59
  · exact k11_row_valid_60
  · exact k11_row_valid_61
  · exact k11_row_valid_62
  · exact k11_row_valid_63
  · exact k11_row_valid_64
  · exact k11_row_valid_65
  · exact k11_row_valid_66
  · exact k11_row_valid_67
  · exact k11_row_valid_68
  · exact k11_row_valid_69
  · exact k11_row_valid_70
  · exact k11_row_valid_71
  · exact k11_row_valid_72
  · exact k11_row_valid_73
  · exact k11_row_valid_74
  · exact k11_row_valid_75
  · exact k11_row_valid_76
  · exact k11_row_valid_77
  · exact k11_row_valid_78
  · exact k11_row_valid_79
  · exact k11_row_valid_80
  · exact k11_row_valid_81
  · exact k11_row_valid_82
  · exact k11_row_valid_83
  · exact k11_row_valid_84
  · exact k11_row_valid_85
  · exact k11_row_valid_86
  · exact k11_row_valid_87
  · exact k11_row_valid_88
  · exact k11_row_valid_89
  · exact k11_row_valid_90
  · exact k11_row_valid_91
  · exact k11_row_valid_92
  · exact k11_row_valid_93
  · exact k11_row_valid_94
  · exact k11_row_valid_95
  · exact k11_row_valid_96
  · exact k11_row_valid_97
  · exact k11_row_valid_98
  · exact k11_row_valid_99
  · exact k11_row_valid_100
  · exact k11_row_valid_101
  · exact k11_row_valid_102
  · exact k11_row_valid_103
  · exact k11_row_valid_104
  · exact k11_row_valid_105
  · exact k11_row_valid_106
  · exact k11_row_valid_107
  · exact k11_row_valid_108
  · exact k11_row_valid_109
  · exact k11_row_valid_110
  · exact k11_row_valid_111
  · exact k11_row_valid_112
  · exact k11_row_valid_113
  · exact k11_row_valid_114
  · exact k11_row_valid_115
  · exact k11_row_valid_116
  · exact k11_row_valid_117
  · exact k11_row_valid_118
  · exact k11_row_valid_119
  · exact k11_row_valid_120
  · exact k11_row_valid_121
  · exact k11_row_valid_122
  · exact k11_row_valid_123
  · exact k11_row_valid_124
  · exact k11_row_valid_125
  · exact k11_row_valid_126
  · exact k11_row_valid_127
  · exact k11_row_valid_128
  · exact k11_row_valid_129
  · exact k11_row_valid_130
  · exact k11_row_valid_131
  · exact k11_row_valid_132
  · exact k11_row_valid_133
  · exact k11_row_valid_134
  · exact k11_row_valid_135
  · exact k11_row_valid_136
  · exact k11_row_valid_137
  · exact k11_row_valid_138
  · exact k11_row_valid_139
  · exact k11_row_valid_140
  · exact k11_row_valid_141
  · exact k11_row_valid_142
  · exact k11_row_valid_143
  · exact k11_row_valid_144
  · exact k11_row_valid_145
  · exact k11_row_valid_146
  · exact k11_row_valid_147
  · exact k11_row_valid_148
  · exact k11_row_valid_149
  · exact k11_row_valid_150
  · exact k11_row_valid_151
  · exact k11_row_valid_152
  · exact k11_row_valid_153
  · exact k11_row_valid_154
  · exact k11_row_valid_155
  · exact k11_row_valid_156
  · exact k11_row_valid_157
  · exact k11_row_valid_158
  · exact k11_row_valid_159
  · exact k11_row_valid_160
  · exact k11_row_valid_161
  · exact k11_row_valid_162
  · exact k11_row_valid_163
  · exact k11_row_valid_164
  · exact k11_row_valid_165
  · exact k11_row_valid_166
  · exact k11_row_valid_167
  · exact k11_row_valid_168
  · exact k11_row_valid_169
  · exact k11_row_valid_170
  · exact k11_row_valid_171
  · exact k11_row_valid_172
  · exact k11_row_valid_173
  · exact k11_row_valid_174
  · exact k11_row_valid_175
  · exact k11_row_valid_176
  · exact k11_row_valid_177
  · exact k11_row_valid_178
  · exact k11_row_valid_179
  · exact k11_row_valid_180
  · exact k11_row_valid_181
  · exact k11_row_valid_182
  · exact k11_row_valid_183
  · exact k11_row_valid_184
  · exact k11_row_valid_185
  · exact k11_row_valid_186
  · exact k11_row_valid_187
  · exact k11_row_valid_188
  · exact k11_row_valid_189
  · exact k11_row_valid_190
  · exact k11_row_valid_191
  · exact k11_row_valid_192
  · exact k11_row_valid_193
  · exact k11_row_valid_194
  · exact k11_row_valid_195
  · exact k11_row_valid_196
  · exact k11_row_valid_197
  · exact k11_row_valid_198
  · exact k11_row_valid_199
  · exact k11_row_valid_200
  · exact k11_row_valid_201
  · exact k11_row_valid_202
  · exact k11_row_valid_203
  · exact k11_row_valid_204
  · exact k11_row_valid_205
  · exact k11_row_valid_206
  · exact k11_row_valid_207
  · exact k11_row_valid_208
  · exact k11_row_valid_209
  · exact k11_row_valid_210
  · exact k11_row_valid_211
  · exact k11_row_valid_212
  · exact k11_row_valid_213
  · exact k11_row_valid_214
  · exact k11_row_valid_215
  · exact k11_row_valid_216
  · exact k11_row_valid_217
  · exact k11_row_valid_218
  · exact k11_row_valid_219
  · exact k11_row_valid_220
  · exact k11_row_valid_221
  · exact k11_row_valid_222
  · exact k11_row_valid_223
  · exact k11_row_valid_224
  · exact k11_row_valid_225
  · exact k11_row_valid_226
  · exact k11_row_valid_227
  · exact k11_row_valid_228
  · exact k11_row_valid_229
  · exact k11_row_valid_230
  · exact k11_row_valid_231
  · exact k11_row_valid_232
  · exact k11_row_valid_233
  · exact k11_row_valid_234
  · exact k11_row_valid_235
  · exact k11_row_valid_236
  · exact k11_row_valid_237
  · exact k11_row_valid_238
  · exact k11_row_valid_239
  · exact k11_row_valid_240
  · exact k11_row_valid_241
  · exact k11_row_valid_242
  · exact k11_row_valid_243
  · exact k11_row_valid_244
  · exact k11_row_valid_245
  · exact k11_row_valid_246
  · exact k11_row_valid_247
  · exact k11_row_valid_248
  · exact k11_row_valid_249
  · exact k11_row_valid_250
  · exact k11_row_valid_251
  · exact k11_row_valid_252
  · exact k11_row_valid_253
  · exact k11_row_valid_254
  · exact k11_row_valid_255
  · exact k11_row_valid_256
  · exact k11_row_valid_257
  · exact k11_row_valid_258
  · exact k11_row_valid_259
  · exact k11_row_valid_260
  · exact k11_row_valid_261
  · exact k11_row_valid_262
  · exact k11_row_valid_263
  · exact k11_row_valid_264
  · exact k11_row_valid_265
  · exact k11_row_valid_266
  · exact k11_row_valid_267
  · exact k11_row_valid_268
  · exact k11_row_valid_269
  · exact k11_row_valid_270
  · exact k11_row_valid_271
  · exact k11_row_valid_272
  · exact k11_row_valid_273
  · exact k11_row_valid_274
  · exact k11_row_valid_275
  · exact k11_row_valid_276
  · exact k11_row_valid_277
  · exact k11_row_valid_278
  · exact k11_row_valid_279
  · exact k11_row_valid_280
  · exact k11_row_valid_281
  · exact k11_row_valid_282
  · exact k11_row_valid_283
  · exact k11_row_valid_284
  · exact k11_row_valid_285
  · exact k11_row_valid_286
  · exact k11_row_valid_287
  · exact k11_row_valid_288
  · exact k11_row_valid_289
  · exact k11_row_valid_290
  · exact k11_row_valid_291
  · exact k11_row_valid_292
  · exact k11_row_valid_293
  · exact k11_row_valid_294
  · exact k11_row_valid_295
  · exact k11_row_valid_296
  · exact k11_row_valid_297
  · exact k11_row_valid_298
  · exact k11_row_valid_299
  · exact k11_row_valid_300
  · exact k11_row_valid_301
  · exact k11_row_valid_302
  · exact k11_row_valid_303
  · exact k11_row_valid_304
  · exact k11_row_valid_305
  · exact k11_row_valid_306
  · exact k11_row_valid_307
  · exact k11_row_valid_308
  · exact k11_row_valid_309
  · exact k11_row_valid_310
  · exact k11_row_valid_311
  · exact k11_row_valid_312
  · exact k11_row_valid_313
  · exact k11_row_valid_314
  · exact k11_row_valid_315
  · exact k11_row_valid_316
  · exact k11_row_valid_317
  · exact k11_row_valid_318
  · exact k11_row_valid_319
  · exact k11_row_valid_320
  · exact k11_row_valid_321
  · exact k11_row_valid_322
  · exact k11_row_valid_323
  · exact k11_row_valid_324
  · exact k11_row_valid_325
  · exact k11_row_valid_326
  · exact k11_row_valid_327
  · exact k11_row_valid_328
  · exact k11_row_valid_329
  · exact k11_row_valid_330
  · exact k11_row_valid_331
  · exact k11_row_valid_332
  · exact k11_row_valid_333
  · exact k11_row_valid_334
  · exact k11_row_valid_335
  · exact k11_row_valid_336
  · exact k11_row_valid_337
  · exact k11_row_valid_338
  · exact k11_row_valid_339
  · exact k11_row_valid_340
  · exact k11_row_valid_341
  · exact k11_row_valid_342
  · exact k11_row_valid_343
  · exact k11_row_valid_344
  · exact k11_row_valid_345
  · exact k11_row_valid_346
  · exact k11_row_valid_347
  · exact k11_row_valid_348
  · exact k11_row_valid_349
  · exact k11_row_valid_350
  · exact k11_row_valid_351
  · exact k11_row_valid_352
  · exact k11_row_valid_353
  · exact k11_row_valid_354
  · exact k11_row_valid_355
  · exact k11_row_valid_356
  · exact k11_row_valid_357
  · exact k11_row_valid_358
  · exact k11_row_valid_359
  · exact k11_row_valid_360
  · exact k11_row_valid_361
  · exact k11_row_valid_362
  · exact k11_row_valid_363
  · exact k11_row_valid_364
  · exact k11_row_valid_365
  · exact k11_row_valid_366
  · exact k11_row_valid_367
  · exact k11_row_valid_368
  · exact k11_row_valid_369
  · exact k11_row_valid_370
  · exact k11_row_valid_371
  · exact k11_row_valid_372
  · exact k11_row_valid_373
  · exact k11_row_valid_374
  · exact k11_row_valid_375
  · exact k11_row_valid_376
  · exact k11_row_valid_377
  · exact k11_row_valid_378
  · exact k11_row_valid_379
  · exact k11_row_valid_380
  · exact k11_row_valid_381
  · exact k11_row_valid_382
  · exact k11_row_valid_383
  · exact k11_row_valid_384
  · exact k11_row_valid_385
  · exact k11_row_valid_386
  · exact k11_row_valid_387
  · exact k11_row_valid_388
  · exact k11_row_valid_389
  · exact k11_row_valid_390
  · exact k11_row_valid_391
  · exact k11_row_valid_392
  · exact k11_row_valid_393
  · exact k11_row_valid_394
  · exact k11_row_valid_395
  · exact k11_row_valid_396
  · exact k11_row_valid_397
  · exact k11_row_valid_398
  · exact k11_row_valid_399
  · exact k11_row_valid_400
  · exact k11_row_valid_401
  · exact k11_row_valid_402
  · exact k11_row_valid_403
  · exact k11_row_valid_404
  · exact k11_row_valid_405
  · exact k11_row_valid_406
  · exact k11_row_valid_407
  · exact k11_row_valid_408
  · exact k11_row_valid_409
  · exact k11_row_valid_410
  · exact k11_row_valid_411
  · exact k11_row_valid_412
  · exact k11_row_valid_413
  · exact k11_row_valid_414
  · exact k11_row_valid_415
  · exact k11_row_valid_416
  · exact k11_row_valid_417
  · exact k11_row_valid_418
  · exact k11_row_valid_419
  · exact k11_row_valid_420
  · exact k11_row_valid_421
  · exact k11_row_valid_422
  · exact k11_row_valid_423
  · exact k11_row_valid_424
  · exact k11_row_valid_425
  · exact k11_row_valid_426
  · exact k11_row_valid_427
  · exact k11_row_valid_428
  · exact k11_row_valid_429
  · exact k11_row_valid_430
  · exact k11_row_valid_431
  · exact k11_row_valid_432
  · exact k11_row_valid_433
  · exact k11_row_valid_434
  · exact k11_row_valid_435
  · exact k11_row_valid_436
  · exact k11_row_valid_437
  · exact k11_row_valid_438
  · exact k11_row_valid_439
  · exact k11_row_valid_440
  · exact k11_row_valid_441
  · exact k11_row_valid_442
  · exact k11_row_valid_443
  · exact k11_row_valid_444
  · exact k11_row_valid_445
  · exact k11_row_valid_446
  · exact k11_row_valid_447
  · exact k11_row_valid_448
  · exact k11_row_valid_449
  · exact k11_row_valid_450
  · exact k11_row_valid_451
  · exact k11_row_valid_452
  · exact k11_row_valid_453
  · exact k11_row_valid_454
  · exact k11_row_valid_455
  · exact k11_row_valid_456
  · exact k11_row_valid_457
  · exact k11_row_valid_458
  · exact k11_row_valid_459
  · exact k11_row_valid_460
  · exact k11_row_valid_461
  · exact k11_row_valid_462
  · exact k11_row_valid_463
  · exact k11_row_valid_464
  · exact k11_row_valid_465
  · exact k11_row_valid_466
  · exact k11_row_valid_467
  · exact k11_row_valid_468
  · exact k11_row_valid_469
  · exact k11_row_valid_470
  · exact k11_row_valid_471
  · exact k11_row_valid_472
  · exact k11_row_valid_473
  · exact k11_row_valid_474
  · exact k11_row_valid_475
  · exact k11_row_valid_476
  · exact k11_row_valid_477
  · exact k11_row_valid_478
  · exact k11_row_valid_479
  · exact k11_row_valid_480
  · exact k11_row_valid_481
  · exact k11_row_valid_482
  · exact k11_row_valid_483
  · exact k11_row_valid_484
  · exact k11_row_valid_485
  · exact k11_row_valid_486
  · exact k11_row_valid_487
  · exact k11_row_valid_488
  · exact k11_row_valid_489
  · exact k11_row_valid_490
  · exact k11_row_valid_491
  · exact k11_row_valid_492
  · exact k11_row_valid_493
  · exact k11_row_valid_494
  · exact k11_row_valid_495
  · exact k11_row_valid_496
  · exact k11_row_valid_497
  · exact k11_row_valid_498
  · exact k11_row_valid_499
  · exact k11_row_valid_500
  · exact k11_row_valid_501
  · exact k11_row_valid_502
  · exact k11_row_valid_503
  · exact k11_row_valid_504
  · exact k11_row_valid_505
  · exact k11_row_valid_506
  · exact k11_row_valid_507
  · exact k11_row_valid_508
  · exact k11_row_valid_509
  · exact k11_row_valid_510
  · exact k11_row_valid_511
  · exact k11_row_valid_512
  · exact k11_row_valid_513
  · exact k11_row_valid_514
  · exact k11_row_valid_515
  · exact k11_row_valid_516
  · exact k11_row_valid_517
  · exact k11_row_valid_518
  · exact k11_row_valid_519
  · exact k11_row_valid_520
  · exact k11_row_valid_521
  · exact k11_row_valid_522
  · exact k11_row_valid_523
  · exact k11_row_valid_524
  · exact k11_row_valid_525
  · exact k11_row_valid_526
  · exact k11_row_valid_527
  · exact k11_row_valid_528
  · exact k11_row_valid_529
  · exact k11_row_valid_530
  · exact k11_row_valid_531
  · exact k11_row_valid_532
  · exact k11_row_valid_533
  · exact k11_row_valid_534
  · exact k11_row_valid_535
  · exact k11_row_valid_536
  · exact k11_row_valid_537
  · exact k11_row_valid_538
  · exact k11_row_valid_539
  · exact k11_row_valid_540
  · exact k11_row_valid_541
  · exact k11_row_valid_542
  · exact k11_row_valid_543
  · exact k11_row_valid_544
  · exact k11_row_valid_545
  · exact k11_row_valid_546
  · exact k11_row_valid_547
  · exact k11_row_valid_548
  · exact k11_row_valid_549
  · exact k11_row_valid_550
  · exact k11_row_valid_551
  · exact k11_row_valid_552
  · exact k11_row_valid_553
  · exact k11_row_valid_554
  · exact k11_row_valid_555
  · exact k11_row_valid_556
  · exact k11_row_valid_557
  · exact k11_row_valid_558
  · exact k11_row_valid_559
  · exact k11_row_valid_560
  · exact k11_row_valid_561
  · exact k11_row_valid_562
  · exact k11_row_valid_563
  · exact k11_row_valid_564
  · exact k11_row_valid_565
  · exact k11_row_valid_566
  · exact k11_row_valid_567
  · exact k11_row_valid_568
  · exact k11_row_valid_569
  · exact k11_row_valid_570
  · exact k11_row_valid_571
  · exact k11_row_valid_572
  · exact k11_row_valid_573
  · exact k11_row_valid_574
  · exact k11_row_valid_575
  · exact k11_row_valid_576
  · exact k11_row_valid_577
  · exact k11_row_valid_578
  · exact k11_row_valid_579
  · exact k11_row_valid_580
  · exact k11_row_valid_581
  · exact k11_row_valid_582
  · exact k11_row_valid_583
  · exact k11_row_valid_584
  · exact k11_row_valid_585
  · exact k11_row_valid_586
  · exact k11_row_valid_587
  · exact k11_row_valid_588
  · exact k11_row_valid_589
  · exact k11_row_valid_590
  · exact k11_row_valid_591
  · exact k11_row_valid_592
  · exact k11_row_valid_593
  · exact k11_row_valid_594
  · exact k11_row_valid_595
  · exact k11_row_valid_596
  · exact k11_row_valid_597
  · exact k11_row_valid_598
  · exact k11_row_valid_599
  · exact k11_row_valid_600
  · exact k11_row_valid_601
  · exact k11_row_valid_602
  · exact k11_row_valid_603
  · exact k11_row_valid_604
  · exact k11_row_valid_605
  · exact k11_row_valid_606
  · exact k11_row_valid_607
  · exact k11_row_valid_608
  · exact k11_row_valid_609
  · exact k11_row_valid_610
  · exact k11_row_valid_611
  · exact k11_row_valid_612
  · exact k11_row_valid_613
  · exact k11_row_valid_614
  · exact k11_row_valid_615
  · exact k11_row_valid_616
  · exact k11_row_valid_617
  · exact k11_row_valid_618
  · exact k11_row_valid_619
  · exact k11_row_valid_620
  · exact k11_row_valid_621
  · exact k11_row_valid_622
  · exact k11_row_valid_623
  · exact k11_row_valid_624
  · exact k11_row_valid_625
  · exact k11_row_valid_626
  · exact k11_row_valid_627
  · exact k11_row_valid_628
  · exact k11_row_valid_629
  · exact k11_row_valid_630
  · exact k11_row_valid_631
  · exact k11_row_valid_632
  · exact k11_row_valid_633
  · exact k11_row_valid_634
  · exact k11_row_valid_635
  · exact k11_row_valid_636
  · exact k11_row_valid_637
  · exact k11_row_valid_638
  · exact k11_row_valid_639
  · exact k11_row_valid_640
  · exact k11_row_valid_641
  · exact k11_row_valid_642
  · exact k11_row_valid_643
  · exact k11_row_valid_644
  · exact k11_row_valid_645
  · exact k11_row_valid_646
  · exact k11_row_valid_647
  · exact k11_row_valid_648
  · exact k11_row_valid_649
  · exact k11_row_valid_650
  · exact k11_row_valid_651
  · exact k11_row_valid_652
  · exact k11_row_valid_653
  · exact k11_row_valid_654
  · exact k11_row_valid_655
  · exact k11_row_valid_656
  · exact k11_row_valid_657
  · exact k11_row_valid_658
  · exact k11_row_valid_659
  · exact k11_row_valid_660
  · exact k11_row_valid_661
  · exact k11_row_valid_662
  · exact k11_row_valid_663
  · exact k11_row_valid_664
  · exact k11_row_valid_665
  · exact k11_row_valid_666
  · exact k11_row_valid_667
  · exact k11_row_valid_668
  · exact k11_row_valid_669
  · exact k11_row_valid_670
  · exact k11_row_valid_671
  · exact k11_row_valid_672
  · exact k11_row_valid_673
  · exact k11_row_valid_674
  · exact k11_row_valid_675
  · exact k11_row_valid_676
  · exact k11_row_valid_677
  · exact k11_row_valid_678
  · exact k11_row_valid_679
  · exact k11_row_valid_680
  · exact k11_row_valid_681
  · exact k11_row_valid_682
  · exact k11_row_valid_683
  · exact k11_row_valid_684
  · exact k11_row_valid_685
  · exact k11_row_valid_686
  · exact k11_row_valid_687
  · exact k11_row_valid_688
  · exact k11_row_valid_689
  · exact k11_row_valid_690
  · exact k11_row_valid_691
  · exact k11_row_valid_692
  · exact k11_row_valid_693
  · exact k11_row_valid_694
  · exact k11_row_valid_695
  · exact k11_row_valid_696
  · exact k11_row_valid_697
  · exact k11_row_valid_698
  · exact k11_row_valid_699
  · exact k11_row_valid_700
  · exact k11_row_valid_701
  · exact k11_row_valid_702
  · exact k11_row_valid_703
  · exact k11_row_valid_704
  · exact k11_row_valid_705
  · exact k11_row_valid_706
  · exact k11_row_valid_707
  · exact k11_row_valid_708
  · exact k11_row_valid_709
  · exact k11_row_valid_710
  · exact k11_row_valid_711
  · exact k11_row_valid_712
  · exact k11_row_valid_713
  · exact k11_row_valid_714
  · exact k11_row_valid_715
  · exact k11_row_valid_716
  · exact k11_row_valid_717
  · exact k11_row_valid_718
  · exact k11_row_valid_719
  · exact k11_row_valid_720
  · exact k11_row_valid_721
  · exact k11_row_valid_722
  · exact k11_row_valid_723
  · exact k11_row_valid_724
  · exact k11_row_valid_725
  · exact k11_row_valid_726
  · exact k11_row_valid_727
  · exact k11_row_valid_728

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_0 : K11AuxiliaryValid 0 := by
  change (1 : Rat) <= (321017511 / 50000000 : Rat) /\
    (321017511 / 50000000 : Rat) <= (647532569 / 100000000 : Rat) /\
    (321017511 / 50000000 : Rat) <= (321017511 / 50000000 : Rat) /\
    (321017511 / 50000000 : Rat) <= (42962507 / 6250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_1 : K11AuxiliaryValid 1 := by
  change (1 : Rat) <= (70403499 / 25000000 : Rat) /\
    (70403499 / 25000000 : Rat) <= (141403089 / 50000000 : Rat) /\
    (70403499 / 25000000 : Rat) <= (7907291 / 2500000 : Rat) /\
    (70403499 / 25000000 : Rat) <= (70403499 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_2 : K11AuxiliaryValid 2 := by
  change (1 : Rat) <= (226669311 / 50000000 : Rat) /\
    (226669311 / 50000000 : Rat) <= (11529707 / 2500000 : Rat) /\
    (226669311 / 50000000 : Rat) <= (97160799 / 20000000 : Rat) /\
    (226669311 / 50000000 : Rat) <= (226669311 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_3 : K11AuxiliaryValid 3 := by
  change (1 : Rat) <= (219618551 / 50000000 : Rat) /\
    (219618551 / 50000000 : Rat) <= (465878247 / 100000000 : Rat) /\
    (219618551 / 50000000 : Rat) <= (219618551 / 50000000 : Rat) /\
    (219618551 / 50000000 : Rat) <= (220066667 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_4 : K11AuxiliaryValid 4 := by
  change (1 : Rat) <= (550281 / 250000 : Rat) /\
    (550281 / 250000 : Rat) <= (550281 / 250000 : Rat) /\
    (550281 / 250000 : Rat) <= (28891009 / 12500000 : Rat) /\
    (550281 / 250000 : Rat) <= (225253843 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_5 : K11AuxiliaryValid 5 := by
  change (1 : Rat) <= (6460067 / 1000000 : Rat) /\
    (6460067 / 1000000 : Rat) <= (666742391 / 100000000 : Rat) /\
    (6460067 / 1000000 : Rat) <= (650449731 / 100000000 : Rat) /\
    (6460067 / 1000000 : Rat) <= (6460067 / 1000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_6 : K11AuxiliaryValid 6 := by
  change (1 : Rat) <= (113070571 / 12500000 : Rat) /\
    (113070571 / 12500000 : Rat) <= (181678789 / 20000000 : Rat) /\
    (113070571 / 12500000 : Rat) <= (253987919 / 25000000 : Rat) /\
    (113070571 / 12500000 : Rat) <= (113070571 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_7 : K11AuxiliaryValid 7 := by
  change (1 : Rat) <= (78618523 / 50000000 : Rat) /\
    (78618523 / 50000000 : Rat) <= (20025891 / 12500000 : Rat) /\
    (78618523 / 50000000 : Rat) <= (80774281 / 50000000 : Rat) /\
    (78618523 / 50000000 : Rat) <= (78618523 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_8 : K11AuxiliaryValid 8 := by
  change (1 : Rat) <= (916237119 / 100000000 : Rat) /\
    (916237119 / 100000000 : Rat) <= (38580913 / 4000000 : Rat) /\
    (916237119 / 100000000 : Rat) <= (916237119 / 100000000 : Rat) /\
    (916237119 / 100000000 : Rat) <= (936967037 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_9 : K11AuxiliaryValid 9 := by
  change (1 : Rat) <= (122668669 / 20000000 : Rat) /\
    (122668669 / 20000000 : Rat) <= (122668669 / 20000000 : Rat) /\
    (122668669 / 20000000 : Rat) <= (363999299 / 50000000 : Rat) /\
    (122668669 / 20000000 : Rat) <= (350618111 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_10 : K11AuxiliaryValid 10 := by
  change (1 : Rat) <= (100614421 / 50000000 : Rat) /\
    (100614421 / 50000000 : Rat) <= (208853927 / 100000000 : Rat) /\
    (100614421 / 50000000 : Rat) <= (52757763 / 25000000 : Rat) /\
    (100614421 / 50000000 : Rat) <= (100614421 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_11 : K11AuxiliaryValid 11 := by
  change (1 : Rat) <= (272498341 / 100000000 : Rat) /\
    (272498341 / 100000000 : Rat) <= (142266387 / 50000000 : Rat) /\
    (272498341 / 100000000 : Rat) <= (155532103 / 50000000 : Rat) /\
    (272498341 / 100000000 : Rat) <= (272498341 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_12 : K11AuxiliaryValid 12 := by
  change (1 : Rat) <= (70406331 / 12500000 : Rat) /\
    (70406331 / 12500000 : Rat) <= (14613251 / 2500000 : Rat) /\
    (70406331 / 12500000 : Rat) <= (29225653 / 5000000 : Rat) /\
    (70406331 / 12500000 : Rat) <= (70406331 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_13 : K11AuxiliaryValid 13 := by
  change (1 : Rat) <= (113909901 / 50000000 : Rat) /\
    (113909901 / 50000000 : Rat) <= (113909901 / 50000000 : Rat) /\
    (113909901 / 50000000 : Rat) <= (234070551 / 100000000 : Rat) /\
    (113909901 / 50000000 : Rat) <= (121234207 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_14 : K11AuxiliaryValid 14 := by
  change (1 : Rat) <= (430436461 / 50000000 : Rat) /\
    (430436461 / 50000000 : Rat) <= (470737733 / 50000000 : Rat) /\
    (430436461 / 50000000 : Rat) <= (430436461 / 50000000 : Rat) /\
    (430436461 / 50000000 : Rat) <= (110427737 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_15 : K11AuxiliaryValid 15 := by
  change (1 : Rat) <= (769940297 / 100000000 : Rat) /\
    (769940297 / 100000000 : Rat) <= (769940297 / 100000000 : Rat) /\
    (769940297 / 100000000 : Rat) <= (3257063 / 400000 : Rat) /\
    (769940297 / 100000000 : Rat) <= (808330659 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_16 : K11AuxiliaryValid 16 := by
  change (1 : Rat) <= (81567523 / 50000000 : Rat) /\
    (81567523 / 50000000 : Rat) <= (5368079 / 3125000 : Rat) /\
    (81567523 / 50000000 : Rat) <= (81567523 / 50000000 : Rat) /\
    (81567523 / 50000000 : Rat) <= (42433927 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_17 : K11AuxiliaryValid 17 := by
  change (1 : Rat) <= (197738213 / 50000000 : Rat) /\
    (197738213 / 50000000 : Rat) <= (424414293 / 100000000 : Rat) /\
    (197738213 / 50000000 : Rat) <= (403710239 / 100000000 : Rat) /\
    (197738213 / 50000000 : Rat) <= (197738213 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_18 : K11AuxiliaryValid 18 := by
  change (1 : Rat) <= (707016983 / 100000000 : Rat) /\
    (707016983 / 100000000 : Rat) <= (707016983 / 100000000 : Rat) /\
    (707016983 / 100000000 : Rat) <= (371200061 / 50000000 : Rat) /\
    (707016983 / 100000000 : Rat) <= (723531671 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_19 : K11AuxiliaryValid 19 := by
  change (1 : Rat) <= (341988419 / 100000000 : Rat) /\
    (341988419 / 100000000 : Rat) <= (341988419 / 100000000 : Rat) /\
    (341988419 / 100000000 : Rat) <= (179087483 / 50000000 : Rat) /\
    (341988419 / 100000000 : Rat) <= (345241753 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_20 : K11AuxiliaryValid 20 := by
  change (1 : Rat) <= (244187283 / 50000000 : Rat) /\
    (244187283 / 50000000 : Rat) <= (493726171 / 100000000 : Rat) /\
    (244187283 / 50000000 : Rat) <= (125128771 / 25000000 : Rat) /\
    (244187283 / 50000000 : Rat) <= (244187283 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_21 : K11AuxiliaryValid 21 := by
  change (1 : Rat) <= (238525433 / 50000000 : Rat) /\
    (238525433 / 50000000 : Rat) <= (565980423 / 100000000 : Rat) /\
    (238525433 / 50000000 : Rat) <= (540536397 / 100000000 : Rat) /\
    (238525433 / 50000000 : Rat) <= (238525433 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_22 : K11AuxiliaryValid 22 := by
  change (1 : Rat) <= (78432163 / 50000000 : Rat) /\
    (78432163 / 50000000 : Rat) <= (78432163 / 50000000 : Rat) /\
    (78432163 / 50000000 : Rat) <= (32270963 / 20000000 : Rat) /\
    (78432163 / 50000000 : Rat) <= (80472771 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_23 : K11AuxiliaryValid 23 := by
  change (1 : Rat) <= (539160007 / 50000000 : Rat) /\
    (539160007 / 50000000 : Rat) <= (284928663 / 25000000 : Rat) /\
    (539160007 / 50000000 : Rat) <= (539160007 / 50000000 : Rat) /\
    (539160007 / 50000000 : Rat) <= (1105740237 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_24 : K11AuxiliaryValid 24 := by
  change (1 : Rat) <= (18700369 / 2500000 : Rat) /\
    (18700369 / 2500000 : Rat) <= (380524133 / 50000000 : Rat) /\
    (18700369 / 2500000 : Rat) <= (755871671 / 100000000 : Rat) /\
    (18700369 / 2500000 : Rat) <= (18700369 / 2500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_25 : K11AuxiliaryValid 25 := by
  change (1 : Rat) <= (1699121 / 500000 : Rat) /\
    (1699121 / 500000 : Rat) <= (46724123 / 12500000 : Rat) /\
    (1699121 / 500000 : Rat) <= (1699121 / 500000 : Rat) /\
    (1699121 / 500000 : Rat) <= (459015261 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_26 : K11AuxiliaryValid 26 := by
  change (1 : Rat) <= (303391193 / 50000000 : Rat) /\
    (303391193 / 50000000 : Rat) <= (303880419 / 50000000 : Rat) /\
    (303391193 / 50000000 : Rat) <= (656239379 / 100000000 : Rat) /\
    (303391193 / 50000000 : Rat) <= (303391193 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_27 : K11AuxiliaryValid 27 := by
  change (1 : Rat) <= (473608073 / 100000000 : Rat) /\
    (473608073 / 100000000 : Rat) <= (24469801 / 5000000 : Rat) /\
    (473608073 / 100000000 : Rat) <= (473608073 / 100000000 : Rat) /\
    (473608073 / 100000000 : Rat) <= (255540689 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_28 : K11AuxiliaryValid 28 := by
  change (1 : Rat) <= (371747491 / 100000000 : Rat) /\
    (371747491 / 100000000 : Rat) <= (200462121 / 50000000 : Rat) /\
    (371747491 / 100000000 : Rat) <= (422690619 / 100000000 : Rat) /\
    (371747491 / 100000000 : Rat) <= (371747491 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_29 : K11AuxiliaryValid 29 := by
  change (1 : Rat) <= (130124561 / 25000000 : Rat) /\
    (130124561 / 25000000 : Rat) <= (22890123 / 4000000 : Rat) /\
    (130124561 / 25000000 : Rat) <= (21553343 / 4000000 : Rat) /\
    (130124561 / 25000000 : Rat) <= (130124561 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_30 : K11AuxiliaryValid 30 := by
  change (1 : Rat) <= (50505679 / 10000000 : Rat) /\
    (50505679 / 10000000 : Rat) <= (51459691 / 10000000 : Rat) /\
    (50505679 / 10000000 : Rat) <= (51890569 / 10000000 : Rat) /\
    (50505679 / 10000000 : Rat) <= (50505679 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_31 : K11AuxiliaryValid 31 := by
  change (1 : Rat) <= (393968733 / 100000000 : Rat) /\
    (393968733 / 100000000 : Rat) <= (393968733 / 100000000 : Rat) /\
    (393968733 / 100000000 : Rat) <= (457674147 / 100000000 : Rat) /\
    (393968733 / 100000000 : Rat) <= (464589837 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_32 : K11AuxiliaryValid 32 := by
  change (1 : Rat) <= (688893917 / 100000000 : Rat) /\
    (688893917 / 100000000 : Rat) <= (711503301 / 100000000 : Rat) /\
    (688893917 / 100000000 : Rat) <= (749948199 / 100000000 : Rat) /\
    (688893917 / 100000000 : Rat) <= (688893917 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_33 : K11AuxiliaryValid 33 := by
  change (1 : Rat) <= (10034481 / 1000000 : Rat) /\
    (10034481 / 1000000 : Rat) <= (527471077 / 50000000 : Rat) /\
    (10034481 / 1000000 : Rat) <= (1071772463 / 100000000 : Rat) /\
    (10034481 / 1000000 : Rat) <= (10034481 / 1000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_34 : K11AuxiliaryValid 34 := by
  change (1 : Rat) <= (178811381 / 100000000 : Rat) /\
    (178811381 / 100000000 : Rat) <= (179036359 / 100000000 : Rat) /\
    (178811381 / 100000000 : Rat) <= (45881651 / 25000000 : Rat) /\
    (178811381 / 100000000 : Rat) <= (178811381 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_35 : K11AuxiliaryValid 35 := by
  change (1 : Rat) <= (309893023 / 20000000 : Rat) /\
    (309893023 / 20000000 : Rat) <= (31437329 / 2000000 : Rat) /\
    (309893023 / 20000000 : Rat) <= (406553657 / 25000000 : Rat) /\
    (309893023 / 20000000 : Rat) <= (309893023 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_36 : K11AuxiliaryValid 36 := by
  change (1 : Rat) <= (212093941 / 50000000 : Rat) /\
    (212093941 / 50000000 : Rat) <= (212093941 / 50000000 : Rat) /\
    (212093941 / 50000000 : Rat) <= (451668723 / 100000000 : Rat) /\
    (212093941 / 50000000 : Rat) <= (463455849 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_37 : K11AuxiliaryValid 37 := by
  change (1 : Rat) <= (41674149 / 20000000 : Rat) /\
    (41674149 / 20000000 : Rat) <= (45136579 / 20000000 : Rat) /\
    (41674149 / 20000000 : Rat) <= (41674149 / 20000000 : Rat) /\
    (41674149 / 20000000 : Rat) <= (6622873 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_38 : K11AuxiliaryValid 38 := by
  change (1 : Rat) <= (129839133 / 25000000 : Rat) /\
    (129839133 / 25000000 : Rat) <= (27500271 / 5000000 : Rat) /\
    (129839133 / 25000000 : Rat) <= (132851269 / 20000000 : Rat) /\
    (129839133 / 25000000 : Rat) <= (129839133 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_39 : K11AuxiliaryValid 39 := by
  change (1 : Rat) <= (232685053 / 50000000 : Rat) /\
    (232685053 / 50000000 : Rat) <= (467388189 / 100000000 : Rat) /\
    (232685053 / 50000000 : Rat) <= (235758437 / 50000000 : Rat) /\
    (232685053 / 50000000 : Rat) <= (232685053 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_40 : K11AuxiliaryValid 40 := by
  change (1 : Rat) <= (323405839 / 100000000 : Rat) /\
    (323405839 / 100000000 : Rat) <= (367488183 / 100000000 : Rat) /\
    (323405839 / 100000000 : Rat) <= (323405839 / 100000000 : Rat) /\
    (323405839 / 100000000 : Rat) <= (326819783 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_41 : K11AuxiliaryValid 41 := by
  change (1 : Rat) <= (424119397 / 50000000 : Rat) /\
    (424119397 / 50000000 : Rat) <= (429949563 / 50000000 : Rat) /\
    (424119397 / 50000000 : Rat) <= (173199193 / 20000000 : Rat) /\
    (424119397 / 50000000 : Rat) <= (424119397 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_42 : K11AuxiliaryValid 42 := by
  change (1 : Rat) <= (161590407 / 25000000 : Rat) /\
    (161590407 / 25000000 : Rat) <= (670853953 / 100000000 : Rat) /\
    (161590407 / 25000000 : Rat) <= (677847037 / 100000000 : Rat) /\
    (161590407 / 25000000 : Rat) <= (161590407 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_43 : K11AuxiliaryValid 43 := by
  change (1 : Rat) <= (12151181 / 5000000 : Rat) /\
    (12151181 / 5000000 : Rat) <= (12151181 / 5000000 : Rat) /\
    (12151181 / 5000000 : Rat) <= (64571653 / 25000000 : Rat) /\
    (12151181 / 5000000 : Rat) <= (34826363 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_44 : K11AuxiliaryValid 44 := by
  change (1 : Rat) <= (383713489 / 50000000 : Rat) /\
    (383713489 / 50000000 : Rat) <= (773716511 / 100000000 : Rat) /\
    (383713489 / 50000000 : Rat) <= (383713489 / 50000000 : Rat) /\
    (383713489 / 50000000 : Rat) <= (404665559 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_45 : K11AuxiliaryValid 45 := by
  change (1 : Rat) <= (2176850661 / 100000000 : Rat) /\
    (2176850661 / 100000000 : Rat) <= (2541267733 / 100000000 : Rat) /\
    (2176850661 / 100000000 : Rat) <= (2176850661 / 100000000 : Rat) /\
    (2176850661 / 100000000 : Rat) <= (1195021351 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_46 : K11AuxiliaryValid 46 := by
  change (1 : Rat) <= (40616559 / 20000000 : Rat) /\
    (40616559 / 20000000 : Rat) <= (203440061 / 100000000 : Rat) /\
    (40616559 / 20000000 : Rat) <= (107438431 / 50000000 : Rat) /\
    (40616559 / 20000000 : Rat) <= (40616559 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_47 : K11AuxiliaryValid 47 := by
  change (1 : Rat) <= (314052731 / 50000000 : Rat) /\
    (314052731 / 50000000 : Rat) <= (680403789 / 100000000 : Rat) /\
    (314052731 / 50000000 : Rat) <= (314052731 / 50000000 : Rat) /\
    (314052731 / 50000000 : Rat) <= (763720003 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_48 : K11AuxiliaryValid 48 := by
  change (1 : Rat) <= (97646499 / 25000000 : Rat) /\
    (97646499 / 25000000 : Rat) <= (437289547 / 100000000 : Rat) /\
    (97646499 / 25000000 : Rat) <= (88001311 / 20000000 : Rat) /\
    (97646499 / 25000000 : Rat) <= (97646499 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_49 : K11AuxiliaryValid 49 := by
  change (1 : Rat) <= (93027563 / 50000000 : Rat) /\
    (93027563 / 50000000 : Rat) <= (93027563 / 50000000 : Rat) /\
    (93027563 / 50000000 : Rat) <= (94101003 / 50000000 : Rat) /\
    (93027563 / 50000000 : Rat) <= (41124961 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_50 : K11AuxiliaryValid 50 := by
  change (1 : Rat) <= (1369358199 / 100000000 : Rat) /\
    (1369358199 / 100000000 : Rat) <= (1466247999 / 100000000 : Rat) /\
    (1369358199 / 100000000 : Rat) <= (149399223 / 10000000 : Rat) /\
    (1369358199 / 100000000 : Rat) <= (1369358199 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_51 : K11AuxiliaryValid 51 := by
  change (1 : Rat) <= (502942901 / 25000000 : Rat) /\
    (502942901 / 25000000 : Rat) <= (256433613 / 10000000 : Rat) /\
    (502942901 / 25000000 : Rat) <= (502942901 / 25000000 : Rat) /\
    (502942901 / 25000000 : Rat) <= (209440747 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_52 : K11AuxiliaryValid 52 := by
  change (1 : Rat) <= (68162577 / 50000000 : Rat) /\
    (68162577 / 50000000 : Rat) <= (68162577 / 50000000 : Rat) /\
    (68162577 / 50000000 : Rat) <= (139433237 / 100000000 : Rat) /\
    (68162577 / 50000000 : Rat) <= (34470983 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_53 : K11AuxiliaryValid 53 := by
  change (1 : Rat) <= (2106897721 / 100000000 : Rat) /\
    (2106897721 / 100000000 : Rat) <= (1117748509 / 50000000 : Rat) /\
    (2106897721 / 100000000 : Rat) <= (1069147283 / 50000000 : Rat) /\
    (2106897721 / 100000000 : Rat) <= (2106897721 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_54 : K11AuxiliaryValid 54 := by
  change (1 : Rat) <= (731773719 / 100000000 : Rat) /\
    (731773719 / 100000000 : Rat) <= (731773719 / 100000000 : Rat) /\
    (731773719 / 100000000 : Rat) <= (751851577 / 100000000 : Rat) /\
    (731773719 / 100000000 : Rat) <= (778826123 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_55 : K11AuxiliaryValid 55 := by
  change (1 : Rat) <= (523226591 / 50000000 : Rat) /\
    (523226591 / 50000000 : Rat) <= (523226591 / 50000000 : Rat) /\
    (523226591 / 50000000 : Rat) <= (1089163203 / 100000000 : Rat) /\
    (523226591 / 50000000 : Rat) <= (39934751 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_56 : K11AuxiliaryValid 56 := by
  change (1 : Rat) <= (70751381 / 20000000 : Rat) /\
    (70751381 / 20000000 : Rat) <= (186036937 / 50000000 : Rat) /\
    (70751381 / 20000000 : Rat) <= (93529087 / 25000000 : Rat) /\
    (70751381 / 20000000 : Rat) <= (70751381 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_57 : K11AuxiliaryValid 57 := by
  change (1 : Rat) <= (73772913 / 12500000 : Rat) /\
    (73772913 / 12500000 : Rat) <= (319961081 / 50000000 : Rat) /\
    (73772913 / 12500000 : Rat) <= (73772913 / 12500000 : Rat) /\
    (73772913 / 12500000 : Rat) <= (120563593 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_58 : K11AuxiliaryValid 58 := by
  change (1 : Rat) <= (2962839 / 1250000 : Rat) /\
    (2962839 / 1250000 : Rat) <= (10104039 / 4000000 : Rat) /\
    (2962839 / 1250000 : Rat) <= (2962839 / 1250000 : Rat) /\
    (2962839 / 1250000 : Rat) <= (124858443 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_59 : K11AuxiliaryValid 59 := by
  change (1 : Rat) <= (695850069 / 100000000 : Rat) /\
    (695850069 / 100000000 : Rat) <= (695850069 / 100000000 : Rat) /\
    (695850069 / 100000000 : Rat) <= (215992287 / 25000000 : Rat) /\
    (695850069 / 100000000 : Rat) <= (93329799 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_60 : K11AuxiliaryValid 60 := by
  change (1 : Rat) <= (379138027 / 12500000 : Rat) /\
    (379138027 / 12500000 : Rat) <= (613430203 / 20000000 : Rat) /\
    (379138027 / 12500000 : Rat) <= (379138027 / 12500000 : Rat) /\
    (379138027 / 12500000 : Rat) <= (3138178397 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_61 : K11AuxiliaryValid 61 := by
  change (1 : Rat) <= (65938111 / 50000000 : Rat) /\
    (65938111 / 50000000 : Rat) <= (65938111 / 50000000 : Rat) /\
    (65938111 / 50000000 : Rat) <= (142959049 / 100000000 : Rat) /\
    (65938111 / 50000000 : Rat) <= (14630443 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_62 : K11AuxiliaryValid 62 := by
  change (1 : Rat) <= (1241787791 / 100000000 : Rat) /\
    (1241787791 / 100000000 : Rat) <= (1241787791 / 100000000 : Rat) /\
    (1241787791 / 100000000 : Rat) <= (63148779 / 5000000 : Rat) /\
    (1241787791 / 100000000 : Rat) <= (1447633719 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_63 : K11AuxiliaryValid 63 := by
  change (1 : Rat) <= (414897063 / 100000000 : Rat) /\
    (414897063 / 100000000 : Rat) <= (414897063 / 100000000 : Rat) /\
    (414897063 / 100000000 : Rat) <= (107313421 / 25000000 : Rat) /\
    (414897063 / 100000000 : Rat) <= (216498331 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_64 : K11AuxiliaryValid 64 := by
  change (1 : Rat) <= (156388311 / 50000000 : Rat) /\
    (156388311 / 50000000 : Rat) <= (156388311 / 50000000 : Rat) /\
    (156388311 / 50000000 : Rat) <= (365560393 / 100000000 : Rat) /\
    (156388311 / 50000000 : Rat) <= (157061737 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_65 : K11AuxiliaryValid 65 := by
  change (1 : Rat) <= (45288167 / 10000000 : Rat) /\
    (45288167 / 10000000 : Rat) <= (466084247 / 100000000 : Rat) /\
    (45288167 / 10000000 : Rat) <= (232159267 / 50000000 : Rat) /\
    (45288167 / 10000000 : Rat) <= (45288167 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_66 : K11AuxiliaryValid 66 := by
  change (1 : Rat) <= (524001593 / 100000000 : Rat) /\
    (524001593 / 100000000 : Rat) <= (137941271 / 25000000 : Rat) /\
    (524001593 / 100000000 : Rat) <= (524001593 / 100000000 : Rat) /\
    (524001593 / 100000000 : Rat) <= (545203397 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_67 : K11AuxiliaryValid 67 := by
  change (1 : Rat) <= (39603981 / 25000000 : Rat) /\
    (39603981 / 25000000 : Rat) <= (4964373 / 3125000 : Rat) /\
    (39603981 / 25000000 : Rat) <= (20991513 / 12500000 : Rat) /\
    (39603981 / 25000000 : Rat) <= (39603981 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_68 : K11AuxiliaryValid 68 := by
  change (1 : Rat) <= (603556239 / 20000000 : Rat) /\
    (603556239 / 20000000 : Rat) <= (634270023 / 20000000 : Rat) /\
    (603556239 / 20000000 : Rat) <= (3787171467 / 100000000 : Rat) /\
    (603556239 / 20000000 : Rat) <= (603556239 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_69 : K11AuxiliaryValid 69 := by
  change (1 : Rat) <= (669190303 / 100000000 : Rat) /\
    (669190303 / 100000000 : Rat) <= (759541697 / 100000000 : Rat) /\
    (669190303 / 100000000 : Rat) <= (669190303 / 100000000 : Rat) /\
    (669190303 / 100000000 : Rat) <= (735259033 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_70 : K11AuxiliaryValid 70 := by
  change (1 : Rat) <= (65961853 / 50000000 : Rat) /\
    (65961853 / 50000000 : Rat) <= (65961853 / 50000000 : Rat) /\
    (65961853 / 50000000 : Rat) <= (34402183 / 25000000 : Rat) /\
    (65961853 / 50000000 : Rat) <= (852137 / 625000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_71 : K11AuxiliaryValid 71 := by
  change (1 : Rat) <= (475333323 / 50000000 : Rat) /\
    (475333323 / 50000000 : Rat) <= (475333323 / 50000000 : Rat) /\
    (475333323 / 50000000 : Rat) <= (111065041 / 10000000 : Rat) /\
    (475333323 / 50000000 : Rat) <= (993498933 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_72 : K11AuxiliaryValid 72 := by
  change (1 : Rat) <= (755841383 / 100000000 : Rat) /\
    (755841383 / 100000000 : Rat) <= (814219873 / 100000000 : Rat) /\
    (755841383 / 100000000 : Rat) <= (755841383 / 100000000 : Rat) /\
    (755841383 / 100000000 : Rat) <= (771303681 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_73 : K11AuxiliaryValid 73 := by
  change (1 : Rat) <= (9424711 / 3125000 : Rat) /\
    (9424711 / 3125000 : Rat) <= (39278487 / 12500000 : Rat) /\
    (9424711 / 3125000 : Rat) <= (158413193 / 50000000 : Rat) /\
    (9424711 / 3125000 : Rat) <= (9424711 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_74 : K11AuxiliaryValid 74 := by
  change (1 : Rat) <= (385054709 / 100000000 : Rat) /\
    (385054709 / 100000000 : Rat) <= (385054709 / 100000000 : Rat) /\
    (385054709 / 100000000 : Rat) <= (421848101 / 100000000 : Rat) /\
    (385054709 / 100000000 : Rat) <= (77805271 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_75 : K11AuxiliaryValid 75 := by
  change (1 : Rat) <= (307643727 / 50000000 : Rat) /\
    (307643727 / 50000000 : Rat) <= (307643727 / 50000000 : Rat) /\
    (307643727 / 50000000 : Rat) <= (330990807 / 50000000 : Rat) /\
    (307643727 / 50000000 : Rat) <= (656169343 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_76 : K11AuxiliaryValid 76 := by
  change (1 : Rat) <= (70169869 / 50000000 : Rat) /\
    (70169869 / 50000000 : Rat) <= (39584139 / 25000000 : Rat) /\
    (70169869 / 50000000 : Rat) <= (141037921 / 100000000 : Rat) /\
    (70169869 / 50000000 : Rat) <= (70169869 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_77 : K11AuxiliaryValid 77 := by
  change (1 : Rat) <= (1286721137 / 50000000 : Rat) /\
    (1286721137 / 50000000 : Rat) <= (575988797 / 20000000 : Rat) /\
    (1286721137 / 50000000 : Rat) <= (1286721137 / 50000000 : Rat) /\
    (1286721137 / 50000000 : Rat) <= (3487438281 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_78 : K11AuxiliaryValid 78 := by
  change (1 : Rat) <= (1098491591 / 100000000 : Rat) /\
    (1098491591 / 100000000 : Rat) <= (1098491591 / 100000000 : Rat) /\
    (1098491591 / 100000000 : Rat) <= (575241977 / 50000000 : Rat) /\
    (1098491591 / 100000000 : Rat) <= (554470769 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_79 : K11AuxiliaryValid 79 := by
  change (1 : Rat) <= (101721321 / 50000000 : Rat) /\
    (101721321 / 50000000 : Rat) <= (206971443 / 100000000 : Rat) /\
    (101721321 / 50000000 : Rat) <= (101721321 / 50000000 : Rat) /\
    (101721321 / 50000000 : Rat) <= (215875169 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_80 : K11AuxiliaryValid 80 := by
  change (1 : Rat) <= (188090669 / 6250000 : Rat) /\
    (188090669 / 6250000 : Rat) <= (188090669 / 6250000 : Rat) /\
    (188090669 / 6250000 : Rat) <= (120490911 / 4000000 : Rat) /\
    (188090669 / 6250000 : Rat) <= (762856581 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_81 : K11AuxiliaryValid 81 := by
  change (1 : Rat) <= (107875551 / 20000000 : Rat) /\
    (107875551 / 20000000 : Rat) <= (606822683 / 100000000 : Rat) /\
    (107875551 / 20000000 : Rat) <= (23644679 / 4000000 : Rat) /\
    (107875551 / 20000000 : Rat) <= (107875551 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_82 : K11AuxiliaryValid 82 := by
  change (1 : Rat) <= (64782177 / 12500000 : Rat) /\
    (64782177 / 12500000 : Rat) <= (11128907 / 2000000 : Rat) /\
    (64782177 / 12500000 : Rat) <= (64782177 / 12500000 : Rat) /\
    (64782177 / 12500000 : Rat) <= (545732129 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_83 : K11AuxiliaryValid 83 := by
  change (1 : Rat) <= (605634153 / 50000000 : Rat) /\
    (605634153 / 50000000 : Rat) <= (97698543 / 6250000 : Rat) /\
    (605634153 / 50000000 : Rat) <= (1311885303 / 100000000 : Rat) /\
    (605634153 / 50000000 : Rat) <= (605634153 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_84 : K11AuxiliaryValid 84 := by
  change (1 : Rat) <= (426147317 / 100000000 : Rat) /\
    (426147317 / 100000000 : Rat) <= (426147317 / 100000000 : Rat) /\
    (426147317 / 100000000 : Rat) <= (236256269 / 50000000 : Rat) /\
    (426147317 / 100000000 : Rat) <= (452582789 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_85 : K11AuxiliaryValid 85 := by
  change (1 : Rat) <= (327893283 / 100000000 : Rat) /\
    (327893283 / 100000000 : Rat) <= (336615699 / 100000000 : Rat) /\
    (327893283 / 100000000 : Rat) <= (327893283 / 100000000 : Rat) /\
    (327893283 / 100000000 : Rat) <= (338807453 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_86 : K11AuxiliaryValid 86 := by
  change (1 : Rat) <= (361832887 / 50000000 : Rat) /\
    (361832887 / 50000000 : Rat) <= (440350177 / 50000000 : Rat) /\
    (361832887 / 50000000 : Rat) <= (832410803 / 100000000 : Rat) /\
    (361832887 / 50000000 : Rat) <= (361832887 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_87 : K11AuxiliaryValid 87 := by
  change (1 : Rat) <= (1078574567 / 50000000 : Rat) /\
    (1078574567 / 50000000 : Rat) <= (2462452853 / 100000000 : Rat) /\
    (1078574567 / 50000000 : Rat) <= (1078574567 / 50000000 : Rat) /\
    (1078574567 / 50000000 : Rat) <= (2256333269 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_88 : K11AuxiliaryValid 88 := by
  change (1 : Rat) <= (118368779 / 50000000 : Rat) /\
    (118368779 / 50000000 : Rat) <= (120169457 / 50000000 : Rat) /\
    (118368779 / 50000000 : Rat) <= (118368779 / 50000000 : Rat) /\
    (118368779 / 50000000 : Rat) <= (27748641 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_89 : K11AuxiliaryValid 89 := by
  change (1 : Rat) <= (1008463567 / 100000000 : Rat) /\
    (1008463567 / 100000000 : Rat) <= (529452269 / 50000000 : Rat) /\
    (1008463567 / 100000000 : Rat) <= (118448383 / 10000000 : Rat) /\
    (1008463567 / 100000000 : Rat) <= (1008463567 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_90 : K11AuxiliaryValid 90 := by
  change (1 : Rat) <= (100771917 / 20000000 : Rat) /\
    (100771917 / 20000000 : Rat) <= (100771917 / 20000000 : Rat) /\
    (100771917 / 20000000 : Rat) <= (259141681 / 50000000 : Rat) /\
    (100771917 / 20000000 : Rat) <= (516968749 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_91 : K11AuxiliaryValid 91 := by
  change (1 : Rat) <= (15044127 / 6250000 : Rat) /\
    (15044127 / 6250000 : Rat) <= (242141287 / 100000000 : Rat) /\
    (15044127 / 6250000 : Rat) <= (15044127 / 6250000 : Rat) /\
    (15044127 / 6250000 : Rat) <= (246651703 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_92 : K11AuxiliaryValid 92 := by
  change (1 : Rat) <= (268336041 / 100000000 : Rat) /\
    (268336041 / 100000000 : Rat) <= (67746123 / 25000000 : Rat) /\
    (268336041 / 100000000 : Rat) <= (305472013 / 100000000 : Rat) /\
    (268336041 / 100000000 : Rat) <= (268336041 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_93 : K11AuxiliaryValid 93 := by
  change (1 : Rat) <= (143843203 / 25000000 : Rat) /\
    (143843203 / 25000000 : Rat) <= (143843203 / 25000000 : Rat) /\
    (143843203 / 25000000 : Rat) <= (618115453 / 100000000 : Rat) /\
    (143843203 / 25000000 : Rat) <= (589916481 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_94 : K11AuxiliaryValid 94 := by
  change (1 : Rat) <= (181752141 / 100000000 : Rat) /\
    (181752141 / 100000000 : Rat) <= (181752141 / 100000000 : Rat) /\
    (181752141 / 100000000 : Rat) <= (49193497 / 25000000 : Rat) /\
    (181752141 / 100000000 : Rat) <= (11573001 / 6250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_95 : K11AuxiliaryValid 95 := by
  change (1 : Rat) <= (162588117 / 25000000 : Rat) /\
    (162588117 / 25000000 : Rat) <= (162588117 / 25000000 : Rat) /\
    (162588117 / 25000000 : Rat) <= (135831801 / 20000000 : Rat) /\
    (162588117 / 25000000 : Rat) <= (682746287 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_96 : K11AuxiliaryValid 96 := by
  change (1 : Rat) <= (703010193 / 100000000 : Rat) /\
    (703010193 / 100000000 : Rat) <= (382605799 / 50000000 : Rat) /\
    (703010193 / 100000000 : Rat) <= (703010193 / 100000000 : Rat) /\
    (703010193 / 100000000 : Rat) <= (4399733 / 625000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_97 : K11AuxiliaryValid 97 := by
  change (1 : Rat) <= (8793177 / 6250000 : Rat) /\
    (8793177 / 6250000 : Rat) <= (8793177 / 6250000 : Rat) /\
    (8793177 / 6250000 : Rat) <= (81223749 / 50000000 : Rat) /\
    (8793177 / 6250000 : Rat) <= (6164101 / 4000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_98 : K11AuxiliaryValid 98 := by
  change (1 : Rat) <= (670038089 / 100000000 : Rat) /\
    (670038089 / 100000000 : Rat) <= (4422911 / 625000 : Rat) /\
    (670038089 / 100000000 : Rat) <= (670038089 / 100000000 : Rat) /\
    (670038089 / 100000000 : Rat) <= (686888693 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_99 : K11AuxiliaryValid 99 := by
  change (1 : Rat) <= (697497457 / 100000000 : Rat) /\
    (697497457 / 100000000 : Rat) <= (185259059 / 25000000 : Rat) /\
    (697497457 / 100000000 : Rat) <= (697497457 / 100000000 : Rat) /\
    (697497457 / 100000000 : Rat) <= (187612957 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_100 : K11AuxiliaryValid 100 := by
  change (1 : Rat) <= (217207647 / 50000000 : Rat) /\
    (217207647 / 50000000 : Rat) <= (490858591 / 100000000 : Rat) /\
    (217207647 / 50000000 : Rat) <= (217207647 / 50000000 : Rat) /\
    (217207647 / 50000000 : Rat) <= (471488759 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_101 : K11AuxiliaryValid 101 := by
  change (1 : Rat) <= (355601827 / 100000000 : Rat) /\
    (355601827 / 100000000 : Rat) <= (370487823 / 100000000 : Rat) /\
    (355601827 / 100000000 : Rat) <= (355601827 / 100000000 : Rat) /\
    (355601827 / 100000000 : Rat) <= (355853059 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_102 : K11AuxiliaryValid 102 := by
  change (1 : Rat) <= (218307993 / 20000000 : Rat) /\
    (218307993 / 20000000 : Rat) <= (1200650161 / 100000000 : Rat) /\
    (218307993 / 20000000 : Rat) <= (218307993 / 20000000 : Rat) /\
    (218307993 / 20000000 : Rat) <= (368597573 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_103 : K11AuxiliaryValid 103 := by
  change (1 : Rat) <= (33274969 / 25000000 : Rat) /\
    (33274969 / 25000000 : Rat) <= (146052769 / 100000000 : Rat) /\
    (33274969 / 25000000 : Rat) <= (146668809 / 100000000 : Rat) /\
    (33274969 / 25000000 : Rat) <= (33274969 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_104 : K11AuxiliaryValid 104 := by
  change (1 : Rat) <= (265709569 / 25000000 : Rat) /\
    (265709569 / 25000000 : Rat) <= (277333919 / 25000000 : Rat) /\
    (265709569 / 25000000 : Rat) <= (265709569 / 25000000 : Rat) /\
    (265709569 / 25000000 : Rat) <= (567474267 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_105 : K11AuxiliaryValid 105 := by
  change (1 : Rat) <= (781727341 / 100000000 : Rat) /\
    (781727341 / 100000000 : Rat) <= (786912723 / 100000000 : Rat) /\
    (781727341 / 100000000 : Rat) <= (887208791 / 100000000 : Rat) /\
    (781727341 / 100000000 : Rat) <= (781727341 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_106 : K11AuxiliaryValid 106 := by
  change (1 : Rat) <= (20643833 / 12500000 : Rat) /\
    (20643833 / 12500000 : Rat) <= (20643833 / 12500000 : Rat) /\
    (20643833 / 12500000 : Rat) <= (170402687 / 100000000 : Rat) /\
    (20643833 / 12500000 : Rat) <= (23250911 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_107 : K11AuxiliaryValid 107 := by
  change (1 : Rat) <= (600006767 / 50000000 : Rat) /\
    (600006767 / 50000000 : Rat) <= (698946223 / 50000000 : Rat) /\
    (600006767 / 50000000 : Rat) <= (600006767 / 50000000 : Rat) /\
    (600006767 / 50000000 : Rat) <= (648594393 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_108 : K11AuxiliaryValid 108 := by
  change (1 : Rat) <= (108412409 / 25000000 : Rat) /\
    (108412409 / 25000000 : Rat) <= (222020819 / 50000000 : Rat) /\
    (108412409 / 25000000 : Rat) <= (444003737 / 100000000 : Rat) /\
    (108412409 / 25000000 : Rat) <= (108412409 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_109 : K11AuxiliaryValid 109 := by
  change (1 : Rat) <= (18321227 / 5000000 : Rat) /\
    (18321227 / 5000000 : Rat) <= (367950749 / 100000000 : Rat) /\
    (18321227 / 5000000 : Rat) <= (194978561 / 50000000 : Rat) /\
    (18321227 / 5000000 : Rat) <= (18321227 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_110 : K11AuxiliaryValid 110 := by
  change (1 : Rat) <= (98741103 / 20000000 : Rat) /\
    (98741103 / 20000000 : Rat) <= (251245081 / 50000000 : Rat) /\
    (98741103 / 20000000 : Rat) <= (98741103 / 20000000 : Rat) /\
    (98741103 / 20000000 : Rat) <= (277873439 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_111 : K11AuxiliaryValid 111 := by
  change (1 : Rat) <= (392540357 / 100000000 : Rat) /\
    (392540357 / 100000000 : Rat) <= (200512781 / 50000000 : Rat) /\
    (392540357 / 100000000 : Rat) <= (214963277 / 50000000 : Rat) /\
    (392540357 / 100000000 : Rat) <= (392540357 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_112 : K11AuxiliaryValid 112 := by
  change (1 : Rat) <= (267076437 / 100000000 : Rat) /\
    (267076437 / 100000000 : Rat) <= (267076437 / 100000000 : Rat) /\
    (267076437 / 100000000 : Rat) <= (136622063 / 50000000 : Rat) /\
    (267076437 / 100000000 : Rat) <= (70894301 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_113 : K11AuxiliaryValid 113 := by
  change (1 : Rat) <= (864241079 / 100000000 : Rat) /\
    (864241079 / 100000000 : Rat) <= (45712807 / 5000000 : Rat) /\
    (864241079 / 100000000 : Rat) <= (864241079 / 100000000 : Rat) /\
    (864241079 / 100000000 : Rat) <= (905226057 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_114 : K11AuxiliaryValid 114 := by
  change (1 : Rat) <= (119407989 / 10000000 : Rat) /\
    (119407989 / 10000000 : Rat) <= (1287797729 / 100000000 : Rat) /\
    (119407989 / 10000000 : Rat) <= (135771291 / 10000000 : Rat) /\
    (119407989 / 10000000 : Rat) <= (119407989 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_115 : K11AuxiliaryValid 115 := by
  change (1 : Rat) <= (61618593 / 50000000 : Rat) /\
    (61618593 / 50000000 : Rat) <= (125881879 / 100000000 : Rat) /\
    (61618593 / 50000000 : Rat) <= (61618593 / 50000000 : Rat) /\
    (61618593 / 50000000 : Rat) <= (126463173 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_116 : K11AuxiliaryValid 116 := by
  change (1 : Rat) <= (2802410819 / 100000000 : Rat) /\
    (2802410819 / 100000000 : Rat) <= (916114871 / 25000000 : Rat) /\
    (2802410819 / 100000000 : Rat) <= (11868116 / 390625 : Rat) /\
    (2802410819 / 100000000 : Rat) <= (2802410819 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_117 : K11AuxiliaryValid 117 := by
  change (1 : Rat) <= (242235009 / 50000000 : Rat) /\
    (242235009 / 50000000 : Rat) <= (242235009 / 50000000 : Rat) /\
    (242235009 / 50000000 : Rat) <= (486704549 / 100000000 : Rat) /\
    (242235009 / 50000000 : Rat) <= (139125849 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_118 : K11AuxiliaryValid 118 := by
  change (1 : Rat) <= (287419107 / 100000000 : Rat) /\
    (287419107 / 100000000 : Rat) <= (146395481 / 50000000 : Rat) /\
    (287419107 / 100000000 : Rat) <= (287419107 / 100000000 : Rat) /\
    (287419107 / 100000000 : Rat) <= (145195011 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_119 : K11AuxiliaryValid 119 := by
  change (1 : Rat) <= (16706471 / 5000000 : Rat) /\
    (16706471 / 5000000 : Rat) <= (9301179 / 2500000 : Rat) /\
    (16706471 / 5000000 : Rat) <= (16706471 / 5000000 : Rat) /\
    (16706471 / 5000000 : Rat) <= (369167993 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_120 : K11AuxiliaryValid 120 := by
  change (1 : Rat) <= (253394433 / 50000000 : Rat) /\
    (253394433 / 50000000 : Rat) <= (253394433 / 50000000 : Rat) /\
    (253394433 / 50000000 : Rat) <= (270240417 / 50000000 : Rat) /\
    (253394433 / 50000000 : Rat) <= (531509627 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_121 : K11AuxiliaryValid 121 := by
  change (1 : Rat) <= (145552949 / 50000000 : Rat) /\
    (145552949 / 50000000 : Rat) <= (327392537 / 100000000 : Rat) /\
    (145552949 / 50000000 : Rat) <= (145552949 / 50000000 : Rat) /\
    (145552949 / 50000000 : Rat) <= (61307299 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_122 : K11AuxiliaryValid 122 := by
  change (1 : Rat) <= (837534361 / 100000000 : Rat) /\
    (837534361 / 100000000 : Rat) <= (837534361 / 100000000 : Rat) /\
    (837534361 / 100000000 : Rat) <= (853439433 / 100000000 : Rat) /\
    (837534361 / 100000000 : Rat) <= (223848253 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_123 : K11AuxiliaryValid 123 := by
  change (1 : Rat) <= (439428719 / 50000000 : Rat) /\
    (439428719 / 50000000 : Rat) <= (176630441 / 20000000 : Rat) /\
    (439428719 / 50000000 : Rat) <= (442324881 / 50000000 : Rat) /\
    (439428719 / 50000000 : Rat) <= (439428719 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_124 : K11AuxiliaryValid 124 := by
  change (1 : Rat) <= (32863973 / 20000000 : Rat) /\
    (32863973 / 20000000 : Rat) <= (32863973 / 20000000 : Rat) /\
    (32863973 / 20000000 : Rat) <= (17978659 / 10000000 : Rat) /\
    (32863973 / 20000000 : Rat) <= (188774533 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_125 : K11AuxiliaryValid 125 := by
  change (1 : Rat) <= (312772347 / 20000000 : Rat) /\
    (312772347 / 20000000 : Rat) <= (70042839 / 4000000 : Rat) /\
    (312772347 / 20000000 : Rat) <= (413314919 / 20000000 : Rat) /\
    (312772347 / 20000000 : Rat) <= (312772347 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_126 : K11AuxiliaryValid 126 := by
  change (1 : Rat) <= (4943188 / 390625 : Rat) /\
    (4943188 / 390625 : Rat) <= (4943188 / 390625 : Rat) /\
    (4943188 / 390625 : Rat) <= (735041269 / 50000000 : Rat) /\
    (4943188 / 390625 : Rat) <= (1492296233 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_127 : K11AuxiliaryValid 127 := by
  change (1 : Rat) <= (6404781 / 3125000 : Rat) /\
    (6404781 / 3125000 : Rat) <= (11277343 / 5000000 : Rat) /\
    (6404781 / 3125000 : Rat) <= (47516911 / 20000000 : Rat) /\
    (6404781 / 3125000 : Rat) <= (6404781 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_128 : K11AuxiliaryValid 128 := by
  change (1 : Rat) <= (540797081 / 100000000 : Rat) /\
    (540797081 / 100000000 : Rat) <= (112992753 / 20000000 : Rat) /\
    (540797081 / 100000000 : Rat) <= (540797081 / 100000000 : Rat) /\
    (540797081 / 100000000 : Rat) <= (147577427 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_129 : K11AuxiliaryValid 129 := by
  change (1 : Rat) <= (402364669 / 100000000 : Rat) /\
    (402364669 / 100000000 : Rat) <= (56553753 / 12500000 : Rat) /\
    (402364669 / 100000000 : Rat) <= (411059967 / 100000000 : Rat) /\
    (402364669 / 100000000 : Rat) <= (402364669 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_130 : K11AuxiliaryValid 130 := by
  change (1 : Rat) <= (129772293 / 100000000 : Rat) /\
    (129772293 / 100000000 : Rat) <= (129772293 / 100000000 : Rat) /\
    (129772293 / 100000000 : Rat) <= (6713951 / 5000000 : Rat) /\
    (129772293 / 100000000 : Rat) <= (34865537 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_131 : K11AuxiliaryValid 131 := by
  change (1 : Rat) <= (1271896129 / 50000000 : Rat) /\
    (1271896129 / 50000000 : Rat) <= (1550434333 / 50000000 : Rat) /\
    (1271896129 / 50000000 : Rat) <= (529457017 / 20000000 : Rat) /\
    (1271896129 / 50000000 : Rat) <= (1271896129 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_132 : K11AuxiliaryValid 132 := by
  change (1 : Rat) <= (153408489 / 20000000 : Rat) /\
    (153408489 / 20000000 : Rat) <= (791459067 / 100000000 : Rat) /\
    (153408489 / 20000000 : Rat) <= (434624283 / 50000000 : Rat) /\
    (153408489 / 20000000 : Rat) <= (153408489 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_133 : K11AuxiliaryValid 133 := by
  change (1 : Rat) <= (128302527 / 100000000 : Rat) /\
    (128302527 / 100000000 : Rat) <= (128302527 / 100000000 : Rat) /\
    (128302527 / 100000000 : Rat) <= (142576833 / 100000000 : Rat) /\
    (128302527 / 100000000 : Rat) <= (30186197 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_134 : K11AuxiliaryValid 134 := by
  change (1 : Rat) <= (1215084031 / 100000000 : Rat) /\
    (1215084031 / 100000000 : Rat) <= (29073449 / 2000000 : Rat) /\
    (1215084031 / 100000000 : Rat) <= (1215084031 / 100000000 : Rat) /\
    (1215084031 / 100000000 : Rat) <= (1262980239 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_135 : K11AuxiliaryValid 135 := by
  change (1 : Rat) <= (210920401 / 20000000 : Rat) /\
    (210920401 / 20000000 : Rat) <= (210920401 / 20000000 : Rat) /\
    (210920401 / 20000000 : Rat) <= (565219023 / 50000000 : Rat) /\
    (210920401 / 20000000 : Rat) <= (533691039 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_136 : K11AuxiliaryValid 136 := by
  change (1 : Rat) <= (609336601 / 50000000 : Rat) /\
    (609336601 / 50000000 : Rat) <= (609336601 / 50000000 : Rat) /\
    (609336601 / 50000000 : Rat) <= (827860069 / 50000000 : Rat) /\
    (609336601 / 50000000 : Rat) <= (712229571 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_137 : K11AuxiliaryValid 137 := by
  change (1 : Rat) <= (205794253 / 50000000 : Rat) /\
    (205794253 / 50000000 : Rat) <= (205794253 / 50000000 : Rat) /\
    (205794253 / 50000000 : Rat) <= (216429463 / 50000000 : Rat) /\
    (205794253 / 50000000 : Rat) <= (225382849 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_138 : K11AuxiliaryValid 138 := by
  change (1 : Rat) <= (574355117 / 100000000 : Rat) /\
    (574355117 / 100000000 : Rat) <= (287538881 / 50000000 : Rat) /\
    (574355117 / 100000000 : Rat) <= (147375189 / 25000000 : Rat) /\
    (574355117 / 100000000 : Rat) <= (574355117 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_139 : K11AuxiliaryValid 139 := by
  change (1 : Rat) <= (57792321 / 25000000 : Rat) /\
    (57792321 / 25000000 : Rat) <= (125167341 / 50000000 : Rat) /\
    (57792321 / 25000000 : Rat) <= (57792321 / 25000000 : Rat) /\
    (57792321 / 25000000 : Rat) <= (59833831 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_140 : K11AuxiliaryValid 140 := by
  change (1 : Rat) <= (801955601 / 100000000 : Rat) /\
    (801955601 / 100000000 : Rat) <= (211800547 / 25000000 : Rat) /\
    (801955601 / 100000000 : Rat) <= (801955601 / 100000000 : Rat) /\
    (801955601 / 100000000 : Rat) <= (841982677 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_141 : K11AuxiliaryValid 141 := by
  change (1 : Rat) <= (880965059 / 50000000 : Rat) /\
    (880965059 / 50000000 : Rat) <= (131183403 / 6250000 : Rat) /\
    (880965059 / 50000000 : Rat) <= (194819551 / 10000000 : Rat) /\
    (880965059 / 50000000 : Rat) <= (880965059 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_142 : K11AuxiliaryValid 142 := by
  change (1 : Rat) <= (82189917 / 50000000 : Rat) /\
    (82189917 / 50000000 : Rat) <= (35278749 / 20000000 : Rat) /\
    (82189917 / 50000000 : Rat) <= (86463817 / 50000000 : Rat) /\
    (82189917 / 50000000 : Rat) <= (82189917 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_143 : K11AuxiliaryValid 143 := by
  change (1 : Rat) <= (892972087 / 100000000 : Rat) /\
    (892972087 / 100000000 : Rat) <= (191756083 / 20000000 : Rat) /\
    (892972087 / 100000000 : Rat) <= (892972087 / 100000000 : Rat) /\
    (892972087 / 100000000 : Rat) <= (246120323 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_144 : K11AuxiliaryValid 144 := by
  change (1 : Rat) <= (204514299 / 50000000 : Rat) /\
    (204514299 / 50000000 : Rat) <= (204514299 / 50000000 : Rat) /\
    (204514299 / 50000000 : Rat) <= (427686027 / 100000000 : Rat) /\
    (204514299 / 50000000 : Rat) <= (43216051 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_145 : K11AuxiliaryValid 145 := by
  change (1 : Rat) <= (120102821 / 50000000 : Rat) /\
    (120102821 / 50000000 : Rat) <= (127350931 / 50000000 : Rat) /\
    (120102821 / 50000000 : Rat) <= (253614343 / 100000000 : Rat) /\
    (120102821 / 50000000 : Rat) <= (120102821 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_146 : K11AuxiliaryValid 146 := by
  change (1 : Rat) <= (9276999 / 2500000 : Rat) /\
    (9276999 / 2500000 : Rat) <= (377755779 / 100000000 : Rat) /\
    (9276999 / 2500000 : Rat) <= (1572098 / 390625 : Rat) /\
    (9276999 / 2500000 : Rat) <= (9276999 / 2500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_147 : K11AuxiliaryValid 147 := by
  change (1 : Rat) <= (255643659 / 50000000 : Rat) /\
    (255643659 / 50000000 : Rat) <= (525929787 / 100000000 : Rat) /\
    (255643659 / 50000000 : Rat) <= (578993067 / 100000000 : Rat) /\
    (255643659 / 50000000 : Rat) <= (255643659 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_148 : K11AuxiliaryValid 148 := by
  change (1 : Rat) <= (144083377 / 100000000 : Rat) /\
    (144083377 / 100000000 : Rat) <= (16684443 / 10000000 : Rat) /\
    (144083377 / 100000000 : Rat) <= (144083377 / 100000000 : Rat) /\
    (144083377 / 100000000 : Rat) <= (164479443 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_149 : K11AuxiliaryValid 149 := by
  change (1 : Rat) <= (1077688707 / 100000000 : Rat) /\
    (1077688707 / 100000000 : Rat) <= (1077688707 / 100000000 : Rat) /\
    (1077688707 / 100000000 : Rat) <= (554412171 / 50000000 : Rat) /\
    (1077688707 / 100000000 : Rat) <= (290740481 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_150 : K11AuxiliaryValid 150 := by
  change (1 : Rat) <= (669301939 / 100000000 : Rat) /\
    (669301939 / 100000000 : Rat) <= (362454909 / 50000000 : Rat) /\
    (669301939 / 100000000 : Rat) <= (669301939 / 100000000 : Rat) /\
    (669301939 / 100000000 : Rat) <= (34037037 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_151 : K11AuxiliaryValid 151 := by
  change (1 : Rat) <= (5646219 / 2000000 : Rat) /\
    (5646219 / 2000000 : Rat) <= (337811243 / 100000000 : Rat) /\
    (5646219 / 2000000 : Rat) <= (361740423 / 100000000 : Rat) /\
    (5646219 / 2000000 : Rat) <= (5646219 / 2000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_152 : K11AuxiliaryValid 152 := by
  change (1 : Rat) <= (110638137 / 20000000 : Rat) /\
    (110638137 / 20000000 : Rat) <= (110638137 / 20000000 : Rat) /\
    (110638137 / 20000000 : Rat) <= (12106253 / 2000000 : Rat) /\
    (110638137 / 20000000 : Rat) <= (17435781 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_153 : K11AuxiliaryValid 153 := by
  change (1 : Rat) <= (889355557 / 100000000 : Rat) /\
    (889355557 / 100000000 : Rat) <= (987751629 / 100000000 : Rat) /\
    (889355557 / 100000000 : Rat) <= (995440509 / 100000000 : Rat) /\
    (889355557 / 100000000 : Rat) <= (889355557 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_154 : K11AuxiliaryValid 154 := by
  change (1 : Rat) <= (26688583 / 12500000 : Rat) /\
    (26688583 / 12500000 : Rat) <= (231109237 / 100000000 : Rat) /\
    (26688583 / 12500000 : Rat) <= (214170521 / 100000000 : Rat) /\
    (26688583 / 12500000 : Rat) <= (26688583 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_155 : K11AuxiliaryValid 155 := by
  change (1 : Rat) <= (372445907 / 100000000 : Rat) /\
    (372445907 / 100000000 : Rat) <= (372445907 / 100000000 : Rat) /\
    (372445907 / 100000000 : Rat) <= (15555851 / 4000000 : Rat) /\
    (372445907 / 100000000 : Rat) <= (195775727 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_156 : K11AuxiliaryValid 156 := by
  change (1 : Rat) <= (51052777 / 10000000 : Rat) /\
    (51052777 / 10000000 : Rat) <= (265912823 / 50000000 : Rat) /\
    (51052777 / 10000000 : Rat) <= (551060279 / 100000000 : Rat) /\
    (51052777 / 10000000 : Rat) <= (51052777 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_157 : K11AuxiliaryValid 157 := by
  change (1 : Rat) <= (16235429 / 12500000 : Rat) /\
    (16235429 / 12500000 : Rat) <= (16235429 / 12500000 : Rat) /\
    (16235429 / 12500000 : Rat) <= (69158297 / 50000000 : Rat) /\
    (16235429 / 12500000 : Rat) <= (1044509 / 800000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_158 : K11AuxiliaryValid 158 := by
  change (1 : Rat) <= (141130917 / 12500000 : Rat) /\
    (141130917 / 12500000 : Rat) <= (578787213 / 50000000 : Rat) /\
    (141130917 / 12500000 : Rat) <= (141130917 / 12500000 : Rat) /\
    (141130917 / 12500000 : Rat) <= (1164893599 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_159 : K11AuxiliaryValid 159 := by
  change (1 : Rat) <= (225660037 / 12500000 : Rat) /\
    (225660037 / 12500000 : Rat) <= (1024129333 / 50000000 : Rat) /\
    (225660037 / 12500000 : Rat) <= (1839542807 / 100000000 : Rat) /\
    (225660037 / 12500000 : Rat) <= (225660037 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_160 : K11AuxiliaryValid 160 := by
  change (1 : Rat) <= (6545771 / 5000000 : Rat) /\
    (6545771 / 5000000 : Rat) <= (28497563 / 20000000 : Rat) /\
    (6545771 / 5000000 : Rat) <= (70096563 / 50000000 : Rat) /\
    (6545771 / 5000000 : Rat) <= (6545771 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_161 : K11AuxiliaryValid 161 := by
  change (1 : Rat) <= (392573659 / 25000000 : Rat) /\
    (392573659 / 25000000 : Rat) <= (1744545289 / 100000000 : Rat) /\
    (392573659 / 25000000 : Rat) <= (392573659 / 25000000 : Rat) /\
    (392573659 / 25000000 : Rat) <= (1919738009 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_162 : K11AuxiliaryValid 162 := by
  change (1 : Rat) <= (519401499 / 50000000 : Rat) /\
    (519401499 / 50000000 : Rat) <= (590199341 / 50000000 : Rat) /\
    (519401499 / 50000000 : Rat) <= (519401499 / 50000000 : Rat) /\
    (519401499 / 50000000 : Rat) <= (209953767 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_163 : K11AuxiliaryValid 163 := by
  change (1 : Rat) <= (317473377 / 100000000 : Rat) /\
    (317473377 / 100000000 : Rat) <= (319373037 / 100000000 : Rat) /\
    (317473377 / 100000000 : Rat) <= (317473377 / 100000000 : Rat) /\
    (317473377 / 100000000 : Rat) <= (336364689 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_164 : K11AuxiliaryValid 164 := by
  change (1 : Rat) <= (114079429 / 20000000 : Rat) /\
    (114079429 / 20000000 : Rat) <= (114079429 / 20000000 : Rat) /\
    (114079429 / 20000000 : Rat) <= (598814889 / 100000000 : Rat) /\
    (114079429 / 20000000 : Rat) <= (611740357 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_165 : K11AuxiliaryValid 165 := by
  change (1 : Rat) <= (102639179 / 20000000 : Rat) /\
    (102639179 / 20000000 : Rat) <= (102639179 / 20000000 : Rat) /\
    (102639179 / 20000000 : Rat) <= (110558473 / 20000000 : Rat) /\
    (102639179 / 20000000 : Rat) <= (519278193 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_166 : K11AuxiliaryValid 166 := by
  change (1 : Rat) <= (294540081 / 50000000 : Rat) /\
    (294540081 / 50000000 : Rat) <= (621987229 / 100000000 : Rat) /\
    (294540081 / 50000000 : Rat) <= (152395067 / 20000000 : Rat) /\
    (294540081 / 50000000 : Rat) <= (294540081 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_167 : K11AuxiliaryValid 167 := by
  change (1 : Rat) <= (159636917 / 25000000 : Rat) /\
    (159636917 / 25000000 : Rat) <= (130847919 / 20000000 : Rat) /\
    (159636917 / 25000000 : Rat) <= (701942601 / 100000000 : Rat) /\
    (159636917 / 25000000 : Rat) <= (159636917 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_168 : K11AuxiliaryValid 168 := by
  change (1 : Rat) <= (1407675693 / 100000000 : Rat) /\
    (1407675693 / 100000000 : Rat) <= (1484374683 / 100000000 : Rat) /\
    (1407675693 / 100000000 : Rat) <= (212504739 / 12500000 : Rat) /\
    (1407675693 / 100000000 : Rat) <= (1407675693 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_169 : K11AuxiliaryValid 169 := by
  change (1 : Rat) <= (67363979 / 50000000 : Rat) /\
    (67363979 / 50000000 : Rat) <= (13761493 / 10000000 : Rat) /\
    (67363979 / 50000000 : Rat) <= (135549191 / 100000000 : Rat) /\
    (67363979 / 50000000 : Rat) <= (67363979 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_170 : K11AuxiliaryValid 170 := by
  change (1 : Rat) <= (48798553 / 4000000 : Rat) /\
    (48798553 / 4000000 : Rat) <= (1262920569 / 100000000 : Rat) /\
    (48798553 / 4000000 : Rat) <= (159389113 / 12500000 : Rat) /\
    (48798553 / 4000000 : Rat) <= (48798553 / 4000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_171 : K11AuxiliaryValid 171 := by
  change (1 : Rat) <= (126528713 / 25000000 : Rat) /\
    (126528713 / 25000000 : Rat) <= (280228589 / 50000000 : Rat) /\
    (126528713 / 25000000 : Rat) <= (144409037 / 25000000 : Rat) /\
    (126528713 / 25000000 : Rat) <= (126528713 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_172 : K11AuxiliaryValid 172 := by
  change (1 : Rat) <= (199801813 / 100000000 : Rat) /\
    (199801813 / 100000000 : Rat) <= (199801813 / 100000000 : Rat) /\
    (199801813 / 100000000 : Rat) <= (105549699 / 50000000 : Rat) /\
    (199801813 / 100000000 : Rat) <= (27836407 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_173 : K11AuxiliaryValid 173 := by
  change (1 : Rat) <= (23550997 / 10000000 : Rat) /\
    (23550997 / 10000000 : Rat) <= (239950967 / 100000000 : Rat) /\
    (23550997 / 10000000 : Rat) <= (237870593 / 100000000 : Rat) /\
    (23550997 / 10000000 : Rat) <= (23550997 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_174 : K11AuxiliaryValid 174 := by
  change (1 : Rat) <= (780609483 / 100000000 : Rat) /\
    (780609483 / 100000000 : Rat) <= (780609483 / 100000000 : Rat) /\
    (780609483 / 100000000 : Rat) <= (829635321 / 100000000 : Rat) /\
    (780609483 / 100000000 : Rat) <= (44745921 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_175 : K11AuxiliaryValid 175 := by
  change (1 : Rat) <= (45838019 / 20000000 : Rat) /\
    (45838019 / 20000000 : Rat) <= (45838019 / 20000000 : Rat) /\
    (45838019 / 20000000 : Rat) <= (124577541 / 50000000 : Rat) /\
    (45838019 / 20000000 : Rat) <= (61948759 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_176 : K11AuxiliaryValid 176 := by
  change (1 : Rat) <= (751241503 / 100000000 : Rat) /\
    (751241503 / 100000000 : Rat) <= (751241503 / 100000000 : Rat) /\
    (751241503 / 100000000 : Rat) <= (189630077 / 25000000 : Rat) /\
    (751241503 / 100000000 : Rat) <= (25733099 / 3125000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_177 : K11AuxiliaryValid 177 := by
  change (1 : Rat) <= (381519687 / 50000000 : Rat) /\
    (381519687 / 50000000 : Rat) <= (763589289 / 100000000 : Rat) /\
    (381519687 / 50000000 : Rat) <= (381519687 / 50000000 : Rat) /\
    (381519687 / 50000000 : Rat) <= (40807381 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_178 : K11AuxiliaryValid 178 := by
  change (1 : Rat) <= (1213013 / 1000000 : Rat) /\
    (1213013 / 1000000 : Rat) <= (133281951 / 100000000 : Rat) /\
    (1213013 / 1000000 : Rat) <= (1213013 / 1000000 : Rat) /\
    (1213013 / 1000000 : Rat) <= (127669243 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_179 : K11AuxiliaryValid 179 := by
  change (1 : Rat) <= (103667129 / 20000000 : Rat) /\
    (103667129 / 20000000 : Rat) <= (104714811 / 20000000 : Rat) /\
    (103667129 / 20000000 : Rat) <= (545105503 / 100000000 : Rat) /\
    (103667129 / 20000000 : Rat) <= (103667129 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_180 : K11AuxiliaryValid 180 := by
  change (1 : Rat) <= (2122073 / 200000 : Rat) /\
    (2122073 / 200000 : Rat) <= (1217150523 / 100000000 : Rat) /\
    (2122073 / 200000 : Rat) <= (1150478651 / 100000000 : Rat) /\
    (2122073 / 200000 : Rat) <= (2122073 / 200000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_181 : K11AuxiliaryValid 181 := by
  change (1 : Rat) <= (2610358 / 390625 : Rat) /\
    (2610358 / 390625 : Rat) <= (697180719 / 100000000 : Rat) /\
    (2610358 / 390625 : Rat) <= (2610358 / 390625 : Rat) /\
    (2610358 / 390625 : Rat) <= (49577529 / 6250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_182 : K11AuxiliaryValid 182 := by
  change (1 : Rat) <= (508532879 / 100000000 : Rat) /\
    (508532879 / 100000000 : Rat) <= (515510497 / 100000000 : Rat) /\
    (508532879 / 100000000 : Rat) <= (508532879 / 100000000 : Rat) /\
    (508532879 / 100000000 : Rat) <= (273739219 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_183 : K11AuxiliaryValid 183 := by
  change (1 : Rat) <= (9695723 / 2000000 : Rat) /\
    (9695723 / 2000000 : Rat) <= (148962583 / 25000000 : Rat) /\
    (9695723 / 2000000 : Rat) <= (9695723 / 2000000 : Rat) /\
    (9695723 / 2000000 : Rat) <= (261019549 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_184 : K11AuxiliaryValid 184 := by
  change (1 : Rat) <= (95095579 / 50000000 : Rat) /\
    (95095579 / 50000000 : Rat) <= (41912719 / 20000000 : Rat) /\
    (95095579 / 50000000 : Rat) <= (95095579 / 50000000 : Rat) /\
    (95095579 / 50000000 : Rat) <= (205394703 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_185 : K11AuxiliaryValid 185 := by
  change (1 : Rat) <= (305025807 / 25000000 : Rat) /\
    (305025807 / 25000000 : Rat) <= (162759249 / 12500000 : Rat) /\
    (305025807 / 25000000 : Rat) <= (305025807 / 25000000 : Rat) /\
    (305025807 / 25000000 : Rat) <= (1343266727 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_186 : K11AuxiliaryValid 186 := by
  change (1 : Rat) <= (652316659 / 100000000 : Rat) /\
    (652316659 / 100000000 : Rat) <= (20420757 / 3125000 : Rat) /\
    (652316659 / 100000000 : Rat) <= (86275007 / 12500000 : Rat) /\
    (652316659 / 100000000 : Rat) <= (652316659 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_187 : K11AuxiliaryValid 187 := by
  change (1 : Rat) <= (47048267 / 25000000 : Rat) /\
    (47048267 / 25000000 : Rat) <= (94574031 / 50000000 : Rat) /\
    (47048267 / 25000000 : Rat) <= (47048267 / 25000000 : Rat) /\
    (47048267 / 25000000 : Rat) <= (21070113 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_188 : K11AuxiliaryValid 188 := by
  change (1 : Rat) <= (374228031 / 20000000 : Rat) /\
    (374228031 / 20000000 : Rat) <= (2279764493 / 100000000 : Rat) /\
    (374228031 / 20000000 : Rat) <= (1872123631 / 100000000 : Rat) /\
    (374228031 / 20000000 : Rat) <= (374228031 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_189 : K11AuxiliaryValid 189 := by
  change (1 : Rat) <= (73492127 / 10000000 : Rat) /\
    (73492127 / 10000000 : Rat) <= (211479607 / 25000000 : Rat) /\
    (73492127 / 10000000 : Rat) <= (750107509 / 100000000 : Rat) /\
    (73492127 / 10000000 : Rat) <= (73492127 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_190 : K11AuxiliaryValid 190 := by
  change (1 : Rat) <= (85729277 / 25000000 : Rat) /\
    (85729277 / 25000000 : Rat) <= (405297833 / 100000000 : Rat) /\
    (85729277 / 25000000 : Rat) <= (85729277 / 25000000 : Rat) /\
    (85729277 / 25000000 : Rat) <= (348076877 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_191 : K11AuxiliaryValid 191 := by
  change (1 : Rat) <= (173387271 / 50000000 : Rat) /\
    (173387271 / 50000000 : Rat) <= (173387271 / 50000000 : Rat) /\
    (173387271 / 50000000 : Rat) <= (363144519 / 100000000 : Rat) /\
    (173387271 / 50000000 : Rat) <= (364513981 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_192 : K11AuxiliaryValid 192 := by
  change (1 : Rat) <= (99422803 / 25000000 : Rat) /\
    (99422803 / 25000000 : Rat) <= (404609431 / 100000000 : Rat) /\
    (99422803 / 25000000 : Rat) <= (53235703 / 12500000 : Rat) /\
    (99422803 / 25000000 : Rat) <= (99422803 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_193 : K11AuxiliaryValid 193 := by
  change (1 : Rat) <= (519622443 / 100000000 : Rat) /\
    (519622443 / 100000000 : Rat) <= (519622443 / 100000000 : Rat) /\
    (519622443 / 100000000 : Rat) <= (598066573 / 100000000 : Rat) /\
    (519622443 / 100000000 : Rat) <= (535863639 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_194 : K11AuxiliaryValid 194 := by
  change (1 : Rat) <= (121553651 / 20000000 : Rat) /\
    (121553651 / 20000000 : Rat) <= (616016463 / 100000000 : Rat) /\
    (121553651 / 20000000 : Rat) <= (672014117 / 100000000 : Rat) /\
    (121553651 / 20000000 : Rat) <= (121553651 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_195 : K11AuxiliaryValid 195 := by
  change (1 : Rat) <= (1124290847 / 100000000 : Rat) /\
    (1124290847 / 100000000 : Rat) <= (1228020123 / 100000000 : Rat) /\
    (1124290847 / 100000000 : Rat) <= (704793853 / 50000000 : Rat) /\
    (1124290847 / 100000000 : Rat) <= (1124290847 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_196 : K11AuxiliaryValid 196 := by
  change (1 : Rat) <= (159682949 / 100000000 : Rat) /\
    (159682949 / 100000000 : Rat) <= (159682949 / 100000000 : Rat) /\
    (159682949 / 100000000 : Rat) <= (21509859 / 12500000 : Rat) /\
    (159682949 / 100000000 : Rat) <= (181421111 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_197 : K11AuxiliaryValid 197 := by
  change (1 : Rat) <= (1443540471 / 50000000 : Rat) /\
    (1443540471 / 50000000 : Rat) <= (3613998147 / 100000000 : Rat) /\
    (1443540471 / 50000000 : Rat) <= (1443540471 / 50000000 : Rat) /\
    (1443540471 / 50000000 : Rat) <= (3515507669 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_198 : K11AuxiliaryValid 198 := by
  change (1 : Rat) <= (597622551 / 100000000 : Rat) /\
    (597622551 / 100000000 : Rat) <= (597622551 / 100000000 : Rat) /\
    (597622551 / 100000000 : Rat) <= (120903697 / 20000000 : Rat) /\
    (597622551 / 100000000 : Rat) <= (660481781 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_199 : K11AuxiliaryValid 199 := by
  change (1 : Rat) <= (192200229 / 100000000 : Rat) /\
    (192200229 / 100000000 : Rat) <= (200572171 / 100000000 : Rat) /\
    (192200229 / 100000000 : Rat) <= (115842769 / 50000000 : Rat) /\
    (192200229 / 100000000 : Rat) <= (192200229 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_200 : K11AuxiliaryValid 200 := by
  change (1 : Rat) <= (43965717 / 12500000 : Rat) /\
    (43965717 / 12500000 : Rat) <= (355966087 / 100000000 : Rat) /\
    (43965717 / 12500000 : Rat) <= (199381657 / 50000000 : Rat) /\
    (43965717 / 12500000 : Rat) <= (43965717 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_201 : K11AuxiliaryValid 201 := by
  change (1 : Rat) <= (587488171 / 100000000 : Rat) /\
    (587488171 / 100000000 : Rat) <= (165444989 / 25000000 : Rat) /\
    (587488171 / 100000000 : Rat) <= (587488171 / 100000000 : Rat) /\
    (587488171 / 100000000 : Rat) <= (119307199 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_202 : K11AuxiliaryValid 202 := by
  change (1 : Rat) <= (34332953 / 20000000 : Rat) /\
    (34332953 / 20000000 : Rat) <= (21932489 / 12500000 : Rat) /\
    (34332953 / 20000000 : Rat) <= (34361409 / 20000000 : Rat) /\
    (34332953 / 20000000 : Rat) <= (34332953 / 20000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_203 : K11AuxiliaryValid 203 := by
  change (1 : Rat) <= (1341080923 / 100000000 : Rat) /\
    (1341080923 / 100000000 : Rat) <= (203557583 / 12500000 : Rat) /\
    (1341080923 / 100000000 : Rat) <= (31490889 / 2000000 : Rat) /\
    (1341080923 / 100000000 : Rat) <= (1341080923 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_204 : K11AuxiliaryValid 204 := by
  change (1 : Rat) <= (513358757 / 50000000 : Rat) /\
    (513358757 / 50000000 : Rat) <= (513358757 / 50000000 : Rat) /\
    (513358757 / 50000000 : Rat) <= (591416969 / 50000000 : Rat) /\
    (513358757 / 50000000 : Rat) <= (1029502823 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_205 : K11AuxiliaryValid 205 := by
  change (1 : Rat) <= (173739757 / 100000000 : Rat) /\
    (173739757 / 100000000 : Rat) <= (5507479 / 3125000 : Rat) /\
    (173739757 / 100000000 : Rat) <= (94323649 / 50000000 : Rat) /\
    (173739757 / 100000000 : Rat) <= (173739757 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_206 : K11AuxiliaryValid 206 := by
  change (1 : Rat) <= (628241083 / 100000000 : Rat) /\
    (628241083 / 100000000 : Rat) <= (628241083 / 100000000 : Rat) /\
    (628241083 / 100000000 : Rat) <= (18872283 / 2500000 : Rat) /\
    (628241083 / 100000000 : Rat) <= (640254311 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_207 : K11AuxiliaryValid 207 := by
  change (1 : Rat) <= (919697183 / 100000000 : Rat) /\
    (919697183 / 100000000 : Rat) <= (919697183 / 100000000 : Rat) /\
    (919697183 / 100000000 : Rat) <= (1033425817 / 100000000 : Rat) /\
    (919697183 / 100000000 : Rat) <= (505395469 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_208 : K11AuxiliaryValid 208 := by
  change (1 : Rat) <= (225639887 / 100000000 : Rat) /\
    (225639887 / 100000000 : Rat) <= (233971203 / 100000000 : Rat) /\
    (225639887 / 100000000 : Rat) <= (115253551 / 50000000 : Rat) /\
    (225639887 / 100000000 : Rat) <= (225639887 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_209 : K11AuxiliaryValid 209 := by
  change (1 : Rat) <= (65894497 / 12500000 : Rat) /\
    (65894497 / 12500000 : Rat) <= (541335339 / 100000000 : Rat) /\
    (65894497 / 12500000 : Rat) <= (567478161 / 100000000 : Rat) /\
    (65894497 / 12500000 : Rat) <= (65894497 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_210 : K11AuxiliaryValid 210 := by
  change (1 : Rat) <= (109471569 / 25000000 : Rat) /\
    (109471569 / 25000000 : Rat) <= (109471569 / 25000000 : Rat) /\
    (109471569 / 25000000 : Rat) <= (13995927 / 3125000 : Rat) /\
    (109471569 / 25000000 : Rat) <= (3460103 / 781250 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_211 : K11AuxiliaryValid 211 := by
  change (1 : Rat) <= (66551543 / 50000000 : Rat) /\
    (66551543 / 50000000 : Rat) <= (66551543 / 50000000 : Rat) /\
    (66551543 / 50000000 : Rat) <= (69228047 / 50000000 : Rat) /\
    (66551543 / 50000000 : Rat) <= (5642443 / 4000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_212 : K11AuxiliaryValid 212 := by
  change (1 : Rat) <= (2355689379 / 100000000 : Rat) /\
    (2355689379 / 100000000 : Rat) <= (1305284701 / 50000000 : Rat) /\
    (2355689379 / 100000000 : Rat) <= (3001336997 / 100000000 : Rat) /\
    (2355689379 / 100000000 : Rat) <= (2355689379 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_213 : K11AuxiliaryValid 213 := by
  change (1 : Rat) <= (141504243 / 12500000 : Rat) /\
    (141504243 / 12500000 : Rat) <= (614419071 / 50000000 : Rat) /\
    (141504243 / 12500000 : Rat) <= (141504243 / 12500000 : Rat) /\
    (141504243 / 12500000 : Rat) <= (1323583461 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_214 : K11AuxiliaryValid 214 := by
  change (1 : Rat) <= (11192591 / 6250000 : Rat) /\
    (11192591 / 6250000 : Rat) <= (11192591 / 6250000 : Rat) /\
    (11192591 / 6250000 : Rat) <= (195502111 / 100000000 : Rat) /\
    (11192591 / 6250000 : Rat) <= (2359597 / 1250000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_215 : K11AuxiliaryValid 215 := by
  change (1 : Rat) <= (1294355361 / 100000000 : Rat) /\
    (1294355361 / 100000000 : Rat) <= (1294355361 / 100000000 : Rat) /\
    (1294355361 / 100000000 : Rat) <= (137442241 / 10000000 : Rat) /\
    (1294355361 / 100000000 : Rat) <= (1475872633 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_216 : K11AuxiliaryValid 216 := by
  change (1 : Rat) <= (1264817007 / 100000000 : Rat) /\
    (1264817007 / 100000000 : Rat) <= (300446967 / 20000000 : Rat) /\
    (1264817007 / 100000000 : Rat) <= (665395679 / 50000000 : Rat) /\
    (1264817007 / 100000000 : Rat) <= (1264817007 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_217 : K11AuxiliaryValid 217 := by
  change (1 : Rat) <= (138891511 / 25000000 : Rat) /\
    (138891511 / 25000000 : Rat) <= (138891511 / 25000000 : Rat) /\
    (138891511 / 25000000 : Rat) <= (71209661 / 12500000 : Rat) /\
    (138891511 / 25000000 : Rat) <= (155290399 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_218 : K11AuxiliaryValid 218 := by
  change (1 : Rat) <= (444842237 / 100000000 : Rat) /\
    (444842237 / 100000000 : Rat) <= (444842237 / 100000000 : Rat) /\
    (444842237 / 100000000 : Rat) <= (462341409 / 100000000 : Rat) /\
    (444842237 / 100000000 : Rat) <= (48642517 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_219 : K11AuxiliaryValid 219 := by
  change (1 : Rat) <= (635794531 / 100000000 : Rat) /\
    (635794531 / 100000000 : Rat) <= (668156639 / 100000000 : Rat) /\
    (635794531 / 100000000 : Rat) <= (635794531 / 100000000 : Rat) /\
    (635794531 / 100000000 : Rat) <= (166350883 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_220 : K11AuxiliaryValid 220 := by
  change (1 : Rat) <= (25995481 / 10000000 : Rat) /\
    (25995481 / 10000000 : Rat) <= (138305841 / 50000000 : Rat) /\
    (25995481 / 10000000 : Rat) <= (25995481 / 10000000 : Rat) /\
    (25995481 / 10000000 : Rat) <= (271293307 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_221 : K11AuxiliaryValid 221 := by
  change (1 : Rat) <= (727469633 / 100000000 : Rat) /\
    (727469633 / 100000000 : Rat) <= (24885483 / 3125000 : Rat) /\
    (727469633 / 100000000 : Rat) <= (727469633 / 100000000 : Rat) /\
    (727469633 / 100000000 : Rat) <= (30132189 / 4000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_222 : K11AuxiliaryValid 222 := by
  change (1 : Rat) <= (1680641739 / 50000000 : Rat) /\
    (1680641739 / 50000000 : Rat) <= (1680641739 / 50000000 : Rat) /\
    (1680641739 / 50000000 : Rat) <= (3498471163 / 100000000 : Rat) /\
    (1680641739 / 50000000 : Rat) <= (4104746083 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_223 : K11AuxiliaryValid 223 := by
  change (1 : Rat) <= (117015573 / 100000000 : Rat) /\
    (117015573 / 100000000 : Rat) <= (12884509 / 10000000 : Rat) /\
    (117015573 / 100000000 : Rat) <= (117015573 / 100000000 : Rat) /\
    (117015573 / 100000000 : Rat) <= (126852327 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_224 : K11AuxiliaryValid 224 := by
  change (1 : Rat) <= (1580725823 / 100000000 : Rat) /\
    (1580725823 / 100000000 : Rat) <= (1580725823 / 100000000 : Rat) /\
    (1580725823 / 100000000 : Rat) <= (203898827 / 12500000 : Rat) /\
    (1580725823 / 100000000 : Rat) <= (869281527 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_225 : K11AuxiliaryValid 225 := by
  change (1 : Rat) <= (87023447 / 20000000 : Rat) /\
    (87023447 / 20000000 : Rat) <= (87023447 / 20000000 : Rat) /\
    (87023447 / 20000000 : Rat) <= (110385213 / 25000000 : Rat) /\
    (87023447 / 20000000 : Rat) <= (3820039 / 800000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_226 : K11AuxiliaryValid 226 := by
  change (1 : Rat) <= (115110721 / 50000000 : Rat) /\
    (115110721 / 50000000 : Rat) <= (63393229 / 25000000 : Rat) /\
    (115110721 / 50000000 : Rat) <= (119859119 / 50000000 : Rat) /\
    (115110721 / 50000000 : Rat) <= (115110721 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_227 : K11AuxiliaryValid 227 := by
  change (1 : Rat) <= (102835219 / 20000000 : Rat) /\
    (102835219 / 20000000 : Rat) <= (52520791 / 10000000 : Rat) /\
    (102835219 / 20000000 : Rat) <= (102835219 / 20000000 : Rat) /\
    (102835219 / 20000000 : Rat) <= (61869533 / 10000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_228 : K11AuxiliaryValid 228 := by
  change (1 : Rat) <= (588787881 / 100000000 : Rat) /\
    (588787881 / 100000000 : Rat) <= (633992527 / 100000000 : Rat) /\
    (588787881 / 100000000 : Rat) <= (588787881 / 100000000 : Rat) /\
    (588787881 / 100000000 : Rat) <= (77169637 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_229 : K11AuxiliaryValid 229 := by
  change (1 : Rat) <= (215758641 / 100000000 : Rat) /\
    (215758641 / 100000000 : Rat) <= (266492437 / 100000000 : Rat) /\
    (215758641 / 100000000 : Rat) <= (61751593 / 25000000 : Rat) /\
    (215758641 / 100000000 : Rat) <= (215758641 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_230 : K11AuxiliaryValid 230 := by
  change (1 : Rat) <= (1570543481 / 100000000 : Rat) /\
    (1570543481 / 100000000 : Rat) <= (1701644267 / 100000000 : Rat) /\
    (1570543481 / 100000000 : Rat) <= (1570543481 / 100000000 : Rat) /\
    (1570543481 / 100000000 : Rat) <= (803588203 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_231 : K11AuxiliaryValid 231 := by
  change (1 : Rat) <= (220763401 / 20000000 : Rat) /\
    (220763401 / 20000000 : Rat) <= (1133441551 / 100000000 : Rat) /\
    (220763401 / 20000000 : Rat) <= (220763401 / 20000000 : Rat) /\
    (220763401 / 20000000 : Rat) <= (618443583 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_232 : K11AuxiliaryValid 232 := by
  change (1 : Rat) <= (92027051 / 50000000 : Rat) /\
    (92027051 / 50000000 : Rat) <= (24520467 / 12500000 : Rat) /\
    (92027051 / 50000000 : Rat) <= (50351427 / 25000000 : Rat) /\
    (92027051 / 50000000 : Rat) <= (92027051 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_233 : K11AuxiliaryValid 233 := by
  change (1 : Rat) <= (564103991 / 100000000 : Rat) /\
    (564103991 / 100000000 : Rat) <= (119022317 / 20000000 : Rat) /\
    (564103991 / 100000000 : Rat) <= (564103991 / 100000000 : Rat) /\
    (564103991 / 100000000 : Rat) <= (601074159 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_234 : K11AuxiliaryValid 234 := by
  change (1 : Rat) <= (761348291 / 100000000 : Rat) /\
    (761348291 / 100000000 : Rat) <= (405686321 / 50000000 : Rat) /\
    (761348291 / 100000000 : Rat) <= (761348291 / 100000000 : Rat) /\
    (761348291 / 100000000 : Rat) <= (40105437 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_235 : K11AuxiliaryValid 235 := by
  change (1 : Rat) <= (138347601 / 50000000 : Rat) /\
    (138347601 / 50000000 : Rat) <= (284938397 / 100000000 : Rat) /\
    (138347601 / 50000000 : Rat) <= (138347601 / 50000000 : Rat) /\
    (138347601 / 50000000 : Rat) <= (71741949 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_236 : K11AuxiliaryValid 236 := by
  change (1 : Rat) <= (15660921 / 5000000 : Rat) /\
    (15660921 / 5000000 : Rat) <= (161402589 / 50000000 : Rat) /\
    (15660921 / 5000000 : Rat) <= (33251873 / 10000000 : Rat) /\
    (15660921 / 5000000 : Rat) <= (15660921 / 5000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_237 : K11AuxiliaryValid 237 := by
  change (1 : Rat) <= (133610141 / 25000000 : Rat) /\
    (133610141 / 25000000 : Rat) <= (554048139 / 100000000 : Rat) /\
    (133610141 / 25000000 : Rat) <= (588759429 / 100000000 : Rat) /\
    (133610141 / 25000000 : Rat) <= (133610141 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_238 : K11AuxiliaryValid 238 := by
  change (1 : Rat) <= (8267143 / 6250000 : Rat) /\
    (8267143 / 6250000 : Rat) <= (8267143 / 6250000 : Rat) /\
    (8267143 / 6250000 : Rat) <= (68608049 / 50000000 : Rat) /\
    (8267143 / 6250000 : Rat) <= (68572433 / 50000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_239 : K11AuxiliaryValid 239 := by
  change (1 : Rat) <= (272736621 / 12500000 : Rat) /\
    (272736621 / 12500000 : Rat) <= (521870167 / 20000000 : Rat) /\
    (272736621 / 12500000 : Rat) <= (2278530101 / 100000000 : Rat) /\
    (272736621 / 12500000 : Rat) <= (272736621 / 12500000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_240 : K11AuxiliaryValid 240 := by
  change (1 : Rat) <= (1368217039 / 100000000 : Rat) /\
    (1368217039 / 100000000 : Rat) <= (149660953 / 10000000 : Rat) /\
    (1368217039 / 100000000 : Rat) <= (295184861 / 20000000 : Rat) /\
    (1368217039 / 100000000 : Rat) <= (1368217039 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_241 : K11AuxiliaryValid 241 := by
  change (1 : Rat) <= (39426861 / 25000000 : Rat) /\
    (39426861 / 25000000 : Rat) <= (166474923 / 100000000 : Rat) /\
    (39426861 / 25000000 : Rat) <= (163439217 / 100000000 : Rat) /\
    (39426861 / 25000000 : Rat) <= (39426861 / 25000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k11_auxiliary_valid_242 : K11AuxiliaryValid 242 := by
  change (1 : Rat) <= (2076358459 / 100000000 : Rat) /\
    (2076358459 / 100000000 : Rat) <= (90572889 / 4000000 : Rat) /\
    (2076358459 / 100000000 : Rat) <= (85073113 / 3125000 : Rat) /\
    (2076358459 / 100000000 : Rat) <= (2076358459 / 100000000 : Rat)
  norm_num1
  exact ⟨trivial, trivial, trivial, trivial⟩

theorem k11_auxiliary_shard_0 (index : Nat)
    (hlo : 0 <= index) (hhi : index < 243) :
    K11AuxiliaryValid index := by
  interval_cases index
  · exact k11_auxiliary_valid_0
  · exact k11_auxiliary_valid_1
  · exact k11_auxiliary_valid_2
  · exact k11_auxiliary_valid_3
  · exact k11_auxiliary_valid_4
  · exact k11_auxiliary_valid_5
  · exact k11_auxiliary_valid_6
  · exact k11_auxiliary_valid_7
  · exact k11_auxiliary_valid_8
  · exact k11_auxiliary_valid_9
  · exact k11_auxiliary_valid_10
  · exact k11_auxiliary_valid_11
  · exact k11_auxiliary_valid_12
  · exact k11_auxiliary_valid_13
  · exact k11_auxiliary_valid_14
  · exact k11_auxiliary_valid_15
  · exact k11_auxiliary_valid_16
  · exact k11_auxiliary_valid_17
  · exact k11_auxiliary_valid_18
  · exact k11_auxiliary_valid_19
  · exact k11_auxiliary_valid_20
  · exact k11_auxiliary_valid_21
  · exact k11_auxiliary_valid_22
  · exact k11_auxiliary_valid_23
  · exact k11_auxiliary_valid_24
  · exact k11_auxiliary_valid_25
  · exact k11_auxiliary_valid_26
  · exact k11_auxiliary_valid_27
  · exact k11_auxiliary_valid_28
  · exact k11_auxiliary_valid_29
  · exact k11_auxiliary_valid_30
  · exact k11_auxiliary_valid_31
  · exact k11_auxiliary_valid_32
  · exact k11_auxiliary_valid_33
  · exact k11_auxiliary_valid_34
  · exact k11_auxiliary_valid_35
  · exact k11_auxiliary_valid_36
  · exact k11_auxiliary_valid_37
  · exact k11_auxiliary_valid_38
  · exact k11_auxiliary_valid_39
  · exact k11_auxiliary_valid_40
  · exact k11_auxiliary_valid_41
  · exact k11_auxiliary_valid_42
  · exact k11_auxiliary_valid_43
  · exact k11_auxiliary_valid_44
  · exact k11_auxiliary_valid_45
  · exact k11_auxiliary_valid_46
  · exact k11_auxiliary_valid_47
  · exact k11_auxiliary_valid_48
  · exact k11_auxiliary_valid_49
  · exact k11_auxiliary_valid_50
  · exact k11_auxiliary_valid_51
  · exact k11_auxiliary_valid_52
  · exact k11_auxiliary_valid_53
  · exact k11_auxiliary_valid_54
  · exact k11_auxiliary_valid_55
  · exact k11_auxiliary_valid_56
  · exact k11_auxiliary_valid_57
  · exact k11_auxiliary_valid_58
  · exact k11_auxiliary_valid_59
  · exact k11_auxiliary_valid_60
  · exact k11_auxiliary_valid_61
  · exact k11_auxiliary_valid_62
  · exact k11_auxiliary_valid_63
  · exact k11_auxiliary_valid_64
  · exact k11_auxiliary_valid_65
  · exact k11_auxiliary_valid_66
  · exact k11_auxiliary_valid_67
  · exact k11_auxiliary_valid_68
  · exact k11_auxiliary_valid_69
  · exact k11_auxiliary_valid_70
  · exact k11_auxiliary_valid_71
  · exact k11_auxiliary_valid_72
  · exact k11_auxiliary_valid_73
  · exact k11_auxiliary_valid_74
  · exact k11_auxiliary_valid_75
  · exact k11_auxiliary_valid_76
  · exact k11_auxiliary_valid_77
  · exact k11_auxiliary_valid_78
  · exact k11_auxiliary_valid_79
  · exact k11_auxiliary_valid_80
  · exact k11_auxiliary_valid_81
  · exact k11_auxiliary_valid_82
  · exact k11_auxiliary_valid_83
  · exact k11_auxiliary_valid_84
  · exact k11_auxiliary_valid_85
  · exact k11_auxiliary_valid_86
  · exact k11_auxiliary_valid_87
  · exact k11_auxiliary_valid_88
  · exact k11_auxiliary_valid_89
  · exact k11_auxiliary_valid_90
  · exact k11_auxiliary_valid_91
  · exact k11_auxiliary_valid_92
  · exact k11_auxiliary_valid_93
  · exact k11_auxiliary_valid_94
  · exact k11_auxiliary_valid_95
  · exact k11_auxiliary_valid_96
  · exact k11_auxiliary_valid_97
  · exact k11_auxiliary_valid_98
  · exact k11_auxiliary_valid_99
  · exact k11_auxiliary_valid_100
  · exact k11_auxiliary_valid_101
  · exact k11_auxiliary_valid_102
  · exact k11_auxiliary_valid_103
  · exact k11_auxiliary_valid_104
  · exact k11_auxiliary_valid_105
  · exact k11_auxiliary_valid_106
  · exact k11_auxiliary_valid_107
  · exact k11_auxiliary_valid_108
  · exact k11_auxiliary_valid_109
  · exact k11_auxiliary_valid_110
  · exact k11_auxiliary_valid_111
  · exact k11_auxiliary_valid_112
  · exact k11_auxiliary_valid_113
  · exact k11_auxiliary_valid_114
  · exact k11_auxiliary_valid_115
  · exact k11_auxiliary_valid_116
  · exact k11_auxiliary_valid_117
  · exact k11_auxiliary_valid_118
  · exact k11_auxiliary_valid_119
  · exact k11_auxiliary_valid_120
  · exact k11_auxiliary_valid_121
  · exact k11_auxiliary_valid_122
  · exact k11_auxiliary_valid_123
  · exact k11_auxiliary_valid_124
  · exact k11_auxiliary_valid_125
  · exact k11_auxiliary_valid_126
  · exact k11_auxiliary_valid_127
  · exact k11_auxiliary_valid_128
  · exact k11_auxiliary_valid_129
  · exact k11_auxiliary_valid_130
  · exact k11_auxiliary_valid_131
  · exact k11_auxiliary_valid_132
  · exact k11_auxiliary_valid_133
  · exact k11_auxiliary_valid_134
  · exact k11_auxiliary_valid_135
  · exact k11_auxiliary_valid_136
  · exact k11_auxiliary_valid_137
  · exact k11_auxiliary_valid_138
  · exact k11_auxiliary_valid_139
  · exact k11_auxiliary_valid_140
  · exact k11_auxiliary_valid_141
  · exact k11_auxiliary_valid_142
  · exact k11_auxiliary_valid_143
  · exact k11_auxiliary_valid_144
  · exact k11_auxiliary_valid_145
  · exact k11_auxiliary_valid_146
  · exact k11_auxiliary_valid_147
  · exact k11_auxiliary_valid_148
  · exact k11_auxiliary_valid_149
  · exact k11_auxiliary_valid_150
  · exact k11_auxiliary_valid_151
  · exact k11_auxiliary_valid_152
  · exact k11_auxiliary_valid_153
  · exact k11_auxiliary_valid_154
  · exact k11_auxiliary_valid_155
  · exact k11_auxiliary_valid_156
  · exact k11_auxiliary_valid_157
  · exact k11_auxiliary_valid_158
  · exact k11_auxiliary_valid_159
  · exact k11_auxiliary_valid_160
  · exact k11_auxiliary_valid_161
  · exact k11_auxiliary_valid_162
  · exact k11_auxiliary_valid_163
  · exact k11_auxiliary_valid_164
  · exact k11_auxiliary_valid_165
  · exact k11_auxiliary_valid_166
  · exact k11_auxiliary_valid_167
  · exact k11_auxiliary_valid_168
  · exact k11_auxiliary_valid_169
  · exact k11_auxiliary_valid_170
  · exact k11_auxiliary_valid_171
  · exact k11_auxiliary_valid_172
  · exact k11_auxiliary_valid_173
  · exact k11_auxiliary_valid_174
  · exact k11_auxiliary_valid_175
  · exact k11_auxiliary_valid_176
  · exact k11_auxiliary_valid_177
  · exact k11_auxiliary_valid_178
  · exact k11_auxiliary_valid_179
  · exact k11_auxiliary_valid_180
  · exact k11_auxiliary_valid_181
  · exact k11_auxiliary_valid_182
  · exact k11_auxiliary_valid_183
  · exact k11_auxiliary_valid_184
  · exact k11_auxiliary_valid_185
  · exact k11_auxiliary_valid_186
  · exact k11_auxiliary_valid_187
  · exact k11_auxiliary_valid_188
  · exact k11_auxiliary_valid_189
  · exact k11_auxiliary_valid_190
  · exact k11_auxiliary_valid_191
  · exact k11_auxiliary_valid_192
  · exact k11_auxiliary_valid_193
  · exact k11_auxiliary_valid_194
  · exact k11_auxiliary_valid_195
  · exact k11_auxiliary_valid_196
  · exact k11_auxiliary_valid_197
  · exact k11_auxiliary_valid_198
  · exact k11_auxiliary_valid_199
  · exact k11_auxiliary_valid_200
  · exact k11_auxiliary_valid_201
  · exact k11_auxiliary_valid_202
  · exact k11_auxiliary_valid_203
  · exact k11_auxiliary_valid_204
  · exact k11_auxiliary_valid_205
  · exact k11_auxiliary_valid_206
  · exact k11_auxiliary_valid_207
  · exact k11_auxiliary_valid_208
  · exact k11_auxiliary_valid_209
  · exact k11_auxiliary_valid_210
  · exact k11_auxiliary_valid_211
  · exact k11_auxiliary_valid_212
  · exact k11_auxiliary_valid_213
  · exact k11_auxiliary_valid_214
  · exact k11_auxiliary_valid_215
  · exact k11_auxiliary_valid_216
  · exact k11_auxiliary_valid_217
  · exact k11_auxiliary_valid_218
  · exact k11_auxiliary_valid_219
  · exact k11_auxiliary_valid_220
  · exact k11_auxiliary_valid_221
  · exact k11_auxiliary_valid_222
  · exact k11_auxiliary_valid_223
  · exact k11_auxiliary_valid_224
  · exact k11_auxiliary_valid_225
  · exact k11_auxiliary_valid_226
  · exact k11_auxiliary_valid_227
  · exact k11_auxiliary_valid_228
  · exact k11_auxiliary_valid_229
  · exact k11_auxiliary_valid_230
  · exact k11_auxiliary_valid_231
  · exact k11_auxiliary_valid_232
  · exact k11_auxiliary_valid_233
  · exact k11_auxiliary_valid_234
  · exact k11_auxiliary_valid_235
  · exact k11_auxiliary_valid_236
  · exact k11_auxiliary_valid_237
  · exact k11_auxiliary_valid_238
  · exact k11_auxiliary_valid_239
  · exact k11_auxiliary_valid_240
  · exact k11_auxiliary_valid_241
  · exact k11_auxiliary_valid_242

end CollatzClassical.KL2003.K11CertificateMatch
