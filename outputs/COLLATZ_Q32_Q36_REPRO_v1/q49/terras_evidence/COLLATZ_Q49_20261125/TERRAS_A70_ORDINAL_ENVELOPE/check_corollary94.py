"""Check only the integer bounds in the D4 <= 94 corollary."""

import json


def main():
    bound = 28**2 * 3**92
    cutoff = 27**2 * 2**146
    assert bound == 27**2 * 63504 * (3**41)**2
    assert 3**41 < 2**65 and 63504 < 2**16
    assert bound < cutoff
    assert 2**237 <= 6**92 < 2**238
    print(json.dumps({"status": "PASS", "H": 92, "a1_bounds": [3, 89],
                      "D4_upper": 94, "D5_upper": 237,
                      "strict_integer_margin": cutoff - bound,
                      "target_margin": 6**92 - 2**237}, indent=2))


if __name__ == "__main__":
    main()
