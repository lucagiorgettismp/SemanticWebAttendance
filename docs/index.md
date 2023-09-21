<h1><center>Attendance</center></h1>
<h3><center>Ontologia per la registrazione delle presenze in aula</center></h3>
<h5><center>Relazione elaborato Web Semantico</center></h5>

<center>
<table>
<tbody>
<td>
<span><center>Luca Giorgietti</center></span>
<span><center>luca.giorgietti7@studio.unibo.it</center></span>
</td>
<td>
<span><center>Daniele Tentoni</center></span>
<span><center>daniele.tentoni2@studio.unibo.it</center></span>
</td>
</tbody>
</table>
</center>

# Sviluppo Ontologia

In questa ontologia ci siamo prefissati di usare le seguenti tecnologie:

* **RDF**: linguaggio usato per la definizione di triplette di dati che permettono di creare delle informazioni utili a chi dovrà usare quegli stessi dati

* **RDFS**: linguaggio per fornire informazioni aggiuntive dai dati rappresentati usando RDF e che con il supporto di tool specifici chiamati *reasoner*, permette anche di comprendere maggiore conoscenza tramite l'uso di regole semantiche

* **OWL**: estensione di RDFS, permette di generare ancora più informazione

* **SPARQL**: linguaggio usato per interrogare ontologie e basi di dati semantiche come quelle in questione

* **Turtle**: sintassi usata in questi ambiti che risulta di più facile lettura anche da utenti umani

Come piattaforma per l'esecuzione delle query e la preparazione dell'ontologia, abbiamo usato principalmente Protégé, affiancato all'uso di reasoner e query enginer a riga di comando. Purtroppo essi non avevano le stesse funzioni di Protégé e il risultato ottenuto non era mai uguale, per questo li abbiamo usati solo per contesti molto limitati.

Come ontologie esterne abbiamo pensato di includere:

* [**VCard**](https://www.w3.org/TR/vcard-rdf/): per descrivere le persone e le organizzazioni. Tramite questa ontologia si potrebbero meglio rappresentare anche le istituzioni di cui fanno parte le persone descritte, permettendo a questa ontologia di modellare una realtà più grande di un solo istituto accademico, ma di un intero sistema, campus condiviso da più atenei ecc...

* [**Foaf**](http://xmlns.com/foaf/0.1/#): per descrivere le relazioni tra le persone descritte. Di questa conoscenza ne viene usata tuttavia solamente una piccola parte, dato che a noi interessa esclusivamente, a questo livello, descrivere le relative lavorative tra esse. Di essa può essere usato anche:

    * [foaf:knows](http://xmlns.com/foaf/0.1/#term_knows)

        Potrebbero essere create proprietà da inferire come: compagni di classe (tra studenti), colleghi di lavoro (tra docenti), ecc...

    * [foaf:publications](http://xmlns.com/foaf/0.1/#term_publications)
    * [foaf:Organization](http://xmlns.com/foaf/0.1/#term_Organization)

        Un relatore di un seminario potrebbe infatti non appartenere all'ateneo.

* [**Time**](https://www.w3.org/TR/owl-time/#): per descrivere le proprietà temporali di una qualsiasi risorsa. Noi l'abbiamo usata per esprimere le durate temporali dei Pin usati per registrare la presenza e per indicare gli orari di inizio degli appuntamenti.

## Presentazione del contesto

L'ontologia in questione nasce dall'esigenza dei due componenti del gruppo di esprimere la conoscenza di un dominio applicativo reale visto durante gli anni di lavoro presso un'azienda di sviluppo software locale.

Il requisito principale è quello di avere un sistema informatico per registrare la [presenza](#attendance) degli studenti quando sia necessario. Potrebbero essere [Lezioni](#lesson), [Esami](#exam) o altri momenti della vita accademica.

> L'adozione delle tecnologie sopracitate consentirà a chi usufruisce di questa ontologia di espanderla per includere gli impegni che richiedono la registrazione della presenza che gli servono.

## Classi

Di seguito viene riportato uno schema di massima della nostra ontologia:

```mermaid
classDiagram
`Didactic Activity` <-- Workgroup : Association
Class <-- Workgroup
Teacher <-- Workgroup
class `Didactic Activity` {
    +string Name
}
class Class {
    +int Number
}
class Workgroup {
    +Year
    isValid()
}
Workgroup *.. Exam : Composition
class Exam {
    +List~turn~ hasTurn
}
Workgroup *.. Lesson
class Lesson {
    +List<Student> hasStudent : from inheritance
}
turn <|-- Exam
class turn["Exam Turn"] {
    +List<Student> hasStudent : from inheritance
}
link turn "/SemanticWebAttendance#exam-turn"
Lesson <|-- Attendable : Inheritance
Exam Turn <|-- Attendable : Inheritance
class Attendable {
    +List<Student> hasStudentManual
}
Pin <-- Attendable
class Pin {
    +string Code
}
Person o-- Teacher : Aggregation
Person o-- Tutor
Person o-- External
Person o-- Student
link Person "/SemanticWebAttendance#person"
class Person {
    string GivenName
    string FamilyName
}
class group["Student Group"] {
    +List~Student~ 
}
link group "/SemanticWebAttendance#student-group"
group --|> Class
group --|> turn
group --|> Lesson
group "n" --> "m" Student : hasStudent
class Attendance
Attendance o-- AttendanceValid
Attendance o-- AttendanceNotValid
Attendance o-- RemoteAttendance
AttendanceValid o-- AttendanceValidPresent
AttendanceValid o-- AttendanceValidWithDelay
AttendanceNotValid o-- AttendanceNotValidAlreadySubmitted
link AttendanceNotValidAlreadySubmitted "/SemanticWebAttendance#AttendanceNotValidAlreadySubmitted"
AttendanceNotValid o-- AttendanceNotValidOutOfWorkgroup
AttendanceNotValid o-- AttendanceNotValidWithDelay
Pin --|> Attendance : hasAttendance
Attendance --|> Person : hasAttendant
```

![Schema di massima](img/schema_di_massima.jpg)

*Sopra: uno schema di massima della nostra ontologia*

Vengono riportate le classi modellate in due classi più rilevanti e le altre (???).

### Person

Questa classe rappresenta una qualunque persona interagisca con un sistema scolastico.

**Data Properties**

| Nome | Tipo |
| --- | --- |
| Given Name | string |
| Family Name | string |
| Birth Date | date |
| Organization Name | string |

**Object Properties**

| Nome | Dominio | Range |
| --- | --- | --- |
| has Gender | Person | Gender |
| has Attendant | Gender | Person |
| has Guest | Lesson | Person |

Nel nostro elaborato esso modella solamente poche di tutte le possibilità, nello specifico:

* <a id="teacher">Teacher</a> (Docente): chi tiene le lezioni

    **Object Properties**

    | Nome | Dominio | Range |
    | --- | --- | --- |
    | has Teacher | Workgroup | Teacher |

* <a id="tutor">Tutor</a> (Tutore): chi aiuta a gestire uno specifico workgroup

    **Object Properties**

    | Nome | Dominio | Range |
    | --- | --- | --- |
    | has Tutor | Lesson | Tutor |

* <a id="student">Student</a> (Studente): chi principalmente partecipa alle lezioni

    **Data Properties**

    | Nome | Tipo |
    | --- | --- |
    | studentId | string |

    **Object Properties**

    | Nome | Dominio | Range |
    | --- | --- | --- |
    | [has Manual Student](#hasstudent-vs-hasmanualstudent) | Student Group | Student |
    | has Student | Student Group | Student |

* <a id="external">External</a> (Esterno): chi non fa parte dell'organizzazione scolastica, utile per identificare le persone che vengono a tenere un seminario

    **Data Properties**

    | Nome | Tipo |
    | --- | --- |
    | organization | string |

    Abbiamo quindi dichiarato questa risorsa DisjointWith con le altre sotto classi di Person

### Workgroup

Rappresenta una [Classe](#classe) che partecipa in un determinato anno didattico e semestre ad una [Attività Didattica](#attivita-didattica).

**Data Property**

| Nome | Tipo |
| --- | --- |
| wrk term | number |
| wrk year | number |

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasClass | Workgroup | Class |
| hasDidacticActivity | Workgroup | DidacticActivity |
| hasExam | Workgroup | Exam |
| hasLesson | Workgroup | Lesson |
| hasTeacher | Workgroup | Teacher |

#### Class

Rappresenta un gruppo di studenti iscritti in un certo anno accademico.

Inoltre è anche sottoclasse di [Student Group](#student-group).

**Object Properties**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasClass | Workgroup | Class |

#### Didactic Activity

Rappresenta un corso di studio insegnato nella scuola. Un esempio può essere *Matematica* o *Economia*.

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasDidacticActivity | Workgroup | DidacticActivity |

### Attendable

Rappresenta un concetto(???) sul quale può essere registrata una presenza. Da notare che questo concetto non viene completamente esaurito in questa ontologia. Infatti possiamo immaginare che nel solo ambito accademico possono essere ancora rappresentati altri tipi di eventi che possono avere interesse del registrare la presenza degli utenti, come a riunioni di docenti e di altro personale o ricevimenti privati.

**Data Property**

| Nome | Tipo |
| --- | --- |
| start time | date |
| end time | date |

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasLocation | Attendable | [Location](#location) |
| hasPin | Attendable | [Pin](#pin) |

Possiamo affermare che la proprietà *hasPin* è **inversamente funzionale**: infatti una lezione può avere molti pin, mentre ogni pin oggetto di questa relazione può avere una sola relazione di questo tipo verso una lezione. Possiamo quindi dire che la relazione inversa di hasPin, isPinOf, è funzionale.


### Lesson

Rappresenta un quanto di tempo dove gli [studenti](#student) seguono un [professore](#teacher). Eventualmente, il professore può essere aiutato o sostituito da un [tutor](#tutor).

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasGuest | Lesson | [Person](#person) |
| hasLesson | Workgroup | Lesson |
| hasTutor | Lesson | [Tutor](#tutor) |

Nella nostra ontologia sono presenti anche altre due risorse sottoclassi di questa:

* **External Guest Seminar**: Seminario tenuto da qualcuno che non sia il solito titolare dell'insegnamento del corso, che potrebbe anche essere un esterno venuto esclusivamente per tenere la lezione, invitato dal docente. Nella nostra ontologia questo è rappresentato dalla classe [External](#external).

* **Not Attended Lesson**: Lezione che non è stata seguita da nessun studente.

### Exam

Rappresenta un quanto di tempo dove gli [studenti](#student), divisi in [turni](#exam-turn) svolgono la propria prova.

**Data Property**

| Nome | Tipo |
| --- | --- |
| exam date | date |

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasExam | Workgroup | Exam |
| hasTurn | Exam | [Exam Turn](#exam-turn) |

#### Exam Turn

Rappresenta un quanto di tempo dove una parte di studenti iscritti ad un esame svolge la propria prova. Questa divisione è necessaria in quanto non sempre negli atenei sono presenti aule abbastanza capienti per contenere tutti gli studenti che svolgono una prova un determinato giorno. Tra le varie motivazioni, ci può essere la necessità di svolgere la prova su dei supporti specifici (come dei computer per le prove di informatica) o per via del distanziamento tra gli attendenti (in un'aula da 200 persone, potrebbero riuscirci a stare soltato 50 persone durante un'esame).

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasTurn | [Exam](#exam) | Exam Turn |

### Pin

Rappresenta un codice a 6 cifre che le persone usano per registrare la loro presenza ad un [Attendable](#attendable).

Possiede una data di creazione (*creation_date*) da valorizzare quando viene generato il Pin che è usata per calcolare tramite la regola ... la data di scadenza dello stesso. Allo scoccare della scadenza non sarà più possibile registrare una presenza sul Pin.

**Data Property**

| Nome | Tipo |
| --- | --- |
| creation date | date |
| expiration date | date |
| code | string |

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasAttendance | Pin | [Attendance](#attendance) |
| pinHasDuration | Pin | time:Duration |
| hasPin | Attendable | Pin |

Possiamo affermare che la proprietà *hasAttendance* è una proprietà **funzionale**: infatti un Pin può avere più Attendance, mentre un Attendance può avere un solo Pin su cui essere registrato.

### Attendance

Rappresenta una registrazione di una presenza. Essa quindi richiede un [Pin](#pin) associato ad un [Attendable](#attendable), cioè un impegno sul quale possa essere registrata una presenza.

Questa registrazione possiede la particolarità di non dover per forza essere binaria nel senso di *"Sei Presente"* o *"Sei Assente"*. La nostra ontologia deve tenere conto che uno studente sia presente sia essendo entrato puntuale o con qualche minuto di anticipo, sia essendo in ritardo. Uno studente che effettua una registrazione della presenza per la seconda volta sullo stesso Pin, ad esempio, dall'applicativo sarà segnato come una registrazione non valida, risultando comunque presente perché già registrato una prima volta precedentemente a quella non valida.

Tuttavia una presenza può essere o *Valida* o *Invalida*, presentando due insiemi disgiunti di classi. In questo è venuta in aiuto l'espressività concessa da OWL. Abbiamo potuto esprimere questo fatto con le seguenti regole:

```
attendance-ontology:AttendanceNotValid rdf:type owl:Class ;
    rdfs:subClassOf attendance-ontology:Attendance ;
    owl:disjointWith attendance-ontology:AttendanceValid .
```

Le varie possibilità offerte attualmente dall'ontologia sono:

* Registrazione non valida (AttendanceNotValid):

    * <a id="AttendanceNotValidAlreadySubmitted">Registrazione già sottoposta (AttendanceNotValidAlreadySubmitted)</a>: uno studente si è sbagliato e ha registrato più di una volta la sua presenza sulla stessa lezione

    * <a id="AttendanceNotValidOutOfWorkgroup">Registrazione di uno studente fuori workgroup (AttendanceNotValidOutOfWorkgroup)</a>: uno studente si è registrato alla lezione nonostante non sia interno al workgroup della lezione e non fosse segnato tra gli studenti al quale è consentito come studenti manuali

    * <a id="AttendanceNotValidWithDelay">Registrazione con ritardo (AttendanceNotValidWithDelay)</a>: questa classe differisce da [AttendanceValidWithDelay](#attendancevalidwithdelay) in quanto il ritardo il questione è così tanto da non poter più considerare valida la presenza allo studente

* Registrazione valida (AttendanceValid):
    
    * <a id="AttendanceValidPresent">Registrazione valida (AttendanceValidPresent)</a>: la presenza dello studente è stata registrata entro l'inizio della lezione

    * <a id="AttendanceValidWithDelay">Registrazione con ritardo (AttendanceValidWithDelay)</a>: questa classe differisce da [AttendanceNotValidWithDelay](#AttendanceNotValidWithDelay) in quanto il ritardo in questo caso non è così tanto da considerare invalida la presenza allo studente

Se la registrazione della presenza fosse stata fatta da remoto, allora anche la proprità `remote` sarebbe valorizzata e la regola [RemoteAttendance](#remoteattendance) inferirebbe che la presenza appartenga anche alla classe `RemoteAttendance`:

**Data Property**

| Nome | Tipo |
| --- | --- |
| remote | boolean |

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| hasAttendance | Pin | Person |
| hasAttendant | Attendance | Person |

### StudentGroup

Rappresenta un gruppo di studenti. Questa classe è usata esclusivamente nell'ontologia come superclasse per conferire la proprietà hasStudent alle sue sottoclassi.

**Object Property**

| Nome | Dominio | Range |
| --- | --- | --- |
| [has Manual Student](#hasstudent-vs-hasmanualstudent) | StudentGroup | Student |
| hasStudent | StudentGroup | Student |

## Object Properties

Di seguito vengono specificate le principali Object Properties modellate. *Vengono elencate ma non esaustivamente spiegate le properties usate dalle ontologie importate.*

### hasStudent vs hasManualStudent

La prima proprietà esprime un elenco di studenti che appartengono ad un determinato Student Group a priori, mentre la seconda un elenco di studenti aggiunti a posteriori ad un Attendable, in genere vengono aggiunti a mano da un operatore su richiesta di un ufficio o di un dipartimento, perché si intende fare seguire ad uno studente una lezione, per via di un dottorato in corso o altre esigenze di formazione degli studenti.

# Regole Semantiche

**Rules**:

* [PinExpirationDate](#pinexpirationdate)

* [RemoteAttendance](#remoteattendance)

* [ExternalGuestLesson](#externalguestlesson)

## PinExpirationDate

```swrl
attendance-ontology:Pin(?pin) ^
attendance-ontology:creation-date(?pin, ?creationDate) ^
swrlb:dayTimeDuration(?pinDuration, 0, 0, 15, 0) ^
swrlb:addDayTimeDurationToDateTime(?result, ?creationDate, ?pinDuration)

-> attendance-ontology:expiration-date(?pin, ?result)
```

Questa regola consente di valorizzare l'orario di scadenza di un Pin in base alla sua data di creazione. Nell'ontologia di esempio proposta, abbiamo assunto che tutti i Pin abbiano una durata di 15 minuti di durata. Tuttavia la regola non viene effettivamente utilizzata poiché Protégé non riesce ad elaborarla attraverso il tool integrato in esso *Drool rule engine* o *Pellet*. Abbiamo infatti realizzato la query `PinExpirationDateQueryRule`, per dimostrare che la regola PinExpirationDate sia formulata correttamente.

## RemoteAttendance

```swrl
# Dato un Attendance ?attendance
at:Attendance(?attendance) ^

# dove ?attendance abbia una proprietà remote con valore ?remot
at:remote(?attendance, ?remot) ^

# dove questo valore ?remot sia uguale a 'true'
swrlb:equal(?remot, true)

# Possiamo assumere che ?attendance sia di tipo Remote Attendance
-> attendance-ontology:RemoteAttendance(?attendance)
```

Questa regola permette di inferire l'appartenenza alla classe RemoteAttendance per tutti gli Attendance che hanno la data property *remote* valorizzata a `true`. Ciò consente di assumere <u>certamente</u> che una presenza con valore `remote true` sia da remoto, ma non che una presenza senza quella proprietà valorizzata sia <u>sicuramente</u> in presenza.

## ExternalGuestLesson

```swrl
attendance-ontology:Lesson(?lesson) ^
attendance-ontology:hasGuest(?lesson, ?guest) ^
attendance-ontology:External(?guest)

-> attendance-ontology:ExternalGuestSeminar(?lesson)
```

Questa regola permetter di inferire se una lezione appartenga anche al tipo specifico *ExternalGuestSeminar*.

# Interrogazioni

Tramite questa sintassi esprimiamo alcune delle più comuni query che potrebbero essere svolte sulla nostra ontologia.

**Query**:

* [Ultimo pin creato per un Attendable](#ultimo-pin-valido-per-un-determinato-attendable)
* [Tutti i workgroup attivi per un determinato utente](#tutti-i-workgroup-attivi-per-un-determinato-utente)
* [Estrai uno studente presente casualmente](#estrai-uno-studente-presente-casualmente)
* [Studenti che possono sostenere l'esame (presenze > di tot %)](#studenti-che-possono-sostenere-lesame-presenze--di-tot)
* [Registro delle presenze](#registro-delle-presenze)
* [Workgroup poco partecipati](#workgroup-poco-partecipati)

Il codice di tutte le query generate per il progetto può essere consultato su [Github](https://github.com/lucagiorgietti)

## Ultimo pin valido per un determinato attendable

Selezioniamo l'ultimo pin valido per un attendable. Questa interrogazione viene usata quando si vuole presentare il pin sul quale gli studenti possono registrare la loro presenza.

In questo caso l'Attendable da usare è già noto, basta ordinare per data di creazione decresente i Pin che sono di un certo Attendable e prendere solo il primo.

```sparql
SELECT ?pin WHERE {
    ?attendable att:hasPin ?pin .
    ?pin att:creation-date ?creationDate ;
        att:expiration-date ?expirationDate ;
        att:pin-code ?code .

    BIND( now() AS ?currentDateTime ) # Get current date time
    FILTER (?attendable = att:LES_WS_2023_05_21) # This is the parameter
    FILTER (?expirationDate >= ?currentDateTime)
}

ORDER BY DESC(?creationDate) LIMIT 1
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
----------------------------------------------------
| pin          | code     | expirationDate         |
====================================================
| att:PIN_WS_5 | "666799" | "2023-09-21T11:15:00Z" |
----------------------------------------------------
```

## Tutti i workgroup attivi per un determinato utente

Selezioniamo tutti i workgroup attivi per un utente per capire quali lezioni dovrà seguire o quali esami sostenere.

```sparql
# Retrieve all workgroup for a student.
SELECT ?workgroup ?da ?teacher ?term WHERE {
    ?student att:isStudentOf ?class . 
    ?class att:isClassOf ?workgroup .
    ?workgroup att:hasDidacticActivity ?da ;
        att:hasTeacher ?teacher ;
        att:wrk-term ?term .
    
    FILTER (?student = att:STU_00001_MarioRossi)
}

ORDER BY ?term
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
---------------------------------------------------------------------------------------------------------------
| workgroup                                 | da                        | teacher                      | term |
===============================================================================================================
| att:WRK_CL_001_DA_PervasiveComputing_2023 | att:DA_PervasiveComputing | att:TR_AlessandroRicci       | "1"  |
| att:WRK_CL_001_DA_ProjectManagement_2023  | att:DA_ProjectManagement  | att:TR_MarcoAntonioBoschetti | "1"  |
| att:WRK_CL_001_DA_WebSemantico_2023       | att:DA_WebSemantico       | att:TR_AntonellaCarbonaro    | "2"  |
---------------------------------------------------------------------------------------------------------------
```

## Estrai uno studente presente casualmente

Seleziono uno studente preso a caso tra i presenti a lezione per verificare se realmente sia presente o è stato registrato da qualcun altro in modo malizioso.

In questo caso devo recuperare da tutti pin usati per la lezione tutte le presenze di un qualsiasi tipo valido e ne leggo soltanto una, la prima tra tutte quelle recuperate riordinate a caso.

```sparql
# Retrieve all attendance from an attendable.
SELECT ?attendance WHERE {
    ?attendable att:hasPin ?pin .
    ?pin att:hasAttendance ?attendance .
    ?attendance att:hasAttendant ?student ;
        rdf:type ?type .
    ?type rdfs:subClassOf att:AttendanceValid .

    FILTER (?attendable = att:LES_WS_2023_05_22) # This is the parameter
}

# Then order them randomly and take the first one.
ORDER BY RAND() LIMIT 1
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
----------------------------
| student                  |
============================
| att:STU_00001_MarioRossi |
----------------------------
```

## Studenti che possono sostenere l'esame (presenze > di tot %)

Otteniamo tutti gli studenti che hanno una percentuale di presenza maggiore rispetto ad una certa soglia (nel nostro esempio 50%).

```sparql
# Students having a presence frequency at DA_WebSemantico higher (or equal) to 50%
SELECT ?student ?percentage WHERE {
		{
		SELECT ?student (count(?attendance) AS ?tot_freq) WHERE {
            ?wrk att:hasClass ?class .
            ?class att:hasStudent ?student .

            OPTIONAL {
                ?wrk att:hasLesson ?lesson .
                ?lesson att:hasPin ?pin .
                ?pin att:hasAttendance ?attendance .
                ?attendance att:hasAttendant ?student ;
                    rdf:type ?type .
                ?type rdfs:subClassOf att:AttendanceValid .
            }

            FILTER (?wrk = att:WRK_CL_001_DA_WebSemantico_2023)
        }

        GROUP BY ?student
	}
	{
		SELECT (count(?lesson) AS ?tot) WHERE {
			?wrk att:hasLesson ?lesson .
			FILTER (?wrk = att:WRK_CL_001_DA_WebSemantico_2023)
		}
	}

	FILTER (?percentage > 50)
}
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
--------------------------------------------------------
| student                  | percentage                |
========================================================
| att:STU_00001_MarioRossi | 66.6666666666666666666667 |
--------------------------------------------------------
```

## Registro delle presenze

```sparql
SELECT DISTINCT ?student ?type WHERE {
    ?lesson att:hasStudent ?student . 

    OPTIONAL { 
        ?lesson att:hasPin ?pin .
        ?pin att:hasAttendance ?attendance .
        ?attendance att:hasAttendant ?student ;
            rdf:type ?type .
        {        
            ?type rdfs:subClassOf att:AttendanceValid .
        }
        UNION
        {        
            ?type rdfs:subClassOf att:AttendanceNotValid .
        }
    }

    FILTER (?lesson = att:LES_WS_2023_05_22)
}

ORDER BY ?student
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
--------------------------------------------------------------
| student                     | type                         |
==============================================================
| att:STU_00001_MarioRossi    | att:AttendanceValidPresent   |
| att:STU_00002_LuigiVerdi    | att:AttendanceValidWithDelay |
| att:STU_00003_ChiaraBianchi |                              |
--------------------------------------------------------------
```

## Workgroup poco partecipati

Secondo noi è anche interessante sapere quali siano i Workgroup con scarsa partecipazione. Possiamo avere bisogno di sapere quali siano le Attività Didattiche che riscontrano poco successo tra gli studenti per capire come migliorarle o come sostituirle negli anni successivi.

```sparql
SELECT ?wrk ?rapporto WHERE {
    {
        # Recupero tutte le presenze di un workgroup e ne ottengo il numero totale.
        SELECT ?wrk (count(?attendance) AS ?tot_freq) WHERE {
            ?wrk att:hasClass ?class .
            ?class att:hasStudent ?student .
            
            OPTIONAL {
                ?wrk att:hasLesson ?lesson .
                ?lesson att:hasPin ?pin .
                ?pin att:hasAttendance ?attendance .
                ?attendance att:hasAttendant ?student ;
                    rdf:type ?type .
                ?type rdfs:subClassOf att:AttendanceValid .
            }
        }

        GROUP BY ?wrk
    }
    {
        # Lo devo rapportare al numero totale di presenze che mi sarei aspettato in quel workgroup.
        SELECT ?wrk (count(?student) AS ?exp_freq) WHERE {
            ?wrk att:hasClass ?class .
            ?class att:hasStudent ?student .
            
            OPTIONAL {
                ?wrk att:hasLesson ?lesson .
            }
        }
        
        GROUP BY ?wrk
    }
    
    # Calcolo e filtro il rapporto.
    BIND (?tot_freq / ?exp_freq * 100 AS ?rapporto)
    FILTER (?rapporto < 30)
}
```

Eseguendo questa interrogazione viene prodotto il risultato:

```sh
--------------------------------------------------------
| wrk                                       | rapporto |
========================================================
| att:WRK_CL_002_DA_ProjectManagement_2023  | 0.0      |
| att:WRK_CL_002_DA_WebSemantico_2023       | 0.0      |
| att:WRK_CL_001_DA_ProjectManagement_2023  | 0.0      |
| att:WRK_CL_001_DA_PervasiveComputing_2023 | 0.0      |
--------------------------------------------------------
```

# Conclusioni

Le tecnologie studiate durante questo corso trovano molto successo in ambienti nei quali è fondamentale essere pronti al cambiamento e all'integrazione con altri sistemi e basi di conoscenza. Nel nostro ambito lavorativo ciò avviene poco o proprio per niente. In questo caso particolare, potrebbe essere utile avere la possibilità di integrare anche la conoscenza in modo veloce tra i vari fornitori di servizi informatici di un ateneo o di un apparato scolastico nazionale. 

<!-- Basti pensare alla realtà dei test d'ingresso alle varie facoltà, che richiedono poi un grandissimo sforzo di comunicazione tra i vari atenei sia per chi riesce ad essere ammesso agli stessi e chi no. Nel nostro caso, le esigenze di registrazione delle presenze da parte dei vari istituti potrebbe essere molto differente e richiedere meno sforzi nel momento in cui vengano sfruttate queste facilitazioni.-->

Inoltre, come già citato in questa relazione, abbiamo notato che non esistono degli strumenti efficaci per lavorare con queste tecnologie a parte Protégé che fossero gratuiti e open. Moltissimi software non sono più mantenuti da molto tempo oppure hanno una scarsa documentazione e supporto da una comunità di utilizzo, per questo anche soluzioni a problemi comuni che abbiamo riscontrato non avevano risposte sui forum online o su Stack Overflow.

Per il problema sopracitato, nonostante i nostri sforzi, non siamo quindi riusciti a creare un efficace sistema di Continuous Integration che, data la nostra ontologia, effettuasse prima l'inferenza e poi un controllo di validità su tutte le query che venivano aggiunte al progetto. Infatti, tramite le Github Actions riusciamo soltanto a controllare che le query eseguite sull'ontologia già inferita. Come *artefatto* risultato di una computazione, non è bene che sia tracciato sul sistema di versioning, dovrebbe essere generato all'occorrenza.

<!-- Scrivere altre cose sull'ontologia -->