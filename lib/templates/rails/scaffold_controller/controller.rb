<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= attributes_names.select { |attr| attr == 'name' }.present? ? "#{class_name}.order('lower(name)').all" : orm_class.all(class_name) %>
    respond_to do |format|
      format.html
      format.json { render json: @<%= plural_table_name %> }
    end
  end

  # GET <%= route_url %>/1
  def show
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    render layout: false
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %> }
        format.json { render json: @<%= singular_table_name %>, status: :created }
        format.js
      else
        format.html { render :new }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html { redirect_to @<%= singular_table_name %> }
        format.json { head :no_content }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    respond_to do |format|
      if @<%= orm_instance.destroy %>    
        format.html { redirect_to <%= index_helper %>_url }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to <%= index_helper %>_url }
        format.json { render json: @<%= singular_table_name %>.errors, status: :forbidden }
        format.js { render status: :forbidden }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
    <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
    <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
    end
end
<% end -%>
