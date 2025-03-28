# Incident Management API

![Python](https://img.shields.io/badge/python-3.7%2B-blue)
![Flask](https://img.shields.io/badge/flask-2.0.1-green)
![PostgreSQL](https://img.shields.io/badge/postgresql-10%2B-blueviolet)
![REST](https://img.shields.io/badge/API-REST-brightgreen)

A RESTful API for managing incident reports with full CRUD functionality, built with Flask and PostgreSQL.

## Features

- Create new incident reports
- List all reported incidents
- Get specific incident details
- Update incident status
- Delete incident reports
- Data validation and error handling
- PostgreSQL database integration

## API Endpoints

| Method | Endpoint           | Description                     |
|--------|-------------------|---------------------------------|
| POST   | `/incidents`      | Create new incident             |
| GET    | `/incidents`      | List all incidents              |
| GET    | `/incidents/{id}` | Get specific incident           |
| PUT    | `/incidents/{id}` | Update incident status          |
| DELETE | `/incidents/{id}` | Delete incident                 |

## Data Structure

Each incident contains:
```json
{
    "id": 1,
    "reporter": "John Doe",
    "description": "Server is not responding",
    "status": "pending",
    "created_at": "2023-05-20T12:00:00.000000"
}