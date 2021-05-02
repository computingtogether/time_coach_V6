```
$ rails new time_coach -T
```

First I will sketch up a database diagram on draw.io. It makes sense to generate the least dependent model first which is the User. But we can just call a migration later to add references to the user, let's make the Routine model first. 
```
$ rails g scaffold routine
$ rails g scaffold activity
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

```html
  <body>
      <p class="notice"><%= notice %></p>
      <p class="alert"><%= alert %></p>

    <%= yield %>
  </body>
</html>
```

While we're at it let's get the notices and alerts to disappear after 2 seconds.
app/javascript/packs/application.js
```js
$(document).on('turbolinks:load', function() {
  setTimeout(function() {
    $('.alert').fadeOut();
  }, 2000);
})
```

4) 
```
$ rails g devise:views
```
Generate a devise user 

```
$ rails g devise user
```


In the CreateRoutines migration

```ruby
class CreateRoutines < ActiveRecord::Migration[6.1]
  def change
    create_table :routines do |t|
      t.references :user, :foreign_key => true
      t.string :routine_type
      t.timestamps
    end
  end
end
```

In the CreateActivities migration

```ruby
class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.references :routine, :foreign_key => true
      t.string :activity_title
      t.string :description
      t.integer :duration
      t.timestamps
    end
  end
end
```

```
rails db:migrate
```


Set the associations.
In app/models/routine.rb
```ruby
class Routine < ApplicationRecord
  validates :routine_type, presence: true, uniqueness: true
  has_many :activities, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :activities, allow_destroy: true
end
```

app/models/user.rb
```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :routines, dependent: :destroy
end
```

app/models/activity.rb
```ruby
class Activity < ApplicationRecord
  validates :activity_title, :presence => true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  belongs_to :routine
end
```


When a routine is created, we need to keep track of the current user's id along with the routine name. Let's also take care of the javascript for adding new activity fields.

In app/views/routines/_form.html.erb

```html
<% if user_signed_in? %>
      <div class="field">
        <%= form.text_field :routine_type, class: 'text-field_routine-name', placeholder: 'Routine Name' %>
      <br />
      <div class="field">
        <%= form.fields_for :activities do |f| %>
          <%= render 'activity_fields', f: f%>
        <% end %>
         <%= link_to_add_fields "Add Another Activiy", form, :activities%>
      <br />
      <br />
      </div>

      <br />
        <%= form.number_field :user_id, id: :routine_user_id, value: current_user.id, type: :hidden %>
      </div>

      <br />

      <div class="actions">
        <%= form.submit %>
      </div>
    <% end %>
<% end %>


<script>
  $('form').on('click', '.add_fields', function(event){
    var regexp, time;
    time = new Date().getTime();
    regexp  = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });
</script>
```

Now the activity fields partial.

```html
<div class="activity-fields-container">
  <%= f.text_field :activity_title, placeholder: 'Activity Title', class: 'activity-field-title' %>
  <%= f.text_field :description, placeholder: 'Description', class: 'activity-field-description' %>
  <%= f.text_field :duration, placeholder: 'Duration In Minutes', class: 'activity-field-duration' %>
</div>

```

app/helpers/application_helper.rb
```ruby
module ApplicationHelper

  def link_to_add_fields(name, f, association)
    ## create new object from an association (:product_variants)
    new_object = f.object.send(association).klass.new

    ## create or take the id from the created object
    id = new_object.object_id

    ## create the fields form
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    ## pass down the link to the fields form
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub("\n", "")})
  end
end
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

```html
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

```html
  <body>
  
    <%= render 'routines/nav' %>
    
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    <%= yield %>
  </body>
```


In app/controllers/routines_controller.rb, update the new method to build the activity. Also add the activities attributes and user_id to routine_params

app/controllers/routines_controller.rb
```ruby
  def show
    @routine = Routine.find(params[:id])
  end

  def new
    @routine = Routine.new
    @routine.activities.build
  end
  
  def routine_params
      params
        .require(:routine)
        .permit(:routine_type, :user_id, activities_attributes: [:id, :activity_title, :description, :duration, :_destroy])
  end
```

In app/controllers/activities_controller.rb add the routine_id to activity_params

app/controllers/activities_controller.rb
```ruby
    def activity_params
      params
      .require(:activity)
      .permit(:activity, :activity_title, :duration, :routine_id)
    end
```

Let's build out the routines show page. On the next post for this series I will embed the animation on the show page, so that the user can click the routine and run it. 

app/views/routines/show.html.erb
```html
<h1><%= @routine.routine_type %></h1>
<table>
  <tr>
      <% @routine.activities.each do |activity| %>
      <tr>
        <td>
        <%= activity.activity_title %>
        </td>
        <td>
        <%= activity.description %>
        </td>
        <td>
        <%= activity.duration %> minutes
        </td>
      </tr>
      <% end %>
  </tr>
</table>


<%= link_to 'Edit', edit_routine_path(@routine) %> |
<%= link_to 'Back', routines_path %>
```

Finally here is my styling.

app/assets/stylesheets/application.scss
```css
 :root {
  --green: rgb(0, 119, 0);
  --red: rgb(140,0,0);
}

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
   margin-top: 10px;
   margin-bottom: 10px;
 }

 .activity-field-title{
  width: 20%;
  margin-top: 10px;
  margin-right: 10px;
 }

 .activity-field-description{
   width: 60%;
   margin-top: 5px;
   margin-right: 10px;
  }
  
  .activity-field-duration{
    width: 10%;
    margin-top: 10px;
  }

  .activity-fields-container{
   display:block;
 }

 .notice{
   color: green;
 }

 .alert{
  color: green;
}

```


The final product looks like this.

