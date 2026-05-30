# Contributing

## Testing

Automated tests run in CI on every push and pull request (see `.github/workflows/tests.yml`).

### JavaScript

```sh
npm run test:js
```

Jest unit tests in `src/__tests__/` cover the public API and mock the native module.

### Android

```sh
npm run test:android
```

Robolectric JVM unit tests in `android/src/test/` cover the ringer-mode logic without needing an emulator.

### iOS

There are **no automated iOS tests**. The mute detection relies on
`AudioServicesPlaySystemSound` timing on a physical device — the simulator
cannot reproduce the ringer/silent switch behaviour, so the module's
`isMuted` function rejects with `ERR_SIMULATOR_UNSUPPORTED` there.

iOS changes are verified manually by running the example app on a physical
device and toggling the ringer switch:

```sh
cd example
npx expo run:ios --device
```
