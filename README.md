## The repo contains Packer that build an AWS AMI with Node and Ember-cli preinstalled - the AMI is Bionic64 with latest updates.

### Usage example:

#### This will build an AWS AMI with the latest 12th version of [NodeJs](https://nodejs.org/en/) and [Ember-cli](https://emberjs.com/) installed . 

- Export you AWS keys:
```
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```
- Start packer
```
packer build ember.json
``` 

For more info please check a following link:

https://www.packer.io/intro/getting-started/build-image.html#some-more-examples-

To test you will need Kitchen:

Kitchen is a RubyGem so please find how to install and setup Test Kitchen for developing infrastructure code, check out the [Getting Started Guide](http://kitchen.ci/docs/getting-started/).

A following [gems](https://guides.rubygems.org/what-is-a-gem/) should be installed:

```
gem install  kitchen-vagrant
gem install  kitchen-inspec
```
Than simply execute a following commands:

```
kitchen converge
kitchen verify
kitchen destroy
```
The result should be as follow
``` 
  Command: `lsb_release -c`
     ✔  stdout should include "bionic"
  debian
     ✔  should eq "debian"
  18.04
     ✔  should eq "18.04"
  Command: `ember`
     ✔  should exist
  Command: `ember -v`
     ✔  stdout should include "3.11.0"
  Command: `node`
     ✔  should exist
  Command: `node -v`
     ✔  stdout should include "12.7.0"

Test Summary: 7 successful, 0 failures, 0 skipped
```
