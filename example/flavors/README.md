# example_with_flavors

A new Flutter project to showcase how to use different icons

## How to run this project

Before being able to run this example you need to navigate to this directory and run the following command

```
flutter create .
```

This project has the following flavors:

- production: `flutter run --flavor production`
- development: `flutter run --flavor development`
- integration: `flutter run --flavor integration`

## Command for running with multiple config files:

In this project, we have three config files for our three flavors, namely: 
 - flutter_launcer_icons-production
 - flutter_launcer_icons-development
 - flutter_launcer_icons-integration

To run flutter_launcher_icons CLI, use the following command:

```
flutter pub run flutter_launcher_icons -f flutter_launcher_icons*
```

this means: run flutter_launcher_icons CLI for all files that start with `flutter_launcher_icons` followed by any characters, denoted by * (asterisk)
