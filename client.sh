#!/bin/bash
echo "🚀 Деплой клиента начат..."

cd /var/www/client
pm2 stop client
git pull origin main
npm cache clean --force
npm install
npm run build
pm2 restart client

echo "✅ Деплой клиента завершен!"
