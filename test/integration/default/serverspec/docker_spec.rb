#require 'spec_helper'
require 'serverspec'

set :backend, :exec

describe package('docker.io') do
  it { should be_installed }
end

describe service('docker.service') do
  it { should be_enabled   }
  it { should be_running   }
end

#describe port(80) do
#  it { should be_listening }
#end

