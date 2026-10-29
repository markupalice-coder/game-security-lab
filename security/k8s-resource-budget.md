
# Kubernetes Resource Budget: game-api



## Workload

game-api



## Current Resource Settings

- CPU request: 100m

- CPU limit: 500m

- Memory request: 128Mi

- Memory limit: 512Mi



## Rationale

The game-api service is currently a lightweight Express API used for health checks and future game-service logic. These values are intentionally conservative for a learning environment.



## Operational Rule

Requests should represent normal expected usage. Limits should prevent one container from exhausting node resources.



## Future Tuning Signal

Increase or reduce these values only after observing real workload metrics from load tests or runtime telemetry.

