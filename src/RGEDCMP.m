RGEDCMP ;MSC/IND/DKM - Initialize key map table ;04-May-2006 08:19;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 D HOME^%ZIS
 N RGED,RGCF
REDO D TITLE^RGUT("Compile Editor Configuration",$P($T(+2),";",3))
 S RGED("ALL")="Enter ALL to compile all configurations."
 S RGCF=$$ENTRY^RGUTLKP("^RGED1","A1UP","Enter configuration to compile: ","","","","",0,3,"$G(^RGEDCFG(%S,.25))","RGED")
 W !!
 Q:(RGCF<1)&(RGCF'="ALL")
 D CMP(RGCF)
 W !!
 S RGED=$$PAUSE^RGUT
 G:RGED'=U REDO
 Q
CMP(RGCF) ;
 I RGCF="ALL" D
 .F RGCF=0:0 S RGCF=+$O(^RGEDCFG(RGCF)) Q:'RGCF  D DOIT(RGCF)
 E  D DOIT(RGCF)
 Q
ALL D CMP("ALL")
 Q
DOIT(RGCF,RGCF1) ;
 N RGV,RGV1,RGEXE,RGID,RGZ,RGZ1,RGZ2,RGZ3
 S RGID="RGEDCMP",RGCF=$S(RGCF=+RGCF:RGCF,RGCF="":0,1:$O(^RGEDCFG("B",RGCF,0)))
 Q:'RGCF
 I '$D(RGCF1) D
 .K ^RGED(RGCF),^TMP(RGID,$J)
 .S RGCF1=RGCF
 .W "Compiling configuration "_$P(^RGEDCFG(RGCF,0),U)_"...",!
 Q:$D(^TMP(RGID,$J,"C",RGCF1))
 S ^(RGCF1)=""
 D:$P(^RGEDCFG(RGCF1,0),U,9) DOIT(RGCF,$P(^(0),U,9))
 I $$NEWERR^%ZTER N $ET S $ET=""
 S @$$TRAP^RGUTOS("ERROR^RGEDCMP")
 ; Load ruler
 S:$G(^RGEDCFG(RGCF1,6))'="" ^RGED(RGCF,"R")=^(6)
 ; Load keystroke macros
 F RGZ=0:0 S RGZ=+$O(^RGEDCFG(RGCF1,3,RGZ)) Q:'RGZ  D
 .S RGV=^(RGZ,0),^TMP(RGID,$J,"K",$P(RGV,U))=$P(RGV,U,2)
 ; Compile key mappings
 F RGZ=0:0 S RGZ=+$O(^RGEDCFG(RGCF1,1,"B",RGZ)),RGTBL=$O(^(RGZ,0)) Q:'RGTBL  D
 .S:$G(^RGEDCFG(RGCF1,1,RGTBL,2))'="" ^RGED(RGCF,"K",RGZ)=^(2)
 .F RGZ1=0:0 S RGZ1=+$O(^RGEDCFG(RGCF1,1,RGTBL,1,RGZ1)) Q:'RGZ1  D
 ..S (RGV,RGV1)=^(RGZ1,0),RGEXE=$G(^(1))
 ..F RGZ2=1:1:$L(RGV1,"_") S RGZ3=$P(RGV1,"_",RGZ2) D:RGZ3?1A.E
 ...I '$D(^TMP(RGID,$J,"K",RGZ3)) W "Keystroke macro not defined:  "_RGZ3,!
 ...E  S $P(RGV1,"_",RGZ2)=^(RGZ3)
 ..S @("RGV1="_RGV1),RGV1=$$ENC(RGV1)
 ..I $D(^RGED(RGCF,"K",RGZ,RGV1)) D
 ...W ?3,"In table #"_RGTBL_", entry "_RGV_" overrides previous assignment.",!
 ..S ^RGED(RGCF,"K",RGZ,RGV1)=RGEXE
 ; Compile state definitions
 F RGZ=0:0 S RGZ=+$O(^RGEDCFG(RGCF1,2,RGZ)) Q:'RGZ  D
 .S RGV=+^(RGZ,0)
 .K ^RGED(RGCF,"S",RGV)
 .F RGZ1=0:1:2 S ^RGED(RGCF,"S",RGV,RGZ1)=$G(^RGEDCFG(RGCF1,2,RGZ,RGZ1))
 I RGCF=RGCF1 D
 .W ?3,"Compilation complete.",!
 .K ^TMP(RGID,$J)
 Q
 ; Convert character string to encoded form
ENC(X) N Y,Z,H
 S H="",X=$$UP^XLFSTR(X)
 F Y=1:1:$L(X) D
 .S Z=$A(X,Y),H=H_$C(Z\16+65)_$C(Z#16+65)
 Q H
ERROR W ?3,"Compilation aborted: "_$$EC^%ZOSV,!
 Q
