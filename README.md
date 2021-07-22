# model-checking-for-multi-agent-pathplanning
The project validates the coupled multi-agent path planning algorithm using formal methods and Spin model checking tool. The detailed description of the algorithm and results obtained can be found in Project_report.pdf.

## Softwares Used
1. Spin version 6.5.1
2. Python version 3.8

## How to run
First, promela file is rann using Spin model checker.
```
cd src
spin finalproj.pml
```
Depending on the test case chosen the program will output coordinates of robots from their starting position to ending position without collision.

To visualize the output
```
cd src
python3 env.py
```