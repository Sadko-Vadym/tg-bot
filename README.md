# Telegram Bot (kbot)

A simple Telegram bot built with Golang, using [Cobra](https://github.com/spf13/cobra) for CLI and [Telebot](https://github.com/tucnak/telebot) for Telegram Bot API integration.

## Features

- Handle text messages from users
- Respond to commands: `/hello`, `/help`, `/start`
- Echo user messages with helpful responses

## Prerequisites

- Go 1.21 or higher
- Telegram Bot Token (obtained from [@BotFather](https://t.me/BotFather))

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Sadko-Vadym/tg-bot.git
cd tg-bot
```

2. Install dependencies:
```bash
go mod download
```

3. Set up your Telegram Bot Token:
   - Create a bot using [@BotFather](https://t.me/BotFather) in Telegram
   - Get your bot token
   - Set it as an environment variable:
   
   **Windows (PowerShell):**
   ```powershell
   $env:TELE_TOKEN="your_bot_token_here"
   ```
   
   **Linux/Mac:**
   ```bash
   export TELE_TOKEN="your_bot_token_here"
   ```

## Usage

Run the bot:
```bash
go run main.go
```

Or build and run:
```bash
go build -o kbot
./kbot
```

## Bot Commands

Once the bot is running, you can interact with it in Telegram:

- `/start` - Start the bot and see welcome message
- `/hello` - Greet the bot
- `/help` - Show available commands
- Any other text - The bot will echo your message

## Bot Link

After creating your bot with BotFather, you can access it at:
```
t.me/your_bot_name_bot
```

Replace `your_bot_name` with the actual name you gave your bot.

## Project Structure

```
tg-bot/
├── cmd/
│   └── root.go           # Cobra root command and bot handlers
├── helm/
│   └── kbot/             # Helm chart for Kubernetes deployment
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── .github/
│   └── workflows/
│       └── ci-cd.yml     # GitHub Actions CI/CD workflow
├── main.go               # Application entry point
├── go.mod                # Go module dependencies
├── Dockerfile            # Container image definition
├── Makefile              # Build automation
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

## Technologies Used

- [Golang](https://golang.org/) - Programming language
- [Cobra](https://github.com/spf13/cobra) - CLI framework
- [Telebot](https://github.com/tucnak/telebot) - Telegram Bot API wrapper
- [Docker](https://www.docker.com/) - Containerization
- [Kubernetes](https://kubernetes.io/) - Container orchestration
- [Helm](https://helm.sh/) - Kubernetes package manager
- [ArgoCD](https://argoproj.github.io/cd/) - GitOps continuous delivery
- [GitHub Actions](https://github.com/features/actions) - CI/CD automation

## Development

### Adding New Handlers

To add new message handlers, modify the `Handle` function in `cmd/root.go`:

```go
kbot.Handle(telebot.OnText, func(m telebot.Context) error {
    // Your handler logic here
    return m.Send("Response message")
})
```

### Building

Build the binary:
```bash
go build -o kbot
```

## Troubleshooting

- **"TELE_TOKEN is not set"**: Make sure you've set the `TELE_TOKEN` environment variable
- **Connection errors**: Check your internet connection and ensure the bot token is correct
- **Bot not responding**: Verify the bot is running and the token is valid

## License

This project is open source and available for educational purposes.

## CI/CD Pipeline

This project includes a fully automated CI/CD pipeline using GitHub Actions, Docker, Helm, and ArgoCD.

### Workflow Overview

The CI/CD pipeline is triggered automatically on every push to the `develop` branch. The workflow includes:

1. **Build & Test**: Compiles the Go application and runs tests
2. **Container Build**: Creates a Docker image for linux/amd64 platform
3. **Image Push**: Publishes the image to GitHub Container Registry (ghcr.io)
4. **Helm Update**: Updates Helm chart values with the new image tag
5. **ArgoCD Sync**: ArgoCD automatically deploys the updated configuration to Kubernetes

### CI/CD Workflow Diagram

```mermaid
graph TB
    A[Push to develop branch] --> B[GitHub Actions Triggered]
    B --> C[Checkout Code]
    C --> D[Set up Go Environment]
    D --> E[Get Git Commit SHA]
    E --> F[Run Tests]
    F --> G{Tests Pass?}
    G -->|No| Z[Pipeline Failed]
    G -->|Yes| H[Set up Docker Buildx]
    H --> I[Login to ghcr.io]
    I --> J[Build Docker Image]
    J --> K[Tag Image: v1.0.0-{SHA}-linux-amd64]
    K --> L[Push to ghcr.io]
    L --> M[Update Helm values.yaml]
    M --> N[Commit Helm Changes]
    N --> O[Push to Repository]
    O --> P[ArgoCD Detects Changes]
    P --> Q[ArgoCD Syncs Application]
    Q --> R[Deploy to Kubernetes]
    R --> S[Bot Running in K8s]
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style F fill:#ffe1f5
    style L fill:#e1ffe1
    style Q fill:#f5e1ff
    style S fill:#e1ffe1
```

### Image Format

The container image follows this naming convention:
```
ghcr.io/den-vasyliev/kbot:v1.0.0-{GIT_COMMIT_SHA}-linux-amd64
```

Example:
```
ghcr.io/den-vasyliev/kbot:v1.0.0-106879e-linux-amd64
```

### Makefile Commands

The project includes a Makefile for local development and build automation:

```bash
# Build the binary
make build

# Build Docker image
make docker-build

# Push Docker image
make docker-push

# Build and push
make docker-build-push

# Update Helm values
make update-helm-values

# Run tests
make test

# Clean build artifacts
make clean

# Show help
make help
```

### Helm Chart

The Helm chart is located in `helm/kbot/` and includes:

- **Deployment**: Kubernetes deployment configuration
- **Service**: Service definition for the bot
- **Secret**: Secret for Telegram bot token
- **ServiceAccount**: Service account for the pod
- **HPA**: Horizontal Pod Autoscaler (optional)

To deploy manually:

```bash
# Install the chart
helm install kbot ./helm/kbot

# Upgrade the chart
helm upgrade kbot ./helm/kbot

# Uninstall
helm uninstall kbot
```

### GitHub Secrets Setup

The workflow uses GitHub Secrets for authentication. You can use either:

1. **Default GITHUB_TOKEN** (automatically provided) - Works for most cases
2. **Custom Personal Access Token (PAT)** - Required if you need extended permissions

To set up a custom PAT:

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with these permissions:
   - `repo` (Full control of private repositories)
   - `write:packages` (Upload packages to GitHub Package Registry)
   - `read:packages` (Download packages from GitHub Package Registry)
3. Copy the token
4. Go to your repository → Settings → Secrets and variables → Actions
5. Click "New repository secret"
6. Name: `GHCR_TOKEN`
7. Value: Paste your token
8. Click "Add secret"

The workflow will automatically use `GHCR_TOKEN` if available, otherwise fall back to `GITHUB_TOKEN`.

**⚠️ Security Note**: Never commit tokens directly to the repository. Always use GitHub Secrets.

### ArgoCD Configuration

ArgoCD watches the repository and automatically syncs changes when:

1. Helm values.yaml is updated with a new image tag
2. ArgoCD Application is configured to watch the repository
3. Auto-sync is enabled in ArgoCD

To configure ArgoCD Application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kbot
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Sadko-Vadym/tg-bot.git
    targetRevision: develop
    path: helm/kbot
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Environment Variables

The bot requires the following environment variable:

- `TELE_TOKEN`: Telegram bot token (set as Kubernetes Secret)

### Kubernetes Deployment

The bot is deployed as a Kubernetes Deployment with:

- **Replicas**: Configurable via Helm values
- **Resources**: CPU and memory limits/requests
- **Security**: Non-root user, read-only filesystem (optional)
- **Scaling**: Horizontal Pod Autoscaler support

## Contributing

Feel free to submit issues and enhancement requests!

