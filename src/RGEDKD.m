RGEDKD ;MSC/IND/DKM - Create keystroke macros ;20-Jan-2015 13:23;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 N RGCF,X,Y,Y1,Y2,RGZ
 I '$G(DTIME) N DTIME S DTIME=999999
 D HOME^%ZIS
 S U="^"
REDO D TITLE^RGUT("Editor Macro Definition Utility",$P($T(+2),";",3))
 S RGCF=$$ENTRY^RGUTLKP("^RGED1","A","Configuration for which to define keys: ")
 Q:RGCF<1
AGAIN R !,"KEY LABEL: ",X:DTIME,!
 G:U[X REDO
 W !,"Press key associated with this label: "
 X ^%ZOSF("EOFF")
 S Y1="$C(",Y2=""
 R *Y:DTIME
 E  G AGAIN
NXT S Y1=Y1_Y2_$S(Y:Y,1:-1),Y2=","
 R *Y:0
 G:Y'<0 NXT
 S Y1=Y1_")"
 X ^%ZOSF("EON")
 L +^RGEDCFG(RGCF,3)
 S RGZ=+$O(^RGEDCFG(RGCF,3,"B",X,0))
 G:RGZ FND
 S RGZ=$P($G(^RGEDCFG(RGCF,3,0)),U,3)+1
 S $P(^(0),U,3)=RGZ,$P(^(0),U,4)=$P(^(0),U,4)+1
FND S ^RGEDCFG(RGCF,3,"B",X,RGZ)=""
 S ^RGEDCFG(RGCF,3,RGZ,0)=X_U_Y1
 L -^RGEDCFG(RGCF,3)
 W "Key macro stored.",!!
 G AGAIN
