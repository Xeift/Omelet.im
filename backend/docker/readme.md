# Build Docker Image
uncomment all lines in `config/config.js`

# Run
```
docker run -p 3000:3000 --env-file config/.env -d omelet-dot-im-server
```