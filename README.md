# BinSub Artifact Release 

This directory contains all artifacts for the BinSub evaluation.


Directory listing:
* angr-type-inference: BinSub's fork of angr with the additional algebraic solver in algebraic_solver.py, as well as utilities for evaluation and merging evaluation results
* cle: BinSub's cle fork which contains fixes for loading DWARF information
* Dockerfile: the dockerfile to build a suitable python environment for running binsub/angr
* results.bak: original paper results 
* binsub.tar: prebuilt Dockerfile for reproducing the evaluation


## Installing the Docker Image

The prebuilt docker image can be installed on an x86 machine with docker running by running the command `docker load < binsub.tar`. If you would like to run the image on a non x86 machine it is recommended you follow the building instructions below.

## Running the Evaluation

We provide two scripts for running the evaluation that are outside the docker container:
* eval_script.sh
* produce_results.sh

These scripts run the docker commands necessary to run the comparative evaluation and produce timing and precision information. Please look at these scripts as example docker commands if you would like to run 
some other sort of test within docker.

From this directory (the directory with the readme) run `./eval_script.sh` once the docker image has been built or installed. You may have to run `chmod +x ./eval_script.sh` and `chmod +x ./produce_results.sh` to run the scripts directly. This will run Typehoon's evaluation then BinSub's evaluation through the docker image named: binsub. The benchmarks should produce typehoon.pkl and algebraic_solver.pkl in the `./mount` directory. The benchmark can take a long time to run, about a day and a half on Google Cloud Compute: [n2-standard-4](https://cloud.google.com/compute/docs/general-purpose-machines#n2_series) machine. The evaluation can be sped up by reducing the number of repeated experiments (currently set to 4), adding more paralell processes for machines with more cores, or setting the experiment size to a small number than 200 to get an approximate result. These changes can be performed by modifying the corresponding argument in `./eval_script.sh` for both targets.

Once the benchmarks terminate you can run `./produce_results.sh` to dump aggregated averages and the figure comparing Typehoon to BinSub. Example output looks like:
```
Number of comparable targets:  1568
0.8041135195805225
1568
1568
[('armel_xz.bin', 74544, 38398213947.0)]
0.8029608976155257
1568
1568
[('armel_xz.bin', 74544, 232690643.25)]
Tgt1 average diff:  1.6831431586323966
Tgt2 average diff:  1.6729650078609744
Tgt1 average time:  1514147895.0876913
Tgt2 average time:  24084671.4765625
```

Note that Typehoon's pkl file is passed as the first argument in `produce_results.sh` and BinSub's as the second argument. This means Tgt1 refers to Typehoon and Tgt2 refers to BinSub. So to compute the average speedup of BinSub over Typehoon we can compute `1514147895.0876913/24084671.4765625`. The relevant lines for the evaluation results are `Tgt1/Tgt2 average diff` which is the average distance of inferred types from the ground truth type for the target and `Tgt1/Tgt2 average time` which is the average time spent in the type simplification algorithm.

Additionally, the produce_results script will dump the figure comparing all samples in `mount/fig.svg`. To produce a figure scaled to only BinSub you can the flag `--disable_plot_file1` to only plot BinSub's results, or pass `--disable_plot_file2` to only plot Typehoon's results.

## Building a Modified Version of BinSub

After performing a source code modifiation a new version of the docker image can be built from this directory with the command `docker build -t binsub .`. Alternatively, source code can be modified directly in the docker container because angr is installed as editable in the container. 

Alternatively, you can use https://github.com/angr/angr-dev to setup an angr development environment. To do this clone angr-dev, then clone each repository in the Dockerfile to the angr-dev repo using the commit hash from the Dockerfile. Then copy angr-type-inference to angr-dev/angr and the cle fork provided to angr-dev/cle. You can then run  `./setup.sh -i -e angr`, `workon angr` (assuming you use virtualenv wrapper to create the angr virtualenv, otherwise find the virtualenv and activate it),  `pip install pyrsistent`, and `pip install matplotlib`. This will setup a local development environment where you can modify BinSub and Angr without requiring a Docker container.

The relevant files for BinSub are:
* `angr-type-inference/angr/analyses/typehoon/algebraic_solver.py`: BinSub's type solver based on algebraic subtyping
* `angr-type-inference/angr/utils/eval_binary_type_inference.py`: The evalaution script that runs a type inference algorithm on a directory of test binaries
* `angr-type-inference/angr/utils/merger_utils.py`: The aggregation and plotting script that takes two evaluation run results and produces an analysis of comparable results and plots those results. 
