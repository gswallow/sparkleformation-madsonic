## sparkleformation-madsonic
This repository creates an AWS Cloudformation template, which will spin up a [madsonic](http://madsonic.org) server
and an S3 bucket to hold your music files.

### How to use
Obviously, you need an AWS account :)  You need ruby and rubygems installed, and bundler.  Then just run:

    bundle && MADSONIC_LICENSE_KEY=<my_license_key> MADSONIC_LICENSE_EMAIL=<my_license_email> bundle exec sfn print -f madsonic > ~/madsonic.json

Or you can just create the stack, skipping inspection:

  bundle && MADSONIC_LICENSE_KEY=<my_license_key> MADSONIC_LICENSE_EMAIL=<my_license_email> bundle exec sfn create -f madsonic

### Environment variables

- BUCKET_NAME is the name of the bucket ($USER-madsonic)
- MADSONIC_LICENSE_KEY is your license key, if you purchased a valid madsonic license
- MADSONIC_LICENSE_EMAIL is the e-mail address associated with your license key
- MADSONIC_REDIRECT_FROM is the "friendly" hostname for your madsonic server (e.g. gswallow.madsonic.org)
- ansible_playbook_repo is this repo, unless you fork it.
- ansible_playbook_branch controls which branch (or git tag) to pull with ansible-pull during instance bootstrap.
