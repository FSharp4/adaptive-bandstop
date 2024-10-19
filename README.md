# Analysis of Adaptive FIR Filter Performance in Narrow Band Interference Suppression
> Jake Peterson & Ahmad Sawwas

This study presents an assessment of the performance of adaptive FIR filters in suppressing narrow band interferences corrupting signals with wideband desired contents. The effects of multiple parameters governing the overall system performance were considered. Adaptations were governed utilizing LMS and RLS algorithms where a comparison between both algorithms’ capabilities is presented. Simulations of both adaptation algorithms were conducted on MATLAB considering stationary and dynamic environments with different SNR levels. Results showed that, under appropriate tuning of the adaptive algorithm parameters and a suitable system delay, the FIR filter provides satisfactory results under all tested operating environments. 

Course project for ECSE 512 (Digital Signal Processing) at McGill University, Fall 2021.

# Instructions for Running Project

Please consider the following to successfully run the m-files attached to this report. 

There are 3 main folders attached. Each one of these folders contains scripts that belong to certain operating environment.

In the folder named “Stationary Environment Scripts, there are 6 MATLAB scripts. 2 of them are used to create the operating environments (“StatEnv_LSNR.m” and “StatEnv_MSNR.m”). The scripts “LMSfilter.m” and “RLSfilter.m” represents LMS and RLS algorithms implementation respectively. The script named “EnsembleMean.m” is a subfunction called in the main script to compute ensemble mean error. Finally, the script “LMSRLS.m” is a script that provides the performance of both algorithms on same plots (for comparison). To successfully run the scripts with adaptive algorithms, you must first run the script defining the operating environment (“StatEnv_LSNR.m” or “StatEnv_MSNR.m”), save the workspace as “StatEnvLSNR.mat” or “StatEnvMSNR.mat” and then update line 4 in “LMSfilter.m” and/or “RLSfilter.m” or lines 5 and 44 in “LMSRLS.m” to load that workspace. Finally, run any of the MATLAB files “LMSfilter.m”, “RLSfilter.m” or “LMSRLS.m” and observe the outputs. Note that comments are provided within the MATLAB scripts so that users can freely adjust algorithms parameters and simulate the system’s performance.

In the folder named “Dynamic Environment 1 Scripts” there are 6 MATLAB scripts and a folder of sound clips labelled “Samples”. Similarly, to successfully run those scripts, the user must first run the script “DynmEnvLSNR.m” defining the operating environment, save that workspace as “DynmEnvLSNR.mat”, and then run any of the adaptation algorithms provided. Likewise, in the folder named “Dynamic Environment 2” there are 5 MATLAB scripts. To Run these, the user should run “DynEnvMSNR”, save the MATLAB workspace as “DynEnvMSNR.mat”, and then use the desired filter script.

Make sure to clear the MATLAB workspace between switching environments to avoid errors in filtration scripts.
