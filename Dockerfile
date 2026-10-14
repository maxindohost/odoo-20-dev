FROM ubuntu:24.04

ARG ODOO_BRANCH=20.0
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential git curl ca-certificates \
        python3 python3-dev python3-venv python3-pip \
        libpq-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
        libjpeg-dev zlib1g-dev libffi-dev libssl-dev \
        postgresql-client nodejs npm \
        fonts-noto-core xfonts-75dpi xfonts-base wkhtmltopdf \
    && npm install -g rtlcss \
    && rm -rf /var/lib/apt/lists/*

# Ubuntu 24.04 punya user "ubuntu" (uid 1000); ganti dengan user odoo sesuai UID host
RUN (userdel -r ubuntu 2>/dev/null || true) \
    && (groupdel ubuntu 2>/dev/null || true) \
    && groupadd -g ${USER_GID} odoo \
    && useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash odoo

# Source Odoo + virtualenv
RUN git clone --depth 1 --branch ${ODOO_BRANCH} https://github.com/odoo/odoo.git /opt/odoo
RUN python3 -m venv /opt/venv \
    && pip install --no-cache-dir -U pip wheel \
    && pip install --no-cache-dir -r /opt/odoo/requirements.txt debugpy watchdog

RUN printf '#!/bin/sh\nexec python /opt/odoo/odoo-bin "$@"\n' > /usr/local/bin/odoo \
    && chmod +x /usr/local/bin/odoo \
    && mkdir -p /var/lib/odoo /mnt/extra-addons /etc/odoo \
    && chown -R odoo:odoo /var/lib/odoo /mnt/extra-addons

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER odoo
WORKDIR /mnt/extra-addons
EXPOSE 8069 5678
ENTRYPOINT ["/entrypoint.sh"]
