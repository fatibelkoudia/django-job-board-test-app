FROM python:3.11

# create app directory
#RUN mkdir /app
WORKDIR /app

# upgrade pip
RUN pip install --upgrade pip

# copy requirements file
COPY requirements.txt .


RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000"]