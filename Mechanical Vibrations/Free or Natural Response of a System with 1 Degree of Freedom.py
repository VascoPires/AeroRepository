# -*- coding: utf-8 -*-

# # Free or natural response of a 1 DOF system

# Author: Vasco Pires, FEUP, 2021
# 
# Computes the free or natural response of system with 1 DOF knowing the mechanical properties and initial conditions of

# In[header]:
    
# Import libraries 
import matplotlib.pyplot as plt 
import numpy as np 

import math
from math import sqrt
from math import atan
from numpy import cos
from numpy import exp
from numpy import cosh
from numpy import sinh


# # Inputs:

# Mechanical properties:

# In[inputs]:

# # Inputs:
"Mechanical properties:"

meq=0.03585 #Insert equivalent mass
keq=90.0917 #Insert equivalent rigidity
ceq=0.5032  #Insert equivalent damping


"Initial Conditions (position and velocity)"
x0=15*(math.pi/180) #Initial Position
x0_dot=0 #Initial Velocity

# In[frequency calc]:
    
wn = sqrt(keq/meq)
xi = ceq/(2*meq*wn)
wd = wn*sqrt(1-xi**2)

t = np.linspace(0, 2, 10000) 


# In[unampeded system]:


if xi == 0:
    A = sqrt(x0**2+(x0_dot/wn)**2)
    phi = atan(x0_dot/(x0*wn))
    x = A*cos(wn*t-phi)

# In[damped system]

if xi > 0 and xi < 1:
    A = sqrt(((x0_dot+xi*wn*x0)/(wn*sqrt(1-xi**2)))**2+x0**2)
    phi = atan((x0_dot+xi*wn*x0)/(wn*sqrt(1-xi**2)*x0))
    x = A*exp(-xi*wn*t)*cos(wn*t-phi)

# In[critically damped system]

if round(xi,2) == 1.00:
    x = (x0+(x0_dot+wn*x0)*t)*exp(-wn*t)
    
# In[overdamped system]

if xi > 1:
    A1 = x0
    A2 = (xi*wn*x0 + x0_dot)/(wn*sqrt(xi**2-1))
    
    x = exp(-xi*wn*t)*(A1*cosh(wn*t*sqrt(xi**2-1))+A2*sinh(wn*t*sqrt(xi**2-1)))

# In[plot]:
    
fig = plt.figure(figsize = (10, 5)) 
# Create the plot 
plt.plot(t, x)
 
plt.xlabel('$t(s)$')
plt.ylabel('$x(t)$')
plt.title('Natural Response of the System')
plt.xlim([0,1])	

# Add Text watermark 
fig.text(0.9, 0.15, 'Made using python - Vasco Pires',  
         fontsize = 12, color ='black', 
         ha ='right', va ='bottom',  
         alpha = 0.7)

plottext = '\u03BE = %.2f' % xi


#Plot Text
fig.text(0.4, 0.70, '\u03BE = %.2f' % xi,  
         fontsize = 14, color ='black', 
         ha ='left', va ='bottom',  
         alpha = 0.7)  

fig.text(0.4, 0.65, 'dot x_0 = %.2f' % x0_dot,  
         fontsize = 14, color ='black', 
         ha ='left', va ='bottom',  
         alpha = 0.7)

fig.text(0.4, 0.60, 'x_0 = %.2f' % x0,  
         fontsize = 14, color ='black', 
         ha ='left', va ='bottom',  
         alpha = 0.7)

if xi>0 and xi <1:
    
    plt.plot(t,A*exp(-xi*wn*t), 'black')
    plt.plot(t,-A*exp(-xi*wn*t), 'black')
  
# Show the plot 
plt.show() 
