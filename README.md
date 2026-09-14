# 🪪 Learn AWS Foundations the School Way — IAM & EC2

The **foundations course** of the school series — the two AWS ideas every other course stands on:

- 🪪 **IAM** — *who may do what* (the ID-card office). Used by ECR logins (Docker course),
  EKS node permissions (Kubernetes course), and CI roles (ArgoCD course).
- 🖥️ **EC2** — *the rented computers* everything runs on. EKS "nodes"? EC2. That $73/month
  cluster? Plus EC2. Know the desk before you rent a hundred of them.

🌐 **Interactive site:** **<https://baluraut.github.io/learn-aws-school/>** — lesson cards,
every lesson as a numbered diagram, the big-picture 4K, and the Before &amp; trade-offs page.

**The series:** 0️⃣ this course (foundations) · 1️⃣ [Docker & ECR](https://github.com/BaluRaut/learn-docker-school) ·
2️⃣ [Kubernetes](https://github.com/BaluRaut/learn-kubernetes-school) · 3️⃣ [ArgoCD](https://github.com/BaluRaut/learn-argocd-school)

## 🗺️ The big picture — one diagram, both worlds

![The big picture: IAM (who may do what) and EC2 (the rented computers)](docs/images/big-picture-4k.png)

## 🎓 The 20 lessons

Each numbered branch adds ONE lesson folder (`lessons/NN-topic/README.md`) with an
explain-like-I'm-5 story, a school analogy, a diagram, **What / Why / How**, and hands-on
commands. Branches are **sequential** — branch 07 contains lessons 01–07.

```bash
git checkout lesson-01-why-iam          # read lessons/01-why-iam/README.md, then...
git checkout lesson-02-users-groups     # ...keep going, one branch at a time
```

### Part 1 — IAM: who may do what 🪪

| # | Branch | You learn | Analogy |
|---|---|---|---|
| 01 | `lesson-01-why-iam` | Root account danger; why identity exists | The principal's master key 🗝️ |
| 02 | `lesson-02-users-groups` | Users & groups | ID cards & the "teachers" list 🪪 |
| 03 | `lesson-03-policies` | Policy JSON: Effect/Action/Resource | Permission slips 📝 |
| 04 | `lesson-04-roles` | Roles & AssumeRole — temporary hats | The substitute-teacher hat 🎩 |
| 05 | `lesson-05-machine-identities` | Instance roles, OIDC for CI — no keys! | Staff badges for robots 🤖 |
| 06 | `lesson-06-iam-hygiene` | MFA, least privilege, audit | The ID-office rules poster 📋 |

### Part 2 — EC2: the rented computers 🖥️

| # | Branch | You learn | Analogy |
|---|---|---|---|
| 07 | `lesson-07-what-is-ec2` | What an instance really is | A rented desk-computer 🖥️ |
| 08 | `lesson-08-types-pricing` | Instance types; on-demand/spot/savings | Scooter vs truck; standby seats 🛵🚚 |
| 09 | `lesson-09-connecting` | Key pairs, SSH — and SSM (the modern way) | Door key vs escorted visit 🔑 |
| 10 | `lesson-10-security-groups` | The instance firewall | The gatekeeper's guest list 🚪 |
| 11 | `lesson-11-ebs-snapshots-ami` | Disks, snapshots, images | Drawer, photocopy, desk template 🗄️ |
| 12 | `lesson-12-ec2-in-real-life` | user-data, metadata, ASGs, EKS nodes | The robot janitor's checklist 🤖📋 |


### Part 3 — the campus & the services 🏫

| # | Branch | You learn | Analogy |
|---|---|---|---|
| 13 | `lesson-13-vpc` | VPC, subnets, IGW, NAT, route tables | The campus walls & corridor signs 🏫🪧 |
| 14 | `lesson-14-s3` | Buckets, objects, presigned URLs, lifecycle | The infinite locker room & visitor passes 🗄️🎟️ |
| 15 | `lesson-15-load-balancers` | ALB/NLB, target groups, health checks | The reception that splits crowds 🛎️ |
| 16 | `lesson-16-route53` | DNS, records, TTL, failover routing | The school's phonebook ☎️ |
| 17 | `lesson-17-rds` | Managed databases, Multi-AZ, replicas | The record office you rent 🗃️ |
| 18 | `lesson-18-cloudwatch` | Metrics, logs, alarms → actions | Report cards, diaries, alarm bells 📈🔔 |
| 19 | `lesson-19-lambda` | Serverless functions, events, cold starts | The on-call helper ⚡ |
| 20 | `lesson-20-the-bill` | The four meters, budgets, cost hygiene | Reading the meter 🧾 |

## 📦 What's in this repo (main branch)

```
learn-aws-school/
├── iam/
│   ├── ecr-push-policy.json        # a real least-privilege permission slip
│   └── ec2-role-trust-policy.json  # who may wear the hat
├── ec2/
│   ├── ec2.tf                      # one rented computer as code: SG + role + t3.micro
│   └── user-data.sh                # the boot checklist: becomes a web server on first boot
└── docs/                           # the GitHub Pages site
```

⚠️ **Costs:** IAM is free. EC2 labs use a `t3.micro` (free-tier eligible; otherwise ~$0.01/hour) —
every lesson ends with cleanup. Never leave a lab instance running overnight.

## 🚀 Quickest possible taste (3 min, free)

```bash
aws sts get-caller-identity          # who am I? (lesson 01's first question)
aws iam list-account-aliases         # your account's nickname
# Part 2's one-command computer:
cd ec2 && terraform init && terraform apply -var my_ip=$(curl -s ifconfig.me)/32
# then open http://<public_ip> ... and ALWAYS: terraform destroy
```
