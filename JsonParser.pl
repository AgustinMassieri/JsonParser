% definición de análisis JSON:
% json_parse/2

% Caso en el que JSONAtom se da como un atom
json_parse(JSONAtom, Object) :-
    atom(JSONAtom),
    !,
    atom_codes(JSONAtom, AtomCodes),
    is_JSON(AtomCodes, Rest, Object),
    skip_space(Rest, []).

% Caso en el que JSONString se da como string
json_parse(JSONString, Object) :-
    string(JSONString),
    !,
    atom_string(JSONAtom, JSONString),
    json_parse(JSONAtom, Object).

% Caso en el que se da JSONAscii como una lista de códigos ascii
json_parse(JSONAscii, Object) :-
    is_list(JSONAscii),
    !,
    is_JSON(JSONAscii, Rest, Object),
    skip_space(Rest, []).

% definición de objeto JSON:
% is_JSON/3

% Caso en el que json es un objeto
is_JSON(AsciiList, Rest1, JSON_Obj) :-
    skip_space(AsciiList, AsciiList1),
    is_object(AsciiList1, Rest, JSON_Obj),
    skip_space(Rest, Rest1),
    !.

% Caso en el que json es un array
is_JSON(AsciiList, Rest1, JSON_Array) :-
    skip_space(AsciiList, AsciiList1),
    is_array(AsciiList1, Rest, JSON_Array),
    skip_space(Rest, Rest1),
    !.

% Definición de OBJETO:
% is_object/3

% Caso base -> json_obj está vacío
is_object([0'{| Xs], Rest, json_obj([])) :-
    skip_space(Xs, [0'} | Rest]),
    !.

% Caso recursivo -> json_obj no está vacío
is_object([0'{ | AsciiList], Rest1, json_obj(Members)) :-
    skip_space(AsciiList, AsciiList1),
    is_members(AsciiList1, [0'} | Rest], Members),
    skip_space(Rest, Rest1),
    !.

% Definición de ARRAY:
% is_array/3

% Caso base -> json_array está vacío
is_array([0'[| Xs], Rest, json_array([])) :-
    skip_space(Xs, [0'] | Rest]),
    !.

% Caso recursivo -> json_array no está vacío
is_array([0'[ | AsciiList], Rest1, json_array(Elements)) :-
    skip_space(AsciiList, AsciiList1),
    is_elements(AsciiList1, [0'] | Rest], Elements),
    skip_space(Rest, Rest1),
    !.

% Definición de ELEMENTOS:
% is_elements/3

% Caso recursivo -> hay más elementos
is_elements(AsciiList, Rest3, [Value | MoreElements]) :-
    skip_space(AsciiList, AsciiList1),
    is_value(AsciiList1, [0', | Rest], Value),
    !,
    skip_space(Rest, Rest1),
    is_elements(Rest1, Rest2, MoreElements),
    skip_space(Rest2, Rest3).

% Caso base -> solo hay un elemento
is_elements(AsciiList, Rest1, [Value]) :-
    skip_space(AsciiList, AsciiList1),
    is_value(AsciiList1, Rest, Value),
    skip_space(Rest, Rest1),
    !.

% Definición de MIEMBROS:
% is_members/3

% Caso recursivo -> hay más de un par
is_members(AsciiList, Rest3, [Pair | MoreMembers]) :-
    skip_space(AsciiList, AsciiList1),
    is_pair(AsciiList1, [0', | Rest], Pair),
    !,
    skip_space(Rest, Rest1),
    is_members(Rest1, Rest2, MoreMembers),
    skip_space(Rest2, Rest3).

% Caso base -> solo hay un par
is_members(AsciiList, Rest1, [Pair]) :-
    skip_space(AsciiList, AsciiList1),
    is_pair(AsciiList1, Rest, Pair),
    !,
    skip_space(Rest, Rest1).

% Definición de PAR:
% is_pair/3

% Caso en el que hay un par <atributo: valor>
is_pair(AsciiList, Rest3, (Attribute, Value)) :-
    skip_space(AsciiList, AsciiList1),
    is_string(AsciiList1, [0': | Rest], Attribute),
    skip_space(Rest, Rest1),
    is_value(Rest1, Rest2, Value),
    skip_space(Rest2, Rest3).

% Definición de STRING:
% is_string/3

% Caso en el que la cadena comienza y termina con
% doble comillas
is_string([0'" | AsciiList], Rest1, String) :-
    skip_chars(AsciiList, Rest, StringCodes),
    !,
    string_codes(String, StringCodes),
    skip_space(Rest, Rest1).

% Caso en el que la cadena comienza y termina con
% comillas simples
is_string([0'' | AsciiList], Rest1, String) :-
    skip_chars1(AsciiList, Rest, StringCodes),
    !,
    string_codes(String, StringCodes),
    skip_space(Rest, Rest1).

% Definición de es VALOR:
% is_value/3

% Caso en el que hay un string
is_value(AsciiList, Rest1, String) :-
    skip_space(AsciiList, AsciiList1),
    is_string(AsciiList1, Rest, String),
    !,
    skip_space(Rest, Rest1).

% Caso en el que hay un número
is_value(AsciiList, Rest1, Number) :-
    is_number(AsciiList, Rest, Number),
    skip_space(Rest, Rest1),
    !.

% Caso en el que hay un valor json
is_value(AsciiList, Rest1, JSON_Obj) :-
    is_JSON(AsciiList, Rest, JSON_Obj),
    !,
    skip_space(Rest, Rest1).

% Definición de es NUMERO:
% is_number/3

% Caso en el que hay un número de tipo float
is_number(AsciiList, Rest, Number) :-
    parse_float(AsciiList, Number, Rest),
    !.

% Caso en el que hay un número de tipo entero
is_number(AsciiList, Rest, Number) :-
    parse_int(AsciiList, Number, Rest),
    !.

%%% DEFINICIONES DE LAS FUNCIONES DE ENTRADA / SALIDA:

% definicio de la carga de JSON desde un archivo:
% json_load/2

json_load(FileName, JSON) :-
    atom(FileName),
    exists_file(FileName),
    read_file_to_string(FileName, JSON_obj, []),
    json_parse(JSON_obj, JSON).

% definicion de escritura json en archivo:
% json_write/2

json_write(JSON, FileName) :-
    atom(FileName),
    open(FileName, write, Out),
    write_JSON(JSON, Out),
    close(Out).

% definicion de escribir json en archivo:
% write_json/2

% Caso en el que hay un json_obj
write_JSON(json_obj(Members), Out) :-
    !,
    write(Out, '{'),
    write_members(Members, Out),
    write(Out, '}').

% Caso en el que hay un json_array
write_JSON(json_array(Elements), Out) :-
    !,
    write(Out, '['),
    write_elements(Elements, Out),
    write(Out, ']').

% definicion de escritura de miembros:
% write_members/2

% Caso base -> JSON vacío
write_members([], _Out) :-
    !.

% Caso base -> string : string
write_members([(Llave, Valor)], Out) :-
    string(Llave),
    string(Valor),
    !,
    writeq(Out, Llave),
    write(Out, " : "),
    writeq(Out, Valor).

% Caso base -> string : number
write_members([(Llave, Valor)], Out) :-
    string(Llave),
    number(Valor),
    !,
    writeq(Out, Llave),
    write(Out, " : "),
    writeq(Out, Valor).

% Caso base -> string : json_Obj
write_members([(Llave, json_obj(Members))], Out) :-
    string(Llave),
    !,
    writeq(Out, Llave),
    write(Out, " : "),
    write_JSON(json_obj(Members), Out).

% Caso recursivo -> string : json_Obj
write_members([(Llave, json_obj(Members)) | Members1], Out) :-
    string(Llave),
    !,
    writeq(Out, Llave),
    write(Out, " : "),
    write_JSON(json_obj(Members), Out),
    write(Out, ', '),
    write_members(Members1, Out).

% Caso base -> string : json_Array
write_members([(Llave, json_array(Elements))], Out) :-
    string(Llave),
    !,
    writeq(Out, Llave),
    write(Out, " : "),
    write_JSON(json_array(Elements), Out).

% Caso recursivo -> more than just a member
write_members([(Llave, Valor) | Members], Out) :-
    !,
    write_members([(Llave, Valor)], Out),
    write(Out, ", "),
    write_members(Members, Out).

% definicion escritura de elementos:
% write_elements/2

% Caso base: array vacío
write_elements([], _Out) :-
    !.

% Caso base: el elemento es un string
write_elements([Element], Out) :-
    string(Element),
    !,
    writeq(Out, Element).

% Caso base: el elemento es un numero
write_elements([Element], Out) :-
    number(Element),
    !,
    writeq(Out, Element).

% Caso base: el elemento es un json_obj
write_elements([json_obj(Members)], Out) :-
    !,
    write_JSON(json_obj(Members), Out).


% Caso base: el elemento es un json_array
write_elements([json_array(Elements)], Out) :-
    !,
    write_JSON(json_array(Elements), Out).

% Caso recursivo: más de un simple elemento
write_elements([Element | Elements], Out) :-
    !,
    write_elements([Element], Out),
    write(Out, ", "),
    write_elements(Elements, Out).

%%% DEFINICIONES DE LAS FUNCIONES DE AYUDA:

% skip_chars/3
% skip_chars1/3
% Este predicado salta todos los caracteres hasta el
% siguiente signo de comillas dobles

% Caso recursivo -> barra invertida y comillas dobles son consecutivas
skip_chars([0'\\, 0'" | Xs], Ris, [0'" | Rest]) :-
    !,
    skip_chars(Xs, Ris, Rest).

% Caso recursivo -> string iniciado con comillas dobles
skip_chars([X | Xs], Ris, [X | Rest]) :-
    X \= 0'",
    !,
    skip_chars(Xs, Ris, Rest).

% Caso base -> comillas dobles encontradas
skip_chars([X | Xs], Xs, []) :-
    X = 0'",
    !.

% Caso recursivo -> barra invertida y comillas simples son consecutivas
skip_chars1([0'\\, 0'' | Xs], Ris, [0'' | Rest]) :-
    !,
    skip_chars1(Xs, Ris, Rest).


% Caso recursivo -> string iniciado con comillas simples
skip_chars1([X | Xs], Ris, [X | Rest]) :-
    X \= 0'',
    !,
    skip_chars1(Xs, Ris, Rest).

% Caso base -> comillas simples encontradas
skip_chars1([X | Xs], Xs, []) :-
    X = 0'',
    !.

% definicion de omision de espacios en blanco:
% skip_space/2
% Este predicado recibe una lista, salta cada espacio
% hasta el primer carácter encontrado y devuelve la lista modificada

% Caso recursivo -> salta todos los caracteres que no son iguales a
% un espacio en blanco
skip_space([X | List], List1) :-
    char_type(X, space),
    !,
    skip_space(List, List1).

% Caso base -> ahora la lista no comienza con espacios en blanco
skip_space(List, List).

% Parse_int - definicion float:
% parse_int-float/3
% parse_int1/3
% Este predicado analiza el entero y devuelve
% todo lo que no es un número en Moreinput

% Main parse_int llama a parse_int1:

% Caso en el que el número tiene signo positivo
parse_int(List, Integer, MoreInput) :-
    skip_space(List, [0'+ | Rest]),
    !,
    parse_int1(Rest, ListNum, MoreInput),
    ListNum \= [], % it means that we haven't found a number
    number_codes(Integer, ListNum).

% Caso en el que el número tiene signo negativo
parse_int(List, Integer, MoreInput) :-
    skip_space(List, [0'- | Rest]),
    !,
    parse_int1(Rest, ListNum, MoreInput),
    ListNum \= [], % it means that we haven't found a number
    number_codes(Integer1, ListNum),
    Integer is Integer1 * (-1).
   
% Caso en el que el número es positivo pero sin el signo +
parse_int(List, Integer, MoreInput) :-
    skip_space(List, List1),
    !,
    parse_int1(List1, ListNum, MoreInput),
    ListNum \= [], % it means that we haven't found a number
    number_codes(Integer, ListNum).
    
% Caso recursivo -> cada vez que X es un dígito, es
% recogido en una lista temporal y procedemos recursivamente
% hasta que X ya no sea un dígito
parse_int1([X | Xs], [X | Acc], MoreInput) :-
    is_digit(X),
    !,
    parse_int1(Xs, Acc, MoreInput).

% Caso base -> no se encontraron más dígitos
parse_int1(MoreInput, [], MoreInput) :-
    !.

% Main parse_float llama dos veces a parse_int1
% Caso en que el número tiene signo positivo
parse_float(List, Float, MoreInput) :-
    skip_space(List, [0'+ | Rest]),
    !,
    parse_int1(Rest, IntegerCodes, [0'. | Rest1]),
    parse_int1(Rest1, DecimalCodes, MoreInput),
    IntegerCodes \= [],
    DecimalCodes \= [],
    append(IntegerCodes, [0'.], FirstPart),
    append(FirstPart, DecimalCodes, FloatCodes),
    number_codes(Float, FloatCodes).

% Caso en que el número tiene signo negativo
parse_float(List, Float, MoreInput) :-
    skip_space(List, [0'- | Rest]),
    !,
    parse_int1(Rest, IntegerCodes, [0'. | Rest1]),
    parse_int1(Rest1, DecimalCodes, MoreInput),
    IntegerCodes \= [],
    DecimalCodes \= [],
    append(IntegerCodes, [0'.], FirstPart),
    append(FirstPart, DecimalCodes, FloatCodes),
    number_codes(Float1, FloatCodes),
    Float is Float1 * (-1).
 
% Caso en que el número es positivo, pero sin el signo +
parse_float(List, Float, MoreInput) :-
    skip_space(List, List1),
    !,
    parse_int1(List1, IntegerCodes, [0'. | Rest]),
    parse_int1(Rest, DecimalCodes, MoreInput),
    IntegerCodes \= [],
    DecimalCodes \= [],
    append(IntegerCodes, [0'.], FirstPart),
    append(FirstPart, DecimalCodes, FloatCodes),
    number_codes(Float, FloatCodes).    
