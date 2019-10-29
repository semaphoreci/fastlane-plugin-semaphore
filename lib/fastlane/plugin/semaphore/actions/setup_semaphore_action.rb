require 'fastlane/action'
require_relative '../helper/semaphore_helper'

module Fastlane
  module Actions
    class SetupSemaphoreAction < Action
      def self.run(params)
        unless Helper.ci? || params[:force]
          UI.message("Not running on CI, skipping `#{action_name}`.")
          return
        end
        set_temp_keychain
        set_readonly_mode
        set_output_paths
      end

      def self.set_temp_keychain
        unless ENV["MATCH_KEYCHAIN_NAME"].nil?
          UI.message("Skipping Keychain setup as a keychain was already specified")
          return
        end
        keychain_name = default_keychain_name
        ENV["MATCH_KEYCHAIN_NAME"] = keychain_name
        ENV["MATCH_KEYCHAIN_PASSWORD"] = ""

        UI.message("Creating temporary keychain: \"#{keychain_name}\".")
        Actions::CreateKeychainAction.run(
          name: keychain_name,
          default_keychain: true,
          unlock: true,
          timeout: false,
          lock_when_sleeps: true,
          add_to_search_list: true,
          password: ""
        )
      end

      def self.set_readonly_mode
        UI.message("Enabling match readonly mode.")
        ENV["MATCH_READONLY"] = true.to_s
      end

      def self.set_output_paths
        unless ENV["FL_OUTPUT_DIR"]
          UI.message("Skipping Log Path setup as FL_OUTPUT_DIR is unset")
          return
        end

        root = Pathname.new(ENV["FL_OUTPUT_DIR"])
        ENV["SCAN_OUTPUT_DIRECTORY"] = (root + "scan").to_s
        ENV["GYM_OUTPUT_DIRECTORY"] = (root + "gym").to_s
        ENV["FL_BUILDLOG_PATH"] = (root + "buildlogs").to_s
        ENV["SCAN_INCLUDE_SIMULATOR_LOGS"] = true.to_s
        
        UI.message("Log paths set up to #{ENV["FL_OUTPUT_DIR"]}")
        UI.message("\tscan logs: #{ENV["SCAN_OUTPUT_DIRECTORY"]}")
        UI.message("\tgym logs: #{ENV["GYM_OUTPUT_DIRECTORY"]}")
        UI.message("\tbuild logs: #{ENV["FL_BUILDLOG_PATH"]}")
      end 

      def self.description
        "Semaphore CI integration"
      end

      def self.authors
        ["Dmitry Bespalov"]
      end

      def self.action_name
        "setup_semaphore"
      end

      def self.default_keychain_name
        "semaphore_temporary_keychain"
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin provides actions for setiing up Semaphore CI environment"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :force,
                                  env_name: "SEMAPHORE_CI_FORCE",
                               description: "Force setup, even if not executed by Semaphore CI",
                                  optional: true,
                             default_value: false,
                                      type: Boolean)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
