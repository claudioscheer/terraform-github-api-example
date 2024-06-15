FROM public.ecr.aws/docker/library/python:3.11-slim

WORKDIR /app
ADD ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY ./src /app

ENV FLASK_APP=main.py
EXPOSE 3000

CMD ["python", "-m", "flask", "run", "--port=3000", "--host=0.0.0.0"]
