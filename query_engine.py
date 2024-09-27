from janus_swi import query
import re

max_time_id = None
time_id = 1

def set_time_id(tid) -> None:
    global time_id
    time_id = tid

def get_time_id() -> int:
    return time_id

def increment_time_id() -> None:
    global time_id
    time_id += 1

def decrement_time_id() -> None:
    global time_id
    time_id -= 1

def set_max_time_id() -> None:
    global max_time_id
    time_ids = [value['X'] for value in query("var(X, _, _)")]
    max_time_id = max(time_ids)

def execute_global(expr: str):
    for i in range(time_id, max_time_id + 1):
        replaced_expression = __replace_variables(expr, i)
        if __evaluate(replaced_expression) == "False":
            return "False"
    return "True"     

def execute_finally(expr: str):
    for i in range(time_id, max_time_id + 1):
        replaced_expression = __replace_variables(expr, i)
        if __evaluate(replaced_expression) == "True":
            return "True"
    return "False"

# if time id is not defined, it will not return the value of the variable at the previous time id
def execute_next(expr: str):
    replaced_expression = __replace_variables(expr, time_id + 1)
    
    return __evaluate(replaced_expression)

def execute_until(expr1, expr2):
    for i in range(time_id, max_time_id + 1):
        replaced_expression1 = __replace_variables(expr1, i)
        replaced_expression2 = __replace_variables(expr2, i)
        if __evaluate(replaced_expression2) == "True":
            return "True"
        if __evaluate(replaced_expression1) == "False":
            return "False"
    return "False"

def execute_release(expr1, expr2):
    for i in range(time_id, max_time_id + 1):
        replaced_expression1 = __replace_variables(expr1, i)
        replaced_expression2 = __replace_variables(expr2, i)
        if __evaluate(replaced_expression2) == "False":
            return "False"
        if __evaluate(replaced_expression1) == "True":
            return "True"
    return "True"

def execute_weak_until(expr1, expr2):
    for i in range(time_id, max_time_id + 1):
        replaced_expression1 = __replace_variables(expr1, i)
        replaced_expression2 = __replace_variables(expr2, i)
        if __evaluate(replaced_expression2) == "True":
            return "True"
        if __evaluate(replaced_expression1) == "False":
            return "False"
    return "True"

def execute_strong_release(expr1, expr2):
    for i in range(time_id, max_time_id + 1):
        replaced_expression1 = __replace_variables(expr1, i)
        replaced_expression2 = __replace_variables(expr2, i)
        if __evaluate(replaced_expression2) == "False":
            return "False"
        if __evaluate(replaced_expression1) == "True":
            return "True"
    return "False"

def print_nested(exp):
    print(type(exp), exp)

def __evaluate(exp):
    answer = query(exp).next()
    return "True" if answer else "False"

def __replace_variables(exp, time_id):
    parsed_expression = __parse_boolean_expression(exp).split()

    for i, term in enumerate(parsed_expression):
        if term.isalpha() and term[0] != '_' and term != 'true' and term != 'false':
            try:
                parsed_expression[i] = str(__get_value(time_id, term))
                print(parsed_expression)
            except:
                print(f"ERROR: Variable {term} not found in time {time_id}")

    return " ".join(parsed_expression)

def __get_value(time_id, var_name):
    return query(f"var({time_id}, {var_name}, Y).").next()['Y']

def __parse_boolean_expression(expression):
    # TODO: Replace with parse tree
    pattern = r'(\s*>=\s*|\s*=<\s*|\s*>\s*|\s*<\s*|\s*==\s*|\s*=:=\s*|\s*=\\=\s*|\s*!=\s*|\s*,\s*|\s*_\d+\s*|\s*;\s*)'
    parts = re.split(pattern, expression)
    parts = [part.strip() for part in parts if part.strip()]
    parsed_expression = ' '.join(parts)
    
    return parsed_expression

if not max_time_id:
    set_max_time_id()

'''
temp > -1
>(temp, -1)
var(1, 'temp', V0), V0 > -1
(var(1, 'temp', V0), >(V0, -1))


global(future( temp > 15)).
global(future(_, 100<13)).

for tid in range(time_id, max_timeid + 1):
    append time id to
    evaluate(future(tid, temp> 100))
'''
