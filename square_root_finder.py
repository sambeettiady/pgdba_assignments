import math

def square_root_binsearch(number = 3,precision = 9*(10**(-11))):
    minimum = float(1)
    maximum = float(number)
    
    accurate_value = math.sqrt(number)
    approximate_sqrt = (minimum + maximum)/2
    
    error = approximate_sqrt - accurate_value
    absolute_error = abs(error)
    
    while absolute_error > precision:
        approximate_sqrt = (minimum + maximum)/2
        error = approximate_sqrt - accurate_value
        absolute_error = abs(error)
        if error < 0:
            minimum = approximate_sqrt
        else:
            maximum = approximate_sqrt
    
    return approximate_sqrt
    
square_root_binsearch(4)

def square_root_amgm(number = 3,precision = 9*(10**(-11))):
    minimum = 
    maximum = float((1 + number)/2)
    
    accurate_value = math.sqrt(number)
    approximate_sqrt = (minimum + maximum)/2
    
    error = approximate_sqrt - accurate_value
    absolute_error = abs(error)
    
    while absolute_error > precision:
        approximate_sqrt = (minimum + maximum)/2
        error = approximate_sqrt - accurate_value
        absolute_error = abs(error)
        if error < 0:
            minimum = approximate_sqrt
        else:
            maximum = approximate_sqrt
    
    return approximate_sqrt
