# farm-tools-scad

Parametric OpenSCAD designs for small-scale farming tools, continuing the paper
[Applications of Open Source 3-D Printing on Small Farms](https://doi.org/10.12924/of2015.01010019)
([open-access copy](https://digitalcommons.mtu.edu/materials_fp/20)).

The [docs](docs/README.md) list every design. They are grouped into six categories:

- [Animal Management](docs/animal-management.md)
- [Food Processing](docs/food-processing.md)
- [Hand Tools](docs/hand-tools.md)
- [Hydroponics](docs/hydroponics.md)
- [Plant Management](docs/plant-management.md)
- [Water Management](docs/water-management.md)

Each design's OpenSCAD source is in `cad/<design>/`. Open a `.scad` file in
[OpenSCAD](https://openscad.org/), adjust its parameters in the Customizer, and
export an STL to print. CI renders with OpenSCAD development snapshot 2026.10.15.
The plant pot is a library of modules, so open one of its `examples/` or
`test-prints/` files instead.

## Contributing

To add a design or suggest one, open a pull request or an issue, or email
`cbrook49@uwo.ca` with what you need it to do.

## References

- Pearce, J. M. (2015). Applications of Open Source 3-D Printing on Small Farms. Organic Farming, 1(1), 19-35. https://doi.org/10.12924/of2015.01010019
  (open-access copy: https://digitalcommons.mtu.edu/materials_fp/20)

## Checks

`just check` renders every design and test-print preset with warnings as errors,
and compares each one's size and volume with its recorded values
(`tests/check_renders.py`). CI runs it on every pull request. A new `.scad` file
fails the check until it is added there. The check covers geometry only, not how a
print performs.

## Licence

The designs come from several authors, and each keeps its own licence: MIT for the
FAST Research Group's own designs, and CC BY-SA, CC BY-NC-SA, GNU GPL, BSD, CC0 or
public domain for the others. Two of them, the ant trap and the irrigation stakes,
are **not for commercial use**. [`LICENSING.md`](LICENSING.md) lists each design's
author, source and licence. If an attribution there is wrong or missing, please
open an issue.
