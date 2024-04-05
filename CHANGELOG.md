## 2.0.0

- **BREAKING CHANGE**: Requires `moc` version `0.11.0` or higher.
- Added `testsys` function to run tests with `system` capability. (by @skilesare)

Example:
```motoko
testsys<system>("test", func<system>() {
  myFunc<system>();
});
```

## 1.2.0

- Fixed test run in `wasi` mode

**Breaking changes**:
- `expect.call` now only available when imported from `mo:test/async`

## 1.1.0

- Added `expect` helper for easier testing of assertions