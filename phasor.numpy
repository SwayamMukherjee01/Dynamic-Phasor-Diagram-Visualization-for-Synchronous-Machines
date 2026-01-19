Code import matplotlib.pyplot as plt
import numpy as np

class SynchronousMachine:
    def _init_(self, Vt, I, pf, phi, Xs, Ra):
        self.Vt = Vt
        self.I = I
        self.Powfactor = pf
        self.phi = phi  # Calculate angle from power factor
        self.Xs = Xs
        self.Ra = Ra

    def calculate_phasors(self):
        phi_rad = np.deg2rad(self.phi) # Use the calculated angle
        Vt_re = self.Vt
        Vt_im = 0
        I_re = self.I * np.cos(-phi_rad)
        I_im = self.I * np.sin(-phi_rad)

        IRa_re = self.I * self.Ra * np.cos(-phi_rad)
        IRa_im = self.I * self.Ra * np.sin(-phi_rad)

        # Ensure IXs is orthogonal to IRa
        # IXs should be 90 degrees to IRa
        IXs_re = -IRa_im  # Adjust IXs to be orthogonal
        IXs_im = IRa_re   # Adjust IXs to be orthogonal

        Ef_re = Vt_re + IRa_re - IXs_re
        Ef_im = Vt_im + IRa_im + IXs_im

        return Vt_re, Vt_im, I_re, I_im, IXs_re, IXs_im, IRa_re, IRa_im, Ef_re, Ef_im

# Example usage
machine = SynchronousMachine(Vt=415, I=20, pf=0.799,phi=36.87, Xs=2.5, Ra=8.0)
Vt_re, Vt_im, I_re, I_im, IXs_re, IXs_im, IRa_re, IRa_im, Ef_re, Ef_im = machine.calculate_phasors()

plt.quiver(0, 0, Vt_re, Vt_im, color='b', label='Vt', scale_units='xy', scale=1)
plt.quiver(0, 0, I_re, I_im, color='c', label='I', scale_units='xy', scale=1)  # Current I
plt.quiver(0, 0, IXs_re, IXs_im, color='g', label='IXs', scale_units='xy', scale=1)
plt.quiver(0, 0, IRa_re, IRa_im, color='m', label='IRa', scale_units='xy', scale=1)
plt.quiver(Vt_re, Vt_im, Ef_re - Vt_re, Ef_im - Vt_im, color='r', label='Ef', scale_units='xy', scale=1)

plt.title('Synchronous Machine Phasor Diagram')
plt.xlabel('Real Component')
plt.ylabel('Imaginary Component')
plt.legend()
plt.grid(True)
plt.axis('equal')
plt.show()
