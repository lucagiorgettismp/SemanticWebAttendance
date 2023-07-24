# SemanticWebAttendance

## Configurazione Protege:
- protege version 5.5.0
- reasoner Pellet
- plugin Snap SPARQL Query

## Jena ARQ
- java version sdk 17
- jena version 4.8.0
- arq is the query executor
- riot is the reasoner

sparql --data=doc/Tutorial/vc-db-1.rdf --query=doc/Tutorial/q1.rq

## Infer

You can infer using:

```
# Unix
riot --format=turtle Progetto_2_3.ttl > inferred.ttl

# Windows
riot --format=turtle Progetto_2_3.ttl | Out-File inferred.ttl -Encoding UTF8
```

## Save and Run

Use the extension `wk-j.save-and-run` to execute the query using arq from jena whenever you save any query with file extension *.rq*.

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