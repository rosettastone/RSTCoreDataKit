# Rosetta Stone Contributing Guidelines

We want to make contributing to Rosetta Stone open source projects as easy and transparaent as possible. 
We actively welcome pull requests and encourage you to open issues on GitHub when you find a bug or run into problems.

## Project Organization

We follow a [successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model) and use [Semantic Versioning](http://semver.org).

* The `master` branch is always stable and release-ready. All releases are tagged from `master`.
* The `develop` branch is the main branch for development, and is merged into `master` when stable and ready.
* Feature branches should be created (branching from `develop`) for adding new features, then merged into `develop` when ready.
* Bug-fix branches should be created (branching from `develop`) for fixing bugs, then merged into `develop` when ready.

## Pull Requests

1. Find an issue to work on, or create a new one.
2. Fork the repo and create your branch from `develop`, give it a good name: `git checkout -b issue_<##>_<featureOrFix>`.
3. If you've added code that should be tested, add tests.
4. If you've changed APIs, update the documentation.
5. Keep your code clean by adhering to the coding style standards.
6. Ensure the test suite passes.
7. Submit a pull request to the `develop` branch.

**You should submit one pull request per feature or fix.** Smaller pull requests are easiest to review and merge.

## Issues

We use GitHub issues to track public bugs. Please ensure your description is clear and has sufficient instructions to be able to reproduce the issue. Also, **please try to avoid opening duplicate issues.**

1. Search existing issues to see if your issue exists.
2. If your issue exists, please comment on its thread with any information you have.
3. Provide a detailed description, including the library version, affected platforms, and affected devices (where applicable).
4. Provide clear steps to reproduce the issue.
5. Provide screenshots, videos, or GIFs if needed.

## Coding Style

Please adhere to the following coding style standards, guidelines, and conventions for the language in which you are writing.

#### Objective-C

We conform to the following sets of guidelines. They compliment each other well and cover nearly everything.

* Google's [Objective-C Style Guide](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)
* Apple's [Coding Guidelines for Cocoa](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)
* NYTimes [Objective-C Style Guide](https://github.com/NYTimes/objective-c-style-guide)

#### Swift

There are not clear style standards for Swift yet, but we encourage adhering the same principles established with Objective-C. Be sure your code is readable and easily understood — clarity always trumps brevity.

## License

By contributing to any Rosetta Stone open source project, you agree that your contributions will be licensed under its BSD license.
