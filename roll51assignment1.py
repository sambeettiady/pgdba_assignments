import pandas as pd
import random as rd

#1-Dimensional Peak Finder - Linear Search
def LinSearchPeak1D(input_list = [1,2,3,4,5]):

    #Get length of input list
    length_of_input = len(input_list)

    #Initial value for index
    n = 0

    #Initial value for counter variable
    count = 0
    if length_of_input == 1:
        return [1,input_list[0]]
    else:
        #While loop starts
        while n <= length_of_input-1:
            
            #Increase counter variable by 1
            count += 1
            
            #Check if given index is the peak, else increase index by 1
            if n == 0:
                if input_list[n] >= input_list[n+1]:
                    peak_index = n
                    peak_value = input_list[n]
                    break
                else:
                    n += 1
                    continue
            elif n == length_of_input - 1:
                peak_index = n
                peak_value = input_list[n]
                break
            else:
                if (input_list[n] >= input_list[n-1]) & (input_list[n] >= input_list[n+1]):
                    peak_index = n
                    peak_value = input_list[n]
                    break
                else:
                    #Increase index to check by 1
                    n += 1
                    continue
    return count,peak_value
        
#1D peak finder - Binary Search:
def BinSearchPeak1D(input_list = [1,2,3,4,5]):
    #Get length of input list
    length_of_input = len(input_list)
    
    #Set minimum index to search
    min_index = 0
    
    #Set maximum index to search
    max_index = length_of_input - 1
    
    #Set initial value of counter variable
    count = 0
    
    if length_of_input == 1:
        return [1,input_list[0]]
    else:
        #While loop starts
        while max_index >= min_index:
            #Check if length is even or odd and set index to check peak for
            if (min_index + max_index)%2 == 1:
                n = (min_index + max_index + 1)/2
            else:
                n = (min_index + max_index)/2
                
            #Increase counter variable by 1
            count += 1
            
            #Set new minimum or maximum index
            if (n != 0) and (n != length_of_input - 1):
                if (input_list[n + 1] > input_list[n]):
                    min_index = n + 1
                elif input_list[n - 1] > input_list[n]:
                    max_index = n - 1
                else:
                    peak_index = n
                    peak_value = input_list[n]
                    break
            else:
                peak_index = n
                peak_value = input_list[n]
                break
    return count,peak_value

#2-D peak finder - n*log2n complexity
def SearchPeak2D(input_list_of_lists):
    min_row_number = 0
    max_row_number = len(input_list_of_lists) - 1
    n_row = 0
    count = 1

    n_row = int((min_row_number + max_row_number + 1)/2)
    row_elements = input_list_of_lists[n_row]

    row_max_value = max(row_elements)
    row_max_column_number = row_elements.index(row_max_value)
    peak_value = 0

    if n_row != max_row_number:
        if input_list_of_lists[n_row][row_max_column_number] < input_list_of_lists[n_row + 1][row_max_column_number]:
            input_list_of_lists = input_list_of_lists[n_row:]
            recur_output = SearchPeak2D(input_list_of_lists)
            count = count + recur_output[0]
            peak_value = recur_output[1]
        elif input_list_of_lists[n_row][row_max_column_number] < input_list_of_lists[n_row - 1][row_max_column_number]:
            input_list_of_lists = input_list_of_lists[:n_row + 1]
            recur_output = SearchPeak2D(input_list_of_lists)
            count = count + recur_output[0]
            peak_value = recur_output[1]
        else:
            peak_value = row_max_value
    else:
        if input_list_of_lists[n_row][row_max_column_number] >= input_list_of_lists[n_row - 1][row_max_column_number]:
            peak_value = row_max_value
        else:
            peak_value = max(input_list_of_lists[n_row - 1])
    return count,peak_value

#Problem - 1
#1-D peak finding runtimes
runtime_1d = pd.DataFrame()
list_of_lengths = [1,10,100,1000,10000,100000,1000000]
for list_size in list_of_lengths:
    print list_size
    list_lin = []
    list_bin = []
    for run in range(0,1000):
        print run
        random_list = [rd.randint(-999,999) for index in range(0,list_size)]
        linear_runtime = LinSearchPeak1D(random_list)
        binary_runtime = BinSearchPeak1D(random_list)
        list_lin.append(linear_runtime[0])
        list_bin.append(binary_runtime[0])
    runtime_1d['runtime_lin_' + str(list_size)] = pd.Series(list_lin)
    runtime_1d['runtime_bin_' + str(list_size)] = pd.Series(list_bin)
runtime_1d.to_csv('1d_runtime.csv',index=False)

#Problem - 2
#2-D peak finding runtimes
runtime_2d = pd.DataFrame()
list_of_lengths = [1,10,100,1000,10000]
for list_size in list_of_lengths:
    print list_size
    list_2d = []
    for run in range(0,1000):
        if run in [1,100,200,300,400,500,600,700,800,900]:
            print run
        random_list = [[rd.randint(-999,999) for column in range(0,list_size)] for row in range(0,list_size) ]
        peak_search_2d = SearchPeak2D(random_list)
        list_2d.append(peak_search_2d[0])
    runtime_2d['runtime_2d_' + str(list_size)] = pd.Series(list_2d)
runtime_2d.to_csv('2d_runtime.csv',index=False)

#Problem - 3
#Binary Search square root finder
def BinarySquareRoot(number = 3,initial_guess = 1,max_iterations = 50,tolerance = 10**(-10)):
    if number <= 0:
        print 'Please input a positive number!'
        return None
    elif initial_guess < 0:
        print 'Please input a positive initial guess!'
        return None
    else:
        x0 = float(initial_guess)
        approx_square_root_list = []
        relative_error_list = []
        if x0**2 < number:
            minimum = x0
            maximum = float(number)
        elif x0**2 > number:
            minimum = float(1)
            maximum = x0
        else:
            print 'Great guess!'
            return [[x0],[0]]
        for each_iteration in range(0,max_iterations):
            x1 = (minimum + maximum)/2
            approx_square_root_list.append(x1)
            relative_error = abs((x1 - x0)/x1)
            relative_error_list.append(relative_error)
            if relative_error < tolerance:
                break
            else:
                if x1**2 < number:
                    minimum = x1
                else:
                    maximum = x1
                x0 = x1
    return [approx_square_root_list,relative_error_list]

#Newton Raphson square root finder
def NewtonSquareRoot(number = 3,initial_guess = 1,max_iterations = 10,tolerance = 10**(-10)):
    def fx(x,square):
        return x**2 - square
    def dfx(x):
        return 2*x
    if number <= 0:
        print 'Please input a positive number!'
        return None
    elif initial_guess < 0:
        print 'Please input a positive initial guess!'
        return None
    else:
        x0 = float(initial_guess)
        if x0**2 == 3:
            return [[x0],[0]]
        else:
            approx_square_root_list = []
            relative_error_list = []
            for each_iteration in range(0,max_iterations):
                x1 = x0 - (fx(x0,number)/dfx(x0))
                approx_square_root_list.append(x1)
                relative_error = abs((x1 - x0)/x1)
                relative_error_list.append(relative_error)
                if relative_error < tolerance:
                    break
                else:
                    x0 = x1
    return [approx_square_root_list,relative_error_list]

output_binary = BinarySquareRoot(0,4,50)
output_newton = NewtonSquareRoot(0,4,20)

#User definable function and it's derivative
def function(x):
    return (x**3) + 2*(x**2) + 5*x + 10
def derivative(x):
    return 3*(x**2) + 4*x + 5

#Problem - 4
#Generic Newton Raphson Method
def NewtonFindRoot(function_name = function,derivative_name = derivative,initial_guess = 1,max_iterations = 20,tolerance = 10**(-10)):
    x0 = float(initial_guess)
    approx_root_list = []
    relative_error_list = []
    try:
        for each_iteration in range(0,max_iterations):
            x1 = x0 - (function_name(x0)/derivative_name(x0))
            approx_root_list.append(x1)
            relative_error = abs((x1 - x0)/x1)
            relative_error_list.append(relative_error)
            if relative_error < tolerance:
                break
            else:
                x0 = x1
    except:
        print 'Could not find roots for the given function!'
        return [None,None]
    return [approx_root_list,relative_error_list]

output_generic_newton = NewtonFindRoot(function_name=function,derivative_name=derivative)

#Problem 5
#Secant Method
def SecantFindRoot(function_name = function,initial_guess_1 = 0,initial_guess_2 = 1,max_iterations = 10,tolerance = 10**(-10)):
    x0 = float(initial_guess_1)
    x1 = float(initial_guess_2)
    approx_root_list = []
    relative_error_list = []
    if function_name(x0)*function_name(x1) > 0:
        print 'Warning: Guesses are not on the opposite side of the root! Algorithm might not converge!'
    try:
        for each_iteration in range(0,max_iterations):
            xnew = x1 - function_name(x1)*(x1 - x0)/(function_name(x1) - function_name(x0))
            approx_root_list.append(xnew)
            relative_error = abs((xnew - x1)/xnew)
            relative_error_list.append(relative_error)
            if relative_error < tolerance:
                break
            else:
                x0 = x1
                x1 = xnew
    except:
        print 'Could not find roots for the given function!'
        return [None,None]
    return [approx_root_list,relative_error_list]
    
output_secant = SecantFindRoot(function_name=function,initial_guess_1=-3,initial_guess_2=1)

