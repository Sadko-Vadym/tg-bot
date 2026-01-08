# 🎯 Фінальні інструкції

## ✅ Що вже виконано:

1. ✅ Створено повний CI/CD pipeline
2. ✅ Всі файли закомічено та запушено до GitHub
3. ✅ Гілка `develop` створена та активна
4. ✅ Workflow налаштовано для автоматичного запуску

## 🔧 Що потрібно зробити ЗАРАЗ:

### Крок 1: Додати секрет GHCR_TOKEN

**Відкрийте в браузері:** https://github.com/Sadko-Vadym/tg-bot/settings/secrets/actions

1. Натисніть **"New repository secret"**
2. **Name:** `GHCR_TOKEN`
3. **Value:** Вставте ваш токен (див. нижче)
4. Натисніть **"Add secret"**

**Ваш токен:**
```
[Вставте ваш Personal Access Token тут]
```

### Крок 2: Запустити workflow

Після додавання секрету виконайте в PowerShell:

```powershell
cd "c:\Users\sadko\Documents\TG BOT"
.\trigger-workflow.ps1
```

Або вручну:
```powershell
git commit --allow-empty -m "trigger: CI/CD after secret setup"
git push origin develop
```

### Крок 3: Перевірити результат

1. Перейдіть до: https://github.com/Sadko-Vadym/tg-bot/actions
2. Знайдіть останній workflow run
3. Дочекайтеся завершення (зазвичай 2-5 хвилин)
4. Перевірте, що він завершився успішно ✅

### Крок 4: Отримати посилання на образ

Після успішного виконання:

1. Відкрийте деталі workflow
2. Знайдіть крок **"Output image reference"**
3. Скопіюйте посилання на образ

**Формат образу:**
```
ghcr.io/den-vasyliev/kbot:v1.0.0-{COMMIT_SHA}-linux-amd64
```

**Приклад:**
```
ghcr.io/den-vasyliev/kbot:v1.0.0-2f85c92-linux-amd64
```

## 📊 Перевірка статусу

Запустіть скрипт для перевірки:
```powershell
.\check-and-trigger.ps1
```

## 🔗 Корисні посилання:

- **GitHub Actions:** https://github.com/Sadko-Vadym/tg-bot/actions
- **Secrets:** https://github.com/Sadko-Vadym/tg-bot/settings/secrets/actions
- **Repository:** https://github.com/Sadko-Vadym/tg-bot
- **Container Registry:** https://github.com/Sadko-Vadym/tg-bot/pkgs/container/kbot

## ❓ Проблеми?

Якщо workflow не запускається або падає:

1. Перевірте, що секрет `GHCR_TOKEN` додано правильно
2. Перевірте права токену (потрібні: `repo`, `write:packages`, `read:packages`)
3. Перевірте логи workflow для деталей помилки

## 🎉 Готово!

Після успішного виконання workflow ваш образ буде доступний у GitHub Container Registry і готовий до розгортання в Kubernetes через ArgoCD.

