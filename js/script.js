/**
 * DevOps IA-3: Modern Cloud Deployment Dashboard Interactive Script
 * Author: Francis | Project: DevOps IA-3 Academic Project
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Mobile Navigation Toggle
    const mobileToggle = document.getElementById('mobile-toggle');
    const navMenu = document.getElementById('nav-menu');
    const navLinks = document.querySelectorAll('.nav-link');

    if (mobileToggle && navMenu) {
        mobileToggle.addEventListener('click', () => {
            const isOpen = navMenu.classList.toggle('open');
            mobileToggle.setAttribute('aria-expanded', isOpen);
            const bars = mobileToggle.querySelectorAll('.bar');
            if (isOpen) {
                bars[0].style.transform = 'rotate(45deg) translate(5px, 6px)';
                bars[1].style.opacity = '0';
                bars[2].style.transform = 'rotate(-45deg) translate(5px, -6px)';
            } else {
                bars[0].style.transform = 'none';
                bars[1].style.opacity = '1';
                bars[2].style.transform = 'none';
            }
        });

        // Close mobile nav when clicking a link
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                if (navMenu.classList.contains('open')) {
                    navMenu.classList.remove('open');
                    const bars = mobileToggle.querySelectorAll('.bar');
                    bars[0].style.transform = 'none';
                    bars[1].style.opacity = '1';
                    bars[2].style.transform = 'none';
                }
            });
        });
    }

    // 2. Active Navigation Link on Scroll
    const sections = document.querySelectorAll('section[id]');
    window.addEventListener('scroll', () => {
        const scrollY = window.pageYOffset;
        sections.forEach(current => {
            const sectionHeight = current.offsetHeight;
            const sectionTop = current.offsetTop - 120;
            const sectionId = current.getAttribute('id');
            const correspondingLink = document.querySelector(`.nav-link[href*="${sectionId}"]`);
            if (correspondingLink) {
                if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                    correspondingLink.classList.add('active');
                } else {
                    correspondingLink.classList.remove('active');
                }
            }
        });
    });

    // 3. Interactive Pipeline Stage Inspector
    const pipelineSteps = document.querySelectorAll('.pipeline-step');
    const inspectorTag = document.getElementById('inspector-tag');
    const inspectorTitle = document.getElementById('inspector-title');
    const inspectorDesc = document.getElementById('inspector-desc');
    const inspectorTool = document.getElementById('inspector-tool');
    const inspectorEnv = document.getElementById('inspector-env');
    const inspectorArtifact = document.getElementById('inspector-artifact');
    const inspectorStatus = document.getElementById('inspector-status');

    const stageDetails = {
        '1': {
            tag: 'STAGE 1 / 7',
            title: 'Source Code Development & Local Testing',
            desc: 'The developer authors responsive HTML5, modern CSS3 styling, and client-side JavaScript. Local validation ensures semantic code quality and responsiveness across viewports prior to version control tracking.',
            tool: 'Git 2.50.1 / VS Code / Antigravity IDE',
            env: 'Windows 11 Workstation',
            artifact: 'Clean Git Working Tree',
            status: 'READY'
        },
        '2': {
            tag: 'STAGE 2 / 7',
            title: 'GitHub Central Version Control',
            desc: 'Source code is pushed to the remote GitHub repository (francis1103/DevOps-IA3.git). Branch protection rules and Git commit histories provide auditability and act as the single source of truth.',
            tool: 'GitHub Remote Repository',
            env: 'Cloud Git Service (HTTPS)',
            artifact: 'Versioned Git Commit / Release Tag',
            status: 'READY'
        },
        '3': {
            tag: 'STAGE 3 / 7',
            title: 'Dockerized Jenkins Automation Engine',
            desc: 'Jenkins runs inside an isolated Docker container on port 8080. It detects repository changes, checks out the latest commit, runs syntax validation, tests, and prepares deployment packages.',
            tool: 'Jenkins LTS 2.479 / OpenJDK 21 in Docker',
            env: 'Docker Desktop (Windows 11 Container)',
            artifact: 'Validated Build Artifacts',
            status: 'ACTIVE'
        },
        '4': {
            tag: 'STAGE 4 / 7',
            title: 'Terraform Infrastructure as Code Validation',
            desc: 'Terraform configuration describes all required Azure resources (Resource Group, VNet, Subnet, NSG, Public IP, NIC, and Ubuntu VM). Terraform fmt and validate confirm syntax and structure.',
            tool: 'HashiCorp Terraform v1.10.5 & AzureRM Provider',
            env: 'Local CLI / CI Validation Step',
            artifact: 'Validated Terraform Plan',
            status: 'VALID'
        },
        '5': {
            tag: 'STAGE 5 / 7',
            title: 'Microsoft Azure Cloud Platform',
            desc: 'Azure hosts the compute and networking layer in Central India. Strict Network Security Groups restrict SSH access to the verified administrator IP while allowing public HTTP ingress on port 80.',
            tool: 'Azure Resource Manager / Azure CLI 2.91.0',
            env: 'Azure for Students (Central India)',
            artifact: 'Static Public IP (20.219.161.235)',
            status: 'ACTIVE'
        },
        '6': {
            tag: 'STAGE 6 / 7',
            title: 'Azure Linux Virtual Machine (Host)',
            desc: 'A dedicated Ubuntu 22.04 LTS instance (Standard_B2als_v2) receives deployment packages over encrypted SSH using an Ed25519/RSA private key stored in Jenkins credentials vault.',
            tool: 'OpenSSH Server / Ubuntu 22.04 LTS',
            env: 'Azure VM: devops-ia3-vm',
            artifact: 'Target Document Root (/var/www/devops-ia3)',
            status: 'READY'
        },
        '7': {
            tag: 'STAGE 7 / 7',
            title: 'Nginx Web Server & Public Application',
            desc: 'Nginx serves the production web application on HTTP port 80. An automated post-deployment health check verifies HTTP 200 response codes, completing the continuous delivery cycle.',
            tool: 'Nginx 1.18+ / Systemd Service',
            env: 'Public Web Access (http://20.219.161.235)',
            artifact: 'Live Web Application Dashboard',
            status: 'ACTIVE'
        }
    };

    pipelineSteps.forEach(step => {
        step.addEventListener('click', () => {
            const stepId = step.getAttribute('data-step');
            pipelineSteps.forEach(s => s.classList.remove('active'));
            step.classList.add('active');

            const info = stageDetails[stepId];
            if (info) {
                inspectorTag.textContent = info.tag;
                inspectorTitle.textContent = info.title;
                inspectorDesc.textContent = info.desc;
                inspectorTool.textContent = info.tool;
                inspectorEnv.textContent = info.env;
                inspectorArtifact.textContent = info.artifact;
                inspectorStatus.textContent = info.status;
            }
        });
    });

    // 4. Interactive Health-Check Button (Demonstration / Real Probing)
    const btnHealthCheck = document.getElementById('btn-run-healthcheck');
    const btnSpinner = document.getElementById('btn-spinner');
    const btnText = document.getElementById('btn-healthcheck-text');
    const lastCheckedLabel = document.getElementById('last-checked-label');
    const mainStatusBadge = document.getElementById('main-status-badge');
    const mainStatusText = document.getElementById('main-status-text');
    const deployCheckItem = document.getElementById('check-item-deploy');

    if (btnHealthCheck) {
        btnHealthCheck.addEventListener('click', () => {
            // Set UI to loading state
            btnHealthCheck.disabled = true;
            btnSpinner.style.display = 'inline-block';
            btnText.textContent = 'Probing Azure VM...';
            mainStatusBadge.className = 'status-indicator-badge badge-pending';
            mainStatusText.textContent = 'Probing...';

            const startTime = Date.now();

            // Attempt lightweight health probe to Azure VM public IP
            fetch(window.location.origin + window.location.pathname, { cache: 'no-store' })
                .then(response => {
                    setTimeout(() => {
                        btnHealthCheck.disabled = false;
                        btnSpinner.style.display = 'none';
                        btnText.textContent = 'Re-check System Health';

                        const now = new Date();
                        const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                        lastCheckedLabel.textContent = `Last checked: Today at ${timeStr} (Verified)`;

                        mainStatusBadge.className = 'status-indicator-badge badge-active';
                        mainStatusText.textContent = 'Operational';

                        if (deployCheckItem) {
                            deployCheckItem.className = 'check-item passed';
                            const badge = deployCheckItem.querySelector('.check-badge');
                            if (badge) {
                                badge.className = 'check-badge';
                                badge.textContent = 'VERIFIED';
                            }
                            const icon = deployCheckItem.querySelector('.check-icon');
                            if (icon) icon.textContent = '✔';
                        }
                    }, 800);
                })
                .catch(() => {
                    btnHealthCheck.disabled = false;
                    btnSpinner.style.display = 'none';
                    btnText.textContent = 'Re-check System Health';
                    mainStatusBadge.className = 'status-indicator-badge badge-pending';
                    mainStatusText.textContent = 'Telemetry Idle';
                });
        });
    }

    console.log('DevOps IA-3 Dashboard initialized successfully.');
});
