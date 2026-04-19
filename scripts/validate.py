#!/usr/bin/env python3
"""
validate.py — validate a workspace.yml against the HPK JSON Schema

Usage:
    python3 scripts/validate.py examples/content-creator/workspace.yml

Exit codes:
    0 — valid
    1 — validation error or file not found

Requires:
    pip install jsonschema pyyaml
"""

import sys
import json
import pathlib
import yaml

try:
    import jsonschema
    from jsonschema import validate, ValidationError
except ImportError:
    print("ERROR: jsonschema not installed. Run: pip install jsonschema pyyaml", file=sys.stderr)
    sys.exit(1)

SCRIPT_DIR = pathlib.Path(__file__).parent
REPO_ROOT = SCRIPT_DIR.parent
SCHEMA_PATH = REPO_ROOT / "schema" / "workspace.schema.json"


def load_schema():
    if not SCHEMA_PATH.exists():
        print(f"ERROR: Schema not found at {SCHEMA_PATH}", file=sys.stderr)
        sys.exit(1)
    with SCHEMA_PATH.open() as f:
        return json.load(f)


def load_workspace(path: pathlib.Path):
    if not path.exists():
        print(f"ERROR: workspace.yml not found at {path}", file=sys.stderr)
        sys.exit(1)
    with path.open() as f:
        return yaml.safe_load(f)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/validate.py <path/to/workspace.yml>", file=sys.stderr)
        sys.exit(1)

    workspace_path = pathlib.Path(sys.argv[1])
    schema = load_schema()
    workspace = load_workspace(workspace_path)

    if workspace is None:
        print(f"ERROR: {workspace_path} is empty or not valid YAML.", file=sys.stderr)
        sys.exit(1)

    try:
        validate(instance=workspace, schema=schema)
        print(f"OK: {workspace_path} is valid HPK workspace.yml (spec {workspace.get('spec', '?')}, pack '{workspace.get('name', '?')}')")
        sys.exit(0)
    except ValidationError as e:
        print(f"INVALID: {workspace_path}", file=sys.stderr)
        print(f"  Field:   {' -> '.join(str(p) for p in e.absolute_path) or '(root)'}", file=sys.stderr)
        print(f"  Problem: {e.message}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
