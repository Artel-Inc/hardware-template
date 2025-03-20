#!/bin/sh

#.github/scripts/KiExport.sh  -n gmb -v v0.1 -k hardware -o manufacturing -s -p -g -c -a -b -i

NAME=""
PRJ=""
OUTDIR=""

while getopts 'n:v:k:o:spdgcabi' OPTION; do  
  case "$OPTION" in
    n)
      NAME="${NAME}${OPTARG}"
      ;;
    v)
      NAME="${NAME}_${OPTARG}"
      ;;
    k)
      PRJ=`realpath $OPTARG`
      ;;
    o)
      mkdir -p $OPTARG
      OUTDIR=`realpath $OPTARG`
      ;;
    s)
      ## SCH
      echo "------------------- SCH [PDF] ------------------- "
      kicad-cli sch export pdf $PRJ/main.kicad_sch -o ${OUTDIR}/${NAME}_sch.pdf -n
      ;;
    p)
      ## PCB
      echo "------------------- SCH [PDF] ------------------- "
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb \
      						 -l 'F.Paste,F.Cu,F.Silkscreen,F.Courtyard,Edge.Cuts' --ibt --ev --drill-shape-opt 2 -o ${OUTDIR}/${NAME}_pcb_t.pdf 
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb \
      						 -l 'B.Paste,B.Cu,B.Silkscreen,B.Courtyard,Edge.Cuts' -m --ibt --ev --drill-shape-opt 2 -o ${OUTDIR}/${NAME}_pcb_b.pdf 
      ;;
    d)
      ## 3D
      echo "------------------- 3D [STEP] ------------------- "
      kicad-cli pcb export step  $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}.step \
      						   --grid-origin --no-dnp --subst-models --include-silkscreen --include-soldermask
      ;;
    g)
      ## GBR
      echo "-------------------- GBR+DRL -------------------- "
      mkdir -p ${OUTDIR}/gerber
      kicad-cli pcb export gerbers $PRJ/main.kicad_pcb -o ${OUTDIR}/gerber/ \
      							 -l 'F.Cu,B.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,User.Drawings,User.Comments,Edge.Cuts' --no-protel-ext \
      							 --ev \
      							 --use-drill-file-origin
      kicad-cli pcb export drill   $PRJ/main.kicad_pcb -o ${OUTDIR}/gerber/ \
      						     --format excellon --excellon-zeros-format decimal \
      						     --excellon-oval-format alternate -u mm --generate-map --map-format gerberx2 \
      						     --drill-origin plot
      cd ${OUTDIR}/gerber/
      mv 

      mv main-User_1.gbr 11_${NAME}_User-1.gbr
      mv main-User_2.gbr 12_${NAME}_User-2.gbr
      mv main-User_3.gbr 13_${NAME}_User-3.gbr
      mv main-User_4.gbr 14_${NAME}_User-4.gbr
      mv main-User_5.gbr 15_${NAME}_User-5.gbr
      mv main-F_Paste.gbr 20_${NAME}_F-Paste.gbr
      mv main-F_Silkscreen.gbr 21_${NAME}_F-Silkscreen.gbr
      mv main-F_Mask.gbr 22_${NAME}_F-Mask.gbr
      mv main-F_Cu.gbr 25_${NAME}_F-Cu.gbr
      mv main-In1_Cu.gbr 26_${NAME}_In1-Cu.gbr
      mv main-In2_Cu.gbr 27_${NAME}_In2-Cu.gbr
      mv main-In3_Cu.gbr 28_${NAME}_In3-Cu.gbr
      mv main-In4_Cu.gbr 29_${NAME}_In4-Cu.gbr
      mv main-In5_Cu.gbr 30_${NAME}_In5-Cu.gbr
      mv main-In6_Cu.gbr 31_${NAME}_In6-Cu.gbr
      mv main-B_Cu.gbr 56_${NAME}_B-Cu.gbr
      mv main-B_Mask.gbr 60_${NAME}_B-Mask.gbr
      mv main-B_Silkscreen.gbr 61_${NAME}_B-Silkscreen.gbr
      mv main-B_Paste.gbr 62_${NAME}_B-Paste.gbr
      mv main-Edge_Cuts.gbr 95_${NAME}_Edge-Cuts.gbr
      mv main-User_6.gbr 96_${NAME}_User-6.gbr
      mv main-User_7.gbr 97_${NAME}_User-7.gbr
      mv main-User_8.gbr 98_${NAME}_User-8.gbr
      mv main-User_9.gbr 99_${NAME}_User-9.gbr
      mv main-User_Comments.gbr ${NAME}_User-Comments.gbr
      mv main-User_Drawings.gbr ${NAME}_User-Drawings.gbr
      mv main.drl ${NAME}.drl
      mv main-drl_map.gbr ${NAME}_drl-map.gbr
      mv main-job.gbrjob ${NAME}_job.gbrjob
      
      zip -r ${OUTDIR}/${NAME}.zip *
      rm -f *job.gbrjob *drl-map.gbr *User-Comments.gbr *User-Drawings.gbr
      zip -r ${OUTDIR}/${NAME}_rezonit.zip *
      cd -
      rm -rf ${OUTDIR}/gerber
      ;;
    c)
      ## POS
      echo "------------------- POS [CSV] ------------------- "
      kicad-cli pcb export pos   $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}_cpl.csv \
      						   --side both --format csv --units mm --use-drill-file-origin
      sed -i 's/Ref/Designator/' ${OUTDIR}/${NAME}_cpl.csv
      sed -i 's/PosX/Mid X/'     ${OUTDIR}/${NAME}_cpl.csv
      sed -i 's/PosY/Mid Y/'     ${OUTDIR}/${NAME}_cpl.csv
      sed -i 's/Rot,/Rotation,/' ${OUTDIR}/${NAME}_cpl.csv
      sed -i 's/Side/Layer/'     ${OUTDIR}/${NAME}_cpl.csv
      ;;
    a)
      ## ASM
      echo "------------------- ASM [PDF] ------------------- "
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}_asm_t.pdf \
      						 -l 'F.Fab,Edge.Cuts,User.Comments' --cl 'User.Drawings' --cdnp --ev --ibt --black-and-white --drill-shape-opt 0
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}_asm_b.pdf \
      						 -l 'B.Fab,Edge.Cuts,User.Comments' --cl 'User.Drawings' --cdnp --ev --ibt --black-and-white --drill-shape-opt 0 -m
      ;;
    b)
      ## BOM
      echo "------------------- BOM [PDF] ------------------- "
      kicad-cli sch export bom $PRJ/main.kicad_sch -o ${OUTDIR}/${NAME}_bom.csv \
       						 --preset general --format-preset CSV
      sed -i 's/"Value"/Comment/'         ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"Reference"/Designator/'  ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"Footprint"/Footprint/'   ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"lcsc"/LCSC/'             ${OUTDIR}/${NAME}_bom.csv
      ;;
    i)
      echo "------------------ IBOM [HTML] ------------------ "
      echo "warning: ignored ibom.config.ini"
      # mv main-ibom.html  ${NAME}_ibom.html
      INTERACTIVE_HTML_BOM_NO_DISPLAY=true generate_interactive_bom.py $PRJ/main.kicad_pcb \
      --highlight-pin1 selected \
      --checkboxes Sourced,Placed \
      --bom-view left-right \
      --layer-view F \
      --no-browser \
      --dest-dir ${OUTDIR} \
      --name-format ${NAME} \
      --sort-order C,R,L,D,U,Y,X,F,SW,A,~,HS,CNN,J,P,NT,MH \
      --extra-data-file $PRJ/main.kicad_pcb \
      --show-fields pn,Value,Coefficient,Voltage,Footprint \
      --group-fields Value,Coefficient,Voltage,Footprint 
      ;;
    ?)
      echo "script usage: $(basename \$0) -n=NAME -v=VER -k=dirPrj -o=OUT [-s][-p][-d][-g][-c][-a][-b][-i]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
