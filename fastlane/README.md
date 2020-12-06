fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### build_for_testing
```
fastlane build_for_testing
```
Create build for testing
### run_tests
```
fastlane run_tests
```
Run tests on build
### send_discord_notification
```
fastlane send_discord_notification
```
Send notification to discord
### build_and_test
```
fastlane build_and_test
```
Create build and run tests

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
