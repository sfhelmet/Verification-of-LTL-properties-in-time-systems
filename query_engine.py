from janus_swi import query
import re

max_time_id = None

def set_max_time_id() -> None:
    global max_time_id
    time_ids = [value['X'] for value in query("var(X, _, _)")]
    max_time_id = max(time_ids)

def execute_global(exp: str):
    for i in range(1, max_time_id + 1):
        replaced_expression = __replace_variables(exp, i)
        if __evaluate(replaced_expression) == "False":
            return "False"
    return "True"     

def execute_finally(exp: str):
    for i in range(1, max_time_id + 1):
        replaced_expression = __replace_variables(exp, i)
        if __evaluate(replaced_expression) == "True":
            return "True"
    return "False" 

# if time id is not defined, it will return the value of the variable at the previous time id?
def execute_next(time_id, exp):
    replaced_expression = __replace_variables(exp, time_id + 1)
    
    return __evaluate(replaced_expression)

def __evaluate(exp):
    answer = query(exp).next()
    return "True" if answer else "False"

def __replace_variables(exp, time_id):
    parsed_expression = __parse_boolean_expression(exp).split()

    for i, term in enumerate(parsed_expression):
        if term.isalpha() and term[0] != '_' and term != 'true' and term != 'false':
            try:
                parsed_expression[i] = str(__get_value(time_id, term))
            except:
                print(f"ERROR: Variable {term} not found in time {time_id}")

    return " ".join(parsed_expression)

def __get_value(time_id, var_name):
    return query(f"var({time_id}, {var_name}, Y).").next()['Y']

def __parse_boolean_expression(expression):
    pattern = r'(\s*>=\s*|\s*=<\s*|\s*>\s*|\s*<\s*|\s*==\s*|\s*=:=\s*|\s*=\\=\s*|\s*!=\s*|\s*,\s*|\s*_\d+\s*|\s*;\s*)'
    parts = re.split(pattern, expression)
    parts = [part.strip() for part in parts if part.strip()]
    parsed_expression = ' '.join(parts)
    
    print(parsed_expression)
    return parsed_expression
