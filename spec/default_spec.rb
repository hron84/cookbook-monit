require 'spec_helper'

describe 'monit::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new(:step_into => ['monit_service']).converge 'monit::default' }
  
  context 'Package installation' do
    it 'should install monit package' do
      expect(chef_run).to install_package 'monit'
    end
  end

  context 'File creations' do
    %w(/etc/monit /etc/monit/conf.d /var/lib/monit).each do |dir|
      it "should create #{dir} directory" do
        expect(chef_run).to create_directory dir
      end
    end


    it 'should create /etc/monit/monitrc' do
      expect(chef_run).to create_file '/etc/monit/monitrc'
    end
    
    it 'should enable service' do
      expect(chef_run).to enable_service 'monit'
      expect(chef_run).to start_service 'monit'
    end

    %w(ubuntu debian).each do |platform|
      it "should create /etc/default/monit on #{platform}" do
        Fauxhai.mock(:platform => platform)
        expect(chef_run).to create_cookbook_file '/etc/default/monit'
      end
    end
  end
end
