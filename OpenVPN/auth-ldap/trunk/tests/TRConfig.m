/*
 * TRConfig.m
 * TRConfig Unit Tests
 *
 * Author: Landon Fuller <landonf@threerings.net>
 *
 * Copyright (c) 2006 Three Rings Design, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of Landon Fuller nor the names of any contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <check.h>
#include <fcntl.h>
#include <unistd.h>

#include <src/TRConfig.h>

/* Path Constants */
#define DATA_PATH(relative)	TEST_DATA "/" relative
#define TEST_CONF		DATA_PATH("TRConfig.conf")

/*
 * LDAP Section Schema
 */

/* Key types */
static TRConfigKeySchema TRKey_timeout = { "timeout", false, TOKEN_DATATYPE_INT };
static TRConfigKeySchema TRKey_url = { "url", false, TOKEN_DATATYPE_NONE };

static TRConfigKeySchema *TRKeys_LDAP [] = { &TRKey_timeout, &TRKey_url, NULL };

/* Section */
static TRConfigSectionSchema TRSection_LDAP = { "LDAP", TRKeys_LDAP, NULL };

/* Root Section Schema */
static TRConfigSectionSchema *TRSections_Root[] = {
	&TRSection_LDAP,
	NULL
};

static TRConfigSectionSchema TRSection_Root = {
	NULL,
	NULL,
	TRSections_Root
};

void print_section(TRConfigSectionSchema *section) {
	TRConfigKeySchema *key;
	int i = 0;

	if (section->keys) {
		while ((key = section->keys[i]) != NULL) {
			printf("Key: %s isMulti: %d Type: %d\n", key->label, key->multikey, key->type);
			i++;
		}
	}
}

void testfoo(void) {
	TRConfigSectionSchema *rootNode = &TRSection_Root;
	TRConfigSectionSchema *node = rootNode;
	int i;

	i = 0;
	while (node) {
		printf("Section: %s\n", node->label);
		print_section(node);
		if (node->subsections) {
			node = node->subsections[0];
		} else {
			node = NULL;
		}
	}
}

START_TEST (test_initWithFD) {
	TRConfig *config;
	int configFD;

	/* Open our configuration file */
	configFD = open(TEST_CONF, O_RDONLY);
	fail_if(configFD == -1, "open() returned -1");

	/* Initialize the configuration parser */
	config = [[TRConfig alloc] initWithFD: configFD configSchema: &TRSection_Root];
	fail_if(config == NULL, "-[[TRConfig alloc] initWithFD:] returned NULL");

	/* Parse the configuration file */
	fail_unless([config parseConfig], "-[TRConfig parse] returned NULL");

	close(configFD);
}
END_TEST

Suite *TRConfig_suite(void) {
	Suite *s = suite_create("TRConfig");

	TCase *tc_lex = tcase_create("Parse Configuration");
	suite_add_tcase(s, tc_lex);
	tcase_add_test(tc_lex, test_initWithFD);

	return s;
}