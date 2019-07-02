---
title: "Go for Hugo"
date: 2019-07-01T20:36:20-07:00
draft: false
---
# We are Go for Hugo
Exciting times...
I just spent the past while converting my blog from Wordpress over to Hugo.
As part of the process, I set up a Continuous Integration and Deployment pipeline with the following characteristics:
- Hosted on Kubernetes (Digital Ocean)
- Build system handled by CircleCI
- SSL provided by LetsEncrypt using cert-manager
- All content, code and deployment files tracked in github (private repos)
- Main repo has several submodules for versioning sub-components (themes, content, deployment, circleci config, manual yamls)

I don't think I was really worried about migrating my old content, but I might pull it in to an archive folder at the topmost menu at some point. Not super difficult to do =)

Hugo is nice because it simplifies delpoyment on Kubernetes by not requiring a database, or needing to maintain any sort of state. Ultimately, Hugo takes my .md files from git and creates static .html files to serve with nginx.
This makes it REALLY easy to scale, and really light weight. 

The entire website is housed in a single docker image, replicated behind a LoadBalancer, and exposed with an nginx Ingress controller. 

I use helm to update the 'releases', so I can update content, or add more replicas. 
This binds my 'content' and my 'code' together as one. Every time I create a new post, a new 'release' is generated.

It was a lot of work setting up, so I'll describe in detail the process without copy and pasting the step-by-steps... I'll link to the articles that I read to get it done, and share commentary about what I learned with every step of the process.

Rather than fill this post with all that detail, I'll instead put it together in a series of posts about each topic area so it's a little easier to digest.
