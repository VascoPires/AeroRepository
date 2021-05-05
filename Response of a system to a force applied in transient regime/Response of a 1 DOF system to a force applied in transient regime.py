# -*- coding: utf-8 -*-

# Response of a 1 DOF system to a force applied in transient regime

# Author: Vasco Pires, FEUP, 2021
# 
# Computes the response of a undamped system to a force applied in transient regime.

# In[header]:
    
# Import libraries 
import matplotlib.pyplot as plt 
import numpy as np 
import math


# In[function]

Tn=1 #[s] , Natural Period
wn=(1/Tn)*2*math.pi #[rad/s] , Natural Frequency
tc = 3 #Force application time

t1 = np.linspace(0, tc, 10000)
t2 = np.linspace(tc,5,10000)
a = 1/(wn*tc)

#While the Force is being applied: 0<t<tc
def f1(t1):
    return (a*(wn*t1-np.sin(wn*t1)))

#The force is no longer applied: t>tc
def f2(t2):
    return (a*(np.sin(wn*(t2-tc)) + wn*tc*np.cos(wn*(t2-tc)) - np.sin(wn*t2)))
            

# Create the figure and the line that we will manipulate
fig, ax = plt.subplots()
line1, = plt.plot(t1,f1(t1), lw=2)


line2, = plt.plot(t2,f2(t2), lw=2)

ax.set_xlabel(r'$t(s)$')
ax.set_ylabel(r'$\frac{x(t)}{F_0/k}$', fontsize=14)


axcolor = 'lightgoldenrodyellow'
ax.margins(x=0)
ax.grid(True)
ax.grid(color='black', lw = 0.25)

# ax.invert_yaxis()


# Add Text watermark 
fig.text(0.88, 0.9, 'Made using python - Vasco Pires',  
         fontsize = 10, color ='black', 
         ha ='right', va ='bottom',  
         alpha = 0.7)

plt.show()