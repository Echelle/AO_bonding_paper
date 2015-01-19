pro fabry_perot_Si_20140421c

;Author: gully
;date: August 5, 2013
;desc: This program makes a Fabry Perot model for the Si voids
; in between bonded Si pucks
;This program is based on fabry_perot_Si_v3_0
;Editted on April 21, 2014 to make figures for the AO paper.

pi=3.14159265D0

;Outline / pseudocode

;0) Import the data, manipulate the arrays [this should be a sub-function]
;1) Define wavelength range
;2) Set the range of temperature
;3) Determine the refractive index
;4) Calculate the Fabry-Perot Physics [This should be a sub-function]
;[4.1) Set the Si absorption per unit length]
;4.2) Set the gap widths
;5) Plot the data and overlay the models 

;1) Wavelength
wl= 1200.0 + 2.0*findgen(650);float(d.wl)
nwls=n_elements(wl)


;-----Values------
 plottit=' ' 
 outname='Astronomy/Latex/AO_bonding_paper/figs/Rel_etalon_trans_stack.eps'
;------------------


;---------------------
;2) Physics here:
T_imr0 = incoh_mult_reflect_v2_0(wl, 0.0)
t0=T_imr0.t_net

pred1 = incoh_mult_reflect_v2_0(wl, 20.0)
pred2 = incoh_mult_reflect_v2_0(wl, 35.0)
pred3 = incoh_mult_reflect_v2_0(wl, 60.0)
pred4 = incoh_mult_reflect_v2_0(wl, 350.0)
pred5 = incoh_mult_reflect_v2_0(wl, 3500.0)
;---------------------


;---------------------
;3) Plots
;---------------------
device, decomposed=0
psObject = Obj_New("FSC_PSConfig",/Color, /Helvetica, /Bold, $
            Filename=outname, xsize=4.0, ysize=8.0, /encapsulate)
thisDevice = !D.Name
Set_Plot, "PS"
!p.font=0
Device, _Extra=psObject->GetKeywords()

!x.thick=3.0
!y.thick=3.0
!z.thick=3.0
!p.thick=3.0

nc=10
c1=ceil(findgen(nc)/nc*255)

xtit=greek('lambda', /append_font)+' (nm)'
device, /helvetica

Polyfill, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=cgColor('Papaya');'Pale Goldenrod')
 !p.multi=[0,1,2,0,0]    

loadct, 13
multiplot,[1,3]

plot, wl, wl*0.0, ytitle='Absolute Transmission', thick=3.0, charthick=2.0,$
 yrange=[0.5, 0.56], psym=10, $
 xrange=[1200.0, 2500.0], xstyle=1, ystyle=1, /nodata, /noerase

oplot, wl, pred1.t_dsp, color=0, linestyle=0, thick=3.0
oplot, wl, pred1.t_net, color=50, linestyle=1, thick=3.0
oplot, wl, pred2.t_net, color=100, linestyle=2, thick=3.0
oplot, wl, pred3.t_net, color=150, linestyle=3, thick=3.0


AL_Legend, ['No gap', '20 nm gap', '35 nm gap', '60 nm gap'], $
linestyle=[0, 1, 2, 3], thick=[3,3,3,3], Color=[0, 50, 100, 150], Position=[1250,0.557]   


multiplot

plot, wl, wl*0.0, ytitle='Gap Transmission', thick=3.0, charthick=2.0,$
 yrange=[0.9, 1.01], psym=10, $
 xrange=[1200.0, 2500.0], xstyle=1, ystyle=1, /nodata, /noerase

oplot, wl, pred1.t_dsp/pred1.t_dsp, color=0, linestyle=0, thick=3.0
oplot, wl, pred1.t_net/pred1.t_dsp, color=50, linestyle=1, thick=3.0
oplot, wl, pred2.t_net/pred2.t_dsp, color=100, linestyle=2, thick=3.0
oplot, wl, pred3.t_net/pred3.t_dsp, color=150, linestyle=3, thick=3.0   

multiplot
    
plot, wl, wl*0.0, xtitle=xtit, ytitle='Gap Transmission', thick=3.0, charthick=2.0,$
 yrange=[0.0, 1.04], psym=10, xticks=5, $
 xrange=[1200.0, 2500.0], xstyle=1, ystyle=1, /nodata, /noerase

oplot, wl, pred3.t_dsp/pred3.t_dsp, color=0, linestyle=0, thick=3.0
oplot, wl, pred3.t_net/pred3.t_dsp, color=150, linestyle=3, thick=3.0
oplot, wl, pred4.t_net/pred3.t_dsp, color=225, linestyle=4, thick=3.0
oplot, wl, pred5.t_net/pred3.t_dsp, color=255, linestyle=5, thick=3.0

AL_Legend, ['No gap','60 nm gap', '350 nm gap', '3500 nm gap'], $
linestyle=[0, 3, 4, 5], thick=[3,3,3,3], Color=[0,150, 225, 255], Position=[1250,0.39] 


multiplot,/reset      

Device, /Close_File
Set_Plot, thisDevice
Obj_Destroy, psObject

print, 1



end


function incoh_mult_reflect_v2_0, wl, dgap ;input wavelength must be in nm
;author: gully
;date: 6/7/2013
;desc: figures out the multiple reflections from the front and backs of Si pucks
; this only works for incoherent multiple reflections
;input the wavelength array
;outputs the net Fresnel transmission
 

;1) Set the temperature (this doesn't matter that much for room temp)
temp1=295.0 ;K

;2) Determine the refractive index
nwls=n_elements(wl)
n1=fltarr(nwls)

for i=0, nwls-1 do begin
  n1[i]=sellmeier_si(wl[i], temp1)
endfor

;3) Silicon reflectance (Fresnel losses at 1 interface)
R0=((n1-1.0)/(n1+1.0))^2.0

;4) Coefficient of Finesse
F=4.0*R0/(1.0-R0)^2.0

delta=2.0*3.141592654*dgap/wl

T_net=2.0*n1/(1.0+2.0*n1*F*sin(delta)^2.0+n1^2.0)
T_old=1.0/(1.0+F*sin(delta)^2.0)
T_dsp=2.0*n1/(n1^2.0+1.0)

ret_struct={t_net:t_net, t_old:t_old, t_dsp:t_dsp}
return, ret_struct

end