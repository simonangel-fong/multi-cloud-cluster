create github page using html
file path docs/

style:

- https://simonangel-fong.github.io/multi-tenant-cluster-eks/
- https://gitops.arguswatcher.net/
- https://eks-benchmark.arguswatcher.net/

- framework: bootstap:latest + custom css,js

phases:
1

- create hello world page, verify page is enable in github

2 design outline

3 section dev

- per section
  - generate content
  - approval
  - generate code
  - preview locally

4

- review and polish html, css, and js.
- use bg image

---


Business Challenge & Solution
Relying on a single cloud provider is a hidden business risk, because:

- single provider outage takes the entire service offline with no fallback and no warning
- Pricing increases or contract changes leave the business with no negotiating power
- Migrating to another provider later means months of costly re-engineering

> How do businesses protect themselves from cloud dependency?

This project solve the problem

- create multi-cloud clusters in AWS EKS and Azure AKS using Terraform
- deploy application across AWS EKS and Azure AKS simultaneously,
- apply gitops practices to automate deployment.

Benefits:

- Resilience: survive a regional or provider-level outage
- Cost control: combine savings plans and avoid lock-in pricing
- Flexibility: place each workload where it performs best

Trade-offs:

- More moving parts: multiple control planes and networking stacks to manage
- Consistency overhead: keeping both environments in sync requires extra tooling and discipline


## Feature: Multi-cloud Deploy

![architecture diagram]()

How it works (3 steps, vertical):

1. **Register the clusters** AWS EKS and Azure AKS are registered in ArgoCD, each labelled with its cloud provider
2. **One config, two targets** A single ArgoCD ApplicationSet reads those labels and deploys to every matching cluster automatically
3. **Cloud-specific settings** Each cluster receives its own Helm values, so cloud differences are handled without duplicating code

![ArgoCD UI - apps list](./docs/img/argocd_ui02.png)
Application list: prefixed with cluster name


![ArgoCD UI - app](./docs/img/argocd_ui03.png)
Application: `Healthy` and `Synced`

Feature: Traffic Control

Feature: Cloud-agnostic Monitoring