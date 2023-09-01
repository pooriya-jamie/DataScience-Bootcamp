# coding: utf-8
def solve(n, m, L):
    import numpy as np
    num_mobiles = np.zeros(5555)
    
    for j in range(m):
        list = [L[int(j)] for j in num_mobiles]
        random = np.random.binomial(1, list)    
           
        for i in range(5555):

            if num_mobiles[i] > 0 and random[i] == 1:
                num_mobiles[i] -= 1
                continue

            if random[i] == 0 and num_mobiles[i] < n:
                num_mobiles[i] += 1

    return num_mobiles.mean()
