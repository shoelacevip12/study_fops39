import pika
from settings import URI

params = pika.URLParameters(URI)
conn = pika.BlockingConnection(params)
channel = conn.channel()

channel.queue_declare(
    queue='skv_dv_FOPS-39',
    durable=True,
    arguments={'x-queue-type': 'quorum'}
)

if __name__ == "__main__":

    count = 0

    while True:
        channel.basic_publish(
            exchange="ex_p_skv_dv_FOPS-39",
            routing_key="rk_skv_dv_FOPS-39",
            body=f"Ya v shoke, no priyatnom! - {count}",
        )
        count += 1
 