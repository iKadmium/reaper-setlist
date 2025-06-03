# Reaper Setlist

A simple setlist management application for the REAPER DAW, built with Svelte frontend and Rust backend. It has very low resource requirements and file size, and can be run on older / more constrained hardware, such as a Raspberry Pi 3.

## Features

- 🎵 Manage setlists and songs
- 🔧 Integration with REAPER
- 💾 Tiny and efficient - 1mb Docker image, 2mb RAM usage

## Usage

### Running from downloaded binary

Download, extract and run the binary for your hardware and OS from the [releases section](https://github.com/iKadmium/reaper-setlist/releases) on the right. Then, open a web browser to http://localhost:3000, click setup and follow the instructions. Then, you're ready to start adding songs and sets.

### Running from Docker / Podman

```sh
docker run -p 3000:3000 -v reaper-setlist-data:/app/data ghcr.io/ikadmium/reaper-setlist:latest
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
