import matplotlib.pyplot as plt
import numpy as np
from scipy.misc import derivative

#A oppervlakte
A=100
#B magnetisch veld
B=20
#ω hoeksnelheid
ω=2*np.pi

def f(t):
    return B*A*np.cos(5*ω*t)

def afgeleide(t):
    return - B*A*5*ω*np.sin(5*ω*t)

t = np.arange(0.0, 2.0, 0.02)

plt.figure()
plt.subplot(311)
# plot de flux 
plt.plot(t, f(t))

plt.ylabel('flux (Φ)')
plt.title('flux en EMK bij wisselstroom')

plt.subplot(312)
# plot de afgeleide mbv. de functie derivative
plt.plot(t, derivative(f, t, dx=0.0000001, n=1), 'r')
plt.subplot(313)
plt.xlabel('tijd (s)')
plt.ylabel('elektromotorische kracht ')
# plot de afgeleide mbv. uitgeschreven afgeleide 
plt.plot(t, afgeleide(t))
plt.show()