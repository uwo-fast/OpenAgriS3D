default:
    @just --list

# Render every design and test-print preset with --hardwarnings, and check their geometry
check:
    python3 tests/check_renders.py
