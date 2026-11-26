"""Check height exclusions on the single Q46 affine witness."""

import json
from pathlib import Path
import sys


q46 = Path(__file__).resolve().parents[1] / "q46"
sys.path.insert(0, str(q46))
from check_label_switches import base_checker


def margin(n, terminal, depth):
    offset, stride = n
    value, increment = terminal
    powers_two = 2**depth
    powers_three = 3**depth
    return (powers_two * (value + 1) - powers_three * (offset - 1),
            powers_two * increment - powers_three * stride)


def main():
    oracle = base_checker()
    witness = json.loads((q46 / "CAMBIOS_ETIQUETA.json").read_text())["witness"]
    n = oracle.seed(witness["k"], witness["period"])
    values, _, book = oracle.trace(n, 73)
    assert list(book) == witness["original_book"]
    assert 3**47 > 2**74 and 3**12 > 2**19

    rows = []
    total_label = 0
    for j, record in enumerate(witness["chronology"]):
        clock = record["clock"]
        terminal = values[clock]
        theoretical_minimum = (42 + 9*j + 2*total_label) // 7 + 1
        depth = theoretical_minimum - 1
        assert min(margin(n, terminal, depth)) > 0
        while min(margin(n, terminal, depth + 1)) > 0:
            depth += 1
        assert max(margin(n, terminal, depth + 1)) <= 0
        rows.append({
            "T": clock, "renewals": j, "sum_labels": total_label,
            "lower_bound_symbolic": theoretical_minimum,
            "lower_bound_whole_cylinder": depth + 1,
            "affine_margin_at_last_excluded_depth": margin(n, terminal, depth),
        })
        total_label += record["label"]
    print(json.dumps({"status": "PASS", "original_book": book, "checkpoints": rows}, indent=2))


if __name__ == "__main__":
    main()
