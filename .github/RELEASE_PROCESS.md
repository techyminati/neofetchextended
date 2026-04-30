# Release Process

This document explains how to create a new release of Neofetch Extended.

## Automated Release Workflow

The GitHub Actions workflow automatically builds and publishes:
- **DEB packages** for 4 architectures: amd64, arm64, armhf, i386
- **Homebrew formula** for macOS
- **Source tarball** with SHA256 checksum

## Creating a Release

### Method 1: Git Tag (Recommended)

1. Make sure all changes are committed
2. Create and push a tag:
   ```bash
   git tag v7.2.0
   git push origin v7.2.0
   ```

The workflow will automatically:
- Build packages for all architectures
- Generate Homebrew formula
- Create a GitHub release
- Upload all artifacts

### Method 2: Manual Trigger

1. Go to GitHub Actions tab
2. Select "Build and Release" workflow
3. Click "Run workflow"
4. Enter version number (e.g., `7.2.0`)
5. Click "Run workflow"

## What Gets Built

### DEB Packages (Debian/Ubuntu/Raspbian)
- `neofetch_7.2.0_amd64.deb` - Intel/AMD 64-bit
- `neofetch_7.2.0_arm64.deb` - ARM 64-bit (Raspberry Pi 4/5, Apple Silicon)
- `neofetch_7.2.0_armhf.deb` - ARM 32-bit (older Raspberry Pi)
- `neofetch_7.2.0_i386.deb` - 32-bit x86

### Homebrew Formula
- `neofetch.rb` - Homebrew formula for macOS/Linux

### Source Distribution
- `neofetch-7.2.0.tar.gz` - Source tarball
- `neofetch-7.2.0.tar.gz.sha256` - SHA256 checksum

## Post-Release Steps

### For APT Repository (Optional)

If you want to host your own APT repository:

1. **Set up a PPA on Launchpad:**
   ```bash
   # Install dput
   sudo apt-get install dput

   # Build source package
   debuild -S -sa

   # Upload to PPA
   dput ppa:your-username/neofetch ../neofetch_7.2.0_source.changes
   ```

2. **Or use GitHub Pages as APT repo:**
   - Use `reprepro` or `aptly` to create repository
   - Host on GitHub Pages
   - Users add with: `sudo add-apt-repository 'deb https://yourusername.github.io/apt stable main'`

### For Homebrew Core (Optional)

To submit to official Homebrew:

1. Fork [homebrew-core](https://github.com/Homebrew/homebrew-core)
2. Copy `neofetch.rb` from the release to `Formula/neofetch.rb`
3. Test locally:
   ```bash
   brew install --build-from-source Formula/neofetch.rb
   brew test neofetch
   brew audit --strict neofetch
   ```
4. Submit PR to homebrew-core

## Version Management

The version is defined in the `neofetch` script:
```bash
version=7.2.0-extended
```

When creating releases:
- The `-extended` suffix is automatically removed from release tags
- Use version format: `v7.2.0` (not `v7.2.0-extended`)
- The workflow extracts version from git tags or manual input

## Testing Before Release

Before tagging a release, test the package build locally:

### Test DEB build:
```bash
sudo apt-get install debhelper devscripts build-essential
dpkg-buildpackage -us -uc -b
sudo dpkg -i ../neofetch_*.deb
neofetch --version
```

### Test on different architectures:
```bash
# Using QEMU
docker run --rm --platform linux/arm64 -v $(pwd):/workspace -w /workspace debian:bookworm bash -c "
  apt-get update && apt-get install -y debhelper devscripts build-essential &&
  dpkg-buildpackage -us -uc -b
"
```

## Troubleshooting

### Build fails on certain architecture
- Check the GitHub Actions logs
- Test locally with Docker/QEMU
- May need to adjust debian/rules or debian/control

### Homebrew formula fails
- Ensure SHA256 checksum is correct
- Test with: `brew install --formula ./neofetch.rb`
- Check that tarball URL is accessible

### Release not created
- Check GitHub Actions permissions (Settings → Actions → General → Workflow permissions)
- Ensure `GITHUB_TOKEN` has write permissions
- Verify the tag follows `v*` pattern

## CI/CD Architecture

```
Push tag v7.2.0
    ↓
GitHub Actions Triggered
    ↓
    ├─→ build-deb (4 parallel jobs for each arch)
    │   ├─→ amd64 (x86_64)
    │   ├─→ arm64 (aarch64)
    │   ├─→ armhf (arm32v7)
    │   └─→ i386 (x86)
    │
    ├─→ build-tarball (creates source distribution)
    │
    └─→ build-homebrew (generates formula)
        ↓
All builds complete
        ↓
create-release (combines all artifacts)
        ↓
        └─→ Publish to GitHub Releases
            ↓
        test-packages (smoke test)
```

## Release Checklist

Before creating a release:

- [ ] Update CHANGELOG.md
- [ ] Update version in `neofetch` script if needed
- [ ] Update debian/changelog if needed
- [ ] Test on at least one platform
- [ ] Commit all changes
- [ ] Create and push tag
- [ ] Monitor GitHub Actions
- [ ] Verify release artifacts
- [ ] Test installation from release
- [ ] Announce release (optional)
