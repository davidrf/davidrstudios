## 🛠 Local Development Setup

This project uses **Docker Compose** for local development and containers your entire T3 Stack environment. You do **not** need to install Node.js, pnpm, or any other dependencies globally.

### ✅ Prerequisites

- [Docker](https://www.docker.com/get-started) installed (Docker Desktop or CLI)
- [pnpm](https://pnpm.io/) (optional, for local dev without Docker)
- `.env` file at the project root (see below)

---

### 📁 `.env` Setup

Create a `.env` file in the root of the project with the following variables:

```
DATABASE_URL=file:./dev.db
```

> ❗ **Never commit `.env` files** — this is already in `.gitignore`.

---

### 🚀 Run the app locally (with Docker)

```
docker-compose up --build
```

This will:
- Build the image using `Dockerfile.dev`
- Inject your `.env` values
- Start the app on [http://localhost:3000](http://localhost:3000)

---

### 🧪 Common Commands

| Task                         | Command                        |
|------------------------------|--------------------------------|
| Rebuild after code change    | `docker-compose up --build`   |
| Enter container shell        | `docker-compose run web sh`   |
| Tear down everything         | `docker-compose down`         |

---

### 🤓 Optional: Local dev without Docker

If you prefer to run things directly on your machine:

```
pnpm install
pnpm dev
```

Make sure you have the right Node version (`24.3.0`) and pnpm (`10.13.1`) installed. If you use [`asdf`](https://asdf-vm.com/) or `nvm`, check the `.tool-versions` or `.nvmrc` file.

## 🛠️ Infrastructure Setup with Terraform + AWS

This project uses **Terraform** to manage AWS infrastructure, including the ECR registry that hosts the production Docker image.

---

### 📦 Tools Required

Make sure you have the following installed:
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [aws-vault](https://github.com/99designs/aws-vault)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

---

### 🔐 AWS SSO Setup

See our internal docs for how to configure `~/.aws/config` with SSO.

Be sure to set your AWS profile and sign in:

```bash
export AWS_PROFILE=admin
aws-vault login $AWS_PROFILE
```

---

### 📁 Terraform Commands

Use the provided wrapper script to run Terraform commands with the correct AWS profile and working directory:

#### Example: Initialize

```bash
./infra/tf.sh init -reconfigure
```

#### Example: Plan

```bash
./infra/tf.sh plan
```

#### Example: Apply

```bash
./infra/tf.sh apply -auto-approve
```
