AC_PREREQ(2.57)
AC_INIT(auth-ldap, [1.0.3], landonf@opendarwin.org)
AC_CONFIG_SRCDIR(${srcdir}/src/LFString.m)
AC_CONFIG_HEADERS(config.h)

AC_CANONICAL_SYSTEM

# Programs
AC_PROG_CC
AC_PROG_OBJC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_CACHE_SAVE

# Headers
AC_HEADER_STDC
AC_CACHE_SAVE

# Threads
ACX_PTHREAD
AC_CACHE_SAVE

# Functions
AC_CHECK_FUNCS([strlcpy])
AC_CACHE_SAVE

# Libraries
OD_OPENLDAP

# OpenVpn
OD_OPENVPN_HEADER

# Objective-C Runtime
OD_OBJC_RUNTIME
AC_CACHE_SAVE

# Output
AC_CONFIG_FILES([Makefile src/Makefile Mk/autoconf.mk Mk/compile.mk Mk/subdir.mk])

AC_OUTPUT