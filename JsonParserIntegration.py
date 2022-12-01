#IMPORTS
from pyswip import Prolog
import json

prolog = Prolog()

prolog.consult('load.pl')
prolog.query('[load].')
prolog.query('json_load_project_modules.')

prolog.consult('./src/json.pl')

#APPLYING PROLOG PROGRAM
result1 = list(prolog.query('json:term_json(json([hello-42]), Json).'))
print('Prolog Output: ', result1[0]["Json"], '\n')

#APPLYING JSON LIB
string = '{\"hello\":42}'
json_object = json.loads(string)
print('Using JSON lib: ', json_object)

#APPLYING PROLOG PROGRAM
result2 = list(prolog.query('json:term_json(json([nodo1-valor1, nodo2-valor2]), Json).'))
print('\n\nProlog Output: ', result2[0]["Json"], '\n')

#APPLYING JSON LIB
string1 = '{\"nodo1\":\"valor1\", \"nodo2\":\"valor2\"}'
json_object1 = json.loads(string1)
print('Using JSON lib: ', json_object1)