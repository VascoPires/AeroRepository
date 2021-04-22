# -*- coding: utf-8 -*-
# Calculation and graphical representation of the transmitted force of a damping device

# Author: Vasco Pires, FEUP, 2021
# 
# Computes the force of a damping device depending on the excitation frequency and damping coefficient

# In[header]:
    
# Import libraries 
import matplotlib.pyplot as plt 
import numpy as np 

from matplotlib.widgets import Slider



# In[function]

def delta(beta, xi):
    return (2*xi*beta)/(np.sqrt((1-beta**2)**2+(2*xi*beta)**2))

beta = np.linspace(0, 6, 10000)

# Define initial parameters
init_xi = 0.14


# Create the figure and the line that we will manipulate
fig, ax = plt.subplots()
line, = plt.plot(beta, delta(beta, init_xi), lw=2)
ax.set_xlabel(r'$\beta=\frac{\omega}{\omega_m}$')
ax.set_ylabel(r'$\Delta(\beta,\xi)$')

axcolor = 'lightgoldenrodyellow'
ax.margins(x=0)
ax.grid(True)
ax.grid(color='black', lw = 0.25)

fig.text(0.5, 0.9, r'$F_c = F_{eq} \Delta(\xi,\beta)$',  
         fontsize = 14, color ='black', 
         ha ='left', va ='bottom',  
         alpha = 0.7)

# Add Text watermark 
fig.text(0.88, 0.25, 'Made using python - Vasco Pires',  
         fontsize = 10, color ='black', 
         ha ='right', va ='bottom',  
         alpha = 0.7)

# adjust the main plot to make room for the sliders
plt.subplots_adjust(left=0.25, bottom=0.25)

# Make a horizontal slider to control the frequency.
axbeta = plt.axes([0.25, 0.1, 0.65, 0.03], facecolor=axcolor)
xi_slider = Slider(
    ax=axbeta,
    label=r'$Damping \; Ratio \; (\xi)$',
    valmin=0.1,
    valmax=3,
    valinit=init_xi,
)

# The function to be called anytime a slider's value changes
def update(val):
    line.set_ydata(delta(beta, xi_slider.val))
    fig.canvas.draw_idle()


# register the update function with each slider
xi_slider.on_changed(update)

plt.show()
