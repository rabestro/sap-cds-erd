# SAP CDS Entity Relationship Diagrams

The small AWK script generate mermaid Entity Relationship diagrams from SAP Cloud Application Programming Model files.

## How to run

```shell
gawk -f src/cds2erd.awk db/* > bookstore.mermaid
```

## Sample generated ER diagram
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
