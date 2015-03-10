RGEDX1 ;MSC/IND/DKM - Maintenance utilities ;04-May-2006 08:19;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 ; Purge settings for terminated users
USRPRG N RGZ,RGED,RGY
 F RGED=0:0 S RGED=$O(^VA(200,RGED)) Q:'RGED  D:$P($G(^(RGED,0)),U,11)
 .K ^RGED("B",RGED)
 .F RGY="A","D","M","R","S" D
 ..F RGZ=0:0 S RGZ=$O(^RGED(RGY,RGZ)) Q:'RGZ  K ^(RGZ,RGED)
 Q
