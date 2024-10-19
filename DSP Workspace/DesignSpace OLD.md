# Adaptive filtering design spaces

## Static Environment Design Subspacing

Dimensions
- Sampling frequency
- Time span
- Interference Amplitude
- Interference Frequency

## Dynamic Environment I Design Subspacing

Dimensions
- Sampling Frequency
- Timespan
- Interference Amplitude
- Interference Frequency
- Signal Sample

## Dynamic Environment II Design Subspacing

Dimensions
- Sampling Frequency
- Timespan
- Interference Amplitude
- Interference Frequency
- Frequency Characterization: Continuous + Discrete; Slow, Medium, Fast

## LMS Design Subspacing

Dimensions:
- Filter Order
- Step Size
- Sample Delay

## RLS Design Subspacing

Dimensions:
- Filter Order
- Step Size
- Sample Delay
- **Regularization Parameter (P : $\delta = P^{-1}$ -- Initial value of filter coeff)**
- **Lambda** 

## Subspace Outputs

Dimensions:
- Learning curves (Plot of Error Func)
- Convergence Rate

## Space Config

- Fs: 8 kHz
- Time Span: 5 seconds
- SNR: Low, High (set via amplitude)
- Interference frequency: 1 Hz (visual example), 200 Hz, 2000 Hz



Look for mu 1e-3 1e-4
- Superimpose
- Look at intermediate mu
- Look at M

Effective parameters
- M
- step size/rls parameters
- SNR

Look to plol the correlation of the speech samples

- Self-correlation matrix
- (-1 to 1)
- Use matrix value to determine point-to-point correlation
- Can only do it for different samples of points

