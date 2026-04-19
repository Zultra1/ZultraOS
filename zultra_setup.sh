#!/bin/bash

# 1. Branding ZultraOS
echo "Applying ZultraOS Branding..."
find vendor/lineage -type f -name "*.mk" -exec sed -i 's/LineageOS/ZultraOS/g' {} +
sed -i 's/Android/ZultraOS/g' packages/apps/Settings/res/values/strings.xml

# 2. KILL BOOT ANIMATION (Speed Up Boot)
# This removes the service from the init system entirely
sed -i '/service bootanim/,/class core/d' system/core/rootdir/init.rc

# 3. Inject Base Station Performance Props
cat <<EOF >> device/samsung/greatlte/system.prop
# ZultraOS Identity
ro.zultra.display.version=ZultraOS-1.0-BaseStation
ro.product.model=Zultra Note 8 Gateway
ro.build.display.id=ZultraOS_Q2_2026

# Performance & Router Logic
debug.sf.nobootanimation=1
ro.telephony.default_network=9
net.hostname=Zultra_Base_Station
# Free Hotspot Hack (Surrey/Bell)
net.tethering.noprovisioning=true
EOF

# 4. Inject the TTL Fix into the boot sequence
echo "iptables -t mangle -A POSTROUTING -j TTL --ttl-set 64" >> device/samsung/greatlte/init.greatlte.rc
