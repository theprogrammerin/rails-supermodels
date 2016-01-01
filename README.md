# Rails Super Models 
#### rails-supermodels

##### What is a super model?
These are base abstract active recrod models which can be inherited by any regular model, to add super functionality.

##### Available Super Models

**Settings** 

- This can be used to store key, value pair in database. 
- This model uses rails caching layer to ensure that you don't have to worry about the db hits, and performance. 
- This includes a generator, which will generate the active record model and required migration. `rails generate settings_schema <module path name>` 

##### Upcoming Super Models

**Invoice** 


<hr/>
I will be moving this to a gem very soon so that installation and setting up becomes more convineint. 
