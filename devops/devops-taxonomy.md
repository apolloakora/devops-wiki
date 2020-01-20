
# DevOps Taxonomy

A **devops taxonomy** helps us collate and document the many assets that are dedicated to delivering **value, productivity, efficiency** to the software developers, infrastructure developers, architects, system administrators and business analysts around us.

## How to Group DevOps Assets

You don't put milk on bookshelves, the microwave doesn't go in the bathroom and modest bedrooms rarely have sofas.

The key pidgeon holes under consideration when grouping your tech (devops) assets are

- **what interface** does it expose &raquo; **command line** (cli), web or desktop (**gui**), **REST** or **SDK**?
- what purpose does it serve and in which use cases is it involved in - security, monitoring, continuous integration, scripting
- what inherently is it &raquo a middleware service, language, managed service, provisioner, library, pattern, process, an IDE?
- whom does it serve - project managers, developers, analysts architects and when, where or during (what)
- conceptually where is it? - in the cloud, office, a smartphone


## State | Where do clothes go and why?

Where clothes go shows us that **state plays an important role** in taxonomy. **Clothes go** in the

- **wardrobe** when **clean**
- **dirty clothes** basket when ...
- **washing machine** to be (and when being) cleaned
- (on a) clothes line or a dryer to ...
- recycling bin when no longer wanted

Shoes and suits are forms of clothing but they don't fit so well in some of the above pidgeon holes. Dry cleaners and boot polish come into play.

## No need to group assets | Surely?

Email groups aren't that important anymore. Nobody moves e-mails anywhere (except the bin). This is because we now have powerful search and indexing tools (Google, ElasticSearch, Lucene) - so the **finding part** is never a problem.

## Taxonomy | Putting and Looking | Not Finding

Microservices tell us that grouping is not a thing of the past. The human brain does not like monoliths because there is too much to take in at once. We want our resources in bite-size, understandable and manageable chunks.

**We don't group to find (in IT) we group to put, look and understand.**

A group of between 4 and 7 items is excellent for the human brain. 5 methods in a class, 6 importnt web security considerations, 7 software languages to choose from, 4 candidates to select.

## Brains Need Taxonomy | Put Look and Decide

Our brains work best with small groupings. We don't like 200 CVs to look through - we want 5 excellent candidates and another group of 7 very good ones.

Its not about **finding** Joe Blogg's CV, it's about **putting** these CVs here and those there, then **looking through**, **understanding** and **deciding**.

## The DevOps Engineer Taxonomy Tree

This folder structure, philosophy and principle stands for the
- wiki documentation
- external website bookmarks
- media files (pdf books, images and videos)


architecture
  |-- microservices
  |-- patterns
  |-- serverless
  |-- restful


credentials
  |-- keys+certs
  |-- s3

cloud
  |-- network
  |-- s3
  |-- iam
  |-- elasticsearch
  |-- aurora
  |-- redis
  |-- kubernetes


cmdtools
  |-- bash
        |-- search.md    (grep, find)
        |-- network.md   (netstat, ifconfig)
        |-- disk.md      (du, df)
  |-- psql
  |-- rclone
  |-- kubectl
  |-- git
  |-- coreos
  |-- curl
  |-- postman
  |-- jq
  |-- openvpn
  |-- opensecret
  |-- ssh


desktop
  |-- firefox
  |-- chrome
  |-- openvpn
  |-- intellij
  |-- pycharm
  |-- emacs
        |-- git


devops
  |-- ansible
  |-- terraform
  |-- kubernetes
        |-- fluentd.md
  |-- docker
        |-- fluentd
  |-- chef
  |-- vagrant
  |-- puppet
  |-- cloud-formation


eco-system
  |-- certificates
  |-- iam


managed
  |-- circleci
  |-- travisci
  |-- confluence
  |-- jira
  |-- bitbucket
  |-- googledrive
  |-- codeship
  |-- github
  |-- dockerhub
  |-- kibana


middleware
  |-- openvpn
  |-- nginx
        |-- fluentd.md
  |-- sqs
  |-- activemq
  |-- rabbitmq
        |-- fluentd.md


stores  (trumps middleware - only put things into middleware (like nginx) that aren't stores)
  |-- elasticsearch
  |-- gitlab
  |-- mongodb
  |-- mysql
  |-- postgres
  |-- memcached
  |-- redis
        |-- fluentd.md
  |-- zookeeper


filesystems
  |-- s3
  |-- googledrive
  |-- hdfs
  |-- ceph
  |-- gluster
  |-- nfs
  |-- ebs
  |-- docker-volumes
  |-- samba


opensecret
  |-- use-cases


software
  |-- ruby
        |-- rubygem
        |-- aruba
        |-- cucumber
        |-- minitest
        |-- rvm
        |-- bundler
        |-- rake
        |-- thor
  |-- golang
        |-- gorm
  |-- python
        |-- wheels


18xxx-gitlab-2125276276.eu-west-1.elb.amazonaws.com



## DevOps | Your Guiding Principles

Take time out to think about the guiding principles driving your organisation and technology. Businesses grow, technologies come and go, but your guiding principles should endure for many years at a time. I believe deeply in these IT evolution principles.

- recreate everything aoap (as often as possible)
- open (source) as much as you can
- secure the bare minimum | declassify often
- document only the published (and public) interfaces
- reuse as many (external and internal) resources as you can
- trash early and trash often
- think in terms of apps, aspects, interfaces, pipelines, players, platforms and eco-systems
- all pipelines take from a source and give to a sink
- understand what intellectual property is | and where yours is

Automation is not mentioned because it is implicit in recreating everything often.

## Precious Patterns

Document your goals - and the simplest way to do this is to document the patterns that are valuable in your situation. These patterns drive many millions of small changes, that eventually lead to a significant technologically unstoppable, agile business.

Patterns to consider adopting are the

- serverless pattern
- immutable infrastructure pattern
- microservices
- object orientation (especiall small interfaces)
- behaviour driven development
- open source patterns
- containerized deployments
- auto service discovery
- software as a service and platform as a service


## How to Organise DevOps Assets? | Where to put them?

The first hurdle is to being able to categorize anything and everything! Accept that they won't all fit into  one bucket - unless everything has its own bucket! It must be instinctive, buckets must be mamnageable and searching needs to produce and collate the highest quality resources from the intranet, extranet and internet.

## The Key Taxonomy Rules

Content should never live at deeper than the third (3rd) level of a tree.

level 1a
  |-- level 1a2a
        |-- level 1a2a3a
        |-- level 1a2a3b
        |-- level 1a2a3c
  |-- level 1a2b
        |-- level 1a2b3a
        |-- level 1a2b3b
  |-- level 1a2c
        |-- level 1a2c3a

level 1b
  |-- level 1b2a
        |-- level 1b2a3a
        |-- level 1b2a3b
        |-- level 1b2a3c
  |-- level 1b2b
        |-- level 1b2b3a
        |-- level 1b2b3b
  |-- level 1b2c
        |-- level 1b2c3a


## How Apps Expose Interfaces?

Larger apps (MySQL for example) expose many interfaces including

- as a middleware service on host/port (3306 for MySQL)
- at the command line
- with a web gui interface
- with a desktop client
- with a REST API
- via a cloud service ( like Amazon's RDB service )


## What Platforms do Apps run on?

- bare metal installs (sudo apt-get)
- Dockerrized container installs
- Install within a Kubernetes cluster
- Installs inside a Cloud Provider (eg Amazon RDS)
- remote (middleware as a service) installs
- embedded within applications (eg HSQLDb or Jetty)


## Platforms, Apps, Libraries (Packages and Plugins), Tech and Eco-Systems

Certain apps, programming languages, and technologies like Python, Java and Jenkins can be eco-systems as well as clustering within other eco-systems.

     A moon is related to other moons but one can cluster around Jupiter which in turns belongs to a solar system.

Apps and Platforms can eschew or implement patterns

- Docker implements the immutable infrastructure pattern
- Amazon's RDB and Lambda eschew the serverless pattern


## Libraries (Packages and Plugins) | Coalesce around Platformss and Players

All libraries, apps, plugins and the like **implement interfaces** laid down by the platform in order that searches can find and download them, installers can onboard them and their users can enjoy their offerings.

Libraries will strictly fall under the wing of a heavy-weight technology, language and/or platform.

- a plethora of libraries exist under NodeJS's javascript platform
- many containers exist for the Docker platform
- there are plugins abound for Chrome, Firefox, Jenkins and Git, iTunes
- packages and libraries exist for Java (Beans), Python (Wheels) and Ruby (Gems)
- apps are available from AppStores, Maven, RubyGems, PyPi and PlayStores
- packages for apt, yum, snap, rpm, pip, gem

All that is done in the name of **distribution**. Products, apps, and tools are distributed using libraries, package managers and platforms.


### The Rules of the Platform

Every App (product) must

- be **placed** (so that it can be found)
- adhere to the rules of the **platform**
- project an **understandable interface** to players
- deliver on **promises to player and platform**

Application developers often fall foul of producing packages that are not properly placed, that do not adhere to the rules and ethos of the platform, that project an interface whose understandability and learning curve is not proportional to the problem it purports to solve, and at the final hurdle it does not deliver on its promises to player or platform.

