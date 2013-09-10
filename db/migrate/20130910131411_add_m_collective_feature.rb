class AddMCollectiveFeature < ActiveRecord::Migration
  class Feature < ActiveRecord::Base; end

  def up
    Feature.create(:name => "MCollective")
  end

  def down
    Feature.delete(:name => "MCollective")
  end
end
