# Jenkins CI/CD Setup Guide — DevOps IA-3

## Overview
This directory details the Jenkins automation server running in Docker Desktop on Windows 11. Jenkins serves as the Continuous Integration and Continuous Deployment (CI/CD) engine for the **DevOps IA-3 Academic Project**.

---

## Container Architecture

- **Container Name:** `devops-jenkins`
- **Base Image:** `jenkins/jenkins:lts-jdk21`
- **Installed Tools:** `git`, `openssh-client`, `curl`
- **Host Binding:** `127.0.0.1:8080:8080` (Local access only; not exposed to the public internet)
- **Persistent Volume:** `jenkins_home` (Docker managed volume)
- **Compose Specification:** `jenkins/compose.yaml`

---

## Required Jenkins Plugins

Verify that the following plugins are installed via **Manage Jenkins → Plugins → Installed plugins**:
1. **Pipeline** (`workflow-aggregator`)
2. **Git Plugin** (`git`)
3. **GitHub Plugin** (`github`)
4. **Credentials Binding Plugin** (`credentials-binding`)
5. **SSH Credentials Plugin** (`ssh-credentials`)

---

## Configuring Jenkins Credentials for Azure SSH

To allow Jenkins to deploy to the Azure Linux VM (`azureuser@20.219.161.235`) securely:

1. Navigate to: **Manage Jenkins → Credentials → System → Global credentials (unrestricted)**.
2. Click **+ Add Credentials**.
3. Configure the credential fields:
   - **Kind:** `SSH Username with private key`
   - **Scope:** `Global (Jenkins, nodes, items, all child items, etc.)`
   - **ID:** `azure-vm-ssh-key` *(Must match `CREDENTIALS_ID` in `Jenkinsfile`)*
   - **Description:** `Azure Linux VM SSH Key for DevOps IA-3`
   - **Username:** `azureuser`
   - **Private Key:** Select **Enter directly** → Click **Add** → Paste the content of `C:\Users\franc\.ssh\devops_ia3_key` (ensuring no trailing spaces or modifications).
   - **Passphrase:** Leave blank (no passphrase).
4. Click **Create**.

---

## Creating the Jenkins Pipeline Job

1. From the Jenkins dashboard, click **New Item**.
2. Enter item name: `DevOps-IA3-Pipeline`.
3. Select **Pipeline** and click **OK**.
4. In the job configuration:
   - **Description:** `Automated CI/CD Pipeline for DevOps IA-3 Project`
   - Under **Build Triggers**:
     - Select **Poll SCM** and set Schedule to `H/2 * * * *` (polls GitHub every 2 minutes for new commits without needing an inbound public webhook).
   - Under **Pipeline**:
     - **Definition:** `Pipeline script from SCM`
     - **SCM:** `Git`
     - **Repository URL:** `https://github.com/francis1103/DevOps-IA3.git`
     - **Branch Specifier:** `*/main`
     - **Script Path:** `Jenkinsfile`
5. Click **Save**.

---

## Testing the Pipeline

Click **Build Now** to trigger the pipeline.
Jenkins will:
1. Check out the latest code from GitHub.
2. Validate file integrity and security policies.
3. Verify Terraform definitions.
4. Securely establish SSH to `20.219.161.235` using the stored credential.
5. Deploy latest web files to `/var/www/devops-ia3` and reload Nginx.
6. Verify live HTTP 200 status on port 80.
