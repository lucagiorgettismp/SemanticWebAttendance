# SemanticWebAttendance

## Configurazione Protege:
- protege version 5.5.0
- reasoner Pellet
- plugin Snap SPARQL Query

## Jena ARQ
- java version sdk 17
- jena version 4.8.0

sparql --data=doc/Tutorial/vc-db-1.rdf --query=doc/Tutorial/q1.rq

## How to render the docs

First install requirements:

```
python -m pip install -r requirements.txt
```

Run following commands:

```
mkdocs serve
```

To build it use:

```
mkdocs build
```

## DL queries
https://github.com/lucagiorgettismp/SemanticWebAttendance/wiki/DL-queries

## SPARQL queries
https://github.com/lucagiorgettismp/SemanticWebAttendance/wiki/SPARQL-queries


Proprietà pin attivo o scaduto con swrl. Ha senso fare una classe separata?