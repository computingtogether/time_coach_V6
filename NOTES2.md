For how to set up RSpec check out the beginning of [this post](https://computingtogether.org/thought-stream-rails-app-tutorial-part-2)
 up to calling: 
 
 ```
 $ rails generate rspec:install

```

Now you should have a spec directory with lots of sub directories in it. 

Let'a add the simplecov gem to our gemfile to give us feedback on our coverage.

```rb
gem 'simplecov', require: false, group: :test
```

Load and launch SimpleCov at the very top of your spec_helper.rb 
```
require 'simplecov'
SimpleCov.start
# Previous content of test helper now starts here
```