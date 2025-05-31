# Reaper Setlist

A modern setlist management application for the REAPER DAW, built with Svelte frontend and Rust backend. It has very low resource requirements and file size, and can be run on older / more constrained hardware, such as a Raspberry Pi 3.

## Features

- 🎵 Manage setlists and songs
- 🔧 Integration with REAPER

## Usage

Download the binary for your hardware and OS from the [releases section](https://github.com/iKadmium/reaper-setlist/releases) on the right if you'd like to run directly, or if you'd like to use Docker, run `docker run -p 3000:3000 -v reaper-setlist-data:/app/data ghcr.io/ikadmium/reaper-setlist:latest`. Then, open a web browser to http://localhost:3000. Remember to start by going to the setup section.
