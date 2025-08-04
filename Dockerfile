# Use official Python 3.9 image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Start your app (adjust if needed)
CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000"]

