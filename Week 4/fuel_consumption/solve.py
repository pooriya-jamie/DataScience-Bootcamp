# coding: utf-8
def solve(arr):
    import numpy as np
    import scipy.stats as stats

    means = [np.mean(country_data) for country_data in arr]

    overall_mean = np.mean(np.concatenate(arr))

    ssb = np.sum([(mean - overall_mean) ** 2 * len(country_data) for mean, country_data in zip(means, arr)])

    ssw = np.sum([np.sum((data - np.mean(data)) ** 2) for data in arr])

    num_countries = len(arr)
    total_data = np.concatenate(arr)
    total_data_count = len(total_data)

    dfb = num_countries - 1
    dfw = total_data_count - num_countries

    f_statistic = (ssb / dfb) / (ssw / dfw)

    p_value = 1 - stats.f.cdf(f_statistic, dfb, dfw)

    alpha = 0.05  
    if p_value < alpha:
        reject_null = True 
    else:
        reject_null = False 

    return (1 - p_value) * 100
