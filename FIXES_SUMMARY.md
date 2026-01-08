# Виправлення помилок CI/CD

## Проблеми, які були виправлені:

### 1. ✅ Helm не був встановлений у deploy job
**Проблема:** Помилка "Cloning into '/tmp/kbot-..." виникала тому, що Helm не був встановлений перед перевіркою chart.

**Виправлення:** Додано крок встановлення Helm:
```yaml
- name: Install Helm
  uses: azure/setup-helm@v3
  with:
    version: 'latest'
```

### 2. ✅ Форматування os та arch у values.yaml
**Проблема:** Поля `os` та `arch` мали бути в лапках для коректного формату YAML.

**Виправлення:** Оновлено `helm/kbot/values.yaml`:
```yaml
image:
  registry: "ghcr.io"
  repository: "den-vasyliev/kbot"
  tag: "v1.0.0-unknown"
  os: "linux"
  arch: "amd64"
```

### 3. ✅ Оновлення workflow для правильного формату
**Проблема:** Workflow має правильно оновлювати `os` та `arch` у values.yaml.

**Виправлення:** Оновлено команди sed у workflow:
```bash
sed -i 's|^  os:.*|  os: "linux"|' helm/kbot/values.yaml
sed -i 's|^  arch:.*|  arch: "amd64"|' helm/kbot/values.yaml
```

## Формат образу:

Після виправлень образ формується правильно:
- **Tag у values.yaml:** `v1.0.0-{COMMIT_SHA}` (наприклад: `v1.0.0-106879e`)
- **OS:** `linux`
- **Arch:** `amd64`
- **Фінальний образ:** `ghcr.io/den-vasyliev/kbot:v1.0.0-{COMMIT_SHA}-linux-amd64`

## Перевірка:

1. Перевірте, що workflow виконується успішно
2. Перевірте, що `os` та `arch` правильно оновлюються у values.yaml
3. Перевірте, що образ публікується з правильним тегом

## Посилання:

- GitHub Actions: https://github.com/Sadko-Vadym/tg-bot/actions
- Останній коміт: `84ae050`

