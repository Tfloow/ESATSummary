---
title: "Image Analysis"
author: Thomas Debelle
geometry: "left=1cm,right=1cm,top=2cm,bottom=2cm"
papersize: a4
titlepage-rule-color: 00407A
date: \today
toc: true
toc-depth: 3
titlepage: true
titlepage-logo: KULlogo.pdf
template: eisvogel
subtitle: "[An Open-Source Summary](https://github.com/Tfloow/ESATSummary)"
copyright: "© Thomas Debelle. This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License."
copyright-link: "https://creativecommons.org/licenses/by-nc-sa/4.0/"
output: pdf_document
---

\newpage

\part{Classic Image Analysis}

# Introduction

The key take away is that vision is subjective to the human being and themselves. It is the results of continuous evolution and survival of the fittest. We are more sensitive to light and certain colors, to motion, ... And this fact will be used for efficient image representation and analysis.

We can think of the classic illusion where our brain will interpret certain lengths of an arrow longer than others. Context also does matter, even in a blurry picture our brain will train to make up for what he sees.

## The basics

We first need light to have vision. Light is influenced by object and create perception. ADD image slide 51. The light source bounce on the object and some scattered ray will get trough the 2D Image plane, which will be casted on the sensor array thanks to the lens system.

### Light

We will look at it from a physical optic (not geometrical (constant speed and straight path) nor quantum). Light is an Electro-magnetic wave which we assume it to be planar. aka $\frac{|E|}{|H|} = \eta$ in simple term, light is perpendicular. This is a **self-sustaining process** that is characterized by:

1. $\lambda$: wavelength
2. Direction
3. $E$: Amplitude
4. $\varphi$: phase
5. Direction of polarisation

Violet: low frequency ($380 nm$); Red: high frequency ($760 nm$). Remember $\lambda = \frac{c}{f}$.

### Perception

We don't perceive light equally. Humans have 3 cones that are not evenly spread apart. But the human vision is trained to compensate for it so everything feels similar in intensity to us. Some animals can have more cones.

### Interaction with matter

| **Phenomenon** |           **Example** |
| :------------- | --------------------: |
| Absorption     | Blue water,green leaf |
| Scattering     |  blue sky, red sunset |
| Reflection     |          colored in k |
| Refraction     | dispersion by a prism |
:The four types of interaction


#### Absorption

Dissipation of $\lambda$ specific for the medium. Resonance in molecules.

#### Scattering

When light (radiation/particles) deviates from a straight trajectory by local non-uniformities. Type depends on the relative size of particles and wavelengths:

1. **Rayleigh**: small ($\lambda$ dependent)
2. **Mie**: comparable (weakly $\lambda$ dependent)
3. **Non-selective**: large ($\lambda$ **in**dependent) 

We ignored transmission and diffraction.

![Wavelength dependence for scattering](image.png){width=50%}

We need scatter to get the bluesky (Rayleigh with Tyndall effect) or it would be dark. Coloured cloud from volcanic eruption = Mie (particle all over the air). Grey cloud is due to non-selective.Less scatter for lower frequency light (infrared).

#### Reflection

![Mirror reflection](image-1.png){width=50%}

With reflection, the notion of polarization is important. The polarization effect creates the fact that a reflected wave on certain surfaces can be reflected with all but one direction of the electric field. This effect is more prominent on **non-metallic** surfaces!

![Non-metallic reflection - strong reflectors](image-2.png){width=50%}

![Metallic reflection - Red dot: Brewster angle (polarizer) - Blue zone: Grazing angles](image-3.png){width=50%}

Rough surfaces will lead to **diffuse** reflection as the reflection angles will be all over the place. On the other hand, smooth surfaces give **specular** reflection. Both **diffuse** and **specular** can also happen all together.

Reflectance varies through $\lambda$ and different side of vegetation can typically give various reflection[^1]

[^1]: This fact can be used for spectral reflectance of vegetation since it forms a signature

#### Refraction

Typically, refraction which is the bending of the light and dispersion which is a frequency dependency.

![Refraction - governed by Snell's law property of the medium **and** material](image-4.png){width=50%}

# Acquisition of images

![Image acquisition model](image-5.png){width=50%}

Controlling the lights is essential for acquisition as it is the main vector to acquire images. Severals techniques exist

| Type                                      | Description                                                                                                                                                             |                                                                                                                       Examples |
| :---------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -----------------------------------------------------------------------------------------------------------------------------: |
| Back-lighting                             | Light source behind object (better with a diffuser plate)                                                                                                               |                                                                        High contrast silhouette. **Binary vision**, inspection |
| Directional                               | Tilt lights to generate sharp shadow of specular reflection (rough surfaces)                                                                                            |                                                                                                            Detection of cracks |
| Diffuse                                   | Uniform lighting, all directions contribute to the diffusion reflection but specular spike due to spike                                                                 |                                                                                                            Detection of cracks |
| Polarized: Contrast diffuse and specular  | diffuse makes light non-polarized while specular keeps polarized. Put polarizer/analyzer orthogonal, better for glare (high dynamic range) issue.                       |                                                                                                            Detection of cracks |
| Polarized: Contrast dielectrics and metal | Dielectric at Brewster angle can be used as a polarizer which is not possible for metallic surface (see previous chapter).                                              | So use a polarizer to suppress specular reflection from dielectric **OR** distinguish between specular and dielectric surfaces |
| Coloured                                  | Highlight region of similar colour. Use laser (monochromatic light), differentiation between specular and diffuse. Comparing colours. Spectral sensitivity of a sensor. |                                                                                                                                |
| Structured                                | Spatially or temporally modulated light pattern. Projection on a 3D object will distort the projection pattern                                                          |                                                                                                              3D reconstruction |
| Stroboscopic                              | High intensity light flash. Eliminate motion blur.                                                                                                                      |                                                                                                      For high speed inspection |

Note about the dar and bright field. Mostly relevant for the Directional/Diffuse lighting. *Dark field*, when the camera is placed outside the specular reflection area of the normal area, only specular reflection (different orientation from normal) will show up. On the other hand, *Bright field*, we place camera inside this specular reflection light area and the non-normal area will appear dark.

## Image formation - Lens

We use the pinhole model in this class:

![Pinhole model](image-6.png){width=60%}

From this we can use the thin-lens equation which assumes:

- Spherical lens surfaces
- Incoming light $\pm \parallel$ to axis
- Thickness << radii
- Same refractive index on both sides

![Thin-lens equation](image-7.png){width=50%}

![Depth of field of the thin lens](image-8.png){width=50%}

There is one focal point. Strike a balance between incoming light (d) and large depth-of-field. Smaller depth-of-field is present in microscopes for example.

## Sensor array

### CCD vs CMOS

We have 2 types of sensors:

- CCD:  Charge-coupled device
  - Old school
  - Charges must hop from tile to tile
  - Cover the total pixel (high fill rate)
  - Expensive
  - Blooming (due to the charge hoping)
  - High power consumption
- CMOS: integrated
  - Cheap, Can put other component on the chip (integration)
  - Read line by line (like RAM = random access) 
  - Smaller
  - Low power
  - Same sensor as CCD but each has their own amplifier = more noise + not covering the full space = lower fill rate / sensitivity

They both works in 2 steps:

1. Photon to electron (charge) conversion
2. Electron (charge) to voltage conversion

![CCD vs CMOS](image-9.png){width=50%}

### Colour cameras

#### 1. Prism

The idea is to split the light using *dichroic prism* to split it in 3 colors. This requires really good precision but allows for good color separation.

#### 2. Filter mosaic

Back to the *bayer pattern* introduced earlier. Good for tricking the human eyes. Each pixel will have a filter in front to follow the bayer pattern. This is good but can create some aliasing especially when an edge is right on a pixel array causing some extra inexistant colors (aliasing).

![Aliasing with bayer pattern](image-10.png){width=50%}

We loose actual resolution since know we need 2x2 pixel array to get 1 colored pixel ! We have to stack even more density but need to capture more lights --> Use microlenses.

#### 3. Filter wheel

Here instead of having 3 filters like in a filter mosaic, we have a full wheel with many filters. Behind the wheel, there is a static sensor (**only static scenes**).

#### Summary

| Type          |      Prism       |     Mosaic      |              Wheel              |
| :------------ | :--------------: | :-------------: | :-----------------------------: |
| # Sensors     |        3         |        1        |                1                |
| Resolution    |       High       |     Medium      |              Good               |
| Cost          |       High       |       Low       |             Medium              |
| Framerate     |       High       |      High       |               Low               |
| Artefacts     |       Low        |    Aliasing     | Aliasing (just motion of wheel) |
| Bands (color) |        3         |        3        |             3 or +              |
| Application   | High-end cameras | Low-end cameras |     Scientific applications     |
:Summary of the 3 coloured camera

#### Improvements

One issue is the Aliasing problem for object in motion. Since we read line by line in CMOS camera, for fast turning object (turning at $\geqslant f_s/2$) we have aliasing. To solve this, we need a global shutter instead of reading line by line.

## Perspective Projection - Image Plane

Here, we revisit the pinhole model where now, we first project everything on an object plane and then this will get through the lens. The center of the lens is the center of the projection, we have an virtual image plane which is also called **perspective projection** (we flattened out everything from the outside on it):

![Camera projection model](image-11.png){width=50%}

![3D view of the camera projection model](image-12.png){width=50%}

The origin is the center of the projection ($X_c$ row-pixel, $Y_c$ column-pixel space), the $Z_c$ axis correspond with the optical axis.

If we look at the $u,v$ space we have the following relationship, which comes from the "similar triangles property" where you look once from above (for X case) and one from the side (for Y case).

$$
u = f\frac{X_c}{Z_c} \qquad v = f\frac{Y_c}{Z_c}
$$

We can then say that if $Z$ is constant, we can write $x = kX_c$ and $y = kY_c$ where $k=f/Z$. Orthographic projection + a scaling. This forms a good approximation if objects are small compared to their distance from the camera.

### Projections limitations

![Pseudo-orthographic vs Perspective projection](image-13.png){width=50%}

The perspective projection model is incomplete. What about world coordinate ? What if we want our u,v coordinates as a row and column numbers (like in a matrix of pixels).

**This part of the class that does not form exam material but helps with understanding where does those matrices come from.**

#### The (u,v) projection to pixel

We can see a matrix of pixel instead of the (u,v) projection. We just need 3 informations: 1. Center of matrix $x_0$ and $y_o$, 2. Width of array $k_x$ and 3. Height of array $k_y$ giving us:

$$
\begin{cases}
    x&= k_x u + x_0 + sv\\
    y&= ky_v +y_0
\end{cases}
$$

Note: the $s$ is for skew, we have the aspect ratio $k_y/k_x$[^2]

[^2]: I thought it was the opposite...

#### The global world coordinate problem

Those equations are based on the previous $u = f X/Z$ and $v = f Y/Z$. Here $\langle , \rangle$ represents the dot product $\cdot$ between 2 vectors.

![Projection matrices](image-14.png){width=50%}

The $P-c$ represents the dotted vector and $C$ being the camera position in a global coordinate system (the camera is no longer stuck to the 0,0 point). We then use the dot product between on of its axis and the vector P-C to obtain the value in this specific vector dimension (a bit like the X before). Repeat it for Y and Z.

#### Homogeneous coordinates

Capturing a 2D image requires to navigate a 3D world (and so on for 3D and 4D). This is important in computer vision where we have to deal with projection where we **have to** divide a point by $z$ !

$$
\tau \begin{pmatrix}
    x\\ y\\ z
\end{pmatrix} \rightarrow_{\text{capturing/projection}} \begin{pmatrix}
    x/z\\ y/z
\end{pmatrix}
$$

#### Putting it all together

We can rewrite the previous big dot/inner product using the homogeneous coordinate (removes division) as:

$$
\tau \begin{pmatrix}
    u\\ v\\ 1
\end{pmatrix} = \begin{pmatrix}
    fr_{11} & fr_{12} & fr_{13} \\
    fr_{21} & fr_{22} & fr_{23} \\
    r_{31} & r_{12} & r_{13} \\
\end{pmatrix} \begin{pmatrix}
    X-C_1\\ Y-C_2 \\ Z-C_3
\end{pmatrix}
$$

we can then apply the pixel coordinate system on this equation:

$$
\tau \begin{pmatrix}
    x\\ y\\ 1
\end{pmatrix} = \begin{pmatrix}
    k_x & s & x_0 \\
    0 & k_y & y_0 \\
    0 & 0 & 1 \\
\end{pmatrix} \begin{pmatrix}
    fr_{11} & fr_{12} & fr_{13} \\
    fr_{21} & fr_{22} & fr_{23} \\
    r_{31} & r_{12} & r_{13} \\
\end{pmatrix} \begin{pmatrix}
    X-C_1\\ Y-C_2 \\ Z-C_3
\end{pmatrix}
$$
 
**Back to important material for exam.**

we can further simplify with

$$
\tau \begin{pmatrix}
    x\\ y\\ 1
\end{pmatrix} = \overbrace{\begin{pmatrix}
    k_x & s & x_0 \\
    0 & k_y & y_0 \\
    0 & 0 & 1 \\
\end{pmatrix} \begin{pmatrix}
    f & 0 & 0\\
    0 & f & 0\\
    0 & 0 & 1
\end{pmatrix}}^{K \text{ Calibration matrix}} \overbrace{\begin{pmatrix}
    r_{11} & r_{12} & r_{13} \\
    r_{21} & r_{22} & r_{23} \\
    r_{31} & r_{12} & r_{13} \\
\end{pmatrix}}^{R \text{ Camera rotation}} \begin{pmatrix}
    X-C_1\\ Y-C_2 \\ Z-C_3
\end{pmatrix}
$$

We then define the following vectors:


\begin{align}
    p &= \begin{pmatrix}
        x\\ y\\ 1
    \end{pmatrix} &     P &= \begin{pmatrix}
        X\\ Y\\ Z
    \end{pmatrix} &     \tilde{P} &= \begin{pmatrix}
        X \\ Y \\ Z \\ 1
    \end{pmatrix} 
\end{align}

Which then yields the simplified version:

$$
\rho p = KR^\top (P-C) \qquad \text{some non-zero } \rho \in \mathbb{R}
$$

$$
\text{or, } \rho p = K (R^\top | -R^\top C ) \tilde{P}
$$

$$
\text{or, }\text{or, } \rho p = (M|t) \tilde{P}
 \qquad \text{with rank } M = 3
$$

## Deviations from the lens model

We assume:

1. All rays from a point are focused onto 1 image point
2. All image points in a single plane
3. Magnification is constant

If those are not respected, we have **aberrations**! Aberrations acan be **geometrical** (small for paraxial rays) or **chromatic** (refractive index function of $\lambda$ - Snell's law)

![Geometrical aberrations](image-15.png){width=50%}

They all cause issues on the focus point of the image plane. Spherical appears when the bending of light is not uniform throughout the lens, typically outer ray converges sooner (small focal length) then inner one. They do not converge all together. Coma is a bit like spherical but this time with a tiled ray. Astigmatism is problems between the *tangential* and *sagittal* ($90^\circ$ rotation from tangential) focus point which are not equal.

### Radial distortion

By far the most important type of distortion which causes "fish-eye" look or pincushion. It creates various *magnification* for different angles of inclination. The pixel either sinks towards the center or slides outside along the line connection the center and the original pixel.

![Radial Distortion](image-16.png){width=50%}

We can model this sliding distance $d$ with the following equation and thus can be corrected. Some algorithm looks at human made structure (straight lines) to establish the effect.

$$
d = (1+ \kappa_1 r^2 + \kappa_2 r^4 + ...)
$$

### Chromatic aberration

Rays of different $\lambda$ will focus in different planes. This creates various colours especially along sharp edges. This **can't** be removed completely but *achromatization* can be achieved by selecting the right type of glasses.

![Achromatization](image-17.png){width=50%}

### Photometric camera model

We want to convert the object radiance into a pixel grey level. This is a 2-step process with our idea of the image plane. We first project the radiance of the object to the image, then this image irradiance projects to a pixel in a grey level. The **cos4** law governs the radiance. The more an object is of-axis from the center by an angle $\theta$ the more it reduces its irradiance in the pixel. This materializes with **natural vignetting**[^3] (like the old instagram filter).

$$
I = R \frac{A_l}{f^2} \cos^4 \theta
$$

This will get converted in a grey pixel with:

$$
pix = g I^\gamma + d
$$

With the $g$ of the camera, $d$ the dark reference of the camera. The gamma $\gamma$ is a non-linear relationship which changes the mid-tone without really changing the pure black or white. A value lower than 1 makes the image lighter and vice-versa. Nowadays, cameras have become quite linear meaning that $\gamma = 1$.

[^3]: optical vignetting appears due to an obstruction of the lens by an element


# Sampling and Quantisation

We live in an analog world but our computers and digital world is finite. So we have to sample (Discretize points) and quantize (attribute them a finite value).

From what we have seen and learned before, we can trick the human eye to see a higher quality image than it is actually. For example the display on a phone has a RGB pixel ratio as 2:1:1 because the human is less sensible to green. We call this grid the **bayer filter**. Other representation exist which can be more exotic, e.g.: hexagonal (more isotropic, similar structure as in the retina, no connectivity ambiguities). 

We have quantization where we usually talk about levels. Typically a n bits representation has $2^n$ levels. We can also apply fancier quantization scheme instead of simple linear one. The most classic representation is the RGB888 (1 byte per pixel for each color).

![Various quantization scheme](capture_temp.jpg){width=50%}

#### HDR

High Dynamic Range (HDR) is a technology where we have various luminance on the screen giving really good contrast in dark and bright area. Usually, we combine multiple photos with various gains and then recombine it all together with the various exposure.

## Sampling

### Integrate brightness over the cell window

![Integrating over a pixel cell](capture_temp-1.jpg){width=50%}

This forms a convolution. Convolution are **linear**, $f_1 \rightarrow g_1 \quad f_2 \rightarrow g_2 \Rightarrow af_1 + bf_2 \rightarrow ag_1+bg_2$ , and **shift-invariant**, $f(x,y) \rightarrow g(x,y) \Rightarrow f(x-a, y-b) \rightarrow g(x-a, y-b)$.

Convolutions are also commutative and associative as proven in the Fourier domain.

$$
\mathfrak{F}(u) = \int_{-\infty}^{\infty} f(t) e^{-2i\pi x u}dx
$$

For the 2D case, we have $e^{-2i\pi (ux + vy)}$ which has for Euler form $\cos(2\pi (ux+vy)) +  i\sin(2\pi (ux+vy))$. Now, the $u$ and $v$ represents the frequency along the x and y dimensions. To obtain the $\lambda$ of  the signal we need to take the norm of the frequency for both axis inverted:

$$
\lambda = \frac{1}{\sqrt{u^2+v^2}}
$$

As in 1D, we can do Fourier transform to decomposition the image in a bunch of frequencies. As in 1D, we have a complex results where the magnitude is $|\mathfrak{F}(u,v)| = \sqrt{\mathbb{R}(\mathfrak{F}(u,v))^2 + \mathbb{I}(\mathfrak{F}(u,v))^2}$ and the phase angle $\angle\mathfrak{F}(u,v) = \arctan(\mathbb{I}(\mathfrak{F}(u,v))/\mathbb{R}(\mathfrak{F}(u,v)))$.

$$
\mathfrak{F}(u,v) = \int_{-\infty}^{\infty}  \int_{-\infty}^{\infty} f(x,y) e^{-2i\pi (xu + yv)}dxdy
$$

![Fourier decomposition of images](image-18.png){width=50%}

![Repetitive patterns in an image creates repetitions in frequency domain](image-19.png){width=50%}

Removing patterns peak in frequency allows to remove periodic background.

![Mixmatch of phase and magnitude](image-20.png){width=50%}

#### Properties of spatial-frequency domain

| Spatial domain |                                               Frequency domain |
| :------------- | -------------------------------------------------------------: |
| Real           | Real part $\rightarrow$ even; Imaginary part $\rightarrow$ odd |
| Real,even      |                                            Real, even (cosine) |
| Real,odd       |                                          Imaginary, odd (sine) |

Important to remember that a convolution in spatial domain is a multiplication in the frequency domain and vice versa.

![FFT approach](image-21.png){width=50%}

We have the base image (the dot) and the the transfer function, MTF R, which contains the amplification and phase shift information to every frequency in the input image I.

#### Integrating with the convolution

Re-using the integration over a cell window:

$$
o(x',y') = \int\int i(x,y)p(x-x', y-y') dxdy \leftrightarrow i(x,y) \ast p(-x,-y)
$$

We can then transform this $p(x,y)$ round-point (as seen in the previous figure) in a $P(u,v)$


\begin{align}
    P(u,v) &= \int_{-\infty}^{\infty} e^{-i 2 \pi (ux+vy)} p(x,y) dxdy\\
    &= wh \left( \frac{\sin(\pi wu)}{\pi wu} \right) \underbrace{\left( \frac{\sin (\pi h v)}{\pi hv} \right)}_{\text{sinc}}
\end{align}


The sinc function is predominantly low-pass **and** non-causal (no phase shift) and it has phase reversal.

## Aliasing

This corresponds to a 2D Dirac train convolution on the grid like:

$$
f(a,b) = \int\int f(x,y) \delta(x-a, y-b) dxdy
$$

The multiplication with the 2D pulse train with a spacing of distance w and h:


\begin{align}
    &\sum_{k=-\infty}^\infty\sum_{l=-\infty}^\infty \delta(x-kw, y-lh)\\
    &\longleftrightarrow \frac{1}{wh}\sum_{k=-\infty}^\infty\sum_{l=-\infty}^\infty \delta(x-k\frac{1}{w}, y-l\frac{1}{h})
\end{align}


![Basic sampling theorem](image-22.png){width=50%}

Also, we need to do a Discrete Fourier Transform, DFT, to discretize the space and frequency. We can also use FFT to bring the complexity of the algorithm from $N^2$ to $N\log_2 N$.


\begin{align}
    &\sum_{m=0}^{M-1}\sum_{n=0}^{N-1} F(k,l) e^{2\pi i \left( \frac{km}{M} + \frac{ln}{N} \right)}\\
    &\longleftrightarrow F(k,l)= \frac{1}{MN} \sum_{m=0}^{M-1}\sum_{n=0}^{N-1} f(m,n) e^{-2\pi i \left( \frac{km}{M} + \frac{ln}{N} \right)}
\end{align}


![Periodicity assumed in both domains, might introduce false high frequencies at image boundaries](image-23.png){width=50%}

![We can have false high frequencies due to sampling](image-24.png){width=50%}

![Solution on periodicity](image-25.png){width=50%}

Again, the Shannon theorem is important in 2D as well such that the sampling distance $w,h$ along the $x,y$ axis must follow:

$$
w \leqslant \frac{1}{2 u_b} \qquad h \leqslant \frac{1}{2v_b}
$$

# Enhancement and feature detection

Strong from the knowledge of the previous section, we can do some spectral filtering. For example, if we have some white noise in an image we could apply a low pass filter on it to already remove a big part of the noise while losing a marginal part of the actual picture information. Usually, this will sorts of blur the image because sharp edges are like high-frequency information.

## Enhancement - better look of image

Typically, HDR is a form of enhancement for better contrast. A cheaper way of doing HDR is doing histogram equalisation which allows for better usage of the full dynamic range available (a bit like gamma correction I think).

### Histogram Equalisation

This will makes the image more vibrant if we exploit more of the dynamic range, we **redistribute** the intensities through a **mapping that keeps their relative order**. Ideally, we make the histogram **flat**.

![We tune the Cumulative Intensity Probability - or CPD to a flat line](image-27.png){width=50%}

We will compress the flat parts of the CPD, and expand the steepest one. But the main issue, since we move bins, we want have a flat histogram, we will just spread the bins more equally due to the **discrete nature** of the input. On top, neigboring pixels won't always have the same difference of intensities after the remapping (less problematic though).

### Deblurring or Unsharp masking

If we deblur we actually increase the image sharpness. It's *simple, linear, image independent and effective*.

![Imagine a vertical cut of image where x-axis is the pixel number and y-axis the grey-level](image-28.png){width=50%}

We see that we, indeed, make the edge steeper. Moreover, the difference between the original-smooth makes a good fit for second order derivative. This is a bit like running a diffusion process backwards.

The little over and under-shoots at the edge even magnifies the contrast (Mach band effect).

### Inverse Filtering

Now, we shift gears and go into the frequency. We have the frequency function that blurs the image with $B(u,v)$. To undo it we apply $B'(u,v)$ such that $B'(u,v)B(u,v) = 1$. Two danger here:

1. What happens for $B(u,v) = 0$
    - Use a constant at the denominator --> Spurious high-frequencies :'(
    - $B'(u,v)=B(u,v)/(B(u,v)^2 + C)$ --> Much better ! Wiener-like reduces C for larger SNR and vice versa.
2. For low $B(u,v)$ after noise was applied --> may over-fit the noise...

### Noise Suppression

#### Low pass

As introduced, we can use a low-pass filter for noise suppression. The main problem with applying this rectangular (actually a circle) window is the rippling due to the sinc function as seen here

![Rippling effect](image-29.png){width=50%}


## Features - edge and corner detections




**ABOVE SHOULD BE THE START OF CHAPTER ABOUT ENHANCEMENT AND EDGES**

P.41

#### Convolution filters

It is based on the insight that noise affects high frequencies the most due to their low SNR. To build a low-pass filter, we will use an averaging kernel such:

$$
\begin{pmatrix}
    1 & 1 & 1\\
    1 & 1 & 1\\
    1 & 1 & 1
\end{pmatrix} = \underbrace{\begin{pmatrix}
    1 & 1 & 1
\end{pmatrix} \ast \begin{pmatrix}
    1\\
    1\\
    1\\
\end{pmatrix}}_{\text{separable filter}}
$$

The two $(1,1,1)$ vectors can be seen in the *frequency* domain as $1 + 2\cos(2\pi u)$ for the horizontal domain or $1 + 2\cos(2\pi v)$ in the vertical one. The intuition for this is to look at the vector as a 1D image centered around the middle value. Finally, the convolution can be simplified in the frequency domain as:

$$
(1 + 2\cos(2\pi u))(1 + 2\cos(2\pi v))
$$

![Representation in 3D of the function](image-26.png){width=50%}

The function is purely real and low-pass with some phase reversal! We can again derivate something similar for a 5x5 kernel:

$$
(1 + 2\cos(2\pi u) + 2\cos(4\pi u))(1 + 2\cos(2\pi v) + 2\cos(4\pi v))
$$

With this one, the phase reversal is even more significant, the higher the frequency the more it looks like a sinc function. This creates more ripples and disturbing effects. Hard to get no ripple and a real low-pass for higher order functions.

From all those experiments we can draw 3 conclusions:

1. Separable filters can be implement more efficiently
2. Better to go in the frequency domain for large kernel
3. Keep it simple, mask of boolean or power of 2 are cheap!

### Binomial filters

They are here to solve the ripple and low-pass issue of the convolution filters presented before. This guarantees no phase reversal.

$$
\begin{pmatrix}
    1 & 2 & 1\\
    2 & 4 & 2\\
    1 & 2 & 1
\end{pmatrix} = \begin{pmatrix}
    1 & 2 & 1
\end{pmatrix} \ast \begin{pmatrix}
    1\\
    2\\
    1\\
\end{pmatrix} \longleftrightarrow (2 + 2\cos(2\pi u))(2 + 2\cos(2\pi v))
$$

![Gaussian filters are limit case of binomial filters](image-27.png){width=50%}{width=50%}

Note that noise removal linear filters will exhibit blurring due the fact they cannot difference noise and actual information.

### Median

Instead of averaging over using a kernel of ones, we take the median - the middle point of neighborhood of pixel. We don't create a new grey level, we take the one in the middle.

![Median filters principle - credits: southampton.ac.uk](image-28.png){width=50%}

One advantage of a median filter is the fact it is robust against outliers and it will preserve the contrast instead of smooching out all the values and making the image more blurry.

- Discard outliers
- Preserve discontinuities

But, it will loose in details (especially small areas). Moreover, give a patchy effect instead of a smooth uniform color.

### Anisotropic filters - all-in-on of filtering

This filter does:

1. Binomial smoothing between edges
2. Unsharp masking at edges

For this, we need to cover edge detection


| Operation name         |                                    Description                                    | Linear ? |
| :--------------------- | :-------------------------------------------------------------------------------: | :------: |
| Histogram equalisation |     Re-sort histogram to create a more linear Cumulative Probability Density      |    V     |
| Unsharp mask           |                                                                                   |    V     |
| Inverse Filtering      | Realize the opposite operation. Need to carefully handle low SNR with a constant. |    V     |
| Low pass               |        Removes noise since it affects more high-frequencies due to low SNR        |    V     |
| Binomial               |                      Like low-pass but avoids phase reversal                      |    V     |
| Median                 |                     Take the middle point instead of the mean                     |    X     |
| Anisotropic            |                     Binomial between edges - Unsharp at edge                      |    X     |
:Summary table of the enhancement procedures

## Enhancement and Feature Detection

### Edges

> **Definition:**
>
> Edge correspond to image locations with strong intensity changes due to:
> 
> 1. Reflectance
> 2. Orientation of shape normals (its surface) - the object's edge
> 3. Illuminations (shadow) 
>
> The hardest challenge in edge detection is linking up all the pixels into a good line drawing.

The methods cover here will be based on the gradient which gives the direction of the steepest change along as its magnitude being the rate of change:

$$
\text{gradient } = \left( \frac{\partial f}{\partial x}, \frac{\partial f}{\partial y} \right) \qquad \text{magnitude } = \sqrt{\left( \frac{\partial f}{\partial x}\right)^2 + \left( \frac{\partial f}{\partial y} \right)^2}
$$

2 methods will be covered using **isotropic** operators[^4]:

1. Locating high intensity gradient magnitude
2. Locating inflection points in the intensity profiles

[^4]: there exists other (and better) operators but too complex for this class

![With curvature being a sort of second order derivative](image-29.png){width=50%}

### Gradient

The idea is to:

1. measure the gradient **magnitude** of all the steep slopes in the image. This operator is isotropic since there are equal contribution of the x and y direction.
2. Measure the angle $\theta$ that maximizes $\frac{\partial f}{\partial x'} = \frac{\partial f}{\partial x} \cos (\theta) + \frac{\partial f}{\partial y} \sin(\theta)$ this yields $\theta_{xtr} = \tan^{-1}\left( \frac{\partial f}{\partial y} / \frac{\partial f}{\partial x} \right)$

The gradient is a non-linear operator of $\partial / \partial x$ which are linear, shift-invariant ! So this can be implemented using a convolution, the **Sobel masks** which are separable and cheap to implement. The Sobel masks are a bit like a binomial filter but with a derivative in the middle. The idea is to have a strong response for high frequencies (edges) and low response for low frequencies (flat areas).:

$$
\frac{\partial}{\partial x} = (-1,0,1) \ast (1,2,1)^\top = \begin{pmatrix}
    -1 & 0 & 1\\
    -2 & 0 & 2\\
    -1 & 0 & 1
\end{pmatrix} \qquad \frac{\partial}{\partial y} = \begin{pmatrix}
    -1 & -2 & -1\\
    0 & 0 & 0\\
    1 & 2 & 1
\end{pmatrix}
$$

From their outputs, we take the square root of the sum of their squares, take the arctan which will give us the orientation of the edge! 

Again we can move to the frequency domain where we remember we can see the vector as a 1D image centered around the middle value. The Fourier transform of the Sobel mask is:

$$
(-1,0,1) \longleftrightarrow 2i \sin(2\pi u) \qquad (1,2,1) \longleftrightarrow 2 + 2\cos(2\pi u)
$$

We see that it is pass band along the u-dir (red on the graph) and low-pass along the v-dir (green on the graph).

![Function in 3D](image-30.png){width=50%}

![Combining the two (top left: x-dir, top right: y-dir)](image-31.png){width=50%}

It is a great technique to map individual pixel edges, but cannot be perfect to edge detection. There can be gap, several pixels thick, weak or salient edges, and so on. But Sobel masks are the optimal 3 x 3 convolution filters with integer coefficients for step edge detection.

### Zero-crossing

First, we want to do edge thinning, to reduce a several pixel thick edge to only one continguous line. Once we found the gradient, we want to look at the direction giving the maximum gradient and interpolate to get these values. We can also apply the hysteresis thresholding to link up the edges. The idea is to have a high threshold for strong edges and a low threshold for weak edges. We then link the weak edges to the strong ones if they are connected.

![Canny edges](image-32.png){width=50%}

To do zero-crossing detection, we need to use second order derivative and make it equal to 0 to find inflexion points. This is linear + shift invariant (convolution) and isotropic (equal contribution of x and y). The Laplacian is sensitive to noise, so we often add a smoothing step (Gaussian) before applying the Laplacian. This is called the Laplacian of Gaussian (LoG) operator.

$$
\nabla^2 f = \frac{\partial^2 f}{\partial x^2} + \frac{\partial^2 f}{\partial y^2} = 0
$$


We can also use the Difference of Gaussian (DoG) which is a good approximation of the LoG and is much faster to compute. The idea is to take the difference between two Gaussian blurred images with different standard deviations.

$$
G_1 = \begin{pmatrix}
    0 & 1 &0 \\
    1 & -4 & 1\\
    0 & 1 & 0
\end{pmatrix} \qquad G_2 = \begin{pmatrix}
    1 & 2 & 1\\
    2 & -12 & 2\\
    1 & 2 & 1
\end{pmatrix}
$$

This DoG method will give us a closed-contour as it is based on the second order derivative. The zero-crossing will give us the edge location. The main issue is that it is not very good at linking up edges and can be quite sensitive to noise.

### Harris corner detection

This method will distinguish between homogeneous areas, edges and corners. The idea is to look at the eigenvalues of the second moment matrix of the gradient. If both eigenvalues are small, we have a homogeneous area. If one eigenvalue is large and the other is small, we have an edge. If both eigenvalues are large, we have a corner. The second order moment matrix is given by:

$$
\begin{pmatrix}
    \left(\frac{\partial f}{\partial x}\right)^2 & \frac{\partial f}{\partial x} \frac{\partial f}{\partial y}\\
    \frac{\partial f}{\partial x} \frac{\partial f}{\partial y} & \left(\frac{\partial f}{\partial y}\right)^2
\end{pmatrix}
$$

![Principle of Harris](image-33.png){width=50%}

The idea is to find the directions of minimal and maximal change in the image. We move the kernel by a small amount (u,v) where our $w$ window function can be either a box or a Gaussian. We then look at the change in intensity which is given by:

$$
E(u,v) = \sum_{x,y} w(x,y) [f(x+u, y+v) - f(x,y)]^2
$$

$$
E(u,v) \approx [u,v] M \begin{bmatrix}
    u\\ v
    \end{bmatrix} \qquad \text{with } M = \sum_{x,y} w(x,y) \begin{pmatrix}
    \left(\frac{\partial f}{\partial x}\right)^2 & \frac{\partial f}{\partial x} \frac{\partial f}{\partial y}\\
    \frac{\partial f}{\partial x} \frac{\partial f}{\partial y} & \left(\frac{\partial f}{\partial y}\right)^2
\end{pmatrix}
$$

To analyze the harris detector, we use the iso-lines $= det -k trace^2 = \lambda_1 \lambda_2-k(\lambda_1 + \lambda_2)^2$. Where $\lambda_1$ and $\lambda_2$ are the eigenvalues of the matrix $M$ and represent a change in one or the other direction. If the iso-line is positive, we have a corner. If it is negative, we have an edge. If it is zero, we have a homogeneous area. The main issue with this method is that it is not very good at distinguishing between edges and corners in the presence of noise.

![Iso-lines for Harris](image-34.png){width=50%}

\newpage
\part{Modern Image Analysis}
