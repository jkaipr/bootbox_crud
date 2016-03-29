# Use this setup block to configure all options available in SimpleForm.

def html5_placeholder(wrapper)
  wrapper.use :html5
  wrapper.use :placeholder
end

def html5_readonly_label(input)
  input.use :html5
  input.optional :readonly
  input.use :label, class: 'col-sm-5 control-label'
end

def input(input)
  input.wrapper tag: 'div', class: 'input-group col-sm-12' do |append|
    append.use :input, class: 'form-control'
  end
  input.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  input.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
end

def form_optional(form)
  form.optional :maxlength
  form.optional :pattern
  form.optional :min_max
  form.optional :readonly
end

def form_input_error_hint(form)
  form.use :input, class: 'form-control'
  form.use :error, wrap_with: { tag: 'span', class: 'help-block' }
  form.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
end

SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-success'
  config.boolean_label_class = nil

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    form_optional b

    b.use :label, class: 'control-label'

    form_input_error_hint b
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'control-label'

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label'
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-5 control-label'

    b.wrapper tag: 'div', class: 'col-sm-6' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-5 control-label'

    b.wrapper tag: 'div', class: 'col-sm-7' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_readonly_label b

    b.wrapper tag: 'div', class: 'col-sm-7' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_readonly_label b

    b.wrapper tag: 'div', class: 'col-sm-7' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    form_optional b

    b.use :label, class: 'sr-only'

    form_input_error_hint b
  end

  config.wrappers :vertical_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div' do |ba|
      input ba
    end
  end

  config.wrappers :horizontal_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    html5_placeholder b
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      input ba
    end
  end

  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :vertical_boolean,
  }
end
