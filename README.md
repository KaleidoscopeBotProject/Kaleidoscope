# Kaleidoscope
## Summary
[**Kaleidoscope**](https://github.com/carlbennett/kaleidoscope) is a
cross-platform classic Battle.net client daemon written in PHP.

Kaleidoscope is in no way affiliated with or endorsed by Blizzard
Entertainment&trade; or its brands, and is not intended to compete with
or undermine Blizzard Entertainment&trade; or Battle.net&trade;. All
aforementioned trademarks are the property of their respective owners. Read the
[LICENSE](https://github.com/carlbennett/kaleidoscope/blob/php/LICENSE.md) file
at the root of this repository for more details.

## Installation
### Download
#### Development
```sh
git clone git@github.com:carlbennett/kaleidoscope.git && cd ./kaleidoscope
```

#### Stable
You can download the latest release from
[here](https://github.com/carlbennett/kaleidoscope/releases/latest).

Once downloaded, extract the files into a new directory, open your terminal,
and switch to that directory.

### Dependencies
```sh
composer install
```

If you haven't installed composer, it can be downloaded from
[here](https://getcomposer.org/download/).

### Configure
1. Copy the `./etc/kaleidoscope.sample.conf` file to `./etc/kaleidoscope.conf`
2. Edit the `./etc/kaleidoscope.conf` file in your favorite text editor

## Run
```sh
./bin/kaleidoscope
```
