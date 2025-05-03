FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y gcc libmariadb-dev && \
    pip install mariadb tabulate

WORKDIR /db-init

COPY schema.sql .
COPY sample_data.sql .
COPY setup_db.py .

CMD ["python3", "setup_db.py"]