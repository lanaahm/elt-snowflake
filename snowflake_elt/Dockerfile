FROM python:3.10-slim
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get install -y libpq-dev build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./snowflake_elt/requirements.txt /app
RUN pip3 install -r requirements.txt

COPY ./snowflake_elt/main.py /app
COPY ./snowflake_elt/config.py /app

CMD ["python", "main.py"]
