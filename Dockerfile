# The Google App Engine Flexible Environment base Docker image can
# also be used on Google Container Engine, or any other Docker host.
# This image is based on Debian Jessie and includes nodejs and npm
# installed from nodejs.org. The source is located in
# https://github.com/GoogleCloudPlatform/nodejs-docker
FROM gcr.io/google_appengine/nodejs

ADD . /app
WORKDIR /app

RUN npm install
ENTRYPOINT []

EXPOSE 50051
CMD ["npm", "start"]

# docker build  -t gcr.io/grpctest1/endpoints-example:1.0 -f Dockerfile .
# gcloud docker -- push gcr.io/grpctest1/endpoints-example:1.0

# node client.js -h  35.196.167.206:50051 -k AIzaSyBwWblozlwOvKsngh3y_Fa9IR9XaZyl6JY
# gcloud endpoints services deploy api.pb api_config.yaml

sudo docker run --detach --name=helloworld gcr.io/grpctest1/endpoints-example:1.0

sudo docker run \
    --detach \
    --name=esp \
    --publish=80:9000 \
    --link=helloworld:helloworld \
    gcr.io/endpoints-release/endpoints-runtime:1 \
    --service=hellogrpc1.endpoints.grpctest1.cloud.goog\
    --rollout_strategy=managed \
    --http2_port=9000 \
    --backend=grpc://helloworld:50051