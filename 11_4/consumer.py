#!/usr/bin/env python
# coding=utf-8
import pika
from settings import URI

connection = pika.BlockingConnection(pika.URLParameters(URI))
channel = connection.channel()
channel.queue_declare(
    queue='skv_dv_FOPS-39',
    durable=True,
    arguments={'x-queue-type': 'quorum'}
)

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(
    queue='skv_dv_FOPS-39',
    on_message_callback=callback,
    auto_ack=True
)
channel.start_consuming()