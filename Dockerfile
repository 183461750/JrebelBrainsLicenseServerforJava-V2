FROM maven:3.8.1-amazoncorretto-8 AS builder

WORKDIR /app


RUN tee /usr/share/maven/conf/settings.xml <<-'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">
  <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF

ADD . .

RUN mvn clean package -Dmaven.test.skip=true



FROM openjdk:8u342-oracle

WORKDIR /app

COPY --from=builder /app/target/*.jar ./JrebelBrains.jar

ENV PORT 8081

CMD java -jar ./JrebelBrains.jar -p $PORT

