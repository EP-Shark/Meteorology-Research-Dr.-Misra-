begin
; Read data
   fnam = "Fl_to_NC_coast_Landfall_frequency.txt"
   nrow = numAsciiRow(fnam)
   ncol = numAsciiCol(fnam) 
   data = asciiread(fnam,(/nrow,ncol/),"float")
   dt = data(:,1)
   print(dt)
   tt   = ispan(1,174,1)

; set 'eemd' options
 
   nrep  = 250                    ; No. of replications
   nimf  = 10                     ; nimf=0 , function will calculate
   noise = 0.2
   dims  = 0
   opt   = False

   et           = eemd(dt,nimf,nrep,noise,opt,dims)     ; (nimf,N) 
   et@long_name = "EEMD"
   printVarSummary(et)
   printMinMax(et,0)

   dime  = dimsizes(et)
   NIMF  = dime(0)                               ; if input nimf=0 (NIMF is calculated)
   NN    = dime(1)                               ; same as N

   asciiwrite ("imf1_Fl_to_NC.txt", et(0,:))
   asciiwrite ("imf2_Fl_to_NC.txt", et(1,:))
   asciiwrite ("imf3_Fl_to_NC.txt", et(2,:))
   asciiwrite ("imf4_Fl_to_NC.txt", et(3,:))
   asciiwrite ("imf5_Fl_to_NC.txt", et(4,:))
   asciiwrite ("imf6_Fl_to_NC.txt", et(5,:))
   asciiwrite ("imf7_Fl_to_NC.txt", et(6,:))
   asciiwrite ("imf8_Fl_to_NC.txt", et(7,:))
   asciiwrite ("imf9_Fl_to_NC.txt", et(8,:))
   asciiwrite ("imf10_Fl_to_NC.txt", et(9,:))

; plot
;======================================================================================
   wks   = gsn_open_wks("png","eemd")            ; send graphics to PNG file
   res   = True

   res@vpHeightF = 0.4                           ; change aspect ratio of plot
   res@vpWidthF  = 0.75                 
   res@vpXF      = 0.15                          ; start plot at x ndc coord 
   res@xyLineColor = "Blue"
   res@xyLineThicknessF = 2.0
                                                 ; for aesthetic purposes only
   res@trXMinF   = min(tt) - 10*(tt(1)-tt(0))    ; extra space at left  boundary
   res@trXMaxF   = max(tt) + 10*(tt(1)-tt(0))    ; extra space at right boundary
   
; Actual Data

   res@tiMainString = "Precipitation"
   plt  = gsn_csm_xy(wks,tt,dt,res)              ; raw data
   delete(res@tiMainString)

; plot each IMF

   plot = new (NIMF,"graphic")

   res           = True
   res@gsnDraw   = False                         ; don't draw
   res@gsnFrame  = False                         ; don't advance frame
   res@xyLineColor = "Blue"
   res@xyLineThicknessF = 2.0

;  res@trXMinF = 10176
;  res@trXMaxF = 10416

   do ni=0,NIMF-1                                ; loop over each IMF
      et@long_name = "NIMF_"+(ni+1)
      printMinMax(et(ni,:),0)                    
      delete(et@long_name)                        ; do not want on plot
      plot(ni) = gsn_csm_xy(wks,tt(:),et(ni,:),res)  ; each IMF
   end do

; create panel of IMFs

  resP = True                                          ; modify the panel plot
  resP@gsnMaximize           = True
  resP@gsnPanelXWhiteSpacePercent = 4
  resP@gsnPanelMainString    = "EEMD: Time Series"        ; new resource added in NCL V6.4.0
  resP@gsnPanelFigureStrings = "IMF "+ispan(1,NIMF,1)  ; add strings to panel
  resP@gsnPanelFigureStringsJust = "TopLeft"           ; new resource added in NCL V6.4.0
  gsn_panel(wks,plot,(/5,2/),resP)                     ; now draw as one plot
end
