#!/bin/sh
#
# Copyright (c) 2008, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ---
# Author: Filipe Almeida

die() {
    echo "Test failed: $@" 1>&2
    exit 1
}

TEST_SRCDIR=${1:-TEST_SRCDIR}

# Find input files
INPUT_FILE="$TEST_SRCDIR/src/tests/testdata/sample_fsm.config"
OUTPUT_FILE="$TEST_SRCDIR/src/tests/testdata/sample_fsm.c"
GENERATE_FSM="$TEST_SRCDIR/src/tools/generate_fsm.py"

EXPECTED="`cat $OUTPUT_FILE`"
if [ -z "$EXPECTED" ]; then die "Error reading $OUTPUT_FILE"; fi

# Let's make sure the script works with python2.2 and above
# for PYTHON in "" "python2.2" "python2.3" "python2.4"; do
for PYTHON in "" "python2.7"; do
  GENERATED="`$PYTHON $GENERATE_FSM $INPUT_FILE`"
  if [ -z "$GENERATED" ]; then die "Error running $GENERATE_FSM"; fi

  if [ "$EXPECTED" != "$GENERATED" ]; then
    echo "Test failed ($PYTHON $GENERATE_FSM $INPUT_FILE)" 1>&2
    echo "-- EXPECTED --" 1>&2
    echo "$EXPECTED" 1>&2
    echo "-- GENERATED --"  1>&2
    echo "$GENERATED" 1>&2
    echo "--"
    exit 1
  fi
done

echo "PASS"
