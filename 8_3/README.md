# Домашнее задание к занятию "`GitLab`" - `Скворцов Денис`

### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` [репозитория c шаблоном решения](https://github.com/netology-code/sys-pattern-homework) к себе в GitHub и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/gitlab-hw или https://github.com/имя-вашего-репозитория/8-03-hw.
   2. Выполните клонирование этого репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите сверху название занятия, ваши фамилию и имя;
      - в каждом задании добавьте решение в требуемом виде — текст, код, скриншоты, ссылка.
      - для корректного добавления скриншотов используйте [инструкцию «Как вставить скриншот в шаблон с решением»](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md);
      - при оформлении используйте возможности языка разметки md. Коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md).
   4. После завершения работы над домашним заданием сделайте коммит `git commit -m "comment"` и отправьте его на GitHub `git push origin`.
   5. Для проверки домашнего задания в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем GitHub.
   6. Любые вопросы по выполнению заданий задавайте в чате учебной группы или в разделе «Вопросы по заданию» в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!

---

### Задание 1

**Что нужно сделать:**

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).   
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

![](gitlab-runner-1.png)
![](gitlab-runner-2.png)
---

### Задание 2

**Что нужно сделать:**

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.
2. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте: 
   
 * файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне; 
 * скриншоты с успешно собранными сборками.
 
![](gitlab-build-1.png)![](gitlab-build-2.png)![](gitlab-build-3.png)![](gitlab-build-4.png)![](gitlab-build-5.png)
```yaml
stages:
  - test
  - test_stte
  - build

jb_1-test:
  stage: test
  image: golang:1.17
  script:
   - cd 8_3 
   - go test .
  tags: 
    - skv_fops39

jb_2-stte:
  stage: test_stte
  image:
    name: sonarsource/sonar-scanner-cli
    entrypoint: [""]
  variables:
  script:
    - cd 8_3
    - sonar-scanner -Dsonar.projectKey=skv_fops39 -Dsonar.sources=. -Dsonar.host.url=http://gitlab.localdomain:9000 -Dsonar.login=sqp_dd57b0623b16333773a265e234b9fe3e0eb04974
  tags: 
    - skv_fops39

jb_build:
  stage: build
  image: docker:latest
  script:
   - cd 8_3
   - docker build .
  tags: 
    - skv_fops39
```


---
## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите лучше разобраться в материале.

---

### Задание 3*

Измените CI так, чтобы:

 - этап сборки запускался сразу, не дожидаясь результатов тестов;
 - тесты запускались только при изменении файлов с расширением *.go.

В качестве ответа добавьте в шаблон с решением файл gitlab-ci.yml своего проекта или вставьте код в соответсвующее поле в шаблоне.
![](gitlab-build-up-1.png)

```yaml
stages:
  - test
  - test_stte
  - build

jb_1-test:
  stage: test
  image: golang:1.17
  script:
   - cd 8_3 
   - go test .
  tags: 
    - skv_fops39
  rules:
    - changes:
        - 8_3/**/*.go

jb_2-stte:
  stage: test_stte
  image:
    name: sonarsource/sonar-scanner-cli
    entrypoint: [""]
  variables:
  script:
    - cd 8_3
    - sonar-scanner -Dsonar.projectKey=skv_fops39 -Dsonar.sources=. -Dsonar.host.url=http://gitlab.localdomain:9000 -Dsonar.login=sqp_dd57b0623b16333773a265e234b9fe3e0eb04974
  tags: 
    - skv_fops39
  rules:
    - changes:
        - 8_3/**/*.go

jb_build:
  stage: build
  image: docker:latest
  script:
   - cd 8_3
   - docker build .
  tags: 
    - skv_fops39
  needs: []
```