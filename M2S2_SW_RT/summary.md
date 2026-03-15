---
title: "Software for Real Time Control"
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

# Introduction 

> **Definition:**
>
> A system wherein being correct depends upon giving the correct answer within a strict deadline

From this, we can differentiate 2 types of deadlines:

- Hard: If we miss the deadline = complete failure
- Soft: If we miss the deadline = degrades performance aka expensive task to fix the error

Interfacing with real life is harder than a deterministic clocked circuits. Here, we are facing stochastic event and can be synchronous or asynchronous.

## Design procedure

![Modeling](image.png){ width=50% }

We iterate over the design; we try to have those 3 boxes to overlap as much as possible to model and understand the environment we are in. It's an iterative process

- **Modeling / What** are you measuring and controlling?
- **Design / How** will your system achieve your cyber-physical goals?
- **Analysis / Why** does your implementation exhibit this level of correctness, speed, power consumption, etc

## Developing for embedded: Challenges

The main bottleneck is energy:

- Bringing it: cables can be more expensive and less flexible than wireless IC
- Battery doesn't shrink as IC

We also need to make sure our IoT devices can be manageable and avoid spending all the costs and labor on battery management and replacement. Batteries are also toxic and corrosive.

The energy management problem:

- Energy consumption: low power sub-routine
- Energy Storage: aklaline or lipo battery ?
- Energy Production: plug socket ?