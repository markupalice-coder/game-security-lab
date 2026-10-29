
# Runtime Detection Design



## Purpose



This design adds runtime security visibility for the Kubernetes-hosted game API.



Static scanners inspect source code, dependencies, containers, and manifests before release.

Runtime detection observes what actually happens after the workload is running.



## Protected Workload



- Workload: game-api

- Runtime: Kubernetes on Kind for this lab

- Namespace: default

- Service Port: 3000

- Primary Asset: API behavior after deployment

- Security Owner: SRE / Platform Security

- Application Owner: Backend Team



## Runtime Detection Tool



Tool: Falco



Falco watches Linux system activity and Kubernetes container context.

It raises alerts when runtime behavior matches suspicious rules.



## Lab 80 Detection Goals



1. Alert when a shell is spawned inside the game-api container.

2. Alert when the game-api container attempts to write below sensitive system paths.

3. Document unexpected outbound network detection as a production rule candidate.

4. Attach useful triage context to every runtime alert:

- workload

- namespace

- pod

- node

- container image

- image digest when available

- Git commit

- command line

- user

- process name



## Non-Goals



This lab does not build a full SIEM pipeline.

This lab does not deploy Falcosidekick, Loki, Grafana, PagerDuty, or Slack routing.

Those belong in later labs after scanner orchestration and evidence bundling mature.



## Alert Response Flow



1. Falco detects suspicious runtime behavior.

2. The learner captures the alert from Falco logs.

3. The learner runs the triage context helper script.

4. The learner opens a runtime alert triage issue.

5. The SRE or security owner decides whether the event is:

- expected administration

- misconfiguration

- compromised workload

- false positive

- training activity



## Initial Runtime Rules



| Rule | Severity | Purpose |

|---|---:|---|

| Lab80 Game API Shell Spawned | WARNING | Detect interactive or unexpected shells inside the game API pod |

| Lab80 Game API Sensitive Path Write | ERROR | Detect writes below sensitive paths such as /etc, /root, or service-account token paths |



## Production Hardening Roadmap



Future labs should route alerts to a central evidence store, normalize severities, link runtime findings to the control register, and automate GitHub issue creation for high-confidence events.

