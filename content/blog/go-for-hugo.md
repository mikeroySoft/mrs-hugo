+++
author = "Michael Roy"
categories = ["Blog", "Hugo"]
tags = ["tutorial"]
date = "2019-07-20"
description = "Transitioned away from Wordpress to Hugo"
featured = "mrs-train.jpg"
featuredalt = "lilly pads, yo"
featuredpath = "/img/2019/07/"
linktitle = ""
title = "Go for Hugo"
type = "post"

+++

## We are Go for Hugo

Exciting times...
I just spent the past while converting my blog from Wordpress over to Hugo.
As part of the process, I set up a Continuous Integration and Deployment pipeline with the following characteristics:

- Hosted on Kubernetes (Digital Ocean)
- Build system handled by CircleCI
- SSL provided by LetsEncrypt using cert-manager
- All content, code and deployment files tracked in github (private repos)
- Main repo has several submodules for versioning sub-components (themes, content, deployment, circleci config, manual yamls)

I wasn't planning to migrate my old content, it's all fairly dated by now, so it made sense to start over with something new using as much open source cloud-native tooling as possible.

Hugo is nice because it simplifies delpoyment on Kubernetes by not requiring a database, or needing to maintain any sort of state. Ultimately, Hugo takes my .md files from git and creates static .html files to serve with nginx.
This makes it REALLY easy to scale, and really light weight.

The entire website is housed in a single docker image, replicated behind a LoadBalancer, and exposed with an nginx Ingress controller.

I use helm to update, the 'releases', and in so I can update content, or add more replicas.
This binds my 'content' and my 'code' together as one. Every time I create a new post, a new 'release' is generated.

With this setup, updates and rollbacks are a breeze, content is secure and, intrinsicly, doesn't need 'backups'. Happy days!
