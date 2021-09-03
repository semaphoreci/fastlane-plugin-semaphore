describe Fastlane::Actions::SetupSemaphoreAction do

  def run_action(params)
    Fastlane::Actions::SetupSemaphoreAction.run(params)
  end

  def expect_not_in_ci_message
    expect_message("Not running on CI, skipping `#{described_class.action_name}`.")
  end

  def expect_message(msg)
    expect(Fastlane::UI).to receive(:message).with(msg)
  end

  def expect_not_in_mac_message
    expect_message("Skipping Keychain setup on non-macOS CI Agent")
  end

  describe '#run' do
    it 'skips when not in CI and not forced' do
      expect_not_in_ci_message
      expect(Fastlane::Helper).to receive(:ci?).and_return(false)
      run_action({force: false})
    end
  end

  describe '#mac' do
    it 'Run on mac Node' do
      expect_message("Creating temporary keychain: \"semaphore_temporary_keychain\".")
      expect(Fastlane::Helper).to receive(:mac?).and_return(true)
      described_class.set_temp_keychain
    end

    it 'Fails on non-mac Node' do
      expect_not_in_mac_message
      expect(Fastlane::Helper).to receive(:mac?).and_return(false)
      described_class.set_temp_keychain
    end
  end

  describe '#set_temp_keychain' do
    
    it 'prints message when already set' do
      stub_const("ENV", { "MATCH_KEYCHAIN_NAME" => "some" })
      expect_message("Skipping Keychain setup as a keychain was already specified")
      described_class.set_temp_keychain
    end

    it 'sets environment variables' do
      described_class.set_temp_keychain
      expect(ENV["MATCH_KEYCHAIN_NAME"]).to eql(described_class.default_keychain_name)
      expect(ENV["MATCH_KEYCHAIN_PASSWORD"]).to eql("")
    end

    it 'creates keychain' do
      expect(Fastlane::Actions::CreateKeychainAction).to receive(:run).with({
        name: described_class.default_keychain_name,
        default_keychain: true,
        unlock: true,
        timeout: 0,
        lock_when_sleeps: true,
        add_to_search_list: true,
        password: ""
      })
      stub_const("ENV", {})
      described_class.set_temp_keychain
    end
  
  end

  describe '#set_readonly_mode' do
    it 'sets environment variable' do 
      described_class.set_readonly_mode
      expect(ENV["MATCH_READONLY"]).to eql("true")
    end
  end

  describe '#set_output_paths' do
    
    it 'skips when environment not set' do
      stub_const("ENV", {})
      expect_message("Skipping Log Path setup as FL_OUTPUT_DIR is unset")
      described_class.set_output_paths
    end

    it 'sets environment variables' do
      stub_const("ENV", { "FL_OUTPUT_DIR" => "/dev/null" })
      described_class.set_output_paths
      expect(ENV["SCAN_OUTPUT_DIRECTORY"]).to eql("/dev/null/scan")
      expect(ENV["GYM_OUTPUT_DIRECTORY"]).to eql("/dev/null/gym")
      expect(ENV["FL_BUILDLOG_PATH"]).to eql("/dev/null/buildlogs")
      expect(ENV["SCAN_INCLUDE_SIMULATOR_LOGS"]).to eql("true")
    end
  end

end
