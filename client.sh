#!/bin/bash
echo "🚀 Деплой клиента начат..."

cd /var/www/client
git pull origin main
npm install
npm run build
pm2 restart client

echo "✅ Деплой клиента завершен!"
