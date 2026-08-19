# Terraform Hello AWS

Infrastructure-as-Code deployment of a single EC2 instance running Nginx, provisioned entirely via Terraform.

## Architecture

```
Terraform
  │
  ├── Security Group (hello-terraform-sg)
  │     allows: HTTP (80), SSH (22)
  │
  └── EC2 Instance (Ubuntu 22.04, t3.micro)
        ├── user_data → installs & starts Nginx
        └── serves a static "Hello from Terraform!" page
```

## Stack

| Layer      | Technology                                                                |
|------------|----------------------------------------------------------------------------|
| IaC        | Terraform (`~> 5.0` AWS provider)                                          |
| Compute    | AWS EC2 (t3.micro, Free Tier eligible)                                     |
| AMI        | Dynamically resolved latest Ubuntu 22.04 (Canonical, owner `099720109477`) |
| Web server | Nginx (installed via `user_data` at boot)                                  |
| Networking | Security Group (HTTP + SSH ingress, unrestricted egress)                   |

## Run it

```bash
terraform init
terraform plan
terraform apply
```

Terraform prints the instance's `public_ip` and `web_url` on completion. Give the instance about a minute to finish running `user_data`, then:

```bash
curl $(terraform output -raw web_url)
```

When done:

```bash
terraform destroy
```

## Key decisions

- **Dynamic AMI lookup** instead of a hardcoded AMI ID — the `data "aws_ami"` block always resolves to the latest Ubuntu 22.04 image in the target region, so the deployment doesn't silently break as AMIs get deprecated.
- **`user_data` for bootstrapping** — Nginx installs and starts automatically on first boot, no manual SSH step needed to see the demo running.
- **Security Group is intentionally permissive** (HTTP/SSH open to `0.0.0.0/0`) — this is a learning project, not a production deployment. In production, SSH would be scoped to a specific IP range or replaced with SSM Session Manager (no open port at all).
- **Local state only** — this was the first Terraform project in the portfolio. Remote state (S3 + DynamoDB locking), VPC design, and RDS were introduced in the next project, Monitored API.

## Outputs

| Output        | Description                          |
|---------------|----------------------------------------|
| `instance_id` | EC2 instance ID                       |
| `public_ip`   | Public IP address of the instance     |
| `web_url`     | Full URL to view Nginx running        |
