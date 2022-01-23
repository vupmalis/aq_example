# aq_example

Oracle AQ example project. Includes examples, how to create and use Oracle Advanced Queues

# Required Tools

- Oracle DB (Oracle XE)
- Gradle

# Setup

- As system user on target database execute script "aq_example\src\main\resources\db\scripts\system.create_schema.sql"
- If neccessary, change db user name password on system.create_schema.sql and correspondingly - on gradle.properties
- Run "gradle flywayMigrate"
