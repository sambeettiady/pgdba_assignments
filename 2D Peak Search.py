import random as rand

#Shows wrong row number for input with less than 3 rows
def SearchPeak2D(input_list_of_lists):
    min_row_number = 0
    max_row_number = len(input_list_of_lists) - 1
    n_row = 0
    count = 1

    n_row = int((min_row_number + max_row_number + 1)/2)
    n_row_actual = n_row
    row_elements = input_list_of_lists[n_row]

    row_max_value = max(row_elements)
    row_max_column_number = row_elements.index(row_max_value)
    n_column_actual = 0
    peak_value = 0

    if n_row != max_row_number:
        if input_list_of_lists[n_row][row_max_column_number] < input_list_of_lists[n_row + 1][row_max_column_number]:
            input_list_of_lists = input_list_of_lists[n_row:]
            recur_output = SearchPeak2D(input_list_of_lists)
            n_row_actual = n_row_actual + recur_output[0]
            count = count + recur_output[3]
            n_column_actual = recur_output[1]
            peak_value = recur_output[2]
        elif input_list_of_lists[n_row][row_max_column_number] < input_list_of_lists[n_row - 1][row_max_column_number]:
            input_list_of_lists = input_list_of_lists[:n_row + 1]
            recur_output = SearchPeak2D(input_list_of_lists)
            n_row_actual = n_row_actual - recur_output[0]
            count = count + recur_output[3]
            n_column_actual = recur_output[1]
            peak_value = recur_output[2]
        else:
            n_column_actual = row_max_column_number
            peak_value = row_max_value
            print("Found a peak!")
    else:
        if input_list_of_lists[n_row][row_max_column_number] >= input_list_of_lists[n_row - 1][row_max_column_number]:
            n_column_actual = row_max_column_number
            peak_value = row_max_value
            print("Found a peak!")
        else:
            row_max_value = max(input_list_of_lists[n_row - 1])
            n_row_actual = 3
            n_column_actual = input_list_of_lists[n_row - 1].index(row_max_value)
            peak_value = row_max_value
            print("Found a peak!")
    print('Found peak at row {}, column {}, having value {} in {} steps.'.format(n_row_actual + 1,n_column_actual + 1,peak_value,count))
    return [n_row_actual,n_column_actual,peak_value,count]

input_list_of_lists = [[rand.randint(0,100) for i in range(0,8)] for j in range(0,8)]
SearchPeak2D(input_list_of_lists)
