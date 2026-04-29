# Installation

## Quick Install

### Using Make (Recommended for Unix-like systems)

```bash
git clone https://github.com/techyminati/neofetch.git
cd neofetch
sudo make install
```

To uninstall:
```bash
sudo make uninstall
```

### Manual Installation

#### Linux / macOS / BSD

```bash
git clone https://github.com/techyminati/neofetch.git
cd neofetch
sudo install -Dm755 neofetch /usr/local/bin/neofetch
sudo install -Dm644 neofetch.1 /usr/local/share/man/man1/neofetch.1
```

#### Windows

**Using Git Bash / MSYS2 / Cygwin:**

1. Install Git Bash, MSYS2, or Cygwin
2. Clone the repository:
   ```bash
   git clone https://github.com/techyminati/neofetch.git
   cd neofetch
   ```
3. Add the neofetch directory to your PATH or copy `neofetch` to a directory in your PATH
4. Run `neofetch` from your terminal

**Using WSL (Windows Subsystem for Linux):**

Follow the Linux installation instructions within your WSL environment.

