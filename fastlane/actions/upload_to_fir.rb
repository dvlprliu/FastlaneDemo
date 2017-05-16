module Fastlane
  module Actions
    module SharedValues
      UPLOAD_TO_FIR_CUSTOM_VALUE = :UPLOAD_TO_FIR_CUSTOM_VALUE
    end

    class UploadToFirAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        home_path = Dir.home
        token = ''
        if !File.exist? "#{home_path}/.fir-cli"
          token = UI.input('Please input fir token: ')
          sh "fir login --token #{token}"
        else
          token = UploadToFirAction.fir_token
        end
        sh "fir publish #{params[:ipa_file]}"
        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::UPLOAD_TO_FIR_CUSTOM_VALUE] = "my_val"
      end

      def self.fir_token
        home = Dir.home
        token = ''
        File.open("#{home}/.fir-cli", 'r') do |f|
          f.each_line do |line|
            token = line.delete(':token:').strip if line.include? ':token:'
          end
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :ipa_file,
          env_name: "IPA_FILE_NAME",
          description: "File name",
          optional: false
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPLOAD_TO_FIR_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
