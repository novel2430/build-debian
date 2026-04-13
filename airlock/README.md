# airlock

A lightweight Bash-based managed install framework prototype.

## v0 scope

- Managed installs only
- Supported types:
  - `managed/source`
  - `managed/artifact`
- Tracked mode is recognized in metadata design, but not implemented yet

## Commands

```bash
airlock install <recipe-name|recipe-path>
airlock remove <pkg-name>
airlock list
airlock files <pkg-name>
```

## Environment overrides

```bash
AIRLOCK_PREFIX
AIRLOCK_DB_ROOT
AIRLOCK_RECIPES_DIR
AIRLOCK_TMPDIR
AIRLOCK_LOG_LEVEL
AIRLOCK_LOG_FILE
```

## Notes

- Recipes must produce a staged tree in `STAGE_DIR`
- Recipes must not write directly to the real system root
- `record`, `commit`, and `remove` are framework-owned actions
