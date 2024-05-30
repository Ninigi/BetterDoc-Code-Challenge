# Specialty normalization

## Medic (medics)

* `specialty_id` [foreign key]
* move `specialty` to `speacialties.name` and delete field (via executable script or postgresql query)

## Specialty (specialties)

* `name` [string]

## TODOs

1. on typing in `specialty` form field, search database for specialty with the current sub string
2. display existing specialties in dropdown, or:
3. display "Create New Specialty" button 