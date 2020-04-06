gcloud compute ssh instance-identity

protoc \
    --include_imports \
    --include_source_info \
    protos/helloworld.proto \
    --descriptor_set_out api.pb
    
gcloud docker -- push gcr.io/grpctest1/endpoints-example:1.0

node client.js -h  35.196.167.206:50051 -k AIzaSyBwWblozlwOvKsngh3y_Fa9IR9XaZyl6JY
gcloud endpoints services deploy api.pb api_config.yaml

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
