#IMPORTS
from pyswip import Prolog

prolog = Prolog()

#----------------------------------------------------------------------------------------------
#CASE 1

#PROLOG INPUT
string = "the young boy who worked for the old man pushed and stored a big box in the large empty room after school"
stringSplited = string.split()
print("Prolog Input: ", stringSplited, "\n")

prolog.consult('C:/GNU-Prolog/TPFinalAlgoritmia/EnglishParser.pl')

#PROLOG OUTPUT
result = list(prolog.query('s(T,' + str(stringSplited) + ', []).'))
print("Prolog Output: ", result[0]["T"])

#----------------------------------------------------------------------------------------------
#CASE 2

#PROLOG INPUT
string1 = "the old woman and the old man gave the poor young man a white envelope in the shed behind the building"
stringSplited1 = string1.split()
print("\n\nProlog Input: ", stringSplited1, "\n")

prolog.consult('C:/GNU-Prolog/TPFinalAlgoritmia/EnglishParser.pl')

#PROLOG OUTPUT
result1 = list(prolog.query('s(T,' + str(stringSplited1) + ', []).'))
print("Prolog Output: ", result1[0]["T"])

#----------------------------------------------------------------------------------------------
#CASE 3

#PROLOG INPUT
string2 = "every boy quickly climbed some big tree while every girl secretly watched some boy"
stringSplited2 = string2.split()
print("\n\nProlog Input: ", stringSplited2, "\n")

prolog.consult('C:/GNU-Prolog/TPFinalAlgoritmia/EnglishParser.pl')

#PROLOG OUTPUT
result2 = list(prolog.query('s(T,' + str(stringSplited2) + ', []).'))
print("Prolog Output: ", result2[0]["T"])