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
      OUTDIR=`realpath $OPTARG`
      ;;
    s)
      ## SCH
      kicad-cli sch export pdf $PRJ/main.kicad_sch -o ${OUTDIR}/${NAME}_sch.pdf -b 
      ;;
    p)
      ## PCB
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb \
      						 -l 'F.Cu,F.Silkscreen,F.Courtyard,Edge.Cuts' --ibt --ev --drill-shape-opt 2 -o ${OUTDIR}/${NAME}_F_pcb.pdf 
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb \
      						 -l 'Edge.Cuts,B.Cu,B.Silkscreen,B.Courtyard' --ibt --ev --drill-shape-opt 2 -o ${OUTDIR}/${NAME}_B_pcb.pdf 
      ;;
    d)
      ## 3D
      kicad-cli pcb export step  $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}.step \
      						   --grid-origin --no-dnp --subst-models
      ;;
    g)
      ## GBR
      mkdir -p ${OUTDIR}/gerber
      kicad-cli pcb export gerbers $PRJ/main.kicad_pcb -o ${OUTDIR}/gerber/ \
      							 --board-plot-params
      kicad-cli pcb export drill   $PRJ/main.kicad_pcb -o ${OUTDIR}/gerber/ \
      						     --format excellon --drill-origin absolute --excellon-zeros-format decimal \
      						     --excellon-oval-format alternate -u mm --generate-map --map-format gerberx2
      rename main ${NAME} ${OUTDIR}/gerber/*
      cd ${OUTDIR}/gerber/
      zip -r ${OUTDIR}/${NAME}.zip *
      rm -f *-job.gbrjob *-drl_map.gbr 
      zip -r ${OUTDIR}/${NAME}_rezonit.zip *
      cd -
      rm -rf ${OUTDIR}/gerber
      ;;
    c)
      ## POS
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
      kicad-cli pcb export pdf $PRJ/main.kicad_pcb -o ${OUTDIR}/${NAME}_asm.pdf \
      						 -l 'Edge.Cuts,F.Fab,B.Fab' --ev --ibt --black-and-white --drill-shape-opt 0
      ;;
    b)
      ## BOM							
      kicad-cli sch export bom $PRJ/main.kicad_sch -o ${OUTDIR}/${NAME}_bom.csv \
       						 --preset general --format-preset CSV
      sed -i 's/"Value"/Comment/'         ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"Reference"/Designator/'  ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"Footprint"/Footprint/'   ${OUTDIR}/${NAME}_bom.csv
      sed -i 's/"lcsc"/LCSC/'             ${OUTDIR}/${NAME}_bom.csv
      ;;
    i)
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
