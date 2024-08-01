# Rails API GraphQL

## Project Overview

The **Shop CRM API** is a RESTful API designed to manage customer data for a small shop. It acts as the backend for a CRM interface, providing a robust solution for handling customer information and interactions. This API is built with Ruby on Rails and GraphQL to facilitate efficient data querying and manipulation.

## Functionality

- **Customer Management**: Create, read, update, and delete customer records.
- **Photo Handling**: Upload and manage customer profile photos with support for image transformations.
- **Authentication and Authorization**: Secure access using OAuth 2.0 and JWT for authentication, with role-based access control via Pundit.
- **Soft Deletion**: Implemented using the `paranoia` gem to ensure data integrity and allow for data recovery.
- **GraphQL Interface**: Efficiently query and mutate customer data using GraphQL, with a structured approach to mutations and queries.

## Getting Started

### Prerequisites

Before you start, ensure you have the following installed:

- Ruby 3.2.4
- Rails 7.1
- PostgreSQL
- Docker (for development and deployment)
- Heroku CLI (for deployment)

### Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/yourusername/your-repo.git
    cd your-repo
    ```

2. **Install Dependencies**

    ```bash
    bundle install
    ```

3. **Setup Database**

    ```bash
    bin/rails db:create
    bin/rails db:migrate
    ```

4. **Configure Active Storage**

    Active Storage is configured to use Amazon S3 in production. For local development, it uses disk storage.

    Update `config/storage.yml` with your S3 credentials if using Amazon S3.

5. **Start the Server**

    ```bash
    bin/rails server
    ```

## Usage

### Access the API

You can interact with the API using GraphiQL at the following URL:

[GraphiQL Interface](https://shop-crm-api-7409536b1857.herokuapp.com/graphiql)

### GraphiQL Usage Example

To execute a request in GraphiQL, use the GraphQL query. For example:

    ```graphql
    mutation {
    loginMutations(input: {
        provider: "google"
        token: "YOUR_OAUTH_TOKEN_HERE"
    }) {
        token
        errors
    }
    }
    ```

Example fot customer creating:

    ```graphql
    mutation {
        createCustomer(input: {
        firstName: "Name"
        lastName: "Last"
            photoBase64: "FILE_BASE64"
            photoFileName: "image_name.png"
        }) {
        customer {
            id
            firstName
            lastName
                    photoUrl
            createdBy {
            id
            email
            firstName
            lastName
            }
            updatedBy {
            id
            email
            firstName
            lastName
            }
        }
        errors
    }
    }
    ```

Be sure to include the following headers in your request (except login):

    ```json
    {
        "Authorization": "Bearer YOUR_JWT_TOKEN_HERE"
    }
    ```


### Authentication

Secure API access using OAuth 2.0 (Google provider). You can use the following token for authentication:

    ```text
    ya29.a0AXooCgv1HNus__uoHr8IyeJwCTmv8IhNCF46eaIm_Wek9hI9hNCamhtgvI4CgVMhv-z2NFXt7jI6wg-vHjG0BLSLv5OTC1j-sIldI2DshwsuM2TUiLUMiEO1S7o7BR07fXYTkoe1gRaPqlR5p9_aX0N8ucR0ovoC61lK8gaCgYKAWwSARASFQHGX2MiilkPQRjXfY9egdZQxBGqBw0173
    ```

If you faced with issues with invalid tokens or need a new one, please contact me via Slack. I'll provide you with a valid token for access.

### License

This project is licensed under the MIT License - see the LICENSE file for details.

