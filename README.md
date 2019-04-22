# semaphore plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-semaphore)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-semaphore`, add it to your project by running:

```bash
fastlane add_plugin semaphore
```

## About semaphore

Semaphore CI is available at <https://semaphoreci.com/>

This plugin adds `setup_semaphore`. The action:

  * Starts if in CI or `force` parameter is set to `true`
  * Creates a temporary keychain if the `MATCH_KEYCHAIN_NAME` envrionment was not set (i.e. if keychain is not created yet)
  * Puts `match` in readonly mode to not modify certificates on CI
  * If `FL_OUTPUT_DIR` environment variable is set, then `scan`, `gym` and build logs will be set in subdirectories of that path.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

See example project at https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
