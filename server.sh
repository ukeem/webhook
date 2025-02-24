#!/bin/bash
echo "🚀 Деплой сервера начат..."

cd /var/www/server
pm2 stop server
git pull origin main
npm cache clean --force
npm install
npm run build
pm2 restart server

echo "✅ Деплой сервера завершен!"
