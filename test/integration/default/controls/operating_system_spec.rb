
describe command('lsb_release -c') do
  its('stdout') { should include 'bionic' }
end

describe os.family do
  it { should eq 'debian' }
end

describe os.release do
  it { should eq '18.04' }
end