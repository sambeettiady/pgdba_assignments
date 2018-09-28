import math

def square_root_binsearch(number = 3,precision = 10):
    if number == 0:
        return 0,1
    else:
        minimum = 1
        maximum = float(number)
        count = 1
        accurate_value = math.sqrt(number)
        approximate_sqrt = (minimum + maximum)/2
        min_error = 9*(10**(-(precision + 2)))
        error = approximate_sqrt - accurate_value
        absolute_error = abs(error)
        print(absolute_error)
        while absolute_error > min_error:
            count += 1
            if error < 0:
                minimum = approximate_sqrt
            else:
                maximum = approximate_sqrt
            approximate_sqrt = (minimum + maximum)/2
            error = approximate_sqrt - accurate_value
            absolute_error = abs(error)
            print(absolute_error)
    return approximate_sqrt,count
    
def square_root_amgm(number = 3,precision = 10):
    if number == 0:
        return 0,1
    else:
        am = float(number)
        hm = 1/am
        count = 1
        accurate_value = math.sqrt(number)
        approximate_sqrt = (am + hm)/2
        min_error = 9*(10**(-(precision + 2)))
        absolute_error = abs(approximate_sqrt - accurate_value)
        print(absolute_error)
        while absolute_error > min_error:
            count += 1
            am = (am + hm)/2
            hm = float(number)/am
            approximate_sqrt = (am + hm)/2
            absolute_error = abs(approximate_sqrt - accurate_value)
            print(absolute_error)
    return approximate_sqrt,count

def square_root_newtonrhapson(number = 3,precision = 10):
    def fx(x,square):
        return x**2 - square
    def dfx(x):
        return 2*x
    if number == 0:
        return 0,1
    else:
        approximate_sqrt = float(1+number)/2
        count = 1
        accurate_value = math.sqrt(number)
        min_error = 9*(10**(-(precision + 2)))
        absolute_error = abs(approximate_sqrt - accurate_value)
        print(absolute_error)
        while absolute_error > min_error:
            count += 1
            approximate_sqrt = approximate_sqrt - (fx(approximate_sqrt,number)/dfx(approximate_sqrt))
            absolute_error = abs(approximate_sqrt - accurate_value)
            print(absolute_error)
    return approximate_sqrt,count

square_root_binsearch(1360000)
square_root_amgm(1360000)
square_root_newtonrhapson(1360000)
