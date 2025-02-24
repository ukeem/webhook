const express = require("express");
const crypto = require("crypto");
const { exec } = require("child_process");

const app = express();
app.use(express.json()); // Увеличенный лимит для больших payload'ов

const SECRET = "legal"; // Замени на свой секрет

// Функция проверки подписи
function verifySignature(req, res, next) {
	const signature = req.headers["x-hub-signature-256"];
	if (!signature) {
		return res.status(401).send("Missing signature");
	}

	const hmac = crypto.createHmac("sha256", SECRET);
	const digest = "sha256=" + hmac.update(JSON.stringify(req.body)).digest("hex");

	if (signature !== digest) {
		return res.status(401).send("Invalid signature");
	}
	next();
}

// Функция деплоя
function deploy(script, res) {
	exec(`sh ${script}`, (error, stdout, stderr) => {
		if (error) {
			console.error(`Ошибка: ${error.message}`);
			return res.status(500).send("Ошибка деплоя");
		}
		console.log(`stdout: ${stdout}`);
		if (stderr) console.error(`stderr: ${stderr}`);
		res.status(200).send("Деплой запущен");
	});
}

// Вебхук для сервера
app.post("/whserver", verifySignature, (req, res) => {
	console.log("🚀 Получен вебхук для сервера...");
	deploy("./server.sh", res);
});

// Вебхук для клиента
app.post("/whclient", verifySignature, (req, res) => {
	console.log("🚀 Получен вебхук для клиента...");
	deploy("./client.sh", res);
});

// Запуск сервера
const PORT = 3001;
app.listen(PORT, () => console.log(`Webhook запущен на порту ${PORT}`));
