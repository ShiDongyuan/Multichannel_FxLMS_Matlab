# User Guide of a MATLAB Program for Multichannel Filtered Reference Least Mean Square Algorithm

## Introduction
Multichannel filtered reference least mean square (McFxLMS) algorithms are widely utilized in adaptive multichannel active noise control (MCANC) applications. As a critical and high-computationally efficient adaptive critical algorithm, it also typically works as a benchmark for comparative studies of the new algorithms proposed by peers and researchers. However, up to now, there are few open-source codes for the FxLMS algorithm, especially for large-count channels. Therefore, this work provides a MATLAB code for the McFxLMS algorithm, which can be used for the arbitrary number of channels system.

## Theoretical Background
- The McFxLMS algorithm is essential for noise cancellation in complex acoustic environments.
Active noise control (ANC) is a mechanism used to address low-frequency noise issues based on the principle of acoustic wave superposition~\cite{dongyuan2020algorithms}. The ANC system artificially generates an anti-noise wave that has the same amplitude but the reverse phase of the noise wave, which interferes with the disturbance destructively.

-In general, the ANC system can be classified as feedforward structure and feedback structure. The feedforward structure implements the reference microphone and the error microphone to generate anti-noise that can dynamically match with the variation of the primary noise, which allows it to deal with many noise types. Moreover, the ANC system also can be referred to as single-channel ANC~\cite{shi2016systolic} or multichannel ANC based on the number of secondary sources used. Compared to single-channel ANC, multichannel ANC is implemented to gain a larger quiet zone through multiple secondary sources and error microphones. 

-The FxLMS is among the most practical adaptive algorithms proposed to compensate for the influence of the secondary path in an ANC system. Figure 1 shows the block diagram of the multichannel FxLMS algorithm, which has $J$ reference microphones, $K$ secondary sources, and $M$ error microphones. The control filter matrix is given by  

\begin{equation}
    \mathbf w(n) = \begin{bmatrix}
        \mathbf{w}_{11}^T(n) & \mathbf{w}_{12}^T(n) & \cdots & \mathbf{w}_{1J}^T(n) \\
        \mathbf{w}_{21}^T(n) & \mathbf{w}_{22}^T(n) & \cdots & \mathbf{w}_{2J}^T(n) \\
        \vdots & \vdots & \ddots & \vdots \\
        \mathbf{w}_{K1}^T(n) & \mathbf{w}_{K2}^T(n) & \cdots & \mathbf{w}_{KJ}^T(n)
    \end{bmatrix} \in \mathbb{R}^{K \times JN},
\end{equation}

- The document covers the principles and effectiveness of active noise control, emphasizing the algorithm's role.

## Code Explanation
### Key MATLAB Files
- `Control_filter.m`: Defines a class for the control filter of the ANC system.
- `Multichannel_FxLMS.m`: Specifies properties and functions of the multichannel ANC system.
- `Four_MCANC.m`: Main program for testing the McFxLMS algorithm.

### Functions and Their Use
- `Multichannel_FxLMS.m`
- Initialization functions for setting system properties.
- Functions for generating anti-noise signals and updating filter coefficients.
- Methods for retrieving control filter coefficients.

## Testing and Simulation
- `Four_MCANC.m`
- Examples include simulations of a 4-channel collocated ANC system.
- Instructions for setting up primary and secondary paths, generating reference and disturbance signals.

## Conclusion
The guide provides a detailed overview of creating and using a MATLAB program for active noise control using the McFxLMS algorithm.
