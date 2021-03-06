RGEDF ;MSC/IND/DKM - Continuation of RGED;04-May-2006 08:19;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 ; Search for string
SEARCH(RGITER) ;
 D SRCRPL("",.RGITER)
 Q
 ; Find next occurrence
FNEXT(RGITER) ;
 D:$L(RGSRCH) SRCRPL(RGSRCH,.RGITER)
 Q
 ; Get search string
SRCH() N RGZ
 S RGZ=$$PRMPT^RGED2(7,.RGZ,"H","",RGSRCH)
 Q:RGZ=U ""
 S:RGZ="^^" RGZ=U
 S:RGZ'="" RGSRCH=RGZ
 Q RGSRCH
 ; Search (and optionally replace) option
SRCRPL(RGS,RGITER,RGRF,RGR) ;
 S:$G(RGS)="" RGS=$$SRCH
 Q:RGS=""
 I $D(RGRF),'$D(RGR) S RGR=$$PRMPT^RGED2(10) Q:RGR=U  S:RGR="^^" RGR=U
 K:$G(RGRF)="" RGRF
 N RGDIR,RGSR,RGSC,RGSRX,RGFND,RGRCNT
 S RGDIR=$S(RGST(3):-1,1:1),RGSRX=$S(RGDIR<0:1,1:RGLC),RGRCNT=0
 S RGS=$S(RGST(4):RGS,1:$$UP^XLFSTR(RGS)),RGITER=+$G(RGITER)
FN1 D UPDATE^RGED2
 S RGSC=RGCOL+1,RGFND=0
 F RGSR=RGROW:RGDIR:RGSRX D  Q:RGFND
 .S RGZ=$G(^XTMP(RGPID,RGBUF,RGSR))
 .S:'RGST(4) RGZ=$$UP^XLFSTR(RGZ)
 .I RGDIR>0 S RGFND=$F(RGZ,RGS,RGSC),RGSC=0
 .E  F RGZ1=0:0 S RGFND=RGZ1,RGZ1=$F(RGZ,RGS,RGZ1+1) I 'RGZ1!(RGZ1'<RGSC) S RGSC=999 Q
 .I RGFND D
 ..I RGITER>1,'$D(RGR) S RGITER=RGITER-1,RGFND=0 Q
 ..D MOVETO^RGED2(RGSR,RGFND-$L(RGS))
 ..I $D(RGR) D
 ...S:'$D(RGRF) RGRF=$S(RGITER>0:"A",1:$$UP^XLFSTR($$PRMPT^RGED2(8,1,1,"yYnNaAcCsS^")))
 ...Q:(RGRF="")!("YAC"'[RGRF)
 ...I ($L(RGLN)-$L(RGS)+$L(RGR))>RGMAX S RGFND=-1,RGRF="" Q
 ...S RGLN=$E(RGLN,1,RGCOL-1)_RGR_$E(RGLN,RGCOL+$L(RGS),RGMAX),RGRCNT=RGRCNT+1,RGCHG=1
 ...W $$XY^RGUT(RGED,RGY)
 ...D SLINE^RGEDS(RGROW),MOVETO^RGED2(RGROW,RGCOL+$L(RGR)-1):RGDIR>0
 ...I RGITER S RGITER=RGITER-1 S:'RGITER RGRF=""
 I RGFND>0,$G(RGRF)'="","ASC"[RGRF K:"SC"[RGRF RGRF G FN1
 S RGZ=$S(RGFND=-1:3,RGRCNT=1:"1 occurrence replaced",$D(RGR):RGRCNT_" occurrences replaced",'RGFND:9,1:"")
 W:RGZ'="" $$PRMPT^RGED2(RGZ,-1)
 Q
 ; Search and replace function
REPLACE(RGITER) ;
 N RGR
 D SRCRPL("",.RGITER,"",.RGR)
 Q
