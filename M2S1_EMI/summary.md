---
title: "Electromagnetic Interference in Analogue and Digital Systems"
author: Thomas Debelle
geometry: "left=1cm,right=1cm,top=2cm,bottom=2cm"
papersize: a4
date: \today
toc: true
toc-depth: 3
titlepage: true
titlepage-logo: KULlogo.pdf
template: eisvogel
subtitle: "[An Open-Source Summary](https://github.com/Tfloow/ESATSummary)"
copyright: "© 2025 Thomas Debelle. This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License."
copyright-link: "https://creativecommons.org/licenses/by-nc-sa/4.0/"
output: pdf_document
---


# Terminology

- **Electromagnetic Compatibility (EMC):** the fact that devices can work normally in the neighborhood of other. apability of a device, apparatus or system to function properly (with a pre-defined margin) in its electromagnetic environment (given in advance) without generating intolerable disturbing signals in this environment
  - **EMEmission:** emission; to disturb. within and between systems
  - **EMSusceptibility:** to be disturbed. within and between systems
  - Everything is a probability and we must take margins to ensure the proper function of a circuit.
- **Electromagnetic Interference (EMI):** the fact that device can be influenced by other. Degradation of the functioning of a device, apparatus or system as a consequence of a disturbing signal; degradation = intolerable behavior, hard to define.
  - This is more and more problematic as:
    - Density increase; speed increase
    - More broadband 
    - Small and High amplitude

This course is all about understanding the fundamental of what makes a circuit and electricity flow. We ground for safety and no current flows in GND in a household. A coaxial is not shielded ! When nothing powers it, it doesn't act as a shielding, only after we power it it will look as shielded.

General rule for disturbance and interference:

- Disturbance: signal causing the problem
- Interference: problem

One thing to always consider is to also check for possible interferences outside the working band as external phenomena happening at higher or lower frequencies can be perceived in the circuit.

## Basic Scheme

![Basic scheme](image.png)

Important to note that there is not just 1 coupling path. It can be inductive, capacitive, ... but can be also conducted through the wires !

![Common impedance coupling](image-1.png)

On top of this we can have some common impedance coupling where the length and slight different in material results in differences in the signal.

### Common mode and Differential mode

They are both important in EM but generally, we are interested in the DM as no current is going through the ground. Common mode is problematic due to its fact the signal go to ground. This could also create an unexpected path that could damage components.

### Size of a system

It is always related to the wavelength $\lambda$.

- $<\lambda/10$: Small: quasi-stationary
- $>\lambda/10$: Large: wave behavior

For the near and far-field we use:

- $<\lambda/2\pi$: near-field
- $>\lambda/2\pi$: far-field

For antenna, we must also take into account the directivity with $10\lambda$ and $2D^2/\lambda$.

Another reminder is the fact that for a signal in dB, we use $20 log(X(y))$ but if it is the power, we use $10 log(X(y)_{power})$ as it is a quadratic value.


# Coupling Mechanisms

> **Note**
>
> Physical meaning: the notions potential and voltage actually **ONLY EXIST AT DC**.

This can be proven with the basic Maxwell equation:

$$
\nabla \times E = - \frac{dB}{dt}
$$

If we are at DC, no change of rate respecting the time so $dB/dt = 0$. We also know that $\nabla \cdot \nabla \times V = 0$ by definition. This leads us to $E= - \nabla \phi$ with the $-$ as a convention so we go from high to low potential. Finally, we can transform this equation into an integral equation:

$$
\int_1^2 E dl = \phi_1 -\phi_2
$$

In the case of an AC signal where the derivate is no longer null we have:


\begin{align}
  \int \nabla \times E dS &= \int - \frac{dB}{dt} dS & \text{with } \int \nabla \times E dS &= \oint E dC \text{ the contour}\\
  \oint E dC &= \int - \frac{dB}{dt} dS & \text{with } B &= \frac{\phi}{dS}\\
  \oint E dC + \frac{d\phi }{dt} &= 0
\end{align}

In other words, the sum of the voltage drop over a closed loop is not equal to 0! This contradicts the KCL.

Which means that when we want to model any RC circuit we will find:

$$
\begin{cases}
  \oint E dC &= -V + RI\\
  \frac{d\phi}{dt} &= \frac{dLI}{dt} = L \frac{dI}{dt}
\end{cases}
$$

Where we have first the voltage drop and then the extra term cause by the loop and the creation of a surface where a magnetic flux is going through. In short, we must model a simple resistive circuit with an extra inductance to keep it correct with Maxwell equation.

![Mutual coupling](image-2.png){ width=50% }

Each pair of loop as to be modeled as a **transformer**!

## Transition between conductor and dielectric

Circuit theory is a simple first order approximation of field theory. When we have a dielectric/vacuum on top of a conductor, we know that the netto charge in conductor is null.

$$
\nabla \times H_2 = (j\omega \varepsilon_2 + \sigma_2) E_2 \text{ with } J_2 = \sigma_2 E_2  
$$

And as used before $\nabla \cdot \nabla \times V = 0$ and so the divergence of the current. Which means what comes in comes out ! The net is null.

### Transition between medium

Now, if we inspect a small loop going around the first and second medium, we can find:

$$
\int_V \nabla (j\omega \varepsilon + \sigma )E dV = \oint_S (j\omega \varepsilon + \sigma) E dS = 0
$$

There is a current flowing to the surface of the conductor that is related to the field outside the conductor:

$$
J_{2n} = \frac{\sigma_2 j \omega \varepsilon_1}{(j\omega \varepsilon_2 + \sigma_2)} E_{1n}
$$

And at DC and with a perfect conductor $(\sigma_2 \rightarrow \infty)$, we have $J_{2n} = j \omega \varepsilon_1 E_{1n}$. This appears immediately after switching it on, this charge ensures the correct voltage drop outside. And later inside, the electrical field is created for the current flow.

### Link with the term capacity

This phenomena is the same that govern the capacity in its strict definition. If we have an area $A$ at a distance $d$ from each other with a voltage potential of $V$ and permitivity of $\varepsilon$. We have:

$$
J_{2n} = j \omega \varepsilon_1 E_{1n} \longrightarrow \underbrace{AJ_{2n}}_I = j \omega \underbrace{\frac{\varepsilon_1 A}{d}}_C \overbrace{d E_{1n}}^{V}
$$

This can be applied to **any pair of conductors**, which is contrary to the current law of Kirchoff. We must model it as a RC parallel network that appears at AC.

## Combined coupling

Capacitive and inductive couplings are **first order correction**. Any one port system can be modeled with a Maclauren series:

$$
Z(\omega) = R + A_1 \omega + A_2 \omega^2 + A_3 \omega^3 + ...
$$

![Combined coupling](image-3.png){ width=70% }

Both circuits are equivalent but will have different values. We can then split-up the two networks and boom we have the same second order term by choosing wisely our split. This will lead to $L_{2R}C_{2R} = L_{2s}C_{2s}$ for an equal split.

Also, important to note that this combined coupling will change depending on the actual wiring and physical constraint which is sometimes forgotten about.

|Characteristics|Circuit theory|Reality|
|:---|---:|---:|
|Conductors|Ideal just transport current and voltage | It is a component itself with non-idealities|
|Shape and implementation|No impact, just the components matter|At higher speed shape matters a lot|
|Components|Localized, discrete|Distributed not discrete|
:Consequences of higher order phenomena

If we do not take care of this, we have lots of problem especially at higher frequencies as such effect because increasingly important. We have to switch gears and really ask ourselves what simplification does circuit theory.

- inductive coupling: make current loop as small as possible
- capacitive coupling: distance as short as possible

# Multi-conductor Transmission Lines

