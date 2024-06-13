extends Node

var party = []

func _ready():
	party.append(load("res://AutoLoad/Warrior.tres"))
	party.append(load("res://AutoLoad/Ranger.tres"))
	party.append(load("res://AutoLoad/Healer.tres"))
	#print(party[0])
