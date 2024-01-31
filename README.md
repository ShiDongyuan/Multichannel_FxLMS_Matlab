# User Guide of a MATLAB Program for Multichannel Filtered Reference Least Mean Square Algorithm

## Introduction
Multichannel filtered reference least mean square (McFxLMS) algorithms are widely utilized in adaptive multichannel active noise control (MCANC) applications. As a critical and high-computationally efficient adaptive critical algorithm, it also typically works as a benchmark for comparative studies of the new algorithms proposed by peers and researchers. However, up to now, there are few open-source codes for the FxLMS algorithm, especially for large-count channels. Therefore, this work provides a MATLAB code for the McFxLMS algorithm, which can be used for the **<font color=#FF000>arbitrary number</font>** of channels system.

## Theoretical Background
- The McFxLMS algorithm is essential for noise cancellation in complex acoustic environments.
Active noise control (ANC) is a mechanism used to address low-frequency noise issues based on the principle of acoustic wave superposition. The ANC system artificially generates an anti-noise wave that has the same amplitude but the reverse phase of the noise wave, which interferes with the disturbance destructively.

- In general, the ANC system can be classified as feedforward structure and feedback structure. The feedforward structure implements the reference microphone and the error microphone to generate anti-noise that can dynamically match with the variation of the primary noise, which allows it to deal with many noise types. Moreover, the ANC system also can be referred to as single-channel ANC or multichannel ANC based on the number of secondary sources used. Compared to single-channel ANC, multichannel ANC is implemented to gain a larger quiet zone through multiple secondary sources and error microphones. 
- The document covers the principles and effectiveness of active noise control, emphasizing the algorithm's role.

## Code Explanation
### Key MATLAB Files
- `Control_filter.m`: Defines a class for the control filter of the ANC system.
- `Multichannel_FxLMS.m`: Specifies properties and functions of the multichannel ANC system.
- `Four_MCANC.m`: Main program for testing the McFxLMS algorithm.
- `\path`: Contain the measured primary paths and secondary paths.

### Functions and Their Use
- `Multichannel_FxLMS.m`
- `Multichannel_FxLMS()` Initialization functions for setting system properties.
- `FxLMS_cannceller()` Functions for generating anti-noise signals and updating filter coefficients.
- `Get_coefficients()` Methods for retrieving control filter coefficients.

## Testing and Simulation
- `Four_MCANC.m`
- Examples include simulations of a 4-channel collocated ANC system.
- Instructions for setting up primary and secondary paths, generating reference and disturbance signals.
- The following code segment shows a simple example of the usage of the McFxLMS code. 
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
