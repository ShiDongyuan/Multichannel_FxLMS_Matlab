# User Guide of a MATLAB Program for Multichannel Filtered Reference Least Mean Square (McFxLMS) Algorithm

## Introduction
Multichannel filtered reference least mean square (McFxLMS) algorithms are widely utilized in adaptive multichannel active noise control (MCANC) applications. As a critical and high-computationally efficient adaptive critical algorithm, it also typically works as a benchmark for comparative studies of the new algorithms proposed by peers and researchers. However, up to now, there are few open-source codes for the FxLMS algorithm, especially for large-count channels. Therefore, this work provides a MATLAB code for the McFxLMS algorithm, which can be used for the **<font color=#FF000>arbitrary number</font>** of channels system.

## Theoretical Background
- The McFxLMS algorithm is essential for noise cancellation in complex acoustic environments.
Active noise control (ANC) is a mechanism used to address low-frequency noise issues based on the principle of acoustic wave superposition. The ANC system artificially generates an anti-noise wave that has the same amplitude but the reverse phase of the noise wave, which interferes with the disturbance destructively.

- In general, the ANC system can be classified as feedforward structure and feedback structure. The feedforward structure implements the reference microphone and the error microphone to generate anti-noise that can dynamically match with the variation of the primary noise, which allows it to deal with many noise types. Moreover, the ANC system also can be referred to as single-channel ANC or multichannel ANC based on the number of secondary sources used. Compared to single-channel ANC, multichannel ANC is implemented to gain a larger quiet zone through multiple secondary sources and error microphones.

- The target multichannel active noise control (MCANC) system is assumed to have $J$ reference microphones, $K$ secondary sources, and $M$ error microphones. According to the gradient decent method, the $kj$ th control filter is obtained from
  $$\mathbf{w}\_{kj}(n + 1)=\mathbf{w}\_{kj}(n)+\mu\sum\_{m=1}^{M} e_m(n) \mathbf{x}'\_{jkm}(n),$$
  
  where $\mu$ and $e_m$ denote the step size and the $m$-th error signal respectively. The filtered reference signal is given by 
  $$x\_{jkm}'(n)=\hat{s}\_{mk}(n)*x\_j(n).$$
  
  In the equation, $\hat{s}\_{mk}(n)$ represents the impulse response of the $mk$-th secondary path, and $x\_j(n)$ is the reference signal picked by the $j$-th reference microphone. This Matlab Code is used to implement the above algorithm.  


## Code Explanation
### Key MATLAB Files
- [`Four_MCANC.m`](#testing-and-simulation): Main program for testing the McFxLMS algorithm.
- [`Multichannel_FxLMS.m`](#the-explanation-of-multichannel_fxlmsm): The code of the multichannel filterd reference least mean sqaure (McFxLMS) algorithm.
- `Control_filter.m`: The code of the control filter in the adaptive algorithm.
- `\path`: The data folder that ontains the measured primary paths and secondary paths.

---
### The explanation of `Multichannel_FxLMS.m` 
 `Multichannel_FxLMS.m` realizes the McFxLMS algorithm with arbitrary channels. It has following functions: 
- `Multichannel_FxLMS()`: Initialization functions for setting system properties.
- `FxLMS_cannceller()`: Functions for generating anti-noise signals and updating filter coefficients.
- `Get_coefficients()`: Methods for retrieving control filter coefficients.

## Testing and Simulation
- `Four_MCANC.m` provides an example of using the code of the McFxLMS algorithm.
- Instructions for setting up primary and secondary paths, generating reference and disturbance signals.
- The following code segment shows a simple example of the usage of the McFxLMS code. 

| Parameter | Definition                        | Parameter | Definition                                  |
|-----------|-----------------------------------|-----------|---------------------------------------------|
| Wc        | Control filter Matrix [Lc xK x J] | Sec       | Secondary path estimate Matrix [Ls x M x K] |
| muW       | Step size                         | Red       | Reference signal Matrix [J x N]             |
| Dir       | Disturbance Matrix [M x N]        |           |                                             |

  ```matlab
  %% Multichannel FxLMS algorithm 
  %---Wc [Filter length x Control unit/ microphone x Reference microphone number]
  %---Sec[Filter length x Error number x Speaker number]
  a = Multichannel_FxLMS(Wc,Sec,muW);
  %---Red is referernce  [Reference microphone number x signal length]
  %---Dir is Disturabnce [Error microphone number x signal length]
  [E,a]= a.FxLMS_cannceller(Red,Dir);
  ```

## Conclusion
The guide provides a detailed overview of creating and using a MATLAB program for active noise control using the McFxLMS algorithm.

## Reference 
``` bibtex
@article{shi2020algorithms,
  title={Algorithms and implementations to overcome practical issues in active noise control systems},
  author={Shi, Dongyuan},
  year={2020},
  publisher={Nanyang Technological University}
}
```
