title 'Tests to confirm pcre binary works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "pcre")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-pcre' do
  impact 1.0
  title 'Ensure pcre binary is working as expected'
  desc '
  We first check that the pcre binary we expect is present and then run version checks on both to verify that it is excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty}
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  pcretest_exists = command("ls -al #{File.join(target_dir, "pcretest")}")
  describe pcretest_exists do
    its('stdout') { should match /pcretest/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  pcretest_works = command("/bin/pcretest -C")
  describe pcretest_works do
    its('stdout') { should match /PCRE version [0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end
 
  pcregrep_exists = command("ls -al #{File.join(target_dir, "pcregrep")}")
  describe pcregrep_exists do
    its('stdout') { should match /pcregrep/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  pcregrep_works = command("/bin/pcregrep -V")
  describe pcregrep_works do
    its('stdout') { should match /pcregrep version [0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  pcre_config_exists = command("ls -al #{File.join(target_dir, "pcre-config")}")
  describe pcre_config_exists do
    its('stdout') { should match /pcre-config/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  pcre_config_works = command("/bin/pcre-config --version")
  describe pcre_config_works do
    its('stdout') { should match /[0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

end
