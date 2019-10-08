# Purpose
Sample workload

Exposes the following
| Path      | Response                              |
|-----------|---------------------------------------|
| /         | Echos a version based on the VERSION file contents at time of image build |
| liveness  | Liveness probe, just echos some json  |
| readiness | Readiness probe, just echos some json |



# Docker image
Will build an image based on the current user
```
make build-image
``` 
