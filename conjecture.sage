# This file was *autogenerated* from the file converse_theorem_loop.sage

# Import all SageMath functionality
from sage.all_cmdline import *   # import sage library

# Define commonly used constants as Sage Integers
_sage_const_2 = Integer(2)
_sage_const_0 = Integer(0)
_sage_const_1 = Integer(1)
_sage_const_3 = Integer(3)

# Import useful SageMath and Python functionality
from sage.all import is_prime, carmichael_lambda, GF, expand
from collections import defaultdict

# -------------------------------------------------------------------------
# Computes the largest exponent m such that l^m divides N

def max_power(N, l):
    m = _sage_const_0
    while N % l == _sage_const_0:
        N //= l
        m += _sage_const_1
    return m

# -------------------------------------------------------------------------
# Partition elements of a group based on their congruence class mod (q-1)/l^m

def partition_by_mod_q_minus_l_power(group, q, l):
    mod_dict = defaultdict(list)
    m = max_power(q - 1, l)
    mod_base = (q - 1) // (l**m)
    for i in group:
        mod_val = i % mod_base
        mod_dict[mod_val].append(i)
    subgroups = []
    for mod_val in sorted(mod_dict.keys()):
        subgroups.append(sorted(mod_dict[mod_val]))
    return subgroups

# -------------------------------------------------------------------------
# Class to compute and analyze Gauss sums over GF(q^2)

class GaussSumTable:
    def __init__(self, q, additive_character_generator, multiplicative_character_generator, l):
        self.q = q
        self.l = l
        self.additive_character_generator = additive_character_generator
        self.multiplicative_character_generator = multiplicative_character_generator

        # Define finite field and group
        self.finite_field = GF(q**_sage_const_2)
        self.generator = self.finite_field.gen()
        self.finite_field_elements = list(self.finite_field)
        self.finite_field_multiplicative_group = [x for x in self.finite_field_elements if x != _sage_const_0]

        # Define ranges for theta and alpha indices
        N_theta = q**_sage_const_2 - _sage_const_1
        m_theta = max_power(N_theta, l)
        self.theta_range = N_theta // (l**m_theta)

        N_alpha = q - _sage_const_1
        m_alpha = max_power(N_alpha, l)
        self.alpha_range = N_alpha // (l**m_alpha)

        # Initialize Gauss sum table
        self.table = [[_sage_const_0 for _ in range(self.alpha_range)] for _ in range(self.theta_range)]
        self.compute_gauss_sum_table()

    # Fill the Gauss sum table with computed values
    def compute_gauss_sum_table(self):
        for theta in range(self.theta_range):
            for alpha in range(self.alpha_range):
                self.table[theta][alpha] = self.compute_gauss_sum(theta, alpha)

    # Compute Gauss sum for given theta and alpha values
    def compute_gauss_sum(self, theta, alpha):
        total = _sage_const_0
        for x in self.finite_field_multiplicative_group:
            additive_character_value = self.additive_character_generator**self.trace(x)
            theta_character_value = self.multiplicative_character_generator**(theta * self.log(x))
            alpha_character_value = self.multiplicative_character_generator**(alpha * self.get_norm_log(x))
            total += additive_character_value * theta_character_value * alpha_character_value
        return total

    # Compute the norm log used in alpha character
    def get_norm_log(self, x):
        return (self.q + _sage_const_1) * self.log(x)

    # Return discrete log of x base generator
    def log(self, x):
        return x.log(self.generator) if x != _sage_const_0 else _sage_const_0

    # Return trace of x in the finite field
    def trace(self, x):
        return x.trace()

    # Find all sets of identical rows in the Gauss sum table
    def find_identical_rows(self):
        n = len(self.table)
        visited = set()
        groups = []

        for i in range(n):
            if i in visited:
                continue
            group = [i]
            visited.add(i)
            for j in range(i + _sage_const_1, n):
                if j in visited:
                    continue
                match = True
                for k in range(len(self.table[i])):
                    if expand(self.table[i][k] - self.table[j][k]) != _sage_const_0:
                        match = False
                        break
                if match:
                    group.append(j)
                    visited.add(j)
            if len(group) > _sage_const_1:
                groups.append(group)
        return groups

    # Return a counterexample if identical rows exist and (q - 1) divisible by l
    def find_counterexamples(self, l, q):
        counterexamples = []
        if (q - _sage_const_1) % l == _sage_const_0:
            identical_groups = self.find_identical_rows()
            if identical_groups:
                identical_groups = sorted(identical_groups, key=len, reverse=True)
                counterexamples.append((l, q, identical_groups))
        return counterexamples

# -------------------------------------------------------------------------
# Factory function to generate a GaussSumTable with parameters from l and q

def fL_bar_gauss_sum_table(q, l):
    if not is_prime(l):
        raise ValueError("l must be a prime number!")
    prime_power_result = q.is_prime_power(get_data=True)
    if prime_power_result[_sage_const_1] == _sage_const_0:
        raise ValueError("Expected q to be a prime power!")

    # Extract base prime p of q
    p = prime_power_result[_sage_const_0]
    N = p * (q * q - _sage_const_1)
    m = max_power(N, l)
    N_prime = N // (l**m)
    c = carmichael_lambda(N_prime)
    F = GF(l**c)
    h = F.gen()

    return GaussSumTable(
        q,
        h**((l**c - _sage_const_1) // p),
        h**((p * (l**c - _sage_const_1)) // N_prime),
        l
    )

# -------------------------------------------------------------------------
# Check if q is of the form q = 1 + 2 * l^j for some integer j >= 1

def is_q_of_the_form_1_plus_2_l_j(q, l):
    if q <= 1:
        return False
    diff = q - _sage_const_1
    if diff % _sage_const_2 != _sage_const_0:
        return False
    diff //= _sage_const_2
    if diff == _sage_const_0:
        return False
    while diff % l == _sage_const_0:
        diff //= l
    return diff == _sage_const_1

# -------------------------------------------------------------------------
# Pretty-print the table of counterexamples

def print_counterexample_table(rows):
    if not rows:
        print("No counterexamples with restricted group size >= 3 found in the given ranges.")
        return

    rows.sort(key=lambda row: (row[0], row[1]))
    line = "-" * 64
    print(line)
    print("| {:^9} | {:^21} | {:^23} |".format(
        "(ℓ, q)",
        "θ₁|𝔽*_q = θ₂|𝔽*_q",
        "q = 1 + 2 ℓ^j"
    ))
    print(line)
    for (l_val, q_val, subgroup_size, bool_val) in rows:
        print("| {:^9} | {:^21} | {:^23} |".format(
            f"({l_val}, {q_val})",
            str(subgroup_size),
            "True" if bool_val else "False"
        ))
    print(line)

# -------------------------------------------------------------------------
# Main program loop

if __name__ == "__main__":
    # Get user input for upper bounds on ℓ and q
    l_upper = Integer(input("Enter the upper bound for prime l: "))
    q_upper = Integer(input("Enter the upper bound for prime-power q: "))

    table_rows = []

    # Iterate over prime ℓ values
    for l_candidate in range(2, l_upper + 1):
        l_val = Integer(l_candidate)
        if is_prime(l_val):
            # Iterate over prime-power q values
            for q_candidate in range(2, q_upper + 1):
                q_candidate_sage = Integer(q_candidate)
                prime_power_data = q_candidate_sage.is_prime_power(get_data=True)
                if prime_power_data[1] != _sage_const_0:
                    q_val = q_candidate_sage

                    # ONLY continue if q = 1 + 2 * l^j
                    if not is_q_of_the_form_1_plus_2_l_j(q_val, l_val):
                        continue

                    # Generate Gauss sum table and search for counterexamples
                    gauss_sum_table_object = fL_bar_gauss_sum_table(q_val, l_val)
                    counterexamples = gauss_sum_table_object.find_counterexamples(l_val, q_val)
                    for (_, _, identical_groups) in counterexamples:
                        largest_subgroup_size = 0
                        for group in identical_groups:
                            mod_subgroups = partition_by_mod_q_minus_l_power(group, q_val, l_val)
                            group_max = max(len(s) for s in mod_subgroups)
                            largest_subgroup_size = max(largest_subgroup_size, group_max)

                        # Determine whether this qualifies as a counterexample
                        counterexample_flag = largest_subgroup_size >= 3

                        table_rows.append((l_val, q_val, largest_subgroup_size, counterexample_flag))

    # Display formatted results
    print_counterexample_table(table_rows)
