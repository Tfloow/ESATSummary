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

| Characteristics          |                           Circuit theory |                                      Reality |
| :----------------------- | ---------------------------------------: | -------------------------------------------: |
| Conductors               | Ideal just transport current and voltage | It is a component itself with non-idealities |
| Shape and implementation |    No impact, just the components matter |          At higher speed shape matters a lot |
| Components               |                      Localized, discrete |                     Distributed not discrete |
:Consequences of higher order phenomena

If we do not take care of this, we have lots of problem especially at higher frequencies as such effect because increasingly important. We have to switch gears and really ask ourselves what simplification does circuit theory.

- inductive coupling: make current loop as small as possible
- capacitive coupling: distance as short as possible

# Multi-conductor Transmission Lines

This is a generalization of the two conductors case where we witness some C and L coupling between conductors of length $>> \lambda$. This could be applied to shorter wires but this theory will be equal to circuit theory but with extra work and computation.

If we look transversal, the cross section is much smaller which leads to quasi-static (quasi TEM) and so possible to introduce L and C for correction.

![L and C coupling](image-4.png){ width=50% }

If we look in telecommunication cables such as telephone line or ethernet cable, we will see twister pairs, shielding, ... this is a first hint to answer the question "how to reduce coupling". This same principle is also found in microstrip line. The strongest coupling is the horizontal one between the microstrip but also some with the ground plate.

![Transmission line equation (frequency domain)](image-5.png){ width=70% }

Each components model the effects within a TL and with the other TL. Distributed ($dx$) components determined via electrostatics and magnetostatics in cross section. On small $dx$ we could use KCL. This models is **only valid if cross-section $<<\lambda$**. (*why?*)

![More explicit model](image-6.png){ width=70% }

If we lump everything in one single vector component, we can obtain a matrix representation with:


\begin{align}
  Rdx + j\omega L dx &= Zdx & Gdx+j\omega C dx &= Y dx
\end{align}

and

$$
\begin{cases}
  \frac{dV(x)}{dx} &= -\boldsymbol{Z}I(x) \\
  \frac{dI(x)}{dx} &= -\boldsymbol{Y}V(x)
\end{cases}
$$

If the matrix becomes of dimension 1, we are in the well-known case of a transmission line. This approach is simply a generalization of it. The matrices are like:

\begin{align}
  \boldsymbol{Z} &= \begin{bmatrix}
    Z_{11} &Z_{12} & ... & Z_{1n}\\
    Z_{21} &Z_{22} & ... & Z_{2n}\\
    \vdots &\vdots & \ddots & \vdots\\
    Z_{n1} &Z_{n2} & ... & Z_{nn}\\ 
  \end{bmatrix} & \boldsymbol{Y} &= \begin{bmatrix}
    \sum_{i=1}^n Y_{1i} &-Y_{12} & ... & -Y_{1n}\\
    -Y_{21} &\sum_{i=1}^n Y_{2i} & ... & -Y_{2n}\\
    \vdots &\vdots & \ddots & \vdots\\
    -Y_{n1} &-Y_{n2} & ... & \sum_{i=1}^n Y_{ni}\\ 
  \end{bmatrix}
\end{align}

If we assume $V(x) = V^+ e^{- \gamma x}$ and $I(x) = I^+ e^{- \gamma x}$, if we use the second derivate of the equation, we get:

$$
(\gamma^2 U - ZY)V^+ = 0 \qquad (\gamma^2 U - YZ)I^+ = 0
$$

Where $U$ is the modal transformation matrix related. The solution is thus given by the eigenvalues $\gamma_i$ and the eigenmodes $V_i^+;I_i^+$. If we look at the column of the current and voltage, they each represent 1 mode-1 base of the system. The matrix is full rank so each mode is orthogonal to the others.

$$
I_m = \left[ I_{m1} \quad I_{m2} \quad ... \quad I_{mn} \right] \qquad V_m = \left[ V_{m1} \quad V_{m2} \quad ... \quad V_{mn} \right]
$$


## Characteristic impedance matrix

We can derivate the equations we found and injecting the new notation of current and voltage which yield:

$$
V_{mi} = \gamma_i^{-1} Z I_{mi} \qquad V_{mi} = \gamma_i Y^{-1} I_{mi}
$$

We can the repeat for every entry of the matrix and by sorting the terms properly for $\gamma$ which will become a diagonal matrix $[\gamma]$:

$$
V_m = (ZI_m) [\gamma]^{-1}= (Y^{-1}I_m)[\gamma] \qquad I_m = Z^{-1}I_m [\gamma]= YV_m[\gamma]^{-1}
$$

![Characteristic impedance matrix](image-7.png){width=50%}

## Crosstalk

> **Definition**
>
> Crosstalk is any phenomenon by which a signal transmitted on one circuit or channel of a transmission system creates an undesired effect in another circuit or channel. Crosstalk is usually caused by undesired capacitive, inductive, or conductive coupling from one circuit or channel to another

So if we end the multi conductor TL with the impedance matrix it can remove the crosstalk.

The main takeaway from this is that, L and C coupling are unavoidable and it is a **physical** phenomena. But cross-talk is a result of this but **can be avoided** if we are putting data on one mode only.

### Special case: homogenous

If the medium is homogeneous, like in power distribution line for example, $\gamma_i \equiv \gamma_{\text{medium}}$. This means that:

$$
Z = \gamma_{\text{medium}}^2 Y^{-1} 
$$

This yields that:

$$
j\omega L = \left( j \omega \sqrt{\mu_{\text{medium}} \varepsilon_{\text{medium}}} \right)^2 (j\omega C)^{-1} \qquad \qquad L = (\mu_{\text{medium}} \varepsilon_{\text{medium}})C^{-1}
$$

This makes matching possible as it will create a real-valued $Y_c = \sqrt{\mu_{\text{medium}} \varepsilon_{\text{medium}}}^{-1}C$. And so each components is a real valued resistor.

### Transfer impedance

This concept indicates us how signal on the outside will influence the signal inside. Basic insight is to make the cable as short as possible and the connection as good as possible to avoid excess inductive coupling.

![Transfer impedance](image-8.png){ width=50% }

#### Low frequencies

![At low frequencies](image-9.png){ width=70% }

On the left we have the sources, then the cable itself with $R_i$ and finally the load that is not active. Finally, we have the return path on the outer conductor. The extra loop at the bottom represents the common mode that is disturbing th signal, this will create a signal inside.

We have then the inner and outer loop equations. The L and M represents the self-inductance and mutual inductance between the loops. It appears due to reciprocity of Maxwell's equation and causes L coupling.

We are interested in the effects of the cable not the connections. For this, we will split the inner loop into the source, load and cable.

![Splitting of cable](image-10.png){width=60%}

#### High frequencies

Cause of the skin depth effect, an exponential decay of exterior signal will be witnessed in the outer conductor. Ideally the characteristic impedance should be $0$ if the shielding is thick enough.

But if we look inside standard commercial coax cable, we will see a *woven metal* which will allow for flexibility. This will reduce its performance as depicted here:

![Plot of the performance of various shielding](image-11.png){width=50%}

For high frequencies, the woven metal will have holes and so no skin-depth. Full copper will increase the skin-depth effect as the frequency increases. On the graph, the *mu-metal* is nickel/iron alloys with the permeability $\mu$.

# Shielding

> **Definition**
>
> Shielding = to diminish the electromagnetic field at the location of the susceptor by placing a physical barrier, in most cases consisting of a conducting material, between emitter and susceptor

We must shield from $\vec{E}$ and $\vec{H}$, those are 2 different cases. For plane wave, achieving one will achieve the other as their fields are orthogonal and their ratio equal to the medium constant. 

We can either shield a device or shield the source of disruption. A general rule is that the higher the $\sigma$, the better is the shielding. BUT, the topology can impact it drastically.

| Metal           | Conductivity - $\sigma$ | Permeability - $\mu$ |
| :-------------- | :---------------------: | :------------------: |
| Silver          |          1.05           |          1           |
| Copper          |            1            |          1           |
| Gold            |           0.7           |          1           |
| Aluminum        |          0.61           |          1           |
| Zinc            |          0.29           |          1           |
| Brass           |          0.26           |          1           |
| Nickel          |           0.2           |          1           |
| Iron            |          0.17           |         1000         |
| Tin             |          0.15           |          1           |
| Steel           |           0.1           |         1000         |
| Hypernick       |          0.06           |        80000         |
| Monel           |          0.04           |          1           |
| Mu-Metal        |          0.03           |        80000         |
| Stainless Steel |          0.02           |         1000         |
:Typical materials for shielding

## Plane waves

If we assume an infinite plane, it can be solved analytically.

![Plane wave model](image-12.png){width=60%}

The shielding effectiveness is $SE=-20 log_{10}(T_{eff})$. Demonstrated how much energy goes through the shield. 

The usual way to solve such problem is to solve the boundary value problem. Integral equation with boundary value and in this case we have tangential field equal at the interface. Moreover, to respect basic fundamental law of physics, the sum of the transmissions and reflections should be equal to 0 at the interface.

### Analytic solve

![Plane wave behavior](image-13.png){width=60%}

#### Medium 1 $z<-d$



# Shielding

> **Definition**
>
> Shielding = to diminish the electromagnetic field at the location of the susceptor by placing a physical barrier, in most cases consisting of a conducting material, between emitter and susceptor

We must shield from $\vec{E}$ and $\vec{H}$, those are 2 different cases. For plane wave, achieving one will achieve the other as their fields are orthogonal and their ratio equal to the medium constant. 

We can either shield a device or shield the source of disruption. A general rule is that the higher the $\sigma$, the better is the shielding. BUT, the topology can impact it drastically.

| Metal           | Conductivity - $\sigma$ | Permeability - $\mu$ |
| :-------------- | :---------------------: | :------------------: |
| Silver          |          1.05           |          1           |
| Copper          |            1            |          1           |
| Gold            |           0.7           |          1           |
| Aluminum        |          0.61           |          1           |
| Zinc            |          0.29           |          1           |
| Brass           |          0.26           |          1           |
| Nickel          |           0.2           |          1           |
| Iron            |          0.17           |         1000         |
| Tin             |          0.15           |          1           |
| Steel           |           0.1           |         1000         |
| Hypernick       |          0.06           |        80000         |
| Monel           |          0.04           |          1           |
| Mu-Metal        |          0.03           |        80000         |
| Stainless Steel |          0.02           |         1000         |
:Typical materials for shielding

## Plane waves

If we assume an infinite plane, it can be solved analytically.

![Plane wave model](image-12.png){width=60%}

The shielding effectiveness is $SE=-20 log_{10}(T_{eff})$. Demonstrated how much energy goes through the shield. 

The usual way to solve such problem is to solve the boundary value problem. Integral equation with boundary value and in this case we have tangential field equal at the interface. Moreover, to respect basic fundamental law of physics, the sum of the transmissions and reflections should be equal to 0 at the interface.

### Analytic solve

![Plane wave behavior](image-13.png){width=60%}

#### Medium 1 $z<-d$




# Shielding

**TODO** The other first part of the course that is still on my computer

## Shielding by general shields

Like in antenna, we are going to apply the same reflection and idea but to shield. A shield is nothing but a scatterer. This time, we don't want to create more total field but we want to reduce the electromagnetic field at a certain spot in space. The main equation that governs:

$$
J^{ind} = \sigma E^{tot} = \sigma \left( E^{inc} + E^{scatt} (J^{ind}) \right)
$$

The induced current satisfies the impedance boundary condition on the shield. We will consider a conductor with conductivity σ. For a conductor the current is proportional to the total field. The proportionality factor is the conductivity. The scattered field is only depending on the induced current flowing in the shield.

### Solution

We can see the $E^{scatt} (J^{ind})$ as a vector operator and not just as a function. This relaxes the problem and allow to write $(U - \sigma E^{scatt}) (J^{ind}) = \sigma E^{inc}$. The $U$ is the unit operator. Finally, using the inverse we can find the total electromagnetic field like this:

$$
E^{tot} = E^{inc} + \left( \frac{1}{\sigma} U - E^{scatt}\right)^{-1} E^{inc}
$$

![Further development](image-12.png){ width=50% }

Which means that for PEC, the total field is null. Which makes sense as we know PEC can make good shielding. The immediate neighborhood of the conductor can be seen as shielding.

If we move away from that conductor, the field becomes normal. But this change is depending on the **electrical size** of the shield (always expressed in $\lambda$). By combining conductor, we can find a solution using computer!

## Shielding broken down in 3 different mechanisms

By basic wave theory, we know that a wave can go through a screen (full or woven) but also *around* it using diffraction. The first one is often less impactful than the second one. An intuitive idea for this is the fact that modern base station relies on diffraction to cover all areas of a city yet our cellphones still work perfectly. In other words, diffraction reduces the signal but not enough to be considered as shielding. Thus must be taken care of. This is also an incentive to develop other methods not just the plane wave one.

> **Reading**
>
> G. A. E. Vandenbosch, “The Basic Concepts Determining Electromagnetic Shielding”, American Journal of Physics, Vol. 90, No. 9, pp. , Sep. 2022, 10.1119/5.0087295.

### Shielding by a wire

![Parallel plane wave incoming to a wire](image-13.png){width=50%}

Important note, the plane wave must be **parallel** to the wire to create an $\vec E$ difference which will result into a current in the wire. If we do it perpendicular, the effect will be close to non-existent.

We can also witness a small area behind the wire where the intensity of the field is lower. This can be seen and considered as a form of shielding (bad nonetheless).

Inside the wire, the $\vec E$ is 0 if it is a PEC and the wire acts as a **scatterer**. This problem can be analytically solved.

### Shielding by a wire grid

If we form a mesh of wire, and space them regularly at a certain distance, the effect of shielding will be better. The tighter they are ($\lambda$ wise) the better is the shielding.

![Wire grid](image-14.png){width=50%}

The last experiment has wire spaced at $\lambda / 32$ but has only a $-30dB$ shielding. This is far less than the $-100dB$ we could attain with a full screen. Also we can see the waves reflected are quasi-static (if we ignore the computer artifacts).

### Shielding by a half-plate

![Shielding by a half-plate experiments](image-15.png){width=50%}

This can be solved analytically using cylindrical coordinate. Here we are seeing parallel and perpendicular polarization hitting the plane. We have slightly different results[^1].

[^1]: The dimensions are with $k = \frac{2\pi}{\lambda}$

Another takeaway here, is the fact we can only reach $-40dB$ which is quite a high figure for shielding. This really showcases how diffraction is more important that what goes through the screen magnitude wise.

## Shields: $\vec H$ field

[comment]: <> (need to check again this part because I think I am not really getting the subtlety)

> Potential exam question:
>
> *Explain mesh of microwave + the metal pieces behind the door*
>
> Mesh has small holes which are large for light $400 - 700 nm$ but which are small for microwave lengths. Microwave operates around $0.3 - 300 GHz$ which corresponds to roughly $1m-1mm$ of $\lambda$.
>
> The metal piece around the back of the door is there to avoid small cavity to form when closing the door. If we let it open, we could have excess of waves so we need to close it with these metal pieces.

A shield is a **scatterer with loop currents**.

![Scatterer single loop](image-16.png){width=75%}

We have to add this $L$ to take into account the physical loop and respect Maxwell's equation. The 3rd equation originates from the fact we will have an incident flux and a new flux due to the loop cause by the current in it. We can then do some series expansion $\frac{j\omega L}{R + j \omega L} = \frac{1}{1+\frac{R}{j\omega L}} \approx 1 -\frac{R}{j\omega L}+...$.

$R$ and $L$ are defined by the loop and material itself. In the paper cited earlier, the professor found that this equation is $\approx 0$ for signal from $600$ Hz and more. Which means it is hard to shield against low frequencies signal.

The shielded field is the normal component of the magnetic field. Shielding magnetic field with electric conductors does not work if no loop current can flow **OR** for very low frequencies (limited conductivity).

A plate can be seen as having an infinite amount of loops so the *normal* component of the $\vec H$ can be shielded over the whole region. Same line of reasoning for a box.

![Effect of shielding with a slit](image-17.png){width=50%}

The first example is better shielded as the current loops see little to no obstacles while in the second case it's tougher to go around it.

## Shielding boxes and shielding rooms

Such box is made of very conductive material but we cannot just make a box, we must ventilate, ...

This is why we must add aperture which are often designed for a specific wavelength. In other words, for a given $\lambda$ the mesh will be seen as having small holes so not too much of this frequency and higher will go through.

But there must also be lab equipments and other connections with the other world which can create a parasitic effect like the coax effects. It can act as a scatterer (like an antenna) and introduce extra unwanted signal.

Bad connection or assembly of the box will create worse shielding. Any details count if we want to achieve significant order of magnitude like $-100 dB$.