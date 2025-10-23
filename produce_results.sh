#!/bin/bash
docker run -v $(pwd)/mount:/mount binsub -m angr.utils.merger_utils /mount/typehoon.pkl /mount/algebraic_solver.pkl --out /mount/fig.svg