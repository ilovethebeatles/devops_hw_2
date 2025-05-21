FROM python:3.9-slim
WORKDIR /app

COPY app/app.py app/requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p logs config

COPY app/config.yaml.template config/config.yaml

EXPOSE 5000
CMD ["python", "app.py"]

