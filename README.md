# Checking the Energy for Coalescing Reactants

Consider the mechanistic step below:

<p align="center">
    <img src="Figures/Mechanistic_Step/Main_Mechanistic_Step.png" alt="Mechanistic Step Example" width="500"/>
</p>

Here, we want to determine the transition state for a Cu inserting itself into the C-H bond of the alpha bond in benzylamine. However, as we need to allow the reactants to coalesce in this mechanistic step, it is usually better to split this mechanistic step into two steps:

1. Reactants coalesce such that the Cu metal coordinates to the benzylamine
2. Cu inserts into the C-H bond. 

![Mechanistic Step Part 1](Figures/Mechanistic_Step/Split_Mechanistic_Steps_Step_1.png)

In this article, we will look at how to determine the energy released for the reactants to coalesce together. Here, this means the energy released when the Cu atom coordinates to the benzylamine. 


## Questions and Feedback

I am very keen for feedback about how you find the information in this github page, both the process and the clarity of what I have written. If you have any questions about this process, feed free to write me a message. 

To do this, click on the ``Issues`` tag at the top of this Github page, click the ``New issue`` button, and write you question/give you feedback. 

Thanks!


## ORCA

I have written this procedure for: 

* ORCA 5.0.3
* ORCA 5.0.4

This method should be valid for future versions of ORCA, but just in case any problems occur it may be due to ORCA version issues. 


## Before beginning

Read the **Before beginning** section of https://github.com/geoffreyweal/ORCA_Mechanism_Procedure

# Coalescing Reactants

## Pre-calculation step:

Before beginning, you need to decide what universal setting you want to use for your mecahnisms. This includes the basis set, functional, solvent model, etc. For example: 

```
!B3LYP DEF2-TZVP D3BJ
%CPCM EPSILON 6.02 REFRAC 1.3723 END
```

Other options that are good to include in all your orca input files are:

```
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%PAL NPROCS 32 END # The number of CPUs you want ORCA to use
%maxcore 2000 # This indicates you want ORCA to use only 2GB per core maximum, so ORCA will use only 2GB*32=64GB of memory in total.
```

**RECOMMENDATIONS**: With regards to the functional, basis set, solvent model, etc., it is recommended that you discuss what you are wanting to do with a computational chemist (if you are not a computational chemist) to get advice about how to set up these, as well as how to proceed with your project. This is important because you want to keep these as consistent as possible across all your mechanistic steps you perform. I would personally recommend reading other computation papers related to the system you are looking at understanding, as well as reading the following papers to understand what functional and basis set is most appropriate for your project:
* https://onlinelibrary.wiley.com/doi/epdf/10.1002/anie.202205735 (This paper is VERY recommended to non-computational chemists and computational chemist. It is a very good guide at all the considerations you should make and best Practices)
* https://pubs.rsc.org/en/content/articlelanding/2017/cp/c7cp04913g (The results section (particularly the end of the results section) provides a list of good functionals to use based on scientific validations)
* https://bpb-ap-se2.wpmucdn.com/blogs.unimelb.edu.au/dist/0/196/files/2021/05/GOERIGK_GroundStateDFT_RACI2021_handout.pdf (Slides from Larz Goerik based on the paper above)
* https://www.publish.csiro.au/CH/CH20093 (This paper give an idea of what you need to think about for excited state calculations)

## Step 1: Locally optimise the co-ordinated/coalesced system

First we need to locally optimize the co-ordinated/coalesced system (following step 1 of the ORCA Mechanism Procedure)[https://github.com/geoffreyweal/ORCA_Mechanism_Procedure?tab=readme-ov-file#step-1-locally-optimize-reactant-and-product]. 
* In this example, the co-ordinated/coalesced system is called the ``Product``. (The ``Product`` here is the ``Reactant`` from the [ORCA Mechanism Procedure example](https://github.com/geoffreyweal/ORCA_Mechanism_Procedure))


To do this, make a ``Product`` folder and add to each folder the ``.inp`` file for performing local optimisations. Make sure you include the following into your ``.inp`` files for the product:

```
!OPT FREQ TightOPT TightSCF defgrid2
```

Here, we perform a geometry optimization to optimize the system. The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform a local optimisation. 
* ``FREQ``: Indicates you want ORCA to calculation the vibrational frequency for your molecule. This is used to verify that your optimised structure is indeed a local minimum. This will also give you the Gibbs free energy for your molecule that you (may) want to report as your energy. 
* ``TightOPT``: Tells ORCA to tighten the convergence criteria for each geometric step. See ORCA 5.0.4 Manual, page 20 for more info.
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default).

**NOTE 1**: I have set the electronic optimisation steps to be tight (``TightSCF``). This is just to make sure the electronic are well converged, but it may be overdo. If you have problems, you can try using the normal convergence criteria for the electronic steps (``NormalSCF``)

**NOTE 2**: [Click here](https://sites.google.com/site/orcainputlibrary/numerical-precision?authuser=0) for more information about other electronic convergence and interaction grid settings.

An example of the complete ``orca.inp`` file for a local optimisation ORCA job is as follows (from ``Examples/Step1_Geo_Opt/Products/orca.inp``): 

```orca.inp
!B3LYP DEF2-TZVP D3BJ 
!OPT FREQ TightOPT TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000 # This indicates you want ORCA to use only 2GB per core maximum, so ORCA will use only 2GB*32=64GB of memory in total.
* xyzfile 1 1 product.xyz

```

**NOTE 3**: Make sure you include a newline or two at the end of your ``orca.inp`` file, otherwise ORCA will get confused and not run.

Here, ``xyzfile`` allows you to import an xyz file into ORCA. You can add the xyz data directly in the ``.inp`` file, but I find having a separate ``xyz`` file is better because this allow you to look at the xyz file in a gui like in atomic simulation environment (ASE --> https://wiki.fysik.dtu.dk/ase/ase/gui/basics.html and https://wiki.fysik.dtu.dk/ase/ase/gui/gui.html). Include the ``xyz`` files of your product molecule in the ``Product`` folders, respectively.

Submit the job to slurm using the ``submit.sl`` file:

```bash
#!/bin/bash -e
#SBATCH --job-name=A_Coalesce_Step1_Product
#SBATCH --ntasks=32
#SBATCH --mem=68GB
#SBATCH --partition=large
#SBATCH --time=3-00:00     # Walltime
#SBATCH --output=slurm-%j.out      # %x and %j are replaced by job name and ID
#SBATCH --error=slurm-%j.err
#SBATCH --nodes=1 # OpenMPI can have problems with ORCA over multiple nodes sometimes, depending on your system.

# Load ORCA
module load GCC/9.2.0
module load ORCA/5.0.3-OpenMPI-4.1.1

# ORCA under MPI requires that it be called via its full absolute path
orca_exe=$(which orca)

# Don't use "srun" as ORCA does that itself when launching its MPI process.
${orca_exe} orca.inp > output.out

```

**NOTE 4**: While ORCA has been told to use 2000 (MB) * 32 = 64 GB in the ``.inp`` file, we have told slurm to reserve ``72GB`` of memory. It is a good idea to give your ORCA job a few GBs of RAM extra in slurm just in case ORCA accidentally goes over it's allocated RAM. Here, I have abitrarily given this job 12GB more RAM just in case. 


### Outputs from ORCA

When ORCA is running, it will output several files, including an ``output.out`` file, an ``orca.xyz`` file, and an ``orca_trj.xyz`` file.

* ``output.out``: This file contains the details about how ORCA ran. This includes the vibrational frequency data to check if the locally optimised structure is in fact a local minimum.
* ``orca.xyz``: This is the locally optimised molecule. 
* ``orca_trj.xyz``: This file shows how ORCA locally optimised the molecule. Type ``viewOPT`` into the terminal to view how the molecule was optimised, including an energy profile. 

Once ORCA has finished, you should do the following checks:

#### Check 1: Look at your molecule and the energy profile and make sure it looks ok

The first thing to do is to look at your molecule and check if it looks sensible with your chemical intuition. You can do this by opening up the ``orca.xyz`` in your favourite GUI. I like to use atomic simulation environment (ASE). To look at the molecule and its energy profile:

1. Open a new terminal
2. ``cd`` into the optimisation folder
3. Type ``viewOPT`` into the terminal

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step1_Geo_Opt/Products

# View the optimisation 
viewOPT
# or directly view the orca_trj file.
ase gui orca_trj.xyz
# or save the OPT_images.xyz file only and copy it back to your computer
# to view with ``ase gui OPT_images.xyz`` (if you are using a HPC).
viewOPT False
```

**NOTE 1**: If ``viewOPT`` does not work, type ``ase gui orca_trj.xyz`` into the terminal instead of ``viewOPT``. 

**NOTE 2**: ``viewOPT`` will also create a xyz file called ``OPT_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 
* If you just want to create the ``OPT_images.xyz`` file, type into the terminal ``viewOPT False`` (which will create the ``OPT_images.xyz`` file). 

Here, you want to **check that the molecule looks ok from your chemical and physical intuition**. Here is an example of what the optimised molecule looks like (the ``orca.xyz`` file here). If we look at the initial molecule geometry (by typing ``ase gui product.xyz`` into the terminal), we can see how the molecule has changed after being geometrically optimised: 

![Opt Image](Figures/1_Opt/opt_example.png)

``viewOPT`` will also show you the energy profile for this optimisation. 

![Opt Energy Profile](Figures/1_Opt/opt_energy.png)


#### Check 2: Did the geometry optimisation converge successfully

You want to look for a table in the ``output.out`` file for a table with the title ``Geometry convergence``. There will be many of these tables, as one is given for each geometric step performed. You want to look at the last ``Geometry convergence`` table as this will give the detailed for the lastest geometrically optimised step. An example for the ``Products`` is given below:

```
                                .--------------------.
          ----------------------|Geometry convergence|-------------------------
          Item                value                   Tolerance       Converged
          ---------------------------------------------------------------------
          Energy change      -0.0000000633            0.0000010000      YES
          RMS gradient        0.0000146520            0.0000300000      YES
          MAX gradient        0.0000503939            0.0001000000      YES
          RMS step            0.0001725590            0.0006000000      YES
          MAX step            0.0007414837            0.0010000000      YES
          ........................................................
          Max(Bonds)      0.0004      Max(Angles)    0.02
          Max(Dihed)        0.03      Max(Improp)    0.00
          ---------------------------------------------------------------------

                    ***********************HURRAY********************
                    ***        THE OPTIMIZATION HAS CONVERGED     ***
                    *************************************************
```

ORCA also tells you this by giving you a ``HURRAY`` message as well as a ``THE OPTIMIZATION HAS CONVERGED`` message (as you can see in above). 

#### Check 3: Does the molecule have any non-negative vibrational frequencies

After performing a local optimization, it is important that you look at the vibrational frequencies that are calculated. These are the frequencies that you could see in an IR or Raman spectra. You want to look through your ``.out`` file for a heading called ``VIBRATIONAL FREQUENCIES``. **We want to make sure that all the frequencies are non-negative**. This means we are in a local energy well. If one or more frequency is negative, this means we are not in a local minimum. In this case, you need to tighten the optimization, or need to look at your molecule and see if any part of it structurally does not make sense with your chemical intuition. 

In the example below (for ``Products``), you can see that there are no non-negative frequencies from the ``FREQ`` calculation, therefore we are in a local energy well: 

```
-----------------------
VIBRATIONAL FREQUENCIES
-----------------------

Scaling factor for frequencies =  1.000000000  (already applied!)

   0:         0.00 cm**-1
   1:         0.00 cm**-1
   2:         0.00 cm**-1
   3:         0.00 cm**-1
   4:         0.00 cm**-1
   5:         0.00 cm**-1
   6:        43.32 cm**-1
   7:        70.57 cm**-1
   8:       103.93 cm**-1
   9:       150.58 cm**-1
  10:       297.27 cm**-1
  11:       347.68 cm**-1
  12:       413.00 cm**-1
  13:       424.12 cm**-1
  14:       509.82 cm**-1
  15:       531.31 cm**-1
  16:       628.64 cm**-1
  17:       635.82 cm**-1
  18:       727.65 cm**-1
  19:       775.31 cm**-1
  20:       819.16 cm**-1
  21:       862.24 cm**-1
  22:       924.51 cm**-1
  23:       937.85 cm**-1
  24:       978.42 cm**-1
  25:       988.87 cm**-1
  26:      1016.58 cm**-1
  27:      1021.93 cm**-1
  28:      1048.64 cm**-1
  29:      1072.65 cm**-1
  30:      1103.98 cm**-1
  31:      1158.35 cm**-1
  32:      1180.38 cm**-1
  33:      1195.06 cm**-1
  34:      1232.03 cm**-1
  35:      1309.40 cm**-1
  36:      1344.54 cm**-1
  37:      1363.42 cm**-1
  38:      1394.22 cm**-1
  39:      1483.96 cm**-1
  40:      1495.53 cm**-1
  41:      1526.49 cm**-1
  42:      1618.08 cm**-1
  43:      1621.16 cm**-1
  44:      1636.61 cm**-1
  45:      3066.60 cm**-1
  46:      3116.54 cm**-1
  47:      3129.59 cm**-1
  48:      3172.82 cm**-1
  49:      3181.46 cm**-1
  50:      3189.87 cm**-1
  51:      3199.56 cm**-1
  52:      3469.06 cm**-1
  53:      3533.10 cm**-1
```


## Step 2: Move the two Reactants from eachother using a SCAN calculation

We will now move the Cu atom away from the benzylamine in this example using a SCAN calculation. To perform a SCAN, we first include this line in our input file:

```
!OPT NormalOPT TightSCF defgrid2 # Try TightOPT if you have convergence problems. 
```

The tags here indicate you want to do the following: 

* ``OPT``: Indicates you want ORCA to perform a local optimisation. 
* ``NormalOPT``: For these calculations we are only wanting to get a good idea of what the transition state looks like. So we dont need to both with using tight convergence settings. Normal convergence sets is perfect for SCAN as it is the usual convergence criteria for performing optimisations, as will run faster than using ``TightOPT``. However, if you have problems with convergence issues, you can try using ``TightOPT``. See ORCA 5.0.4 Manual, page 20 for more info.
* ``TightSCF``: Tells ORCA to tighten the convergence criteria for each electronic step. 
* ``defgrid2``: Indicates how fine we want the intergration grid to be (This is the default)

We also include the following lines:

```
%geom 
    SCAN B 2 17 = 2.693, 30.693, 1401 END 
END
```

In this example, we have told ORCA to begin by setting the distance between atom 2 (one of the C atoms in the benzene ring) and 17 (the Cu atom) to 2.693 Å, and then increase the distance between these two atoms to 30.693 Å in increments of $\frac{30.693-2.693}{1401-1} = 0.02$ Å. 

**NOTE 1**: You will want to measure the initial distance between your two atoms using a GUI like ASE GUI. This is the value you want to put in for the initial bond distance. This is how I got the bond distance between atom 2 and 17 to 2.693 Å for this example. 

**NOTE 2**: ORCA counts atoms starting from 0. This means that in some GUIs (like GView), atom 2 here is atom 3 in GView. **In the ASE GUI and all the programs given here, atoms numbers are equal to ORCA. I.e.: atom 2 in the ASE GUI means atom 2 in ORCA**. 

**NOTE 3**: We have set the number of steps to perform to 1401 rather than 1400. This is because we are including the endpoint in our SCAN, and I want the increments to be spaced by a rational value (i.e.: $\frac{30.693-2.693}{1401-1} = 0.02$ Å step size). This is just a personal preference of mine, and is not a hard rule. 

In this example, we are looking at how a Cu atom could insert itself into a C-H bond. The ``orca.inp`` file for this example is given below (from ``Examples/Step2_SCAN/orca.inp``):

**NOTE 4**: I would recommend using the ``NormalOPT`` convergence settings for SCAN calculations. This is because we are using the SCAN method to roughly make sure that we dont have a transition state, or if it does roughly figuring out what the transition state structure is. ``NormalOPT`` convergence setting is faster than ``TightOPT``, so allows you to try more variations if you run into problems in this state. Also, the  ``NormalOPT`` convergence setting is good, no doubt about it; I am just use to using ``TightOPT``. If you have problems, try tightening the convergence using ``TightOPT``. 

```
!B3LYP DEF2-TZVP D3BJ
!OPT NormalOPT TightSCF defgrid2
%SCF
    MaxIter 2000       # Here setting MaxIter to a very high number. Intended for systems that require sometimes 1000 iterations before converging (very rare).
    DIISMaxEq 5        # Default value is 5. A value of 15-40 necessary for difficult systems.
    directresetfreq 15 # Default value is 15. A value of 1 (very expensive) is sometimes required. A value between 1 and 15 may be more cost-effective.
END
%CPCM EPSILON 6.02 REFRAC 1.3723 END
%PAL NPROCS 32 END
%maxcore 2000
%geom 
    SCAN B 2 17 = 2.693, 30.693, 1401 END 
END
* xyzfile 1 1 reactant_opt.xyz

```

### Outputs from ORCA

As well as the ``output.out`` and ``orca_trj.xyz`` files, ORCA will also get:

* A series of files called ``orca.001.xyz``, ``orca.002.xyz``, ``orca.003.xyz``, ... up to ``orca.126.xyz``. These are the steps in the SCAN process. 

**NOTE**: The ``orca_trj.xyz`` contains the xyz files for every geometric step across all ``orca.ABC.xyz`` file, so it is not as useful in it's own. However make sure you keep it, because it is used by the ``viewSCAN`` program.

To view the SCAN mechanism and the energy path, type ``viewSCAN`` in the terminal and hit enter. This will load a program that will allow you to see how the SCAN calculation performed your mechanism, along with the energy profile. 

```bash
# cd into your optimisation folder
cd ORCA_Mechanism_Procedure/Examples/Step2_Find_TS/SCAN

# View the SCAN calculation 
viewSCAN
# or save the SCAN_images.xyz file only and copy it back to your computer
# to view with ``ase gui SCAN_images.xyz`` (if you are using a HPC).
viewSCAN False
```

**NOTE 1**: ``viewSCAN`` will also create a xyz file called ``SCAN_images.xyz`` that you can copy to your computer if you are using a high-capacity computer (HPC) system and view on your own computer. 
* If you just want to create the ``SCAN_images.xyz`` file, type into the terminal ``viewSCAN False`` (which will create the ``SCAN_images.xyz`` file). 

You will get a GUI that shows you the following SCAN pathway:

![SCAN Images](Figures/2A_SCAN/SCAN_example.gif)

The energy profile for this example is given below:

![SCAN Energy Profile](Figures/2A_SCAN/SCAN_energy.png)

### Analysis of Output

Unfortunately, this SCAN failed during the calculation. However it doesnt matter because we only wanted to use the SCAN to understand how the energy changes as the Cu atom dissociates from the benzylamine, which from the GIF we can see the Cu atom has moved well away from the nitrogen atom in benzylamine. So I am happy that there is no transition state and the Cu atom naturally would want to coordinate with the nitrogen atom, as is probably expected. 
* Note: I am ignoring any energy requirements to remove the solvent shell. This wasn't the point of this exercise. We just wanted to confirm there is no transition state. 


### Advice about SCANs

In this example, I got the SCAN calculation to gradually increase the distance between Cu and a carbon in the benzene group. 
* I actually first tried increasing the distance between the nitrogen of benzylamine and Cu. However, this did not work because the Cu wanted to attach to the benzene via pi-bonding, and then for some reason ORCA kept crashing. 
* It is common that you need to try the SCAN calculation where you try increasing the distance between different atoms. Some just wont work, and some will work nicely.
* In this case, it turned out that forcing the increase in distance between the benzene ring (via atom 2) and Cu worked. 

### Other Information about performing SCANs in ORCA

See https://sites.google.com/site/orcainputlibrary/geometry-optimizations/tutorial-saddlepoint-ts-optimization-via-relaxed-scan for more information. 


## Step 3: Obtain the energy of the reactants

We now want to repeat step 1 for each of the components in the un-coalesced molecules. In this case, there are two systems, benzylamine and Cu<sup>+</sup>. 

There is nothing new to learn from step 1, everything is exactly the same. See the outputs for this system in ``Examples/Step3_Geo_Opt/Reactants``. 

## Step 4: Check that you are happy

Before finalising everything, it is important to do a final check that everything is all good and that there are no issues with your output files from this proceedure and you are happy with all the calculations and the decisions you made, as this process is often not smooth and requires playing around. So finalising everything is a good idea to make sure you haven't missed anything important. 

## Step 6: Obtain the energies and structures of your reactants, products, and transition state

We now can obtain the energies and structures for the reactant, product, and transition state. To do this, we want to compare the energies of the ``Reactant`` and ``Product`` with the ``Forward`` and ``Backwards`` structure from Step 4B steps. It is good to do this because sometimes the structures from 4B might be slightly lower energy than what was obtain from Step 1. 

**NOTE 1**: We want to take the Gibb's Free Energy, so make sure you take this energy value from the ``output.out`` files. We can obtain this value because we have run the vibrational frequency calculation, which allows the vibrational entropy to be calculated. You will find these if you look for the ``GIBBS FREE ENERGY`` header in the ``output.out`` file. 

**NOTE 2**: The energy values you get will be in hartrees (unit are Eh or Ha). It is important to record the whole hartrees energy value to the full decimal places. 

In this example:
* The energy of the ``Reactant`` is -1967.08223843 Eh, while the ``Backwards`` structure from Step 4B did not converge. As we saw in Step 5 the ``Reactant`` and ``Backwards`` structures are very similar, so I would not be worried about this, and take the ``Reactant`` structure as the reactant. 
* The energy of the ``Product`` is -1967.03515273 Eh, while the energy of the ``Forwards`` structure from Step 4B is -1967.03512026 Eh. The ``Product`` structure has a lower energy than the ``Forwards`` structure. 

From Step 3, the energy of the transition state is -1967.01474746 Eh. 

**NOTE 3**: Record all these numbers, as you will need the absolute values when collecting the energy for all the mechanistic step across the one or more mechanisms that you are studying. 

**NOTE 4**: The conversion from Hartrees (Eh or Ha) to kJ/mol to multiply the Hartree energy by 2625.5 to get the energy in kJ/mol

The energy profile for this example is shown below

![Energy Profile for this example](Figures/6_Info/Energy_Profile.png)

Here: 
* The energy from the reactant to transition state is $-1967.01474746 \rm{Eh} - -1967.08223843 \rm{Eh} = 0.06749096999 \rm{Eh}$ which in kJ/mol is $0.06749096999 \rm{Eh} * 2625.5 = 177.2 \rm{kJ/mol}$ (1dp).
* The energy from the product  to transition state is $-1967.01474746 \rm{Eh} - -1967.03515273 \rm{Eh} = 0.02040526999 \rm{Eh}$ which in kJ/mol is $0.02040526999 \rm{Eh} * 2625.5 = 53.6  \rm{kJ/mol}$ (1dp).

So the activation energy for this reaction is 177 kJ/mol. 



