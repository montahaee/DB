# This repository contains selected solutions to homework assignments for the lecture on Database (DE. Datenbank)

For the **theoretical part**, we need two reference books: 
1. [FUNDAMENTALS OF Database Systems (SEVENTH EDITION)](https://www.pearson.com/en-us/subject-catalog/p/fundamentals-of-database-systems/P200000003546/9780137502523)
2. [Datenbanksysteme Eine Einführung by Prof. Dr. Alfons Kemper and Dr. André Eickler](https://www.degruyter.com/document/isbn/9783110443752/html?lang=de)

For the **practical exercises**, we need a so-called database management system (DBMS, server) that provides data for our applications (clients). For this purpose, we will use “relational” DBMS (and later other types) and, as an example, [MySQL](https://www.mysql.com/) or [MariaDB](https://mariadb.com/). [Docker](https://www.docker.com/) is used to provide a pre-configured application, in this case our DBMS, as an encapsulated container and to be able to run it largely separate from already installed applications. Install Docker including Docker Compose (“Compose is a tool for defining and running multi-container Docker applications.”) and any IDE compatible with MariaDB and MySQL for the client.

**Notice:** To turn on/off the server enter 'docker-compose up/down -d'(-d for whithout detaching).
