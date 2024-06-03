[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/6w2f2gy8py8ito6Bi3D6PP/LrohxxxeKADARTqH9sNeLC/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/6w2f2gy8py8ito6Bi3D6PP/LrohxxxeKADARTqH9sNeLC/tree/main)

# MedHub

BetterDoc Code Challenge

## What's the challenge? (informal specs)

For now MedHub will be an internal tool and does not require any authentication as the users will need a VPN and some secrets to access it.
MedHub will allow people working at BetterDoc to create, edit & delete medics and workplaces.
Medics have the following attributes:

    Name (text)
    Title (text)
    Gender (text)
    Specialty (e.g. General, Surgeon, etc. - text)


Workplaces also have:

    Name (text)
    Address (text)


In the future we can add more things for sure, but this is only the first iteration!

Of course, as you can imagine, medics belong to a workplace. So, when creating a medic, it is mandatory to add it to a workplace.
But workplaces without medics are expected.

And you don’t know why, but a random requirement came from the stakeholders: workplaces can’t have more than 50 medics.

So now that we know how medics & workplaces look like, we should be able to manage them.

Now the last thing to do is display them.
These are the pages we need:

  * A list of medics where we should see: their main info, the name of their workplace and a button that deletes the medic.
    * For some specific cases it is important that we can filter by gender
    * To help our researchers we need also to filter by specialty
  * A workplace view where we can see its information and all the medics related to it. Also add button to delete the workplace. 
  * A form to create/edit medics
  * A form to create/edit workplaces


Mentioning again that this will be a first iteration, so don’t think too much in “advanced” features like pagination or a super smart search bar.

Also, as we may introduce some more reactive parts in MedHub in the future, we thought that LiveView is the right candidate to implement all these pages. (We are Elixir enthusiasts!)
Thinking in the future is also a good practice.

## Development

## Data Model

See [dev_docs/data_model.md](/dev_docs/data_model.md)

## Pages specs

* `/medics` medics index incl. workplace info + delete button
* `/medics/new` medic form
* `/medics/:id/[action]` medic show/edit

* `/workplaces` workplaces index
* `/workplaces/new` workplace form
* `/workplaces/:id/[action]` workplace show/edit + list of medics at the workplace

## Limit Number of Medics per Workplace

The only 100% relyable way to enforce the 50 medics/workplace limit is to introduce a database trigger, but has the downside of limitted visibility in the code (needs very clear comments/documentation).

To make tracking the current number of medics/workplace easier, we add a `medics_count` field to `workplaces`. We can check this number in the changeset to avoid unnecessary database hits.

 ## New Features (WIP or upcoming)

 This is just an example of what could be improved, and how I might keep future improvements/feature ideas organized in the repository.
 
 * [Specialty normalization](/dev_docs/new_features/specialty_normalization.md)

## Phoenix

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
