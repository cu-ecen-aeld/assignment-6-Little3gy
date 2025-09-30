# See https://git.yoctoproject.org/poky/tree/meta/files/common-licenses
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Inherit the update-rc.d class for init script support
inherit update-rc.d

SRC_URI = "git://git@github.com/cu-ecen-aeld/assignments-3-and-later-Little3gy.git;protocol=ssh;branch=main \
           file://aesdsocket-start-stop"

PV = "1.0+git${SRCPV}"
# TODO: set to reference a specific commit hash in your assignment repo
SRCREV = "78b8a47a98a23d26be858c8e0efb77f18d726db7"

# This sets your staging directory based on WORKDIR, where WORKDIR is defined at 
# https://docs.yoctoproject.org/ref-manual/variables.html?highlight=workdir#term-WORKDIR
# We reference the "server" directory here to build from the "server" directory
# in your assignments repo
S = "${WORKDIR}/git/server"

# Combined FILES entry - include both binary and init script
FILES:${PN} += "${bindir}/aesdsocket ${sysconfdir}/init.d/aesdsocket-start-stop"

# TODO: customize these as necessary for any libraries you need for your application
TARGET_LDFLAGS += "-pthread -lrt"

# Configuration for init script
INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME:${PN} = "aesdsocket-start-stop"
INITSCRIPT_PARAMS:${PN} = "defaults"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

do_install () {
	# Create the destination directory for the binary
	install -d ${D}${bindir}
	# Install the aesdsocket binary with executable permissions
	install -m 0755 ${S}/aesdsocket ${D}${bindir}/aesdsocket

	# Create the destination directory for the init script
	install -d ${D}${sysconfdir}/init.d
	# Install the start/stop script with executable permissions (no .sh extension)
	install -m 0755 ${WORKDIR}/aesdsocket-start-stop ${D}${sysconfdir}/init.d/aesdsocket-start-stop
}
