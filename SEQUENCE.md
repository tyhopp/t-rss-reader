# Sequence

Sequence diagrams that describe the patterns every client implements.

## App start sequence

```mermaid
sequenceDiagram
    autonumber

    actor Client
    participant LoginService
    participant FeedsService
    participant EntriesService
    participant LastAccessService
    
    Client->>LoginService: POST /login
    LoginService-->>Client: Token

    Client->>FeedsService: GET /feeds
    FeedsService-->>Client: Feed[]
    par for each feed url
    Client->>EntriesService: GET /entries?url=[Feed.url]
    EntriesService-->>Client: Entry[]
    end

    Client->>LastAccessService: PUT /last-access
```

## Upsert feed sequence

```mermaid
sequenceDiagram
    autonumber

    actor Client
    participant FeedsService
    
    Client->>FeedsService: PUT /feeds
    FeedsService-->>Client: Feed
```

## Delete feed sequence

```mermaid
sequenceDiagram
    autonumber

    actor Client
    participant FeedsService
    
    Client->>FeedsService: DELETE /feeds
```

## Type reference

```ts
interface Token {
  accessToken: string;
  tokenType: string;
  expiresIn: number;
}

interface Feed {
  name: string;
  url: string;
  hasNew?: boolean;
}

interface Entry {
  url?: string;
  title?: string;
  published?: string;
  isNew?: boolean;
}
```
