# coding: utf-8
def euclidean_norm_np(mylist):
    import numpy as np
    num_array = np.array(mylist)
    norm = np.linalg.norm(num_array)
    return norm
