#!/bin/bash
echo "🚀 Деплой клиента начат..."

cd /var/www/client || { echo "❌ Ошибка: папка /var/www/client не найдена!"; exit 1; }

pm2 stop client
git pull origin main || { echo "❌ Ошибка при `git pull`!"; exit 1; }

# Очистка кэша и зависимостей
rm -rf .next
rm -rf node_modules
rm -rf package-lock.json
npm cache clean --force
npm install || { echo "❌ Ошибка при `npm install`!"; exit 1; }

# Очистка кэша еще раз (можно убрать, если не помогает)
npm cache clean --force

# Сборка
npm run build || { echo "❌ Ошибка при `npm run build`!"; exit 1; }


# Перезапуск PM2
pm2 restart client --update-env

echo "✅ Деплой клиента завершен!"
