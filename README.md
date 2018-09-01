# Master Thesis Project

## Introduction

Any design activity starts from sketching. In the visual domain, sketches effectively communicate verbal and non-verbal expressions as writings and drawings, whereas in the sonic domain, they are conveyed as speech and imitations. In order to create novel interaction paradigms for sound designers, it is crucial to understand and exploit the potential of vocal imitations. This Master's project contributes to the academic research by investigating the automatic extraction of articulatory parameters from audio files of everyday sounds vocally imitated by actors. In particular, three such parameters, namely *myoelastic*, *phonation* and *turbulent* are introduced. Thus, the overall goal of the application at hand is to create a classification system which is able to automatically determine whether or not an audio file exhibits aforementioned parameters.

## How to get stared

Before being able to run the program, the source files (located in the *Files* directory) have to be obtained by writing a request to *martin.hellwagner@gmail.com*.

1. Open `main.m` in [MATLAB](https://www.mathworks.com/products/matlab.html).
2. Execute `main.m` in the correct folder (see below).
3. Specify which parameter you want to run the program for.
4. Should the annotated fragments already have been extracted, they are saved in the *Fragments* directory. If so, the program will query if they should be overwritten or not.
5. Specify if you want to downsample the fragments (thus making the program faster). The original sampling rate is 48 kHz. Hence, a downsample factor of 2 would result in a new sampling rate of 24 kHz.

Please make sure sure that either the **MATLAB** working directory is switched to the folder containing `main.m` or that this folder is added to the program's paths. Do not change the original folder structure, as the program is specifically tailored thereto.

Since a lot of fragments have to be processed, the computation of the features takes a while, especially if no downsampling is chosen. Please be patient and do not close the program by force. The algorithm has been extensively tested to prevent any errors and crashes.

## One more thing

You are invited to check out the corresponding Master's thesis [here](https://github.com/martinhellwagner/master-thesis-project/blob/master/Thesis.pdf).
