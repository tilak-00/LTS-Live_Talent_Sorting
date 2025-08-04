FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN test -f /etc/secrets/.env && cp /etc/secrets/.env .env || echo ".env not found at build time"

# Secret file Render provides

RUN pip install python-dotenv

CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000"]
