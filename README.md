# react-native-is-muted

[![npm version](https://img.shields.io/npm/v/react-native-is-muted.svg?style=for-the-badge&logo=appveyor)](https://www.npmjs.com/package/react-native-is-muted)

<p align="center"><img src="https://github.com/popup-plus/react-native-is-muted/blob/main/isMutedExample.ios.gif?raw=true" alt="Showcase iOS" width="234" height="433">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/popup-plus/react-native-is-muted/blob/main/isMutedExample.android.gif?raw=true" alt="Showcase Android" width="234" height="433"></p>

Detect whether the device is muted (iOS silent switch / Android ringer mode).

Built with the [Expo Modules API](https://docs.expo.dev/modules/overview/). Works in any Expo or bare React Native project with autolinking.

## ⚠️ Breaking change in 1.0.0

Version `1.0.0` rewrites the package on top of the Expo Modules API. The public JS API has changed:

- The default export `IsMuted` has been **removed**.
- Use the named export `isMuted` (lowercase) instead.

```diff
- import IsMuted from 'react-native-is-muted';
- const muted = await IsMuted();
+ import { isMuted } from 'react-native-is-muted';
+ const muted = await isMuted();
```

The manual iOS step of adding `MuteChecker.caf` to "Copy Bundle Resources" is no longer required — the podspec bundles it automatically.

## Installation

```sh
npm install react-native-is-muted
```

Then rebuild the native app:

```sh
npx expo prebuild   # if using a managed Expo project
npx expo run:ios
npx expo run:android
```

No manual native setup is required — the iOS `MuteChecker.caf` resource is bundled via the podspec and Android autolinking handles the rest.

## Usage

```ts
import { isMuted } from 'react-native-is-muted';

const muted = await isMuted();
console.log('Muted:', muted);
```

### Notes

- **iOS**: returns `true` when the hardware silent switch is on. Does not work in the iOS Simulator (the call rejects with `ERR_SIMULATOR_UNSUPPORTED`).
- **Android**: returns `true` when the ringer mode is silent or vibrate.
- **Web**: not supported. Browsers do not expose system mute state.
