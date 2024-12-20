<!-- markdownlint-disable -->
# (deprecated) terraform-aws-bc-eotk[![deprecated](https://img.shields.io/badge/lifecycle-deprecated-critical?style=flat-square)](#deprecated)
[![pipeline status](https://gitlab.com/sr2c/terraform-aws-bc-eotk/badges/main/pipeline.svg?ignore_skipped=true&style=flat-square)](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/pipelines)
[![latest release](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/badges/release.svg?style=flat-square)](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/tags)
[![gitlab stars](https://img.shields.io/gitlab/stars/sr2c/terraform-aws-bc-eotk?style=flat-square)](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/starrers)
[![gitlab forks](https://img.shields.io/gitlab/forks/sr2c/terraform-aws-bc-eotk?style=flat-square)](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/forks)
<!-- markdownlint-restore -->
[![SR2 Communications Limited][logo]](https://www.sr2.uk/)

[![README Header][readme_header_img]][readme_header_link]
<!--

  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of projects. This is how we maintain our sanity.)
  **

-->

## Deprecated
  This module is no longer actively maintained



### Historical Description

Terraform module to deploy Bypass Censorship Enterprise Onion Toolkit instances in AWS.

This module supports creating multiple EC2 instances, each serving the same selection of onion services. Due to the
way that onion services are published, this provides basic load balancing and failover, although there is no direct
coordination between the EOTK instances.

Each EC2 instance is deployed to a separate availability zone (up to a maximum number of the number of available
availability zones within the region).

The nginx reverse proxy server configured by EOTK on each instance will keep access logs and these will be rotated
hourly. On rotation, the logs will be copied to an S3 bucket for processing by an analytics system.

Rather than replace the EC2 instance on every update, which would be difficult given that EOTK builds tor and
OpenResty from source as part of the installation process (time consuming), a script is installed to reconfigure
EOTK every 25 minutes with any updated configuration bundle uploaded to the S3 bucket. The EC2 instances should
still be considered "disposable" however, as new AMIs will cause EC2 instance replacement.

![terraform-aws-bc-eotk overview](./docs/terraform-aws-bc-eotk.png)

---
It's 100% Open Source and licensed under the [BSD 2-clause License](LICENSE).

## Usage
Before the module may be used, a zip file containing the EOTK configuration and the necessary Onion and TLS keys
and certificates must be created. This may be done with
[archive_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file) or
with a tool like [deterministic-zip](https://github.com/timo-reymann/deterministic-zip) if it is acceptable to have
a non-Terraform solution for that part. No directory structure is used within the zip file, it has only a flat
structure. To begin, create a file named `sites.conf` that contains your EOTK configuration, for example:

```
set log_separate 1

set nginx_resolver 127.0.0.53 ipv6=off  # The EC2 instance will have systemd-resolved

set nginx_cache_seconds 60  # Handle bursts, but don't cache anything too long
set nginx_cache_size 64m
set nginx_tmpfile_size 8m

set x_from_onion_value 1

foreignmap facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion facebook.com
foreignmap twitter3e4tixl4xyajtrzo62zg5vztmjuricljdp2c5kshju4avyoid.onion twitter.com

set project sites

hardmap systems3hwkxej5nzmo6kvwgx6sik2plqe4w3lsqglr6xhvyi2xlsmqd test.sr2.uk
```

For each onion service, you'll need to include 4 more files in the zip file:

* `<onion address without .onion>.v3sec.key` - Onion secret key
* `<onion address without .onion>.v3pub.key` - Onion public key
* `<first 20 characters of onion address>-v3.pem` - TLS private key (PEM encoded)
* `<first 20 characters of onion address>-v3.cert` - TLS certificate (PEM encoded)

For the example given above, these files would be named:

* `systems3hwkxej5nzmo6kvwgx6sik2plqe4w3lsqglr6xhvyi2xlsmqd.v3sec.key` - Onion secret key
* `systems3hwkxej5nzmo6kvwgx6sik2plqe4w3lsqglr6xhvyi2xlsmqd.v3pub.key` - Onion public key
* `systems3hwkxej5nzmo6-v3.cert` - TLS private key (PEM encoded)
* `systems3hwkxej5nzmo6-v3.pem` - TLS certificate (PEM encoded)

You can then use the module to create EC2 instances and other resources to run EOTK and serve the onion site:

```hcl
module "eotk" {
  source               = "sr2c/bc-eotk/aws"
  namespace            = "eg"
  name                 = "bc-eotk"
  instance_count       = 1
  configuration_bundle = "configuration.zip"
}
```


## References

For additional context, refer to some of these links.

- [Bypass Censorship Portal Documentation](https://bypass.censorship.guide/) - The documentation for the portal software that uses this module.
- [terraform-aws-ec2-conf-log](https://gitlab.com/sr2c/terraform-aws-ec2-conf-log/) - The configuration and logging bucket setup that is used in this module.
- [Enterprise Onion Toolkit](https://github.com/alecmuffett/eotk) - The GitHub repository for the Enterprise Onion Toolkit that is installed and configured on each EC2 instance.


## Help

**Got a question?** We got answers.

File a
[GitLab issue](https://gitlab.com/sr2c/terraform-aws-bc-eotk/-/issues),
send us an [email][email] or join our [IRC](#irc).

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## IRC

[![IRC badge](https://img.shields.io/badge/libera.chat-%23sr2-blueviolet?style=flat-square)][irc]

Join our [public chat][irc] on IRC.
If you don't have an IRC client already, you can get started with the
[web client](https://web.libera.chat/#sr2).
This is the best place to talk shop, ask questions, solicit feedback, and work
together as a community to build on our open source code.



## Copyright

Copyright © 2021-2024 SR2 Communications Limited

## License

![License: BSD 2-clause](https://img.shields.io/badge/License-BSD%202--clause-blue?style=flat-square)

```text
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained by [SR2 Communications Limited][website].

[![SR2 Communications Limited][logo]][website]

We're a [DevOps services][website] company based in Aberdeen, Scotland. We
specialise in solutions for online freedom, digital sovereignty and
anti-censorship.

We offer [paid support][website] on all of our projects.

Check out [our other projects][gitlab], or [hire us][website] to get support
with using our projects.

## Contributors

<!-- markdownlint-disable -->
|  [![irl][irlxyz_avatar]][irlxyz_homepage]<br/>[irl][irlxyz_homepage] |
|---|

  [irlxyz_homepage]: https://gitlab.com/irlxyz
  [irlxyz_avatar]: https://gitlab.com/uploads/-/system/user/avatar/5895869/avatar.png?width=130

<!-- markdownlint-restore --><!-- markdownlint-disable -->
  [logo]: https://www.sr2.uk/readme/logo.png
  [website]: https://www.sr2.uk/?utm_source=gitlab&utm_medium=readme&utm_campaign=sr2c/terraform-aws-bc-eotk&utm_content=website
  [gitlab]: https://go.sr2.uk/gitlab?utm_source=gitlab&utm_medium=readme&utm_campaign=sr2c/terraform-aws-bc-eotk&utm_content=gitlab
  [contact]: https://go.sr2.uk/contact?utm_source=gitlab&utm_medium=readme&utm_campaign=sr2c/terraform-aws-bc-eotk&utm_content=contact
  [irc]: ircs://libera.chat/sr2
  [linkedin]: https://www.linkedin.com/company/sr2uk/
  [email]: mailto:contact@sr2.uk
  [readme_header_img]: https://www.sr2.uk/readme/paid-support.png
  [readme_header_link]: https://www.sr2.uk/?utm_source=gitlab&utm_medium=readme&utm_campaign=sr2c/terraform-aws-bc-eotk&utm_content=readme_header_link
  [readme_commercial_support_img]: https://www.sr2.uk/readme/paid-support.png
  [readme_commercial_support_link]: https://go.sr2.uk/commerical-support?utm_source=gitlab&utm_medium=readme&utm_campaign=sr2c/terraform-aws-bc-eotk&utm_content=readme_commercial_support_link
<!-- markdownlint-restore -->
