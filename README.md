## How to run in Docker environment  

1. Build the image  

    ```docker build -t ltl .```
2. Run inside the container

    ```docker run -it --entrypoint /bin/bash ltl```

3. Run Prolog

    ```swipl /app/start.pl```

## How to exit Docker environment

type ```exit```

