RGEDFIL ;MSC/IND/DKM - Text file editor ;20-Jan-2015 13:23;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 N RGFIL
 R "Filename to edit: ",RGFIL:$G(DTIME,999999),!!
 I RGFIL'="",RGFIL'["^" D ENTRY(RGFIL)
 Q
 ;=================================================================
 ; RGFIL = Name of input file
 ; RGOUT = Name of output file.  If missing, defaults to same as
 ;         input file (i.e., input file is overwritten).
 ;=================================================================
ENTRY(RGFIL,RGOUT) ;
 N RGZ,RGZ1
 I $$NEWERR^%ZTER N $ET S $ET=""
 D HOME^%ZIS
 U IO W !
 S U="^",@$$TRAP^RGUTOS("ERROR^RGEDFIL")
 K ^TMP("RGEDFIL",$J)
 I $G(RGFIL)="" S RGZ=1 G DONE:$G(RGOUT)=""
 E  D
 .W "Reading file...",!!
 .D OPEN^RGUTOS(.RGFIL,"R")
 .F RGZ=1:1 Q:$$READ^RGUTOS(.RGZ1,RGFIL)  S ^TMP("RGEDFIL",$J,RGZ,0)=RGZ1
 .D CLOSE^RGUTOS(.RGFIL)
 S RGZ=RGZ-1,^TMP("RGEDFIL",$J,0)=U_U_RGZ_U_RGZ
 D ENTRY^RGED($NA(^TMP("RGEDFIL",$J)),"Text File Editor  Version 1.5",RGFIL,$S('$D(RGOUT):"DEFAULT",RGOUT'="":"DEFAULT",1:"BROWSE"))
 I '$P(^TMP("RGEDFIL",$J,0),U,5) W "No changes made.",!! G DONE
 S:$G(RGOUT)="" RGOUT=RGFIL
 D OPEN^RGUTOS(.RGOUT,"W")
 U RGOUT
 S RGZ1=-1
 F RGZ=0:0 S RGZ1=RGZ1+1,RGZ=+$O(^TMP("RGEDFIL",$J,RGZ)) Q:'RGZ  W ^(RGZ,0),!
 D CLOSE^RGUTOS(.RGOUT)
 W RGZ1," line",$S(RGZ1=1:"",1:"s")," written to ",RGOUT,!
DONE K ^TMP("RGEDFIL",$J)
 Q
ERROR U IO
 W !!,"Error opening """_RGFIL_"""",!!
 Q
