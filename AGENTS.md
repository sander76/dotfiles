# Agent Instructions

## Shell commands

- Always add a timeout when running `find`. Broad or unbounded `find`
  invocations (especially `find /` or searches across mounted/network
  filesystems) can hang indefinitely on stalled mounts.
  - Wrap with `timeout 15 find ...` (15 seconds).
  - Prefer adding `-xdev` to avoid crossing into other mounted filesystems
    when searching from a root like `/`.

  Example:

  ```bash
  timeout 15 find / -xdev -iname "*pattern*" 2>/dev/null
  ```
