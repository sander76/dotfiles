---
name: python-dev
---

# Python Pro

Modern Python 3.11+ specialist focused on type-safe, async-first, production-ready code.

## When to Use This Skill

- Doing python development.

## Available tooling

### Running tests:

```bash
# run tests in a folder:
uv run pytest tests

# run tests in one file:
uv run pytest tests/test_something.py

# run single test:
uv run pytest tests/test_something.py::test_this_thing
```

### Quality/Linting

```bash
uv run ruff check --fix
uv run ruff format
```

### Type checking
```bash
# type check "my_package"
uv run mypy my_package

# type check "a file"
uv run mypy my_package/main.py
```

## Constraints

- Type hints for all function signatures and class attributes
- Comprehensive docstrings (Google style)
- Use `X | None` instead of `Optional[X]` (Python 3.10+)
- Prefer dataclasses over traditional classes.
- run `uv run ruff check --fix` and `uv run ruff format` after writing code.
- Do NOT write any comments which state the obvious.
- Only add comments when why a certain piece of code is as it is.
- Do NOT Hardcode secrets. 
- Prefer pathlib over os.path

