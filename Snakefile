# Snakefile for BinSub evaluation
# Converts eval_script.sh into a Snakemake workflow

# Configuration
MOUNT_DIR = "mount"
DATASETS = ["coreutils_O3", "coreutils_O0"]
N_SAMPLES = 0
NUM_PROC_PER_RUN = 2
MICROBENCHMARKS = 1

# Rule to run all evaluations
rule all:
    input:
        expand("{mount_dir}/{dataset}/typehoon.jsonl", mount_dir=MOUNT_DIR, dataset=DATASETS),
        expand("{mount_dir}/{dataset}/algebraic_solver.jsonl", mount_dir=MOUNT_DIR, dataset=DATASETS)

# Rule for TypeHoon evaluation (without algebraic solver)
rule eval_typehoon:
    input:
        dataset = "{mount_dir}/{dataset}"
    output:
        results = "{mount_dir}/{dataset}/typehoon.jsonl",
        failure_log = "{mount_dir}/{dataset}/typehoon.fail.log"
    log:
        "{mount_dir}/{dataset}/typehoon.log"
    resources:
        cpus = NUM_PROC_PER_RUN
    params:
        n = N_SAMPLES,
        num_proc = NUM_PROC_PER_RUN,
        microbenchmarks = MICROBENCHMARKS
    shell:
        """
        docker run --rm -v $(pwd)/{wildcards.mount_dir}:/{wildcards.mount_dir} binsub \
            -m angr.utils.eval_binary_type_inference \
            -n {params.n} \
            -num_proc {params.num_proc} \
            -failure_log /{output.failure_log} \
            /{input.dataset} \
            -o /{output.results} \
            -microbenchmarks {params.microbenchmarks} > {log} 2>&1
        """

# Rule for algebraic solver evaluation
rule eval_algebraic_solver:
    input:
        dataset = "{mount_dir}/{dataset}"
    output:
        results = "{mount_dir}/{dataset}/algebraic_solver.jsonl",
        failure_log = "{mount_dir}/{dataset}/algebraic_solver.fail.log"
    log:
        "{mount_dir}/{dataset}/algebraic_solver.log"
    resources:
        cpus = NUM_PROC_PER_RUN
    params:
        n = N_SAMPLES,
        num_proc = NUM_PROC_PER_RUN,
        microbenchmarks = MICROBENCHMARKS
    shell:
        """
        docker run --rm -v $(pwd)/{wildcards.mount_dir}:/{wildcards.mount_dir} binsub \
            -m angr.utils.eval_binary_type_inference \
            -algebraic_solver \
            -n {params.n} \
            -num_proc {params.num_proc} \
            -failure_log /{output.failure_log} \
            /{input.dataset} \
            -o /{output.results} \
            -microbenchmarks {params.microbenchmarks} > {log} 2>&1
        """
