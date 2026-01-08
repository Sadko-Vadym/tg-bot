# 🚀 Швидкий старт CI/CD

## ✅ Що вже зроблено:

1. ✅ Створено всі необхідні файли (Dockerfile, Makefile, Helm chart, GitHub Actions)
2. ✅ Закомічено та запушено до GitHub
3. ✅ Створено гілку `develop`
4. ✅ Відкрито сторінку для додавання секрету

## 🔧 Що потрібно зробити ЗАРАЗ:

### Крок 1: Додати секрет GHCR_TOKEN

**Відкрийте в браузері:** https://github.com/Sadko-Vadym/tg-bot/settings/secrets/actions

1. Натисніть **"New repository secret"**
2. **Name:** `GHCR_TOKEN`
3. **Value:** [Ваш Personal Access Token - див. інструкції вище]
4. Натисніть **"Add secret"**

### Крок 2: Запустити workflow

Після додавання секрету виконайте:

```powershell
cd "c:\Users\sadko\Documents\TG BOT"
git commit --allow-empty -m "trigger: CI/CD after secret setup"
git push origin develop
```

Або запустіть скрипт:
```powershell
.\trigger-workflow.ps1
```

### Крок 3: Перевірити результат

1. Перейдіть до: https://github.com/Sadko-Vadym/tg-bot/actions
2. Знайдіть останній workflow run
3. Перевірте, що він завершився успішно (зелена галочка)
4. Відкрийте деталі workflow
5. Знайдіть крок "Output image reference"
6. Скопіюйте посилання на образ

## 📋 Формат образу:

Після успішного виконання образ буде доступний як:
```
ghcr.io/den-vasyliev/kbot:v1.0.0-{COMMIT_SHA}-linux-amd64
```

Приклад:
```
ghcr.io/den-vasyliev/kbot:v1.0.0-6944d3a-linux-amd64
```

## 🔍 Перевірка статусу:

Запустіть скрипт для перевірки:
```powershell
.\check-and-trigger.ps1
```

## ❓ Проблеми?

Якщо workflow не запускається або падає з помилкою:

1. Перевірте, що секрет `GHCR_TOKEN` додано правильно
2. Перевірте права токену (потрібні: `repo`, `write:packages`, `read:packages`)
3. Перевірте логи workflow: https://github.com/Sadko-Vadym/tg-bot/actions

## 📞 Допомога:

- GitHub Actions: https://github.com/Sadko-Vadym/tg-bot/actions
- Secrets: https://github.com/Sadko-Vadym/tg-bot/settings/secrets/actions
- Repository: https://github.com/Sadko-Vadym/tg-bot

