# Use official Python 3.9 base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Upgrade pip
RUN pip install --upgrade pip

# Install dependencies
RUN pip install -r requirements.txt

# Expose the port Render uses
EXPOSE 8000

# Run Django using gunicorn
CMD ["gunicorn", "resume_ranker.wsgi:application", "--bind", "0.0.0.0:8000"]
