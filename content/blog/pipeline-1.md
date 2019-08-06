+++
author = "Michael Roy"
categories = ["Hugo"]
date = "2019-07-26"
description = "A quick rundown of the pipeline that powers this site"
featured = "pipeline.jpg"
featuredalt = "Pic 1"
featuredpath = "/img/2019/07/"
linktitle = "link-title"
title = "mikeroySoft Pipeline Overview"
type = "post"
draft = true
+++

## the mikeroysoft.com pipeline

As I mentioned in **[this post](/blog/go-for-hugo/)**, I had the desire to move off of Wordpress for some time. Maintaining it just was getting boring.

My wp installation, which was on an Ubuntu VM 'in the cloud' with a seperate VM for the db, kept running into issues. The docker image cache would fill up, and it kept getting hacked. Seemed like a great exercise to move my blog to something more 'cloud native' by way of using containers, kubernetes, and a continuously deploying pipeline.

With this setup, updates and rollbacks are a breeze, content and delivery are secure without relying on a big CDN like CloudFlare and, it intrinsicly doesn't need 'backups' becuase all the content is just a git repo on github and on my various machines. Happy days!

Ok, for anyone interested as well, as for my own sanity by having it all writen down, I'll document a rundown of how this blog is put together. I'll break the content up in a few posts to seperate some of the subject areas, lead with a deep enough overview to understand the system as whole before getting into the moving pieces.

I'll reference the sources where I put this all together, and shed some comments on what I had to do to get things working as described.

### The big picture

The app I'm using to 'generate' my site is Hugo, and it's job is to create static html from markdown content files based on yaml config files. Since everything is just text (and images), the whole lot should be kept in source control. I chose git and github for this.

The desire is to be able to keep the site really simple rather than using a big clunky database for some pretty basic content. I don't mind hosting a bunch of images in a github repo along with my content.

#### Workflows

I have 3 main workflows: one for **iterating dev**, one for **deploying to staging**, and one for **deploying into production**.

Dev is deployed using docker to my desktop, staging and production are both on DigitalOcean (using their kubernetes service). (*I plan on working minikube into the setup using VMware Fusion soon to simulate deployments locally, to avoid consuming cloud resources for early testing.*)

#### Docker

The docker image contains the entire site, including all staticly generated content, and sits behind a load balancer. The LB is exposed to the world with a public IP via an nginx Ingress controller. I use LetsEncrypt to provide HTTPS certificates on the Ingress side so the site works without security warnings.

This lets me keep the domain and https in a 'good state' while allowing me to update the container images behind the LB at will without disruption or re-cert'ing.

#### Content

All content is in a seperate github repo that gets pulled into Hugo's build process (hugo-extended) as the docker image is built. In more specific terms, 'content' is a folder in the root of the 'app'; that folder is a git submodule linking to the 'content' repo. On build it does a *git submodule update --remote* to pull in the other repos, which also includes the Hugo Theme. (Pretty handy to keep that always up to date with it's upstream source!). The config.toml file is configured to look at this path for the markdown content it uses to build the site.

#### Build Process

I'm using CircleCI to build the docker image with a combination of multi-stage dockerfile and Circle's tools.

Each code commit of the app repository triggers a Circle 'Workflow'. It builds and tags the completed docker image using the git branch name ('stable', 'master' and 'latest'), and if successful it then pushes the updated image to docker hub.

Circle needs a config folder in the repo (*.circleci*), so we maintain the build config from the root of the app folder. A to-do item would be to break this out into a submodule and track a different repo for circle (or build) specific config files.

Circle's final jobs are to deploy to the different kubernetes environments using helm. This means helm needs to be setup and configured properly on each of the destination clusters.

#### Deployment

CircleCI is also responsible for Deployment to 'staging' and 'prod'.

Deployment happens to 'staging' automatically when the 'master' git branch is updated. Deployment to 'production' happens when a 'release' is created in GitHub (i.e. manually). Releases come from the 'stable' branch. When I get lazy or if something isn't working with helm (like it was at first…), I can just update and push the docker image and then kill the pods in kubernetes. (alwaysPull policy ensures fresh images are pulled each time they're needed.)

So far the process takes about 30 seconds to build and push the docker image, and another 15 to deploy using helm.

Diagram

### Git setup

I currently maintain 2 main repositories… one for the app and one for the content, the latter of which is linked to the former as a git submodule.

The file structure for the 'app' (which in my case is defined as 'mrs-hugo') is pretty simple:

<pre>
~/dev/mrs-hugo:  tree -L 2
.
├── Dockerfile ***- main dockerfile for the whole site***
├── README.md ***- basic readme***
├── archetypes ***- hugo page templating***
├── config.toml ***- hugo main configuration file***
├── content ***- submodule folder for the markdown content***
├── man-yaml - ***- manual yaml files I need to set up the site (one-time-operation stuff)***
│   └── production_issuer.yaml ***- LetsEncrypt ClusterIssuer spec***
├── mrs-www ***- helm chart folder… should probably be a submodule***
│   ├── Chart.yaml ***- helm chart definition***
│   ├── templates ***- helm templates***
│   └── values.yaml ***- helm chart value definitions***
├── public ***- hugo-generated site folder***
├── resources ***- folder that gets generated containing javascript and scss assets***
└── themes ***- themes folder***
    ├── mrs-theme ***- current theme defined in config.toml, included as a submodule***
</pre>
To simplify, here are the important bits:
<pre>
├── Dockerfile ***- main dockerfile for the whole site***
├── config.toml ***- hugo main configuration file***
├── content ***- submodule folder for the markdown content***
├── mrs-www ***- helm chart folder… should probably be a submodule***
└── themes ***- themes folder***
</pre>
I think that should be a decent enough overview. Next I'll get into each of those areas, describe how and where I learned to solve for that part of the flow and link to the reference material appropriately.
