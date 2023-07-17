<h1><center>Attendance</center></h1>
<h3><center>Ontologia per la registrazione delle presenze in aula</center></h3>
<h5><center>Relazione elaborato Web Semantico</center></h5>

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

# Sviluppo Ontologia

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
```

![Schema di massima](img/schema_di_massima.jpg)

*Sopra: uno schema di massima della nostra ontologia*

Vengono riportate le classi modellate in due classi più rilevanti e le altre (???).

### Person

Questo sostantivo rappresenta una qualunque persona interagisca con un sistema scolastico. Nel nostro elaborato esso modella solamente poche di tutte le possibilità, nello specifico:

* <a id="teacher">Teacher</a>: chi tiene le lezioni

* <a id="tutor">Tutor</a>: chi aiuta a gestire uno specifico workgroup

* <a id="student">Student</a>: chi segue le lezioni

### Workgroup

Rappresenta una [Classe](#classe) che partecipa in un determinato anno didattico e semestre ad una [Attività Didattica](#attivita-didattica).

#### Classe

Rappresenta un gruppo di studenti iscritti in un certo anno accademico.

#### Attività Didattica

Rappresenta un corso di studio insegnato nella scuola. Un esempio può essere *Matematica* o *Economia*.

### Attendable

Rappresenta un concetto(???) sul quale può essere registrata una presenza.

### Lesson

Rappresenta un quanto di tempo dove gli [studenti](#student) seguono un [professore](#teacher). Eventualemnte, il professore può essere aiutato o sostituito da un [tutor](#tutor).

### Exam

Rappresenta un quanto di tempo dove gli [studenti](#student), divisi in [turni](#exam-turn) svolgono la propria prova.

#### Exam Turn

Rappresenta un quanto di tempo dove una parte di studenti iscritti ad un esame svolge la propria prova.

### Pin

Rappresenta un codice a 6 cifre che le persone usano per registrare la loro presenza ad un [Attendable](#attendable).

### Attendance

Rappresenta una registrazione di una presenza. Essa quindi richiede un [Pin](#pin) associato ad un [Attendable](#attendable), cioè un impegno sul quale possa essere registrata una presenza.

### Student Group

Rappresenta un gruppo di studenti. Questa classe è usata esclusivamente nell'ontologia come superclasse per conferire la proprietà hasStudent alle sue sottoclassi

## Object Properties

Di seguito vengono specificate le principali Object Properties modellate. *Vengono elencate ma non esaustivamente spiegate le properties usate dalle ontologie importate.*

### hasStudent vs hasStudentManual

La prima proprietà esprime un elenco di studenti che appartengono ad un determinato Student Group a priori, mentre la seconda un elenco di studenti aggiunti a posteriori ad un Attendable.

# Regole Semantiche

# Interrogazioni

Tramite questa sintassi esprimiamo alcune delle più comuni query che potrebbero essere svolte sulla nostra ontologia.

**Query**:

* [L'ultimo pin creato per un Attendable](#lultimo-pin-creato-per-un-attendable)

## Ultimo pin valido per un determinato attendable
## Tutti i workgroup attivi per un determinato utente
## Estrai uno studente presente casualmente
## Studenti che possono sostenere l'esame (presenze > di tot %)
## Registro delle presenze

```sparql
SELECT ...
```