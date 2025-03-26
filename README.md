# Before use you should:

- Select board stack
  
  ```
  Use thickness: 1.6mm (default), 1.2mm 
  
  2 layers
  JLC0216 (default) [I Recommend]
  
  4 layers 
  JLC04xx1H-7628 (default)
  JLC04xx1H-3313 [I Recommend]
  
  6 layers
  JLC04xx1H-7628 (additional payment)
  JLC06xx1H-3313 (default) [I Recommend]
  
  Transition from `JLC06xx1H-3313` to `JLC04xx1H-3313`
  is possible, impedance of outer layers will be the same.
  ```
  
  
- Move the `.kicad_pro` file you selected to the directory `hardware`
- Move the `.kicad_pcb` file you selected to the directory `hardware`
- Rename all files in the `hardware` directory to `main`
- Delete all unused files (`.kicad_pro`/`.kicad_pcb`) in `/` and `calc`
- create a directory if necessary (`manufacturing`,`docs`)
- Complete the README.md file
- Fill in the frame in the PCB and schematic file (all fields marked `SET!!!`)
- Adjust as needed `hardware/main.kicad_dru`

# XXX

XXX hardware template - transcript

!!!PHOTO!!!

## Production:

- Different Design: `1`
- Thickness: `1.6mm`;`1.2`
- Color: `Green`;`Purple`;`Yellow`;`Red`;`Blue`;`Black`
- Silkscreen: `White`
- Material Type: `FR4-Standard`
- Surface Finish:  `HASL(with lead)`;`ENIG`
- Outer Copper Weight: `1oz`;`2oz`
- Inner Copper Weight: `0.5oz`;`1oz`;`2oz`
- Layers: `JLC04xx1H-7628`
- Via Covering: `Plugged`;`Epoxy/Copper paste Filled`
- Min via hole size/diameter: `0.3/0.6`
- Board Outline Tolerance: `+-0.2mm`
- Mark on PCB: `Specify Position`;`QR Code`
- Gold Fingers: `No`;`Yes`
- Castellated Holes: `No`;`Yes`
- Edge Plating: `No`;`Yes`
- Assembly Side: `Both`;`Top`
- HS-Code: `text`

## Note:

## Changelog:

### v0.0.1

- Init
