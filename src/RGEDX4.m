RGEDX4 ;MSC/IND/DKM - Help frame editor ;20-Jan-2015 13:23;DKM
 ;;3.0;EXTENSIBLE EDITOR;;Jan 23, 2015;Build 12
 ;;
 ;=================================================================
 N RGHF,RGHC,RGZ
 D HOME^%ZIS
 S RGHC=$$ROOT^DILFD(9.2,,1),RGHC(0)=$$ROOT^DILFD(9.2)
 F  D  Q:RGHF<0
 .D TITLE^RGUT("Help Frame Editor",$P($T(+2),";",3))
 .S RGHF=$$GETFRM("Initial help frame to edit: ")
 .Q:RGHF<1
 .S RGZ=@RGHC@(RGHF,0),RGHF(0)=$P(RGZ,U),RGHF(1)=0,RGHF(2)=0
 .D ENTRY^RGED($NA(@RGHC@(RGHF,1)),$P(RGZ,U,2),RGHF(0),"HFEDIT")
 W @IOF,!!
 Q
 ; Get current key
CURKEY() N RGZ,RGZ1
 F RGZ=RGCOL:-1:0 Q:$E(RGLN,RGZ)="]"  I $E(RGLN,RGZ)="[",$E(RGLN,RGZ-1,RGZ+1)'["[[" Q
 Q:$E(RGLN,RGZ)'="[" ""
 D MOVETO^RGED2(RGROW,RGZ)
 Q $$UP^XLFSTR($E($$TRIM^RGUT($TR($P($E(RGLN,RGZ+1,999),"]"),U)),1,30))
 ; Move to next hyperlink
NXTKEY() N RGCOL1,RGROW1,RGKEY,RGZ
 S RGZ=$$CURKEY,RGCOL1=RGCOL,RGROW1=RGROW,RGMSG=0,RGKEY=""
 F  D  Q:RGMSG
 .D SRCRPL^RGEDF("[")
 .I RGMSG S RGF=1 Q
 .S RGKEY=$$CURKEY
 .S:$L(RGKEY) RGCOL1=RGCOL,RGROW1=RGROW,RGMSG=-1
 D MOVETO^RGED2(RGROW1,RGCOL1)
 Q RGKEY
 ; Tab to next hyperlink
TAB N RGZ
 S RGZ=$$NXTKEY
 Q:'$L(RGZ)
 S RGZ=$P($$KEYDATA(RGZ),U,3)
 W $$PRMPT^RGED2($S('RGZ:"Not linked",'$D(^DIC(9.2,RGZ,0)):"Broken link",1:"Linked to "_$P(^(0),U)),0)
 Q
 ; Return global reference for current HF and specified subscript
HF(X) Q $NA(@RGHC@(RGHF,X))
 ; Return info for hyperlink
KEYDATA(RGKEY,RGCNT) ;
 N RGZ,RGZ1
 S RGZ=$$HF(2),RGZ1=$O(@RGZ@("B",RGKEY,0))
 I 'RGZ1 D
 .L +@RGZ
 .S RGZ1=$O(@RGZ@($C(1)),-1)+1,@RGZ@(RGZ1,0)=RGKEY,@RGZ@("B",RGKEY,RGZ1)="",$P(@RGZ@(0),U,3)=RGZ1,$P(^(0),U,4)=$P(^(0),U,4)+1,RGCNT=$G(RGCNT)+1
 .L -@RGZ
 Q RGZ1_U_@RGZ@(RGZ1,0)
 ; Find broken hyperlink
NOFRM(RGF) ;
 N RGKEY
 D MAIN
 S RGKEY=$S(RGF:$$CURKEY,1:$$NXTKEY)
 S:'$L(RGKEY) RGKEY=$$NXTKEY
 F  Q:RGKEY=""  S RGKEY=$$KEYDATA(RGKEY) Q:'$P(RGKEY,U,3)  S RGKEY=$$NXTKEY
 Q:'RGKEY
 S RGKEY=$P(RGKEY,U,2)
 I 'RGF W $$PRMPT^RGED2("No help frame linked to "_RGKEY,-1)
 E  D NXTFRM
 D PAINT
 Q
 ; Force to main buffer
MAIN Q:RGBUF="RGED"
 D SWITCH^RGED5("")
 S RGHF(2)=0
 Q
 ; Traverse hyperlink
NXTFRM D GOTO($$KEYX($$CURKEY)),PAINT
 Q
 ; Go to specified frame
GOTOFRM D GOTO($$GETFRM("Go to which frame: ",0,RGY1)),PAINT
 Q
 ; Goto help frame
GOTO(RGFRM) ;
 I RGFRM>0 D
 .I '$D(@RGHC@(RGFRM)) W $$PRMPT^RGED2("Help frame #|RGFRM| does not exist.",-1)
 .E  D:'$$QUIT
 ..S RGHF(1)=1+RGHF(1),^XTMP("RGEDHF",RGPID,RGHF(1))=RGHF_U_RGROW_U_RGCOL
 ..D CHANGE(RGFRM)
 Q
 ; Repaint screen if needed
PAINT D:RGHF(2) PAINT^RGEDS
 S RGHF(2)=0
 Q
 ; Change to new help frame
CHANGE(RGFRM,RGR,RGC) ;
 N RGZ
 S RGHF=RGFRM,RGDIC=$$HF(1)
 D LOAD^RGED0,MOVETO^RGED2($G(RGR,1),$G(RGC,1))
 S RGZ=@$$HF(0),RGHF(0)=$P(RGZ,U),RGHF(2)=1,RGTTL=$P(RGZ,U,2),RGOBJ=RGHF(0)_$S(RGHF(1):" ["_RGHF(1)_"]",1:""),RGCHG=0
 D PAINT
 Q
 ; Return HF linked to keyword
KEYX(RGKEY) ;
 N RGFRM
 I RGKEY="" W RGBEL Q 0
 S RGKEY=$$KEYDATA(RGKEY)
 I 'RGKEY W RGBEL Q 0
 S RGFRM=+$P(RGKEY,U,3)
 I '$D(@RGHC@(RGFRM,0)) D
 .W $$PRMPT^RGED2("No help frame has been linked to |$P(RGKEY,U,2)|",-1),$$XY^RGUT(RGED1,RGY1),RGEOS
 .S RGFRM=$$GETFRM("Link to help frame: ",0,RGY1)
 .S:RGFRM>0 $P(@$$HF(2)@(+RGKEY,0),U,2)=RGFRM
 Q RGFRM
 ; Prompt for HF
GETFRM(RGP,RGED,RGY) ;
 N RGI,RGZ
 X:$D(RGDIC) ^%ZOSF("EON"),^("TRMOFF")
 S RGI("NEW")="Create new frame"
 S RGZ=$$ENTRY^RGUTLKP(RGHC,"TU",RGP,"B^C","","","",.RGED,.RGY,2,"RGI"),RGHF(2)=1
 I RGZ="NEW" D
 .R !!,"New help frame name: ",RGF:DTIME,!
 .S RGZ=0,RGF=$$CHKNAME(RGF)
 .Q:RGF=""
 .S RGZ=+$O(@RGHC@("B",RGF,0))
 .S:'RGZ RGZ=+$$ENTRY^RGUTDIC(9.2,"~LFX;.01///^S X=RGF")
 E  S:'RGZ RGZ=-1
 X:$D(RGDIC) ^%ZOSF("EOFF"),^("TRMON")
 Q RGZ
 ; Backup to previous HF
BACK N RGZ,RGFRM
 I 'RGHF(1) W RGBEL Q
 Q:$$QUIT
 S RGFRM=^XTMP("RGEDHF",RGPID,RGHF(1)),RGHF(1)=RGHF(1)-1
 D CHANGE(+RGFRM,$P(RGFRM,U,2),$P(RGFRM,U,3))
 Q
 ; Prompt to save
QUIT() N RGFIN
 D MAIN,QUIT^RGED0
 Q '$D(RGFIN)
 ; Return to original HF
HOME N RGFRM
 Q:$$QUIT
 S RGFRM=$G(^XTMP("RGEDHF",RGPID,1)),RGHF(1)=0
 K ^XTMP("RGEDHF",RGPID)
 D:RGFRM CHANGE(+RGFRM,$P(RGFRM,U,2),$P(RGFRM,U,3))
 Q
 ; Rename help frame
RENAME N RGZ
 S RGZ=$$CHKNAME($$PRMPT^RGED2("Rename help frame to: ",30,"U",,RGHF(0)),RGHF(0))
 Q:RGZ=""
 I $D(@RGHC@("B",RGZ)) W $$PRMPT^RGED2("Name already exists") Q
 I $$ENTRY^RGUTDIC(9.2,RGHF_"|<;.01///^S X=RGZ")>0 S RGHF(0)=RGZ,RGOBJ=RGZ_$S(RGHF(1):" ["_RGHF(1)_"]",1:"")
 E  W $$PRMPT^RGED2("Error renaming help frame")
 D STATUS^RGEDS
 Q
 ; Validate help frame name
CHKNAME(RGN,RGD) ;
 S RGN=$E($$TRIM^RGUT($$UP^XLFSTR(RGN)),1,30)
 Q $S($L(RGN)<3:"",RGN[U:"",RGN=$G(RGD):"",1:RGN)
 ; Modify header
HEADER N RGZ
 S RGZ=$$PRMPT^RGED2("New header: ",65,,,RGTTL)
 Q:RGZ[U
 S $P(@$$HF(0),U,2)=RGZ,RGTTL=RGZ
 D STATUS^RGEDS
 Q
 ; Add referenced keys to index
ADDKEYS N RGCNT
 D MAIN,TOP^RGED2,SHST^RGEDS(3,0)
 W $$PRMPT^RGED2("Scanning for keywords...",0)
 S RGCNT=0
 F  S RGZ=$$NXTKEY Q:RGZ=""  S RGZ=$$KEYDATA(RGZ,.RGCNT)
 W $$PRMPT^RGED2("Keywords added: |RGCNT|",0)
 Q
 ; Remove unreferenced keys
DELKEYS N RGZ,RGZ1,RGKEY,RGCNT
 D MAIN,TOP^RGED2,SHST^RGEDS(3,0)
 W $$PRMPT^RGED2("Scanning for keywords...",0)
 K ^XTMP(RGPID,"RGEDKY")
 F  S RGZ=$$NXTKEY Q:RGZ=""  S ^XTMP(RGPID,"RGEDKY",RGZ)=""
 S RGZ=$$HF(2),RGKEY="",RGCNT=0
 F  S RGKEY=$O(@RGZ@("B",RGKEY)) Q:RGKEY=""  I $E(RGKEY)'="?",'$D(^XTMP(RGPID,"RGEDKY",RGKEY)) D
 .D DELIDX(RGKEY)
 .S RGCNT=RGCNT+1
 W $$PRMPT^RGED2("Unused keywords deleted: |RGCNT|",0)
 K ^XTMP(RGPID,"RGEDKY")
 Q
 ; Remove a key from index
DELIDX(RGKEY) ;
 N RGZ,RGZ1
 S RGZ=$$HF(2)
 F RGZ1=0:0 S RGZ1=$O(@RGZ@("B",RGKEY,RGZ1)) Q:'RGZ1  K ^(RGZ1),@RGZ@(RGZ1)
 Q
 ; Remove a link
DELLNK N RGKEY,RGZ,RGZ1
 S RGKEY=$$CURKEY,RGZ=$$HF(2)
 D:$L(RGKEY) DELIDX(RGKEY)
 Q
