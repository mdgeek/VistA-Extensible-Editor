RGED2 ;MSC/IND/DKM - Continuation of RGED;04-May-2006 08:19;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 ; Position cursor at current edit location
POS W $$XY^RGUT(RGED,RGY)
 Q
 ; Cursor up
UP(RGITER) ;
UP1 I RGROW=1 W $$PRMPT(-14,0) Q
 D MOVETO(RGROW-1,RGCOL)
 I $G(RGITER)>1 S RGITER=RGITER-1 G UP1
 Q
 ; Cursor down
DOWN(RGITER) ;
DOWN1 I RGROW>RGLC W $$PRMPT(-15,0) Q
 D MOVETO(RGROW+1,RGCOL)
 I $G(RGITER)>1 S RGITER=RGITER-1 G DOWN1
 Q
 ; Cursor left
LEFT(RGITER) ;
LEFT1 I RGCOL=1 D UP(),END:'RGMSG Q
 D MOVETO(RGROW,RGCOL-1)
 I $G(RGITER)>1 S RGITER=RGITER-1 G LEFT1
 Q
 ; Cursor right
RIGHT(RGITER) ;
RIGHT1 I RGCOL>$L(RGLN) D DOWN(),HOME:'RGMSG Q
 D MOVETO(RGROW,RGCOL+1)
 I $G(RGITER)>1 S RGITER=RGITER-1 G RIGHT1
 Q
 ; Word right
WRIGHT(RGITER) ;
 N RGZ
WR1 F RGZ=RGCOL:1:$L(RGLN) Q:$A(RGLN,RGZ)=32
WR2 I RGZ'<$L(RGLN) D MOVETO(RGROW+1,1) Q:RGROW>RGLC  S RGZ=0
 F RGZ=RGZ+1:1:$L(RGLN)+1 Q:$E(RGLN,RGZ)?.1A.1N
 G:RGZ>$L(RGLN) WR2
 D MOVETO(RGROW,RGZ)
 I $G(RGITER)>1 S RGITER=RGITER-1 G WR1
 Q
 ; Word left
WLEFT(RGITER) ;
 N RGZ
WL1 F RGZ=RGCOL-1:-1:0 Q:$A(RGLN,RGZ)'=32
 I 'RGZ Q:RGROW=1  D MOVETO(RGROW-1,1),END G WL1
 F RGZ=RGZ-1:-1:0 Q:$A(RGLN,RGZ)=32
 D MOVETO(RGROW,RGZ+1)
 I $G(RGITER)>1 S RGITER=RGITER-1 G WL1
 Q
 ; Move to left margin
LMAR D MOVETO(RGROW,$S(RGST(7):RGST(7),1:1))
 Q
 ; Move to beginning of line
HOME D MOVETO(RGROW,1)
 Q
 ; Move to end of line
END D MOVETO(RGROW,$L(RGLN)+1)
 Q
 ; Move to next tab stop
TAB(RGITER) ;
TAB1 S RGZ=$F($TR(RGRULER,"wn","TT"),"T",RGCOL+1)-1
 I RGZ<1 W RGBEL Q
 D INSERT^RGED0(" ",RGZ-RGCOL):RGST(16),MOVETO(RGROW,RGZ)
 I $G(RGITER)>1 S RGITER=RGITER-1 G TAB1
 Q
 ; Move to previous tab stop
BKTB(RGITER) ;
BKTB1 F RGZ=RGCOL-1:-1:0 I "wn"[$E(RGRULER,RGZ) D MOVETO(RGROW,RGZ) Q
 I RGZ<1 W RGBEL Q
 I $G(RGITER)>1 S RGITER=RGITER-1 G BKTB1
 Q
 ; Move down one page
PGDN(RGITER) ;
 S RGZ=RGROW+(RGY2-RGY1-2*$S($G(RGITER)>0:RGITER,1:1))
 I RGZ>(RGLC+1) W $$PRMPT(-15,0) S RGZ=RGLC+1
 D MOVETO(RGZ,RGCOL)
 Q
 ; Move up one page
PGUP(RGITER) ;
 S RGZ=RGROW-(RGY2-RGY1-2*$S($G(RGITER)>0:RGITER,1:1))
 I RGZ<1 W $$PRMPT(-14,0) S RGZ=1
 D MOVETO(RGZ,RGCOL)
 Q
 ; Move to top of buffer
TOP D MOVETO(1,1)
 Q
 ; Move to bottom of buffer
BTM D MOVETO(RGLC+1,1)
 Q
 ; Move to top of display
SCRTOP D MOVETO(RGTOP,RGCOL)
 Q
 ; Move to bottom of display
SCRBTM S RGZ=RGTOP+RGY2-RGY1
 D MOVETO($S(RGZ>(RGLC+1):RGLC+1,1:RGZ),RGCOL)
 Q
 ; Move to left side of display
SCRLT D MOVETO(RGROW,RGLFT)
 Q
 ; Move to right side of display
SCRRT D MOVETO(RGROW,RGLFT+RGED2)
 Q
 ; Scroll horizontally
SCRHZ N RGZ
 S RGZ=RGED2-RGED1\2,RGLFT=$S(RGST(13)=2:1,RGCOL>RGZ:RGCOL-RGZ,1:1),RGED=RGED1+RGCOL-RGLFT
 D SHOW^RGEDS,RULER^RGEDS,SHST^RGEDS(0)
 Q
 ; Scroll down
SCRDN N RGZ
 S RGZ=RGY1-RGY
 I (RGZ>(RGY2-RGY1))!(RGED<RGED1)!(RGED>RGED2) D  G SCRHZ
 .S RGY=RGY1,RGTOP=RGROW
 W $$XY^RGUT(RGED1,RGY1)
 F RGY=RGY+1:1:RGY1 D
 .W *13,RGESC_"[L"
 .S RGTOP=RGTOP-1
 .D SLINE^RGEDS(RGTOP)
 Q
 ; Scroll up
SCRUP N RGZ
 S RGZ=RGY-RGY2
 I (RGZ>(RGY2-RGY1))!(RGED<RGED1)!(RGED>RGED2) D  G SCRHZ
 .S RGY=RGY2,RGTOP=RGROW-RGY2+RGY1
 .S:RGTOP<1 RGTOP=1
 W $$XY^RGUT(RGED1,RGY2)
 F RGY=RGY-1:-1:RGY2 D
 .W $C(13,10)
 .S RGTOP=RGTOP+1
 .D SLINE^RGEDS(RGTOP+RGY2-RGY1)
 Q
 ; Move to a new buffer row and/or column
MOVETO(RGNEWR,RGNEWC) ;
 N RGZ,RGZ1,RGZ2
 S:RGNEWR<1 RGNEWR=1
 S:RGNEWC<1 RGNEWC=1
 S:RGNEWR>RGLC RGNEWR=RGLC+1
 S:RGSR1 RGSR2=RGNEWR,RGSC2=RGNEWC
 I RGNEWR'=RGROW D
 .I RGSR1 D
 ..I RGROW<RGNEWR S RGZ1=RGROW,RGZ2=RGNEWR,RGZ=RGY-1
 ..E  S RGZ1=RGNEWR,RGZ2=RGROW,RGZ=RGZ1-RGZ2+RGY-1
 ..F RGZ1=RGZ1:1:RGZ2 S RGZ=RGZ+1 Q:RGZ>RGY2  I RGZ'<RGY1 W $$XY^RGUT(RGED1,RGZ) D SLINE^RGEDS(RGZ1)
 .S ^XTMP(RGPID,RGBUF,RGROW)=RGLN
 .S RGLN=$G(^(RGNEWR))
 E  I RGSR1 D
 .I RGCOL<RGNEWC S RGZ1=RGCOL,RGZ2=RGNEWC,RGZ=RGED
 .E  S RGZ1=RGNEWC,RGZ2=RGCOL,RGZ=RGZ1-RGZ2+RGED Q:RGZ<RGED1
 .W $$XY^RGUT(RGZ,RGY)
 .F RGZ1=RGZ1:1:RGZ2 W $$RV^RGEDS(RGROW,RGZ1),$TR($E(RGLN,RGZ1),RGCTL1,RGCTL2)
 .W *13,RGNORM
 S RGY=RGY+RGNEWR-RGROW,RGROW=RGNEWR
 S RGED=RGED+RGNEWC-RGCOL,RGCOL=RGNEWC
 G SCRUP:RGY>RGY2,SCRDN:RGY<RGY1,SCRHZ:RGED<RGED1,SCRHZ:RGED>RGED2
 D POS
 Q
 ; Update current line
UPDATE S ^XTMP(RGPID,RGBUF,RGROW)=RGLN
 Q
 ; Undo changes to current line
UNDO S RGLN=^XTMP(RGPID,RGBUF,RGROW)
 D SLINE^RGEDS(RGROW)
 Q
 ; Display message / prompt for input
PRMPT(RGPRMPT,RGLEN,RGFLG,RGVALID,RGDATA) ;
 S RGFLG=$G(RGFLG),RGPRMPT=$G(RGPRMPT)
 S:RGFLG["1" RGFLG=RGFLG_"ET"
 I RGPRMPT=+RGPRMPT D
 .I RGPRMPT<0 W RGBEL S RGPRMPT=-RGPRMPT,RGITER=0
 .I RGPRMPT S RGPRMPT=$$EZBLD^DIALOG($S(RGPRMPT<10000:RGPRMPT+9960000,1:RGPRMPT))
 .E  S RGPRMPT=RGHLP
 S RGPRMPT=$E($$MSG^RGUT(RGPRMPT,"|"),1,RGST(11)-1)
 W $$XY^RGUT(0,1),RGRVON_RGPRMPT_RGEOL_$S($G(RGLEN)<0:RGBEL,1:"")
 N RGSTR,X
 S RGSTR="",RGMSG=1,$X=$L(RGPRMPT)
 S:'$D(RGLEN) RGLEN=RGED2-$X
 S:RGED2-$X<RGLEN RGLEN=RGED2-$X
 S:RGLEN=1 RGFLG=RGFLG_"T"
 W:RGFLG["1" $$XY^RGUT(RGED,RGY)
 S:RGLEN>0 RGSTR=$$ENTRY^RGUTEDT(.RGDATA,RGLEN,$X,$Y,.RGVALID,RGFLG_"R","","","",RGED2)
 W RGNORM
 D RM^RGUTOS(0)
 X ^%ZOSF("EOFF"),^%ZOSF("TRMON")
 W:RGFLG["1" $$XY^RGUT(RGED,RGY)
 Q $S($A(RGSTR)<0:"",1:RGSTR)