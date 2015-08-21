module BootboxCrud
  class Railtie > ::Rails::Railtie
    initializer "bootbox_crud.configure_view" do |app|
      ActiveSupport.on_load :action_view do
        include BootboxCrud::ActionView::Helpers
      end
    end
  end
end