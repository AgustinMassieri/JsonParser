from pyswip import Prolog

prolog = Prolog()

prolog.consult('C:/GNU-Prolog/examples/prolog-json-master/src/JsonParser.pl')

result = list(prolog.query('json_write(json_array([json_obj([("Nombre", "India Pale Ale (IPA)"),("Graduacion alcoholica", "5-7%"), ("IBU", 93.5), ("Descripcion", "Un estilo de cerveza que se caracteriza por ser amarga, media-alta en graduacion alcoholica, lupulizada, espumosa y elaborada con maltas palidas."),("Puntaje", 9)]),json_obj([("Nombre", "American Pale Ale (APA)"),("Graduacion alcoholica", "4.5-6.2%"), ("IBU", 71), ("Descripcion", "Son cervezas de alta fermentacion con un aroma y sabor marcado a lupulos americanos, bastante alto debido al usual dry hopping. Suele tener caracteres citricos y tienen baja maltosidad. Los esteres afrutados varian de moderado a ninguno."), ("Puntaje", 6)]),json_obj([("Nombre", "Stout"),("Graduacion alcoholica", "7-8%"), ("IBU", 57.5), ("Descripcion", "Son cervezas amargas (entre 30 y 45 IBUs) y generalmente llevan toques a cafe y chocolate. Presentan poca o ninguna lupulizacion y suelen ser en general cervezas bastante secas. Salen oscuras de estar muy tostadas las maltas. Muy cremosas y agradables en el paladar."),("Puntaje", 7.5)])]), \'cervezaInfo.json\').'))
