#!/bin/bash
set -e
if [ "${DEBUG:-0}" = "1" ]; then
  # Mode debug: tanpa auto-reload python (reload + debugger tidak kompatibel)
  exec python -m debugpy --listen 0.0.0.0:5678 /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf --dev=xml "$@"
fi
exec python /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf --dev=reload,xml "$@"
