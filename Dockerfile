# Dockerfile

# The first instruction is what image we want to base our container on
# We Use an official Python runtime as a parent image
FROM python:3.10-slim-bookworm

# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 
# Allows docker to cache installed dependencies between builds
WORKDIR /app


# Mounts the application code to the image
COPY . /app/

# then installs dependencies
RUN apt update \
    && apt upgrade -y \
    && apt install -y gcc default-libmysqlclient-dev pkg-config
RUN pip install -r /app/requirements.txt
RUN playwright install --with-deps firefox

EXPOSE ${PORT:-80}

# runs the production server
CMD ["python","manage.py","runserver", "0.0.0.0:${PORT:-80}"]