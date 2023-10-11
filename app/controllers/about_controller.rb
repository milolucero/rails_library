require "json"
class AboutController < ApplicationController
  def index
    json_data = File.read(Rails.root.join("db/dataset_description.json"))
    @data = JSON.parse(json_data)
  end
end
