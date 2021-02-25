# RabbitMQ

## 설치

## 사용
1. Management Plugin 접속
```
localhost:15672
guest/guest 
```

## 명령어
1. Server실행
```
$> rabbitmq-server => Fore-ground방식 시작 > 창을 닫으면 중지
$> rabbitmqctl [start|stop] => Back-ground방식 실행/중지
```

# 참조사이트
1. 설명
- [RabbitMQによる非同期処理](https://tech-lab.sios.jp/archives/7902) <== 잘설명됨.
- [CodeZine](https://codezine.jp/article/corner/472)
- [RabbitMQにJavaクライアントからメッセージを送信、受信する](https://symfoware.blog.fc2.com/blog-entry-1487.html)
- [Consumer Acknowledgements and Publisher Confirms](https://www.rabbitmq.com/confirms.html)
- [amqpを使ってRabbitMQのキューを操作する](https://qiita.com/tamikura@github/items/a268afa51c5537ca4fe6) <== ack, nack 관계 알아보다 참고한 사이트
- [Node.jsで習得するRabbitMQによるメッセージキューイング その2 (ACKとpersistent)](https://komari.co.jp/blog/4271/) <== ack, nack 관계 알아보다 참고한 사이트

2. 사용관련
- [[Rabbitmq] 1. 초보를 위한 RabbitMQ 후딱 설치하고 설정하기](http://abh0518.net/tok/?p=384)
- [무작정 시작하기 (1) - 설치 및 실행](https://heodolf.tistory.com/50)

2. 명령어
- [RabbitMQ管理コマンド（rabbitmqctl）使い方](https://qiita.com/tamikura@github/items/5293cda4c0026b2d7022#%E3%82%AD%E3%83%A5%E3%83%BC%E7%A2%BA%E8%AA%8D)