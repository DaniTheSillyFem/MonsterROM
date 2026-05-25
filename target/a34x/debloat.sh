# Copyright (C) 2025 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Galaxy A34 5G (a34x)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Overlays
SYSTEM_DEBLOAT+="
system/app/WifiRROverlayAppLls
"
