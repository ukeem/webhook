#!/bin/bash
echo "🚀 Деплой клиента начат..."

cd /var/www/server
git pull origin main
npm install
npm run build
pm2 restart server

echo "✅ Деплой клиента завершен!"
