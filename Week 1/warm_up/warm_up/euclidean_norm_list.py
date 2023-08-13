# coding: utf-8
def euclidean_norm_list(my_list):
    import math
    squared_sum = 0
    for x in my_list:
        squared_sum += x**2
    euclidean_norm = math.sqrt(squared_sum)
    return euclidean_norm
