# Rails Starter Template

## Simple rails app generation

Usage: 

```sh
rails new app_name -T -B -m https://raw.githubusercontent.com/surreymagpie/rails_starter_template/master/app_template
```

### Flags:

* -T:           prevents using Rails's default TestUnit; I prefer to use rSpec
* -B:           skip bundle
* --skip-keeps: avoid committing empty directories 

### Post-generation of the default app this template will

* Create a Markdown README instead of Rdoc
* Put preferred gems into the Gemfile and install
* Initialise a git repo of the same name
* Generate Guard and rspec configuration
* Set up gems such as bootstrap, kaminari, simpleform, devise or cancancan as needed
