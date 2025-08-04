# Use Python 3.9 base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy all project files
COPY . /app/

# Expose the port Render uses
EXPOSE 8000

# Start the app using Gunicorn
CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000"]
