from janus_swi import query

def execute_global(timeId, exp: str):
    if not isinstance(timeId, int) and not timeId.upper() == timeId:
        return 'Invalid Time ID. It must be an integer.'
    
    iter = query(f"var({timeId}, X, Y).")
    
    ans = ""
    for i, x in enumerate(iter):
        if i != 0:
            ans += ";\n"
        ans += str(x)
    return ans