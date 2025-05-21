# Домашнее задание 1
1. Запустить Minicube
minikube start
kubectl get nodes

2. Собрать докер-образ, передать его в minikube
docker build -t custom-app:latest .

3. Запустить скрипт
chmod +x deploy.sh
./deploy.sh

4. Пробросить порты
kubectl port-forward svc/custom-app-service 8080:80

5. Проверить работу приложения
curl http://localhost:8080/              
curl http://localhost:8080/status        
curl -X POST http://localhost:8080/log \
     -H "Content-Type: application/json" \
     -d '{"message":"Some logs"}'
curl http://localhost:8080/logs          
