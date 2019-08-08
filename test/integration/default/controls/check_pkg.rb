describe command('ember') do
  it { should exist }
end

describe command('ember -v') do
  its('stdout') { should include '3.11.0' }
end

describe command('node') do
  it { should exist }
end

describe command('node -v') do
  its('stdout') { should include '12.7.0' }
end
