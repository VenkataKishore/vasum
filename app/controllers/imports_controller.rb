class ImportsController < ApplicationController

  def show
  end

  def create
    @importer_type = params[:type]
    @importer = Import::UsersImport.new(params[:file], params[:type])
    @importer.process
    render action: 'show'
  end

end
