# coding: utf-8
def integral(f, a, b, error_tolerance=0.05):
    n = 1  
    integral_prev = 0
    integral_curr = (f(a) + f(b)) * (b - a) / 2
    
    while abs(integral_curr - integral_prev) > error_tolerance:
        n *= 2
        dx = (b - a) / n
        integral_prev = integral_curr
        integral_curr = sum(f(a + i * dx) for i in range(1, n)) * dx + (f(a) + f(b)) * dx / 2
    
    return integral_curr
