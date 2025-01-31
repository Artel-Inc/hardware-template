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

STACK: XXX

## Note:

## Changelog:

### v 0.0.1

- Init