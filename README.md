# Introduction

molUP is a VMD extension that provides a simple manner for loading and saving Gaussian files, and analyze related results. molUP provides a graphical interface for VMD where the users can load and save chemical structures in the Gaussian file formats. This extension includes a set of tools to set up any calculation supported by Gaussian, including ONIOM; analyze energies through interactive plots; animate vibrational frequencies; draw the vectors associated with those frequencies; modify bonds, angles, and dihedrals; and collect bibliographic information on the employed methods.

Main Features:
- Load Gaussian Input (.com) and Output files (.log) on VMD;
- Assign ONIOM layers (High-, Medium-, and Low-level);
- Select free and fixed atoms during geometry optimization (Freeze status);
- Analyze and edit atomic charges;
- Setup new Gaussian calculation using the Gaussian input section;
- Load scan across reactional coordinates and plot the structure's energies;
- Load Gaussian frequency calculations, animate the vibrational modes and show respective vectors;
- Show quick useful representations such as the protein, the different ONIOM layers, and the fixed atoms;
- Structural Manipulation: adjust the bond length, angle amplitude, and dihedral angle torsion;
- Provide a complete bibliographic list of references according to the type of methods and functionals that were employed in the calculation;
- Among others.


## ScreenShots

![Adjusting a dihedral angles using molUP](Screenshots/image1.gif)

![Energies](Screenshots/image2.gif)

![Input section](Screenshots/image3.gif)

![ONIOM layers](Screenshots/image4.gif)

![Loading a file](Screenshots/image5.gif)

## Minimum Requirements

Operating System: macOS or Linux (Windows version will be available soon)
Visual Molecular Dynamics (VMD) 1.9.3 or later

## Installation

You could install molUP through [vmdStore](https://github.com/portobiocomp/vmdStore) (Recommended).

## Contacts
If you have any suggestion of new features, please contact us: henrique.fernandes@fc.up.pt
