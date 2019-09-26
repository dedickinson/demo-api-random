FROM python:3.7-alpine as builder

RUN mkdir /build
WORKDIR /build
RUN pip install pipenv
COPY Pipfile .
COPY Pipfile.lock .
RUN pipenv lock -r > requirements.txt


FROM python:3.7-alpine

COPY --from=builder /build/requirements.txt .
RUN pip install -r requirements.txt
RUN mkdir /app
WORKDIR /app
COPY app.py ./
EXPOSE 5000
CMD [ "flask", "run", "--host", "0.0.0.0" ]
