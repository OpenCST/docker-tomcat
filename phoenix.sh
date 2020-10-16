#!/usr/bin/env sh

export CP=$CATALINA_HOME/lib/*
export CP=$CP:$CATALINA_HOME/webapps/$CONTEXT_NAME/WEB-INF/lib/*

java    -classpath $CP \
        -Dphoenix.config.location=$PHOENIX_CONFIG_LOCATION/$CONTEXT_NAME \
        -Dphoenix.context.paths=classpath*:META-INF/context/phoenix-data-context.xml \
        it.phoenix.core.Phoenix

