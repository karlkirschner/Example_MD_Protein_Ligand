# Example_MD_Protein_Ligand
Two examples (implicit and explicit water) for model preparation and execution of MD simulations for a protein with a bound ligand.

Software Used: Amber Package (http://ambermd.org)
Karl N. Kirschner (k.n.kirscher at gmail com)

PDB: 1bo4.pdb (https://www.rcsb.org/structure/1BO4)

	Meta level information about drug resistant bacteria: http://pdb101.rcsb.org/motm/146

	PDB reference: Wolf, E.; Vassilev, A.; Makino, Y.; Sali, A.; Nakatani, Y. & Burley, S. K.,
	Crystal Structure of a GCN5-Related N-acetyltransferase: Serratia marcescens
	Aminoglycoside 3-N-acetyltransferase Cell, Cell, 1998, 94, 439-449

Notes:

	1. This workflow is only intended as a teaching tool. A research workflow and input
		that is intended for publication parameters will likely be different.
	2. Workflow designed to executed on a bash command line.

Contents:

	1. implicit_water: implicit model using Generalized Born
	2. explicit_water: explicit model using tip3p
	3. target_files: reference files for how they should look for after cleaning up and computing bcc charges

###################

I. Cleanup the original PDB

	a. pdb4amber -i 1bo4.pdb -o 1bo4_amber.pdb --dry --most-populous --reduce
			(pdb4amber --help)

	b. Extract one monomer (if necessary) from 1bo4_amber.pdb, and save as complex.pdb
		i. Here I chose the "B" monomer since visual inspection showed an additional ligand in "A" that I don't want to consider.

	c. Rename 3-letter ligand identifier to "LIG"

	d. Copy ligand coordinates to "ligand.pdb"

	e. Open ligand.pdb in pymol
		i. double check to see if the structure is correct (need to know some chemistry here)
		ii. (note: instead of using pdb4amber, one could go to pymol's builder and add hydrogens)

	f. If corrections were done, replace the ligand coordinates in complex.pdb with those in the newly saved ligand.pdb

II. Get the model ready for running Amber MD simulations

	a. Run Amber's antechamber program. Pay attention to the ligand's formal charge.
		(see Figure 5 of Wolf et al.)

		antechamber -i ligand.pdb -fi pdb -o ligand.mol2 -fo mol2 -c bcc -nc -3 -s 2
		
		or for faster, but less accurate, partial atomic charges

		antechamber -i ligand.pdb -fi pdb -o ligand.mol2 -fo mol2 -c gas -nc -3 -s 2

		rm ANTECHAMBER_* ATOMTYPE.INF ANTECHAMBER.FRCMOD

	b. Run Ambers parmchk program:
		parmchk2 -i ligand.mol2 -f mol2 -s 2 -o ligand.frcmod -a Y -w Y

	c. Run Amber's tleap program:
		tleap -f leap.in

III. Run the calculations

	a. Minimization:
		sander -O -i min.in -o complex_min.out -p complex_leap.prmtop -c complex_leap.inpcrd -r complex_min.ncrst

	b. Molecular Dynamics: (a very short heating phase, followed by a constant T simulation)
		sander -O -i md_1.in -o complex_md_1.out -p complex_leap.prmtop -c complex_min.ncrst -r complex_md.ncrst -x complex_md.nc
 		sander -O -i md_2.in -o complex_md_2.out -p complex_leap.prmtop -c complex_md_1.ncrst -r complex_md_2.ncrst -x complex_md_2.nc

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg

