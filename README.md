## sparkleformation-subsonic
This repository creates an AWS Cloudformation template, which will spin up a [subsonic](http://subsonic.org) server
and an S3 bucket to hold your music files.

### How to use
Obviously, you need an AWS account :)  You need ruby and rubygems installed, and bundler.  Then just run:

    bundle && SUBSONIC_LICENSE_KEY=<my_license_key> SUBSONIC_LICENSE_EMAIL=<my_license_email> bundle exec sfn print -f subsonic > ~/subsonic.json

Or you can just create the stack, skipping inspection:

  bundle && SUBSONIC_LICENSE_KEY=<my_license_key> SUBSONIC_LICENSE_EMAIL=<my_license_email> bundle exec sfn create -f subsonic

### Environment variables

- SUBSONIC_LICENSE_KEY is your license key, if you purchased a valid subsonic license
- SUBSONIC_LICENSE_EMAIL is the e-mail address associated with your license key
- SUBSONIC_REDIRECT_FROM is the "friendly" hostname for your subsonic server (e.g. gswallow.subsonic.org)
- SUBSONIC_VERSION is the version of subsonic to install
- ansible_playbook_repo is this repo, unless you fork it.
- ansible_playbook_branch controls which branch (or git tag) to pull with ansible-pull during instance bootstrap.
