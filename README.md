# Server Project

## Overview

This repository contains the server-side code for a system built using Node.js, TypeScript, and Sequelize. The project handles business logic, database interactions, and provides RESTful APIs for the clients. It includes various endpoints for managing resources such as orders, products, clients, and users.

## Architecture

The architecture follows a modular structure where each domain (such as orders, products, clients) is grouped into its own folder. Each domain includes the following components:

1. **Endpoints**: Files for HTTP request handlers (routes).
2. **Services**: Business logic related to the domain.
3. **Repositories**: Database interaction logic.
4. **Schemas**: Validation and data transformation logic (for request and response data).
5. **Types**: Custom TypeScript types used within the domain.

The architecture uses the **Model-View-Controller (MVC)** pattern, where:
- **Models** are managed via Sequelize ORM, allowing interaction with the database.
- **Controllers** (represented as endpoints in this case) handle the HTTP requests and return appropriate responses.


## Folder Structure

Here’s a breakdown of the folder structure of the project:

```plaintext
.
├── database
│   ├── 001.create_data_base.sql          # SQL to create the database
│   ├── 002.create_sps.sql               # SQL to create stored procedures
│   ├── 003.create_views.sql             # SQL to create views
│   ├── 004.create_read_view.sql         # SQL for read-only views
│   └── dockerfile                       # Docker file for building container
├── docker-compose.yml                   # Docker compose file to run the server and DB
├── pnpm-lock.yaml                       # Lock file for dependency management
├── sapassword.env                       # Environment file for storing sensitive information
├── server
│   ├── build                            # Compiled TypeScript code
│   ├── node_modules                     # Node.js modules (excluded from version control)
│   ├── package.json                     # Node.js project metadata and dependencies
│   ├── src                              # Source code (TypeScript)
│   ├── swagger.js                       # Swagger API documentation generator
│   ├── swagger-output.json              # Generated Swagger documentation
│   ├── tsconfig.json                    # TypeScript configuration file
├── sqlserver.env                        # Environment variables for SQL Server
└── web                                  # Frontend (if applicable)