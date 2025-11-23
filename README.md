# 🚀 Cloud-Native DevOps Project (iVolve)

An end-to-end DevOps project demonstrating a complete **CI/CD pipeline** for a Python web application.  
This project uses **AWS**, **Terraform**, **Kubernetes (EKS)**, **GitHub Actions**, **Docker**, and **ArgoCD (GitOps)**.

---

## 📌 Architecture Overview
Developer → GitHub → GitHub Actions (CI) → DockerHub → ArgoCD (GitOps) → AWS EKS → LoadBalancer → User

![Project Architecture](https://raw.githubusercontent.com/Mohammed-Borham/Cloud-DevOps-Project/refs/heads/main/Cloud_DevOps_project.drawio.png)



---

## 🛠 Tech Stack

| Category | Tool | Description |
|---------|------|-------------|
| Cloud | AWS | VPC, EKS, LoadBalancers |
| IaC | Terraform | Infrastructure provisioning |
| Orchestration | Kubernetes (EKS) | Container orchestration |
| CI | GitHub Actions | Build → Scan → Push |
| CD / GitOps | ArgoCD | Auto-sync deployments |
| Security | Trivy | Docker image scanning |
| Containerization | Docker | App packaging |

---

## 📁 Project Structure

```
├── app/                # Python application
├── k8s/                # Kubernetes manifests
├── terraform/          # Terraform infrastructure code
└── .github/workflows/  # CI pipeline
```

---
## Step 0 - Cloud Environment Prep (Manual Setup via Console)
  Before running Terraform, we need to manually create the S3 bucket for state storage and the IAM Role.

#### 1. Create S3 Bucket (For Terraform State)

* Go to S3 service in AWS Console.
* Click Create bucket.
* Bucket name: `cloud-devops-project-tfstate` (Must be globally unique).
* Region: us-east-1.
* Keep other settings as default and click Create bucket.
#### 2. Create police to manage IAM, VPC, and EKS 
#### 3. Create IAM Role (For Terraform Access)

* Go to IAM service -> Roles -> Create role.
* Trusted entity type: Select AWS account -> This account.

* Click Next.

* Permissions: Search for Police which you created

* Click Next.

* Role name: `Terraform-Control-Plane-Role`

* Click Create role.




## 🏗 Step 1 - Provision Infrastructure (Terraform)
I use Terraform to build the VPC, Public Subnets, Internet Gateway, Custom Network ACLs, and the EKS Cluster.

```bash
terraform init
terraform plan
# Note: Ensure 'node_desired_count = 2' in terraform.tfvars to avoid resource limits on t3.small or use t3.medium
terraform apply -auto-approve
```

Make sure you have:

- S3 bucket for Terraform state  
- IAM role: `Terraform-Control-Plane-Role`
- Set `node_desired_count = 2` in terraform.tfvars

---

## 🔑 Step 2 — Connect to EKS

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name my-eks-cluster \
  --role-arn arn:aws:iam::Your_account_ID:role/Terraform-Control-Plane-Role

kubectl get nodes
```

---

## ⚙️ Step 3 — CI (GitHub Actions)
The pipeline handles Build, Trivy Scan, Push, and Manifest Update.

1. Secrets: Go to Repo Settings -> Secrets -> Actions and add:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

2. Permissions: Go to Repo Settings -> Actions -> General -> Workflow permissions and select Read and write permissions.

Pipeline steps:
1. Build Docker image  
2. Scan using Trivy  
3. Push to DockerHub  
4. Auto-update deployment manifest on k8s/

---

## 🚀 Step 4 — Deploy via ArgoCD
#### Installing ArgoCD to manage deployments via GitOps.

```bash
kubectl create namespace argocd

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "LoadBalancer"}}'
```

#### Get ArgoCD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

#### Get ArgoCD URL:

```bash
kubectl get svc argocd-server -n argocd
```

### ArgoCD App Configuration:
- **App Name:** `ivolve-app`
- **Project:** `default`
- **Repo Path:** `k8s/`
- **Cluster:** `https://kubernetes.default.svc`
- **Namespace:** `ivolve`
- **Sync Policy:** Automatic (Prune + Self-Heal)

---

## 🌐 Step 5 — Access Application
Once ArgoCD syncs the changes, the app is deployed to the ivolve namespace.

```bash
kubectl get pods -n ivolve
kubectl get svc -n ivolve
```

Open the **EXTERNAL-IP** in your browser.

---

## 🐛 Troubleshooting

### 1️⃣ Nodes not joining cluster
- Add NACL Inbound rules for **ephemeral ports 1024–65535**

### 2️⃣ Pods stuck in Pending
- t3.small supports ~11 pods only  
- Increase worker nodes to 2  
- Or reduce CoreDNS:

```bash
kubectl scale deployment coredns -n kube-system --replicas=1
```

### 3️⃣ Check logs / events

```bash
kubectl describe pod <name> -n ivolve
kubectl logs <name> -n ivolve
```



