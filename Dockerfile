FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip config set global.retries 10 && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy Render's secret .env if available
RUN test -f /etc/secrets/.env && cp /etc/secrets/.env .env || echo ".env not found at build time"

# Just in case python-dotenv isn't in requirements.txt
RUN pip install python-dotenv

# Django setup
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate --noinput

# Expose port (Render dynamically sets it, but this is okay)
EXPOSE 8000

# Start Gunicorn with environment port support
CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000"]
