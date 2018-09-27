# Job Board

job board provides an API with everything needed to publish and manage job offers

### Installation
Requires ruby 2.3.1 and rails 5.2.1

### Configuration
Execute bundle install in the root of the project.

```sh
$ bundle install
```
The system use sqlite database by default. You can change it in the database.yml file.

### Execution
Start the server:

```sh
$ rails s
```

### PATHS AVAILABLES

##### POST /signup
Register as company or candidate user
- email: require
- password: require
- rol: require. [company or candidate]

GOOD EXAMPLE
```
{user: {email: "email@email.com", password: "password", rol: "company"}}
```

##### POST   /login
Login with one user
- email: require
- password: require

GOOD EXAMPLE
```
{user: {email: "email@email.com", password: "password"}}
```

##### DELETE   /logout
Logout with one user

## AUTHENTICATION
In the next paths you need insert in the headers the authorization token that returns the login.

##### GET   /job_adverts
Path only for candidates. Return list of job adverts.

RETURN EXAMPLE
```
[
    {
        "id": 1,
        "title": "Title",
        "description": "description offer",
        "user_id": 3,
        "created_at": "2018-09-26T18:56:30.658Z",
        "updated_at": "2018-09-26T18:56:30.658Z"
    },
    {
        "id": 3,
        "title": "Title",
        "description": "Description",
        "user_id": 6,
        "created_at": "2018-09-27T17:17:29.647Z",
        "updated_at": "2018-09-27T17:17:29.647Z"
    }
]
```

##### POST   /job_adverts
Path only for companies. Return the object or the errors in the creation.

- title: require (minimum 5 characters)
- description: optional

GOOD EXAMPLE
```
{job_advert: {title: "titulo"}}
```
RETURN SUCCESS EXAMPLE
```
{
    "id": 4,
    "title": "Titulo",
    "description": null,
    "user_id": 6,
    "created_at": "2018-09-27T17:27:07.203Z",
    "updated_at": "2018-09-27T17:27:07.203Z"
}
```
##### GET   /applies
Path only for companies. Return all applies for the logged company.

RETURN EXAMPLE
```
[
    {
        "id": 6,
        "status": "pending",
        "highlight": null,
        "user_id": 7,
        "job_advert_id": 3,
        "created_at": "2018-09-27T17:38:10.941Z",
        "updated_at": "2018-09-27T17:38:10.941Z"
    }
]
```
##### POST   /applies
Path only for candidates. Return the object or the errors in the object creation.
- job_advert_id: require 

GOOD EXAMPLE
```
{apply: {job_advert_id: 1}}
```
RETURN EXAMPLE
```
{
    "id": 4,
    "status": "pending",
    "highlight": false,
    "user_id": 7,
    "job_advert_id": 1,
    "created_at": "2018-09-27T17:35:45.034Z",
    "updated_at": "2018-09-27T17:35:45.034Z"
}
```

##### GET   /applies/:id
Path only for company. Return the object or error if not exists.

RETURN EXAMPLE
```
{
    "id": 6,
    "status": "pending",
    "highlight": null,
    "user_id": 7,
    "job_advert_id": 3,
    "created_at": "2018-09-27T17:38:10.941Z",
    "updated_at": "2018-09-27T17:38:10.941Z"
}
```

##### PUT   /applies/:id
Path only for companies. Update the apply and return the object or the error.
- status: possible values [in_progress, hire, reject]
- highlight: Optional. possible values [true, false]

GOOD EXAMPLE
```
{apply: {status: "reject", highlight: true}}
```
RETURN EXAMPLE
```
{
    "id": 4,
    "status": "pending",
    "highlight": false,
    "user_id": 7,
    "job_advert_id": 1,
    "created_at": "2018-09-27T17:35:45.034Z",
    "updated_at": "2018-09-27T17:35:45.034Z"
}
```


### CATCH ERRORS EXAMPLE
When an object creation return error the JSON contains in detail the errors:
```
{
    "errors": [
        {
            "status": "400",
            "title": "Bad Request",
            "detail": {
                "title": [
                    "is too short (minimum is 5 characters)"
                ]
            },
            "code": "100"
        }
    ]
}
```