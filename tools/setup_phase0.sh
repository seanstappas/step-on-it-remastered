#!/usr/bin/env bash
# Phase 0 environment setup for the "Step On It!" remaster.
# Target: WSL Ubuntu 24.04 (install one first: `wsl --install -d Ubuntu`).
# Pins per MASTER_PLAN §8. Re-runnable; skips steps already done.
#
# Usage (inside WSL, from the repo root on /mnt/d/...):
#   bash tools/setup_phase0.sh
set -euo pipefail

GHIDRA_VER="11.3"
GHIDRA_REL="20250205"                       # <-- pin the exact Ghidra release date when downloading
GHIDRA_ZIP="ghidra_${GHIDRA_VER}_PUBLIC_${GHIDRA_REL}.zip"
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VER}_build/${GHIDRA_ZIP}"
TOOLS_DIR="${HOME}/soi-tools"

echo "== 1. APT deps (JDK 21, build tools) =="
sudo apt-get update -y
sudo apt-get install -y openjdk-21-jdk unzip wget git build-essential cmake pkg-config \
    zlib1g-dev libpng-dev

echo "== 2. Ghidra ${GHIDRA_VER} =="
mkdir -p "${TOOLS_DIR}"
if [ ! -d "${TOOLS_DIR}/ghidra_${GHIDRA_VER}_PUBLIC" ]; then
  wget -O "${TOOLS_DIR}/${GHIDRA_ZIP}" "${GHIDRA_URL}"
  unzip -q "${TOOLS_DIR}/${GHIDRA_ZIP}" -d "${TOOLS_DIR}"
fi
GHIDRA_HOME="${TOOLS_DIR}/ghidra_${GHIDRA_VER}_PUBLIC"
echo "GHIDRA_HOME=${GHIDRA_HOME}"

echo "== 3. resource_dasm (fuzziqersoftware) =="
if [ ! -d "${TOOLS_DIR}/resource_dasm" ]; then
  git clone https://github.com/fuzziqersoftware/resource_dasm "${TOOLS_DIR}/resource_dasm"
fi
# Pin the commit you build so §8 stays reproducible:
( cd "${TOOLS_DIR}/resource_dasm" && git rev-parse HEAD > "${TOOLS_DIR}/resource_dasm.commit" )
( cd "${TOOLS_DIR}/resource_dasm" && cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j )

echo "== 4. Extract the PEF (pure Python; safe to run from Windows too) =="
python3 tools/extract_pef.py

cat <<EOF

== Phase 0 setup complete ==
  Ghidra:        ${GHIDRA_HOME}
  resource_dasm: ${TOOLS_DIR}/resource_dasm/build (commit $(cat "${TOOLS_DIR}/resource_dasm.commit"))
  PEF:           bin/core_pef.bin

Still to install by hand (see MASTER_PLAN §8): SheepShaver + a pinned New World PPC ROM +
Mac OS 9.0.4 (record the ROM SHA-256 into §8's environment lock — never commit it), Godot 4.3 +
godot-cpp, FluidSynth + FluidR3_GM, Real-ESRGAN, a C/C++ toolchain.

Next: run the headless Ghidra discovery pass:
  "\${GHIDRA_HOME}/support/analyzeHeadless" ./analysis/ghidra soi \\
      -import bin/core_pef.bin -postScript analysis/ghidra/discover.py \\
      -scriptPath analysis/ghidra -deleteProject
EOF
