FROM python:3.7-alpine

COPY requirements.txt ./

RUN pip install -r requirements.txt

RUN mkdir /app

WORKDIR /app

COPY app.py ./

EXPOSE 5000

CMD [ "flask", "run", "--host", "0.0.0.0" ]
