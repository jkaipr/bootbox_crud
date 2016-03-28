module BootboxCrud
  module ActionView
    module Helpers
      def show_value(label, value)
        render :partial => 'layouts/show_value', :locals => { :label => label, :value => value }
      end

      def show_link_to(label, object, link_text)
        render :partial => 'layouts/show_link_to', :locals => { :label => label, :link_to_text => link_text, :link_to_object => object }
      end

      def show_link_to_array(label, objects, name_object_field)
        render :partial => 'layouts/show_link_to_array', :locals => { :label => label, :objects => objects, :field => name_object_field }
      end

      def bb_alert
        render :partial => 'layouts/bb_alert'
      end

      def form_options
        { html: { class: 'form-horizontal' }, 
          wrapper: :horizontal_form, 
          wrapper_mappings: {
          	check_boxes: :horizontal_radio_and_checkboxes, 
          	radio_buttons: :horizontal_radio_and_checkboxes, 
          	file: :horizontal_file_input, 
          	boolean: :horizontal_boolean
          }
        }
      end

      def remote_form_options
        { remote: true, authenticity_token: true }.merge(form_options)
      end
    end
  end
end
