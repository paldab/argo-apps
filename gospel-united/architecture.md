# Architecture Diagram

## Current Architecture
```mermaid
graph TD
    subgraph Services
        Clipchooser
        VideoAPI
        Instauploader
    end

    subgraph Data
        MySQL
        Dropbox
        Instagram
    end

    Clipchooser -- "reads/writes" --> MySQL
    VideoAPI -- "reads/writes" --> MySQL
    VideoAPI -- "stores/retrieves" --> Dropbox
    Instauploader -- "stores/retrieves" --> Dropbox
    Instauploader -- "uploads" --> Instagram
```

## Purposed Architecture
```mermaid
graph TD
    subgraph Services
        Cron-Clipchooser
        VideoAPI
        Cron-Insta-uploader
    end

    subgraph Data
        local-MySQL
        NFS
        Instagram
    end

    Cron-Clipchooser -- "reads/writes" --> local-MySQL
    VideoAPI -- "reads/writes" --> local-MySQL
    VideoAPI -- "stores/retrieves" --> NFS
    Cron-Insta-uploader -- "stores/retrieves" --> NFS
    Cron-Insta-uploader -- "uploads" --> Instagram
```

### TODO
1. Fix local mysql installation in helm
2. Fix NFS or other filesystem in cluster
3. Rebuild app so it connects to filesystem
