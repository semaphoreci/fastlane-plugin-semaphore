describe Fastlane::Actions::SemaphoreAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The semaphore plugin is working!")

      Fastlane::Actions::SemaphoreAction.run(nil)
    end
  end
end
