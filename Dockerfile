FROM python:3.10-slim-buster

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app/src"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    # install -y iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
COPY wait-for-it.sh /wait-for-it.sh
RUN pip install -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["/wait-for-it.sh", "postgres:5432", "--", "bash", "-c", "python manage.py collectstatic --noinput && gunicorn --bind 0.0.0.0:8000 --workers 3 deploy.wsgi:application"]
