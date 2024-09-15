# Docker FoundationDB

 Docker images for FoundationDB supporting linux/amd64 and linux/arm64.
 Useful for development and testing.

 ## Usage

 ### Docker

```bash
docker run -it -p 4500:4500 celrenheit/foundationdb:7.3.46
```

 ### Docker Compose

```yaml
version: '3.7'

services:
  foundationdb:
    image: celrenheit/foundationdb:7.3.46
    ports:
      - 4500:4500
```

You can also set knobs using environment variables:

```yaml
version: '3.7'

services:
  foundationdb:
    image: celrenheit/foundationdb:7.3.46
    ports:
      - 4500:4500
    environment:
      - FDB_KNOB_min_available_space_ratio=0.001
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
