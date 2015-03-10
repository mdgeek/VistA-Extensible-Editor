RGEDBRS ;MSC/IND/DKM - Text file browser;04-May-2006 08:19;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 ;   RGFIL = Name of input file
 ;   RGH1  = Left header
 ;   RGH2  = Right header
 ;   RGCFG = Extensible Editor config to invoke (defaults to INQUIRY)
 ;   RGOPT = Options (D=delete file; H=use first line as header)
 ;=================================================================
LOAD(RGFIL,RGH1,RGH2,RGCFG,RGOPT) ;
 N RGBL,RGLN,RGLN2,RGLC,RGZ,RGZ1
 S U="^",(RGLC,RGBL)=0,@$$TRAP^RGUTOS("ERROR^RGEDBRS"),RGOPT=$G(RGOPT)
 G:$G(^TMP("RGEDBRS",$J,"STOP")) DONE
 S:$G(RGCFG)="" RGCFG="INQUIRY"
 U IO(0)
 W !,"Invoking browser...",!
 K ^TMP("RGEDBRS",$J)
 D OPEN^RGUTOS(.RGFIL,"R"),NXT
 D CLOSE^RGUTOS(.RGFIL)
 S ^TMP("RGEDBRS",$J,0)=U_U_RGLC_U_RGLC
 D ENTRY^RGED($NA(^TMP("RGEDBRS",$J)),$G(RGH1,"Text Browser"),$G(RGH2,$$ENTRY^RGUTDT()),RGCFG)
DONE D DELETE^RGUTOS(RGFIL):RGOPT["D"
 K ^TMP("RGEDBRS",$J)
 Q
NXT U RGFIL
 I $G(RGLN2)'="" S RGLN=RGLN2,RGLN2=""
 E  Q:$$READ^RGUTOS(.RGLN)
 S RGLN=$TR(RGLN,$C(9,10,11,12)," ")
 I RGLN="" S RGBL=RGBL+1 G:RGBL>2 NXT
 E  S RGBL=0
 I RGLN[$C(8) D
 .S RGLN2=$P(RGLN,$C(8),2,999),RGLN=$P(RGLN,$C(8))
 .F RGZ=1:1 Q:$A(RGLN2,RGZ)'=8
 .S RGLN2=$$REPEAT^XLFSTR(" ",$L(RGLN)-RGZ)_$E(RGLN2,RGZ,999)
 F RGZ=1:1:$L(RGLN,$C(13)) D
 .S RGZ1=$P(RGLN,$C(13),RGZ)
 .I RGOPT["H",$G(RGH1)="" S RGH1=RGZ1
 .E  S RGLC=RGLC+1,^TMP("RGEDBRS",$J,RGLC,0)=RGZ1
 G NXT
ERROR U IO(0)
 Q
 ; Pre-open code
PREOPEN D SETPAR()
 S %ZIS("HFSNAME")=$$DEFDIR^%ZISH("")_$$UFN^RGUT,%ZIS("HFSMODE")="W"
 D SETPAR("UFN",%ZIS("HFSNAME"))
 Q
 ; Post-close code
POSTCLS D LOAD(^TMP("RGEDBRS",$J,"UFN"),$G(^("H1")),$G(^("H2")),$G(^("CFG")),"DH")
 Q
 ; Set browser parameters
SETPAR(RGNAME,RGVAL) ;
 I '$D(RGNAME) K ^TMP("RGEDBRS",$J)
 E  S ^TMP("RGEDBRS",$J,RGNAME)=RGVAL
 Q
