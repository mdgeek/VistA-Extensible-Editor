RGEDIT ;MSC/IND/DKM - M routine editor ;01-Apr-2015 08:59;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 D ENTRY()
 Q
SEARCH D ENTRY(1)
 Q
BROWSE D ENTRY(,1)
 Q
BRSSRC D ENTRY(1,1)
 Q
LOCAL N RGI,RGED,RGY
 F RGI=0:0 S RGI=$O(^TMP("RGEDRTN",$J,RGI)) Q:'RGI  S RGED=^(RGI,0),RGY=$P(RGED," ",2,999),RGED=$P(RGED," "),^(0)=RGED_$E("         ",$L(RGED)+1,8)_RGY
 S ^TMP("RGEDRTN2",$J)="Local Routine"
 D DOIT(-1)
 F RGI=0:0 S RGI=$O(^TMP("RGEDRTN",$J,RGI)) Q:'RGI  S RGED=^(RGI,0),^(0)=$P(RGED," ")_" "_$$TRIM^RGUT($P(RGED," ",2,999))
 K ^TMP("RGEDRTN2",$J)
 Q
ENTRY(RGS,RGB) ;
 N RGT
 S U="^",RGS=$G(RGS),RGB=+$G(RGB),DTIME=$G(DTIME,999999),DT=$$DT^XLFDT
 S RGT=$S(RGS&RGB:"search/browse",RGS:"search",RGB:"browse",1:"")
 S:$L(RGT) RGT=" ("_RGT_" option"_$S(RGS&RGB:"s",1:"")_")"
 D HOME^%ZIS,TITLE^RGUT("Routine Editor"_RGT,$P($T(+2),";",3),"Enter Routine(s) to Edit")
 I $$NEWERR^%ZTER N $ET S $ET=""
 W !!
 I $D(^TMP("RGEDRTN",$J)),$$ASK^RGUT("Routines exist in edit buffer.  Do you wish to edit these") D DOIT(1) Q
 X ^%ZOSF("RSEL")
 W !!
 I RGS,$O(^UTILITY($J,$C(1)))'="" D
 .N RGUT,RGR,RGS,RGZ,RGL,RGED
 .S RGUT='$$ASK^RGUT("Distinguish upper and lower case"),RGR=$C(1)
 .F RGS=0:1 R "Search for: ",RGS(RGS):DTIME,! Q:U[RGS(RGS)  S:RGUT RGS(RGS)=$$UP^XLFSTR(RGS(RGS))
 .I RGS(RGS)=U!'RGS K ^UTILITY($J) Q
 .S RGS=RGS-1
 .F  S RGR=$O(^UTILITY($J,RGR)) Q:RGR=""  D
 ..W "Searching "_RGR_"..."
 ..F RGZ=1:1 S RGL=$T(+RGZ^@RGR) Q:RGL=""  D  Q:'RGZ
 ...S:RGUT RGL=$$UP^XLFSTR(RGL)
 ...F RGED=0:1:RGS I RGL[RGS(RGED) S RGZ=0 Q
 ..W $S(RGZ:"not found",1:"found"),!
 ..K:RGZ ^UTILITY($J,RGR)
 D:$O(^UTILITY($J,$C(1)))'="" DOIT()
 Q
 ; Edit routines named in ^UTILITY($J)
DOIT(RGKP) ;
 N RGN,RG,RG1,RG2,RG3,RG4,RG5,RG6,RG7,RG8,RGD,RGE,RGH,RGL,RGED,RGR,RGS,RGS1,RGS2,RGQ,RGZ,RGG
 S U="^",RGN=0,RG=$C(1),RG3=0,RGQ=0,RGKP=$G(RGKP)
 S:'$G(DUZ) DUZ=0
 G:RGKP EDIT
 K ^TMP("RGEDRTN",$J)
 F  S RG=$O(^UTILITY($J,RG)) Q:RG=""!RGQ  D
 .S RG8=$T(+1^@RG),RG6=$P(RG8,";",2)="%ROUTINE TEMPLATE%",RG8=$P(RG8,";",3),RGZ=$S(RG6:$$NEW(RG),1:RG)
 .Q:RGQ
 .S:RGZ="@" RGZ=RG,RG6=0
 .L +^RGED("RTN",RGZ):0
 .E  S RGZ=$$GET(RGZ_" is being edited by another user.  Press RETURN or ENTER to continue") Q
 .S ^RGED("RTN",RGZ)=$J,RGN=RGN+1,RGG=RGZ,RG3=RG3+1,^TMP("RGEDRTN",$J,RG3,0)="*"_RGZ
 .F RG1=RG6+1:1 S RG2=$T(+RG1^@RG) Q:RG2=""  D
 ..S:RG6&$L(RG8) RG2=$$MSG^RGUT(RG2,RG8)
 ..S RG3=RG3+1,RG4=$P(RG2," "),RG2=$P(RG2," ",2,999),^TMP("RGEDRTN",$J,RG3,0)=RG4_$E("         ",$L(RG4)+1,$S($L(RG4)+$L(RG2)>245:0,1:8))_" "_RG2
 G:RGQ!'RG3 DONE
 S ^TMP("RGEDRTN2",$J)=$S(RGN=1:RGG,1:RGN_" routines"),^TMP("RGEDRTN",$J,0)=U_U_RG3_U_RG3
EDIT D ENTRY^RGED($NA(^TMP("RGEDRTN",$J)),"Routine Editor  Version |RGVER|",^TMP("RGEDRTN2",$J),$S($G(RGB):"BROWSE",1:"PROG"))
 G:'$P(^TMP("RGEDRTN",$J,0),U,5) DONE
 Q:RGKP<0
 K ^TMP("RGEDRTN3",$J)
 S RGH=$P($G(^VA(200,DUZ,0)),U,2),RGS=1,@$$TRAP^RGUTOS("ERR^RGEDIT"),$ZE=""
 R:RGH="" !,"Initials: ",RGH:DTIME,!
 S RGH=$$ENTRY^RGUTDT($H)_";"_$E($TR(RGH,"^;"),1,3)
 F RG1=.5:0 S RG1=+$O(^TMP("RGEDRTN",$J,RG1)) Q:'RG1  S RGL=$G(^(RG1,0)) D SV0:$E(RGL)="*",@("SV"_RGS)
 D SV0
DONE K ^UTILITY($J),^TMP("RGEDRTN",$J),^TMP("RGEDRTN2",$J),^TMP("RGEDRTN3",$J)
 S RGZ=""
 F  S RGZ=$O(^RGED("RTN",RGZ)) Q:RGZ=""  I ^(RGZ)=$J K ^(RGZ) L -^RGED("RTN",RGZ)
 X ^%ZOSF("TYPE-AHEAD")
 W !!
 Q
ERR W $$EC^%ZOSV,!
 G DONE
SV0 ; Save current routine
 D:$D(^TMP("RGEDRTN3",$J,"R")) SAVE^RGUTRTN(RGR,$NA(^("R")))
 K ^TMP("RGEDRTN3",$J)
 S RGS=1
 Q
SV1 ; New routine
 S:$E(RGL)="*" RGR=$E($TR(RGL," "),2,999),RGS=2
 W !,RGR_"..."
 Q
SV2 ; Possible header
 S RGS=3
 I RGL'["%ROUTINE TEMPLATE%",RGL[";" S $P(RGL,";",3,4)=RGH
 ; Routine line
SV3 N LBL,CMD,X,Y
 S LBL=$P(RGL," "),CMD=$$TRIM^RGUT($P(RGL," ",2,999))
 I $L(LBL) D
 .S (X,Y)=$P(LBL,"(")
 .F  Q:'$D(^TMP("RGEDRTN3",$J,"L",X))  S X=X_"_"
 .S ^TMP("RGEDRTN3",$J,"L",X)=""
 .I X'=Y D
 ..W !?5,"Replacing duplicate label ",Y," with ",X
 ..S $P(LBL,"(")=X
 S:$L(LBL)!$L(CMD) X=1+$O(^TMP("RGEDRTN3",$J,"R",""),-1),^(X,0)=LBL_" "_CMD
 Q
 ; Process routine templates
NEW(RGRTN) ;
 W RGRTN_" is a routine template.",!!
 F  D  Q:RGRTN'=""
 .R "New routine name: ",RGRTN:DTIME,!
 .E  S RGRTN=U
 .I RGRTN=U S RGQ=1 Q
 .Q:RGRTN="@"
 .I RGRTN'?1A.7AN W "That is not a valid name.  Enter ^ to abort, @ to edit the template.",!! S RGRTN="" Q
 .I $$TEST^RGUTRTN(RGRTN) W "That routine already exists.  Try another name.",!! S RGRTN="" Q
 Q RGRTN
 ; Allows routine template to prompt for input
GET(RGP,RGD) ;
 W RGP_$S($G(RGD)'="":"  /"_RGD_"/",1:"")_" : "
 R RGP:DTIME,!
 E  S RGP=U
 S:RGP=U RGQ=1
 Q $S(RGP="":$G(RGD),1:RGP)
