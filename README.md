# mempalace-mcp-bridge

Image Docker qui wrap [MemPalace](https://github.com/MemPalace/mempalace) (MCP stdio) dans [mcp-proxy](https://github.com/sparfenyuk/mcp-proxy) pour exposer un endpoint **SSE/HTTP** accessible a distance.

Image publiee : `zikki1981/mempalace-mcp-bridge:latest`

## Usage

```bash
docker run -d \
  --name mempalace \
  -p 8765:8765 \
  -v mempalace-data:/data \
  zikki1981/mempalace-mcp-bridge:latest
```

Endpoint SSE : `http://localhost:8765/sse`

## Volumes

| Path | Contenu |
|------|---------|
| `/data` | Palace (SQLite + ChromaDB) + cache HuggingFace |

## Variables d'environnement

| Variable | Defaut | Description |
|----------|--------|-------------|
| `MEMPALACE_PALACE_PATH` | `/data/palace` | Path du palace SQLite + ChromaDB |
| `HF_HOME` | `/data/hf-cache` | Cache HuggingFace (modele embedding) |
| `MEMPALACE_EMBEDDING_MODEL` | `embeddinggemma-300m` | Modele d'embeddings |
| `MEMPALACE_EMBEDDING_DEVICE` | `cpu` | `cpu` / `cuda` / `mps` |

## Integration Claude Code

```json
{
  "mcpServers": {
    "mempalace": {
      "type": "sse",
      "url": "http://your-host:8765/sse"
    }
  }
}
```

## Build local

```bash
docker build -t mempalace-mcp-bridge .
```

## CI/CD

GitHub Actions builde et pousse `zikki1981/mempalace-mcp-bridge:latest` (+ tag par SHA) sur Docker Hub a chaque push sur `main`.

Secret requis sur le repo : `DOCKER_TOKEN` (PAT Docker Hub).
