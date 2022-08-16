#!/usr/bin/env bash

set -e

echo "Testing for $TEST_PLATFORM, Unit Type: $TESTING_TYPE"

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' unity-editor} \
  -projectPath $UNITY_DIR \
  -runTests \
  -testPlatform $TEST_PLATFORM \
  -testResults $UNITY_DIR/$TEST_PLATFORM-results.xml \
  -logFile /dev/stdout \
  -batchmode \
  -nographics   

UNITY_EXIT_CODE=$?
if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
  saxonb-xslt -s $UNITY_DIR/$TEST_PLATFORM-results.xml -xsl /scripts/nunit3-junit.xslt >$UNITY_DIR/$TEST_PLATFORM-junit-results.xml
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
  if [ $TESTING_TYPE == 'JUNIT' ]; then
    echo "Converting results to JUNit for analysis";
    saxonb-xslt -s $UNITY_DIR/$TEST_PLATFORM-results.xml -xsl /scripts/nunit3-junit.xslt >$UNITY_DIR/$TEST_PLATFORM-junit-results.xml
  fi
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
  if [ $TESTING_TYPE == 'JUNIT' ]; then
    echo "Not converting results to JUNit";
  fi
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
  if [ $TESTING_TYPE == 'JUNIT' ]; then
    echo "Not converting results to JUNit";
  fi
fi

cat $UNITY_DIR/$TEST_PLATFORM-results.xml | grep test-run | grep Passed
exit $UNITY_EXIT_CODE