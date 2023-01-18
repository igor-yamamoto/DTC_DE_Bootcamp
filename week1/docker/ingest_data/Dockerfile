FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2 python-dotenv

WORKDIR /app
COPY ingest_data.py ingest_data.py 
COPY docker.env .env

ENTRYPOINT [ "python", "ingest_data.py" ]