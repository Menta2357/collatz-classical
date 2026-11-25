"""Check one exact Q44 lift with both increasing and decreasing labels."""

import json

from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def base_checker():
    path = Path(__file__).resolve().parents[1] / "q44/verify_second_renewal.py"
    spec = spec_from_file_location("q44", path)
    checker = module_from_spec(spec)
    spec.loader.exec_module(checker)
    return checker


def exact_v2(number):
    assert number > 0
    return (number & -number).bit_length() - 1


def scale(label):
    return 3 * label + 4


def multiplier(label):
    return 3 ** (2 * label + 3)


def cylinder(labels, residue=1, bits=1):
    """Solve each required odd quotient backwards from a terminal residue."""
    for a, b in reversed(list(zip(labels, labels[1:]))):
        bits += scale(b)
        modulus = 2**bits
        residue = (1 + 2**scale(b) * residue) * pow(multiplier(a), -1, modulus) % modulus

    exponent = scale(labels[0]) + 8
    modulus = 2 ** (bits + exponent)
    base, slope = 3384512724039106948104, 3**47
    t = (256 + 2**exponent * residue - 81 * base) * pow(81 * slope, -1, modulus) % modulus
    return 521 + 4096 * t, 4096 * modulus


def verify(labels, residue=1, bits=1):
    oracle = base_checker()
    k, period = cylinder(labels, residue, bits)
    original = oracle.seed(k, period)
    end_clock = 53 + sum(2 * a + 3 for a in labels[:-1])
    values, word, book = oracle.trace(original, end_clock)
    oracle.check_renewals(values, word, 3 * labels[0] + 1)
    assert all(oracle.below(original, point) for point in values[53:])
    clock = 53
    records = []
    for label in labels:
        value, slope = values[clock]
        divisor = 36 * 8**label
        assert (value + 5) % divisor == slope % divisor == 0
        z, stride = (value + 5) // divisor, slope // divisor
        assert z % 2 == 1 and stride % 2 == 0
        rho = exact_v2((multiplier(label) - 2**scale(label)) * z - 1)
        records.append({"label": label, "clock": clock, "z": z, "stride": stride, "rho": rho})
        if clock != end_clock:
            count = 2 * label + 3
            assert word[clock:clock + count] == [1, 2] * label + [1, 1, 2]
            clock += count
    for left, right in zip(records, records[1:]):
        a, b = left["label"], right["label"]
        assert 2**scale(b) * right["z"] == multiplier(a) * left["z"] - 1
        assert 2**scale(b) * right["stride"] == multiplier(a) * left["stride"]
        if a == b:
            assert left["rho"] - right["rho"] == scale(a)
        else:
            assert left["rho"] == min(scale(a), scale(b))
    return {"k": k, "period": period, "original_book": book, "chronology": records}


def verify_recharge(height):
    bits = height + 1
    terminal = (1 + 2**height) * pow(multiplier(2) - 2**scale(2), -1, 2**bits) % 2**bits
    row = verify([1, 2], terminal, bits)
    first, last = row["chronology"]
    assert (first["rho"], last["rho"]) == (7, height)
    return row


if __name__ == "__main__":
    alternating = verify([1, 1, 0, 2, 1])
    price_loss = verify([0, 0, 0])
    oracle = base_checker()
    n = oracle.seed(price_loss["k"], price_loss["period"])
    first, _, last = price_loss["chronology"]
    assert oracle.below((first["z"], first["stride"]), n)
    assert oracle.below(n, (last["z"], last["stride"]))
    print(json.dumps({"status": "PASS", "witness": alternating, "price_loss": price_loss,
                      "recharge_to_32": verify_recharge(32)}, indent=2))
