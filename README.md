# SAP CDS Entity Relationship Diagrams

The small AWK script generate [mermaid](https://mermaid.js.org/) Entity Relationship diagrams from SAP Cloud Application Programming Model files.

## How to run script

```shell
gawk -f src/cds2erd.awk db/* > bookstore.mermaid
```

Alternatively you can make the script executable:
```shell
chmod +x cds2erd.awk
```
In this case you can call the script without specifying an interpreter:

```shell
cds2erd.awk schema.cds > schema.mermaid
```

## Sample generated ER diagram

Below is the database schema from the project SAP Cloud CAP Samples [Bookstore](https://github.com/SAP-samples/cloud-cap-samples/) 
```mermaid
erDiagram
    Books {
        String title 
        String descr 
        Integer stock 
        Decimal price 
        Currency currency 
        Decimal rating 
        TechnicalBooleanFlag isReviewable 
    }

    Authors {
        String name 
        Date dateOfBirth 
        Date dateOfDeath 
        String placeOfBirth 
        String placeOfDeath 
    }

    Genres {
        String name 
        String descr 
        Integer ID PK
    }

    Notes {
        String note 
    }

    Orders {
        String OrderNo 
        User buyer 
        Decimal total 
        Currency currency 
    }

    OrderItems {
        Integer quantity 
        Decimal amount 
    }

    Reviews {
        Rating rating 
        String title 
        String text 
    }

    Orders |o--o{ OrderItems : ""
    OrderItems |o--o| Books : ""
    Genres }o--o| Genres : ""
    Books |o--o{ Reviews : ""
    Books |o--o| Genres : ""
    Books }o--o| Authors : ""

```
