[![Build Status](https://travis-ci.org/jkaipr/bootbox_crud.png)](https://travis-ci.org/jkaipr/bootbox_crud)
# Bootbox modal CRUD

Provides Rails modal CRUD scaffolding powered by bootstrap & bootbox & simple_form. Built for use with Turbolinks, jQuery and Twitter Bootstrap 3.

![Screenshots](/screenshots/bbcrud.gif?raw=true "Scaffold example screenshots")

This is what you get after running ```rails g model Block name width:integer height:integer depth:integer``` with this gem setup in your rails application.

All modal views are using AJAX and template partials, which makes it behave faster compared to full page reloads.

Makes it easy to open up a modal for selected action and model on click by [setting](#user-content-links-to-modals) data attributes to HTML tags, no additional javascript needed. 

## Initial setup

Set custom scaffolding generators in your ```config/application.rb```

    config.generators do |g|
      g.template_engine :haml_modal_crud
      g.resource_route  :modal_crud_route
    end

Require the main javascript file in your ```app/assets/javascripts/application.js```

    //= require bootbox_crud_main

Require the main stylesheet file in your ```app/assets/stylesheets/application.css``` and also don't forget to add the main Bootstrap stylesheet

    *= require bootstrap
    *= require bootbox_crud_main

Add bootbox alert markup into the main container of your ```app/views/layouts/application.html.haml```

    %body
      .container
        = yield
        = bb_alert

Run the install generator to copy over default simple_form initializers and models.js for defining modal CRUD enabled models

    $ bundle exec rails g bootbox_crud:install

## Scaffolding

Custom model scaffolding is enabled by installing and configuring this gem. The generated files are following the rules described in the Modal CRUD section.

     $ bundle exec rails g scaffold Block name width:integer height:integer depth:integer

The above code will give you a ready to use, nicely formatted modal enabled Block CRUD. Just migrate the DB.

# Modal CRUD with  [bootbox.js](https://github.com/rocsci/bootbox-rails)

This concept is a work in progress and suggestions are welcome.

Main source files are in the gem:

    vendor/assets/javascripts/bootbox_crud_modals.js
    app/views/modals/_form.js
    app/views/modals/_alert.js
    app/views/modals/_create.js
    app/views/modals/_destroy.js
    app/views/modals/_update.js

and in your application

    app/assets/javascripts/models.js

## Controller

### Create, update and destroy

All of these methods must have a js response format defined in the respond_to block. Update example: 

    respond_to do |format|
      if @model.update(model_params)
          ...
          format.js
        else
          ...
          format.js
        end
      end
    end

### New, edit and show

If you want your modals to be fast, related actions shouldn't render with a full layout. Instead return only the form or detail template.
In another words, use ``` render layout: false ```.

    def new
      @model = Model.new

      respond_to do |format|
        format.html { render layout: false }
        format.json { render json: @model }
      end
    end

    def edit
      render layout: false
    end

#### Different show view template for modal and normal page

In cases where a separate view template is needed for modal and normal full page show action, you can achieve that by doing the following.
The modal show request accepted content type is \*/\* so it is going to take the .js format response option as acceptable, because it is the first in the list.
A standard request will skip format.js and take the html option.

    def show
      respond_to do |format|
        format.js { render 'show_modal', layout: false }
        format.html
      end
    end

This method can also be used for differentiating edit and new actions for modal and normal views.

## Views

### Create, update and destroy

Three new files have to be added to the views directory of the related model:

**create.js.erb**

    <%= render partial: 'modals/create', locals: { model: @model, form_path: 'model/form' } %>

**update.js.erb**

    <%= render partial: 'modals/update', locals: { model: @model, form_path: 'model/form' } %>

**destroy.js.erb**

    <%= render partial: 'modals/destroy', locals: { model: @model, form_path: 'model/form' } %>


The partials in app/views/modals directory should provide the necessary functionality for most cases. If you need some special behaviour, implement it instead of rendering the partial.

**Create/Destroy visit_path** [optional parameter]: determines what page to load after the model has been created/destroyed.

The path is visited by invoking Turbolinks.visit(visit_path). If it isn't set, the current page will be reloaded.

It is mostly useful in cases:

 * when you create a new model and want to redirect to its full page detail or when you create a new subpage/tab and you want to refresh the page with an anchor after the base URL (the example is used for overviews)


     <%= render partial: 'modals/create', locals: { model: @overview, form_path: 'overviews/form', visit_path: "#overview_#{@overview.id}" } %>

 * where you can delete a model from its full page detail and you need to redirect the user to some list view, a simple page reload wouldn't be useful because the model was destroyed and its detail can't be shown anymore


     <%= render partial: 'modals/destroy', locals: { visit_path: "/#{ location_name.to_s }/unipolars" } %>

### New, edit and show

All views being shown inside a modal window must have a root node with ```id='content'```.
Example in haml:

    #content
      = render 'form'

The javascript handling the response will fill this node and its contents into the modal window body.

#### Forms

Forms used inside of modal windows need to have the remote attribute set to true.

    = simple_form @model, remote: true

This way they are submitted via an ajax request.

The ```ApplicationHelper#remote_form_options``` helper with default simple\_form formatting and layout wrapping options should be used instead of only writing ```remote: true``` to keep all forms unified.
But more on that in the main forms section of this readme.

#### Show helpers

Use these in case you want to show values of a model in a modal window.

    show_value(label, value)
    show_link_to(label, object, link_text)
    show_link_to_array(label, objects, name_object_field)

    show_value 'Name', @model.name
    show_link_to 'Model', @model, @model.name
    show_link_to_array 'Model blackboxes', @model.blackboxes, 'name'

Wrap them into a div with ```class='form-horizontal'```. Bootstrap horizontal form layout with little customization is used to display the values.

Adding ```class='show'``` to root node with ```id='content'``` is mandatory to get the right styling. If you forget this one, it will look like input fields.

    #content.show
      .form-horizontal
        = show_value 'Name', @model.name
        = show_value 'Status', @model.status

### Links to modals

Making links modal enabled is done via data attributes.

    data-entity='Model'
    data-action='edit'
    data-id='1'

In haml:

    = link_to '#', :class => 'btn btn-primary btn-sm', data: { id: @model.id, entity: 'Model', action: 'edit' } do
      %i.fa.fa-edit
      edit

There is a global button handler searching for any DOM nodes with 'data-entity' attribute. Click events of such nodes lead to modals.
The logic is simple, clicking on a node with the above values will lead to this function invocation:

    BBCrud.Model.edit({id: 1})

Available actions are:

 * new
 * edit
 * show

#### Adding a new model to modals on the client side

The above mentioned functions are defined in **models.js**, if you want to add modals to a new model, you have to add a new line there.

    BBCrud.Models.add(namespace, baseUrl, modalHeaderTitle);

 * **namespace** is used to define the BBCrud.Unipolar object
 * **baseUrl** is setting the base route for the models actions
 * **modalHeaderTitle** is used in modal titles, it should be a singular downcase name of the model

Filled in for unipolars:

    BBCrud.Models.add('Unipolar', '/unipolars/', 'unipolar');

The above function invocation creates these functions:

    BBCrud.Models.Unipolar.new
    BBCrud.Models.Unipolar.edit
    BBCrud.Models.Unipolar.show

Now you should be all set to click your data-entity links and call the functions from your scripts if needed.

 *Note*: I18n is currently not supported on the client, there are a few ways how to approach it. The necessary changes should be simple.

#### Adding custom actions to models (non CRUD)

Is done in ```models.js``` by adding a line similar to the for defining CRUD actions. Here is an example for close event action:

    BBCrud.Models.addAction('Event', '/events/', 'event', 'close');

The first three arguments are the same as for ```BBCrud.Models.add``` function, the last argument is the new action name.
After adding this line, you can create a button with the following data attributes and your modal is almost ready.

    data-entity='Event'
    data-action='close'
    data-id='1'

Of course you have to do all the little tweaks on this action, as you did for CRUD. Meaning, adding ```#content``` to the form view and rendering it without layout. Next adding ```format.js``` to the relevant controller action and creating a ```*.js.erb``` view template for it.

To finish our ```Event.close``` example, the file will be named ```events/close_event.js.erb``` and it's contents:

    <%= render partial: 'modals/form', locals: { model: @event, form_path: 'events/close', success_alert: 'Closed' , error_alert: 'Error while closing' } %>

The important detail to notice is the use of ```modals/form``` partial, which was made to handle custom actions. The rest of the arguments are self-explanatory.

## Modals in short

 * Create format.js lines in respond_to block of controller :create, :update, :destroy
 * Return views without layout in controller :new, :show, :edit
 * Make sure your views have a root ```id='content'``` node & with ```class='show'``` in case of a show view using show helpers from this guide
 * Make sure your form has ```remote: true``` or preferably ```remote_form_options``` with simple\_form, the layout should be the same as in the example in form section of this README
 * Add create, update and destroy .js.erb files to the view directory and fill them according to this guide
 * Add your model definition as a new line to models.js
 * Add ```data-entity```, ```data-action``` and ```data-id``` with the right values to an element on the page and click it, or call ``BBCrud.Models.ModelName.new/edit/show()`` from your javascript to show the modal


## Custom scaffold source files

If you want have a peek or override some of the scaffolding templates, here is an overview of the files used:

**haml\_modal\_crud**

    lib/generators/rails/haml_modal_crud/templates/create.js.erb
    lib/generators/rails/haml_modal_crud/templates/destroy.js.erb
    lib/generators/rails/haml_modal_crud/templates/update.js.erb
    lib/generators/rails/haml_modal_crud/haml_modal_crud_generator.rb
    lib/generators/rails/haml_modal_crud/USAGE

**modal\_crud\_route**

    lib/generators/rails/modal_crud_route/modal_crud_route_generator.rb

**haml scaffold templates override**

    lib/templates/haml/scaffold/_form.html.haml
    lib/templates/haml/scaffold/edit.html.haml
    lib/templates/haml/scaffold/index.html.haml
    lib/templates/haml/scaffold/new.html.haml
    lib/templates/haml/scaffold/show.html.haml

**controller scaffold template override**

    lib/templates/rails/scaffold_controller/controller.rb

# Changelog
 **0.2.0** - some breaking changes
 
  * defined model actions moved to BBCrud.Models.<ModelName>, declaring them directly on  BBCrud.<ModelName> was dangerous, new models could overwrite basic functionality [Models, Modals, Alert] 
  * renamed actions on models to new, edit, show [previously was create, update, show]
  * added a few more jasmine specs

# TODOs

 * I18n support on client side
 * Improve BBCrud.Alert / integration with Rails flash messages
