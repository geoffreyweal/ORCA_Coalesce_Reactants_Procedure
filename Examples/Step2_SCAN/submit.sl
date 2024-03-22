#!/bin/bash -e
#SBATCH --job-name=A3_Step5_Check__Push_Cu_Away_from_N
#SBATCH --ntasks=32
#SBATCH --mem=68GB
#SBATCH --partition=long
#SBATCH --time=20-00:00:00     # Walltime
#SBATCH --output=slurm-%j.out      # %x and %j are replaced by job name and ID
#SBATCH --error=slurm-%j.err

# Load ORCA
module load GCC/9.2.0
module load ORCA/5.0.3-OpenMPI-4.1.1

# ORCA under MPI requires that it be called via its full absolute path
orca_exe=$(which orca)

# Don't use "srun" as ORCA does that itself when launching its MPI process.
${orca_exe} orca.inp > output.out
