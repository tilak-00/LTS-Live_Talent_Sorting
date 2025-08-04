FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip config set global.retries 10 && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Optional: copy secret .env file if it exists in Render secret files
RUN test -f /etc/secrets/.env && cp /etc/secrets/.env .env || echo ".env not found at build time"

# Install dotenv (in case it's not in requirements.txt)
RUN pip install python-dotenv

# Set environment variables for Gunicorn to bind on 0.0.0.0:8000
EXPOSE 8000

# Start Gunicorn server
CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000", "--timeout", "90"]
