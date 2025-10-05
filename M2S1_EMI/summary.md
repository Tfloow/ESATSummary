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