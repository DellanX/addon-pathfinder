ARG BUILD_FROM=hassioaddons/base:8.0.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
	apk add --no-cache \
		composer \
		git \
		npm \
		nginx=1.18.0-r1 \
		php7 \
		php7-ctype \ 
		php7-curl \ 
		php7-dom \
		php7-fileinfo \
		php7-fpm \
		php7-gd \
		php7-json \
		php7-mbstring \
		php7-opcache \
		php7-pdo_mysql \
		php7-pdo \
        php7-session \
		php7-simplexml \
		php7-tokenizer \
		php7-xml \
	&& apk add --no-cache --virtual .build-dependencies \
		yarn=1.22.4-r0 \
	&& yarn global add modclean \
	\
	&& git clone https://github.com/exodus4d/pathfinder.git /var/www/pathfinder \
	&& chown -R nginx:nginx /var/www/pathfinder \
	&& mkdir /tmp/cache/ \
	&& mkdir /var/www/pathfinder/conf/ \
	&& chmod -R 766 /tmp/cache/ /var/www/pathfinder/logs/ \
	&& cd /var/www/pathfinder \
	&& composer install --no-dev \
	&& yarn --production \
	\
	&& modclean \
		--path /var/www/pathfinder/ \
		--no-progress \
		--keep-empty \
		--run \
	\
	&& yarn global remove modclean
RUN yarn cache clean \
	&& apk del --no-cache --purge .build-dependencies \
	\
	&& find /var/www/ -type f -name "*.md" -depth -exec rm -f {} \; \
	&& rm -f -r \
		/tmp/* \
		/etc/nginx \
		/usr/local/share/.cache \
		/usr/lib/node_modules \
		/var/www/pathfinder/.git \
		/var/www/pathfinder/.htaccess \
		/var/www/pathfinder/.htaccess_HTTP \
		/var/www/pathfinder/.tx \
		/var/www/pathfinder/.vscode \
		/var/www/pathfinder/build.bat \
		/var/www/pathfinder/build_tools

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
	io.hass.name="Pathfinder" \
	io.hass.description="ERP beyond your fridge! A groceries & household management solution for your home" \
	io.hass.arch="${BUILD_ARCH}" \
	io.hass.type="addon" \
	io.hass.version=${BUILD_VERSION} \
	maintainer="Franck Nijhof <frenck@addons.community>" \
	org.opencontainers.image.title="Pathfinder" \
	org.opencontainers.image.description="ERP beyond your fridge! A groceries & household management solution for your home" \
	org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
	org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
	org.opencontainers.image.licenses="MIT" \
	org.opencontainers.image.url="https://addons.community" \
	org.opencontainers.image.source="https://github.com/hassio-addons/addon-grocy" \
	org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-grocy/blob/master/README.md" \
	org.opencontainers.image.created=${BUILD_DATE} \
	org.opencontainers.image.revision=${BUILD_REF} \
	org.opencontainers.image.version=${BUILD_VERSION}
