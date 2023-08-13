# coding: utf-8
def custom_filter(arr, L):
    import numpy as np
    new_array = np.append(arr, [L], axis=0)
    check = np.logical_or(np.any(new_array >= 10, axis=0), np.any(new_array <= 1, axis=0))
    final_array = new_array[:, np.logical_not(check)]
    if final_array.size == 0:
        return "Null"
    else:
        return final_array
