# Antrag

[![GitHub Release](https://img.shields.io/github/v/release/khcrysalis/antrag?include_prereleases)](https://github.com/khcrysalis/protokolle/releases)
[![GitHub License](https://img.shields.io/github/license/khcrysalis/antrag?color=%23C96FAD)](https://github.com/khcrysalis/protokolle/blob/main/LICENSE)

| ![Preview Image](image.jpeg) |
| :--------------------------: |

An app to list iOS/iPadOS app's, for stock devices. This app uses [idevice](https://github.com/jkcoxson/idevice) and lockdownd pairing to retrieve installed apps.

## Features

- List, open, and delete "System" & "User" apps.
- View entitlements, signing identity, and additional misc info.

## Download

Visit [releases](https://github.com/khcrysalis/Antrag/releases) and get the latest `.ipa`.

## How does it work?

- Establish a heartbeat with a TCP provider (the app will need this for later).
  - For it to be successful, we need a pairing file from [JitterbugPair](https://github.com/osy/Jitterbug/releases) and a [VPN](https://apps.apple.com/us/app/stosvpn/id6744003051).
- When preparing the list, we need to establish another connection but for `installation_proxy` using our heartbeat provider and client handle.
- Then we can use `installation_proxy_get_apps` using that handle to list applications.

Due to how it works right now we need both a VPN and a lockdownd pairing file, this means you will need a computer for its initial setup.

## Building

#### Minimum requirements

- Xcode 16
- Swift 5.9
- iOS 16

1. Clone repository
    ```sh
    git clone https://github.com/khcrysalis/Antrag
    ```

2. Compile
    ```sh
    cd Antrag
    gmake
    ```

3. Updating
    ```sh
    git pull
    ```

Using the makefile will automatically create an adhoc ipa inside the packages directory, using this to debug or report issues is not recommend. When making a pull request or reporting issues, it's generally advised you've used Xcode to debug your changes properly.

## Sponsors

| Thanks to all my [sponsors](https://github.com/sponsors/khcrysalis)!! |
|:-:|
| <img src="https://raw.githubusercontent.com/khcrysalis/github-sponsor-graph/main/graph.png"> |
| _**"samara is cute" - Vendicated**_ |

## Acknowledgements

- [Samara](https://github.com/khcrysalis) - The maker
- [idevice](https://github.com/jkcoxson/idevice) - Backend functionality, uses `installation_proxy` to retrieve messages.

## License 

This project is licensed under the GPL-3.0 license. You can see the full details of the license [here](https://github.com/khcrysalis/Feather/blob/main/LICENSE). Code from Antoine is going to be under MIT, if you figure out where that is.

By contributing to this project, you agree to license your code under the GPL-3.0 license as well (including agreeing to license exceptions), ensuring that your work, like all other contributions, remains freely accessible and open.
