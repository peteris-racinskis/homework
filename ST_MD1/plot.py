import numpy as np
import matplotlib.pyplot as plt

def util(x1,x2):
    sections = [min(x1,x2), abs(x1-x2), min(1-x1,1-x2)]
    return max(sections) + min(sections)

def element_util(x1, x2):
    result = np.ndarray((len(x1), len(x2)))
    for i in range(len(x1)):
        for j in range(len(x2)):
            result[i][j] = util(x1[i],x2[j])
    return result

def orthomin(x,z):
    result = np.ndarray((len(x)))
    for i in range(len(x)):
        result[i] = min(z[i])
    return result

x = np.linspace(0,1,400)
y = np.linspace(0,1,400)
X,Y = np.meshgrid(x,y)
Z = element_util(x,y)
Zmin = orthomin(x,Z)

plt.plot(x,Zmin)
plt.show()
plt.contourf(X, Y, Z, 200, cmap='RdGy')
plt.colorbar()
plt.show()