extends Node

var words_01 = [
#	"\nแถวหนึ่ง",
	"\nฟหกด",
	"\n่าสว"
]

var words_02 = [
	"\nแถวสอง",
	"\nแถวสอง"
]

export var lv = 1
export var sub_lv = 1
export var num_summon = 0
export var difficulty = 0
export var enemy_killed: int = 0
export var enemy_died: int = 0
export var enemy_boss: int = 0
export var skill_stk: int = 0
export var game_timer_value: int = 0

func get_lv():
	return lv

func get_prompt(lv: int) -> String :
	var words_index
	var word
	if lv == 1 :
		words_index = randi() % words_01.size()
		word = words_01[words_index]
	if lv == 2 :
		words_index = randi() % words_02.size()
		word = words_02[words_index]
	
	return word

func get_enemy_hp(difficulty_hp: int) :
	var enemy_hp: int = 0 
	var sub_lv_fc: int = sub_lv
	if sub_lv_fc > 3 :
		sub_lv_fc = 3
	if difficulty_hp == 0 :
		enemy_hp = rand_range(1 , 2) + rand_range(1 ,int(sub_lv_fc)) 
	if difficulty_hp == 1 :
		enemy_hp = rand_range(1 , 3) + rand_range(1 ,int(sub_lv_fc)) 
	if difficulty_hp == 2 :
		enemy_hp = rand_range(2 , 4) + rand_range(1 ,int(sub_lv_fc)) 
	if difficulty_hp == 3 :
		enemy_hp = rand_range(4 , 5) + rand_range(1 ,int(sub_lv_fc)) 
	
	return enemy_hp



#ฟังก์ชั่นแปลภาษา
func tran_th(key: String):
	var key_th
	#1st
	if key == "1":
		key_th = "ๅ"
	if key == "!":
		key_th = "+"
	if key == "2":
		key_th = "/"
	if key == "@":
		key_th = "๑"
	if key == "3":
		key_th = "-"
	if key == "#":
		key_th = "๒"
	
	if key == "4":
		key_th = "ภ"
	if key == "$":
		key_th = "๓"
	if key == "5":
		key_th = "ถ"
	if key == "%":
		key_th = "๔"
	if key == "6":
		key_th = "ุ"
	if key == "^":
		key_th = "ู"
	
	if key == "7":
		key_th = "ึ"
	if key == "&":
		key_th = "฿"
	if key == "8":
		key_th = "ค"
	if key == "*":
		key_th = "๕"
	if key == "9":
		key_th = "ต"
	if key == "(":
		key_th = "๖"
	
	if key == "0":
		key_th = "จ"
	if key == ")":
		key_th = "๗"
	if key == "-":
		key_th = "ข"
	if key == "_":
		key_th = "๘"
	if key == "=":
		key_th = "ช"
	if key == "+":
		key_th = "๙"
#	2nd
	if key == "q":
		key_th = "ๆ"
	if key == "Q":
		key_th = "๐"
	if key == "w":
		key_th = "ไ"
	if key == "W":
		key_th = "\""
	if key == "e":
		key_th = "ำ"
	if key == "E":
		key_th = "ฎ"
	
	if key == "r":
		key_th = "พ"
	if key == "R":
		key_th = "ฑ"
	if key == "t":
		key_th = "ะ"
	if key == "T":
		key_th = "ธ"
	if key == "y":
		key_th = "ั"
	if key == "Y":
		key_th = "ํ"
	
	if key == "u":
		key_th = "ี"
	if key == "U":
		key_th = "๊"
	if key == "i":
		key_th = "ร"
	if key == "I":
		key_th = "ณ"
	if key == "o":
		key_th = "น"
	if key == "O":
		key_th = "ฯ"
	
	if key == "p":
		key_th = "ย"
	if key == "P":
		key_th = "ญ"
	if key == "[":
		key_th = "บ"
	if key == "{":
		key_th = "ฐ"
	if key == "]":
		key_th = "ล"
	if key == "}":
		key_th = ","
#3nd
	if key == "a":
		key_th = "ฟ"
	if key == "A":
		key_th = "ฤ"
	if key == "s":
		key_th = "ห"
	if key == "S":
		key_th = "ฆ"
	if key == "d":
		key_th = "ก"
	if key == "D":
		key_th = "ฏ"
	
	if key == "f":
		key_th = "ด"
	if key == "F":
		key_th = "โ"
	if key == "g":
		key_th = "เ"
	if key == "G":
		key_th = "ฌ"
	if key == "h":
		key_th = "้"
	if key == "H":
		key_th = "็"
	
	if key == "j":
		key_th = "่"
	if key == "J":
		key_th = "๋"
	if key == "k":
		key_th = "า"
	if key == "K":
		key_th = "ษ"
	if key == "l":
		key_th = "ส"
	if key == "L":
		key_th = "ศ"
	
	if key == ";":
		key_th = "ว"
	if key == ":":
		key_th = "ซ"
	if key == "'":
		key_th = "ง"
	if key == "\"":
		key_th = "."
	if key == "\\":
		key_th = "ฃ"
	if key == "|":
		key_th = "ฅ"
#4th
	if key == "z":
		key_th = "ผ"
	if key == "Z":
		key_th = "("
	if key == "x":
		key_th = "ป"
	if key == "X":
		key_th = ")"
	if key == "c":
		key_th = "แ"
	if key == "C":
		key_th = "ฉ"
	
	if key == "v":
		key_th = "อ"
	if key == "V":
		key_th = "ฮ"
	if key == "b":
		key_th = "ิ"
	if key == "B":
		key_th = "ฺ"
	if key == "n":
		key_th = "ื"
	if key == "N":
		key_th = "์"
	
	if key == "m":
		key_th = "ท"
	if key == "M":
		key_th = "?"
	if key == ",":
		key_th = "ม"
	if key == "<":
		key_th = "ฒ"
	if key == ".":
		key_th = "ใ"
	if key == ">":
		key_th = "ฬ"
	
	if key == "/":
		key_th = "ฝ"
	if key == "?":
		key_th = "ฦ"
	return key_th
