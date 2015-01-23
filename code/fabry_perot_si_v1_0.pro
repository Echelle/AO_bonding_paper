pro fabry_perot_Si_v1_0

;Author: gully
;date: Feb 21, 2013
;desc: This program makes a Fabry Perot model for the Si voids
; in between bonded Si pucks
;The original prototpe for this program was an Excel spreadsheet:
; Si_optics_Feb2013

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
;6) 


;0) Import the data, manipulate the arrays [this should be a sub-function]
fn1='20130218_cary5000_Si_all.csv'
;dir1='/Users/gully/Astronomy/Silicon/ACT/transmission_tests/20130218/'
dir1='/Volumes/cambridge/Astronomy/silicon/ACT/bonding/cary5000/20130218'
cd, dir1
;at=ascii_template(fn1)
;save, at, /verbose, filename=file_basename(fn1, '.csv')+'.sav'
restore, file_basename(fn1, '.csv')+'.sav', /verbose
d=cary_5000_csv(fn1, at)


;1) Define the wavelength range
;This is easy:  just use the wavelength range of the data
wl=float(d.wl)
nwls=n_elements(wl)

;2) Set the temperature range
temp1=295.0 ;K
temp2=77.0 ;K

;3) Determine the refractive index
n1=fltarr(nwls)
n2=fltarr(nwls)
n3=fltarr(nwls)
for i=0, nwls-1 do begin
  n1[i]=sellmeier_si(wl[i], temp1)
  n2[i]=sellmeier_si(wl[i], temp2)
endfor
;plot, wl, n1, yrange=[3.4, 3.6], psym=10
;oplot, wl, n2, color='FF0000'xL, psym=10
;oplot, wl, n3, color='0000FF'xL, psym=10


;4) Calculate the Fabry-Perot Physics [This should be a sub-function]
;a) Set the gap widths 
L1=4100.0 ;nm
L2=L1 ;nm
L3=l1 ;nm

;b) Set the angles and the index of air
thet1= 0.0 ;rad
n_air=1.0

;c) Phase difference:
d1=(2.0*pi/wl)*2.0*n_air*L1*cos(thet1)
d2=2.0*pi/wl*2.0*n_air*L2*cos(thet1)
d3=2.0*pi/wl*2.0*n_air*L3*cos(thet1)

;d) Silicon reflectance (Fresnel losses at 1 interface)
R1=((n1-1.0)/(n1+1.0))^2.0
R2=(n2-1.0)^2.0/(n2+1.0)^2.0
R3=(n3-1.0)^2.0/(n3+1.0)^2.0

;e) The predicted transmission for a DSP puck has Fresnel losses at 2 interfaces:
fresnel_T1=(1.0-R1)*(1.0-R1)
fresnel_T2=(1.0-R2)*(1.0-R2)
fresnel_T3=(1.0-R3)*(1.0-R3)

;f)The transmission through the Fabry-Perot etalon depends on the coefficient of finesse:
F1=4.0*R1/((1.0-R1)^2.0)
F2=4.0*R2/((1.0-R2)^2.0)
F3=4.0*R3/((1.0-R3)^2.0)

;g) The etalon transmission is then:
Te1= 1.0 / (1.0+F1*sin(d1/2.0)*sin(d1/2.0))
Te2= 1.0 / (1.0+F2*sin(d2/2.0)^2.0)
Te3= 1.0 / (1.0+F3*sin(d3/2.0)^2.0)

;h) Plot it

device, decomposed=0
outname='/Volumes/cambridge/Astronomy/latex/AO_fabry_2014/figs/SiIndexAOmgsFinesseFig.eps'
psObject = Obj_New("FSC_PSConfig",/Color, /Helvetica, /Bold, Filename=outname, xsize=7.0, ysize=3.5, /encapsulate)
thisDevice = !D.Name
Set_Plot, "PS"
!p.font=0
Device, _Extra=psObject->GetKeywords()

nc=10
c1=ceil(findgen(nc)/nc*255)

xtit=greek('lambda', /append_font)+' (nm)'
device, /helvetica
ytit='Etalon transmission'
!p.thick = 3
!x.thick = 3
!y.thick = 3
!z.thick = 3

!p.multi=[0, 2, 1, 0, 1]
Polyfill, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=cgColor('Papaya');'Pale Goldenrod')

loadct, 13
plot, wl, n1, xtitle=xtit, ytitle='n', thick=3.0, charthick=2.0,$
 yrange=[3.4, 3.6], linestyle=0, title='Si Refractive Index', /noerase, $
 xrange=[1200.0, 2500.0], xstyle=1, charsize=0.8
 oplot, wl, n2, color=255, thick=3, linestyle=1
legend, [ strcompress('T= '+string(fix(temp1))+' K'), $
          string(fix(temp2))+' K'], colors=[0, 255], $
          linestyle=[0, 1], /TOP_LEGEND, thick=3, /right_legend
 
!p.multi=[1, 2, 1, 0, 1]
!p.thick = 3
!x.thick = 3
!y.thick = 3
!z.thick = 3
tit='Coefficient of Finesse'

plot, wl, F1, xtitle=xtit, ytitle='F', thick=3.0, charthick=2.0,$
 yrange=[2.4, 2.7], linestyle=0, title=tit, /noerase, $
 xrange=[1200.0, 2500.0], xstyle=1, charsize=0.8
oplot, wl, F2, color=255, linestyle=1, thick=3

;plot, wl, Te1, xtitle=xtit, ytitle=ytit, thick=3.0, charthick=2.0,$
; yrange=[0.00, 1.00], psym=10, title=tit, /noerase, $
; xrange=[1100.0, 2500.0], xstyle=1, xticks=4
;oplot, wl, Te2, color=40, psym=10, thick=3
;oplot, wl, Te3, color=255, psym=10, thick=3


sharpcorners, thick=4 
Device, /Close_File
Set_Plot, thisDevice
Obj_Destroy, psObject

!P.multi=0
device, decomposed=0
outname='/Volumes/cambridge/Astronomy/latex/AO_fabry_2014/figs/fresnel_Si_index.eps'
psObject = Obj_New("FSC_PSConfig",/Color, /Helvetica, /Bold, Filename=outname, xsize=4.0, ysize=3.5, /encapsulate)
thisDevice = !D.Name
Set_Plot, "PS"
!p.font=0
Device, _Extra=psObject->GetKeywords()

nc=10
c1=ceil(findgen(nc)/nc*255)

!p.thick = 3
!x.thick = 3
!y.thick = 3
!z.thick = 3

xtit=greek('lambda', /append_font)+' (nm)'
device, /helvetica
ytit='DSP Transmission'

Polyfill, [1,1,0,0,1], [1,0,0,1,1], /NORMAL, COLOR=cgColor('Papaya');'Pale Goldenrod')

tit='Fresnel transmission prediction'
plot, wl, fresnel_t1, xtitle=xtit, ytitle=ytit, thick=3.0, charthick=2.0,$
 yrange=[0.45, 0.55], psym=10, title=tit, /noerase, $
 xrange=[1200.0, 2500.0], xstyle=1, xticks=4
oplot, wl, fresnel_t2, color=40, psym=10, thick=3
oplot, wl, d.dat[2, *]/100.0, linestyle=1
oplot, wl, d.dat[16, *]/100.0, linestyle=2

sharpcorners, thick=4
Device, /Close_File
Set_Plot, thisDevice
Obj_Destroy, psObject


print, 1


end


function cary_5000_csv, in_fn, asc_template
;This function takes in the Cary 5000 formatted csv file, and an ascii_template
;The function outputs a structure with wavelength and data array

fn1=in_fn
at=asc_template

d=read_ascii(fn1, template=at)

;Manipulate the array.

;a) The first two lines are header info.
hdr=d.field01[*, 0]  
gi=where(hdr ne '')
ti=where(hdr eq '')
names=hdr[gi]

;b) Round up the numbers in d.field01
;find what the data sampling is:
wl_si=where(strpos(d.field01[0, *], 'Start (nm)') eq 0) 
wl_ei=where(strpos(d.field01[0, *], 'Stop (nm)') eq 0)
wl_ii=where(strpos(d.field01[0, *], 'UV-Vis Data Interval (nm)') eq 0)
wl_start=float(strmid(d.field01[0, wl_si[0]], 11))
wl_stop=float(strmid(d.field01[0, wl_ei[0]], 10))
wl_interval=float(strmid(d.field01[0, wl_ii[0]], 26))

n_wls= (wl_start-wl_stop) / wl_interval
dat=float(d.field01[ti, 2:2+n_wls])

;c) While we're at it let's figure out the collection times:
coll_t=where(strpos(d.field01[0, *], 'Collection Time:') eq 0)
times=strarr(n_elements(coll_t))
for i=0, n_elements(coll_t)-1 do begin
  times[i]= strmid(d.field01[0, coll_t[i]], 16)
endfor  

ids=string(indgen(n_elements(names)))
print, '------------------------------------'
print, '----------Collection times----------'
print, transpose([[ids],[names],[times]])
print, '------------------------------------'
print, '------------------------------------'

;d) We only need one wavelength array:
wl=d.field01[0, 2:2+n_wls]

;e) Transpose, so wavelength is increasing
wl=reform(wl)
wl=reverse(wl)
dat2=reverse(dat, 2)

ret_struct={wl:wl, dat:dat2}

return, ret_struct

end
