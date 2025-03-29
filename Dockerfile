# Build stage
FROM python:3.9-slim-bullseye as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.9-slim-bullseye

# Install Chrome dependencies (minimal set)
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Environment variables
ENV PATH="/root/.local/bin:${PATH}"
ENV CHROMIUM_FLAGS="--no-sandbox --headless=new --disable-dev-shm-usage"
ENV PYTHONUNBUFFERED=1

# Non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 5000
CMD ["python", "app/index.py"]


### ORIGINAL DOCKERFILE ###
# FROM python:3.9.18-alpine

# # Generic labels
# LABEL maintainer="Arian Mollik Wasi <arianmollik323@gmail.com>"
# LABEL version="0.3.4"
# LABEL description="My own custom 12ft.io replacement"
# LABEL url="https://github.com/wasi-master/13ft/"
# LABEL documentation="https://github.com/wasi-master/13ft/blob/main/README.md"

# # OCI compliant labels
# LABEL org.opencontainers.image.source="https://github.com/wasi-master/13ft"
# LABEL org.opencontainers.image.authors="Arian Mollik Wasi"
# LABEL org.opencontainers.image.created="2023-10-31T22:53:00Z"
# LABEL org.opencontainers.image.version="0.3.4"
# LABEL org.opencontainers.image.url="https://github.com/wasi-master/13ft/"
# LABEL org.opencontainers.image.source="https://github.com/wasi-master/13ft/"
# LABEL org.opencontainers.image.description="My own custom 12ft.io replacement"
# LABEL org.opencontainers.image.documentation="https://github.com/wasi-master/13ft/blob/main/README.md"
# LABEL org.opencontainers.image.licenses=MIT

# COPY . .
# RUN pip install -r requirements.txt
# WORKDIR /app
# EXPOSE 5000
# ENTRYPOINT [ "python" ]
# CMD [ "portable.py" ] 
### END OF ORIGINAL DOCKERFILE ###