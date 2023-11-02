FROM dev.exactspace.co/python3.11-base-es-flask:r1
RUN mkdir -p /src
COPY main /src/
COPY index.py /src/
RUN chmod +x /src/main
RUN chmod +x /src/index.py
EXPOSE 5019
WORKDIR /src
ENTRYPOINT ["./main"]

