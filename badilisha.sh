#!/usr/bin/env bash 
set -e

# --- MAELEKEZO ---
ZAMANI_GITHUB="dockur/windows"
MPYA_GITHUB="newboytz/MyDesktopOS"

ZAMANI_USER="dockurr"
MPYA_USER="newboytz"

ZAMANI_JINA="WinBoat"
MPYA_JINA="MyDesktopOS"

echo "🚀 Inaanza kazi ya kubadilisha kila kitu..."

# 1. Kubadilisha Maneno (Search and Replace)
# Inatafuta na kubadilisha kwenye kila faili isipokuwa picha na mafaili ya git
find . -type f -not -path '*/.*' -exec sed -i "s|$ZAMANI_GITHUB|$MPYA_GITHUB|g" {} +
find . -type f -not -path '*/.*' -exec sed -i "s|$ZAMANI_USER|$MPYA_USER|g" {} +
find . -type f -not -path '*/.*' -exec sed -i "s|$ZAMANI_JINA|$MPYA_JINA|g" {} +
find . -type f -not -path '*/.*' -exec sed -i "s|Windows for Docker|$MPYA_JINA|g" {} +

echo "✅ Mabadiliko yamekamilika ndani ya mafaili."

# 2. Git Automation (Save, Commit, and Push)
echo "📦 Inatayarisha kupeleka mabadiliko GitHub..."

git add .

# Hapa tunaweka ujumbe wa commit
git commit -m "Ownership Transfer: Rebranded to $MPYA_JINA"

# Inasukuma code kwenda GitHub yako
echo "⬆️ Inasukuma (Pushing) kwenda kwenye repository yako..."
git push origin main

echo "------------------------------------------------"
echo "🎉 KAZI IMEISHA! MRADI SASA NI WAKO 100%."
echo "Nenda kwenye GitHub yako sasa hivi kacheki."
echo "------------------------------------------------"

