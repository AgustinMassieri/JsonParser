from pyswip import Prolog

prolog = Prolog()

prolog.consult('C:/GNU-Prolog/examples/prolog-json-master/src/JsonParser.pl')

prolog.query('json_write(json_array([json_obj([("Nombre", "India Pale Ale (IPA)"),("Graduacion alcoholica", "5-7%"), ("IBU", "93,5")]),json_obj([("Nombre", "American Pale Ale (APA)"),("Graduacion alcoholica", "4,5-6,2%"), ("IBU", "71")]),json_obj([("Nombre", "Stout"),("Graduacion alcoholica", "7-8%"), ("IBU", "57,5")])]), \'cervezaInfo.json\').')
