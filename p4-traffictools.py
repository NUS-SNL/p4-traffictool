#!/usr/bin/env python
import argparse,subprocess,sys
from os import path
import os
from time import time

parser = argparse.ArgumentParser(description="Arguments for p4-traffictools")
parser.add_argument("input_file", metavar = "input_file", help="path to the input p4 source or json description")
parser.add_argument("--std", metavar = "std", help="specify p4 standard to be used for compilation{p4-14,p4-16}" , default="p4-14")
parser.add_argument("-o", metavar = "output_dir", type=str, help="path to the output directory")
parser.add_argument("--scapy", help="generate code for Scapy",action="store_true")
parser.add_argument("--wireshark", help="generate code for Lua dissector for Wireshark",action="store_true")
parser.add_argument("--moongen", help="generate code for MoonGen",action="store_true")
parser.add_argument("--pcpp", help="generate code for PCapPlusPlus",action="store_true")
parser.add_argument("--debug", help="prints metadata to console",action="store_true")
args = parser.parse_args()

def escape_character_correction(s):
	t=""
	for i in s:
		if i==" " :
			t+="\ "
		elif i=="'" :
			t+="\'"
		elif i=='"':
			t+='\"'
		else:
			t+=i
	return t

if (path.exists(args.input_file)):
	pass
else:
	print("Input file path not found")
	parser.print_help()
	exit(1)

if (args.o == None):
	args.o = path.abspath(path.dirname(args.input_file))

args.input_file = escape_character_correction(args.input_file)
args.o = escape_character_correction(args.o)

if (args.debug):
	print (args)
	DEBUG_MODE = "-d"
else:
	DEBUG_MODE = ""

if (args.scapy or args.wireshark or args.moongen or args.wireshark) == False:
	print("Specify atleast one target")
	print("usage: p4-traffictools.py [-h] [--std std] [-o output_dir] [--scapy] [--wireshark] [--moongen] [--pcpp] [--debug] input_file")	
	exit(2)

if (path.basename(args.input_file)[-4:]=="json"):
	JSONSOURCE = escape_character_correction(path.abspath(args.input_file))
else:
	FOLDERNAME = "tempfolder_"+str(time())
	subprocess.call(["mkdir",FOLDERNAME])
	subprocess.call(["cd", FOLDERNAME])
	
	P4_SOURCE = escape_character_correction(path.abspath(args.input_file))
	print("-------------------------\nCompiling P4 source with p4_bm2_ss...")
	command_to_run = ["p4c-bm2-ss" ,"--std", args.std, "-o", "alpha.json", P4_SOURCE]
	returncode = subprocess.call(command_to_run)
	if (returncode!=0):
		print("Compilation with p4c-bm2-ss failed...trying with p4c")
		command_to_run = ["p4c" ,"-S", "--std", args.std, P4_SOURCE]
		returncode = subprocess.call(command_to_run)
		if (returncode!=0):
			print("Compilation with p4c failed.. exiting")
			exit(3)
		else:
			print("Compilation successful with p4c\n-------------------------")
	else:
		print("Compilation successful with p4c-bm2-ss\n-------------------------")

	JSONSOURCE = escape_character_correction(path.abspath(subprocess.check_output("ls *.json".split(), shell=True).split()[0]))
	subprocess.call("cd ..".split())
CURR_DIR = escape_character_correction(path.abspath(sys.argv[0]))
if (args.scapy):
	temp="mkdir -p "+ args.o+"/scapy"
	print (temp.split())
	subprocess.call(temp.split(), shell =True)
	print("Running Scapy backend script")
	subprocess.call(["python",CURR_DIR+"/src/GenTrafficScapy.py", JSONSOURCE, args.o+"/scapy",DEBUG_MODE],stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	print ("-------------------------")
if (args.moongen):
	temp="mkdir -p "+ args.o+"/moongen"
	subprocess.call(temp.split(), shell =True)
	print("Running MoonGen backend script")
	subprocess.call(["python",CURR_DIR+"/src/GenTrafficMoonGen.py", JSONSOURCE, args.o+"/moongen",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	print ("-------------------------")
if (args.pcpp):
	temp="mkdir -p "+ args.o+"/pcapplusplus"
	subprocess.call(temp.split(), shell =True)
	print("Running PCapPlusPlus backend script")
	subprocess.call(["python",CURR_DIR+"/src/DissectTrafficPcap.py", JSONSOURCE, args.o+"/pcapplusplus",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	print ("-------------------------")
if (args.wireshark):
	temp="mkdir -p "+ args.o+"/lua_dissector"
	subprocess.call(temp.split(), shell =True)
	print("Running Scapy backend script")
	subprocess.call(["python",CURR_DIR+"/src/DissectTrafficLua.py", JSONSOURCE, args.o+"/lua_dissector",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	print ("-------------------------")

subprocess.call(["rm", "-rf", FOLDERNAME], shell=True)

# if (args.scapy or args.wireshark or args.moongen or args.wireshark) == False:
# 	print("Specify atleast one target")
# 	print("usage: p4-traffictools.py [-h] [--std std] [-o output_dir] [--scapy] [--wireshark] [--moongen] [--pcpp] [--debug] input_file")	
# 	exit(2)

# if (path.basename(args.input_file)[-4:]=="json"):
# 	JSONSOURCE = path.abspath(args.input_file)
# 	print JSONSOURCE
# else:
# 	FOLDERNAME = "tempfolder_"+str(time())
# 	os.system("mkdir "+FOLDERNAME)
# 	os.system("cd "+ FOLDERNAME)
	
# 	P4_SOURCE = path.abspath(args.input_file)
# 	print("-------------------------\nCompiling P4 source with p4_bm2_ss...")
# 	command_to_run = "p4c-bm2-ss " +"--std "+ args.std+ " -o "+ "alpha.json "+ P4_SOURCE
# 	returncode = os.system(command_to_run)
# 	if (returncode!=0):
# 		print("Compilation with p4c-bm2-ss failed...trying with p4c")
# 		command_to_run = ["p4c" ,"-S", "--std", args.std, P4_SOURCE]
# 		returncode = os.system(command_to_run)
# 		if (returncode!=0):
# 			print("Compilation with p4c failed.. exiting")
# 			exit(3)
# 		else:
# 			print("Compilation successful with p4c\n-------------------------")
# 	else:
# 		print("Compilation successful with p4c-bm2-ss\n-------------------------")

# 	JSONSOURCE = path.abspath(subprocess.check_output("ls *.json".split(), shell=True).split()[0])
# 	os.system("cd ..".split())
# CURR_DIR = path.dirname(path.abspath(sys.argv[0]))
# if (args.scapy):
# 	temp="mkdir -p "+ args.o+"/scapy"
# 	print (temp.split())
# 	os.system(temp)
# 	print("Running Scapy backend script")
# 	f = ("python "+CURR_DIR+"/src/GenTrafficScapy.py"+" "+ JSONSOURCE + " " +args.o+"/scapy "+DEBUG_MODE)
# 	os.system(f)
# 	print ("-------------------------")
# if (args.moongen):
# 	temp="mkdir -p "+ args.o+"/moongen"
# 	os.system(temp.split(), shell =True)
# 	print("Running MoonGen backend script")
# 	os.system(["python",CURR_DIR+"/src/GenTrafficMoonGen.py", JSONSOURCE, args.o+"/moongen",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
# 	print ("-------------------------")
# if (args.pcpp):
# 	temp="mkdir -p "+ args.o+"/pcapplusplus"
# 	os.system(temp.split(), shell =True)
# 	print("Running PCapPlusPlus backend script")
# 	os.system(["python",CURR_DIR+"/src/DissectTrafficPcap.py", JSONSOURCE, args.o+"/pcapplusplus",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
# 	print ("-------------------------")
# if (args.wireshark):
# 	temp="mkdir -p "+ args.o+"/lua_dissector"
# 	os.system(temp.split(), shell =True)
# 	print("Running Scapy backend script")
# 	os.system(["python",CURR_DIR+"/src/DissectTrafficLua.py", JSONSOURCE, args.o+"/lua_dissector",DEBUG_MODE], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
# 	print ("-------------------------")

#os.system(["rm", "-rf", FOLDERNAME], shell=True)