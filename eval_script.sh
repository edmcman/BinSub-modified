#!/bin/bash

set -euxo pipefail

docker run -v $(pwd)/mount:/mount binsub -m angr.utils.eval_binary_type_inference -n 200 -num_proc 2 -failure_log /mount/fail_typehoon2 /mount/mixed_dataset -o /mount/typehoon.jsonl -microbenchmarks 4
docker run -v $(pwd)/mount:/mount binsub -m angr.utils.eval_binary_type_inference -algebraic_solver -n 200 -num_proc 2 -failure_log /mount/fail_algebraic_solver2 /mount/mixed_dataset -o /mount/algebraic_solver.jsonl -microbenchmarks 4