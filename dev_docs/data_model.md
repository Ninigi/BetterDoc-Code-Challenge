# Data Model

Context: Practices

Format: [Schema Name] ([Table Name])

Explanations for changes made from informal specs are below the table of fields for each schema where necessary.

All tables have the following default fields and are therefore omitted:

* id [primary key]
* inserted_at [datetime]
* updated_at [datetime]

## Medic (medics)

* `name` [string]
* `title` [string]
* `gender` [enum] (male, female, non_binary, other)
* `workplace_id` [foreign key]
* `specialty` [string]

`name` could be split into first-, middle-, and last name, but one field is better for searchability and simpler to implement.
`title` could maybe be an enum, or its own table, but there might be cases with some combinations like "Prof. Dr. Dr." that would make that model unnecessarily complicated.
`specialty` is a string for now, but will be moved into a separate table in a feature PR. Having this in its own table will help to avoid typos/different ways to write the same thing (making searching for specialties very difficult). We can implement a search-autocomplete for the form field and retain a minimum uniformity.

## Workplace (workplaces)

* `name` [string]
* `street_name` [string]
* `street_number` [string]
* `zip` [string]
* `city` [string]

Instead of using an `address` text field, the address is broken up into individual fields. A single `address` field would be difficult to normalize once there is production data, and breaking the address up like this provides the option to add searches like "search by zip code/city" in the future.