#Define 1-Dimensional Peak Finding - Linear Search Function
def LinSearchPeak1D(input_list = [1,2,3,4,5]):

    #Get length of input list
    length_of_input = len(input_list)

    #Initial value for index
    n = 0

    #Initial value for counter variable
    count = 0
    
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
    print("The algorithm found the result in {} steps. The peak value is {}, at position {}.".format(count,peak_value,peak_index + 1))
        
#Run 1-D Peak Finding Linear Search Algorithm
LinSearchPeak1D(range(1,100000))

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
    print("The algorithm found the result in {} steps. The peak value is {}, at position {}.".format(count,peak_value,peak_index + 1))

#Run 1-D Peak Finding Binary Search Algorithm
BinSearchPeak1D(range(1,129))


#1D peak finder - Binary Search - Checks for a peak first:
def BinSearchPeak1D(input_list = [1,2,3,4,5]):
    #Get length of input list
    length_of_input = len(input_list)
    
    #Set minimum index to search
    min_index = 0
    
    #Set maximum index to search
    max_index = length_of_input - 1
    
    #Set initial value of counter variable
    count = 0
    
    #While loop starts
    while max_index >= min_index:
        #Check if length is even or odd and set index to check peak for
        if (min_index + max_index)%2 == 1:
            n = (min_index + max_index + 1)/2
        else:
            n = (min_index + max_index)/2
            
        #Increase counter variable by 1
        count += 1

        #Check if given index is the peak, else assign new values to min or max indices
        if n == 0:
            peak_index = n
            peak_value = input_list[n]
            break
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
                #Set new minimum or maximum index
                if input_list[n + 1] >= input_list[n - 1]:
                    min_index = n + 1
                else:
                    max_index = n - 1
                continue
    print("The algorithm found the result in {} steps. The peak value is {}, at position {}.".format(count,peak_value,peak_index + 1))

#Run 1-D Peak Finding Binary Search Algorithm
BinSearchPeak1D(range(1,10))

#Avg. Time for each function to execute 
%timeit LinSearchPeak1D(range(1,1000000))
%timeit BinSearchPeak1D(range(1,1000000))

