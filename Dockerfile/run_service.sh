docker service rm data-api
docker service create --name data-api \
        --publish published=5019,target=5019 \
        --limit-memory=900M \
        --host  "api-es:10.1.0.5" \
    --host  "vml-2:10.1.0.5" \
        --env BROKER_ADDRESS=10.1.0.5 \
    dev.exactspace.co/data-api-es:r1

