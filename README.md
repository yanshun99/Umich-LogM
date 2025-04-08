# Failure of Converse Theorems of Gauss Sums Modulo ℓ  
_Yanshun Zhang (2025)_

This repository contains code developed to support the computational experiments detailed in the research article **"Failure of Converse Theorems of Gauss Sums Modulo ℓ"**. The aim of this project is to investigate the breakdown of the classical uniqueness of multiplicative characters—uniquely determined via twisted Gauss sums—when reduced modulo a prime ℓ . These deviations from classical behavior are systematically studied through the construction and analysis of modular Gauss sum tables.

A key theoretical framework motivating this study is the conjecture proposed by Bakeberg, Gerbelli-Gauthier, Goodson, Iyengar, Moss, and Zhang, which asserts that modular counterexamples to the classical converse theorem of Gauss sums are expected to arise precisely when the field size q satisfies the condition:

q = 2ℓ^i + 1 (for some integer i > 0)

This conjectural form delineates a structured family of field extensions wherein the uniqueness of characters, so robust in the complex case, may fail under modular reduction. The computational tools in this repository are designed to test and extend the boundaries of this conjecture by identifying and classifying new modular anomalies.

## Table of Contents
- [Structure](#structure)
- [To Get Started](#to-get-started)
- [Usage](#usage)
- [Contributors](#contributors)
- [Contact](#contact)

## Structure
This repository contains three core scripts used in the systematic investigation of modular counterexamples to the classical converse theorem of Gauss sums:

- **`pair_generator.py`**  
  This Python script generates candidate pairs (ℓ , q) where q = 1 + 2ℓ ^i for some i >= 1, and where q is also a prime power. These pairs serve as inputs to the subsequent Gauss sum analysis. The script returns the largest values of ℓ  and q among the generated pairs, providing useful upper bounds for computational loops.

- **`conjecture.sage`**  
  This SageMath program automates the construction of full twisted Gauss sum tables over Fℓ̄, given any (ℓ , q) pair from the generator. It identifies counterexamples by locating repeated rows in the table—i.e., sets of distinct multiplicative characters that yield identical Gauss sums under all twists. These repetitions, when observed, directly violate the classical converse theorem and suggest a failure of uniqueness in the modular setting.

- **`converse_theorem_info.sage`**  
  This script allows for detailed investigation of **individual** (ℓ , q) values. It computes and prints the corresponding Gauss sum table and explicitly highlights theta-character collisions, organizing them by their congruence classes. This tool is useful for confirming whether a given pair leads to a counterexample, regardless of whether it matches any specific conjectural form.

## To Get Started

### Prerequisites

To successfully run the scripts provided in this repository, ensure the following software dependencies are met:

- **SageMath**  
  Required for executing the `.sage` files. Visit [https://www.sagemath.org](https://www.sagemath.org) for installation instructions.

- **Python 3**  
  Required for running the `pair_generator.py` script. The script depends on the `sympy` library, which can be installed via `pip`.

### Installation
To set up the project locally, begin by cloning the repository and navigating to the project directory:

```bash
git clone https://github.com/yanshun99/Umich-LogM.git
cd Umich-LogM
```

## Usage

1. **Run the Pair Generator Script**  
   Command: `python pair_generator.py`  

2. **Evaluate Candidate Pairs with `conjecture.sage`**  
   Command: `sage conjecture.sage`  

3. **Check Specific $(\ell, q)$ Pairs with `converse_theorem_info.sage`**  
   Command: `sage converse_theorem_info.sage`  

## Contributors

James Evans, Xinning Ma, & Yanshun Zhang - undergraduate researcher
Dr. Elad Zelingher – project mentor
Calvin Yost-Wolff - graduate mentor

## Contact

**Yanshun Zhang**  
Email: [yanshun@umich.edu]