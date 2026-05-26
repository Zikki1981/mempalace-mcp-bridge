# MemPalace MCP Bridge
# Wraps mempalace (stdio MCP) in mcp-proxy (SSE/HTTP) for remote access.
#
# Endpoint exposed: http://0.0.0.0:8765/sse
# Persistent data:  /data  (mount a volume here)

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    MEMPALACE_PALACE_PATH=/data/palace \
    HF_HOME=/data/hf-cache

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
 && pip install mempalace mcp-proxy

RUN mkdir -p /data

VOLUME ["/data"]
EXPOSE 8765

HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=5 \
  CMD curl -fsS -m 2 http://localhost:8765/sse || exit 1

ENTRYPOINT ["mcp-proxy", "--sse-port", "8765", "--sse-host", "0.0.0.0", "--pass-environment", "--", "mempalace-mcp"]
