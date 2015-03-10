RGED ;MSC/IND/DKM - Extensible Editor ;20-Jan-2015 13:23;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 ; This is the main entry point for the Extensible Editor.
 ; Inputs:
 ;   RGDIC = Root node of word processing multiple (defaults to none)
 ;   RGTTL = Title text (defaults to none)
 ;   RGOBJ = Edited object name (defaults to none)
 ;   RGCF  = Configuration to use (defaults to DEFAULT)
 ;   RGPID = Instance identifier (defaults to $J)
 ;=================================================================
ENTRY(RGDIC,RGTTL,RGOBJ,RGCF,RGPID) ;
MAIN N RGLC,RGST,RGTBL,RGFIN,RGED,RGY,RGED1,RGED2,RGY1,RGY2,RGROW,RGCOL,RGLN,RGCHG
 N RGRVON,RGNORM,RGBEL,RGESC,RGCLR,RGEOL,RGEOS,RGLFT,RGTOP,RGFLG,RGCF2
 N RGSR1,RGSC1,RGSR2,RGSC2,RGMSG,RGCTL1,RGCTL2,RGHLP,RGRULER,RGITER,RGITER2
 N RGCH,RGCH1,RGCH2,RGLNM,RGRULX,RGSRCH,RGR,RGCNT,RGPAD,RGBUF,RGVER,RGMAX
 N RGBMR,RGBMC,RGUNON,RGHION,RGGRON,RGGROF,RGZ,RGZ1,RGZ2,RGZ3,RGZ4
 I '$G(DUZ) N DUZ S DUZ=0
 S U="^"
 F RGPID=+$G(RGPID,$J):.0001 I '$D(^XTMP(RGPID_"RGED")) S RGPID=RGPID_"RGED",^XTMP(RGPID)="" Q
 ; Get internal configuration identifier
 S:$G(RGCF)="" RGCF="DEFAULT"
 S RGCF=+$O(^RGEDCFG("B",RGCF,0)),RGCF2=0
 I 'RGCF W !!,"Configuration not found - unable to continue.",!! Q
 S:$D(^RGED("A",RGCF,DUZ)) RGCF2=RGCF,RGCF=^(DUZ)                      ; Check for a configuration alias
 ; Normalize global root
 S RGDIC=$$CREF^DILF($G(RGDIC))
 S:$L(RGDIC) RGDIC=$NA(@RGDIC)
 ; Set up terminal characteristics
 D HOME^%ZIS
 U IO
 D RM^RGUTOS(0)
 X ^%ZOSF("EOFF"),^%ZOSF("TRMON"),^%ZOSF("TYPE-AHEAD")
 ; Set up variables
 S RGBUF="RGED"
 S RGVER=$P(^RGEDCFG(RGCF,0),U,4),RGMAX=+$P(^(0),U,5),RGZ1=$P(^(0),U,6),RGZ=+$G(DTIME)
 N DTIME
 S DTIME=$S(RGZ1!'RGZ:999999,1:RGZ),DT=$$DT^XLFDT
 S:RGMAX<40 RGMAX=255
 S RGTTL=$$MSG^RGUT($G(RGTTL),"|"),RGOBJ=$$MSG^RGUT($G(RGOBJ),"|")
 S RGESC=$C(27),RGCLR=RGESC_"[H"_RGESC_"[J",RGEOL=RGESC_"[K",RGEOS=RGESC_"[J"
 S RGRVON=$C(27,91,55,109),RGUNON=$C(27,91,52,109),RGHION=$C(27,91,49,109),RGNORM=$C(27,91,109),RGGRON=$C(27,40,48),RGGROF=$C(27,40,66)
 S (RGSR1,RGSC1,RGSR2,RGSC2,RGST,RGED,RGED1,RGFLG,RGITER,RGITER2,RGCHG,RGBMR,RGBMC,RGLC)=0
 S (RGROW,RGCOL,RGLFT,RGTOP,RGTBL,RGMSG)=1,RGY1=3,RGY=RGY1
 S (RGCTL1,RGCTL2,RGSRCH,RGBEL)=""
 S RGRULER=$TR($S($D(^RGED("R",RGCF,DUZ))#10:^(DUZ),$D(^RGED(RGCF,"R"))#10:^("R"),1:$G(^RGEDCFG(RGCF,6))),"=T","qw")
 S RGHLP=$G(^RGEDCFG(RGCF,5)),RGHLP(0)=$$ROOT^DILFD(9.2,,1)
 F RGZ=1:1:31,127:1:255 S RGCTL1=RGCTL1_$C(RGZ),RGCTL2=RGCTL2_$S(RGZ=9:" ",RGZ=27:"$",1:"~")
 S RGTTL=$TR(RGTTL,RGCTL1,RGCTL2),RGOBJ=$TR(RGOBJ,RGCTL1,RGCTL2)
 ; Load state variables
 F RGZ=1:1:20 S RGST(RGZ)=0,RGST(RGZ,-1)=999999
 S RGZ2=0
 F RGZ=0:0 S RGZ=+$O(^RGED(RGCF,"S",RGZ)) Q:'RGZ  D
 .S RGZ1=^RGED(RGCF,"S",RGZ,0),RGST(RGZ,-1)=$P(RGZ1,U,2)-1,RGST(RGZ)=+$P(RGZ1,U,3),RGST(RGZ,-4)=$P(RGZ1,U,4),RGZ1=$P(^(1),U),RGST(RGZ,-3)=^(2)
 .F RGZ3=0:1:$L(RGZ1,";") D
 ..S RGZ4=$P(RGZ1,";",RGZ3+1),RGST(RGZ,RGZ3)=RGZ4,RGST=$S($L(RGZ4)>RGST:$L(RGZ4),1:RGST)
 ..I $L(RGZ4),'$D(RGST(RGZ,-2)) S RGST(RGZ,-2)=RGZ2,RGZ2=RGZ2+1
 .I RGST(RGZ,-4) S:$D(^RGED("S",RGCF,DUZ,RGZ))#10 RGST(RGZ)=+^(RGZ)
 S RGST=RGST+2
 D RMLM^RGED1(7),RMLM^RGED1(8)
 ; Setup edit screen and begin session
 D LOAD^RGED0,PAINT^RGEDS,SHST^RGEDS(1,0),START^RGED0
 ; Cleanup and exit
DONE F RGZ=0:1:9 D
 .S RGZ1="RGED"_RGZ
 .Q:'$D(^XTMP(RGPID,RGZ1))
 .K ^RGED("B",DUZ,RGZ)
 .M ^RGED("B",DUZ,RGZ)=^XTMP(RGPID,RGZ1)
 K ^XTMP(RGPID)
 ; Reset terminal characteristics
RESET X ^%ZOSF("EON"),^%ZOSF("TRMOFF")
 W RGESC_"[?3l"_RGESC_"[1;24r"_RGESC_"[?7h"_RGCLR,!
 Q
