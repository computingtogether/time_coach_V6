```
$ rails new time_coach -T
```

First I will sketch up a database diagram on draw.io. It makes sense to generate the least dependent model first which is the User. But we can just call a migration later to add references to the user, let's make the Routine model first. 
```
$ rails g scaffold routine routine_name:string 
$ rails g scaffold activity activity_name:string time_range:integer routine:references
$ rails db:migrate
```

I will be using these in my Gemfile for now.
```ruby
gem 'rexml', '~> 3.2', '>= 3.2.4'
gem 'timecop', '~> 0.9.4'  
gem 'rails-controller-testing'
gem 'devise'
gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'pry', '~> 0.13.1'
  gem 'pry-byebug', '~> 3.9'
end
```

## How to add jquery for rails 6:

Add jquery gem to gemfile
```
gem 'jquery-rails'
```

```
$ yarn add jquery
```

Add in config/webpack/environment.js
```js
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
```

Require jquery in application.js file.
```js
require('jquery')
```
## Setting Up Devise to be able to have users that can sign up / in / out / edit profile.
```
$ bundle install

$ rails g devise:install

```

1) In **config/environments/development.rb** add 

```ruby
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
2)  Set the home route in **config/routes.rb**

```ruby
  root 'routines#index'
```

3) Ensure you have flash messages. 

In app/views/layouts/application.html.erb  at the top of the body

```erb
  <body>
      <p class="notice"><%= notice %></p>
      <p class="alert"><%= alert %></p>

    <%= yield %>
  </body>
</html>
```

4) 
```
$ rails g devise:views
```
Generate a devise user 

```
$ rails g devise user
```


## Coding the App

Set the associations.
In app/models/routine.rb
```ruby
class Routine < ApplicationRecord
  validates :routine_name, presence: true, uniqueness: true
  belongs_to: user
  has_many: activities
  accepts_nested_attributes_for :activities
end
```

app/models/user.rb
```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :routines
end
```

app/models/activity.rb
```ruby
class Activity < ApplicationRecord
  validates :activity_name, presence: true
  validates :time_range, presence: true, numericality: { only_integer: true, greater_than: 0 }
  belongs_to :routine
end
```

Looking at the database diagram, we want the Routine model to have a foriegn key for user_id.
```
$ rails g migration add_user_id_to_routines user_id:integer:index
$ rails db:migrate
```

When a routine is created, we need to keep track of the current user's id along with the routine name. 
In app/views/routines/_form.html.erb

```erb
  <div class="field">
    <%= form.text_field :routine_name, class: 'text-field_routine-name', placeholder: 'routine' %>
  
    <%= form.number_field :user_id, id: :routine_user_id, value: current_user.id, type: :hidden %>
  </div>
```

## Adding a Nav Bar


For app/assets/stylesheets/application.css change the file type to scss.

In app/assets/stylesheets/application.scss

```scss

 ul.nav-header{
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background-color: #333;
  li {
    float: left;
  }
  
  li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
  }
  
  li a:hover {
    background-color: #111;
  }
 }

 .text-field_routine-name{
   width: 99%;
 }

 .text-field_activity-name{
   width: 48%;
 }
 
 .text-field_time-range{
  width: 48%;
}
```

Create a new file in app/views/routines for the nav bar partial called "_nav.html.erb

In app/views/routines/_nav.html.erb

```erb
<ul class="nav-header">
  <li>
    <%= link_to "Time Coach", routines_path, class:"nav-link" %>
  </li>
  <% if user_signed_in? %>
    <li>
      <%= link_to "Edit Profile", edit_user_registration_path, class:"nav-link" %>
    </li>
    <li>
      <%= link_to "Sign Out", destroy_user_session_path, method: :delete, class:"nav-link" %>
    </li>
    <li>
      <%= link_to "New Routine", new_routine_path, class:"nav-link" %>
    </li>
  <% else %>
    <li>
      <%= link_to "Sign Up", new_user_registration_path, class:"nav-link" %>
    </li>
    <li>
      <%= link_to "Sign In", new_user_session_path, class:"nav-link" %>
    </li>
  <% end %>
</ul>
``` 

In app/views/layouts/application.html.erb

```erb
  <body>
  
    <%= render 'routines/nav' %>
    
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    <%= yield %>
  </body>
```

In app/views/routines/_form.html.erb

```erb
  <div class="field">
    <%= form.text_field :routine_name, class: 'text-field_routine-name', placeholder: 'routine' %>
  
    <%= form.number_field :user_id, id: :routine_user_id, value: current_user.id, type: :hidden %>
  </div>
```





