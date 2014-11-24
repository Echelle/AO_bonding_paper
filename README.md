# Fabry-Perot Metrology of Compound Silicon Optics

This is a paper on the Fabry-Perot technique applied to Si compound optics.

### Authors

* Michael Gully-Santiago, University of Texas at Austin, Dept. of Astronomy
* Dan Jaffe, University of Texas at Austin, Dept. of Astronomy

### Compiling

Basically, you will need to mimic my directory structure for all this to work.  For now I have everything that is static in the .gitignore file.  Just type:

`Make`

### Figures and source code

Here is the list of figures and the code that created them.  All of the code is in IDL.


1. SiIndexAOmgsFinesseFig.pdf - `fabry_perot_si_v1_0.pro`
	This two-panel figure shows the refractive index on the left and the Coefficient of Finesse on the right.  Both are continuous functions of wavelength, and plotted for 2 temperatures- room temp and 77 K (100 C is slated for removal).
2. fpAbsorbfig.pdf - `fpAbsorbFig.pro`
This two panel figure shows the directly measured absorption as a function of wavelength for Silicon.  The panels are basically showing the same thing on linear and log scales.

3. 20140421_absolute.pdf - `fabry_perot_Si_20140421x.pro`
This figure shows the theoretical absolute transmission through DSP silicon, taking into account multiple incoherent reflections.  Two other curves show the reduced transmission for small gaps.

~~4. 20140421_absoluteB.pdf - `fabry_perot_Si_20140421x.pro`
Similar to Figure 3, but with normalized transmission scale.~~

~~5. 20140421_absoluteC.pdf - `fabry_perot_Si_20140421x.pro`
Similar to Figure 4, but with larger gap sizes.~~

4. Rel_etalon_trans_stack.pdf - `fabry_perot_Si_20140421c.pro`
*Figures 4 and 5 replaced with a single figure with a shared axis.*

6. VS20fineGapCrop.pdf - *Screenshot from Veeco software*.
Shows how we measure the mesh gap sizes.

7. 20130911_VS21posM1.pdf - `fabry_perot_Si_20130911.pro`
Shows measurement and prediction bands for known gaps

8. 20130911_VS21posM1.pdf - `fabry_perot_Si_20130911.pro`
Shows measurement and prediction bands for known gaps in a different sample

### License

Copyright 2013, 2014 by the authors.  **All rights reserved.**
