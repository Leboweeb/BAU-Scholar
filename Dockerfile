# Dockerfile

# The first instruction is what image we want to base our container on
# We Use an official Python runtime as a parent image
FROM python:3.10

# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 
# Allows docker to cache installed dependencies between builds
WORKDIR /app


# Mounts the application code to the image
COPY . /app/

# then installs dependencies
RUN pip install -r /app/requirements.txt
EXPOSE 8000

# runs the production server
CMD ["python","manage.py","runserver", "0.0.0.0:8000"]