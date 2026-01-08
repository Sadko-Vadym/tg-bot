# Налаштування CI/CD Pipeline

## ✅ Виконано автоматично

- ✅ Створено Makefile для автоматизації збірки
- ✅ Створено Dockerfile для контейнеризації
- ✅ Створено Helm chart з повною конфігурацією
- ✅ Створено GitHub Actions workflow
- ✅ Додано графічну схему workflow до README
- ✅ Закомічено всі зміни
- ✅ Створено гілку `develop`
- ✅ Зроблено push до GitHub

## 🔧 Потрібно налаштувати вручну

### 1. Додати GitHub Secret для токену

1. Перейдіть на GitHub: https://github.com/Sadko-Vadym/tg-bot
2. Settings → Secrets and variables → Actions
3. Натисніть "New repository secret"
4. **Name**: `GHCR_TOKEN`
5. **Value**: Вставте ваш Personal Access Token (не додавайте токен у файли репозиторію!)
6. Натисніть "Add secret"

⚠️ **Важливо**: 
- Ніколи не комітьте токени у репозиторій
- Використовуйте тільки GitHub Secrets
- Переконайтеся, що токен має права:
- `repo` (Full control of private repositories)
- `write:packages` (Upload packages)
- `read:packages` (Download packages)

### 2. Перевірити налаштування workflow

Workflow автоматично запуститься при push до гілки `develop`. 

Щоб запустити тестовий запуск:
1. Зробіть будь-яку зміну у коді
2. Закомітьте та зробіть push до `develop`:
   ```bash
   git add .
   git commit -m "test: trigger CI/CD pipeline"
   git push origin develop
   ```
3. Перевірте статус workflow: https://github.com/Sadko-Vadym/tg-bot/actions

### 3. Налаштувати ArgoCD (опціонально)

Якщо у вас є доступ до Kubernetes кластера з ArgoCD:

1. Створіть ArgoCD Application:
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

2. Створіть Secret з Telegram токеном:
   ```bash
   kubectl create secret generic kbot-secret \
     --from-literal=tele-token=YOUR_TELEGRAM_BOT_TOKEN \
     -n default
   ```

3. Оновіть `helm/kbot/values.yaml` з вашим токеном або використайте Secret

### 4. Перевірити результат

Після успішного виконання workflow:

1. Перевірте образ у GitHub Container Registry:
   - https://github.com/Sadko-Vadym/tg-bot/pkgs/container/kbot

2. Формат образу буде:
   ```
   ghcr.io/den-vasyliev/kbot:v1.0.0-{GIT_COMMIT_SHA}-linux-amd64
   ```

3. Приклад:
   ```
   ghcr.io/den-vasyliev/kbot:v1.0.0-106879e-linux-amd64
   ```

## 📋 Чеклист

- [ ] Додано секрет `GHCR_TOKEN` в GitHub
- [ ] Перевірено права токену
- [ ] Зроблено тестовий push до `develop`
- [ ] Перевірено виконання workflow
- [ ] Перевірено публікацію образу в ghcr.io
- [ ] (Опціонально) Налаштовано ArgoCD
- [ ] (Опціонально) Створено Kubernetes Secret з Telegram токеном

## 🚀 Наступні кроки

1. Додайте секрет `GHCR_TOKEN` (крок 1 вище)
2. Зробіть тестовий push до `develop`
3. Перевірте результат у GitHub Actions
4. Скопіюйте посилання на образ з виводу workflow

## 📞 Допомога

Якщо виникли проблеми:
- Перевірте логи GitHub Actions
- Переконайтеся, що токен має правильні права
- Перевірте, що гілка `develop` існує та має останні зміни

