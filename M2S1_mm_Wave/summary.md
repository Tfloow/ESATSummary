---
title: "Design of RF and mm-Wave Integrated Circuits"
author: Thomas Debelle
geometry: "left=1cm,right=1cm,top=2cm,bottom=2cm"
papersize: a4
titlepage-rule-color: 00407A
date: \today
toc: true
toc-depth: 3
titlepage: true
titlepage-logo: micas_logo_colored.pdf
template: eisvogel
subtitle: "[An Open-Source Summary](https://github.com/Tfloow/ESATSummary)"
copyright: "© Thomas Debelle. This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License."
copyright-link: "https://creativecommons.org/licenses/by-nc-sa/4.0/"
output: pdf_document
---

# Motivation

We want to go to higher frequency to transmit more and more data as per Shannon channel capacity

$$
BW\cdot \log_2 \left( 1 + \frac{S}{N} \right)
$$

## Problem 1

It was predicted that the $f_{max}$ and $f_T$ of CMOS would increase in the coming years. Sadly, this is not true as CMOS won't go much higher than 300 GHz. One of our best hope is **Si-Ge** which is a developing and promising technology for high speed application. The main drawback is the fact it doesn't scale well (factor 1000 between CMOS and Si-Ge) and it is a power hungry technology node.

Another issue with this Ge, is that the oxide is quite bad and can be dissolved just by water.

## Problem 2

Another big problem comes from fundamental EM theory. The **free-space path loss**:

$$
20 \log_{10} \frac{4 \pi f_c d}{c}
$$

The higher we go in frequency, the higher is the losses. Same with the Friis equation:


\begin{align}
    P_{\text{density}} &= \frac{P_t}{4\pi d^2} \cdot G_t\\
P_r &= P_{\text{density}} \cdot \frac{\lambda^2}{4\pi} \cdot G_r\\
\frac{P_r}{P_t} &= \left(\frac{\lambda}{4\pi d}\right)^2 \cdot G_r \cdot G_t
\end{align}

But, the gain of an antenna scales with the frequency. Which means, for the same area of a RF one, we can split it in multiple sub mmWave one.

$$
G_{\text{ant}} = \frac{4 \pi A_{ant} f_c^2}{c^2}
$$

This opens the way to *beamforming* antenna where tiny delays can steer the beam. Main issue is the energy consumption, it has currently troubles to find its way to the consumer market. Many architecture exists that try to overcome various challenges.

# mm-wave design in CMOS: Actives

## MOS transistor power gain, fT and fMAX

![Basic FoM of MOS transistor](image.png){width=70%}

A tuned amplifier can be seen as an amplifier where we have some L at the boundwire for gate and drain making it a tuned amplifier.

![Model of transistor](image-1.png){width=60%}

Good RF model have GSD contact resistor and a bulk resistance model. This can be quite cumbersome to analyze, so for this reason the second model is preferred as lots of important problems can be explained with this model.

## Gate resistance

One of the main limits of gain is this $R_G$ as it will form with $C_{gs}$ a LPF. This value must be minimized to achieve high gain. 

The gate resistance is not just 1 resistance but a combination of various resistance all modeled through $R_G$. Those values depend on the layout of the transistor.

Typically, making smaller width finger will reduce the on resistance between the drain and source but the length of the gate resistance may again increase.

![Minimizing $R_G$ by modifying width of finger](image-2.png){width=50%}

The intrinsic corner frequency $f_T$ can be calculated as:

$$
f_T = \frac{g_{m}}{2\pi (C_{gs} + C_{gd})}
\qquad\begin{cases}
    h_{21}(f) &= \frac{i_{OUT}}{i_{in}} = \frac{Y_{21} v_{in}}{Y_{111} v_{in}}\\
    |h_{21}(f_T)| = 1
\end{cases}
$$

The "*amazing*" thing about this metric is that it does not depend on the layout! It is purely a technological constant!

In reality and more advanced model, there is only a weak dependency between $f_T$ and $R_G$. The higher is the bias point, the higher is the $f_T$ until it plateau and decreases.

### Matching source and load 

The goal is to transform the impedance seen by a load or a source to increase the performances of the circuit.

#### RL Series to Parallel conversion

With $Q_L = \frac{Z_L}{R_S} = \frac{\omega L_S}{R_S}$, we can convert to parallel with:

$$
L_P = L_S(1+1/Q_L^2) \qquad R_P = R_S(1+Q_L^2)
$$

#### RC Series to Parallel conversion

With $Q_C = \frac{Z_C}{R_S} = \frac{1}{\omega C_SR_S}$, we can convert to parallel with:

$$
C_P = \frac{C_S}{1+1/Q_L^2} \qquad R_P = R_S(1+Q_L^2)
$$

#### LC-match network

If we have a $L_m$, $C_m$ matching network in parallel of a $R_L$ load, we can convert into a fully in series network with $Q_C = \frac{1}{\omega C_m R_L}$.

$$
\omega = \frac{1}{\sqrt{L_m C_m'}} \qquad R_L' = \frac{R_L}{(1+Q_C^2)}
$$

And we have now that $R_{in} = R_L'$. There will be now power loss as $P_{out} = P_{in} = \frac{v_{in}^2}{R_{in}} = \frac{v_{in}^2}{R_{L}'} = (1+Q_C^2)\frac{v_{in}^2}{R_L}$. $v_{out} \approx Q_C v_{in}$ (narrowband) passive voltage amplifier.

#### Definition: $f_{max}$

![Matching](image-3.png){width=70%}

$$
G_P = \left(\frac{g_m}{2\pi f_{\text{MAX}} \cdot C_{gs}}\right)^2 \frac{r_{ds}}{4R_G} = 1 \Rightarrow f_{\text{MAX}} = \frac{g_m}{2\pi \cdot C_{gs}} \sqrt{\frac{r_{ds}}{4R_G}}
$$

Here, $f_{MAX}$ depends on biasing and layout !

$$
f_{MAX} = f_T \cdot \sqrt{\frac{r_{ds}}{4 R_G}}
$$

### Modeling it

![Contributions of $R_G$](image-4.png){width=70%}

#### Horizontal gate resistance $R_{G,h}$

$$
R_{G,h} = \alpha \frac{W_F}{L}\rho_{sh, Sili}
$$

We have a distributed effect $\alpha$ using the sheet-resistance of the Silicide layer $\rho_{sh, Sili}$.

It would be naive to think that this resistance is constant throughout the gate, actually, the current $I_G$ will be high at the entrance of the gate and slowly decrease until reaching 0. In this case $\alpha = 1/3$.

One way to reduce this is by applying two contacts at each side. This will divide by 2 the current in each branch and each branch are 2 times smaller. So, $\alpha = 1/2 \cdot 1/2 \cdot 1/3 = 1/12$

#### Vertical gate resistance $R_{G,v}$

$$
R_{G,v} = \rho_{poly} \frac{t_{poly}}{L \cdot W_F}
$$

$L$ here is the cross-section of a gate finger and $\rho_{poly}$ is the gate resistivity poly.

#### Non-Quasi-Static (NQS) gate resistance $R_{G,NQS}$

$$
R_{G,NQS} \sim \frac{L}{W_F}
$$

It is not a "real" resistance, it appears due to charge in channel coming from the source. It models the time constant $\tau = 1/RC$ that appears due to the fact the charges must travel through the channel.

#### Multi-Finger connection resistance $R_{G,int}$

$$
R_{G,int} \sim \frac{W\cdot L}{W_F}
$$

Appears due to all the connections with each fingers.

#### Summary

| Name                               | Symbol      | Equation                                   |
| :--------------------------------- | :---------- | :----------------------------------------- |
| Horizontal gate resistance         | $R_{G,h}$   | $\alpha \frac{W_F}{L}\rho_{sh, Sili}$      |
| Vertical gate resistance           | $R_{G,v}$   | $\rho_{poly} \frac{t_{poly}}{L \cdot W_F}$ |
| NQS gate resistance                | $R_{G,NQS}$ | $\sim \frac{L}{W_F}$                       |
| Multi-Finger connection resistance | $R_{G,int}$ | $\sim \frac{W\cdot L}{W_F}$                |
:Summary of the various actor in the Gate Resistance $R_G$

To optimize it, we can find the ideal $W_F$ value. The vertical and NQS resistances are found in the `BSIM` model

The multi-finger can be found using the `PEX` model. 

The optimal $W_F$ isn't the same for every transistors. The optimum shifts as the transistor get larger. Typically, the width of a finger should get larger as the total width increase.

Surprisingly, the $f_{max}$ is also shifting as the total width increase. We see that $r_{ds}$ reduces by 10 while $R_G$ only reduces by a factor 3.7. This unequal reduction leads to a 60% reduction of $f_{max}$.

#### Layout optimization

We can focus only on the gate resistance which will add parasitic at the drain which is not too bad for our goal. We use wider trace at the gate which will increase the gate source capacitance. Luckily, this can be tuned out.

#### FinFETs

The total width is the number of fingers times the amount of fins per finger. We need fin depopulation to reduce the gate resistance.

### Interstage matching situation

This is a good way to enhance the gain by re-adjusting the impedance seen at the terminals. However, this will induce power loss and require more chip area ! The losses are proportional to the Impedance Transformation Ratio (ITR).

**Re-read this section + re-watch to fully grasp everything**

The bottom line is that matching with realistic Q factors only makes sense at higher frequencies. Higher than 20 GHz or we would have too much power loss at lower frequencies. 1:1 impedance ratio leads to a very easy matching network. This 1:1 happens at various frequencies for different technology node and size ratio.

#### Mismatch can give better output power

**Add slice example**



## Stability

The capacitance $C_{gd}$ forms a feedback between the output and input opening the door for instability issues. This limits the maximum attainable gain.

We define the term conditionally stable and unconditionally stable:

- Conditional: for some source and load impedance, the network will be unstable
- Unconditional: always stable for (any) source and load

This definition is only based on the fact that we put a network at the input and one at the output without any connections between. But, if add a voltage source between input and output we can make any unconditionally stable circuit oscillate.

### Rollett Stability Factor K

- $K>1$: unconditionally stable
- $K<1$: *potentially* unstable

$$
K = \frac{1-|S_{11}|^2 - |S_{22}|^2 + |\Delta|^2}{2|S_{21}S_{12}|} \qquad \Delta = S_{11}S_{22} - S_{21}S_{12} 
$$

#### Maximum Available Gain (MAG)

MAG provided ideal matching and $K>1$

$$
MAG = (K-\sqrt{K^2 - 1}) \cdot \frac{S_{21}}{S_{12}} = \frac{1}{K + \sqrt{K^2 - 1}} \cdot \frac{S_{21}}{S_{12}}
$$

#### Maximum Stable Gain (MSG)

To achieve stability, one way is to add loss at the input or output. If $K=1$ we have the MSG:

$$
MSG = \frac{S_{21}}{S_{12}}
$$

### Gmax in Cadence

At lower frequency, the transistor will be conditionally stable and thus the gain will be linear corresponding to the MSG. There will be a corner in the gain depending on the layout. Good layout (ideal finger width) will have a higher corner.

In this second region the MAG is the maximum gain as the transistor will be unconditionally stable.

Using the proper conjugate matching network, in the conditionally stable region, we can touch that MSG.

## Neutralization

Instead of adding losses, we could try to **tune out** the gate drain capacitance which is the reason for the feedback and instability. But, the inductance will be too large and consumes lots of chip area.

A better solution is to use a "*negative*" capacitance which will counter-act the effects of the gate drain one. In other words, use a **differential mode** approach.

![Neutralization](image-5.png){width=70%}

![Value of $C_N$](image-6.png){width=70%}

One issue with the neutralization implementation is the fact that the $C_N$ will be not only $C_{gd}$ but also other parasitic.

Ultimately, neutralization will lead to far superior Gmax.

### Implementation

Implementing neutralization is quite easy and interesting to do. We can use transformers and at the middle inject the bias voltages. The transformers will ensure the symmetrical differential mode signal. 

![Neutralization implementation](image-7.png){width=70%}

#### Neutralization with single-ended amps

![Possible solutions for single-ended amps](image-8.png){width=70%}

### Use dummy transistor

![Dummy transistors with floating source](image-9.png){width=70%}

Another way, instead of using a floating source, is to tie the drain and source together. With this technique, no current will flow as there will be no real polarity.

## Drawback of Neutralization

In DM, it is easy to analyze the stability of the circuit. We need to just check 1 frequency, the operating one. We are not really affected by the VDD and VBIAS as it is seen as a virtual ground only.

But in Common Mode, this is a whole different story. The circuit looks different, we see the bound pad inductances and we must sweep all frequencies to make sure it is always stable. Moreover, this stability depends on the impedance of the two DC voltages (VDD and VBIAS). Finally the transistor now looks twice as wide.

### CM stability

One solution is to use *harmonic traps* that will provide excess feedback:

![Harmonic traps](image-10.png){width=60%}

### CM feedback

A crucial thing is the fact that the the second order distortion is caused by the common mode ! In many research paper, this is often overlooked as this distortion will appear at $2\omega_1;2\omega_2;\omega_1+\omega_2$. So this is not close from the main frequencies. 

**BUT**, if a distorted signal is feedback at the input, it will mix and appear like a third order distortion. It is a secondary mixing terms due to the $C_{gd}$ and $C_N$ feedback network.

# System-level aspects of PAs

## Introduction

Designing a power amplifier is different than designing a regular amplifier. In a regular amplifier, we are trying to optimize the gain, so the input and output matching network will transform the impedance to be seen as $50\Omega$. In a PA, we want to send the maximum amount of power.

![PA basics 101](image-11.png){width=70%}

The total power is proportional to $V_{DD}^2$, we kept pushing down the supply to maintain $\vec E$ over the diffusion area yet we didn't see any dramatic output power reduction. Why ?

## Gain and power matching

### Gain matching

We are trying to have the highest power gain thanks to conjugate matching as load. We create a sort of high load line to have the highest output power for the given input swing and this is called matching. This is based on a small-signal approach.

### Power matching

we allow to go more extreme and this requires a large-signal approach. We are limited by the $I_{max}$ and $V_{max}$. There is also a minimum $V_{knee}$. The result is a less resistive load and more swing.

- $I_{max}$: to avoid electron migration 
- $V_{max}$: to avoid breakdown voltage
- $V_{knee}$: to stay out of the triode region

The optimal loads for maximum gain and power are **not** the same. The best we can do is take an intermediate between the power curves. The corner point in the Pin/Pout plot is sooner for power matching than gain matching.

## Ratio-gain and slope-gain

- **Power gain:** $P_{out}- P_{in}$
- **Gain compression:**  Crossing point with the linear slope of the -1 dB gain at $P_{in}=0dB$
  - This indicates the start of the compression area where the PA becomes saturated. In this area, there is high output power and good PAE.
  - Often, in those plots, we can see the curve never flattens out. This is due to the feed-forward path.
- **Saturation power:** -3dB compression power, not a convention but usually used.

A good PA will have the $P_{1dB}$ and $P_{3dB}$ close to avoid the effect of "*soft compression*" which induces low input swing due to premature distortion.

### Slope gain and ratio gain

- Slope gain: take the derivative around 0 mW of input
- Ratio gain: take the difference over X 

Slope gain will remain constant while the ratio gain will continue changing, even in compression. slope gain will tend to 0 which reflects the actual added benefit of going to higher power input.

### Predistortion curve

If we take the Pout/Pin curve and its inverse on the same plot, we will find the **PD gain**. This only appears if the slope gain is bigger than one and this point is where the ratio gain and the output power gain meets.

The issue is the fact that after this distortion point, the slope gain is almost null but not the ratio gain.

- Slope gain: better for checking predistortion

## Efficiency

| Name                              | Description                                                                                       |                        Formula                        |
| :-------------------------------- | :------------------------------------------------------------------------------------------------ | :---------------------------------------------------: |
| Drain collector efficiency **DE** | The output power over the DC power                                                                |         $\eta = \frac{P_{out,RF}}{P_{DC,PA}}$         |
| Power-added efficiency **PAE**    | Subtracting the input power to the output power. Idea closer to laser where input flows to output |   $PAE = \frac{P_{out,RF} - P_{in,RF}}{P_{DC,PA}}$    |
| System efficiency **SE**          | Overall efficiency of the system, more meaningful and reflect reality                             | $\eta_{sys} = \frac{P_{out,RF}}{P_{in,RF}+P_{DC,PA}}$ |
: Various efficiency of a Power Amplifier

$$
\textbf{PAE} = \eta \cdot \left( 1 - \frac{1}{G_P} \right)
$$

> *Note*
>
> $P_{DC,PA}$ depends in most case on $P_{out,RF}$.

When running the simulations we can see that:

- **Linear region:** 
  - Good: gain, linearity
  - Bad: output power, efficiency
- **Compressed region:**
  - Good: output power, efficiency
  - Bad: gain, linearity

### $P_{DC} \text{ } \& \text{ } P_{BIAS}$

The DC power is not equal to the bias power besides at small input and output signals. Moreover:

$$
P_{DC,PA}(P_{out,RF})
$$

The DE keeps improving due to the feed-forward path but the PAE has an optimum. 

> *Note*
>
> PSAT is sometimes defined as the output power at $\textbf{PAE}_{max}$

#### Driver stage

The DE will always refer to the drain efficiency and thus never take into account the extra power burned by a driver stage. While for other metrics:

$$
\begin{aligned}
    PAE &= \frac{P_{out,RF} - P_{in,RF}}{P_{DC,DRV} + P_{DC,PA}} & \eta_{sys} &= \frac{P_{OUT,RF}}{P_{IN,RF} + P_{DC,PA} + P_{DC,DRV}}
\end{aligned}
$$

## PAPR

Or **Peak to Average Power Ratio**, a large difference between the average and peak power gives a *low efficiency*. This is an important metric in modern communication scheme as the PAPR grows bigger and bigger as the standards advance.

### Definition in Analog and RF

| Metric        | Symbol          |      Equation      |
| :------------ | :-------------- | :----------------: |
| Crest factor  | $CF$            | $V_{max}/V_{RMS}$  |
|               | $CF_{dB}$       |   $20 \log(CF)$    |
| ???           | $PIP$           |  $V_{max}^2/R_L$   |
| Average power | $P_{avg}$       |  $V_{RMS}^2/R_L$   |
| PAPR analog   | $PAPR_{analog}$ | $PIP/P_{AVG}=CF^2$ |
| PAPR RF       | $PAPR_{RF}$     | $PEP/P_{AVG}$                    |
|               | $PAPR_{dB}$     |     $CF_{dB}$      |
: Important metrics

In RF, we modulate our signal on a carrier which creates an enveloppe. If we take the $V_{max}$ of this enveloppe and map it to a *continuous wave* with amplitude equal to the peak of the modulated signal, we obtain the **PEP**.

$$
PEP = PIP - 3 dB
$$

So when $PAPR_{RF} = 0$, it will be $PAPR_{analog} = 3$. It is just a naming convention but important to distinguish. A good thing is to only use crest factor for $PAPR_{analog}$ instead.

$$
\begin{aligned}
    PEP &= \frac{PIP_{env}}{2} & P_{AVG} &= \frac{P_{AVG,ENV}}{2} 
\end{aligned}
$$

$$
PAPR_{RF} = \frac{PEP_{RF}}{P_{AVG,RF}} = \frac{PIP_{ENV}}{P_{AVG,ENV}} = PAPR_{ENV}
$$

### Modulated signals

We can use constellations plot to represent the *amplitude and phase* of the RF carrier. But, this plot shouldn't just be viewed as a static plot but as a points that carrier will visit and where change is not instantaneous.

$$
\begin{aligned}
    s(t) &= I(t) \cos (2\pi f_c t) - Q(t) \sin (2\pi f_c t)\\
    &= A(t) \cos (2 \pi f_c t+\varphi (t))
\end{aligned}
$$

The complex envelope signal is:

$$
\begin{aligned}
    g(t) &= \overbrace{A(t)}^{\text{Envelope signal}} \overbrace{e^{j\varphi (t)}}^{\text{phase modulation}} & s(t)&=\mathfrak{R} \left\{ A(t) e^{j\varphi(t)} e^{j2\pi f_c t} \right\}
\end{aligned}
$$

The envelope signal properties will influence the PA design and performance. We have:

$$
\begin{aligned}
  A(t) &= \sqrt{I(t)^2 + Q(t)^2} & \varphi(t) &= arctan \left( \frac{Q(t)}{I(t)} \right)
\end{aligned}
$$

Modulation and filtering will cause envelope variations. If we look at a QPSK constellation where all points lay around the circle of radius 1, if we assume perfect transition between the points, we have a $PAPR = 0$. But with a $RRC = 0.35$, we have $4$dB PAPR. This is due to the transition that takes the shortest path instead of going around the circle. This is some IQ filtering that will introduce the detrimental PAPR.

For constellations that do not have all their point laying on the circle, they will have a PAPR larger than 0.

#### OFDM

If we want to take into account OFDM modulation using $N$ modulated sinewaves, we have the following formula:

$$
PAPR_{RF,dB} = PAPR_{RF} + \overbrace{10 \log (N)}^{\text{OFDM factor}}
$$

#### Signal statistics

What define the PAPR is the ratio of the largest peak over the average signal. But some average peak can be quite rare as they must me an exact sequence of bits for example.

So, it is quite common to define the **likelihood** of a waveform of X symbols to have a PAPR of Y dB. A good reference point is using $1\%$. This is shown with a Complementary Cumulative Distribution Function Plot:

![CCDF Plot](image-12.png){width=60%}

The bad news is that, the more advance is a communication scheme, the worse is the PAPR becoming.

## Distortion: ACLR

> **Definition**
>
> ACLR: Adjacent Channel Leakage Ratio
>
> ACP: Adjacent Channel Power

This section is about ACLR and how we must take into account possible leakage from other channel. Indeed, we are not operating without any noise or other user. Everyone has a specific frequency range (ideally).

This is all related to Harmonic Distortion (HD) and how third order distortion (IMD3) of 2 signals will fold back next to the two first order signal. Thus, creating some distortion as unwanted signals can be difficultly filtered out.

A spectrum shows the power, measured inside a BW equal to the Resolution Bandwidth (RBW).

![ACP and ACLR](image-13.png){ width=60% }

The shoulders are often asymmetric due to the memory effects and second order distortion. The power in the first **adjacent shoulder** is written as $P_{AC1}$. We can then extract the first ACLR:

$$
ACLR_{1 [dB]} = P_{OUT[dBm]} - P_{AC1[dBm]}
$$


## Distortion: EVM

> **Definition**
>
> EVM: Error Vector Measure

The error vector is a complex number that represents the difference in a time domain constellation IQ between the measured signal and the ideal signal.

$$
EVM = \sqrt{(I_{MEAS} - I_{REF})^2 + (Q_{MEAS} - I_{MEAS})^2}
$$

We can then measure it for each symbol transmitted and compute the RMS value of the EVM:

$$
EVM_{RMS} = \frac{\sqrt{\frac{1}{N} \sum_{i=1}^N EVM_i^2}}{\sqrt{\frac{1}{N} \sum_{i=1}^N |S_i|^2}}
$$

An interesting fact is that if we have little to no AM-AM, AM-PM noise, we will have $EVM_n \approx \frac{1}{\sqrt{SNR}}$.

### Understanding the pattern of constellation

If we don't have a nice grid square shaped pattern and rather a round shaped patterned with higher $EVM$ for signal further, this is likely a non-linear PA that saturates for higher signals.

> *Note*
>
> Always make sure to pick the root-square sum of the signals and not the max of the signal as Keysight default setting does.
>
> The difference is the PAPR of the unfiltered modulated signal. Not the PAPR of the RF signal.


## Distortion: AM/AM – AM/PM – PM/AM

### AM-AM

AM-AM is ratio gain it is the difference between the AM in minus the AM out. If we witness in a QAM constellation that the center is still square but the outside becomes round, this is typical sign of AM-AM distortion.

Cannot really be avoided as it is intrinsic of the PA.

### AM-PM

This is the fact that having a larger amplitude will create a phase change at the output. This can be avoided with better matching. Push the phase shift to higher input voltage.

AM-PM will be seen as the constellation is swirling a little bit. The full constellation is not just rotating but swirling and is more noticeable for the edges.

#### Typical causes

This is due to a changing $C_{GS}$ capacitance. This will change the resonance frequency and phase response. The root cause can also be:

- $C_{GD}$ and miller cap
- Gain compression
- Non-linear $C_{DS}$
- Non-linear $g_m$

But usually, a non-linear $C_{GS}$ is the sweetspot for amplifier.

Class A amplifier will have stronger negative output phase than class AB that will tend to be more positive output phase. Ideally we want a null output phase.

#### Compensating

We can compensate for this by inducing more gain for I instead of Q for example.

Also, a lot of systems have a precise time domain envelope that is not constant. Typically emitting data will have lots of radiation while receiving will be much smaller power-wise.

### Memory effects

The gain and phase relationships of PA depends on the previous power situation. This is caused by thermal behavior and low-frequency bias networks with large RC time constants.

A lot of decoupling capacitance will creates more memory effect as the circuit must (dis)charge more or less the caps. We must do proper sweep to see clearly those effects. 

# CMOS Passives

## Metal stacks, CMOS vs SiGe and Q-factor

For the metal part, we can use some microstrip line or coplanar line. A good model is **transmission lines** which are convenient as they are:

1. Length-scalable model
2. Current-return path is part of the model
  * no just floating around current that closes the loop somehow; this usually results in poor or unexpected behavior for simulations if not taken into account

In classic CMOS technology, we want to have our signal to run as far as possible from the substrate. We want to avoid any $\vec E$ in the lossy $SiO_2$. We usually shield metals from the substrate with a ground plane but this results into a low $Z_0 = \sqrt{\frac{L}{C}}$.

For more exotic technology such as $GaAs,InP$, the substrate as few losses so no need to shield, microstrip is preferred. The substrate is 3 times smaller than the CMOS one

### Slow-wave transmission lines

Under microstrip line signal line, we can add some floating isolated metal strips. This will increase the capacitance but not the inductance resulting into a slow wave propagation (can never be faster):

$$
v_c = \frac{1}{\sqrt{LC}} = \frac{\mu}{\varepsilon}
$$


### Lumping components

When lumping, it is harder to model the return current / closing the loop. As hinted before, this is a bad model choice.

One good choice is to use differential mode as it will have a virtual ground but the common mode is tougher to analyze.


![Evolution of the stack](image-14.png){width=70%}

![SOI (RF) and SiGe (BJT)](image-15.png){width=40%}

When looking at the speed on CMOS, it's much faster than SiGe but when adding the interconnect, it becomes worse than SiGe.

The quality due to metal resistance $Q \approx \frac{\mathcal{Im}(Z_{11})}{\mathcal{Re}(Z_{11})}$

If we assume that $R_S \approx \sqrt{\omega}$ is dominated by the skin effect. This results in:

- Inductive: $Q_L = \frac{\omega L}{R_S} \approx \sqrt{\omega}$
- Capacitive: $Q_C = \frac{1}{\omega C R_S} \approx \frac{1}{\omega \sqrt{\omega}}$

So the quality depends on the frequency.

## Capacitors

Thin metal gives worse Quality factor. To have higher density, we must go towards but will create higher resistance.

## Inductors

### Q-factors definitions

In simple model we have $Z_{11} = R_S + j\omega L_S$ with the quality factor being $Q = \frac{\mathcal{Im}(Z_{11})}{\mathcal{Re}(Z_{11})}$. It implies that the quality facto grows until it completely crumbles. This is false as it assumes that the operating frequency is much lower than the self-resonance frequency $f_{SRF}$.

In reality, close to $f_{SRF}$, the impedance goes up due to resonance. We must model the inductance with an extra parasitic capacitance. The proper way to calculate the quality factor is by using $Q = \frac{f_{res}}{\Delta f_{-3 dB}}$.

![Simple inductor model](image-16.png){width=50%}

![Simplified at high frequencies](image-17.png){width=50%}

### CM and DM behavior

## Transformers
## Transmission lines
## Shielding


\part{Exam questions}

\newpage

# List of questions

## actives

1. Explain Shannon
2. Explain Friis and FSPL
3. Why is an array needed at mm-wave frequencies?
4. Why is beamforming needed?
5. What are the main limitations of gain at mm-wave frequencies (above 20GHz)
6. What are the main limitations of gain at RF frequencies (below 20GHz)
7. How does the gate resistance scale with the number of fingers?
8. Can we do complex conjugate matching at RF frequencies?
9. How to solve stability problems at mm-wave and RF ?
10. What are the drawbacks of neutralization?

## passives

1. Explain why Q-factor of inductors improve as we go to higher frequency
2. Discuss the different ways to calculate Q of an inductor
3. Which metal layers would you use to implement inductors? Which ones to
implement capacitors?
4. Explain why a 2-turn inductor behaves very differently in common-mode than a
1-turn inductor
5. Show on a smith chart how transformer-based matching works
6. Explain the impact of coupling-cap (between primary and secondary) in a
transformer
7. Which transmission line structures perform the best in III/V and which ones in
CMOS?
8. Explain how a slow-wave transmission line works
9. Is shielding useful in single-ended structure?

## transformers

1. Compare bipolar with CMOS. Which one is better?
2. Very often, the magnetic coupling (k) of a transformer is reduced on purpose.
Why?
3. Explain the causes of imbalance in balanced transformers. Explain how to
reduce this imbalance
4. In some situations, isolating the ground between primary and secondary
winding of a transformer, helps to improve performance. Explain this effect

## PA system level

1. Explain the difference between matching for gain and matching for output power
2. Explain the difference between ratio gain and slope gain.
3. What is PAPR and what is the problem when the PAPR is high?
4. Is second-order distortion important or not?
5. What is EVM
6. What is AM-AM and what is AM-PM ?

## Receivers


1. What is the problem with the heterodyne mixing
2. Explain the tradeoff between image rejection and channel selection
3. What is homo-dyne mixing?
4. Explain sliding IF
5. Explain the basic concepts of image-rejection receivers
6. Compare Low-IF and Zero-IF
7. What is a polyphase filter?

## Transmitters

1. Discuss why we do baseband filtering and what is a Nyquist filter
2. What is PA-VCO pulling and how can we solve it?

\newpage

You can find human answered questions at this [URL](https://docs.google.com/document/d/1lEV2Qdt3hnRr6ZiOJNV0eW85YG45oVbZDZI_VzP5jhY/edit?usp=sharing).

Here is some Notebook LM based one

# Actives

## 1. Explain Shannon

Claude Shannon defined the theoretical limit of the amount of information (channel capacity) that can be transmitted over a communication channel. The "Shannon limit" is expressed by the formula:
$$C = B \cdot \log_2(1 + SNR)$$
where **C** is the channel capacity (bits/s), **B** is the bandwidth, and **SNR** is the Signal-to-Noise Ratio.

In the context of modern communications, this theorem highlights the fundamental trade-off: to increase data rates (the "Growth of bits"), one must either increase the Signal-to-Noise Ratio (which requires more power) or increase the Bandwidth (B). Since spectrum at lower RF frequencies is congested ("BW = business"), designers move to mm-wave frequencies (e.g., 28GHz, 60GHz, E-band) where vast amounts of bandwidth are available to increase capacity.

## 2. Explain Friis and FSPL

**Friis Transmission Equation:**
Harald T. Friis derived the formula for the power received by an antenna from a transmitting antenna. It describes the link budget in a free-space environment:
$$P_{rx} = P_{tx} \cdot G_{tx} \cdot G_{rx} \cdot (\frac{\lambda}{4\pi d})^2$$
where $P_{rx}$ and $P_{tx}$ are received and transmitted powers, $G$ represents antenna gains, $\lambda$ is the wavelength, and $d$ is the distance.

**Free-Space Path Loss (FSPL):**

The term $(\frac{\lambda}{4\pi d})^2$ in the Friis equation represents the loss. Expressed in decibels, FSPL is:
$$FSPL (dB) = 20\log_{10}(\frac{4\pi d f}{c})$$
FSPL indicates that loss increases with frequency ($f$). For example, at 120GHz over a distance of 10 meters, the loss is approximately 94dB. This implies that only an infinitesimal fraction (0.00000004%) of the transmitted power is received if isotropic antennas are used. This high path loss at high frequencies is a fundamental challenge in mm-wave design.

## 3. Why is an array needed at mm-wave frequencies?

An antenna array is necessary to compensate for the high Free-Space Path Loss (FSPL) and the small effective aperture of individual antennas at mm-wave frequencies.

As frequency increases, the wavelength ($\lambda$) decreases. Since the effective aperture (capture area) of an isotropic antenna scales with $\lambda^2$, a single mm-wave antenna captures very little power compared to an RF antenna. To recover this lost area, multiple antenna elements are combined into an array. The total effective area becomes $A_{eff, total} = N \cdot A_{ant}$, where $N$ is the number of elements. This increases the overall antenna gain, allowing for sufficient signal strength despite the high path loss.

## 4. Why is beamforming needed?

Beamforming is required to improve the efficiency of wireless transmission and to overcome the severe path loss at mm-wave frequencies.

Radiating energy in all directions (isotropic transmission) is inefficient ("wireless is inefficient") because only a fraction of the power reaches the receiver. By using an antenna array and adjusting the phase of the signal at each element (phased array), the constructive interference creates a directed beam toward the receiver. This provides high directional gain, compensating for the high FSPL. Furthermore, beam steering allows the transmitter to track the receiver, which is critical in mobile applications.

## 5. What are the main limitations of gain at mm-wave frequencies (above 20GHz)?

At mm-wave frequencies, gain is primarily limited by transistor parasitics and stability issues:

1.  **Gate Resistance ($R_g$):** The gate resistance forms an RC low-pass filter with the gate-source capacitance ($C_{gs}$), which attenuates the signal before it is amplified. Minimizing $R_g$ via layout optimization is critical.
2.  **Feedback Capacitance ($C_{gd}$):** The parasitic capacitance between the gate and drain creates a feedback path. This feedback can cause the amplifier to become potentially unstable. To ensure stability (K-factor > 1), loss must often be added, or the gain must be reduced to the Maximum Stable Gain (MSG) level rather than the Maximum Available Gain (MAG),,.
3.  **Passive Loss:** Matching networks and passives (inductors/transformers) have finite Q-factors, introducing insertion loss that directly subtracts from the achievable gain.

## 6. What are the main limitations of gain at RF frequencies (below 20GHz)?

At lower RF frequencies, the main limitation shifts toward the efficiency and practicality of matching networks:

1.  **Passive Component Size and Loss:** At lower frequencies, the inductance and capacitance values required for matching become large. Large inductors on-chip tend to have lower Q-factors (due to series resistance), leading to significant power loss in the matching network,.
2.  **Matching Efficiency:** While conjugate matching maximizes power transfer, the loss introduced by the matching network itself can be so high that it reduces the overall voltage gain. Consequently, at RF frequencies, designers often avoid complex conjugate matching and rely on simple 1:1 impedance ratios or "tuning" (resonating out capacitance) to avoid the heavy losses associated with impedance transformation.

## 7. How does the gate resistance scale with the number of fingers?

Gate resistance ($R_g$) is a distributed resistance that negatively impacts $f_{max}$ and gain. To minimize $R_g$, the transistor gate is laid out using multiple fingers.

*   **Scaling:** By splitting a large transistor width into multiple parallel fingers ($N_f$) of smaller width ($W_f$), the effective gate resistance decreases.
*   **Trade-off:** Using narrower fingers (smaller $W_f$) reduces the resistance per finger and places them in parallel, reducing total $R_g$. However, this must be balanced against the increased complexity and potential parasitic capacitance of the interconnects. The course notes emphasize that minimizing $R_g$ is crucial for maximizing gain and $f_{max}$, and this is achieved by optimizing the layout (e.g., choice of finger width and number of fingers),.

## 8. Can we do complex conjugate matching at RF frequencies?

Technically yes, but practically it is often avoided or "impossible" to do efficiently on-chip.

*   **Reason:** At lower RF frequencies, the required matching components (inductors and capacitors) are large. On-chip inductors at these frequencies have relatively low Q-factors (high series resistance),.
*   **Consequence:** Implementing a complex conjugate matching network introduces so much insertion loss that it cancels out the benefit of the power match, reducing the overall voltage gain.
*   **Conclusion:** The course states that at lower frequencies, matching gives too much power loss. Therefore, simpler "tuning" (canceling reactance) or using 1:1 impedance ratios is preferred over full impedance transformation/matching.

## 9. How to solve stability problems at mm-wave and RF?

Stability problems, often caused by the feedback capacitance $C_{gd}$, are solved using **Neutralization**.

*   **Technique:** Neutralization involves adding specific circuit elements to cancel out the unwanted feedback current flowing through $C_{gd}$.
*   **Implementation:** In differential amplifiers, this is typically implemented by cross-coupling capacitors ($C_N$) between the gate of one transistor and the drain of the other (and vice versa). If $C_N = C_{gd}$, the current fed back through $C_{gd}$ is canceled by the opposite-phase current through $C_N$.
*   **Result:** This unilateralizes the device, isolating the input from the output. This increases the stability factor (K > 1), allowing the design to achieve Maximum Available Gain (MAG) rather than being limited to Maximum Stable Gain (MSG), significantly boosting gain,.

## 10. What are the drawbacks of neutralization?

While neutralization improves differential stability and gain, it introduces several drawbacks:

1.  **Common-Mode (CM) Instability:** The neutralizing capacitors ($C_N$), which cancel feedback in differential mode, appear in *parallel* with $C_{gd}$ for common-mode signals. This effectively doubles the feedback capacitance for common-mode signals, potentially causing CM oscillation,.
2.  **Bandwidth Limitation:** The cancellation relies on specific component values matching ($C_N \approx C_{gd}$). Since these capacitances may vary differently with frequency or bias, perfect cancellation is narrowband.
3.  **Process Variation:** $C_{gd}$ is an internal transistor parasitic, while $C_N$ is often a metal-on-metal capacitor. These two components track differently over process and temperature variations, making robust neutralization difficult to maintain.
4.  **Sensitivity to Ground Inductance:** In single-ended implementations using transformers for neutralization, ground inductance can disrupt the phase relationships required for cancellation.

# Passives


## 1. Explain why Q-factor of inductors improve as we go to higher frequency

The Quality factor ($Q$) of an inductor typically improves as frequency increases due to the relationship between reactance and resistance.

*   **Formula:** The basic definition of $Q$ for an inductor is $Q = \frac{\omega L}{R}$, where $\omega$ is the angular frequency, $L$ is inductance, and $R$ is the series resistance.
*   **Scaling:** As frequency ($\omega$) increases, the reactance ($\omega L$) increases linearly. However, due to the **skin effect**, the resistance ($R$) of the metal trace typically increases only with the square root of the frequency ($\sqrt{\omega}$).
*   **Result:** Consequently, the numerator grows faster than the denominator, leading to a net increase in $Q$ as frequency rises ($Q \propto \sqrt{\omega}$), provided the frequency is not close to the Self-Resonance Frequency (SRF). At very high frequencies (mm-wave), substrate losses and skin effect become dominant, eventually causing the Q-factor to drop as it approaches resonance.

## 2. Discuss the different ways to calculate Q of an inductor

The course highlights two primary methods for calculating the Q-factor, noting that simple models often fail at mm-wave frequencies.

1.  **Impedance-based (Conventional) Calculation:**
    *   **Formula:** $Q = \frac{\text{Imag}(Z_{11})}{\text{Real}(Z_{11})}$.
    *   **Limitation:** This assumes a simple series $LR$ model. It is valid at lower frequencies but fails near the Self-Resonance Frequency (SRF). Near SRF, the parasitic capacitance causes the impedance to rise, artificially inflating the $\text{Imag}(Z)$ component. This calculation can erroneously suggest the inductance is increasing and does not reflect the physical energy storage efficiency,.

2.  **Resonator-based Calculation (Bandwidth Method):**
    *   **Method:** An ideal capacitor is added in parallel to the inductor to tune it to a specific resonance frequency ($f_0$).
    *   **Formula:** $Q = \frac{f_0}{\Delta f_{3dB}}$, where $\Delta f_{3dB}$ is the -3dB bandwidth of the magnitude response.
    *   **Advantage:** This method is more physically meaningful at mm-wave frequencies because it accounts for the total energy stored versus the energy dissipated per cycle ($Q = 2\pi \frac{\text{Energy Stored}}{\text{Energy Dissipated}}$). It provides a more accurate representation of the component's performance when used in a tuned circuit.

## 3. Which metal layers would you use to implement inductors? Which ones to implement capacitors?

The choice of metal layers depends on the trade-off between series resistance and capacitive density.

*   **Inductors:**
    *   **Layers:** **Top thick metals** (e.g., M9, AP/TM).
    *   **Reasoning:** Inductors require low series resistance to maintain a high Q-factor. Top metal layers in CMOS processes are thicker, offering lower sheet resistance. Furthermore, placing the inductor on the top layer maximizes the distance from the lossy silicon substrate, reducing substrate coupling and loss.
*   **Capacitors (MOM - Metal-Oxide-Metal):**
    *   **Layers:** **Lower/Middle metal layers** (e.g., M1–M5).
    *   **Reasoning:** MOM capacitors rely on lateral fringing fields between metal fingers. To maximize capacitance density ($fF/\mu m^2$), the metal fingers must be placed very close together. Lower metal layers in the stack typically allow for finer lithography (smaller spacing) than top metals. Although these layers are thinner and more resistive (lowering Q), the high density is necessary for compact designs,.

## 4. Explain why a 2-turn inductor behaves very differently in common-mode than a 1-turn inductor

The behavior differs due to the magnetic coupling and current flow direction in the windings.

*   **Differential Mode (DM):** In a differential 2-turn inductor, the currents in the adjacent windings flow in the **same direction**. The magnetic fields generated by these currents add up constructively (mutual inductance $M$ is positive), resulting in a high inductance: $L_{DM} \approx L_{primary} + L_{secondary} + 2M$.
*   **Common Mode (CM):** When driven in common mode, the currents in the adjacent windings of the symmetrical 2-turn structure flow in **opposite directions**.
*   **Cancellation:** These opposing currents cause the magnetic fields to cancel each other out. As a result, the effective inductance drops significantly ($L_{CM} \approx 0$).
*   **Course Reference:** The slides show that for a specific 2-turn inductor, the DM inductance is 200pH, while the CM inductance is only 50pH. Consequently, the SRF for CM (275 GHz) is much higher than for DM (72 GHz),.

## 5. Show on a smith chart how transformer-based matching works


Transformer-based matching does not follow constant resistance or conductance circles like simple L-C networks. Instead, it performs an impedance transformation based on the coupling factor $k$ and the turn ratio $n$.

*   **Visual behavior:** On the Smith Chart, a transformer rotates the load impedance. The course slides illustrate this by showing that a specific load impedance (e.g., $Z_{load} = 25 + j25 \Omega$) is transformed to a different point ($50\Omega$) via the transformer parameters.
*   **Mechanism:** An ideal transformer with a 1:n ratio modifies the impedance by $n^2$. However, real on-chip transformers rely on magnetic coupling ($k < 1$). The matching is achieved by tuning out the primary and secondary inductances ($L_P, L_S$) with capacitances, while the mutual inductance $M$ facilitates the power transfer. In a doubly-tuned transformer, this allows for wideband matching, visualized as a loop or curve passing through the center of the Smith Chart,.

## 6. Explain the impact of coupling-cap (between primary and secondary) in a transformer

The parasitic coupling capacitance ($C_c$) between the primary and secondary windings (inter-winding capacitance) creates non-idealities:

1.  **Reduction of SRF:** The capacitance creates a parallel resonance path, limiting the high-frequency operation range.
2.  **Notch in Transfer Function:** It creates a "zero" in the transfer function ($S_{21}$ or $Z_{21}$), leading to a notch where signal transmission drops significantly.
3.  **Imbalance:** Depending on how the transformer is connected (e.g., "Same side" vs. "Opposite side" connection), the voltage drop across this capacitance varies. If the voltage drop is high, it injects Common-Mode (CM) currents, ruining the balance of the differential signal,,.
4.  **Isolation:** Ideally, a transformer provides DC isolation. A large coupling cap degrades this isolation at high frequencies.

## 7. Which transmission line structures perform the best in III/V and which ones in CMOS?

The optimal structure depends on the substrate conductivity.

*   **III/V (e.g., GaAs):** **Microstrip** lines perform best.
    *   **Reason:** GaAs substrates are semi-insulating (high resistivity). The electric fields can penetrate the substrate without causing significant losses. Therefore, the ground plane can be placed on the backside of the wafer, using the substrate as part of the dielectric.
*   **CMOS (Silicon):** **Coplanar Waveguide (CPW)** or **Shielded** lines perform best.
    *   **Reason:** Silicon substrates are conductive (lossy, $\sim 10 \Omega$-cm). Electric fields penetrating the substrate generate eddy currents and dielectric loss. CPW brings the ground lines to the top metal layer (beside the signal), keeping fields largely in the air/oxide. Alternatively, a slow-wave structure with a metal shield is used to block fields from entering the silicon,.

## 8. Explain how a slow-wave transmission line works

A slow-wave transmission line uses a specific shielding structure to decouple magnetic and electric fields, effectively slowing down the wave velocity ($v = 1/\sqrt{LC}$).

*   **Structure:** It consists of a signal line on a top metal layer and a **floating patterned shield** (metal strips) on a lower layer, above the silicon substrate.
*   **Inductance ($L$):** The shield strips are floating and patterned orthogonal to the current flow. Therefore, no return current flows through them, and the magnetic field passes through to the ground unchanged. $L$ remains constant (or slightly decreases due to eddy currents if not perfectly patterned).
*   **Capacitance ($C$):** The electric field terminates on the floating metal strips rather than the distant substrate. This effectively reduces the distance between the "plates" of the transmission line capacitor, significantly increasing the capacitance per unit length ($C$).
*   **Result:** Since velocity $v = 1/\sqrt{LC}$, the increased $C$ (with constant $L$) reduces the wave velocity. This allows for physically shorter lines to achieve the same electrical length (wavelength $\lambda$ decreases), saving chip area.

## 9. Is shielding useful in single-ended structure?

**Generally, no.** The course states that for single-ended structures, a floating shield does not improve performance.

*   **Floating Shield:** Since there is no virtual ground (unlike in differential signaling), the floating shield does not effectively terminate the electric field in a way that boosts performance without penalty. It is explicitly stated: "For single-ended structures, a floating shield... will not improve the performance".
*   **Grounded Shield:** If the shield is connected to ground, it acts as a short-circuit for the electric field. While this eliminates substrate loss (improving Q at lower frequencies), it massively increases the capacitance to ground. This results in a much lower Self-Resonance Frequency (SRF), limiting the usable bandwidth for mm-wave applications.


# Transformers

## 1. Compare bipolar with CMOS. Which one is better?

In the context of mm-wave passives and transformers, Bipolar (often associated with III/V technologies like GaAs or SiGe) is generally considered "better" regarding substrate performance, while CMOS struggles with losses but offers complex back-end integration.

*   **Substrate Resistivity:** The primary differentiator is the substrate. Bipolar technologies often use semi-insulating substrates (e.g., GaAs) or high-resistivity silicon. In contrast, standard CMOS uses a conductive silicon substrate (resistivity $\approx 10 \;\Omega\cdot\text{cm}$).
*   **Impact on Passives:** In CMOS, the conductive substrate allows electric fields to penetrate, generating eddy currents and dielectric losses, which degrades the Quality factor (Q) and Maximum Available Gain (MAG) of transformers and transmission lines. As shown in the course, higher substrate resistivity directly correlates to higher MAG for transformers.
*   **CMOS Compensation:** To mitigate this, CMOS designs utilise the complex "Back-End Of Line" (BEOL) metal stacks. Modern CMOS nodes (e.g., 40nm, 28nm) offer many metal layers (up to 10+), allowing for vertical stacking and complex winding geometries (like "dummy filling" compliance) that are necessary to achieve acceptable performance despite the lossy substrate.

## 2. Very often, the magnetic coupling (k) of a transformer is reduced on purpose. Why?

The magnetic coupling ($k$) is reduced to increase the **bandwidth** of the matching network.

*   **Trade-off:** A transformer-based matching network is essentially a 4th-order network with two resonant frequencies ($L\omega$ and $H\omega$). The separation between these two frequencies is determined by $k$.
*   **High k (e.g., 0.9):** Causes the two resonant peaks to move far apart. Typically, only the lower resonance is used for narrowband applications. This yields the highest efficiency and lowest loss but limits bandwidth.
*   **Lower k (e.g., 0.6 to 0.3):** Brings the poles closer together or flattens the response between them. This results in a wideband, flat frequency response (e.g., for E-band receivers), albeit with slightly higher insertion loss. If the component Q-factor is high, a lower $k$ can be tolerated to achieve this wide bandwidth without sacrificing too much efficiency.

## 3. Explain the causes of imbalance in balanced transformers. Explain how to reduce this imbalance.

Layout symmetry alone does not guarantee signal balance; the electrical environment matters significantly.

*   **Causes:**
    1.  **Capacitive Coupling ($C_c$):** The parasitic capacitance between primary and secondary windings creates a path for Common-Mode (CM) signals. If the voltage drop across this capacitance is not symmetrical (e.g., in a balun converting single-ended to differential), it injects unbalanced currents.
    2.  **Ground Impedance:** A non-zero ground impedance ($Z_{GND}$) in the return path creates a voltage potential that affects the effective capacitance seen by the signal, leading to asymmetry.
    3.  **Center-Tap (CT) Connection:** Even with a balanced input/output, connecting the center-tap on only one side creates a geometric and electrical imbalance.
*   **Reduction Techniques:**
    1.  **High Ground Impedance:** Increasing the impedance of the ground return path prevents the flow of imbalance currents.
    2.  **High Center-Tap Impedance:** Using a choke (inductor) at the center-tap creates a high impedance for mm-wave frequencies, blocking CM currents while allowing DC bias.
    3.  **Balanced Coupling:** Ensuring that the inter-winding capacitors see identical voltages on both sides (symmetrical voltage distribution) cancels out the CM coupling effect.

## 4. In some situations, isolating the ground between primary and secondary winding of a transformer, helps to improve performance. Explain this effect.

Isolating the ground breaks the return path for common-mode (CM) currents, thereby restoring balance and reducing loss.

*   **The Mechanism:** In a non-isolated combiner or balun, ground loops can form through the ground planes, facilitating imbalance through capacitive coupling. By utilizing the DC isolation property of the transformer and actively isolating the AC grounds (e.g., via high impedance or physical separation), the path for the capacitive feedthrough current is removed.
*   **Result:** This forces the current to flow magnetically (differential mode) rather than through the parasitic capacitance (common mode), which improves the Common-Mode Rejection Ratio (CMRR) and prevents the "notch" in the transfer function caused by capacitive feedthrough.


# PA System Level

## 1. Explain the difference between matching for gain and matching for output power.

Matching for gain and power target different impedances on the Smith chart, and they rarely coincide in large-signal operation.

*   **Gain Matching:** This targets the complex conjugate of the transistor's output impedance ($S_{22}^*$) to maximize the small-signal gain ($S_{21}$). It ensures the most efficient transfer of *available* signal gain but does not account for voltage/current clipping limits.
*   **Power Matching:** This targets the optimal load resistance ($R_{opt}$ or Load Pull contour) that allows the transistor to swing its full voltage and current range to generate the maximum saturated output power ($P_{sat}$). This impedance is often lower than the gain-matching impedance.
*   **Trade-off:** A designer must select a point between these two distinct circles on the Smith chart to balance sufficient gain with maximum drive capability.

## 2. Explain the difference between ratio gain and slope gain.

*   **Ratio Gain:** This is the "large-signal" gain, defined simply as the ratio of output magnitude to input magnitude ($P_{out}/P_{in}$ or $V_{out}/V_{in}$). Even when a PA is compressing, the ratio gain is still positive (greater than 0).
*   **Slope Gain:** This is the derivative of the output amplitude with respect to the input amplitude ($\partial V_{out} / \partial V_{in}$). It represents the incremental gain.
*   **Significance:** This distinction is critical for **Digital Predistortion (DPD)**. DPD requires inverting the amplifier's transfer function. If the PA enters hard saturation, the *slope gain* drops to zero. You cannot invert a zero slope (it would require infinite input drive). Therefore, predistortion is only possible as long as the slope gain is positive, making slope gain the better metric for determining the linearizable range of a PA.

## 3. What is PAPR and what is the problem when the PAPR is high?

*   **Definition:** PAPR stands for **Peak-to-Average Power Ratio**. It is the ratio of the peak power of the signal to its average power.
*   **Problem:** High PAPR is the primary cause of low efficiency in modern transmitters.
    *   To transmit the peaks without clipping (distortion), the PA must be biased and sized to handle the peak power ($P_{peak}$).
    *   However, the signal spends most of its time at the much lower average power level ($P_{avg}$).
    *   Since PA efficiency drops significantly at power back-off (linear region), a high PAPR forces the PA to operate in its low-efficiency region for the majority of the time, resulting in poor average efficiency.

## 4. Is second-order distortion important or not?

**Yes, it is important.** While the direct second-harmonic products ($2f_1, f_1+f_2$) are far away from the fundamental frequency and can be filtered, the low-frequency beat product ($f_2 - f_1$) causes **Memory Effects**.

*   **Mechanism:** The envelope (difference) frequency creates a low-frequency AC signal on the bias lines. If the bias network has large RC time constants, this LF signal modulates the bias voltage, disrupting the PA's operation point dynamically.
*   **Consequence:** These "baseband" disturbances mix with the fundamental tones to generate asymmetrical third-order intermodulation (IMD3) products, degrading linearity in a way that is difficult to predict with simple static models.

## 5. What is EVM?

**EVM (Error Vector Magnitude)** is a metric used to quantify the linearity and modulation accuracy of a transmitter.

*   **Definition:** It measures the difference between the ideal constellation point (reference) and the actual measured symbol location in the I/Q plane. It is calculated as the RMS value of the error vectors for all symbols, normalized to either the RMS power or the Peak power of the constellation.
*   **Significance:** It combines errors from amplitude distortion (AM-AM), phase distortion (AM-PM), and noise into a single figure of merit. For complex modulations like 64-QAM, a very low EVM (e.g., -25dB) is required to ensure decodability.

## 6. What is AM-AM and what is AM-PM?

These are the two primary forms of non-linear distortion in a Power Amplifier:

*   **AM-AM (Amplitude-to-Amplitude):** This represents gain compression. As the input power ($P_{in}$) increases, the gain ($P_{out}/P_{in}$) decreases. In a constellation diagram, this looks like the outer points (highest amplitude) being compressed inward towards the origin (squares become circles).
*   **AM-PM (Amplitude-to-Phase):** This is the variation of the output signal's phase shift as a function of the input amplitude. As the input power increases, the phase of the signal rotates.
    *   **Cause:** It is typically caused by the non-linear behaviour of the transistor's parasitic capacitances (mainly non-linear $C_{GS}$) which change value with the input voltage level, detuning the matching network.
    *   **Effect:** In a constellation diagram, this causes the outer points to rotate relative to the inner points.


# Receivers

## 1. What is the problem with the heterodyne mixing

The fundamental problem with heterodyne mixing is the **Image Frequency**.

*   **Mechanism:** In a heterodyne receiver, the RF signal ($\omega_{in}$) is mixed with a Local Oscillator ($\omega_{LO}$) to translate it to an Intermediate Frequency ($\omega_{IF}$). The mixer produces an output at $|\omega_{in} - \omega_{LO}|$. However, there is a second frequency, called the Image Frequency ($\omega_{im}$), which also satisfies $|\omega_{im} - \omega_{LO}| = \omega_{IF}$.
*   **Consequence:** Since the receiver does not know upfront what signals are present in the air, a strong blocker located at the image frequency will be downconverted directly on top of the desired channel at the IF, corrupting or blocking the desired signal. This necessitates the use of an image-reject filter before the mixer to suppress $\omega_{im}$.

## 2. Explain the tradeoff between image rejection and channel selection

This tradeoff is dictated by the choice of the Intermediate Frequency (IF):

*   **High IF:** If the IF is high, the image frequency ($2\omega_{IF}$ away from the carrier) is far away. This makes **image rejection easy** because a simple analog RF filter can attenuate the distant image. However, **channel selection becomes hard** because the relative bandwidth of the channel at a high IF is very small, requiring extremely high-Q filters to separate the channel from neighbors.
*   **Low IF:** If the IF is low, channel selection is **easy** because filter Q-factor requirements are relaxed. However, the image frequency is now very close to the RF carrier. This makes **image rejection hard** (or "bad") because a standard RF filter cannot distinguish between the close-in image and the desired signal.

## 3. What is homo-dyne mixing?

Homo-dyne mixing, also known as **Direct Conversion** or **Zero-IF**, involves mixing the RF signal with an LO frequency that is equal to the RF carrier frequency ($\omega_{LO} = \omega_{in}$).

*   **Result:** The signal is downconverted directly to DC (0 Hz).
*   **Advantage:** The image frequency is the signal itself, so there is **no image problem**.
*   **Disadvantages:** It suffers from **DC offsets** caused by LO leakage self-mixing (LO leaks to antenna and reflects back), even-order distortion ($IP_2$), and **1/f noise** which corrupts the signal at baseband.

## 4. Explain sliding IF

Sliding IF is a topology that solves the oscillator pulling and synthesizer complexity issues.

*   **Concept:** Instead of using two independent LO synthesizers, one single LO ($\omega_{LO1}$) is used to derive the second LO ($\omega_{LO2}$) typically via a frequency divider (e.g., $\div 2$).
*   **Mechanism:** The first mixer uses $\omega_{LO1}$, and the second mixer uses $\omega_{LO1}/2$. The IF frequency "slides" or tracks with the RF frequency because they are derived from the same source.
*   **Benefit:** It avoids the need for two Phase-Locked Loops (PLLs) and ensures that the LO frequency is different from the RF frequency, reducing pulling.

## 5. Explain the basic concepts of image-rejection receivers

Image-rejection receivers (like the Hartley or Weaver architectures) use signal processing rather than filtering to remove the image.

*   **Quadrature Mixing:** They utilize quadrature downconversion, processing the signal in two paths ($I$ and $Q$) using LOs shifted by $90^\circ$ ($\cos$ and $\sin$).
*   **Complex Domain:** In the complex domain, positive and negative frequencies can be distinguished. The desired signal and the image signal map to different polarities (e.g., $+ \omega_{IF}$ vs $-\omega_{IF}$).
*   **Cancellation:** By applying specific phase shifts (e.g., another $90^\circ$ shift) and adding the paths, the image components cancel out destructively while the desired signal components add constructively. Ideally, this provides infinite rejection, but in practice, it is limited by amplitude and phase mismatch (gain ratio and phase error) between the paths.

## 6. Compare Low-IF and Zero-IF

*   **Zero-IF (Direct Conversion):**
    *   **Pros:** Simple, no image filter needed (image is self).
    *   **Cons:** Serious issues with **DC offset**, **1/f noise**, and self-mixing because the signal is at DC.
*   **Low-IF:**
    *   **Pros:** Downconverts to a low non-zero frequency (e.g., 100-200 kHz). This avoids the DC offset and 1/f noise problems associated with Zero-IF. It allows for high integration.
    *   **Cons:** The "image" is now the adjacent channel (or nearby blocker). Since regular filters cannot remove this close image, it requires an **active image rejection** scheme (like a polyphase filter) or digital image rejection to achieve the necessary >60dB suppression,.

## 7. What is a polyphase filter?

A polyphase filter is a **complex analog filter** used primarily in Low-IF receivers for image rejection.

*   **Function:** Unlike a real filter which has a symmetric response ($H(j\omega) = H(-j\omega)^*$), a polyphase filter processes complex signals ($I$ and $Q$) and has an asymmetric transfer function. It can pass positive frequencies (desired signal) while attenuating negative frequencies (image).
*   **Implementation:** It is typically realized using active RC networks (operational amplifiers with cross-coupled resistors and capacitors) to synthesize the complex transfer function.

# Transmitters

## 1. Discuss why we do baseband filtering and what is a Nyquist filter

*   **Reason for Filtering:** Digital symbols (like QPSK or QAM) are discrete points. Transitioning between them instantaneously (square pulses) results in a $\text{sinc}(x)$ spectrum with infinite bandwidth. To fit the transmission within a limited spectral mask (allocated channel) and avoid interfering with adjacent channels, we must apply low-pass filtering to the baseband pulses.
*   **Nyquist Filter:** Filtering spreads the symbols in time, potentially causing **Inter-Symbol Interference (ISI)** where previous symbols corrupt the current one. A Nyquist filter (e.g., Raised Cosine) is a specific filter shape designed to band-limit the signal while ensuring zero ISI at the sampling instants. It ensures that the ringing of one symbol is zero at the precise moment the next symbol is sampled.

## 2. What is PA-VCO pulling and how can we solve it?

*   **The Problem:** In a direct-conversion transmitter, the Power Amplifier (PA) output frequency is exactly the same as the Voltage Controlled Oscillator (VCO) frequency ($\omega_{RF} = \omega_{LO}$). The strong output signal from the PA can leak back (via the substrate or magnetic coupling) to the sensitive VCO. This creates an injection locking phenomenon where the VCO is "pulled" away from its desired frequency by the PA's modulation, corrupting the signal.
*   **Solution:** The standard solution is to avoid operating the VCO at the PA frequency. This is achieved by generating the LO at a different frequency (e.g., $2\omega_c$) and using a **frequency divider** (e.g., $\div 2$) to generate the final carrier frequency. This creates a large frequency separation between the strong PA output and the sensitive VCO, preventing injection locking.