require 'spec_helper'

describe 'monit::mmonit' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'monit::mmonit' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
