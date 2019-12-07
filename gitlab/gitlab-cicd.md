
# GitLab CI/CD Pipelines

GitLab is better known for version control so why use it for Continuous Integration and Continuous Delivery.

### GitLab CI/CD | 7 Reasons Why

Gitlab CI/CD tools may be perfect for your project if and when

- your project is lightweight and common (Ruby, Python, Go)
- the complexity of Jenkins2 is overkill
- the cost of CircleCI, TravisCI and/or CodeShip feels exhuberant
- you don't want a public codebase in GitHub and/or BitBucket
- you'd like to use GitLab's inbuilt docker image repository
- running builds and tests against Git branches feels right
- you are already using Gitlab for version control (no brainer)

## The Kubernetes Runner

Kubernetes is the number one load executor for all CI/CD platforms and if you have a Kubernetes cluster available you should consider deploying your CI/CD workloads into it.

You should always farm out the actual load running thus separating it from the CI/CD brain. The brain's user interface needs to remain responsive and not get bogged down with workloads that can freeze and destabilize the environment.


**[[Video - GitLab CI/CD for Ruby with the Kubernetes Executor]](https://www.youtube.com/watch?v=1iXFbchozdY)**

