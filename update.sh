#!/usr/bin/env bash

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#
	EOH
}

generate_dockerfile() {
    variants=$1

    if [[ "$variants" != "" ]]; then
        path=/$1
        version_suffix=-${variants}
    else
        path=""
        version_suffix=""
    fi

    # Prepare directories
    mkdir -p ${version}${path}

    generated_warning > ${version}${path}/Dockerfile

    cat Dockerfile.template | \
        sed -e 's!%%PHP_VERSION%%!'"${version}${version_suffix}"'!' | \
        sed -e 's!%%PHALCON_VERSION%%!'"${PHALCON_VERSION}"'!' \
        >> ${version}${path}/Dockerfile
}

PHALCON_VERSION=4.0.0

# Dockerfile on PHP 5 is customized
VERSIONS="
7.2
7.3
7.4
"

for version in ${VERSIONS}; do
    major_version=$(echo ${version} | cut -f1 -d.)

    generate_dockerfile
    generate_dockerfile alpine
    generate_dockerfile apache
    generate_dockerfile fpm
    generate_dockerfile fpm-alpine
done
