FROM python:3.8-slim

WORKDIR /app
ENV PYTHONUNBUFFERED=1
ENV PORT=5001

# Install system deps needed for scientific wheels
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc g++ libatlas-base-dev libgfortran5 && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for caching
COPY requirements.txt /app/requirements.txt

RUN pip install --upgrade pip wheel setuptools
RUN pip install -r /app/requirements.txt

# Copy the rest of the app
COPY . /app

EXPOSE 5001

# Use same command as Procfile; Gunicorn will bind to PORT
CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:5001", "--workers", "2"]