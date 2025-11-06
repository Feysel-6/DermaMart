# Installing dlib on Windows - Quick Guide

## Option 1: Install CMake first (Recommended)

1. **Download CMake**:
   - Go to https://cmake.org/download/
   - Download Windows installer (cmake-3.x.x-windows-x86_64.msi)
   - **Important**: During installation, check "Add CMake to system PATH"

2. **Restart your terminal/PowerShell** after installing CMake

3. **Verify CMake is installed**:
   ```powershell
   cmake --version
   ```

4. **Install dlib**:
   ```powershell
   pip install dlib
   ```

## Option 2: Use Conda (Easier, but requires Conda)

```powershell
conda install -c conda-forge dlib
```

## Option 3: Pre-built wheel (If available)

Sometimes pre-built wheels are available. Try:
```powershell
pip install dlib-binary
```

Or search for pre-built wheels:
```powershell
pip install dlib --only-binary :all:
```

## After installing dlib

Run the server again:
```powershell
python standalone_server.py --host 0.0.0.0 --port 8080 --device cpu
```

