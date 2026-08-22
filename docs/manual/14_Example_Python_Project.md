# 14. Example Python project

| Field | Value |
|---|---|
| Document type | User manual, Clause 14 |
| Part of | [Index](index.md) |

## 14.1 Purpose

This clause provides a small, dependency-free Python project. It gives a
reader a concrete project to scan and inspect without locating or
constructing one independently.

## 14.2 Files

Two files, placed together at a project root, form a valid, detectable
Python project.

`pyproject.toml`:

```toml
[project]
name = "iderm-python-example"
version = "0.1.0"
requires-python = ">=3.10"
```

`iderm_python_template.py`:

```python
#!/usr/bin/env python3
"""Small, dependency-free Python project specimen for IDERM."""

from __future__ import annotations

import argparse
import math
from dataclasses import dataclass


@dataclass(frozen=True)
class Measurement:
    """One scalar measurement with a unit."""

    name: str
    value: float
    unit: str


def calculate_power(voltage: float, current: float) -> float:
    """Calculate electrical power: P = U × I."""
    return voltage * current


def calculate_rms(samples: list[float]) -> float:
    """Calculate RMS for a finite sequence of samples."""
    if not samples:
        raise ValueError("RMS requires at least one sample")

    mean_square = sum(sample * sample for sample in samples) / len(samples)
    return math.sqrt(mean_square)


def parse_measurement(line: str) -> Measurement:
    """Parse: voltage=12.4 V"""
    try:
        name, raw_value = line.split("=", 1)
        value_text, unit = raw_value.strip().split(maxsplit=1)
        return Measurement(name.strip(), float(value_text), unit.strip())
    except ValueError as exc:
        raise ValueError(f"Invalid measurement: {line!r}") from exc


def demo() -> None:
    voltage = 12.0
    current = 0.75

    print(f"Voltage : {voltage:.2f} V")
    print(f"Current : {current:.2f} A")
    print(f"Power   : {calculate_power(voltage, current):.2f} W")
    print(f"RMS     : {calculate_rms([0.0, 1.0, -1.0, 1.0, -1.0]):.3f}")


def main() -> int:
    parser = argparse.ArgumentParser(description="IDERM Python example")
    parser.add_argument(
        "--measurement",
        metavar="TEXT",
        help="parse a measurement such as 'temperature=42.5 C'",
    )
    args = parser.parse_args()

    if args.measurement:
        measurement = parse_measurement(args.measurement)
        print(f"{measurement.name}: {measurement.value:.3f} {measurement.unit}")
        return 0

    demo()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```

## 14.3 Detection

The default Python manifest detects a project by the presence of
`pyproject.toml` at the project root. `iderm_python_template.py` is
ordinary source; it does not itself trigger detection. See
[Configuration and plugins](04_Plugins.md).

Detected fields:

| Field | Value |
|---|---|
| Language label | Python (pyproject.toml) |
| LSP binary | `pylsp` |
| Declared task | `pytest` |

## 14.4 What the example demonstrates

The file is intentionally small and self-contained:

- `Measurement`, a frozen dataclass holding one scalar value with a unit;
- `calculate_power`, a pure function;
- `calculate_rms`, a pure function that raises `ValueError` on empty
  input rather than returning a plausible-looking wrong answer;
- `parse_measurement`, a small parser with a clear failure message; and
- a minimal `argparse` command-line interface.

No third-party dependency is required.

```sh
python3 iderm_python_template.py
python3 iderm_python_template.py --measurement "temperature=42.5 C"
```

## 14.5 Trying it

```sh
mkdir python-example && cd python-example
# create pyproject.toml and iderm_python_template.py as shown above
iderm .
```

Doctor shall report a detected Python manifest. `pylsp`, if installed, is
available for an on-demand LSP check with `l`. The declared `pytest` task
appears in the task list if `pytest` is installed. This example defines
no test file, so a run reports zero tests collected, not a failure.
