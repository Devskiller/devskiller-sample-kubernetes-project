# Devskiller programming task sample - Kubernetes

## Introduction

With [Devskiller.com](https://devskiller.com) you can assess your candidates'
programming skills as a part of your recruitment process. We have found that
programming tasks are the best way to do this and have built our tests
accordingly. The way our test works is your candidate is asked to modify the
source code of an existing project.

During the test, your candidates have the option of using our browser-based
code editor and can build the project inside the browser at any time. If they
would prefer to use an IDE they are more comfortable with, they can also
download the project code or clone the project’s Git repository and work
locally.

You can check out this short video to see the test from the [candidate's
perspective](https://devskiller.zendesk.com/hc/en-us/articles/360019530419-Programming-task-project-descriptor).

This repo contains a sample DevOps project and below you can find a detailed
guide for creating your own programming project.

**Please make sure to read our [Getting started with programming
projects](https://goo.gl/gkQU4J) guide first**

## Technical details

Kubernetes task is a special type of [DevOps task](https://github.com/Devskiller/devskiller-sample-devops-project) and also consists of two parts:

 * the initialization script `init.sh`
 * `bats` verification tests

The `init.sh` script is used for initializing the candidate's Kubernetes cluster that is set up in two modes:

1. By executing `/init/kube-init.sh` script at the cluster startup and can be used to provision some services on the cluster using Helm or an operator.
2. By applying `/init/kube-init.yaml` file with Kubernetes manifests
  
They are applied automatically if they exist and should be created within `init.sh` script if they are needed for the task purposes.

## Automatic assessment

It is possible to automatically assess the solution posted by the candidate.

**Verification tests** are unit tests that are hidden from the candidate. The
final score, calculated during verification, is a direct result of the
verification tests.

Verification tests in Kubernetes tasks *must* reside in the `verification`
directory, i.e. the `pathPatterns` directive in project descriptor is ignored.

## Devskiller project descriptor

Programming tasks can be configured with the Devskiller project descriptor
file:

1. Create a `devskiller.json` file.
2. Place it in the root directory of your project.

Here is an example project descriptor:

```json
{
    "verification" : {
        "testNamePatterns" : [ ".*Verification.*" ]
    },
     "cloud": {
        "k8sVersion": "1.20", 
        "instanceSize": "medium"
    }
}
```

There are additional `cloud` fields that are required for Kubernetes tasks:

* **k8sVersion** - specifies Kubernetes versions used in the task, also marks this task as Kubernetes type
* **instanceSize** - specifies instance size, `medium` is recommended for Kubernetes (4GiB memory, 2vCPUs)

You can find more details about the `devskiller.json` descriptor in our
[documentation](https://goo.gl/uWXeCD).

### Marking the end of initalization process

When the task is initiated on the DevSkiller platform, the existence of `/etc/devskiller/.task-init-complete` file tells the platform that the process has been completed. Make sure that at the end of initialization this file is created.

## Automatic verification with verification tests

The solution submitted by the candidate may be verified using automated tests with [bats](https://github.com/bats-core/bats-core).
Simply define which tests should be treated as verification tests.

To define verification tests, you need to set two configuration properties in
`devskiller.json`:

- `testNamePatterns` - an array of RegEx patterns which should match all the
  names of the verification tests.

In our sample task all verifications tests are prefixed with string `Verification`.
In this case the following patterns will be sufficient:

```json
"testNamePatterns" : [".*Verification.*"]
```